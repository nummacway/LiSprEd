unit UnitFileProperties;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, GBUtils;

type
  TFormFileProperties = class(TForm)
    Label1: TLabel;
    ComboBoxFileClass: TComboBox;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    EditFileOffsetBytes: TEdit;
    EditFileOffsetPieces: TEdit;
    Label3: TLabel;
    EditFileOffsetToBytes: TEdit;
    EditFileOffsetToPieces: TEdit;
    Label4: TLabel;
    EditSizeBytes: TEdit;
    EditSizePieces: TEdit;
    LabelSizeOf: TLabel;
    EditSizeOfBytes: TEdit;
    EditSizeOfPieces: TEdit;
    Label5: TLabel;
    EditGBOffsetBytes: TEdit;
    EditGBOffsetPieces: TEdit;
    Label6: TLabel;
    EditGBOffsetToBytes: TEdit;
    EditGBOffsetToPieces: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxFileClassSelect(Sender: TObject);
    procedure EditFileOffsetBytesChange(Sender: TObject);
    procedure EditSizeBytesChange(Sender: TObject);
    procedure EditGBOffsetBytesChange(Sender: TObject);
    procedure EditFileOffsetPiecesChange(Sender: TObject);
    procedure EditSizePiecesChange(Sender: TObject);
    procedure EditGBOffsetPiecesChange(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure SetFileName(AFileName: string);
    function GetFile: TFile;
    procedure SetFile(const Value: TFile);
    var
      FProject: TProject;
      FFileName: string;
      FFileSize: Integer;
      FMustLoad: Boolean; // size does not have to be in range of the file
  public
    { Public-Deklarationen }
    procedure New(const AFileName: string; AProject: TProject; AMustLoad: Boolean);
    procedure UpdateAllPieces();
    procedure Validate();
    property DataFile: TFile read GetFile write SetFile;
    var
      FC: TFileClass;
  end;

var
  FormFileProperties: TFormFileProperties;

implementation

{$R *.dfm}

uses
  ClassHelpers, Math;

procedure TFormFileProperties.ButtonOKClick(Sender: TObject);
const
  STooManyBytes = 'Processing %s bytes from the file offset of %s would exceed the file size of %d.'#13#10#13#10'Do you want to process the file until its end instead?';
begin
  if FMustLoad then
  if StrToInt(EditFileOffsetBytes.Text) + StrToInt(EditSizeBytes.Text) > FFileSize then
  case MessageDlg(Format(STooManyBytes, [EditSizeBytes.Text, EditFileOffsetBytes.Text, FFileSize]), mtWarning, [mbYes, mbIgnore, mbCancel], 0, mbYes) of
    mrYes: EditSizeBytes.Text := IntToStr(FFileSize - StrToInt(EditFileOffsetBytes.Text));
    mrIgnore: ;
    else Exit;
  end;
  ModalResult := mrOk;
end;

procedure TFormFileProperties.ComboBoxFileClassSelect(Sender: TObject);
begin
  FC := FileClasses[ComboBoxFileClass.ItemIndex];
  EditFileOffsetBytes.TextNoChange := 'x0';
  if FMustLoad then
  EditSizeBytes.TextNoChange := 'x' + IntToHex(Min(FC.GetMaxPieces() * FC.GetBytesPerPiece(), FFileSize), 0)
  else
  EditSizeBytes.TextNoChange := 'x' + IntToHex(FC.GetMaxPieces() * FC.GetBytesPerPiece(), 0);
  EditGBOffsetBytes.TextNoChange := 'x' + IntToHex(FC.GetMinStartOffset(), 4);
  EditSizeOfBytes.TextNoChange := 'x' + IntToHex(FFileSize, 0);
  if FFileSize mod FC.GetBytesPerPiece() = 0 then
  EditSizeOfPieces.TextNoChange := IntToStr(FFileSize div FC.GetBytesPerPiece())
  else
  EditSizeOfPieces.TextNoChange := '';
  UpdateAllPieces();
end;

procedure TFormFileProperties.EditFileOffsetBytesChange(Sender: TObject);
var
  Value: Integer;
begin
  if TryStrToInt(EditFileOffsetBytes.Text, Value) then
  if Value mod FC.GetBytesPerPiece() = 0 then
  EditFileOffsetPieces.TextNoChange := IntToStr(Value div FC.GetBytesPerPiece())
  else
  EditFileOffsetPieces.TextNoChange := '';
  Validate();
end;

procedure TFormFileProperties.EditFileOffsetPiecesChange(Sender: TObject);
var
  Temp: Integer;
begin
  if TryStrToInt(EditFileOffsetPieces.Text, Temp) then
  EditFileOffsetBytes.TextNoChange := 'x' + IntToHex(Temp*FC.GetBytesPerPiece(), 0);
  Validate();
end;

procedure TFormFileProperties.EditGBOffsetBytesChange(Sender: TObject);
var
  Value: Integer;
begin
  if TryStrToInt(EditGBOffsetBytes.Text, Value) then
  if Value mod FC.GetBytesPerPiece() = 0 then
  EditGBOffsetPieces.TextNoChange := IntToStr((Value - FC.GetMinStartOffset) div FC.GetBytesPerPiece())
  else
  EditGBOffsetPieces.TextNoChange := '';
  Validate();
end;

procedure TFormFileProperties.EditGBOffsetPiecesChange(Sender: TObject);
var
  Temp: Integer;
begin
  if TryStrToInt(EditGBOffsetPieces.Text, Temp) then
  EditGBOffsetBytes.TextNoChange := 'x' + IntToHex(FC.GetMinStartOffset()+Temp*FC.GetBytesPerPiece(), 4);
  Validate();
end;

procedure TFormFileProperties.EditSizeBytesChange(Sender: TObject);
var
  Value: Integer;
begin
  if TryStrToInt(EditSizeBytes.Text, Value) then
  if Value mod FC.GetBytesPerPiece() = 0 then
  EditSizePieces.TextNoChange := IntToStr(Value div FC.GetBytesPerPiece())
  else
  EditSizePieces.TextNoChange := '';
  Validate();
end;

procedure TFormFileProperties.EditSizePiecesChange(Sender: TObject);
var
  Temp: Integer;
begin
  if TryStrToInt(EditSizePieces.Text, Temp) then
  EditSizeBytes.TextNoChange := 'x' + IntToHex(Temp*FC.GetBytesPerPiece(), 0);
  Validate();
end;

procedure TFormFileProperties.FormCreate(Sender: TObject);
var
  FC: TFileClass;
begin
  ComboBoxFileClass.Items.BeginUpdate();
  try
    ComboBoxFileClass.Items.Clear;
    for FC in FileClasses do
    ComboBoxFileClass.Items.Add(FC.GetLongName());
  finally
    ComboBoxFileClass.Items.EndUpdate();
  end;
end;

function TFormFileProperties.GetFile: TFile;
begin
  Result := FC.Create(FFileName, StrToInt(EditFileOffsetBytes.Text), StrToInt(EditSizeBytes.Text), StrToInt(EditGBOffsetBytes.Text), FProject);
end;

procedure TFormFileProperties.New(const AFileName: string; AProject: TProject; AMustLoad: Boolean);
begin
  FMustLoad := AMustLoad;
  FProject := AProject;
  ComboBoxFileClass.ItemIndex := 0;
  SetFileName(AFileName);
  ComboBoxFileClassSelect(nil);
end;

procedure TFormFileProperties.SetFile(const Value: TFile);
var
  i: Integer;
begin
  FProject := Value.Project;
  FFileName := Value.FileName;
  FMustLoad := False; // questionable, but basically we have to do this
  FFileSize := 0;
  LabelSizeOf.Hide();
  EditSizeOfBytes.Hide();
  EditSizeOfPieces.Hide();
  for i := Low(FileClasses) to High(FileClasses) do
  if Value is FileClasses[i] then
  begin
    FC := FileClasses[i];
    ComboBoxFileClass.ItemIndex := i;
    EditFileOffsetBytes.Text := 'x' + IntToHex(Value.FileOffset, 4);
    EditSizeBytes.Text := 'x' + IntToHex(Value.Size, 4);
    EditGBOffsetBytes.Text := 'x' + IntToHex(Value.GBOffset, 4);
  end;
  ComboBoxFileClass.Enabled := False;
end;

procedure TFormFileProperties.SetFileName(AFileName: string);
var
  FS: TFileStream;
begin
  FFileSize := 0;
  FFileName := AFileName;
  if FileExists(AFileName) then
  begin
    FS := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
    try
      FFileSize := FS.Size;
    finally
      FS.Free();
    end;
  end;
end;

procedure TFormFileProperties.UpdateAllPieces;
begin
  EditFileOffsetBytesChange(nil);
  EditSizeBytesChange(nil);
  EditGBOffsetBytesChange(nil);
end;

procedure TFormFileProperties.Validate;
var
  Valid: Boolean;
  FileOffset, Size, GBOffset: Integer;
begin
  Valid := True;
  if not TryStrToInt(EditFileOffsetBytes.Text, FileOffset) then
  Valid := False;
  if not TryStrToInt(EditSizeBytes.Text, Size) then
  Valid := False;
  if not TryStrToInt(EditGBOffsetBytes.Text, GBOffset) then
  Valid := False;
  if FMustLoad then
  if Size > FFileSize then
  Valid := False;
  if Size > FC.GetMaxPieces() * FC.GetBytesPerPiece() then
  Valid := False;

  if Valid then
  begin
    EditFileOffsetToBytes.Text := 'x' + IntToHex(FileOffset + Size - 1, 4);
    if (FileOffset + Size) mod FC.GetBytesPerPiece() = 0 then
    EditFileOffsetToPieces.Text := IntToStr((FileOffset + Size) div FC.GetBytesPerPiece() - 1)
    else
    EditFileOffsetToPieces.Text := '';

    EditGBOffsetToBytes.Text := 'x' + IntToHex(GBOffset + Size - 1, 4);
    if (GBOffset + Size) mod FC.GetBytesPerPiece() = 0 then
    EditGBOffsetToPieces.Text := IntToStr((GBOffset + Size - FC.GetMinStartOffset()) div FC.GetBytesPerPiece() - 1)
    else
    EditGBOffsetToPieces.Text := '';
  end;

  ButtonOK.Enabled := Valid;
end;

end.
