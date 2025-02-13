unit UnitTilemaps;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, GBUtils, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.Menus, System.Actions, Vcl.ActnList;

type
  TFormTilemaps = class(TForm)
    Image0: TImage;
    Image1: TImage;
    PanelOptions: TPanel;
    Label1: TLabel;
    ComboBoxMap: TComboBox;
    LabelTile: TLabel;
    ComboBoxBank: TComboBox;
    EditTile: TEdit;
    Label3: TLabel;
    CheckBoxPriority: TCheckBox;
    Label4: TLabel;
    CheckBoxFlipY: TCheckBox;
    CheckBoxFlipX: TCheckBox;
    Label5: TLabel;
    ComboBoxCGBPaletteIndex: TComboBox;
    ToolBar: TToolBar;
    ToolButtonSelect: TToolButton;
    ToolButtonCopy: TToolButton;
    PopupMenuCopy: TPopupMenu;
    MenuItemTile: TMenuItem;
    MenuItemTileNoTile: TMenuItem;
    MenuItemTileTile: TMenuItem;
    MenuItemTileIncrementTile: TMenuItem;
    MenuItemPriority: TMenuItem;
    MenuItemYFlip: TMenuItem;
    MenuItemXFlip: TMenuItem;
    MenuItemCGBPaletteIndex: TMenuItem;
    ShapeSelection: TShape;
    ShapeHover: TShape;
    MenuItemTileDecrementTile: TMenuItem;
    ActionListHotkeys: TActionList;
    ActionUp: TAction;
    ActionDown: TAction;
    ActionLeft: TAction;
    ActionRight: TAction;
    ActionAdd: TAction;
    ActionSubtract: TAction;
    Action0: TAction;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    procedure ComboBoxMapSelect(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure EditTileChange(Sender: TObject);
    procedure EditTileExit(Sender: TObject);
    procedure ComboBoxBankSelect(Sender: TObject);
    procedure ComboBoxCGBPaletteIndexSelect(Sender: TObject);
    procedure CheckBoxPriorityClick(Sender: TObject);
    procedure CheckBoxFlipYClick(Sender: TObject);
    procedure CheckBoxFlipXClick(Sender: TObject);
    procedure ToolButtonSelectClick(Sender: TObject);
    procedure ToolButtonCopyClick(Sender: TObject);
    procedure ImageDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ImageDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ImageMouseLeave(Sender: TObject);
    procedure ActionUpExecute(Sender: TObject);
    procedure ActionDownExecute(Sender: TObject);
    procedure ActionLeftExecute(Sender: TObject);
    procedure ActionRightExecute(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionSubtractExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure ActionPalExecute(Sender: TObject);
  private
    { Private-Deklarationen }
    var
      FProject: TProject;
      LastX: Byte;
      LastY: Byte;
      LastAddr: Word;
  public
    { Public-Deklarationen }
    procedure SetProject(Project: TProject);
    procedure ShowTile(Addr: Word); overload;
    procedure ShowTile(X, Y: Byte); overload;
    procedure ProjectFullUpdate(Sender: TProject);
    procedure ProjectTileUpdate(Sender: TProject; TileAddr: Word; Bank: Boolean);
    procedure ProjectTileMapUpdate(Sender: TProject; Index, X, Y: Byte);
    procedure ProjectPaletteUpdate(Sender: TProject; IsObj: Boolean; PaletteIndex: Byte; ColorIndex: Byte);
    procedure ProjectRegisterUpdate(Sender: TProject; Registers: TRegisters);
  end;

var
  FormTilemaps: TFormTilemaps;

implementation

{$R *.dfm}

uses
  ClassHelpers;

{ TFormTilemaps }

procedure TFormTilemaps.ActionAddExecute(Sender: TObject);
begin
  EditTile.Text := IntToStr((StrToInt(EditTile.Text) + 1) mod 256);
end;

procedure TFormTilemaps.ActionDownExecute(Sender: TObject);
begin
  ShowTile(LastX, (LastY + 1) mod 32);
end;

procedure TFormTilemaps.ActionLeftExecute(Sender: TObject);
begin
  ShowTile((LastX + 31) mod 32, LastY);
end;

procedure TFormTilemaps.ActionPalExecute(Sender: TObject);
begin
  ComboBoxCGBPaletteIndex.ItemIndex := (Sender as TComponent).Tag;
  ComboBoxCGBPaletteIndexSelect(ComboBoxCGBPaletteIndex);
end;

procedure TFormTilemaps.ActionRightExecute(Sender: TObject);
begin
  ShowTile((LastX + 1) mod 32, LastY);
end;

procedure TFormTilemaps.ActionSubtractExecute(Sender: TObject);
begin
  EditTile.Text := IntToStr((StrToInt(EditTile.Text) + 255) mod 256);
end;

procedure TFormTilemaps.ActionUpExecute(Sender: TObject);
begin
  ShowTile(LastX, (LastY + 31) mod 32);
end;

procedure TFormTilemaps.CheckBoxFlipXClick(Sender: TObject);
begin
  FProject.VRAM1Maps[LastAddr].XFlip := CheckBoxFlipX.Checked;
  FProject.UpdateTileMapCacheByLocation(ComboBoxMap.ItemIndex, LastX, LastY);
  FProject.TriggerTileMapUpdate(ComboBoxMap.ItemIndex, LastX, LastY);
end;

procedure TFormTilemaps.CheckBoxFlipYClick(Sender: TObject);
begin
  FProject.VRAM1Maps[LastAddr].YFlip := CheckBoxFlipY.Checked;
  FProject.UpdateTileMapCacheByLocation(ComboBoxMap.ItemIndex, LastX, LastY);
  FProject.TriggerTileMapUpdate(ComboBoxMap.ItemIndex, LastX, LastY);
end;

procedure TFormTilemaps.CheckBoxPriorityClick(Sender: TObject);
begin
  FProject.VRAM1Maps[LastAddr].Priority := CheckBoxPriority.Checked;
  FProject.UpdateTileMapCacheByLocation(ComboBoxMap.ItemIndex, LastX, LastY);
  FProject.TriggerTileMapUpdate(ComboBoxMap.ItemIndex, LastX, LastY);
end;

procedure TFormTilemaps.ComboBoxBankSelect(Sender: TObject);
begin
  FProject.VRAM1Maps[LastAddr].Bank := ComboBoxBank.ItemIndex = 1;
  FProject.UpdateTileMapCacheByLocation(ComboBoxMap.ItemIndex, LastX, LastY);
  FProject.TriggerTileMapUpdate(ComboBoxMap.ItemIndex, LastX, LastY);
end;

procedure TFormTilemaps.ComboBoxCGBPaletteIndexSelect(Sender: TObject);
begin
  FProject.VRAM1Maps[LastAddr].CGBPaletteIndex := ComboBoxCGBPaletteIndex.ItemIndex;
  FProject.UpdateTileMapCacheByLocation(ComboBoxMap.ItemIndex, LastX, LastY);
  FProject.TriggerTileMapUpdate(ComboBoxMap.ItemIndex, LastX, LastY);
end;

procedure TFormTilemaps.ComboBoxMapSelect(Sender: TObject);
begin
  Image0.Visible := ComboBoxMap.ItemIndex = 0;
  Image1.Visible := ComboBoxMap.ItemIndex = 1;
  ShowTile(LastX, LastY);
end;

procedure TFormTilemaps.ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ShapeHover.Left := (X * 32 div Image0.Width) * Image1.Width div 32;
  ShapeHover.Top := Image1.Top + (Y * 32 div Image0.Height) * Image1.Height div 32;
  ShapeHover.Show();
end;

procedure TFormTilemaps.EditTileChange(Sender: TObject);
begin
  FProject.VRAM0Maps[LastAddr] := StrToIntDef(EditTile.Text, FProject.VRAM0Maps[LastAddr]);
  FProject.UpdateTileMapCacheByLocation(ComboBoxMap.ItemIndex, LastX, LastY);
  FProject.TriggerTileMapUpdate(ComboBoxMap.ItemIndex, LastX, LastY);
end;

procedure TFormTilemaps.EditTileExit(Sender: TObject);
begin
  ShowTile(LastAddr);
end;

procedure TFormTilemaps.FormActivate(Sender: TObject);
begin
  ActionListHotkeys.State := asNormal;
end;

procedure TFormTilemaps.FormDeactivate(Sender: TObject);
begin
  ActionListHotkeys.State := asSuspended;
end;

procedure TFormTilemaps.ImageMouseLeave(Sender: TObject);
begin
  ShapeHover.Hide();
end;

procedure TFormTilemaps.ImageDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  Addr: Word;
begin
  X := X * 32 div Image0.Width;
  Y := Y * 32 div Image0.Height;

  Addr := $9800 + ComboBoxMap.ItemIndex * $400 + Y shl 5 + X;

  FProject.VRAM0Maps[Addr] := Byte(FProject.DnDData div 16);
  FProject.VRAM1Maps[Addr].Bank := FProject.DnDData2;

  FProject.UpdateTileMapCacheByLocation(ComboBoxMap.ItemIndex, X, Y);
  FProject.TriggerTileMapUpdate(ComboBoxMap.ItemIndex, X, Y);
end;

procedure TFormTilemaps.ImageDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if FProject.DnDType = ddTile then
  if FProject.LCDC.BGWindowTiles then
  Accept := FProject.DnDData < $9000
  else
  Accept := FProject.DnDData >= $8800;

  ImageMouseMove(Sender, [], X, Y);
end;

procedure TFormTilemaps.ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Addr: Word;
begin
  X := X * 32 div Image0.Width;
  Y := Y * 32 div Image0.Height;

  Addr := $9800 + ComboBoxMap.ItemIndex * $400 + Y shl 5 + X;

  if (not ToolButtonSelect.Down) or (Button = mbRight) then
  begin
    if MenuItemTileTile.Checked then
    begin
      FProject.VRAM0Maps[Addr] := FProject.VRAM0Maps[LastAddr];
      FProject.VRAM1Maps[Addr].Bank := FProject.VRAM1Maps[LastAddr].Bank;
    end;
    if MenuItemTileIncrementTile.Checked then
    begin
      FProject.VRAM0Maps[Addr] := Byte(FProject.VRAM0Maps[LastAddr] + 1);
      if (FProject.VRAM0Maps[Addr] = 0) and (FProject.IsCGB) then // overflowed
      FProject.VRAM1Maps[Addr].Bank := not FProject.VRAM1Maps[LastAddr].Bank
      else
      FProject.VRAM1Maps[Addr].Bank := FProject.VRAM1Maps[LastAddr].Bank;
    end;
    if MenuItemTileDecrementTile.Checked then
    begin
      FProject.VRAM0Maps[Addr] := Byte(FProject.VRAM0Maps[LastAddr] - 1);
      if (FProject.VRAM0Maps[Addr] = 255) and (FProject.IsCGB) then // underflowed
      FProject.VRAM1Maps[Addr].Bank := not FProject.VRAM1Maps[LastAddr].Bank
      else
      FProject.VRAM1Maps[Addr].Bank := FProject.VRAM1Maps[LastAddr].Bank;
    end;

    if MenuItemPriority.Checked then
    FProject.VRAM1Maps[Addr].Priority := FProject.VRAM1Maps[LastAddr].Priority;
    if MenuItemYFlip.Checked then
    FProject.VRAM1Maps[Addr].YFlip := FProject.VRAM1Maps[LastAddr].YFlip;
    if MenuItemXFlip.Checked then
    FProject.VRAM1Maps[Addr].XFlip := FProject.VRAM1Maps[LastAddr].XFlip;
    if MenuItemCGBPaletteIndex.Checked then
    FProject.VRAM1Maps[Addr].CGBPaletteIndex := FProject.VRAM1Maps[LastAddr].CGBPaletteIndex;

    FProject.UpdateTileMapCacheByLocation(ComboBoxMap.ItemIndex, X, Y);
    FProject.TriggerTileMapUpdate(ComboBoxMap.ItemIndex, X, Y);
  end;

  ShowTile(Addr);
end;

procedure TFormTilemaps.ProjectFullUpdate(Sender: TProject);
begin
  Image0.Picture.Graphic := Sender.TileMapImages[0];
  Image1.Picture.Graphic := Sender.TileMapImages[1];
end;

procedure TFormTilemaps.ProjectPaletteUpdate(Sender: TProject; IsObj: Boolean; PaletteIndex, ColorIndex: Byte);
begin
  Image0.Picture.Graphic := Sender.TileMapImages[0];
  Image1.Picture.Graphic := Sender.TileMapImages[1];
end;

procedure TFormTilemaps.ProjectRegisterUpdate(Sender: TProject; Registers: TRegisters);
begin
  Image0.Picture.Graphic := Sender.TileMapImages[0];
  Image1.Picture.Graphic := Sender.TileMapImages[1];
end;

procedure TFormTilemaps.ProjectTileMapUpdate(Sender: TProject; Index, X, Y: Byte);
begin
  Image0.Picture.Graphic := Sender.TileMapImages[0];
  Image1.Picture.Graphic := Sender.TileMapImages[1];
end;

procedure TFormTilemaps.ProjectTileUpdate(Sender: TProject; TileAddr: Word; Bank: Boolean);
begin
  Image0.Picture.Graphic := Sender.TileMapImages[0];
  Image1.Picture.Graphic := Sender.TileMapImages[1];
end;

procedure TFormTilemaps.SetProject(Project: TProject);
begin
  FProject := Project;
  Project.TileUpdateEvents.Add(ProjectTileUpdate);
  Project.TileMapUpdateEvents.Add(ProjectTileMapUpdate);
  Project.FullUpdateEvents.Add(ProjectFullUpdate);
  Project.PaletteUpdateEvents.Add(ProjectPaletteUpdate);
  Project.RegisterUpdateEvents.Add(ProjectRegisterUpdate);
  ComboBoxMapSelect(nil);
end;

procedure TFormTilemaps.ShowTile(X, Y: Byte);
begin
  ShowTile($9800 + ComboBoxMap.ItemIndex * $400 + Y shl 5 + X);
end;

procedure TFormTilemaps.ShowTile(Addr: Word);
begin
  ComboBoxBank.ItemIndex := Byte(FProject.VRAM1Maps[Addr].Bank);
  EditTile.TextNoChange := IntToStr(FProject.VRAM0Maps[Addr]);
  CheckBoxPriority.CheckedNoClick := FProject.VRAM1Maps[Addr].Priority;
  CheckBoxFlipY.CheckedNoClick := FProject.VRAM1Maps[Addr].YFlip;
  CheckBoxFlipX.CheckedNoClick := FProject.VRAM1Maps[Addr].XFlip;
  ComboBoxCGBPaletteIndex.ItemIndex := FProject.VRAM1Maps[Addr].CGBPaletteIndex;
  LastAddr := Addr;
  LastX := Addr and $1f;
  LastY := (Addr shr 5) and $1f;
  LabelTile.Caption := 'Tile ' + IntToStr(LastX) + ':' + IntToStr(LastY) + ':';
  ShapeSelection.Left := LastX * Image1.Width div 32;
  ShapeSelection.Top := Image1.Top + LastY * Image1.Height div 32;
end;

procedure TFormTilemaps.ToolButtonCopyClick(Sender: TObject);
begin
  ToolButtonSelect.Down := False;
  ToolBar.Perform(1027, ToolButtonCopy.Index, 1);
end;

procedure TFormTilemaps.ToolButtonSelectClick(Sender: TObject);
begin
  ToolButtonSelect.Down := True;
  ToolButtonCopy.Down := False;
end;

end.
