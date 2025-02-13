unit UnitRegisters;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, GBUtils, Vcl.ExtCtrls;

type
  TFormRegisters = class(TForm)
    LabelLCDC: TLabel;
    EditLCDC: TEdit;
    LabelLCDC7: TLabel;
    CheckBoxLCDC7: TCheckBox;
    LabelLCDC6: TLabel;
    Panel1: TPanel;
    RadioButtonLCDC60: TRadioButton;
    RadioButtonLCDC61: TRadioButton;
    LabelLCDC5: TLabel;
    CheckBoxLCDC5: TCheckBox;
    LabelLCDC4: TLabel;
    Panel2: TPanel;
    RadioButtonLCDC40: TRadioButton;
    RadioButtonLCDC41: TRadioButton;
    LabelLCDC3: TLabel;
    Panel3: TPanel;
    RadioButtonLCDC30: TRadioButton;
    RadioButtonLCDC31: TRadioButton;
    LabelLCDC2: TLabel;
    Panel4: TPanel;
    RadioButtonLCDC20: TRadioButton;
    RadioButtonLCDC21: TRadioButton;
    LabelLCDC1: TLabel;
    CheckBoxLCDC1: TCheckBox;
    LabelLCDC0: TLabel;
    CheckBoxLCDC0: TCheckBox;
    LabelWY: TLabel;
    EditWY: TEdit;
    LabelWX: TLabel;
    EditWX: TEdit;
    LabelSCY: TLabel;
    EditSCY: TEdit;
    LabelSCX: TLabel;
    EditSCX: TEdit;
    LabelBGP: TLabel;
    EditBGP: TEdit;
    ColorBoxBGP3: TColorBox;
    ColorBoxBGP2: TColorBox;
    ColorBoxBGP1: TColorBox;
    ColorBoxBGP0: TColorBox;
    LabelOBP0: TLabel;
    EditOBP0: TEdit;
    ColorBoxOBP03: TColorBox;
    ColorBoxOBP02: TColorBox;
    ColorBoxOBP01: TColorBox;
    ColorBoxOBP00: TColorBox;
    LabelOBP1: TLabel;
    EditOBP1: TEdit;
    ColorBoxOBP13: TColorBox;
    ColorBoxOBP12: TColorBox;
    ColorBoxOBP11: TColorBox;
    ColorBoxOBP10: TColorBox;
    LabelOPRI: TLabel;
    EditOPRI: TEdit;
    LabelOPRI0: TLabel;
    CheckBoxOPRI0: TCheckBox;
    LabelKEY0: TLabel;
    EditKEY0: TEdit;
    LabelKEY02: TLabel;
    RadioButtonKEY020: TRadioButton;
    RadioButtonKEY021: TRadioButton;
    procedure ColorBoxGetColors(Sender: TCustomColorBox; Items: TStrings);
    procedure RadioButtonLCDC60Click(Sender: TObject);
    procedure RadioButtonLCDC61Click(Sender: TObject);
    procedure CheckBoxLCDC5Click(Sender: TObject);
    procedure RadioButtonLCDC40Click(Sender: TObject);
    procedure RadioButtonLCDC41Click(Sender: TObject);
    procedure RadioButtonKEY020Click(Sender: TObject);
    procedure RadioButtonKEY021Click(Sender: TObject);
    procedure CheckBoxLCDC1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure EditLCDCChange(Sender: TObject);
    procedure RadioButtonLCDC20Click(Sender: TObject);
    procedure RadioButtonLCDC21Click(Sender: TObject);
    procedure RadioButtonLCDC30Click(Sender: TObject);
    procedure RadioButtonLCDC31Click(Sender: TObject);
    procedure CheckBoxLCDC0Click(Sender: TObject);
    procedure EditWYChange(Sender: TObject);
    procedure EditWXChange(Sender: TObject);
    procedure EditSCYChange(Sender: TObject);
    procedure EditSCXChange(Sender: TObject);
    procedure EditBGPChange(Sender: TObject);
    procedure ColorBoxBGPChange(Sender: TObject);
    procedure ColorBoxOBP0Change(Sender: TObject);
    procedure ColorBoxOBP1Change(Sender: TObject);
    procedure EditOBP0Change(Sender: TObject);
    procedure EditOBP1Change(Sender: TObject);
    procedure CheckBoxOPRI0Click(Sender: TObject);
    procedure EditOPRIChange(Sender: TObject);
    procedure EditExit(Sender: TObject);
  private
    { Private-Deklarationen }
    var
      FProject: TProject;
  public
    { Public-Deklarationen }
    procedure ProjectRegisterUpdate(Sender: TProject; Registers: TRegisters);
    procedure ProjectFullUpdate(Sender: TProject);
    procedure SetProject(Project: TProject);
  end;

