unit UnitPreview;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, GBUtils, pngimage,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.Menus, Vcl.ExtDlgs, Generics.Collections,
  Vcl.StdCtrls;

type
  TFormPreview = class(TForm)
    PanelOptions: TPanel;
    ScrollBox: TScrollBox;
    Image: TImage;
    ShapeOAM: TShape;
    ToolBar: TToolBar;
    ToolButtonDraw: TToolButton;
    ToolButtonColorPicker: TToolButton;
    ToolButtonOverlays: TToolButton;
    PopupMenuOverlays: TPopupMenu;
    MenuItemAddOverlay: TMenuItem;
    N1: TMenuItem;
    PopupMenuOverlay: TPopupMenu;
    MenuItemSendToBack: TMenuItem;
    MenuItemBringToFront: TMenuItem;
    OpenPictureDialog: TOpenPictureDialog;
    ShapeResize: TShape;
    CheckBoxOverlays: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ImageDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ImageMouseLeave(Sender: TObject);
    procedure ImageDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure MenuItemOverlayClick(Sender: TObject);
    procedure OverlayMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OverlayStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure OverlayEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ShapeResizeStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure CheckBoxOverlaysClick(Sender: TObject);
    procedure ToolButtonOverlaysClick(Sender: TObject);
    procedure ToolButtonColorPickerClick(Sender: TObject);
    procedure ToolButtonDrawClick(Sender: TObject);
    procedure MenuItemAddOverlayClick(Sender: TObject);
    procedure ShapeResizeEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private-Deklarationen }
    procedure UpdateLine(LY: Integer);
    procedure AddOverlay(Index: Integer);
    procedure UpdateOverlaySize(Index: Integer);
    procedure AddMenuItem(Index: Integer);
    procedure SetOverlaysEnabled(Value: Boolean);
    function GetBGTileAddr(var X, Y: Byte; out Attributes: TTileAttributes): Word;
    var
      FProject: TProject;
      Overlays: TObjectList<TImage>;
      OverlaysEnabled: Boolean;
      MenuItems: TObjectList<TMenuItem>;
      ZoomLevel: Byte;
      OverlayIndex: Integer;
      OverlayDragX: Integer;
      OverlayDragY: Integer;
      IsDrawing: Boolean;
      IsDrawingButton: TMouseButton;
  public
    { Public-Deklarationen }
    procedure ProjectFullUpdate(Sender: TProject);
    procedure ProjectTileUpdate(Sender: TProject; TileAddr: Word; Bank: Boolean);
    procedure ProjectTileMapUpdate(Sender: TProject; Index, X, Y: Byte);
    procedure ProjectOAMUpdate(Sender: TProject; OAMIndex: Byte);
    procedure ProjectPaletteUpdate(Sender: TProject; IsObj: Boolean; PaletteIndex: Byte; ColorIndex: Byte);
    procedure ProjectRegisterUpdate(Sender: TProject; Registers: TRegisters);
    procedure SetProject(Project: TProject);
    procedure ArrangeOverlays();
    procedure RecreateAllOverlays();
    procedure UpdateOverlaysMenu();
  end;

var
  FormPreview: TFormPreview;

implementation

{$R *.dfm}

uses
  MMSystem, Math, UnitPalettes;

{ TFormPreview }

procedure TFormPreview.AddMenuItem(Index: Integer);
var
  MI: TMenuItem;
begin
  MI := TMenuItem.Create(Self);
  MenuItems.Add(MI);
  PopupMenuOverlays.Items.Add(MI);

  MI.Caption := StringReplace(ExtractFileName(FProject.Overlays[Index].FileName), '&', '&&', [rfReplaceAll]);
  MI.OnClick := MenuItemOverlayClick;
  MI.Tag := Index;
end;

procedure TFormPreview.AddOverlay(Index: Integer);
var
  Image: TImage;
  Overlay: TOverlay;
