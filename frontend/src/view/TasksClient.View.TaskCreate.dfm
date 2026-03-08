object frmTaskCreate: TfrmTaskCreate
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nova Tarefa'
  ClientHeight = 263
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 363
    Height = 240
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      Left = 12
      Top = 16
      Width = 35
      Height = 13
      Caption = 'T'#237'tulo *'
    end
    object lblDescription: TLabel
      Left = 12
      Top = 64
      Width = 46
      Height = 13
      Caption = 'Descri'#231#227'o'
    end
    object lblPriority: TLabel
      Left = 12
      Top = 168
      Width = 57
      Height = 13
      Caption = 'Prioridade *'
    end
    object edtTitle: TEdit
      Left = 12
      Top = 36
      Width = 336
      Height = 21
      MaxLength = 100
      TabOrder = 0
    end
    object mmoDescription: TMemo
      Left = 12
      Top = 84
      Width = 336
      Height = 72
      MaxLength = 500
      TabOrder = 1
    end
    object cbPriority: TComboBox
      Left = 12
      Top = 188
      Width = 336
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'Baixa'
      Items.Strings = (
        'Baixa'
        'M'#233'dia'
        'Alta')
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 223
    Width = 363
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnSave: TButton
      Left = 196
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Salvar'
      Default = True
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 277
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