var
  FormRegisters: TFormRegisters;

implementation

{$R *.dfm}

uses
  ClassHelpers;

procedure TFormRegisters.CheckBoxLCDC0Click(Sender: TObject);
begin
  FProject.LCDC.BGWindowEnablePriority := CheckBoxLCDC0.Checked;
  FProject.TriggerRegisterUpdate([rgLCDC]);
end;

procedure TFormRegisters.CheckBoxLCDC1Click(Sender: TObject);
begin
  FProject.LCDC.OBJEnable := CheckBoxLCDC1.Checked;
  FProject.TriggerRegisterUpdate([rgLCDC]);
end;

procedure TFormRegisters.CheckBoxLCDC5Click(Sender: TObject);
begin
  FProject.LCDC.WindowEnable := CheckBoxLCDC5.Checked;
  FProject.TriggerRegisterUpdate([rgLCDC]);
end;

procedure TFormRegisters.CheckBoxOPRI0Click(Sender: TObject);
begin
  FProject.OPRI := CheckBoxOPRI0.Checked;
  FProject.TriggerRegisterUpdate([rgOPRI]);
end;

procedure TFormRegisters.ColorBoxBGPChange(Sender: TObject);
begin
  FProject.BGP.ID[(Sender as TColorBox).Tag] := (Sender as TColorBox).ItemIndex;
  FProject.UpdatePAL();
  FProject.TriggerRegisterUpdate([rgBGP]);
end;

procedure TFormRegisters.ColorBoxGetColors(Sender: TCustomColorBox; Items: TStrings);
begin
  Items.AddObject('White', Pointer(clWhite));
  Items.AddObject('Light', Pointer($AAAAAA));
  Items.AddObject('Dark', Pointer($555555));
  Items.AddObject('Black', Pointer(clBlack));
  Sender.Enabled := True;
end;

procedure TFormRegisters.ColorBoxOBP0Change(Sender: TObject);
begin
  FProject.OBP[0].ID[(Sender as TColorBox).Tag] := (Sender as TColorBox).ItemIndex;
  FProject.UpdatePAL();
  FProject.TriggerRegisterUpdate([rgOBP0]);
end;

procedure TFormRegisters.ColorBoxOBP1Change(Sender: TObject);
begin
  FProject.OBP[1].ID[(Sender as TColorBox).Tag] := (Sender as TColorBox).ItemIndex;
  FProject.UpdatePAL();
  FProject.TriggerRegisterUpdate([rgOBP1]);
end;

