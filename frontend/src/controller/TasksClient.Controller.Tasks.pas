unit TasksClient.Controller.Tasks;

interface

uses
  System.Classes,
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
    function ShowCreateDialog(AOwner: TComponent): Boolean;
  end;

implementation

uses
  TasksClient.View.TaskCreate,
  Vcl.Forms, Vcl.Controls;

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

function TTaskController.ShowCreateDialog(AOwner: TComponent): Boolean;
var
  LDlg: TfrmTaskCreate;
begin
  LDlg := TfrmTaskCreate.Create(AOwner);
  try
    LDlg.SetController(Self);
    Result := LDlg.ShowModal = mrOk;
  finally
    LDlg.Free;
  end;
end;

end.
