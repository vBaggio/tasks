unit TasksClient.View.Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  TasksClient.Controller.Tasks,
  TasksClient.Model.Dto.Task,
  TasksClient.Model.Dto.Stats,
  TasksClient.Model.Exceptions;

type
  TfrmMain = class(TForm)
    pnlToolbar: TPanel;
    btnCreate: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    pnlStats: TPanel;
    pnlStatTotal: TPanel;
    lblTotalTitle: TLabel;
    lblTotalCount: TLabel;
    pnlStatAvg: TPanel;
    lblAvgTitle: TLabel;
    lblAvgPriority: TLabel;
    pnlStatWeek: TPanel;
    lblWeekTitle: TLabel;
    lblCompletedWeek: TLabel;
    lvTasks: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure lvTasksCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
  private
    FController: TTaskController;
    FTasks: TArray<TTaskResponseDto>;
    FUpdatingList: Boolean;
    procedure LoadTasks;
    procedure LoadStats;
    procedure RefreshAll;
    procedure ClearListData;
  public
    procedure SetController(AController: TTaskController);
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.UITypes;

{$R *.dfm}

function PriorityLabel(APriority: Integer): string;
begin
  case APriority of
    1: Result := 'Baixa';
    2: Result := 'M'#233'dia';
    3: Result := 'Alta';
  else
    Result := APriority.ToString;
  end;
end;

{ TfrmMain }

procedure TfrmMain.SetController(AController: TTaskController);
begin
  FController := AController;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  RefreshAll;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  ClearListData;
end;

procedure TfrmMain.ClearListData;
var
  LItem: TListItem;
  I: Integer;
begin
  for I := 0 to lvTasks.Items.Count - 1 do
  begin
    LItem := lvTasks.Items[I];
    if Assigned(LItem.Data) then
      Dispose(PInteger(LItem.Data));
  end;
  lvTasks.Items.Clear;
  FTasks := nil;
end;

procedure TfrmMain.LoadTasks;
var
  I: Integer;
  LItem: TListItem;
  LTask: TTaskResponseDto;
  LId: PInteger;
begin
  ClearListData;
  FTasks := FController.ListAll;
  FUpdatingList := True;
  lvTasks.Items.BeginUpdate;
  try
    for I := 0 to High(FTasks) do
    begin
      LTask := FTasks[I];
      New(LId);
      LId^ := LTask.Id;

      LItem := lvTasks.Items.Add;
      LItem.Caption := LTask.Title;
      LItem.Data := LId;
      LItem.SubItems.Add(LTask.Description);
      LItem.SubItems.Add(PriorityLabel(LTask.Priority));
      LItem.SubItems.Add(LTask.CreatedAt);
      LItem.SubItems.Add(LTask.CompletedAt);
      LItem.Checked := (LTask.Status = 1);
    end;
  finally
    lvTasks.Items.EndUpdate;
    FUpdatingList := False;
  end;
end;

procedure TfrmMain.LoadStats;
var
  LStats: TTaskStatsDto;
begin
  LStats := FController.GetStats;
  lblTotalCount.Caption      := LStats.TotalCount.ToString;
  lblAvgPriority.Caption     := FormatFloat('0.0', LStats.AveragePriorityPending);
  lblCompletedWeek.Caption   := LStats.CompletedLastSevenDays.ToString;
end;

procedure TfrmMain.RefreshAll;
begin
  try
    LoadTasks;
    LoadStats;
  except
    on E: EApiException do
      MessageDlg('Erro ao comunicar com a API: ' + E.Message, mtError, [mbOK], 0);
    on E: Exception do
      MessageDlg('Erro inesperado: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmMain.btnRefreshClick(Sender: TObject);
begin
  RefreshAll;
end;

procedure TfrmMain.btnCreateClick(Sender: TObject);
begin
  // Task 2.3
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
begin
  // Task 2.5
end;

procedure TfrmMain.lvTasksCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  LIndex: Integer;
begin
  DefaultDraw := True;
  if SubItem <> 1 then   // SubItems[1] = Priority (0=Desc, 1=Priority, 2=CreatedAt, 3=CompletedAt)
    Exit;

  LIndex := Item.Index;
  if (LIndex < 0) or (LIndex > High(FTasks)) then
    Exit;

  case FTasks[LIndex].Priority of
    1: Sender.Canvas.Font.Color := clGreen;
    2: Sender.Canvas.Font.Color := $000080FF;  // orange
    3: Sender.Canvas.Font.Color := clRed;
  end;
end;

end.
