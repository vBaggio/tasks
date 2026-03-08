unit TasksClient.View.TaskCreate;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  TasksClient.Controller.Tasks,
  TasksClient.Model.Dto.Task,
  TasksClient.Model.Exceptions;

type
  TfrmTaskCreate = class(TForm)
    pnlMain: TPanel;
    lblTitle: TLabel;
    edtTitle: TEdit;
    lblDescription: TLabel;
    mmoDescription: TMemo;
    lblPriority: TLabel;
    cbPriority: TComboBox;
    pnlButtons: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    FController: TTaskController;
  public
    procedure setController(AController: TTaskController);
  end;

implementation

{$R *.dfm}

uses
  System.UITypes;

{ TfrmTaskCreate }

procedure TfrmTaskCreate.setController(AController: TTaskController);
begin
  FController := AController;
end;

procedure TfrmTaskCreate.btnSaveClick(Sender: TObject);
var
  LRequest: TCreateTaskRequestDto;
begin
  if Trim(edtTitle.Text) = '' then
  begin
    MessageDlg('O título é obrigatório.', mtWarning, [mbOK], 0);
    Exit;
  end;

  LRequest.Title       := Trim(edtTitle.Text);
  LRequest.Description := Trim(mmoDescription.Text);
  LRequest.Priority    := cbPriority.ItemIndex + 1;

  try
    FController.CreateTask(LRequest);
    ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmTaskCreate.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
