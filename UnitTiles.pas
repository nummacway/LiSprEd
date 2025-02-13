unit UnitTiles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, GBUtils;

type
  TTileLocation = record
    Address: Word;
    Bank: Boolean;
  end;

  TFormTiles = class(TForm)
    Image: TImage;
    ShapeHover: TShape;
    procedure FormCreate(Sender: TObject);
    procedure ImageStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ImageEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ImageDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ImageMouseLeave(Sender: TObject);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private-Deklarationen }
    var
      FProject: TProject;
      ClickedTile: TTileLocation;
  public
    { Public-Deklarationen }
    procedure ProjectFullUpdate(Sender: TProject);
    procedure ProjectTileUpdate(Sender: TProject; TileAddr: Word; Bank: Boolean);
    procedure ProjectPaletteUpdate(Sender: TProject; IsObj: Boolean; PaletteIndex: Byte; ColorIndex: Byte);
    procedure ProjectRegisterUpdate(Sender: TProject; Registers: TRegisters);
    procedure SetProject(Project: TProject);
    function GetTileLocation(X, Y: Integer): TTileLocation;
  end;

var
  FormTiles: TFormTiles;

implementation

{$R *.dfm}

uses
  PNGImage;

{ TFormTiles }

procedure TFormTiles.FormCreate(Sender: TObject);
var
  PNG: TPNGImage;
begin
  PNG := TPngImage.CreateBlank(COLOR_PALETTE, 8, 256, 192);
  try
    {with PNG.Chunks.Add(TChunktRNS) as TChunktRNS do
    begin

      PaletteValues[0] := 0;
    end;    }
    Image.Picture.Assign(PNG);
  finally
    PNG.Free();
  end;
end;

function TFormTiles.GetTileLocation(X, Y: Integer): TTileLocation;
begin
  Result.Address := $8000 + 16 * ( ((X * 32 div Image.Width) mod 16) + (Y * 24 div Image.Height) * 16 );
  Result.Bank := X * 2 div Image.Width = 1;
end;

procedure TFormTiles.ImageDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  PNG, PNG2: TPngImage;
  i: Integer;
begin
  PNG := TPngImage.CreateBlank(COLOR_PALETTE, 8, 8, 8);
  PNG2 := TPngImage.CreateBlank(COLOR_PALETTE, 8, 8, 8);
  try
    FProject.ReadFromTile(PNG, 0, 0, FProject.DnDData, FProject.DnDData2, [1, 2, 3, 4], False, False);

    if GetAsyncKeyState(VK_CONTROL) >= 0 then
    begin
      with GetTileLocation(X, Y) do
      FProject.ReadFromTile(PNG2, 0, 0, Address, Bank, [1, 2, 3, 4], False, False);

      FProject.WriteToTile(PNG2, 0, 0, FProject.DnDData, FProject.DnDData2, False, False);
      FProject.UpdateTileMapCacheByTileAddr(FProject.DnDData, FProject.DnDData2);
      FProject.TriggerTileUpdate(FProject.DnDData, FProject.DnDData2);

      if FProject.DnDData < $9000 then
      for i := 0 to 39 do
      if FProject.OAM.OAM[i].ContainsTile((FProject.DnDData - $8000) div 16, FProject.DnDData2, FProject) then
      begin
        FProject.UpdateOAMCacheByIndex(i);
        FProject.TriggerOAMUpdate(i);
      end;
    end;

    with GetTileLocation(X, Y) do
    begin
      FProject.WriteToTile(PNG, 0, 0, Address, Bank, False, False);
      FProject.UpdateTileMapCacheByTileAddr(Address, Bank);
      FProject.TriggerTileUpdate(Address, Bank);

      if Address < $9000 then
      for i := 0 to 39 do
      if FProject.OAM.OAM[i].ContainsTile((Address - $8000) div 16, Bank, FProject) then
      begin
        FProject.UpdateOAMCacheByIndex(i);
        FProject.TriggerOAMUpdate(i);
      end;
    end;
  finally
    PNG.Free();
    PNG2.Free();
  end;