begin
  Image := TImage.Create(Self);
  try
    Overlay := FProject.Overlays[Index];
    Image.Picture.LoadFromFile(Overlay.FileName);
    Image.Stretch := True;
    Image.Tag := Index;
    Image.Parent := ScrollBox;
    Image.OnStartDrag := OverlayStartDrag;
    Image.OnEndDrag := OverlayEndDrag;
    Image.OnMouseDown := OverlayMouseDown;
    Image.DragCursor := crSize;
    Image.Enabled := OverlaysEnabled;
    UpdateOverlaySize(Overlays.Add(Image));
    ShapeResize.BringToFront();
  except
    Image.Free();
    raise;
  end;
end;

procedure TFormPreview.ArrangeOverlays;
var
  Image: TImage;
begin
  for Image in Overlays do
  begin
    Image.BringToFront();
    Image.Left := ZoomLevel * FProject.Overlays[Image.Tag].Bounds.Left - ScrollBox.HorzScrollBar.Position;
    Image.Top := ZoomLevel * FProject.Overlays[Image.Tag].Bounds.Top - ScrollBox.VertScrollBar.Position;
    Image.Width := ZoomLevel * FProject.Overlays[Image.Tag].Bounds.Width;
    Image.Height := ZoomLevel * FProject.Overlays[Image.Tag].Bounds.Height;
  end;
  ShapeResize.BringToFront();
  //if ShapeResize.Visible then
  begin
    ShapeResize.Left := Overlays[OverlayIndex].Left + Overlays[OverlayIndex].Width - ShapeResize.Width;
    ShapeResize.Top := Overlays[OverlayIndex].Top + Overlays[OverlayIndex].Height - ShapeResize.Height;
  end;
end;

procedure TFormPreview.CheckBoxOverlaysClick(Sender: TObject);
var
  Image: TImage;
  Value: Boolean;
begin
  Value := CheckBoxOverlays.Checked;
  for Image in Overlays do
  Image.Visible := Value;
end;

procedure TFormPreview.FormCreate(Sender: TObject);
var
  PNG: TPNGImage;
begin
  PNG := TPngImage.CreateBlank(COLOR_PALETTE, 8, 160, 144);
  try
    Image.Picture.Assign(PNG);
  finally
    PNG.Free();
  end;
  ZoomLevel := 4;

  Overlays := TObjectList<TImage>.Create();
  MenuItems := TObjectList<TMenuItem>.Create(True);
end;

procedure TFormPreview.ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if GetAsyncKeyState(VK_CONTROL) < 0 then
  begin
    Handled := True;
    if WheelDelta < 0 then
    ZoomLevel := Max(1, ZoomLevel - 1)
    else
    ZoomLevel := Min(100, ZoomLevel + 1);
    Image.Width := 160 * ZoomLevel;
    Image.Height := 144 * ZoomLevel;
    ArrangeOverlays();
  end;
end;

procedure TFormPreview.SetOverlaysEnabled(Value: Boolean);
var
  Image: TImage;
begin
  OverlaysEnabled := Value;
  for Image in Overlays do
  Image.Enabled := Value;
  ShapeResize.Enabled := Value;
end;

procedure TFormPreview.SetProject(Project: TProject);
begin
  FProject := Project;
  Project.TileUpdateEvents.Add(ProjectTileUpdate);
  Project.TileMapUpdateEvents.Add(ProjectTileMapUpdate);
  Project.OAMUpdateEvents.Add(ProjectOAMUpdate);
  Project.FullUpdateEvents.Add(ProjectFullUpdate);
  Project.PaletteUpdateEvents.Add(ProjectPaletteUpdate);
  Project.RegisterUpdateEvents.Add(ProjectRegisterUpdate);

  RecreateAllOverlays();
  UpdateOverlaysMenu();
end;

procedure TFormPreview.ShapeResizeEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  SetOverlaysEnabled(True);
  FProject.DnDType := ddNone;
end;

procedure TFormPreview.ShapeResizeStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  SetOverlaysEnabled(False);
  FProject.DnDType := ddOverlayResize;
end;

procedure TFormPreview.ToolButtonColorPickerClick(Sender: TObject);
begin
  ToolButtonOverlays.Down := False;
  ShapeResize.Hide();
  CheckBoxOverlays.Enabled := True;
end;

procedure TFormPreview.ToolButtonDrawClick(Sender: TObject);
begin
  ToolButtonOverlays.Down := False;
  ShapeResize.Hide();
  CheckBoxOverlays.Enabled := True;
end;

