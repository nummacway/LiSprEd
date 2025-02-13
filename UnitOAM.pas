unit UnitOAM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, GBUtils,
  Vcl.Menus, System.ImageList, Vcl.ImgList;

type
  TFormOAM = class(TForm)
    Image01: TImage;
    Label01: TLabel;
    Image02: TImage;
    Label02: TLabel;
    Image03: TImage;
    Label03: TLabel;
    Image04: TImage;
    Label04: TLabel;
    Image05: TImage;
    Label05: TLabel;
    Image06: TImage;
    Label06: TLabel;
    Image07: TImage;
    Label07: TLabel;
    Image08: TImage;
    Label08: TLabel;
    Image09: TImage;
    Label09: TLabel;
    Image10: TImage;
    Label10: TLabel;
    Image11: TImage;
    Label11: TLabel;
    Image12: TImage;
    Label12: TLabel;
    Image13: TImage;
    Label13: TLabel;
    Image14: TImage;
    Label14: TLabel;
    Image15: TImage;
    Label15: TLabel;
    Image16: TImage;
    Label16: TLabel;
    Image17: TImage;
    Label17: TLabel;
    Image18: TImage;
    Label18: TLabel;
    Image19: TImage;
    Label19: TLabel;
    Image20: TImage;
    Label20: TLabel;
    Image21: TImage;
    Label21: TLabel;
    Image22: TImage;
    Label22: TLabel;
    Image23: TImage;
    Label23: TLabel;
    Image24: TImage;
    Label24: TLabel;
    Image25: TImage;
    Label25: TLabel;
    Image26: TImage;
    Label26: TLabel;
    Image27: TImage;
    Label27: TLabel;
    Image28: TImage;
    Label28: TLabel;
    Image29: TImage;
    Label29: TLabel;
    Image30: TImage;
    Label30: TLabel;
    Image31: TImage;
    Label31: TLabel;
    Image32: TImage;
    Label32: TLabel;
    Image33: TImage;
    Label33: TLabel;
    Image34: TImage;
    Label34: TLabel;
    Image35: TImage;
    Label35: TLabel;
    Image36: TImage;
    Label36: TLabel;
    Image37: TImage;
    Label37: TLabel;
    Image38: TImage;
    Label38: TLabel;
    Image39: TImage;
    Label39: TLabel;
    Image40: TImage;
    Label40: TLabel;
    PopupMenuEdit: TPopupMenu;
    MenuItemPriority: TMenuItem;
    MenuItemYFlip: TMenuItem;
    MenuItemXFlip: TMenuItem;
    N1: TMenuItem;
    MenuItemDMGPal0: TMenuItem;
    MenuItemDMGPal1: TMenuItem;
    Bank12: TMenuItem;
    MenuItemBank0: TMenuItem;
    MenuItemBank1: TMenuItem;
    N3: TMenuItem;
    MenuItemCGBPal0: TMenuItem;
    MenuItemCGBPal1: TMenuItem;
    MenuItemCGBPal2: TMenuItem;
    MenuItemCGBPal3: TMenuItem;
    MenuItemCGBPal4: TMenuItem;
    MenuItemCGBPal5: TMenuItem;
    MenuItemCGBPal6: TMenuItem;
    MenuItemCGBPal7: TMenuItem;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure LabelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupMenuEditPopup(Sender: TObject);
    procedure MenuItemPriorityClick(Sender: TObject);
    procedure MenuItemYFlipClick(Sender: TObject);
    procedure MenuItemXFlipClick(Sender: TObject);
    procedure MenuItemDMGPalClick(Sender: TObject);
    procedure MenuItemBankClick(Sender: TObject);
    procedure MenuItemCGBPalClick(Sender: TObject);
    procedure ImageStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ImageDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ImageEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ImageDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
  private
    { Private-Deklarationen }
    var
      FProject: TProject;
      ClickedIndex: Integer;
      Images: TArray<TImage>;
      Labels: TArray<TLabel>;
  public
    { Public-Deklarationen }
    procedure ProjectFullUpdate(Sender: TProject);
    procedure ProjectTileUpdate(Sender: TProject; TileAddr: Word; Bank: Boolean);
    procedure ProjectOAMUpdate(Sender: TProject; OAMIndex: Byte);
    procedure ProjectRegisterUpdate(Sender: TProject; Registers: TRegisters);
    procedure ProjectPaletteUpdate(Sender: TProject; IsObj: Boolean; PaletteIndex: Byte; ColorIndex: Byte);
    procedure SetProject(Project: TProject);
  end;

