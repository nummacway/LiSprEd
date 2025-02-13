object FormPreview: TFormPreview
  Left = 0
  Top = 0
  Caption = 'Main Preview & Editor'
  ClientHeight = 663
  ClientWidth = 678
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Visible = True
  OnCreate = FormCreate
  TextHeight = 15
  object PanelOptions: TPanel
    Left = 0
    Top = 0
    Width = 678
    Height = 39
    Align = alTop
    BevelOuter = bvNone
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object ToolBar: TToolBar
      Left = 8
      Top = 8
      Width = 113
      Height = 23
      Align = alNone
      ButtonHeight = 23
      Caption = 'ToolBar'
      Images = FormMain.ImageList
      TabOrder = 0
      object ToolButtonDraw: TToolButton
        Left = 0
        Top = 0
        Hint = 'Pen'
        Caption = 'ToolButtonDraw'
        Down = True
        Grouped = True
        ImageIndex = 2
        Style = tbsCheck
        OnClick = ToolButtonDrawClick
      end
      object ToolButtonColorPicker: TToolButton
        Left = 23
        Top = 0
        Hint = 'Color Picker (Ctrl)'
        Caption = 'ToolButtonColorPicker'
        Grouped = True
        ImageIndex = 3
        Style = tbsCheck
        OnClick = ToolButtonColorPickerClick
      end
      object ToolButtonOverlays: TToolButton
        Left = 46
        Top = 0
        DropdownMenu = PopupMenuOverlays
        ImageIndex = 0
        Style = tbsDropDown
        OnClick = ToolButtonOverlaysClick
      end
    end
    object CheckBoxOverlays: TCheckBox
      Left = 536
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Overlays'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = CheckBoxOverlaysClick
    end
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 39
    Width = 678
    Height = 624
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    BorderStyle = bsNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    OnMouseWheel = ScrollBoxMouseWheel
    object Image: TImage
      Left = 0
      Top = 0
      Width = 640
      Height = 576
      Stretch = True
      OnDragDrop = ImageDragDrop
      OnDragOver = ImageDragOver
      OnMouseDown = ImageMouseDown
      OnMouseLeave = ImageMouseLeave
      OnMouseMove = ImageMouseMove
      OnMouseUp = ImageMouseUp
    end
    object ShapeOAM: TShape
      Left = 48
      Top = 56
      Width = 25
      Height = 41
      Brush.Style = bsClear
      Enabled = False
      Pen.Color = clRed
      Visible = False
    end
    object ShapeResize: TShape
      Left = 176
      Top = 248
      Width = 7
      Height = 7
      DragCursor = crSizeNWSE
      DragMode = dmAutomatic
      Visible = False
      OnEndDrag = ShapeResizeEndDrag
      OnStartDrag = ShapeResizeStartDrag
    end
  end
  object PopupMenuOverlays: TPopupMenu
    Left = 304
    Top = 255
    object MenuItemAddOverlay: TMenuItem
      Caption = 'Add Overlay...'
      OnClick = MenuItemAddOverlayClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
  end
  object PopupMenuOverlay: TPopupMenu
    Left = 456
    Top = 279
    object MenuItemSendToBack: TMenuItem
      Caption = 'Send to Back'
    end
    object MenuItemBringToFront: TMenuItem
      Caption = 'Bring to Front'
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Left = 456
    Top = 199
  end
end
