unit TasksAPI.Model.Dto.Task;

interface

uses
  System.SysUtils,
  System.DateUtils,
  TasksAPI.Model.Entity.Task;

type
  TCreateTaskRequestDto = record
    Title: string;
    Description: string;
    Priority: Integer;

    function ToModel: TTaskModel;
  end;

  TTaskResponseDto = record
    Id: Integer;
    Title: string;
    Description: string;
    Status: Integer;
    Priority: Integer;
    CreatedAt: string;
    CompletedAt: string;

    class function FromModel(ATask: TTaskModel): TTaskResponseDto; static;
  end;

implementation

{ TCreateTaskRequestDto }

function TCreateTaskRequestDto.ToModel: TTaskModel;
begin
  Result := TTaskModel.Create;
  Result.Title := Self.Title;
  Result.Description := Self.Description;
  Result.Priority := Self.Priority;
  Result.Status := Ord(tsPending);
end;

{ TTaskResponseDto }

class function TTaskResponseDto.FromModel(ATask: TTaskModel): TTaskResponseDto;
begin
  Result.Id := ATask.Id;
  Result.Title := ATask.Title;
  Result.Description := ATask.Description;
  Result.Status := ATask.Status;
  Result.Priority := ATask.Priority;
  Result.CreatedAt := DateToISO8601(ATask.CreatedAt, False);

  if ATask.HasCompletedAt then
    Result.CompletedAt := DateToISO8601(ATask.CompletedAt, False)
  else
    Result.CompletedAt := '';
end;

end.