procedure TFormPreview.ToolButtonOverlaysClick(Sender: TObject);
begin
  ToolButtonDraw.Down := False;
  ToolButtonColorPicker.Down := False;
  ToolBar.Perform(1027, ToolButtonOverlays.Index, 1);
  CheckBoxOverlays.Checked := True;
  //ShapeResize.Show();
  CheckBoxOverlays.Enabled := False;
  SetOverlaysEnabled(True);
end;

function TFormPreview.GetBGTileAddr(var X, Y: Byte; out Attributes: TTileAttributes): Word;
var
  TileMapAddr: Word;
  Tile: Byte;
begin
  if (Y >= FProject.WY) and (X+7 >= FProject.WX) and (FProject.LCDC.WindowEnable) then
  begin
    Y := Y - FProject.WY;
    X := X - FProject.WX + 7;

    TileMapAddr := $9800 + Byte(FProject.LCDC.WindowTileMap) * $400;
  end
  else
  begin
    Y := Byte(Y + FProject.SCY);
    X := Byte(X + FProject.SCX);

    TileMapAddr := $9800 + Byte(FProject.LCDC.BGTileMap) * $400;
  end;

  TileMapAddr := TileMapAddr or ((Y div 8) shl 5) or (X div 8);

  Attributes := FProject.VRAM1Maps[TileMapAddr];
  Tile := FProject.VRAM0Maps[TileMapAddr];

  if FProject.LCDC.BGWindowTiles then
  Result := $8000 + 16 * Tile
  else
  Result := $9000 + 16 * ShortInt(Tile);

  Y := Y mod 8;
  X := X mod 8;
end;

procedure TFormPreview.ImageDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if FProject.DnDType = ddOAM then
  begin
    FProject.OAM.OAM[FProject.DnDData].X := X * 160 div Image.Width + 8;
    FProject.OAM.OAM[FProject.DnDData].Y := Y * 144 div Image.Height + 16;
    FProject.TriggerOAMUpdate(FProject.DnDData);
    ShapeOAM.Hide();
  end;
end;

procedure TFormPreview.ImageDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  TempOverlay: TOverlay;
begin
  Accept := False;
  if FProject.DnDType = ddOAM then
  begin
    ShapeOAM.Left := X * 160 div Image.Width * ZoomLevel - ScrollBox.HorzScrollBar.Position;
    ShapeOAM.Top := Y * 144 div Image.Height * ZoomLevel - ScrollBox.VertScrollBar.Position;
    ShapeOAM.Show();
    Accept := True;
  end
  else
  if FProject.DnDType = ddOverlayMove then
  begin
    TempOverlay := FProject.Overlays[OverlayIndex];
    TempOverlay.Bounds.Location := Point(Max(0, (X - OverlayDragX) div ZoomLevel), Max(0, (Y - OverlayDragY) div ZoomLevel));
    FProject.Overlays[OverlayIndex] := TempOverlay;
    UpdateOverlaySize(OverlayIndex);
    Accept := True;
  end
  else
  if FProject.DnDType = ddOverlayResize then
  begin
    TempOverlay := FProject.Overlays[OverlayIndex];
    TempOverlay.Bounds.Width := Max(0, (X - Overlays[OverlayIndex].Left) div ZoomLevel);
    TempOverlay.Bounds.Height := Max(0, (Y - Overlays[OverlayIndex].Top) div ZoomLevel);
    ShapeResize.Left := Overlays[OverlayIndex].Left + Overlays[OverlayIndex].Width - ShapeResize.Width;
    ShapeResize.Top := Overlays[OverlayIndex].Top + Overlays[OverlayIndex].Height - ShapeResize.Height;
    FProject.Overlays[OverlayIndex] := TempOverlay;
    UpdateOverlaySize(OverlayIndex);
    Accept := True;
  end;
end;

procedure TFormPreview.ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  OAMs: TArray<Byte>;
  OAMIndex: Byte;
  PaletteIndex: Byte;
  ColorValue: Byte;
  IsObj: Boolean;
  X2, Y2: Byte;
  Attributes: TTileAttributes;
  Addr: Word;
  PNG: TPngImage;
  Pixel: PByte;