var
  FormOAM: TFormOAM;

implementation

{$R *.dfm}

uses
  StrUtils, Math;

procedure TFormOAM.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  Images := [Image01, Image02, Image03, Image04,
             Image05, Image06, Image07, Image08,
             Image09, Image10, Image11, Image12,
             Image13, Image14, Image15, Image16,
             Image17, Image18, Image19, Image20,
             Image21, Image22, Image23, Image24,
             Image25, Image26, Image27, Image28,
             Image29, Image30, Image31, Image32,
             Image33, Image34, Image35, Image36,
             Image37, Image38, Image39, Image40];
  Labels := [Label01, Label02, Label03, Label04,
             Label05, Label06, Label07, Label08,
             Label09, Label10, Label11, Label12,
             Label13, Label14, Label15, Label16,
             Label17, Label18, Label19, Label20,
             Label21, Label22, Label23, Label24,
             Label25, Label26, Label27, Label28,
             Label29, Label30, Label31, Label32,
             Label33, Label34, Label35, Label36,
             Label37, Label38, Label39, Label40];

  for i := 0 to 39 do
  begin
    Images[i].Stretch := True;
    Images[i].Proportional := True;
    Images[i].Tag := i;
    Images[i].OnStartDrag := ImageStartDrag;
    Images[i].OnDragOver := ImageDragOver;
    Images[i].OnDragDrop := ImageDragDrop;
    Images[i].OnEndDrag := ImageEndDrag;
    Images[i].DragMode := TDragMode.dmAutomatic;
    Labels[i].Tag := i;
    Labels[i].OnMouseDown := LabelMouseDown;
  end;
end;

procedure TFormOAM.ImageDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  case FProject.DnDType of
    ddTile:
      begin
        FProject.OAM.OAM[(Sender as TComponent).Tag].Tile := (FProject.DnDData - $8000) div 16;
        FProject.OAM.OAM[(Sender as TComponent).Tag].Attributes.Bank := FProject.DnDData2;
      end;
    ddOAM: FProject.OAM.OAM[(Sender as TComponent).Tag] := FProject.OAM.OAM[FProject.DnDData];
  end;
  FProject.UpdateOAMCacheByIndex((Sender as TImage).Tag);
  FProject.TriggerOAMUpdate((Sender as TImage).Tag);
end;

procedure TFormOAM.ImageDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  case FProject.DnDType of
    ddNone: Accept := False;
    ddTile: Accept := FProject.DnDData < $9000;
    ddOAM: Accept := FProject.DnDData <> (Sender as TComponent).Tag;
  end;
end;

procedure TFormOAM.ImageEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  FProject.DnDType := ddNone;
end;

procedure TFormOAM.ImageStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  FProject.DnDType := ddOAM;
  FProject.DnDData := (Sender as TComponent).Tag;
end;

