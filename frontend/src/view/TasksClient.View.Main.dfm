object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Gerenciador de Tarefas'
  ClientHeight = 540
  ClientWidth = 820
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
  object imgRows: TImageList
    Height = 20
    Width = 1
    Left = 16
    Top = 504
  end
  object pnlContainer: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 820
    Height = 540
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
      Width = 820
      Height = 56
      Align = alTop
      BevelOuter = bvNone
      Padding.Left = 15
      Padding.Top = 5
      Padding.Right = 15
      Padding.Bottom = 5
      TabOrder = 0
      object lblTitle: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 5
        Width = 790
        Height = 46
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = 'Gerenciador de Tarefas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -21
        Font.Name = 'Roboto'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
    end
    object pnlStats: TPanel
      Left = 0
      Top = 56
      Width = 820
      Height = 44
      Align = alTop
      BevelOuter = bvNone
      Color = $00F5F5F5
      Padding.Left = 20
      Padding.Top = 6
      Padding.Right = 20
      Padding.Bottom = 6
      ParentBackground = False
      ParentColor = False
      TabOrder = 1
      object lblTotalTitle: TLabel
        Left = 20
        Top = 8
        Width = 104
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
        Left = 130
        Top = 8
        Width = 8
        Height = 15
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblAvgTitle: TLabel
        Left = 280
        Top = 8
        Width = 173
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
        Left = 459
        Top = 8
        Width = 22
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
        Left = 560
        Top = 8
        Width = 120
        Height = 15
        Caption = 'Conclu'#237'das (7 dias):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblCompletedWeek: TLabel
        Left = 686
        Top = 8
        Width = 8
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
    object pnlContent: TPanel
      Left = 0
      Top = 100
      Width = 820
      Height = 440
      Align = alClient
      BevelOuter = bvNone
      Padding.Left = 15
      Padding.Right = 15
      Padding.Bottom = 5
      TabOrder = 2
      object lvTasks: TListView
        Left = 15
        Top = 0
        Width = 790
        Height = 375
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Caption = ''
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
            Width = 194
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        HideSelection = False
        ParentFont = False
        ReadOnly = True
        RowSelect = True
        SmallImages = imgRows
        TabOrder = 0
        ViewStyle = vsReport
        OnCustomDrawSubItem = lvTasksCustomDrawSubItem
        OnDblClick = lvTasksDblClick
        OnItemChecked = lvTasksItemChecked
      end
      object pnlButtons: TPanel
        Left = 15
        Top = 375
        Width = 790
        Height = 60
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          790
          60)
        object btnCreate: TBitBtn
          Left = 0
          Top = 12
          Width = 120
          Height = 36
          Caption = 'Nova Tarefa'
          TabOrder = 0
          OnClick = btnCreateClick
        end
        object btnDelete: TBitBtn
          Left = 128
          Top = 12
          Width = 100
          Height = 36
          Caption = 'Excluir'
          TabOrder = 1
          OnClick = btnDeleteClick
        end
        object btnRefresh: TBitBtn
          Left = 662
          Top = 12
          Width = 120
          Height = 36
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Atualizar'
          TabOrder = 2
          OnClick = btnRefreshClick
        end
      end
    end
  end
end