begin
  X := X * 160 div Image.Width;
  Y := Y * 144 div Image.Height;
  if not InRange(X, 0, 159) then
  Exit;
  if not InRange(Y, 0, 143) then
  Exit;

  if (ToolButtonColorPicker.Down) or (GetAsyncKeyState(VK_CONTROL) < 0) then
  begin
    Pixel := (Image.Picture.Graphic as TPngImage).Scanline[Y];
    Inc(Pixel, X);

    if Button = mbLeft then
    begin
      ForegroundIndex := Pixel^;
      ForegroundIsTrans := False; // cannot be set by this
      ForegroundIsObj := TProject.PalIndexToIsObj[Pixel^];
      ForegroundPaletteIndex := TProject.PalIndexToPaletteIndex[Pixel^];
      ForegroundColorIndex := TProject.PalIndexToColorIndex[Pixel^];
    end
    else
    if Button = mbRight then
    begin
      BackgroundIndex := Pixel^;
      BackgroundIsTrans := False;
      BackgroundIsObj := TProject.PalIndexToIsObj[Pixel^];
      BackgroundPaletteIndex := TProject.PalIndexToPaletteIndex[Pixel^];
      BackgroundColorIndex := TProject.PalIndexToColorIndex[Pixel^];
    end;

    FormPalettes.UpdateSelection();

    ToolButtonDraw.Down := True;

    Exit;
  end;

  if ToolButtonDraw.Down then
  begin
    IsDrawing := True;
    IsDrawingButton := Button;
    if Button = mbLeft then
    begin
      IsObj := ForegroundIsObj or ForegroundIsTrans;
      PaletteIndex := ForegroundPaletteIndex;
      ColorValue := ForegroundIndex;
    end
    else
    if Button = mbRight then
    begin
      IsObj := BackgroundIsObj or BackgroundIsTrans;
      PaletteIndex := BackgroundPaletteIndex;
      ColorValue := BackgroundIndex;
    end
    else
    Exit;

    if not IsObj then
    begin
      X2 := X;
      Y2 := Y;
      Addr := GetBGTileAddr(X2, Y2, Attributes);

      if FProject.IsCGB then
      if PaletteIndex <> Attributes.CGBPaletteIndex then
      begin
        PlaySound('SYSTEMASTERISK', 0, SND_ASYNC);
        Exit;
      end;

      PNG := TPngImage.CreateBlank(COLOR_PALETTE, 8, 8, 8);
      try
        FProject.ReadFromTile(PNG, 0, 0, Addr, Attributes.Bank and FProject.IsCGB, [1, 2, 3, 4], Attributes.XFlip and FProject.IsCGB, Attributes.YFlip and FProject.IsCGB);
        Pixel := PNG.Scanline[Y2];
        Inc(Pixel, X2);
        if Pixel^ <> ColorValue then
        begin
          Pixel^ := ColorValue;
          FProject.WriteToTile(PNG, 0, 0, Addr, Attributes.Bank and FProject.IsCGB, Attributes.XFlip and FProject.IsCGB, Attributes.YFlip and FProject.IsCGB);
          FProject.UpdateTileMapCacheByTileAddr(Addr, Attributes.Bank);
          if Addr < $9000 then
          FProject.UpdateOAMCacheByTile(Byte(Addr div 16), Attributes.Bank, True);
          FProject.TriggerTileUpdate(Addr, Attributes.Bank and FProject.IsCGB);
        end;
        ColorValue := 0; // make overlapping OBJs transparent now
      finally
        PNG.Free();
      end;
    end;

    OAMs := FProject.GetOAMs(Y);
    for OAMIndex in OAMs do
    if InRange(X + 8 - FProject.OAM.OAM[OAMIndex].X, 0, 7) then
    begin
      Pixel := FProject.OAMImages[OAMIndex].Scanline[Y + 16 - FProject.OAM.OAM[OAMIndex].Y];
      Inc(Pixel, X + 8 - FProject.OAM.OAM[OAMIndex].X);

      try
        if ColorValue <> 0 then
        if FProject.IsCGB then
        begin
          if FProject.OAM.OAM[OAMIndex].Attributes.CGBPaletteIndex = PaletteIndex then
          begin
            Pixel^ := ColorValue;
            ColorValue := 0; // if more than one tile is applicable, only paint the topmost
            Continue;
          end;
        end
        else
        begin
          if Byte(FProject.OAM.OAM[OAMIndex].Attributes.DMGPaletteIndex) = PaletteIndex then
          begin
            Pixel^ := ColorValue;
            ColorValue := 0; // same
            Continue;
          end;
        end;
        Pixel^ := 0
      finally
        FProject.WriteOAMCacheByIndex(OAMIndex);
        FProject.UpdateOAMCacheByTile(FProject.OAM.OAM[OAMIndex].Tile, FProject.OAM.OAM[OAMIndex].Attributes.Bank and FProject.IsCGB, True);
        if FProject.LCDC.OBJSize then
        begin
          FProject.TriggerTileUpdate(FProject.OAM.OAM[OAMIndex].Tile and $FE, True, FProject.OAM.OAM[OAMIndex].Attributes.Bank and FProject.IsCGB);
          FProject.TriggerTileUpdate(FProject.OAM.OAM[OAMIndex].Tile or 1, True, FProject.OAM.OAM[OAMIndex].Attributes.Bank and FProject.IsCGB);
          FProject.UpdateTileMapCacheByTileAddr($8000 + 16 * (FProject.OAM.OAM[OAMIndex].Tile and $FE), FProject.OAM.OAM[OAMIndex].Attributes.Bank);
          FProject.UpdateTileMapCacheByTileAddr($8000 + 16 * (FProject.OAM.OAM[OAMIndex].Tile or 1), FProject.OAM.OAM[OAMIndex].Attributes.Bank);
        end
        else
        begin
          FProject.TriggerTileUpdate(FProject.OAM.OAM[OAMIndex].Tile, True, FProject.OAM.OAM[OAMIndex].Attributes.Bank and FProject.IsCGB);
          FProject.UpdateTileMapCacheByTileAddr($8000 + 16 * FProject.OAM.OAM[OAMIndex].Tile, FProject.OAM.OAM[OAMIndex].Attributes.Bank);
        end;
      end;
    end;
  end;
