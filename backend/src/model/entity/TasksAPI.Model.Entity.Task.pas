unit TasksAPI.Model.Entity.Task;

interface

type
  TTaskStatus = (tsPending = 0, tsCompleted = 1);

  TTaskPriority = (tpLow = 1, tpMedium = 2, tpHigh = 3);

  TTaskModel = class
  private
    FId: Integer;
    FTitle: string;
    FDescription: string;
    FStatus: Integer;
    FPriority: Integer;
    FCreatedAt: TDateTime;
    FCompletedAt: TDateTime;
    FHasCompletedAt: Boolean;
  public
    property Id: Integer read FId write FId;
    property Title: string read FTitle write FTitle;
    property Description: string read FDescription write FDescription;
    property Status: Integer read FStatus write FStatus;
    property Priority: Integer read FPriority write FPriority;
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    property CompletedAt: TDateTime read FCompletedAt write FCompletedAt;
    property HasCompletedAt: Boolean read FHasCompletedAt write FHasCompletedAt;
  end;

  TTaskStats = class
  private
    FTotalCount: Integer;
    FAveragePriorityPending: Double;
    FCompletedLastSevenDays: Integer;
  public
    property TotalCount: Integer read FTotalCount write FTotalCount;
    property AveragePriorityPending: Double read FAveragePriorityPending write FAveragePriorityPending;
    property CompletedLastSevenDays: Integer read FCompletedLastSevenDays write FCompletedLastSevenDays;
  end;

implementation

end.
