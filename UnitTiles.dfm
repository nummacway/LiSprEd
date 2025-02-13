object FormTiles: TFormTiles
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Tiles'
  ClientHeight = 384
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
  OnCreate = FormCreate
  TextHeight = 15
  object Image: TImage
    Left = 0
    Top = 0
    Width = 512
    Height = 384
    Align = alClient
    Stretch = True
    OnDragDrop = ImageDragDrop
    OnDragOver = ImageDragOver
    OnEndDrag = ImageEndDrag
    OnMouseDown = ImageMouseDown
    OnMouseLeave = ImageMouseLeave
    OnMouseMove = ImageMouseMove
    OnStartDrag = ImageStartDrag
    ExplicitLeft = 104
    ExplicitTop = 88
    ExplicitWidth = 105
    ExplicitHeight = 105
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
end