end;

procedure TFormPreview.ImageMouseLeave(Sender: TObject);
begin
  ShapeOAM.Hide();
end;

procedure TFormPreview.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if IsDrawing then
  ImageMouseDown(Sender, IsDrawingButton, Shift, X, Y);
end;

procedure TFormPreview.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsDrawing := False;
end;

procedure TFormPreview.MenuItemAddOverlayClick(Sender: TObject);
var
  TempOverlay: TOverlay;
begin
  if OpenPictureDialog.Execute() then
  begin
    TempOverlay.FileName := OpenPictureDialog.FileName;
    TempOverlay.Bounds := TRect.Empty();
    AddOverlay(FProject.Overlays.Add(TempOverlay));
    TempOverlay.Bounds.Width := Image.Picture.Width;
    TempOverlay.Bounds.Height := Image.Picture.Height;
    FProject.Overlays[FProject.Overlays.Count - 1] := TempOverlay;
    AddMenuItem(FProject.Overlays.Count - 1);
    ArrangeOverlays();
  end;
end;

procedure TFormPreview.MenuItemOverlayClick(Sender: TObject);
begin
  FProject.Overlays.Delete((Sender as TMenuItem).Tag);
  Overlays.Delete((Sender as TMenuItem).Tag);
  MenuItems.Delete((Sender as TMenuItem).Tag);
  ShapeResize.Hide();
end;

procedure TFormPreview.OverlayStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  SetOverlaysEnabled(False);
  FProject.DnDType := ddOverlayMove;
  ShapeResize.Hide();
end;

procedure TFormPreview.OverlayEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  SetOverlaysEnabled(True);
  FProject.DnDType := ddNone;
  ShapeResize.Left := (Sender as TImage).Left + (Sender as TImage).Width - ShapeResize.Width;
  ShapeResize.Top := (Sender as TImage).Top + (Sender as TImage).Height - ShapeResize.Height;
  ShapeResize.Show();
end;