procedure TFormRegisters.EditBGPChange(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(EditBGP.Text, i) then
  begin
    FProject.BGP.AsByte := Byte(i);
    FProject.UpdatePAL();
    FProject.TriggerRegisterUpdate([rgBGP]);
  end;
end;

procedure TFormRegisters.EditExit(Sender: TObject);
begin
  ProjectRegisterUpdate(FProject, [TRegister((Sender as TEdit).Tag)]);
end;

procedure TFormRegisters.EditLCDCChange(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(EditLCDC.Text, i) then
  begin
    FProject.LCDC.AsByte := Byte(i);
    FProject.TriggerRegisterUpdate([rgLCDC]);
  end;
end;

procedure TFormRegisters.EditOBP0Change(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(EditOBP0.Text, i) then
  begin
    FProject.OBP[0].AsByte := Byte(i);
    FProject.UpdatePAL();
    FProject.TriggerRegisterUpdate([rgOBP0]);
  end;
end;

procedure TFormRegisters.EditOBP1Change(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(EditOBP1.Text, i) then
  begin
    FProject.OBP[1].AsByte := Byte(i);
    FProject.UpdatePAL();
    FProject.TriggerRegisterUpdate([rgOBP1]);
  end;
end;

procedure TFormRegisters.EditOPRIChange(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(EditOPRI.Text, i) then
  begin
    FProject.OPRI := (i and 1) = 1;
    FProject.TriggerRegisterUpdate([rgOPRI]);
  end;
end;

procedure TFormRegisters.EditSCXChange(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(EditSCX.Text, i) then
  begin
    FProject.SCX := Byte(i);
    FProject.TriggerRegisterUpdate([rgSCX]);
  end;
end;

procedure TFormRegisters.EditSCYChange(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(EditSCY.Text, i) then
  begin
    FProject.SCY := Byte(i);
    FProject.TriggerRegisterUpdate([rgSCY]);
  end;
end;

procedure TFormRegisters.EditWXChange(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(EditWX.Text, i) then
  begin
    FProject.WX := Byte(i);
    FProject.TriggerRegisterUpdate([rgWX]);
  end;
end;

procedure TFormRegisters.EditWYChange(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(EditWY.Text, i) then
  begin
    FProject.WY := Byte(i);
    FProject.TriggerRegisterUpdate([rgWY]);
  end;
end;

procedure TFormRegisters.FormDeactivate(Sender: TObject);
begin
  ProjectFullUpdate(FProject);
end;

procedure TFormRegisters.ProjectFullUpdate(Sender: TProject);
begin
  ProjectRegisterUpdate(Sender, AllRegisters);
end;

procedure TFormRegisters.ProjectRegisterUpdate(Sender: TProject; Registers: TRegisters);
procedure SetEdit(Target: TEdit; const Value: Integer);
begin
  if not (Target.Focused and Active) then
  Target.TextNoChange := 'x' + IntToHex(Value, 2);
end;
begin
  // Set edits
  if rgLCDC in Registers then
  begin
    SetEdit(EditLCDC, Sender.LCDC.AsByte);
    RadioButtonLCDC60.Checked := not Sender.LCDC.WindowTileMap;
    RadioButtonLCDC61.Checked := Sender.LCDC.WindowTileMap;
    CheckBoxLCDC5.Checked := Sender.LCDC.WindowEnable;
    RadioButtonLCDC40.Checked := not Sender.LCDC.BGWindowTiles;
    RadioButtonLCDC41.Checked := Sender.LCDC.BGWindowTiles;
    RadioButtonLCDC30.Checked := not Sender.LCDC.BGTileMap;
    RadioButtonLCDC31.Checked := Sender.LCDC.BGTileMap;
    RadioButtonLCDC20.Checked := not Sender.LCDC.OBJSize;
    RadioButtonLCDC21.Checked := Sender.LCDC.OBJSize;
    CheckBoxLCDC1.Checked := Sender.LCDC.OBJEnable;
    CheckBoxLCDC0.Checked := Sender.LCDC.BGWindowEnablePriority;
  end;

  if rgWY in Registers then
  SetEdit(EditWY,   Sender.WY);

  if rgWX in Registers then
  SetEdit(EditWX,   Sender.WX);

  if rgSCY in Registers then
  SetEdit(EditSCY,  Sender.SCY);

  if rgSCY in Registers then
  SetEdit(EditSCX,  Sender.SCX);

  if rgBGP in Registers then
  begin
    SetEdit(EditBGP,  Sender.BGP.AsByte);
    ColorBoxBGP3.ItemIndex := Sender.BGP.ID[3];
    ColorBoxBGP2.ItemIndex := Sender.BGP.ID[2];
    ColorBoxBGP1.ItemIndex := Sender.BGP.ID[1];
    ColorBoxBGP0.ItemIndex := Sender.BGP.ID[0];
  end;

  if rgOBP0 in Registers then
  begin
    SetEdit(EditOBP0, Sender.OBP[0].AsByte);
    ColorBoxOBP03.ItemIndex := Sender.OBP[0].ID[3];
    ColorBoxOBP02.ItemIndex := Sender.OBP[0].ID[2];
    ColorBoxOBP01.ItemIndex := Sender.OBP[0].ID[1];
    //ColorBoxOBP00.ItemIndex := Sender.OBP[0].ID[0];
  end;

  if rgOBP1 in Registers then
  begin
    SetEdit(EditOBP1, Sender.OBP[1].AsByte);
    ColorBoxOBP13.ItemIndex := Sender.OBP[1].ID[3];
    ColorBoxOBP12.ItemIndex := Sender.OBP[1].ID[2];
    ColorBoxOBP11.ItemIndex := Sender.OBP[1].ID[1];
    //ColorBoxOBP10.ItemIndex := Sender.OBP[1].ID[0];
  end;

  if rgOPRI in Registers then
  begin
    SetEdit(EditOPRI, Byte(Sender.OPRI));
    CheckBoxOPRI0.Checked := Sender.OPRI;
  end;

  if rgKEY0 in Registers then
  begin
    if Sender.IsCGB then
    SetEdit(EditKEY0, $80)
    else
    SetEdit(EditKEY0, $04);

    //CheckBoxLCDC7.Checked := True;
    RadioButtonKEY020.Checked := Sender.IsCGB;
    RadioButtonKEY021.Checked := not Sender.IsCGB;
  end;
end;

procedure TFormRegisters.RadioButtonKEY020Click(Sender: TObject);
begin
  FProject.IsCGB := True;
  FProject.UpdateOAMCache();
  FProject.UpdateTileMapCache();
  FProject.TriggerRegisterUpdate([rgKEY0]);
end;

procedure TFormRegisters.RadioButtonKEY021Click(Sender: TObject);
begin
  FProject.IsCGB := False;
  FProject.UpdateOAMCache();
  FProject.UpdateTileMapCache();
  FProject.TriggerRegisterUpdate([rgKEY0]);
end;

procedure TFormRegisters.RadioButtonLCDC20Click(Sender: TObject);
begin
  FProject.LCDC.OBJSize := False;
  FProject.UpdateOAMCache();
  FProject.TriggerRegisterUpdate([rgLCDC]);
end;

procedure TFormRegisters.RadioButtonLCDC21Click(Sender: TObject);
begin
  FProject.LCDC.OBJSize := True;
  FProject.UpdateOAMCache();
  FProject.TriggerRegisterUpdate([rgLCDC]);
end;

procedure TFormRegisters.RadioButtonLCDC30Click(Sender: TObject);
begin
  FProject.LCDC.BGTileMap := False;
  FProject.TriggerRegisterUpdate([rgLCDC]);
end;

procedure TFormRegisters.RadioButtonLCDC31Click(Sender: TObject);
begin
  FProject.LCDC.BGTileMap := True;
  FProject.TriggerRegisterUpdate([rgLCDC]);
end;

procedure TFormRegisters.RadioButtonLCDC40Click(Sender: TObject);
begin
  FProject.LCDC.BGWindowTiles := False;
  FProject.UpdateTileMapCache();
  FProject.TriggerRegisterUpdate([rgLCDC]);
end;

procedure TFormRegisters.RadioButtonLCDC41Click(Sender: TObject);
begin
  FProject.LCDC.BGWindowTiles := True;
  FProject.UpdateTileMapCache();
  FProject.TriggerRegisterUpdate([rgLCDC]);
end;

procedure TFormRegisters.RadioButtonLCDC60Click(Sender: TObject);
begin
  FProject.LCDC.WindowTileMap := False;
  FProject.TriggerRegisterUpdate([rgLCDC]);
end;

procedure TFormRegisters.RadioButtonLCDC61Click(Sender: TObject);
begin
  FProject.LCDC.WindowTileMap := True;
  FProject.TriggerRegisterUpdate([rgLCDC]);
end;

procedure TFormRegisters.SetProject(Project: TProject);
begin
  FProject := Project;
  Project.FullUpdateEvents.Add(ProjectFullUpdate);
  Project.RegisterUpdateEvents.Add(ProjectRegisterUpdate);
end;

end.
