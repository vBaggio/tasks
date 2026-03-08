unit TasksAPI.Controller.Tasks;

interface

uses
  Horse,
  TasksAPI.Service.Interfaces,
  TasksAPI.Service.Factory;

type
  TTaskController = class
  private
    FServiceFactory: IServiceFactory;
    procedure HandleGetStats(Req: THorseRequest; Res: THorseResponse);
    procedure HandleGetAll(Req: THorseRequest; Res: THorseResponse);
    procedure HandleCreate(Req: THorseRequest; Res: THorseResponse);
    procedure HandleUpdateStatus(Req: THorseRequest; Res: THorseResponse);
    procedure HandleDelete(Req: THorseRequest; Res: THorseResponse);
  public
    constructor Create(AServiceFactory: IServiceFactory);
    procedure RegisterRoutes;
  end;

implementation

uses
  System.SysUtils,
  System.Rtti,
  System.Generics.Collections,
  Horse.Commons,
  Horse.Exception,
  Neon.Core.Types,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,
  TasksAPI.Model.Entity.Task,
  TasksAPI.Model.Dto.Task,
  TasksAPI.Model.Dto.Stats,
  TasksAPI.Model.Exceptions,
  TasksAPI.Conn.Factory,
  TasksAPI.Repository.Task,
  TasksAPI.Service.Task;

function NeonConfig: INeonConfiguration;
begin
  Result := TNeonConfiguration.Create
    .SetMemberCase(TNeonCase.CamelCase);
end;

procedure RequireBody(Req: THorseRequest);
begin
  if Req.Body = '' then
    raise EHorseException.New
      .Error('Corpo da requisi'#231#227'o n'#227'o pode estar vazio.')
      .Status(THTTPStatus.BadRequest);
end;

function ParseId(Req: THorseRequest): Integer;
begin
  try
    Result := StrToInt(Req.Params['id']);
  except
    on E: EConvertError do
      raise EHorseException.New
        .Error('ID inv'#225'lido.')
        .Status(THTTPStatus.BadRequest);
  end;
end;

{ TTaskController }

constructor TTaskController.Create(AServiceFactory: IServiceFactory);
begin
  inherited Create;
  FServiceFactory := AServiceFactory;
end;

procedure TTaskController.RegisterRoutes;
var
  LSelf: TTaskController;
begin
  LSelf := Self;

  THorse.Get('/tasks/stats',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      LSelf.HandleGetStats(Req, Res);
    end);

  THorse.Get('/tasks',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      LSelf.HandleGetAll(Req, Res);
    end);

  THorse.Post('/tasks',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      LSelf.HandleCreate(Req, Res);
    end);

  THorse.Patch('/tasks/:id/status',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      LSelf.HandleUpdateStatus(Req, Res);
    end);

  THorse.Delete('/tasks/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      LSelf.HandleDelete(Req, Res);
    end);
end;

procedure TTaskController.HandleGetStats(Req: THorseRequest; Res: THorseResponse);
var
  LStats: TTaskStatsDto;
  LService: ITaskService;
begin
  LService := FServiceFactory.CreateTaskService;
  LStats := LService.GetStats;

  Res
    .ContentType('application/json')
    .Send(TNeon.ValueToJSONString(TValue.From<TTaskStatsDto>(LStats), NeonConfig));
end;

procedure TTaskController.HandleGetAll(Req: THorseRequest; Res: THorseResponse);
var
  LList: TObjectList<TTaskModel>;
  LArray: TArray<TTaskResponseDto>;
  I: Integer;
  LService: ITaskService;
begin
  LService := FServiceFactory.CreateTaskService;
  LList := LService.ListAll;
  try
    SetLength(LArray, LList.Count);
    for I := 0 to LList.Count - 1 do
      LArray[I] := TTaskResponseDto.FromModel(LList[I]);

    Res
      .ContentType('application/json')
      .Send(TNeon.ValueToJSONString(TValue.From<TArray<TTaskResponseDto>>(LArray), NeonConfig));
  finally
    LList.Free;
  end;
end;

procedure TTaskController.HandleCreate(Req: THorseRequest; Res: THorseResponse);
var
  LRequest: TCreateTaskRequestDto;
  LModel: TTaskModel;
  LResult: TTaskModel;
  LResponse: TTaskResponseDto;
  LService: ITaskService;
begin
  RequireBody(Req);
  LRequest := TNeon.JSONToValue<TCreateTaskRequestDto>(Req.Body, NeonConfig);
  LModel := LRequest.ToModel;
  LService := FServiceFactory.CreateTaskService;
  try
    LResult := LService.Add(LModel);
    try
      LResponse := TTaskResponseDto.FromModel(LResult);

      Res
        .ContentType('application/json')
        .Status(THTTPStatus.Created)
        .Send(TNeon.ValueToJSONString(TValue.From<TTaskResponseDto>(LResponse), NeonConfig));
    finally
      LResult.Free;
    end;
  finally
    LModel.Free;
  end;
end;

procedure TTaskController.HandleUpdateStatus(Req: THorseRequest; Res: THorseResponse);
var
  LId: Integer;
  LRequest: TUpdateStatusRequestDto;
  LService: ITaskService;
begin
  RequireBody(Req);
  LId := ParseId(Req);
  LRequest := TNeon.JSONToValue<TUpdateStatusRequestDto>(Req.Body, NeonConfig);
  LService := FServiceFactory.CreateTaskService;
  LService.UpdateStatus(LId, LRequest.Status);
  Res.Status(THTTPStatus.NoContent).Send('');
end;

procedure TTaskController.HandleDelete(Req: THorseRequest; Res: THorseResponse);
var
  LId: Integer;
  LService: ITaskService;
begin
  LId := ParseId(Req);
  LService := FServiceFactory.CreateTaskService;
  LService.Delete(LId);
  Res.Status(THTTPStatus.NoContent).Send('');
end;

end.
