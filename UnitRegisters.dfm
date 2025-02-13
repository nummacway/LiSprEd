object FormRegisters: TFormRegisters
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'I/O Registers'
  ClientHeight = 280
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Visible = True
  OnDeactivate = FormDeactivate
  TextHeight = 15
  object LabelLCDC: TLabel
    Left = 8
    Top = 11
    Width = 33
    Height = 15
    Caption = 'LCDC:'
  end
  object LabelLCDC7: TLabel
    Left = 88
    Top = 8
    Width = 63
    Height = 15
    Caption = 'LCD Enable:'
  end
  object LabelLCDC6: TLabel
    Left = 88
    Top = 24
    Width = 69
    Height = 15
    Caption = 'Win Tilemap:'
  end
  object LabelLCDC5: TLabel
    Left = 88
    Top = 40
    Width = 62
    Height = 15
    Caption = 'Win Enable:'
  end
  object LabelLCDC4: TLabel
    Left = 88
    Top = 56
    Width = 70
    Height = 15
    Caption = 'BG/Win Tiles:'
  end
  object LabelLCDC3: TLabel
    Left = 88
    Top = 72
    Width = 63
    Height = 15
    Caption = 'BG Tilemap:'
  end
  object LabelLCDC2: TLabel
    Left = 88
    Top = 88
    Width = 46
    Height = 15
    Caption = 'OBJ Size:'
  end
  object LabelLCDC1: TLabel
    Left = 88
    Top = 104
    Width = 61
    Height = 15
    Caption = 'OBJ Enable:'
  end
  object LabelLCDC0: TLabel
    Left = 88
    Top = 120
    Width = 67
    Height = 15
    Caption = 'BG over OBJ:'
  end
  object LabelWY: TLabel
    Left = 8
    Top = 42
    Width = 21
    Height = 15
    Caption = 'WY:'
  end
  object LabelWX: TLabel
    Left = 8
    Top = 66
    Width = 21
    Height = 15
    Caption = 'WX:'
  end
  object LabelSCY: TLabel
    Left = 8
    Top = 92
    Width = 24
    Height = 15
    Caption = 'SCY:'
  end
  object LabelSCX: TLabel
    Left = 8
    Top = 116
    Width = 24
    Height = 15
    Caption = 'SCX:'
  end
  object LabelBGP: TLabel
    Left = 8
    Top = 147
    Width = 25
    Height = 15
    Caption = 'BGP:'
  end
  object LabelOBP0: TLabel
    Left = 8
    Top = 173
    Width = 32
    Height = 15
    Caption = 'OBP0:'
  end
  object LabelOBP1: TLabel
    Left = 8
    Top = 197
    Width = 32
    Height = 15
    Caption = 'OBP1:'
  end
  object LabelOPRI: TLabel
    Left = 8
    Top = 228
    Width = 29
    Height = 15
    Caption = 'OPRI:'
  end
  object LabelOPRI0: TLabel
    Left = 88
    Top = 228
    Width = 72
    Height = 15
    Caption = 'OAM Priority:'
  end
  object LabelKEY0: TLabel
    Left = 8
    Top = 252
    Width = 29
    Height = 15
    Caption = 'KEY0:'
  end
  object LabelKEY02: TLabel
    Left = 88
    Top = 252
    Width = 34
    Height = 15
    Caption = 'Mode:'
  end
  object EditLCDC: TEdit
    Tag = 64
    Left = 52
    Top = 8
    Width = 28
    Height = 23
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = EditLCDCChange
    OnExit = EditExit
  end
  object CheckBoxLCDC7: TCheckBox
    Left = 168
    Top = 8
    Width = 104
    Height = 16
    Caption = 'On'
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 168
    Top = 24
    Width = 104
    Height = 16
    BevelOuter = bvNone
    TabOrder = 2
    object RadioButtonLCDC60: TRadioButton
      Left = 0
      Top = 0
      Width = 52
      Height = 16
      Caption = '9800'
      TabOrder = 0
      OnClick = RadioButtonLCDC60Click
    end
    object RadioButtonLCDC61: TRadioButton
      Left = 52
      Top = 0
      Width = 52
      Height = 16
      Caption = '9C00'
      TabOrder = 1
      OnClick = RadioButtonLCDC61Click
    end
  end
  object CheckBoxLCDC5: TCheckBox
    Left = 168
    Top = 40
    Width = 104
    Height = 16
    Caption = 'On'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = CheckBoxLCDC5Click
  end
  object Panel2: TPanel
    Left = 168
    Top = 56
    Width = 104
    Height = 16
    BevelOuter = bvNone
    TabOrder = 4
    object RadioButtonLCDC40: TRadioButton
      Left = 0
      Top = 0
      Width = 52
      Height = 16
      Caption = '9000'
      TabOrder = 0
      OnClick = RadioButtonLCDC40Click
    end
    object RadioButtonLCDC41: TRadioButton
      Left = 52
      Top = 0
      Width = 52
      Height = 16
      Caption = '8000'
      TabOrder = 1
      OnClick = RadioButtonLCDC41Click
    end
  end
  object Panel3: TPanel
    Left = 168
    Top = 72
    Width = 104
    Height = 16
    BevelOuter = bvNone
    TabOrder = 5
    object RadioButtonLCDC30: TRadioButton
      Left = 0
      Top = 0
      Width = 52
      Height = 16
      Caption = '9800'
      TabOrder = 0
      OnClick = RadioButtonLCDC30Click
    end
    object RadioButtonLCDC31: TRadioButton
      Left = 52
      Top = 0
      Width = 52
      Height = 16
      Caption = '9C00'
      TabOrder = 1
      OnClick = RadioButtonLCDC31Click
    end
  end
  object Panel4: TPanel
    Left = 168
    Top = 88
    Width = 104
    Height = 16
    BevelOuter = bvNone
    TabOrder = 6
    object RadioButtonLCDC20: TRadioButton
      Left = 0
      Top = 0
      Width = 52
      Height = 16
      Caption = '8'#215'8'
      TabOrder = 0
      OnClick = RadioButtonLCDC20Click
    end
    object RadioButtonLCDC21: TRadioButton
      Left = 52
      Top = 0
      Width = 52
      Height = 16
      Caption = '8'#215'16'
      TabOrder = 1
      OnClick = RadioButtonLCDC21Click
    end
  end
  object CheckBoxLCDC1: TCheckBox
    Left = 168
    Top = 104
    Width = 104
    Height = 16
    Caption = 'On'
    Checked = True
    State = cbChecked
    TabOrder = 7
    OnClick = CheckBoxLCDC1Click
  end
  object CheckBoxLCDC0: TCheckBox
    Left = 168
    Top = 120
    Width = 104
    Height = 16
    Caption = 'Available'
    Checked = True
    State = cbChecked
    TabOrder = 8
    OnClick = CheckBoxLCDC0Click
  end
  object EditWY: TEdit
    Tag = 74
    Left = 52
    Top = 39
    Width = 28
    Height = 23
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnChange = EditWYChange
    OnExit = EditExit
  end
  object EditWX: TEdit
    Tag = 75
    Left = 52
    Top = 63
    Width = 28
    Height = 23
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    OnChange = EditWXChange
    OnExit = EditExit
  end
  object EditSCY: TEdit
    Tag = 66
    Left = 52
    Top = 89
    Width = 28
    Height = 23
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnChange = EditSCYChange
    OnExit = EditExit
  end
  object EditSCX: TEdit
    Tag = 67
    Left = 52
    Top = 113
    Width = 28
    Height = 23
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    OnChange = EditSCXChange
    OnExit = EditExit
  end
  object EditBGP: TEdit
    Tag = 71
    Left = 52
    Top = 144
    Width = 28
    Height = 23
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    OnChange = EditBGPChange
    OnExit = EditExit
  end
  object ColorBoxBGP3: TColorBox
    Tag = 3
    Left = 88
    Top = 144
    Width = 40
    Height = 23
    Selected = clScrollBar
    Style = [cbPrettyNames, cbCustomColors]
    DropDownWidth = 64
    ItemHeight = 17
    TabOrder = 14
    OnChange = ColorBoxBGPChange
    OnGetColors = ColorBoxGetColors
  end
  object ColorBoxBGP2: TColorBox
    Tag = 2
    Left = 136
    Top = 144
    Width = 40
    Height = 23
    Selected = clScrollBar
    Style = [cbPrettyNames, cbCustomColors]
    DropDownWidth = 64
    ItemHeight = 17
    TabOrder = 15
    OnChange = ColorBoxBGPChange
    OnGetColors = ColorBoxGetColors
  end
  object ColorBoxBGP1: TColorBox
    Tag = 1
    Left = 184
    Top = 144
    Width = 40
    Height = 23
    Selected = clScrollBar
    Style = [cbPrettyNames, cbCustomColors]
    DropDownWidth = 64
    ItemHeight = 17
    TabOrder = 16
    OnChange = ColorBoxBGPChange
    OnGetColors = ColorBoxGetColors
  end
  object ColorBoxBGP0: TColorBox
    Left = 232
    Top = 144
    Width = 40
    Height = 23
    Selected = clScrollBar
    Style = [cbPrettyNames, cbCustomColors]
    DropDownWidth = 64
    ItemHeight = 17
    TabOrder = 17
    OnChange = ColorBoxBGPChange
    OnGetColors = ColorBoxGetColors
  end
  object EditOBP0: TEdit
    Tag = 72
    Left = 52
    Top = 170
    Width = 28
    Height = 23
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 18
    OnChange = EditOBP0Change
    OnExit = EditExit
  end
  object ColorBoxOBP03: TColorBox
    Tag = 3
    Left = 88
    Top = 170
    Width = 40
    Height = 23
    Selected = clScrollBar
    Style = [cbPrettyNames, cbCustomColors]
    DropDownWidth = 64
    ItemHeight = 17
    TabOrder = 19
    OnChange = ColorBoxOBP0Change
    OnGetColors = ColorBoxGetColors
  end
  object ColorBoxOBP02: TColorBox
    Tag = 2
    Left = 136
    Top = 170
    Width = 40
    Height = 23
    Selected = clScrollBar
    Style = [cbPrettyNames, cbCustomColors]
    DropDownWidth = 64
    ItemHeight = 17
    TabOrder = 20
    OnChange = ColorBoxOBP0Change
    OnGetColors = ColorBoxGetColors
  end
  object ColorBoxOBP01: TColorBox
    Tag = 1
    Left = 184
    Top = 170
    Width = 40
    Height = 23
    Selected = clScrollBar
    Style = [cbPrettyNames, cbCustomColors]
    DropDownWidth = 64
    ItemHeight = 17
    TabOrder = 21
    OnChange = ColorBoxOBP0Change
    OnGetColors = ColorBoxGetColors
  end
  object ColorBoxOBP00: TColorBox
    Left = 232
    Top = 170
    Width = 40
    Height = 23
    Selected = clScrollBar
    Style = [cbPrettyNames, cbCustomColors]
    DropDownWidth = 64
    ItemHeight = 17
    TabOrder = 22
    Visible = False
    OnChange = ColorBoxOBP0Change
    OnGetColors = ColorBoxGetColors
  end
  object EditOBP1: TEdit
    Tag = 73
    Left = 52
    Top = 194
    Width = 28
    Height = 23
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 23
    OnChange = EditOBP1Change
    OnExit = EditExit
  end
  object ColorBoxOBP13: TColorBox
    Tag = 3
    Left = 88
    Top = 194
    Width = 40
    Height = 23
    Selected = clScrollBar
    Style = [cbPrettyNames, cbCustomColors]
    DropDownWidth = 64
    ItemHeight = 17
    TabOrder = 24
    OnChange = ColorBoxOBP1Change
    OnGetColors = ColorBoxGetColors
  end
  object ColorBoxOBP12: TColorBox
    Tag = 2
    Left = 136
    Top = 194
    Width = 40
    Height = 23
    Selected = clScrollBar
    Style = [cbPrettyNames, cbCustomColors]
    DropDownWidth = 64
    ItemHeight = 17
    TabOrder = 25
    OnChange = ColorBoxOBP1Change
    OnGetColors = ColorBoxGetColors
  end
  object ColorBoxOBP11: TColorBox
    Tag = 1
    Left = 184
    Top = 194
    Width = 40
    Height = 23
    Selected = clScrollBar
    Style = [cbPrettyNames, cbCustomColors]
    DropDownWidth = 64
    ItemHeight = 17
    TabOrder = 26
    OnChange = ColorBoxOBP1Change
    OnGetColors = ColorBoxGetColors
  end
  object ColorBoxOBP10: TColorBox
    Left = 232
    Top = 194
    Width = 40
    Height = 23
    Selected = clScrollBar
    Style = [cbPrettyNames, cbCustomColors]
    DropDownWidth = 64
    ItemHeight = 17
    TabOrder = 27
    Visible = False
    OnChange = ColorBoxOBP1Change
    OnGetColors = ColorBoxGetColors
  end
  object EditOPRI: TEdit
    Left = 52
    Top = 225
    Width = 28
    Height = 23
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 28
    OnChange = EditOPRIChange
    OnExit = EditExit
  end
  object CheckBoxOPRI0: TCheckBox
    Left = 168
    Top = 228
    Width = 104
    Height = 16
    Caption = 'DMG Mode'
    Checked = True
    State = cbChecked
    TabOrder = 29
    OnClick = CheckBoxOPRI0Click
  end
  object EditKEY0: TEdit
    Tag = 76
    Left = 52
    Top = 249
    Width = 28
    Height = 23
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 30
    OnExit = EditExit
  end
  object RadioButtonKEY020: TRadioButton
    Left = 168
    Top = 252
    Width = 52
    Height = 16
    Caption = 'CGB'
    TabOrder = 31
    OnClick = RadioButtonKEY020Click
  end
  object RadioButtonKEY021: TRadioButton
    Left = 220
    Top = 252
    Width = 52
    Height = 16
    Caption = 'DMG'
    TabOrder = 32
    OnClick = RadioButtonKEY021Click
  end
end
