unit TasksClient.Controller.Tasks;

interface

uses
  TasksClient.Client.Interfaces,
  TasksClient.Model.Dto.Task,
  TasksClient.Model.Dto.Stats;

type
  TTaskController = class
  private
    FApiClient: ITaskApiClient;
  public
    constructor Create(AApiClient: ITaskApiClient);
    function ListAll: TArray<TTaskResponseDto>;
    function GetStats: TTaskStatsDto;
    function CreateTask(const ARequest: TCreateTaskRequestDto): TTaskResponseDto;
    procedure UpdateStatus(AId: Integer; AStatus: Integer);
    procedure DeleteTask(AId: Integer);
  end;

implementation

{ TTaskController }

constructor TTaskController.Create(AApiClient: ITaskApiClient);
begin
  FApiClient := AApiClient;
end;

function TTaskController.ListAll: TArray<TTaskResponseDto>;
begin
  Result := FApiClient.ListAll;
end;

function TTaskController.GetStats: TTaskStatsDto;
begin
  Result := FApiClient.GetStats;
end;

function TTaskController.CreateTask(const ARequest: TCreateTaskRequestDto): TTaskResponseDto;
begin
  Result := FApiClient.CreateTask(ARequest);
end;

procedure TTaskController.UpdateStatus(AId: Integer; AStatus: Integer);
begin
  FApiClient.UpdateStatus(AId, AStatus);
end;

procedure TTaskController.DeleteTask(AId: Integer);
begin
  FApiClient.Delete(AId);
end;

end.
