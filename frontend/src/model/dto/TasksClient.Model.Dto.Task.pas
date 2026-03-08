unit TasksClient.Model.Dto.Task;

interface

type
  TTaskResponseDto = record
    Id: Integer;
    Title: string;
    Description: string;
    Status: Integer;
    Priority: Integer;
    CreatedAt: string;
    CompletedAt: string;
  end;

  TCreateTaskRequestDto = record
    Title: string;
    Description: string;
    Priority: Integer;
  end;

  TUpdateStatusRequestDto = record
    Status: Integer;
  end;

implementation

end.
