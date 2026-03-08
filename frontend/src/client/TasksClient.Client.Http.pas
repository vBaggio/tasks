unit TasksClient.Client.Http;

interface

uses
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
    procedure EnsureSuccess(AStatusCode: Integer; const AResponseBody: string);
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
  System.SysUtils,
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

function TTaskApiClient.CreateRequest(const APath: string): IRequest;
begin
  Result := TRequest.New
    .BaseURL(FConfig.BaseUrl + APath)
    .BasicAuthentication(FConfig.Username, FConfig.Password)
    .Accept('application/json');
end;

procedure TTaskApiClient.EnsureSuccess(AStatusCode: Integer; const AResponseBody: string);
var
  LMessage: string;
begin
  if AStatusCode < 400 then
    Exit;

  LMessage := GetError(AResponseBody);

  case AStatusCode of
    401: raise EApiUnauthorizedException.Create(LMessage);
    404: raise EApiNotFoundException.Create(LMessage);
    422: raise EApiValidationException.Create(LMessage);
  else
    raise EApiException.Create(AStatusCode, LMessage);
  end;
end;

function TTaskApiClient.ListAll: TArray<TTaskResponseDto>;
var
  LResponse: IResponse;
begin
  LResponse := CreateRequest('/tasks').Get;
  EnsureSuccess(LResponse.StatusCode, LResponse.Content);
  Result := TNeon.JSONToValue<TArray<TTaskResponseDto>>(LResponse.Content, FNeonConfig);
end;

function TTaskApiClient.CreateTask(const ARequest: TCreateTaskRequestDto): TTaskResponseDto;
var
  LResponse: IResponse;
begin
  LResponse := CreateRequest('/tasks')
    .ContentType('application/json')
    .AddBody(TNeon.ValueToJSONString(TValue.From<TCreateTaskRequestDto>(ARequest), FNeonConfig))
    .Post;
  EnsureSuccess(LResponse.StatusCode, LResponse.Content);
  Result := TNeon.JSONToValue<TTaskResponseDto>(LResponse.Content, FNeonConfig);
end;

procedure TTaskApiClient.UpdateStatus(AId: Integer; AStatus: Integer);
var
  LResponse: IResponse;
  LRequest: TUpdateStatusRequestDto;
begin
  LRequest.Status := AStatus;
  LResponse := CreateRequest('/tasks/' + AId.ToString + '/status')
    .ContentType('application/json')
    .AddBody(TNeon.ValueToJSONString(TValue.From<TUpdateStatusRequestDto>(LRequest), FNeonConfig))
    .Patch;
  EnsureSuccess(LResponse.StatusCode, LResponse.Content);
end;

procedure TTaskApiClient.Delete(AId: Integer);
var
  LResponse: IResponse;
begin
  LResponse := CreateRequest('/tasks/' + AId.ToString).Delete;
  EnsureSuccess(LResponse.StatusCode, LResponse.Content);
end;

function TTaskApiClient.GetStats: TTaskStatsDto;
var
  LResponse: IResponse;
begin
  LResponse := CreateRequest('/tasks/stats').Get;
  EnsureSuccess(LResponse.StatusCode, LResponse.Content);
  Result := TNeon.JSONToValue<TTaskStatsDto>(LResponse.Content, FNeonConfig);
end;

end.