procedure TFormPreview.OverlayMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  OverlayIndex := (Sender as TImage).Tag;
  ShapeResize.Left := (Sender as TImage).Left + (Sender as TImage).Width - ShapeResize.Width;
  ShapeResize.Top := (Sender as TImage).Top + (Sender as TImage).Height - ShapeResize.Height;
  ShapeResize.Show();
  OverlayDragX := X;
  OverlayDragY := Y;
  (Sender as TImage).BeginDrag(False);
end;

procedure TFormPreview.ProjectFullUpdate(Sender: TProject);
var
  i: Integer;
begin
  (Image.Picture.Graphic as TPNGImage).Palette := Sender.TileMapImages[0].Palette;
  for i := 0 to 143 do
  UpdateLine(i);
  ShapeOAM.Width := 8 * ZoomLevel;
  ShapeOAM.Height := (1 + Byte(Sender.LCDC.OBJSize)) * 8 * ZoomLevel;
end;

procedure TFormPreview.ProjectOAMUpdate(Sender: TProject; OAMIndex: Byte);
begin
  ProjectFullUpdate(Sender); // should be optimized
end;

procedure TFormPreview.ProjectPaletteUpdate(Sender: TProject; IsObj: Boolean; PaletteIndex, ColorIndex: Byte);
begin
  if FProject.IsCGB then
  begin
    (Image.Picture.Graphic as TPNGImage).Palette := Sender.TileMapImages[0].Palette;
    Image.Picture.Graphic := Image.Picture.Graphic;
  end;
end;

procedure TFormPreview.ProjectRegisterUpdate(Sender: TProject; Registers: TRegisters);
begin
  if rgLCDC in Registers then
  begin
    ShapeOAM.Width := 8 * ZoomLevel;
    ShapeOAM.Height := (1 + Byte(Sender.LCDC.OBJSize)) * 8 * ZoomLevel;
  end;

  if Registers - [rgBGP, rgOBP0, rgOBP1] = [] then // just palette changes
  if FProject.IsCGB then // ignore DMG palette changes in CGB mode
  Exit
  else
  begin
    (Image.Picture.Graphic as TPNGImage).Palette := Sender.TileMapImages[0].Palette;
    Image.Invalidate();
  end
  else
  ProjectFullUpdate(Sender);
end;

procedure TFormPreview.ProjectTileMapUpdate(Sender: TProject; Index, X, Y: Byte);
begin
  ProjectFullUpdate(Sender); // should be optimized
end;

procedure TFormPreview.ProjectTileUpdate(Sender: TProject; TileAddr: Word; Bank: Boolean);
begin
  ProjectFullUpdate(Sender); // should be optimized
end;

procedure TFormPreview.RecreateAllOverlays;
var
  i: Integer;
begin
  Overlays.Clear();
  for i := 0 to FProject.Overlays.Count - 1 do
  AddOverlay(i);
end;

procedure TFormPreview.UpdateLine(LY: Integer);
var
  WinTileMap, BGTileMap: TPNGImage;
  WinX: Integer;
  x, i: Integer;
  OAMs: TArray<Byte>;
  OAMXs: TArray<Integer>;
  OAMXMaxs: TArray<Integer>;
  OAMPs: TArray<PByte>;
  OAM: Byte;
  Pixel: PByte;
  HasOBJPixel: Boolean;
  WinOffset, BGOffset: Word;
  WinY, BGY: Integer;
  WinTileY, BGTileX, BGTileY: Integer;
  BGPixelOffset, WinPixelOffset, BGPixel: PByte;
  BGPriority, BGPriorityColor: Boolean;