end;

procedure TFormTiles.ImageDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := FProject.DnDType = ddTile;
end;

procedure TFormTiles.ImageEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  FProject.DnDType := ddNone;
end;

procedure TFormTiles.ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ClickedTile := GetTileLocation(X, Y);
  Image.BeginDrag(False);
end;

procedure TFormTiles.ImageMouseLeave(Sender: TObject);
begin
  ShapeHover.Hide();
end;

procedure TFormTiles.ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ShapeHover.Left := (X * 32 div Image.Width) * Image.Width div 32;
  ShapeHover.Top := (Y * 24 div Image.Height) * Image.Height div 24;
  ShapeHover.Show();
end;

procedure TFormTiles.ImageStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  FProject.DnDData := ClickedTile.Address;
  FProject.DnDData2 := ClickedTile.Bank;
  FProject.DnDType := ddTile;
end;

procedure TFormTiles.ProjectFullUpdate(Sender: TProject);
var
  Attr: TTileAttributes;
  PNG: TPNGImage;
  i, j: Integer;
  IsCGB, BGWindowTiles: Boolean;
begin
  PNG := Image.Picture.Graphic as TPNGImage;
  PNG.Palette := Sender.TileMapImages[0].Palette;
  IsCGB := Sender.IsCGB;
  BGWindowTiles := Sender.LCDC.BGWindowTiles;
  try
    Sender.LCDC.BGWindowTiles := True;
    Sender.IsCGB := False;
    for j := 0 to 15 do
    for i := 0 to 15 do
    Attr.WriteTileTo(PNG, i * 8, j * 8, j * 16 + i, False, Sender, True);
    Sender.LCDC.BGWindowTiles := False;
    for j := 0 to 7 do
    for i := 0 to 15 do
    Attr.WriteTileTo(PNG, i * 8, 128 + j * 8, j * 16 + i, False, Sender, True);
    Attr.Bank := True;
    Sender.LCDC.BGWindowTiles := True;
    for j := 0 to 15 do
    for i := 0 to 15 do
    Attr.WriteTileTo(PNG, 128 + i * 8, j * 8, j * 16 + i, False, Sender, True);
    Sender.LCDC.BGWindowTiles := False;
    for j := 0 to 7 do
    for i := 0 to 15 do
    Attr.WriteTileTo(PNG, 128 + i * 8, 128 + j * 8, j * 16 + i, False, Sender, True);
  finally
    Sender.IsCGB := IsCGB;
    Sender.LCDC.BGWindowTiles := BGWindowTiles;
    Image.Invalidate();
  end;
end;

procedure TFormTiles.ProjectPaletteUpdate(Sender: TProject; IsObj: Boolean;
  PaletteIndex, ColorIndex: Byte);
begin
  (Image.Picture.Graphic as TPNGImage).Palette := Sender.TileMapImages[0].Palette;
  Image.Invalidate();
end;

procedure TFormTiles.ProjectRegisterUpdate(Sender: TProject; Registers: TRegisters);
begin
  if rgBGP in Registers then
  ProjectPaletteUpdate(Sender, False, 0, 0);
end;

procedure TFormTiles.ProjectTileUpdate(Sender: TProject; TileAddr: Word; Bank: Boolean);
var
  TileAddr2: Integer;
begin
  TileAddr2 := (TileAddr - $8000) div 16;
  FProject.ReadFromTile(Image.Picture.Graphic as TPNGImage, Byte(Bank) * 128 + (TileAddr2 mod 16) * 8, (TileAddr2 div 16) * 8, TileAddr, Bank, [1, 2, 3, 4], False, False);
  Image.Invalidate();
end;

procedure TFormTiles.SetProject(Project: TProject);
begin
  FProject := Project;
  Project.TileUpdateEvents.Add(ProjectTileUpdate);
  Project.FullUpdateEvents.Add(ProjectFullUpdate);
  Project.PaletteUpdateEvents.Add(ProjectPaletteUpdate);
  Project.RegisterUpdateEvents.Add(ProjectRegisterUpdate);
end;

end.