procedure TFormOAM.LabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  s: string;
begin
  ClickedIndex := (Sender as TLabel).Tag;
  Y := Y * 4 div (Sender as TLabel).Height;
  case Y of
    0:
      begin
        s := IntToStr(FProject.OAM.OAM[ClickedIndex].Y);
        if InputQuery('Edit OAM ' + IntToStr(ClickedIndex), 'Y:', s) then
        begin
          FProject.OAM.OAM[ClickedIndex].Y := StrToInt(s);
          //FProject.UpdateOAMCacheByIndex(ClickedIndex);
          FProject.TriggerOAMUpdate(ClickedIndex);
        end;
      end;
    1:
      begin
        s := IntToStr(FProject.OAM.OAM[ClickedIndex].X);
        if InputQuery('Edit OAM ' + IntToStr(ClickedIndex), 'X:', s) then
        begin
          FProject.OAM.OAM[ClickedIndex].X := StrToInt(s);
          //FProject.UpdateOAMCacheByIndex(ClickedIndex);
          FProject.TriggerOAMUpdate(ClickedIndex);
        end;
      end;
    2:
      begin
        s := IntToStr(FProject.OAM.OAM[ClickedIndex].Tile);
        if InputQuery('Edit OAM ' + IntToStr(ClickedIndex), 'Tile:', s) then
        begin
          FProject.OAM.OAM[ClickedIndex].Tile := StrToInt(s);
          FProject.UpdateOAMCacheByIndex(ClickedIndex);
          FProject.TriggerOAMUpdate(ClickedIndex);
        end;
      end;
    3: PopupMenuEdit.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  end;
end;

procedure TFormOAM.MenuItemBankClick(Sender: TObject);
begin
  FProject.OAM.OAM[ClickedIndex].Attributes.Bank := (Sender as TMenuItem).Tag = 1;
  FProject.UpdateOAMCacheByIndex(ClickedIndex);
  FProject.TriggerOAMUpdate(ClickedIndex);
end;

procedure TFormOAM.MenuItemCGBPalClick(Sender: TObject);
begin
  FProject.OAM.OAM[ClickedIndex].Attributes.CGBPaletteIndex := (Sender as TMenuItem).Tag;
  FProject.UpdateOAMCacheByIndex(ClickedIndex);
  FProject.TriggerOAMUpdate(ClickedIndex);
end;

procedure TFormOAM.MenuItemDMGPalClick(Sender: TObject);
begin
  FProject.OAM.OAM[ClickedIndex].Attributes.DMGPaletteIndex := (Sender as TMenuItem).Tag = 1;
  FProject.UpdateOAMCacheByIndex(ClickedIndex);
  FProject.TriggerOAMUpdate(ClickedIndex);
end;

procedure TFormOAM.MenuItemPriorityClick(Sender: TObject);
begin
  FProject.OAM.OAM[ClickedIndex].Attributes.Priority := not FProject.OAM.OAM[ClickedIndex].Attributes.Priority;
  FProject.UpdateOAMCacheByIndex(ClickedIndex);
  FProject.TriggerOAMUpdate(ClickedIndex);
end;

procedure TFormOAM.MenuItemXFlipClick(Sender: TObject);
begin
  FProject.OAM.OAM[ClickedIndex].Attributes.XFlip := not FProject.OAM.OAM[ClickedIndex].Attributes.XFlip;
  FProject.UpdateOAMCacheByIndex(ClickedIndex);
  FProject.TriggerOAMUpdate(ClickedIndex);
end;

procedure TFormOAM.MenuItemYFlipClick(Sender: TObject);
begin
  FProject.OAM.OAM[ClickedIndex].Attributes.YFlip := not FProject.OAM.OAM[ClickedIndex].Attributes.YFlip;
  FProject.UpdateOAMCacheByIndex(ClickedIndex);
  FProject.TriggerOAMUpdate(ClickedIndex);
end;

procedure TFormOAM.PopupMenuEditPopup(Sender: TObject);
begin
  with FProject.OAM.OAM[ClickedIndex].Attributes do
  begin
    MenuItemPriority.Checked := Priority;
    MenuItemYFlip.Checked := YFlip;
    MenuItemXFlip.Checked := XFlip;
    MenuItemDMGPal0.Checked := not DMGPaletteIndex;
    MenuItemDMGPal1.Checked := DMGPaletteIndex;
    MenuItemBank0.Checked := not Bank;
    MenuItemBank1.Checked := Bank;
    MenuItemCGBPal0.Checked := CGBPaletteIndex = 0;
    MenuItemCGBPal1.Checked := CGBPaletteIndex = 1;
    MenuItemCGBPal2.Checked := CGBPaletteIndex = 2;
    MenuItemCGBPal3.Checked := CGBPaletteIndex = 3;
    MenuItemCGBPal4.Checked := CGBPaletteIndex = 4;
    MenuItemCGBPal5.Checked := CGBPaletteIndex = 5;
    MenuItemCGBPal6.Checked := CGBPaletteIndex = 6;
    MenuItemCGBPal7.Checked := CGBPaletteIndex = 7;
  end;
