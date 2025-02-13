object FormOverlays: TFormOverlays
  Left = 0
  Top = 0
  Caption = 'Overlays'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 512
    object ButtonLoad: TButton
      Left = 4
      Top = 4
      Width = 80
      Height = 24
      Caption = 'Add File...'
      TabOrder = 0
    end
    object ButtonEdit: TButton
      Left = 88
      Top = 4
      Width = 80
      Height = 24
      Caption = 'Edit Bounds...'
      TabOrder = 1
    end
    object ButtonRemove: TButton
      Left = 172
      Top = 4
      Width = 80
      Height = 24
      Caption = 'Remove File'
      TabOrder = 2
    end
    object ButtonReload: TButton
      Left = 256
      Top = 4
      Width = 80
      Height = 24
      Caption = 'Reload Files'
      TabOrder = 3
    end
  end
  object ListView: TListView
    Left = 0
    Top = 32
    Width = 624
    Height = 409
    Align = alClient
    Columns = <
      item
        Caption = 'File Name'
        Width = 200
      end
      item
        Alignment = taRightJustify
        Caption = 'X'
      end
      item
        Alignment = taRightJustify
        Caption = 'Y'
      end
      item
        Alignment = taRightJustify
        Caption = 'Width'
      end
      item
        Alignment = taRightJustify
        Caption = 'Height'
      end>
    DoubleBuffered = True
    ReadOnly = True
    RowSelect = True
    ParentDoubleBuffered = False
    TabOrder = 1
    ViewStyle = vsReport
    ExplicitWidth = 512
    ExplicitHeight = 288
  end
  object OpenPictureDialog: TOpenPictureDialog
    Left = 376
    Top = 256
  end
end
