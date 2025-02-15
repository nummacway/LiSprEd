object FormFiles: TFormFiles
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Files'
  ClientHeight = 320
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Visible = True
  TextHeight = 15
  object ListView: TListView
    Left = 0
    Top = 32
    Width = 512
    Height = 288
    Align = alClient
    Columns = <
      item
        Caption = 'File Name'
        Width = 200
      end
      item
        Caption = 'Type'
        Width = 64
      end
      item
        Alignment = taRightJustify
        Caption = 'File'#39's Offset'
        Width = 85
      end
      item
        Alignment = taRightJustify
        Caption = 'GB Offset'
        Width = 85
      end
      item
        Alignment = taRightJustify
        Caption = 'Pieces'
        Width = 45
      end>
    DoubleBuffered = True
    DragMode = dmAutomatic
    ReadOnly = True
    RowSelect = True
    ParentDoubleBuffered = False
    TabOrder = 0
    ViewStyle = vsReport
    OnEndDrag = ListViewEndDrag
    OnDragDrop = ListViewDragDrop
    OnDragOver = ListViewDragOver
    OnSelectItem = ListViewSelectItem
    OnStartDrag = ListViewStartDrag
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 512
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object ButtonLoad: TButton
      Left = 4
      Top = 4
      Width = 80
      Height = 24
      Caption = 'Add File...'
      DropDownMenu = PopupMenu
      Style = bsSplitButton
      TabOrder = 0
      OnClick = ButtonLoadClick
    end
    object ButtonNew: TButton
      Left = 88
      Top = 4
      Width = 80
      Height = 24
      Caption = 'New File...'
      TabOrder = 1
      OnClick = ButtonNewClick
    end
    object ButtonEdit: TButton
      Left = 172
      Top = 4
      Width = 80
      Height = 24
      Caption = 'Edit Offsets...'
      TabOrder = 2
      OnClick = ButtonEditClick
    end
    object ButtonRemove: TButton
      Left = 340
      Top = 4
      Width = 80
      Height = 24
      Caption = 'Remove File'
      TabOrder = 4
      OnClick = ButtonRemoveClick
    end
    object ButtonReload: TButton
      Left = 432
      Top = 4
      Width = 80
      Height = 24
      Caption = 'Reload Files'
      TabOrder = 5
      OnClick = ButtonReloadClick
    end
    object ButtonSaveAs: TButton
      Left = 256
      Top = 4
      Width = 80
      Height = 24
      Caption = 'Save As...'
      TabOrder = 3
      OnClick = ButtonSaveAsClick
    end
  end
  object OpenDialog: TOpenDialog
    Left = 144
    Top = 160
  end
  object PopupMenu: TPopupMenu
    Left = 48
    Top = 120
    object MenuItemAutoAddEmuliciousExports: TMenuItem
      Caption = 'Auto-Add Emulicious Exports...'
      OnClick = MenuItemAutoAddEmuliciousExportsClick
    end
  end
  object OpenDialogEmulicious: TOpenDialog
    Filter = 
      'Emulicious Exports|*.vrm;*.pal;*.bin|VRAM|*.vrm|PAL|*.pal|OAM|*.' +
      'bin'
    Left = 96
    Top = 256
  end
  object SaveDialog: TSaveDialog
    Left = 280
    Top = 152
  end
end
