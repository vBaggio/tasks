object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Gerenciador de Tarefas'
  ClientHeight = 540
  ClientWidth = 820
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlToolbar: TPanel
    Left = 0
    Top = 0
    Width = 820
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btnCreate: TButton
      Left = 8
      Top = 8
      Width = 110
      Height = 25
      Caption = 'Nova Tarefa'
      TabOrder = 0
      OnClick = btnCreateClick
    end
    object btnDelete: TButton
      Left = 124
      Top = 8
      Width = 90
      Height = 25
      Caption = 'Excluir'
      TabOrder = 1
      OnClick = btnDeleteClick
    end
    object btnRefresh: TButton
      Left = 220
      Top = 8
      Width = 90
      Height = 25
      Caption = 'Atualizar'
      TabOrder = 2
      OnClick = btnRefreshClick
    end
  end
  object pnlStats: TPanel
    Left = 0
    Top = 40
    Width = 820
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object pnlStatTotal: TPanel
      Left = 0
      Top = 0
      Width = 240
      Height = 60
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblTotalTitle: TLabel
        Left = 12
        Top = 12
        Width = 92
        Height = 13
        Caption = 'Total de Tarefas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblTotalCount: TLabel
        Left = 12
        Top = 34
        Width = 6
        Height = 13
        Caption = '0'
      end
    end
    object pnlStatAvg: TPanel
      Left = 240
      Top = 0
      Width = 280
      Height = 60
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object lblAvgTitle: TLabel
        Left = 12
        Top = 12
        Width = 168
        Height = 13
        Caption = 'M'#233'dia Prioridade (Pendentes)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblAvgPriority: TLabel
        Left = 12
        Top = 34
        Width = 16
        Height = 13
        Caption = '0.0'
      end
    end
    object pnlStatWeek: TPanel
      Left = 520
      Top = 0
      Width = 300
      Height = 60
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 2
      object lblWeekTitle: TLabel
        Left = 12
        Top = 12
        Width = 106
        Height = 13
        Caption = 'Conclu'#237'das (7 dias)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblCompletedWeek: TLabel
        Left = 12
        Top = 34
        Width = 6
        Height = 13
        Caption = '0'
      end
    end
  end
  object lvTasks: TListView
    Left = 0
    Top = 100
    Width = 820
    Height = 440
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'T'#237'tulo'
        Width = 200
      end
      item
        Caption = 'Descri'#231#227'o'
        Width = 200
      end
      item
        Caption = 'Prioridade'
        Width = 70
      end
      item
        Caption = 'Criada em'
        Width = 140
      end
      item
        Caption = 'Conclu'#237'da em'
        Width = 140
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    OnCustomDrawSubItem = lvTasksCustomDrawSubItem
  end
end
