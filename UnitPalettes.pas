unit UnitPalettes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, GBUtils, System.UITypes, pngimage;

type
  TFormPalettes = class(TForm)
    Label1: TLabel;
    Shape01: TShape;
    Shape02: TShape;
    Shape03: TShape;
    Shape04: TShape;
    Shape05: TShape;
    Shape06: TShape;
    Shape07: TShape;
    Shape08: TShape;
    Shape09: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Shape19: TShape;
    Shape20: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Shape26: TShape;
    Shape27: TShape;
    Shape28: TShape;
    Shape29: TShape;
    Shape30: TShape;
    Shape31: TShape;
    Shape32: TShape;
    Shape33: TShape;
    Shape34: TShape;
    Shape35: TShape;
    Shape36: TShape;
    Shape37: TShape;
    Shape38: TShape;
    Shape39: TShape;
    Shape40: TShape;
    Shape41: TShape;
    Shape42: TShape;
    Shape43: TShape;
    Shape44: TShape;
    Shape45: TShape;
    Shape46: TShape;
    Shape47: TShape;
    Shape48: TShape;
    Shape49: TShape;
    Shape50: TShape;
    Shape51: TShape;
    Shape52: TShape;
    Shape53: TShape;
    Shape54: TShape;
    Shape55: TShape;
    Shape56: TShape;
    Label2: TLabel;
    ShapeForeground: TShape;
    ShapeBackground: TShape;
    GroupBoxEditor: TGroupBox;
    Label3: TLabel;
    EditCGB: TEdit;
    Label4: TLabel;
    EditCSS: TEdit;
    Label5: TLabel;
    SpinEditR: TSpinEdit;
    Label6: TLabel;
    SpinEditG: TSpinEdit;
    Label7: TLabel;
    SpinEditB: TSpinEdit;
    Shape00: TShape;
    ShapePicker: TShape;
    TimerPicker: TTimer;
    procedure Shape00MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpinEditRGBChange(Sender: TObject);
    procedure ShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerPickerTimer(Sender: TObject);
    procedure ShapePickerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePickerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EditCGBChange(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure EditCSSChange(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure SetNewColor(Color: TCGBColor);
    var
      FProject: TProject;
      FIsCGB: Boolean;
      BGSwatches: TArray<TShape>;
      OBJSwatches: TArray<TShape>;
      EditingForeground: Boolean;
      PickerClick: TPoint;
  public
    { Public-Deklarationen }
    procedure UpdateSelection();
    constructor Create(AOwner: TComponent); override;
    procedure ProjectFullUpdate(Sender: TProject);
    procedure ProjectRegisterUpdate(Sender: TProject; Registers: TRegisters);
    procedure ProjectPaletteUpdate(Sender: TProject; IsObj: Boolean; PaletteIndex: Byte; ColorIndex: Byte);
    procedure SetProject(Project: TProject);
  end;

var
  FormPalettes: TFormPalettes;

implementation

{$R *.dfm}

uses
  ClassHelpers, Math, StrUtils;

{ TFormPalettes }

constructor TFormPalettes.Create(AOwner: TComponent);
var
  i, j: Byte;
begin
  inherited;
  BGSwatches  := [Shape01, Shape02, Shape03, Shape04,
                  Shape05, Shape06, Shape07, Shape08,
                  Shape09, Shape10, Shape11, Shape12,
                  Shape13, Shape14, Shape15, Shape16,
                  Shape17, Shape18, Shape19, Shape20,
                  Shape21, Shape22, Shape23, Shape24,
                  Shape25, Shape26, Shape27, Shape28,
                  Shape29, Shape30, Shape31, Shape32];
  OBJSwatches := [nil,     Shape33, Shape34, Shape35,
                  nil,     Shape36, Shape37, Shape38,
                  nil,     Shape39, Shape40, Shape41,
                  nil,     Shape42, Shape43, Shape44,
                  nil,     Shape45, Shape46, Shape47,
                  nil,     Shape48, Shape49, Shape50,
                  nil,     Shape51, Shape52, Shape53,
                  nil,     Shape54, Shape55, Shape56];


  for i := 0 to 7 do
  for j := 0 to 3 do
  begin
    BGSwatches[(i shl 2) or j].Tag := (i shl 2) or j;
    BGSwatches[(i shl 2) or j].OnMouseDown := ShapeMouseDown;
  end;
  for i := 0 to 7 do
  for j := 1 to 3 do
  begin
    OBJSwatches[(i shl 2) or j].Tag := (1 shl 6) or (i shl 2) or j;
    OBJSwatches[(i shl 2) or j].OnMouseDown := ShapeMouseDown;
  end;

  FIsCGB := True;
  EditingForeground := True;
  ForegroundIsTrans := False;
  ForegroundIsObj := False;
  ForegroundPaletteIndex := 0;
  ForegroundColorIndex := 0;
  BackgroundIsTrans := True;
end;

procedure TFormPalettes.EditCGBChange(Sender: TObject);
var
  Temp: Integer;
  Temp2: TCGBColor;
begin
  if TryStrToInt(EditCGB.Text, Temp) then
  begin
    Temp2.RGB555 := Word(Temp);
    SetNewColor(Temp2);
  end;
end;

procedure TFormPalettes.EditCSSChange(Sender: TObject);
var
  Temp: TCGBColor;
begin
  Temp.TrySetCSS(EditCSS.Text);
  SetNewColor(Temp);
end;

procedure TFormPalettes.EditExit(Sender: TObject);
begin
  UpdateSelection();
end;

procedure TFormPalettes.ProjectFullUpdate(Sender: TProject);
var
  i, j, k: Byte;
begin
  ProjectRegisterUpdate(Sender, [rgBGP, rgOBP0, rgOBP1, rgKEY0]);

  if Sender.IsCGB then
  for i := 0 to 1 do
  for j := 0 to 7 do
  for k := 0 to 3 do
  ProjectPaletteUpdate(Sender, Boolean(i), j, k);
end;

procedure TFormPalettes.ProjectPaletteUpdate(Sender: TProject; IsObj: Boolean; PaletteIndex, ColorIndex: Byte);
begin
  if not Sender.IsCGB then
  begin
    ProjectRegisterUpdate(Sender, [rgBGP, rgOBP0, rgOBP1, rgKEY0]);
    Exit;
  end;

  if IsObj and (ColorIndex = 0) then
  Exit;
  if IsObj then
  begin
    if ColorIndex = 0 then
    Exit;

    OBJSwatches[(PaletteIndex shl 2) or ColorIndex].Brush.Color := Sender.CGBOBJPal[PaletteIndex][ColorIndex].Color;
  end
  else
  BGSwatches[(PaletteIndex shl 2) or ColorIndex].Brush.Color := Sender.CGBBGPal[PaletteIndex][ColorIndex].Color;

  UpdateSelection();
end;

procedure TFormPalettes.ProjectRegisterUpdate(Sender: TProject; Registers: TRegisters);
var
  i: Integer;
begin
  if Sender.IsCGB <> FIsCGB then
  begin
    for i := 4 to High(BGSwatches) do
    BGSwatches[i].Visible := Sender.IsCGB;
    for i := 9 to High(OBJSwatches) do
    if Assigned(OBJSwatches[i]) then
    OBJSwatches[i].Visible := Sender.IsCGB;

    FIsCGB := Sender.IsCGB;

    GroupBoxEditor.Visible := FIsCGB;

    if Sender.IsCGB then
    ProjectFullUpdate(Sender)
    else
    Registers := Registers + [rgBGP, rgOBP0, rgOBP1];
  end;

  if not FIsCGB then
  begin
    ForegroundPaletteIndex := Min(ForegroundPaletteIndex, Byte(ForegroundIsObj));
    BackgroundPaletteIndex := Min(BackgroundPaletteIndex, Byte(BackgroundIsObj));

    if rgBGP in Registers then
    begin
      BGSwatches[0].Brush.Color := Sender.BGP.Color[0];
      BGSwatches[1].Brush.Color := Sender.BGP.Color[1];
      BGSwatches[2].Brush.Color := Sender.BGP.Color[2];
      BGSwatches[3].Brush.Color := Sender.BGP.Color[3];
    end;
    if rgOBP0 in Registers then
    begin
      OBJSwatches[1].Brush.Color := Sender.OBP[0].Color[1];
      OBJSwatches[2].Brush.Color := Sender.OBP[0].Color[2];
      OBJSwatches[3].Brush.Color := Sender.OBP[0].Color[3];
    end;
    if rgOBP1 in Registers then
    begin
      OBJSwatches[5].Brush.Color := Sender.OBP[1].Color[1];
      OBJSwatches[6].Brush.Color := Sender.OBP[1].Color[2];
      OBJSwatches[7].Brush.Color := Sender.OBP[1].Color[3];
    end;

    UpdateSelection();
  end;
end;

procedure TFormPalettes.SetNewColor(Color: TCGBColor);
var
  IsObj: Boolean;
  PaletteIndex: Byte;
  ColorIndex: Byte;
begin
  if EditingForeground then
  begin
    IsObj := ForegroundIsObj;
    PaletteIndex := ForegroundPaletteIndex;
    ColorIndex := ForegroundColorIndex;
  end
  else
  begin
    IsObj := BackgroundIsObj;
    PaletteIndex := BackgroundPaletteIndex;
    ColorIndex := BackgroundColorIndex;
  end;

  if IsObj then
  FProject.CGBOBJPal[PaletteIndex][ColorIndex] := Color
  else
  FProject.CGBBGPal[PaletteIndex][ColorIndex] := Color;

  FProject.UpdatePAL();
  FProject.TriggerPaletteUpdate(IsObj, PaletteIndex, ColorIndex);
end;

procedure TFormPalettes.SetProject(Project: TProject);
begin
  FProject := Project;
  Project.FullUpdateEvents.Add(ProjectFullUpdate);
  Project.PaletteUpdateEvents.Add(ProjectPaletteUpdate);
  Project.RegisterUpdateEvents.Add(ProjectRegisterUpdate);
end;

procedure TFormPalettes.Shape00MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if not BackgroundIsTrans then
    begin
      ForegroundIsTrans := True;
      EditingForeground := False;
      UpdateSelection();
    end;
  end;
  if Button = mbRight then
  begin
    if not ForegroundIsTrans then
    begin
      BackgroundIsTrans := True;
      EditingForeground := True;
      UpdateSelection();
    end;
  end;
end;

procedure TFormPalettes.ShapeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ForegroundIsTrans := False;
    ForegroundIsObj := ((Sender as TShape).Tag shr 6) = 1;
    ForegroundPaletteIndex := ((Sender as TShape).Tag shr 2) and $7;
    ForegroundColorIndex := (Sender as TShape).Tag and $3;
  end
  else
  if Button = mbRight then
  begin
    BackgroundIsTrans := False;
    BackgroundIsObj := ((Sender as TShape).Tag shr 6) = 1;
    BackgroundPaletteIndex := ((Sender as TShape).Tag shr 2) and $7;
    BackgroundColorIndex := (Sender as TShape).Tag and $3;
  end
  else
  Exit;
  GroupBoxEditor.Enabled := False; // required so the currently-focused edit gets updated
  GroupBoxEditor.Enabled := True;
  UpdateSelection();
end;

procedure TFormPalettes.ShapePickerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PickerClick := Point(X, Y);
  TimerPicker.Enabled := True;
end;

procedure TFormPalettes.ShapePickerMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Temp: TCGBColor;
begin
  TimerPicker.Enabled := False;
  if PickerClick = Point(X, Y) then
  if ShapePicker.ClientToScreen(ShapePicker.ClientRect).Contains(Mouse.CursorPos) then // because MouseInClient only exists for WinControl
  begin
    Temp.Color := ShapePicker.Brush.Color;
    GroupBoxEditor.Enabled := False; // required so the currently-focused edit gets updated
    GroupBoxEditor.Enabled := True;
    SetNewColor(Temp);
  end;
end;

procedure TFormPalettes.SpinEditRGBChange(Sender: TObject);
var
  Temp: TCGBColor;
begin
  Temp.RGB555 := (SpinEditB.Value shl 10) or (SpinEditG.Value shl 5) or (SpinEditR.Value);
  SetNewColor(Temp);
end;

procedure TFormPalettes.TimerPickerTimer(Sender: TObject);
var
  DC: HDC;
begin
  if not ShapePicker.ClientToScreen(ShapePicker.ClientRect).Contains(Mouse.CursorPos) then
  begin
    DC := GetDC(0);
    with Mouse.CursorPos do
    ShapePicker.Brush.Color := GetPixel(DC, X, Y);
  end;
end;

procedure TFormPalettes.UpdateSelection;
function GetPaletteIndex(IsTrans, IsObj: Boolean; PaletteIndex, ColorIndex: Byte): Byte;
begin
{ Index  | Usage
  -------+--------
       0 | Transparency
    1..4 | DMG BG
    5..7 | DMG OBJ0
   8..10 | DMG OBJ1
  11..42 | CGB BG
  43..66 | CGB OBJ }
  if IsTrans then
  Result := 0
  else
  if FProject.IsCGB then
  if IsObj then
  Result := 42 + (3 * PaletteIndex) + ColorIndex
  else
  Result := 11 + (4 * PaletteIndex) + ColorIndex
  else
  if IsObj then
  Result := 4 + (3 * PaletteIndex) + ColorIndex
  else
  Result := ColorIndex + 1;
end;
var
  Temp: TCGBColor;
begin
  if ForegroundIsTrans then
  begin
    ShapeForeground.Brush.Assign(Shape00.Brush);
    ShapeForeground.Pen.Assign(Shape00.Pen);
  end
  else
  begin
    if ForegroundIsObj and (ForegroundColorIndex > 0) then
    ShapeForeground.Brush.Color := OBJSwatches[(ForegroundPaletteIndex shl 2) or ForegroundColorIndex].Brush.Color
    else
    ShapeForeground.Brush.Color := BGSwatches[(ForegroundPaletteIndex shl 2) or ForegroundColorIndex].Brush.Color;
    ShapeForeground.Brush.Style := bsSolid;
    ShapeForeground.Pen.Color := clBlack;
  end;

  if BackgroundIsTrans then
  begin
    ShapeBackground.Brush.Assign(Shape00.Brush);
    ShapeBackground.Pen.Assign(Shape00.Pen);
  end
  else
  begin
    if BackgroundIsObj and (BackgroundColorIndex > 0) then
    ShapeBackground.Brush.Color := OBJSwatches[(BackgroundPaletteIndex shl 2) or BackgroundColorIndex].Brush.Color
    else
    ShapeBackground.Brush.Color := BGSwatches[(BackgroundPaletteIndex shl 2) or BackgroundColorIndex].Brush.Color;
    ShapeBackground.Brush.Style := bsSolid;
    ShapeBackground.Pen.Color := clBlack;
  end;

  if EditingForeground then
  Temp.Color := ShapeForeground.Brush.Color
  else
  Temp.Color := ShapeBackground.Brush.Color;

  if not (SpinEditR.Focused and Active) then
  SpinEditR.TextNoChange := IntToStr(Temp.RGB555 and $001f);
  if not (SpinEditG.Focused and Active) then
  SpinEditG.TextNoChange := IntToStr((Temp.RGB555 shr 5) and $001f);
  if not (SpinEditB.Focused and Active) then
  SpinEditB.TextNoChange := IntToStr((Temp.RGB555 shr 10) and $001f);

  if not (EditCGB.Focused and Active) then
  EditCGB.TextNoChange := 'x' + IntToHex(Temp.RGB555, 4);

  if not (EditCSS.Focused and Active) then
  EditCSS.TextNoChange := '#' + Temp.CSSNoHash;

  ForegroundIndex := GetPaletteIndex(ForegroundIsTrans, ForegroundIsObj, ForegroundPaletteIndex, ForegroundColorIndex);
  BackgroundIndex := GetPaletteIndex(BackgroundIsTrans, BackgroundIsObj, BackgroundPaletteIndex, BackgroundColorIndex);

  if EditingForeground then
  GroupBoxEditor.Caption := 'Editing ' + IfThen(ForegroundIsObj, 'OBJ', 'BG') + IntToStr(ForegroundPaletteIndex) + ':' + IntToStr(ForegroundColorIndex)
  else
  GroupBoxEditor.Caption := 'Editing ' + IfThen(BackgroundIsObj, 'OBJ', 'BG') + IntToStr(BackgroundPaletteIndex) + ':' + IntToStr(BackgroundColorIndex);
end;

end.
