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
    function PriorityAsString: string;
    function CreatedAtFormatted: string;
    function CompletedAtFormatted: string;
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

uses
  System.SysUtils, System.DateUtils;

{ TTaskResponseDto }

function TTaskResponseDto.PriorityAsString: string;
begin
  case Priority of
    1: Result := 'Baixa';
    2: Result := 'Média';
    3: Result := 'Alta';
  else
    Result := Priority.ToString;
  end;
end;

function FormatApiDateTime(const AValue: string): string;
var
  LDt: TDateTime;
begin
  if AValue = '' then
  begin
    Result := '-';
    Exit;
  end;
  try
    LDt := ISO8601ToDate(AValue, False);
    Result := FormatDateTime('dd/mm/yyyy HH:mm', LDt);
  except
    Result := AValue;
  end;
end;

function TTaskResponseDto.CreatedAtFormatted: string;
begin
  Result := FormatApiDateTime(CreatedAt);
end;

function TTaskResponseDto.CompletedAtFormatted: string;
begin
  Result := FormatApiDateTime(CompletedAt);
end;

end.
