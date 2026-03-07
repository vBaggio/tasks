unit TasksAPI.Model.Dto.Stats;

interface

type
  TTaskStatsDto = record
    TotalCount: Integer;
    AveragePriorityPending: Double;
    CompletedLastSevenDays: Integer;
  end;

implementation

end.
