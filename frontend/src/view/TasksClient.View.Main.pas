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
  TasksClient.Model.Exceptions, System.ImageList;

type
  TfrmMain = class(TForm)
    imgRows: TImageList;
    pnlContainer: TPanel;
    pnlTop: TPanel;
    lblTitle: TLabel;
    pnlContent: TPanel;
    lvTasks: TListView;
    pnlButtons: TPanel;
    btnCreate: TBitBtn;
    btnDelete: TBitBtn;
    btnRefresh: TBitBtn;
    pnlStats: TPanel;
    lblAvgTitle: TLabel;
    lblAvgPriority: TLabel;
    lblWeekTitle: TLabel;
    lblCompletedWeek: TLabel;
    lblTotalTitle: TLabel;
    lblTotalCount: TLabel;
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
    procedure LoadStatsAsync;
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
begin
  lvTasks.Items.Clear;
  FTasks := nil;
end;

procedure TfrmMain.LoadTasks;
var
  I: Integer;
  LItem: TListItem;
  LTask: TTaskResponseDto;
begin
  ClearListData;
  FTasks := FController.ListAll;
  FUpdatingList := True;
  lvTasks.Items.BeginUpdate;
  try
    for I := 0 to High(FTasks) do
    begin
      LTask := FTasks[I];
      LItem := lvTasks.Items.Add;
      LItem.Caption := '';
      LItem.Data := Pointer(LTask.Id);
      LItem.SubItems.Add(LTask.Title);
      LItem.SubItems.Add(LTask.Description);
      LItem.SubItems.Add(LTask.PriorityAsString);
      LItem.SubItems.Add(LTask.CreatedAtFormatted);
      LItem.SubItems.Add(LTask.CompletedAtFormatted);
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

procedure TfrmMain.LoadStatsAsync;
begin
  FController.GetStatsAsync(
    procedure(AStats: TTaskStatsDto)
    begin
      lblTotalCount.Caption    := AStats.TotalCount.ToString;
      lblAvgPriority.Caption   := FormatFloat('0.0', AStats.AveragePriorityPending);
      lblCompletedWeek.Caption := AStats.CompletedLastSevenDays.ToString;
    end,
    procedure(AError: string)
    begin
      //TODO
    end
  );
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
  if FController.ShowCreateDialog(Self) then
    RefreshAll;
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
var
  LId: Integer;
begin
  if lvTasks.Selected = nil then
  begin
    MessageDlg('Selecione uma tarefa para excluir.', mtWarning, [mbOK], 0);
    Exit;
  end;

  LId := Integer(lvTasks.Selected.Data);

  if MessageDlg('Deseja realmente excluir esta tarefa?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  try
    FController.DeleteTask(LId);
    RefreshAll;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmMain.lvTasksDblClick(Sender: TObject);
var
  LItem: TListItem;
begin
  LItem := lvTasks.Selected;
  if Assigned(LItem) then
    LItem.Checked := not LItem.Checked; //Trigger OnItemChecked
end;

procedure TfrmMain.lvTasksItemChecked(Sender: TObject; Item: TListItem);
var
  LId, LNewStatus: Integer;
begin
  Sleep(100);
  if FUpdatingList then
    Exit;

  LId := Integer(Item.Data);
  LNewStatus := Ord(Item.Checked);

  FController.UpdateStatusAsync(LId, LNewStatus,
    procedure // OnSuccess
    var
      I: Integer;
      LCurrentItem: TListItem;
    begin
      LCurrentItem := nil;
      for I := 0 to lvTasks.Items.Count - 1 do
      begin
        if Integer(lvTasks.Items[I].Data) = LId then
        begin
          LCurrentItem := lvTasks.Items[I];
          Break;
        end;
      end;

      if Assigned(LCurrentItem) then
      begin
        if LNewStatus = 1 then
          LCurrentItem.SubItems[4] := FormatDateTime('dd/mm/yyyy HH:mm', Now)
        else
          LCurrentItem.SubItems[4] := '-';
      end;
      LoadStatsAsync;
    end,

    procedure(AError: string) // OnError
    var
      I: Integer;
      LCurrentItem: TListItem;
    begin
      MessageDlg(AError, mtError, [mbOK], 0);

      LCurrentItem := nil;
      for I := 0 to lvTasks.Items.Count - 1 do
      begin
        if Integer(lvTasks.Items[I].Data) = LId then
        begin
          LCurrentItem := lvTasks.Items[I];
          Break;
        end;
      end;

      if Assigned(LCurrentItem) then
      begin
        FUpdatingList := True;
        try
          LCurrentItem.Checked := not LCurrentItem.Checked;
        finally
          FUpdatingList := False;
        end;
      end;
    end
  );
end;

procedure TfrmMain.lvTasksCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  LIndex: Integer;
begin
  DefaultDraw := True;
  Sender.Canvas.Font.Color := clWindowText;

  if SubItem > 2 then
    Exit;

  LIndex := Item.Index;
  if (LIndex < 0) or (LIndex > High(FTasks)) then
    Exit;

  case FTasks[LIndex].Priority of
    1: Sender.Canvas.Font.Color := clGreen;
    2: Sender.Canvas.Font.Color := $000080FF;
    3: Sender.Canvas.Font.Color := clRed;
  end;
end;

end.
