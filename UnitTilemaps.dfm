object FormTilemaps: TFormTilemaps
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Tilemaps'
  ClientHeight = 567
  ClientWidth = 512
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Visible = True
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
  TextHeight = 15
  object Image0: TImage
    Left = 0
    Top = 55
    Width = 512
    Height = 512
    Stretch = True
    OnDragDrop = ImageDragDrop
    OnDragOver = ImageDragOver
    OnMouseDown = ImageMouseDown
    OnMouseLeave = ImageMouseLeave
    OnMouseMove = ImageMouseMove
  end
  object Image1: TImage
    Left = 0
    Top = 55
    Width = 512
    Height = 512
    Proportional = True
    Stretch = True
    Visible = False
    OnDragDrop = ImageDragDrop
    OnDragOver = ImageDragOver
    OnMouseDown = ImageMouseDown
    OnMouseLeave = ImageMouseLeave
    OnMouseMove = ImageMouseMove
  end
  object ShapeSelection: TShape
    Left = 112
    Top = 104
    Width = 16
    Height = 16
    Brush.Style = bsClear
    Enabled = False
    Pen.Color = 33023
    Pen.Style = psDot
  end
  object ShapeHover: TShape
    Left = 120
    Top = 112
    Width = 16
    Height = 16
    Brush.Style = bsClear
    Enabled = False
    Pen.Color = clFuchsia
    Pen.Style = psDot
  end
  object PanelOptions: TPanel
    Left = 0
    Top = 0
    Width = 512
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    DoubleBuffered = False
    ParentDoubleBuffered = False
    TabOrder = 0
    object Label1: TLabel
      Left = 440
      Top = 8
      Width = 27
      Height = 15
      Caption = 'Map:'
    end
    object LabelTile: TLabel
      Left = 8
      Top = 8
      Width = 39
      Height = 15
      Caption = 'Tile 0:0:'
    end
    object Label3: TLabel
      Left = 78
      Top = 8
      Width = 41
      Height = 15
      Caption = 'Priority:'
    end
    object Label4: TLabel
      Left = 172
      Top = 8
      Width = 22
      Height = 15
      Caption = 'Flip:'
    end
    object Label5: TLabel
      Left = 240
      Top = 8
      Width = 19
      Height = 15
      Caption = 'Pal:'
    end
    object ComboBoxMap: TComboBox
      Left = 440
      Top = 24
      Width = 64
      Height = 23
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = 'x9800'
      OnSelect = ComboBoxMapSelect
      Items.Strings = (
        'x9800'
        'x9C00')
    end
    object ComboBoxBank: TComboBox
      Left = 8
      Top = 24
      Width = 34
      Height = 23
      Style = csDropDownList
      BiDiMode = bdRightToLeft
      ItemIndex = 0
      ParentBiDiMode = False
      TabOrder = 1
      Text = ':0'
      OnSelect = ComboBoxBankSelect
      Items.Strings = (
        ':0'
        ':1')
    end
    object EditTile: TEdit
      Left = 43
      Top = 24
      Width = 27
      Height = 23
      TabOrder = 2
      Text = '123'
      OnChange = EditTileChange
      OnExit = EditTileExit
    end
    object CheckBoxPriority: TCheckBox
      Left = 78
      Top = 24
      Width = 86
      Height = 22
      Caption = 'BG over OBJ'
      TabOrder = 3
      OnClick = CheckBoxPriorityClick
    end
    object CheckBoxFlipY: TCheckBox
      Left = 172
      Top = 24
      Width = 30
      Height = 22
      Caption = 'Y'
      TabOrder = 4
      OnClick = CheckBoxFlipYClick
    end
    object CheckBoxFlipX: TCheckBox
      Left = 202
      Top = 24
      Width = 30
      Height = 22
      Caption = 'X'
      TabOrder = 5
      OnClick = CheckBoxFlipXClick
    end
    object ComboBoxCGBPaletteIndex: TComboBox
      Left = 240
      Top = 24
      Width = 32
      Height = 23
      Style = csDropDownList
      TabOrder = 6
      OnSelect = ComboBoxCGBPaletteIndexSelect
      Items.Strings = (
        '0'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7')
    end
    object ToolBar: TToolBar
      Left = 288
      Top = 24
      Width = 142
      Height = 23
      Align = alNone
      ButtonHeight = 23
      Caption = 'ToolBar'
      Images = FormMain.ImageList
      TabOrder = 7
      object ToolButtonSelect: TToolButton
        Left = 0
        Top = 0
        Down = True
        ImageIndex = 0
        OnClick = ToolButtonSelectClick
      end
      object ToolButtonCopy: TToolButton
        Left = 23
        Top = 0
        DropdownMenu = PopupMenuCopy
        ImageIndex = 1
        Style = tbsDropDown
        OnClick = ToolButtonCopyClick
      end
    end
  end
  object PopupMenuCopy: TPopupMenu
    Left = 200
    Top = 264
    object MenuItemTile: TMenuItem
      Caption = 'Tile'
      object MenuItemTileNoTile: TMenuItem
        AutoCheck = True
        Caption = 'No Tile'
        RadioItem = True
      end
      object MenuItemTileTile: TMenuItem
        AutoCheck = True
        Caption = 'Tile'
        Checked = True
        RadioItem = True
      end
      object MenuItemTileIncrementTile: TMenuItem
        AutoCheck = True
        Caption = 'Tile++'
        RadioItem = True
      end
      object MenuItemTileDecrementTile: TMenuItem
        AutoCheck = True
        Caption = 'Tile--'
        RadioItem = True
      end
    end
    object MenuItemPriority: TMenuItem
      AutoCheck = True
      Caption = 'BG over OBJ'
      Checked = True
    end
    object MenuItemYFlip: TMenuItem
      AutoCheck = True
      Caption = 'Y-Flip'
      Checked = True
    end
    object MenuItemXFlip: TMenuItem
      AutoCheck = True
      Caption = 'X-Flip'
      Checked = True
    end
    object MenuItemCGBPaletteIndex: TMenuItem
      AutoCheck = True
      Caption = 'CGB Palette'
      Checked = True
    end
  end
  object ActionListHotkeys: TActionList
    State = asSuspended
    Left = 80
    Top = 160
    object ActionUp: TAction
      ShortCut = 38
      OnExecute = ActionUpExecute
    end
    object ActionDown: TAction
      ShortCut = 40
      OnExecute = ActionDownExecute
    end
    object ActionLeft: TAction
      ShortCut = 37
      OnExecute = ActionLeftExecute
    end
    object ActionRight: TAction
      ShortCut = 39
      OnExecute = ActionRightExecute
    end
    object ActionAdd: TAction
      ShortCut = 107
      OnExecute = ActionAddExecute
    end
    object ActionSubtract: TAction
      ShortCut = 109
      OnExecute = ActionSubtractExecute
    end
    object Action0: TAction
      Caption = 'Action0'
      ShortCut = 96
      OnExecute = ActionPalExecute
    end
    object Action1: TAction
      Tag = 1
      Caption = 'Action1'
      ShortCut = 97
      OnExecute = ActionPalExecute
    end
    object Action2: TAction
      Tag = 2
      Caption = 'Action2'
      ShortCut = 98
      OnExecute = ActionPalExecute
    end
    object Action3: TAction
      Tag = 3
      Caption = 'Action3'
      ShortCut = 99
      OnExecute = ActionPalExecute
    end
    object Action4: TAction
      Tag = 4
      Caption = 'Action4'
      ShortCut = 100
      OnExecute = ActionPalExecute
    end
    object Action5: TAction
      Tag = 5
      Caption = 'Action5'
      ShortCut = 101
      OnExecute = ActionPalExecute
    end
    object Action6: TAction
      Tag = 6
      Caption = 'Action6'
      ShortCut = 102
      OnExecute = ActionPalExecute
    end
    object Action7: TAction
      Tag = 7
      Caption = 'Action7'
      ShortCut = 103
      OnExecute = ActionPalExecute
    end
  end
end