begin
  WinTileMap := FProject.TileMapImages[Byte(FProject.LCDC.WindowTileMap)];
  WinOffset := $9800 + 32*32*Byte(FProject.LCDC.WindowTileMap);
  BGTileMap := FProject.TileMapImages[Byte(FProject.LCDC.BGTileMap)];
  BGOffset := $9800 + 32*32*Byte(FProject.LCDC.BGTileMap);

  WinX := 255;
  if FProject.LCDC.WindowEnable then
  if FProject.WY <= LY then
  WinX := FProject.WX - 7;

  BGY := (LY + FProject.SCY) mod 256;
  WinY := (LY - FProject.WY);
  BGTileY := BGY div 8;
  WinTileY := WinY div 8;

  // Get OBJs
  if FProject.LCDC.OBJEnable then
  OAMs := FProject.GetOAMs(LY);

  // Optimize
  SetLength(OAMXs, Length(OAMs));
  SetLength(OAMXMaxs, Length(OAMs));
  SetLength(OAMPs, Length(OAMs));
  for i := Low(OAMs) to High(OAMs) do
  begin
    OAMXs[i] := FProject.OAM.OAM[OAMs[i]].X - 8;
    OAMXMaxs[i] := FProject.OAM.OAM[OAMs[i]].X - 1;
    OAMPs[i] := FProject.OAMImages[OAMs[i]].Scanline[LY+16-FProject.OAM.OAM[OAMs[i]].Y];
    Dec(OAMPs[i], OAMXs[i]);
  end;

  BGPixelOffset := BGTileMap.Scanline[BGY];
  if WinY < 0 then
  WinPixelOffset := nil
  else
  WinPixelOffset := WinTileMap.Scanline[WinY];


  // Render
  Pixel := (Image.Picture.Graphic as TPNGImage).Scanline[LY];
  for x := 0 to 159 do
  try
    if x < WinX then
    begin
      // BG
      BGPixel := BGPixelOffset;
      Inc(BGPixel, (FProject.SCX + x) mod 256);
      Pixel^ := BGPixel^;

      if FProject.IsCGB then
      BGPriority := FProject.VRAM1Maps[BGOffset or (BGTileY shl 5) or (((x + FProject.SCX) mod 256) div 8)].Priority
      else
      BGPriority := True;
    end
    else
    begin
      // Win
      BGPixel := WinPixelOffset;
      Inc(BGPixel, x - Winx);
      Pixel^ := BGPixel^;

      if FProject.IsCGB then
      BGPriority := FProject.VRAM1Maps[WinOffset or (WinTileY shl 5) or ((x - WinX) div 8)].Priority
      else
      BGPriority := True;
    end;

    BGPriorityColor := not ((Pixel^ = 1) or ((Pixel^ > 10) and (Pixel^ mod 4 = 3)));

    for i := Low(OAMs) to High(OAMs) do
    if x >= OAMXs[i] then
    if x <= OAMXMaxs[i] then
    begin
      if OAMPs[i]^ <> 0 then
      begin
        if BGPriorityColor then
        begin
          if FProject.IsCGB then
          begin
            if FProject.LCDC.BGWindowEnablePriority then
            if BGPriority or FProject.OAM.OAM[OAMs[i]].Attributes.Priority then
            Break;
          end
          else
          if FProject.OAM.OAM[OAMs[i]].Attributes.Priority then
          Break;
        end;

        Pixel^ := OAMPs[i]^;
        Break;
      end;
    end;
  finally
    Inc(Pixel);
    for i := Low(OAMs) to High(OAMs) do
    Inc(OAMPs[i]);
  end;

  (Image.Picture.Graphic as TPNGImage).Palette := FProject.TileMapImages[0].Palette;
  Image.Picture.Graphic := Image.Picture.Graphic;
end;

procedure TFormPreview.UpdateOverlaySize(Index: Integer);
var
  Image: TImage;
  Overlay: TOverlay;
begin
  Image := Overlays[Index];
  Overlay := FProject.Overlays[Index];

  Image.Left := ZoomLevel * Overlay.Bounds.Left;
  Image.Top := ZoomLevel * Overlay.Bounds.Top;
  if Overlay.Bounds.Width <= 0 then
  Overlay.Bounds.Width := Min(160, Image.Picture.Width);
  if Overlay.Bounds.Width < 2 then
  Overlay.Bounds.Width := 2;
  Image.Width := ZoomLevel * Overlay.Bounds.Width;
  if Overlay.Bounds.Height <= 0 then
  Overlay.Bounds.Height := Min(144, Image.Picture.Height);
  if Overlay.Bounds.Height < 2 then
  Overlay.Bounds.Height := 2;
  Image.Height := ZoomLevel * Overlay.Bounds.Height;
end;

procedure TFormPreview.UpdateOverlaysMenu;
var
  i: Integer;
begin
  MenuItems.Clear();

  for i := 0 to FProject.Overlays.Count - 1 do
  AddMenuItem(i);
end;

end.
