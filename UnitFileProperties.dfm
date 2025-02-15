object FormFileProperties: TFormFileProperties
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'File Properties'
  ClientHeight = 194
  ClientWidth = 248
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 48
    Height = 15
    Caption = 'File Type:'
  end
  object ComboBoxFileClass: TComboBox
    Left = 8
    Top = 24
    Width = 232
    Height = 23
    Style = csDropDownList
    ItemIndex = 10
    TabOrder = 0
    Text = 'OBJ Pal - LD [HL], n8; RET (output only)'
    OnSelect = ComboBoxFileClassSelect
    Items.Strings = (
      'Tiles 0'
      'Tiles 1'
      'Tile Map'
      'Map Attr'
      'OAM'
      'BG Pal - Raw (output only)'
      'BG Pal - LD [HL], n8 (output only)'
      'BG Pal - LD [HL], n8; RET (output only)'
      'OBJ Pal - Raw (output only)'
      'OBJ Pal - LD [HL], n8 (output only)'
      'OBJ Pal - LD [HL], n8; RET (output only)')
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 55
    Width = 232
    Height = 99
    Caption = 'Offsets/Pieces'
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 19
      Width = 21
      Height = 15
      Caption = 'File:'
    end
    object Label3: TLabel
      Left = 126
      Top = 19
      Width = 11
      Height = 15
      Caption = 'to'
    end
    object Label4: TLabel
      Left = 8
      Top = 45
      Width = 23
      Height = 15
      Caption = 'Size:'
    end
    object LabelSizeOf: TLabel
      Left = 126
      Top = 45
      Width = 11
      Height = 15
      Caption = 'of'
    end
    object Label5: TLabel
      Left = 8
      Top = 71
      Width = 18
      Height = 15
      Caption = 'GB:'
    end
    object Label6: TLabel
      Left = 126
      Top = 71
      Width = 11
      Height = 15
      Caption = 'to'
    end
    object EditFileOffsetBytes: TEdit
      Left = 40
      Top = 16
      Width = 42
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = EditFileOffsetBytesChange
    end
    object EditFileOffsetPieces: TEdit
      Left = 83
      Top = 16
      Width = 35
      Height = 23
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = EditFileOffsetPiecesChange
      OnExit = EditFileOffsetBytesChange
    end
    object EditFileOffsetToBytes: TEdit
      Left = 146
      Top = 16
      Width = 42
      Height = 23
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object EditFileOffsetToPieces: TEdit
      Left = 189
      Top = 16
      Width = 35
      Height = 23
      TabStop = False
      Alignment = taRightJustify
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
    object EditSizeBytes: TEdit
      Left = 40
      Top = 42
      Width = 42
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnChange = EditSizeBytesChange
    end
    object EditSizePieces: TEdit
      Left = 83
      Top = 42
      Width = 35
      Height = 23
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnChange = EditSizePiecesChange
      OnExit = EditSizeBytesChange
    end
    object EditSizeOfBytes: TEdit
      Left = 146
      Top = 42
      Width = 42
      Height = 23
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
    end
    object EditSizeOfPieces: TEdit
      Left = 189
      Top = 42
      Width = 35
      Height = 23
      TabStop = False
      Alignment = taRightJustify
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
    end
    object EditGBOffsetBytes: TEdit
      Left = 40
      Top = 68
      Width = 42
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnChange = EditGBOffsetBytesChange
    end
    object EditGBOffsetPieces: TEdit
      Left = 83
      Top = 68
      Width = 35
      Height = 23
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnChange = EditGBOffsetPiecesChange
      OnExit = EditGBOffsetBytesChange
    end
    object EditGBOffsetToBytes: TEdit
      Left = 146
      Top = 68
      Width = 42
      Height = 23
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 10
    end
    object EditGBOffsetToPieces: TEdit
      Left = 189
      Top = 68
      Width = 35
      Height = 23
      TabStop = False
      Alignment = taRightJustify
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 11
    end
  end
  object ButtonOK: TButton
    Left = 48
    Top = 162
    Width = 72
    Height = 24
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 128
    Top = 162
    Width = 72
    Height = 24
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
