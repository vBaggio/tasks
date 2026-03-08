unit TasksClient.Client.Http;

interface

uses
  System.SysUtils,
  TasksClient.Config,
  TasksClient.Client.Interfaces,
  TasksClient.Model.Dto.Task,
  TasksClient.Model.Dto.Stats,
  Neon.Core.Types,
  Neon.Core.Persistence,
  RESTRequest4D;

type
  TTaskApiClient = class(TInterfacedObject, ITaskApiClient)
  private
    FConfig: TClientConfig;
    FNeonConfig: INeonConfiguration;
    function GetError(const AResponseBody: string): string;
    procedure ValidateResponse(AStatusCode: Integer; const AResponseBody: string);
    procedure RaiseConnectionError;
    function CreateRequest(const APath: string): IRequest;
  public
    constructor Create(const AConfig: TClientConfig);
    function ListAll: TArray<TTaskResponseDto>;
    function CreateTask(const ARequest: TCreateTaskRequestDto): TTaskResponseDto;
    procedure UpdateStatus(AId: Integer; AStatus: Integer);
    procedure Delete(AId: Integer);
    function GetStats: TTaskStatsDto;
  end;

implementation

uses
  System.Rtti,
  System.JSON,
  Neon.Core.Persistence.JSON,
  TasksClient.Model.Exceptions;

{ TTaskApiClient }

constructor TTaskApiClient.Create(const AConfig: TClientConfig);
begin
  inherited Create;
  FConfig := AConfig;
  FNeonConfig := TNeonConfiguration.Create.SetMemberCase(TNeonCase.CamelCase);
end;

function TTaskApiClient.GetError(const AResponseBody: string): string;
var
  LJson: TJSONObject;
begin
  Result := AResponseBody;
  if AResponseBody = '' then
    Exit;
  LJson := TJSONObject.ParseJSONValue(AResponseBody) as TJSONObject;
  if Assigned(LJson) then
  try
    if LJson.GetValue('error') <> nil then
      Result := LJson.GetValue('error').Value;
  finally
    LJson.Free;
  end;
end;

procedure TTaskApiClient.ValidateResponse(AStatusCode: Integer; const AResponseBody: string);
var
  LMessage: string;
begin
  if AStatusCode < 400 then
    Exit;

  LMessage := GetError(AResponseBody);

  case AStatusCode of
    401:
      begin
        if Trim(LMessage) = '' then
          LMessage := 'Credenciais inválidas. Verifique usuário e senha.';
        raise EApiUnauthorizedException.Create(LMessage);
      end;
    404: raise EApiNotFoundException.Create(LMessage);
    422: raise EApiValidationException.Create(LMessage);
  else
    raise EApiException.Create(AStatusCode, LMessage);
  end;
end;

procedure TTaskApiClient.RaiseConnectionError;
begin
  raise EApiConnectionException.Create('API indisponível. Verifique se o servidor está em execução.' + #13#10);
end;

function TTaskApiClient.CreateRequest(const APath: string): IRequest;
begin
  Result := TRequest.New
    .BaseURL(FConfig.BaseUrl + APath)
    .BasicAuthentication(FConfig.Username, FConfig.Password)
    .Accept('application/json');
end;

function TTaskApiClient.ListAll: TArray<TTaskResponseDto>;
var
  LResponse: IResponse;
begin
  try
    LResponse := CreateRequest('/tasks').Get;
  except
    on E: EApiException do
      raise;

    on E: Exception do
      RaiseConnectionError;
  end;
  ValidateResponse(LResponse.StatusCode, LResponse.Content);
  if (LResponse.Content = '') or (LResponse.Content = 'null') then
    Result := []
  else
    Result := TNeon.JSONToValue<TArray<TTaskResponseDto>>(LResponse.Content, FNeonConfig);
end;

function TTaskApiClient.CreateTask(const ARequest: TCreateTaskRequestDto): TTaskResponseDto;
var
  LResponse: IResponse;
  LBody: string;
begin
  LBody := TNeon.ValueToJSONString(TValue.From<TCreateTaskRequestDto>(ARequest), FNeonConfig);
  try
    LResponse := CreateRequest('/tasks')
      .ContentType('application/json')
      .AddBody(LBody)
      .Post;
  except
    on E: EApiException do
      raise;

    on E: Exception do
      RaiseConnectionError;
  end;
  ValidateResponse(LResponse.StatusCode, LResponse.Content);
  Result := TNeon.JSONToValue<TTaskResponseDto>(LResponse.Content, FNeonConfig);
end;

procedure TTaskApiClient.UpdateStatus(AId: Integer; AStatus: Integer);
var
  LResponse: IResponse;
  LRequest: TUpdateStatusRequestDto;
  LBody: string;
begin
  LRequest.Status := AStatus;
  LBody := TNeon.ValueToJSONString(TValue.From<TUpdateStatusRequestDto>(LRequest), FNeonConfig);
  try
    LResponse := CreateRequest('/tasks/' + AId.ToString + '/status')
      .ContentType('application/json')
      .AddBody(LBody)
      .Patch;
  except
    on E: EApiException do
      raise;

    on E: Exception do
      RaiseConnectionError;
  end;
  ValidateResponse(LResponse.StatusCode, LResponse.Content);
end;

procedure TTaskApiClient.Delete(AId: Integer);
var
  LResponse: IResponse;
begin
  try
    LResponse := CreateRequest('/tasks/' + AId.ToString).Delete;
  except
    on E: EApiException do
      raise;

    on E: Exception do
      RaiseConnectionError;
  end;
  ValidateResponse(LResponse.StatusCode, LResponse.Content);
end;

function TTaskApiClient.GetStats: TTaskStatsDto;
var
  LResponse: IResponse;
begin
  try
    LResponse := CreateRequest('/tasks/stats').Get;
  except
    on E: EApiException do
      raise;

    on E: Exception do
      RaiseConnectionError;
  end;
  ValidateResponse(LResponse.StatusCode, LResponse.Content);
  if (LResponse.Content = '') or (LResponse.Content = 'null') then
    Result := Default(TTaskStatsDto)
  else
    Result := TNeon.JSONToValue<TTaskStatsDto>(LResponse.Content, FNeonConfig);
end;

end.