end;

procedure TFormOAM.ProjectFullUpdate(Sender: TProject);
var
  i: Integer;
begin
  for i := 0 to 39 do
  ProjectOAMUpdate(Sender, i);
end;

procedure TFormOAM.ProjectOAMUpdate(Sender: TProject; OAMIndex: Byte);
begin
  Images[OAMIndex].Picture.Graphic := Sender.OAMImages[OAMIndex];
  with Sender.OAM.OAM[OAMIndex] do
  begin
    Labels[OAMIndex].Caption := 'Y:'#$200A' ' + IntToStr(Y) + #13#10 +
                                'X: ' + IntToStr(X) + #13#10 +
                                'T: ' + IntToStr(Byte(Attributes.Bank)) + ':' + IntToStr(Tile) + #13#10 +
                                IfThen(Attributes.Priority, 'P') + IfThen(Attributes.YFlip, 'Y') + IfThen(Attributes.XFlip, 'X') + IfThen(Attributes.DMGPaletteIndex, 'B', 'A') + IntToStr(Attributes.CGBPaletteIndex);
    Labels[OAMIndex].Font.Color := IfThen(IsOnScreen(Sender), clWindowText, clGrayText);
  end;
end;

procedure TFormOAM.ProjectPaletteUpdate(Sender: TProject; IsObj: Boolean; PaletteIndex, ColorIndex: Byte);
var
  i: Integer;
begin
  if Sender.IsCGB then
  for i := 0 to 39 do
  if Sender.OAM.OAM[i].Attributes.CGBPaletteIndex = PaletteIndex then
  Images[i].Picture.Graphic := Sender.OAMImages[i];
end;

procedure TFormOAM.ProjectRegisterUpdate(Sender: TProject; Registers: TRegisters);
var
  i: Integer;
begin
  if (rgLCDC in Registers) or (rgKEY0 in Registers) then
  ProjectFullUpdate(Sender)
  else
  begin
    // If we did a full update, we don't have to do this
    if (rgOBP0 in Registers) then
    for i := 0 to 39 do
    if Sender.OAM.OAM[i].Attributes.DMGPaletteIndex = False then
    Images[i].Picture.Graphic := Sender.OAMImages[i];

    if (rgOBP1 in Registers) then
    for i := 0 to 39 do
    if Sender.OAM.OAM[i].Attributes.DMGPaletteIndex = True then
    Images[i].Picture.Graphic := Sender.OAMImages[i];
  end;
end;

procedure TFormOAM.ProjectTileUpdate(Sender: TProject; TileAddr: Word; Bank: Boolean);
var
  i: Integer;
begin
  if TileAddr < $9000 then
  for i := 0 to 39 do
  if Sender.OAM.OAM[i].ContainsTile((TileAddr - $8000) div 16, Bank, Sender) then
  Images[i].Picture.Graphic := Sender.OAMImages[i];
end;

procedure TFormOAM.SetProject(Project: TProject);
begin
  FProject := Project;
  Project.TileUpdateEvents.Add(ProjectTileUpdate);
  Project.OAMUpdateEvents.Add(ProjectOAMUpdate);
  Project.FullUpdateEvents.Add(ProjectFullUpdate);
  Project.PaletteUpdateEvents.Add(ProjectPaletteUpdate);
  Project.RegisterUpdateEvents.Add(ProjectRegisterUpdate);
end;

end.
