object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Tarefas'
  ClientHeight = 458
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object pnlContainer: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 784
    Height = 458
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 784
      Height = 49
      Align = alTop
      BevelOuter = bvNone
      Color = 16119285
      Padding.Left = 15
      Padding.Top = 5
      Padding.Right = 15
      Padding.Bottom = 5
      ParentBackground = False
      TabOrder = 0
      object lblTitle: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 5
        Width = 754
        Height = 39
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = 'Tarefas'
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -21
        Font.Name = 'Roboto'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
        ExplicitWidth = 731
        ExplicitHeight = 60
      end
    end
    object pnlContent: TPanel
      Left = 0
      Top = 49
      Width = 784
      Height = 409
      Align = alClient
      BevelOuter = bvNone
      Padding.Left = 15
      Padding.Right = 15
      Padding.Bottom = 5
      TabOrder = 1
      object lvTasks: TListView
        Left = 15
        Top = 0
        Width = 754
        Height = 326
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Width = 28
          end
          item
            Caption = 'T'#237'tulo'
            Width = 175
          end
          item
            Caption = 'Descri'#231#227'o'
            Width = 183
          end
          item
            Caption = 'Prioridade'
            Width = 70
          end
          item
            Caption = 'Criada em'
            Width = 130
          end
          item
            Caption = 'Conclu'#237'da em'
            Width = 189
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        SmallImages = imgRows
        TabOrder = 0
        ViewStyle = vsReport
        OnCustomDrawSubItem = lvTasksCustomDrawSubItem
        OnDblClick = lvTasksDblClick
        OnItemChecked = lvTasksItemChecked
      end
      object pnlButtons: TPanel
        Left = 15
        Top = 326
        Width = 754
        Height = 78
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          754
          78)
        object btnCreate: TBitBtn
          Left = 0
          Top = 32
          Width = 120
          Height = 36
          Anchors = [akLeft, akBottom]
          Caption = 'Nova Tarefa'
          TabOrder = 0
          OnClick = btnCreateClick
        end
        object btnDelete: TBitBtn
          Left = 126
          Top = 32
          Width = 100
          Height = 36
          Anchors = [akLeft, akBottom]
          Caption = 'Excluir'
          TabOrder = 1
          OnClick = btnDeleteClick
        end
        object btnRefresh: TBitBtn
          Left = 631
          Top = 32
          Width = 123
          Height = 36
          Anchors = [akRight, akBottom]
          Caption = 'Atualizar'
          TabOrder = 2
          OnClick = btnRefreshClick
        end
        object pnlStats: TPanel
          Left = 0
          Top = 0
          Width = 754
          Height = 28
          Align = alTop
          BevelOuter = bvNone
          Padding.Left = 20
          Padding.Top = 6
          Padding.Right = 20
          Padding.Bottom = 6
          ParentBackground = False
          TabOrder = 3
          DesignSize = (
            754
            28)
          object lblAvgTitle: TLabel
            Left = 120
            Top = 7
            Width = 159
            Height = 15
            Caption = 'M'#233'dia Prioridade (Pendentes):'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGrayText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object lblAvgPriority: TLabel
            Left = 285
            Top = 7
            Width = 17
            Height = 15
            Caption = '0.0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 12615680
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblWeekTitle: TLabel
            Left = 324
            Top = 7
            Width = 103
            Height = 15
            Anchors = [akLeft, akTop, akBottom]
            Caption = 'Conclu'#237'das (7 dias):'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGrayText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object lblCompletedWeek: TLabel
            Left = 433
            Top = 7
            Width = 7
            Height = 15
            Anchors = [akLeft, akTop, akBottom]
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 12615680
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblTotalTitle: TLabel
            Left = 0
            Top = 7
            Width = 85
            Height = 15
            Caption = 'Total de Tarefas:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGrayText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object lblTotalCount: TLabel
            Left = 91
            Top = 7
            Width = 7
            Height = 15
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 12615680
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
      end
    end
  end
  object imgRows: TImageList
    Height = 20
    Width = 1
    Left = 16
    Top = 504
  end
end
