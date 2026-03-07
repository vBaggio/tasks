unit TasksAPI.Repository.Task;

interface

uses
  System.Generics.Collections,
  FireDAC.Comp.Client,
  TasksAPI.Conn.Interfaces,
  TasksAPI.Repository.Interfaces,
  TasksAPI.Model.Entity.Task,
  TasksAPI.Model.Dto.Stats;

type
  TTaskRepository = class(TInterfacedObject, ITaskRepository)
  private
    FConnection: IConnection;
    function MapRow(AQuery: TFDQuery): TTaskModel;
  public
    constructor Create(AConnection: IConnection);
    function FindAll: TObjectList<TTaskModel>;
    function FindById(AId: Integer): TTaskModel;
    function Insert(ATask: TTaskModel): Integer;
    procedure UpdateStatus(AId: Integer; AStatus: Integer);
    procedure Delete(AId: Integer);
    function GetStats: TTaskStatsDto;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.Stan.Param;

{ TTaskRepository }

constructor TTaskRepository.Create(AConnection: IConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TTaskRepository.MapRow(AQuery: TFDQuery): TTaskModel;
begin
  Result := TTaskModel.Create;
  Result.Id := AQuery.FieldByName('id').AsInteger;
  Result.Title := AQuery.FieldByName('title').AsString;
  Result.Description := AQuery.FieldByName('description').AsString;
  Result.Status := AQuery.FieldByName('status').AsInteger;
  Result.Priority := AQuery.FieldByName('priority').AsInteger;
  Result.CreatedAt := AQuery.FieldByName('created_at').AsDateTime;
  Result.HasCompletedAt := not AQuery.FieldByName('completed_at').IsNull;
  if Result.HasCompletedAt then
    Result.CompletedAt := AQuery.FieldByName('completed_at').AsDateTime;
end;

function TTaskRepository.FindAll: TObjectList<TTaskModel>;
var
  LQuery: TFDQuery;
begin
  Result := TObjectList<TTaskModel>.Create(True);
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text :=
      'SELECT id, title, description, status, priority, created_at, completed_at ' +
      'FROM tasks ' +
      'ORDER BY created_at DESC';
    LQuery.Open;
    while not LQuery.Eof do
    begin
      Result.Add(MapRow(LQuery));
      LQuery.Next;
    end;
  finally
    LQuery.Free;
  end;
end;

function TTaskRepository.FindById(AId: Integer): TTaskModel;
var
  LQuery: TFDQuery;
begin
  Result := nil;
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text :=
      'SELECT id, title, description, status, priority, created_at, completed_at ' +
      'FROM tasks ' +
      'WHERE id = :id';
    LQuery.ParamByName('id').AsInteger := AId;
    LQuery.Open;
    if not LQuery.IsEmpty then
      Result := MapRow(LQuery);
  finally
    LQuery.Free;
  end;
end;

function TTaskRepository.Insert(ATask: TTaskModel): Integer;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text :=
      'INSERT INTO tasks (title, description, status, priority) ' +
      'OUTPUT INSERTED.id ' +
      'VALUES (:title, :description, :status, :priority)';
    LQuery.ParamByName('title').AsString := ATask.Title;
    if ATask.Description <> '' then
      LQuery.ParamByName('description').AsString := ATask.Description
    else
    begin
      LQuery.ParamByName('description').DataType := ftString;
      LQuery.ParamByName('description').Clear;
    end;
    LQuery.ParamByName('status').AsInteger := ATask.Status;
    LQuery.ParamByName('priority').AsInteger := ATask.Priority;
    LQuery.Open;
    Result := LQuery.FieldByName('id').AsInteger;
  finally
    LQuery.Free;
  end;
end;

procedure TTaskRepository.UpdateStatus(AId: Integer; AStatus: Integer);
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    if AStatus = Ord(tsCompleted) then
      LQuery.SQL.Text :=
        'UPDATE tasks SET status = :status, completed_at = GETDATE() WHERE id = :id'
    else
      LQuery.SQL.Text :=
        'UPDATE tasks SET status = :status, completed_at = NULL WHERE id = :id';
    LQuery.ParamByName('status').AsInteger := AStatus;
    LQuery.ParamByName('id').AsInteger := AId;
    LQuery.ExecSQL;
  finally
    LQuery.Free;
  end;
end;

procedure TTaskRepository.Delete(AId: Integer);
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text := 'DELETE FROM tasks WHERE id = :id';
    LQuery.ParamByName('id').AsInteger := AId;
    LQuery.ExecSQL;
  finally
    LQuery.Free;
  end;
end;

function TTaskRepository.GetStats: TTaskStatsDto;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text :=
      'SELECT ' +
      '  (SELECT COUNT(*) FROM tasks) AS total_count, ' +
      '  (SELECT AVG(CAST(priority AS FLOAT)) FROM tasks WHERE status = 0) AS avg_priority_pending, ' +
      '  (SELECT COUNT(*) FROM tasks WHERE status = 1 ' +
      '    AND completed_at >= DATEADD(DAY, -7, GETDATE())) AS completed_last_7_days';
    LQuery.Open;
    Result.TotalCount := LQuery.FieldByName('total_count').AsInteger;
    Result.AveragePriorityPending := LQuery.FieldByName('avg_priority_pending').AsFloat;
    Result.CompletedLastSevenDays := LQuery.FieldByName('completed_last_7_days').AsInteger;
  finally
    LQuery.Free;
  end;
end;

end.
