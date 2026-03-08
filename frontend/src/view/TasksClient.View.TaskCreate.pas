unit TasksClient.View.TaskCreate;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls;

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
  end;

implementation

{$R *.dfm}

procedure TfrmTaskCreate.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
