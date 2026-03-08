unit TasksClient.View.Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons, Vcl.ImgList,
  TasksClient.Controller.Tasks,
  TasksClient.Model.Dto.Task,
  TasksClient.Model.Dto.Stats,
  TasksClient.Model.Exceptions;

type
  TfrmMain = class(TForm)
    imgRows: TImageList;
    pnlContainer: TPanel;
    pnlTop: TPanel;
    lblTitle: TLabel;
    pnlStats: TPanel;
    lblTotalTitle: TLabel;
    lblTotalCount: TLabel;
    lblAvgTitle: TLabel;
    lblAvgPriority: TLabel;
    lblWeekTitle: TLabel;
    lblCompletedWeek: TLabel;
    pnlContent: TPanel;
    lvTasks: TListView;
    pnlButtons: TPanel;
    btnCreate: TBitBtn;
    btnDelete: TBitBtn;
    btnRefresh: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure lvTasksDblClick(Sender: TObject);
    procedure lvTasksItemChecked(Sender: TObject; Item: TListItem);
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

{$R *.dfm}

uses
  System.UITypes,
  System.DateUtils;

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
  I: Integer;
  LItem: TListItem;
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
      LItem.Caption := '';                              // column 0: checkbox only
      LItem.Data := LId;
      LItem.SubItems.Add(LTask.Title);                 // column 1
      LItem.SubItems.Add(LTask.Description);           // column 2
      LItem.SubItems.Add(PriorityLabel(LTask.Priority)); // column 3
      LItem.SubItems.Add(FormatApiDateTime(LTask.CreatedAt));   // column 4
      LItem.SubItems.Add(FormatApiDateTime(LTask.CompletedAt)); // column 5
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
  lblTotalCount.Caption    := LStats.TotalCount.ToString;
  lblAvgPriority.Caption   := FormatFloat('0.0', LStats.AveragePriorityPending);
  lblCompletedWeek.Caption := LStats.CompletedLastSevenDays.ToString;
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

procedure TfrmMain.lvTasksDblClick(Sender: TObject);
var
  LItem: TListItem;
begin
  LItem := lvTasks.Selected;
  if Assigned(LItem) then
    LItem.Checked := not LItem.Checked; // triggers OnItemChecked
end;

procedure TfrmMain.lvTasksItemChecked(Sender: TObject; Item: TListItem);
var
  LId, LNewStatus: Integer;
begin
  if FUpdatingList or not Assigned(Item.Data) then
    Exit;

  LId := PInteger(Item.Data)^;
  LNewStatus := Ord(Item.Checked); // True=1 (concluída), False=0 (pendente)

  try
    FController.UpdateStatus(LId, LNewStatus);
  except
    on E: EApiException do
      MessageDlg('Erro ao atualizar status: ' + E.Message, mtError, [mbOK], 0);
    on E: Exception do
      MessageDlg('Erro inesperado: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmMain.lvTasksCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  LIndex: Integer;
begin
  DefaultDraw := True;
  if SubItem <> 2 then // SubItems[2] = Priority (0=Title, 1=Desc, 2=Priority ...)
    Exit;

  LIndex := Item.Index;
  if (LIndex < 0) or (LIndex > High(FTasks)) then
    Exit;

  case FTasks[LIndex].Priority of
    1: Sender.Canvas.Font.Color := clGreen;
    2: Sender.Canvas.Font.Color := $000080FF; // orange
    3: Sender.Canvas.Font.Color := clRed;
  end;
end;

end.
