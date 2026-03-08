unit TasksAPI.Service.Task;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  TasksAPI.Repository.Interfaces,
  TasksAPI.Service.Interfaces,
  TasksAPI.Model.Entity.Task,
  TasksAPI.Model.Dto.Stats,
  TasksAPI.Model.Exceptions;

type
  TTaskService = class(TInterfacedObject, ITaskService)
  private
    FRepository: ITaskRepository;
    procedure ValidateForInsert(ATask: TTaskModel);
    procedure ValidateStatus(AStatus: Integer);
    procedure EnsureTaskExists(AId: integer);
  public
    constructor Create(ARepository: ITaskRepository);

    function ListAll: TObjectList<TTaskModel>;
    function GetById(AId: Integer): TTaskModel;
    function Add(ATask: TTaskModel): TTaskModel;
    procedure UpdateStatus(AId: Integer; AStatus: Integer);
    procedure Delete(AId: Integer);
    function GetStats: TTaskStatsDto;
  end;

implementation

const
  TITLE_MAX_LENGTH = 100;
  DESCRIPTION_MAX_LENGTH = 500;
  PRIORITY_MIN = 1;
  PRIORITY_MAX = 3;

{ TTaskService }

constructor TTaskService.Create(ARepository: ITaskRepository);
begin
  FRepository := ARepository;
end;

procedure TTaskService.ValidateForInsert(ATask: TTaskModel);
begin
  if Trim(ATask.Title) = '' then
    raise EValidationException.Create('O título da tarefa é obrigatório.');

  if Length(ATask.Title) > TITLE_MAX_LENGTH then
    raise EValidationException.CreateFmt('O título deve ter no máximo %d caracteres.', [TITLE_MAX_LENGTH]);

  if Length(ATask.Description) > DESCRIPTION_MAX_LENGTH then
    raise EValidationException.CreateFmt('A descrição deve ter no máximo %d caracteres.', [DESCRIPTION_MAX_LENGTH]);

  if (ATask.Priority < PRIORITY_MIN) or (ATask.Priority > PRIORITY_MAX) then
    raise EValidationException.CreateFmt('A prioridade deve ser entre %d (baixa) e %d (alta).', [PRIORITY_MIN, PRIORITY_MAX]);
end;

procedure TTaskService.ValidateStatus(AStatus: Integer);
begin
  if (AStatus <> Ord(tsPending)) and (AStatus <> Ord(tsCompleted)) then
    raise EValidationException.CreateFmt('Status inválido. Use %d (pendente) ou %d (concluída).', [Ord(tsPending), Ord(tsCompleted)]);
end;

function TTaskService.ListAll: TObjectList<TTaskModel>;
begin
  Result := FRepository.FindAll;
end;

function TTaskService.GetById(AId: Integer): TTaskModel;
begin
  Result := FRepository.FindById(AId);

  if not Assigned(Result) then
    raise ENotFoundException.CreateFmt('Tarefa com id %d não encontrada.', [AId]);
end;

function TTaskService.Add(ATask: TTaskModel): TTaskModel;
var
  LInsertedId: Integer;
begin
  ValidateForInsert(ATask);
  ATask.Status := Ord(tsPending);
  LInsertedId := FRepository.Insert(ATask);
  Result := FRepository.FindById(LInsertedId);
end;

procedure TTaskService.UpdateStatus(AId: Integer; AStatus: Integer);
begin
  ValidateStatus(AStatus);
  EnsureTaskExists(AId);
  FRepository.UpdateStatus(AId, AStatus);
end;

procedure TTaskService.Delete(AId: Integer);
begin
  EnsureTaskExists(AId);
  FRepository.Delete(AId);
end;

procedure TTaskService.EnsureTaskExists(AId: integer);
begin
  if not FRepository.TaskExists(AId) then
    raise ENotFoundException.CreateFmt('Tarefa com id %d não encontrada.', [AId]);
end;

function TTaskService.GetStats: TTaskStatsDto;
begin
  Result := FRepository.GetStats;
end;

end.
