unit TasksClient.Controller.Tasks;

interface

uses
  System.Classes, System.SysUtils,
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
    procedure UpdateStatusAsync(AId: Integer; AStatus: Integer; AOnSuccess: TProc; AOnError: TProc<string>);
    procedure DeleteTask(AId: Integer);
    function ShowCreateDialog(AOwner: TComponent): Boolean;
    procedure GetStatsAsync(AOnSuccess: TProc<TTaskStatsDto>; AOnError: TProc<string>);
  end;

implementation

uses
  System.Threading,
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

procedure TTaskController.GetStatsAsync(AOnSuccess: TProc<TTaskStatsDto>; AOnError: TProc<string>);
begin
  TTask.Run(
    procedure
    var
      LStats: TTaskStatsDto;
      LErrorMsg: string;
      LSuccess: Boolean;
    begin
      LSuccess := False;
      try
        LStats := GetStats;
        LSuccess := True;
      except
        on E: Exception do
          LErrorMsg := E.Message;
      end;

      TThread.Queue(nil,
        procedure
        begin
          if LSuccess then
          begin
            if Assigned(AOnSuccess) then
              AOnSuccess(LStats);
          end
          else
          begin
            if Assigned(AOnError) then
              AOnError(LErrorMsg);
          end;
        end
      );
    end
  );
end;

function TTaskController.CreateTask(const ARequest: TCreateTaskRequestDto): TTaskResponseDto;
begin
  Result := FApiClient.CreateTask(ARequest);
end;

procedure TTaskController.UpdateStatus(AId: Integer; AStatus: Integer);
begin
  FApiClient.UpdateStatus(AId, AStatus);
end;

procedure TTaskController.UpdateStatusAsync(AId: Integer; AStatus: Integer; AOnSuccess: TProc; AOnError: TProc<string>);
begin
  TTask.Run(
    procedure
    var
      LErrorMsg: string;
      LSuccess: Boolean;
    begin
      LSuccess := False;
      try
        UpdateStatus(AId, AStatus);
        LSuccess := True;
      except
        on E: Exception do
          LErrorMsg := E.Message;
      end;

      TThread.Queue(nil,
        procedure
        begin
          if LSuccess then
          begin
            if Assigned(AOnSuccess) then
              AOnSuccess();
          end
          else
          begin
            if Assigned(AOnError) then
              AOnError(LErrorMsg);
          end;
        end
      );
    end
  );
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
