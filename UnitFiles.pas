unit UnitFiles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, GBUtils,
  Vcl.Menus;

type
  TFormFiles = class(TForm)
    ListView: TListView;
    Panel1: TPanel;
    ButtonLoad: TButton;
    ButtonNew: TButton;
    ButtonEdit: TButton;
    OpenDialog: TOpenDialog;
    ButtonRemove: TButton;
    PopupMenu: TPopupMenu;
    MenuItemAutoAddEmuliciousExports: TMenuItem;
    OpenDialogEmulicious: TOpenDialog;
    ButtonReload: TButton;
    ButtonSaveAs: TButton;
    SaveDialog: TSaveDialog;
    procedure ButtonLoadClick(Sender: TObject);
    procedure MenuItemAutoAddEmuliciousExportsClick(Sender: TObject);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ButtonRemoveClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonNewClick(Sender: TObject);
    procedure ButtonReloadClick(Sender: TObject);
    procedure ButtonSaveAsClick(Sender: TObject);
    procedure ListViewStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ListViewDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListViewEndDrag(Sender, Target: TObject; X, Y: Integer);
  private
    { Private-Deklarationen }
    var
      FProject: TProject;
  public
    { Public-Deklarationen }
    procedure UpdateList();
    procedure SetProject(Project: TProject);
  end;

var
  FormFiles: TFormFiles;

implementation

uses
  UnitFileProperties;

{$R *.dfm}

procedure TFormFiles.ButtonEditClick(Sender: TObject);
begin
  Application.CreateForm(TFormFileProperties, FormFileProperties);
  try
    FormFileProperties.DataFile := FProject.Files[ListView.Selected.Index];
    if FormFileProperties.ShowModal() = mrOk then
    begin
      FProject.Files[ListView.Selected.Index] := FormFileProperties.DataFile;
      if MessageDlg('Do you want to load the edited file?', mtInformation, mbYesNo, 0) = mrYes then
      FProject.Files[ListView.Selected.Index].LoadFromFile();
    end;
  finally
    FormFileProperties.Free();
    UpdateList();
    FProject.TriggerFullUpdate();
  end;
end;

procedure TFormFiles.ButtonLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute() then
  begin
    Application.CreateForm(TFormFileProperties, FormFileProperties);
    try
      FormFileProperties.New(OpenDialog.FileName, FProject, True);
      if FormFileProperties.ShowModal() = mrOk then
      begin
        FProject.Files.Add(FormFileProperties.DataFile);
        FProject.Files.Last().LoadFromFile();
      end;
    finally
      FormFileProperties.Free();
      UpdateList();
      FProject.TriggerFullUpdate();
    end;
  end;
end;

procedure TFormFiles.ButtonNewClick(Sender: TObject);
begin
  if SaveDialog.Execute() then
  begin
    Application.CreateForm(TFormFileProperties, FormFileProperties);
    try
      FormFileProperties.New(SaveDialog.FileName, FProject, False);
      if FormFileProperties.ShowModal() = mrOk then
      begin
        FProject.Files.Add(FormFileProperties.DataFile);
        FProject.Files.Last().SaveToFile();
      end;
    finally
      FormFileProperties.Free();
      UpdateList();
    end;
  end;
end;

procedure TFormFiles.ButtonReloadClick(Sender: TObject);
var
  DataFile: TFile;
begin
  for DataFile in FProject.Files do
  DataFile.LoadFromFile();
  FProject.UpdateTileMapCache();
  FProject.UpdateOAMCache();
  FProject.UpdatePAL();
  FProject.TriggerFullUpdate();
end;

procedure TFormFiles.ButtonRemoveClick(Sender: TObject);
var
  i: Integer;
begin
  try
    for i := ListView.Items.Count - 1 downto 0 do
    if ListView.Items[i].Selected then
    begin
      ListView.Items[i].Delete();
      FProject.Files.Delete(i);
    end;
  finally
    UpdateList();
    // No update needed
  end;
end;

procedure TFormFiles.ButtonSaveAsClick(Sender: TObject);
begin
  try
    SaveDialog.FileName := FProject.Files[ListView.Selected.Index].FileName;
    if SaveDialog.Execute() then
    begin
      FProject.Files[ListView.Selected.Index].FileName := SaveDialog.FileName;
      FProject.Files[ListView.Selected.Index].SaveToFile();
    end;
  finally
    UpdateList();
  end;
end;

procedure TFormFiles.ListViewDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  TargetIndex: Integer;
begin
  TargetIndex := ListView.GetItemAt(X, Y).Index;
  FProject.Files.Move(FProject.DnDData, TargetIndex);
  UpdateList();
end;

procedure TFormFiles.ListViewDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := False;
  if FProject.DnDType = ddFile then
  Accept := Assigned(ListView.GetItemAt(X, Y));
end;

procedure TFormFiles.ListViewEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  FProject.DnDType := ddNone;
end;

procedure TFormFiles.ListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
   ButtonEdit.Enabled := ListView.SelCount = 1;
   ButtonSaveAs.Enabled := ListView.SelCount = 1;
   ButtonRemove.Enabled := ListView.SelCount > 0;
   if ListView.SelCount = 1 then
   ListView.DragMode := dmAutomatic
   else
   ListView.DragMode := dmManual;
end;

procedure TFormFiles.ListViewStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  FProject.DnDType := ddFile;
  FProject.DnDData := ListView.Selected.Index;
end;

procedure TFormFiles.MenuItemAutoAddEmuliciousExportsClick(Sender: TObject);
procedure AddFile(FileClass: TFileClass; const Ext: string; Offset: Integer);
begin
  FProject.Files.Add(FileClass.Create(ChangeFileExt(OpenDialogEmulicious.FileName, Ext), Offset, FileClass.GetMaxPieces() * FileClass.GetBytesPerPiece(), FileClass.GetMinStartOffset(), FProject));
  FProject.Files.Last.LoadFromFile();
end;
begin
  if OpenDialogEmulicious.Execute() then
  begin
    if FileExists(ChangeFileExt(OpenDialogEmulicious.FileName, '.vrm')) then
    begin
      AddFile(TTiles0File, '.vrm', $0000);
      AddFile(TTileMapFile, '.vrm', $1800);
      AddFile(TTiles1File, '.vrm', $2000);
      AddFile(TAttributeMapFile, '.vrm', $3800);
      FProject.UpdateTileMapCache();
    end;

    if FileExists(ChangeFileExt(OpenDialogEmulicious.FileName, '.bin')) then
    AddFile(TOAMFile, '.bin', $0000);

    if FileExists(ChangeFileExt(OpenDialogEmulicious.FileName, '.pal')) then
    begin
      AddFile(TBGPalRawFile, '.pal', $0000);
      AddFile(TOBJPalRawFile, '.pal', $0040);
      FProject.UpdatePAL();
    end;

    FProject.UpdateOAMCache();
    UpdateList();
    FProject.TriggerFullUpdate();
  end;
end;

procedure TFormFiles.SetProject(Project: TProject);
begin
  FProject := Project;
end;

procedure TFormFiles.UpdateList;
var
  F: TFile;
begin
  ListView.Items.BeginUpdate();
  try
    ListView.Items.Clear();
    for F in FProject.Files do
    with ListView.Items.Add do
    begin
      Data := Pointer(F.GetID());
      Caption := ExtractFileName(F.FileName);
      SubItems.Add(F.GetShortName());
      SubItems.Add(F.IntToMonospaceHex(F.FileOffset, 4, True)+'-'+F.IntToMonospaceHex(F.FileOffset+F.Size-1, 4, False));
      SubItems.Add(F.IntToMonospaceHex(F.GBOffset, 4, True)+#150+F.IntToMonospaceHex(F.GBOffset+F.Size-1, 4, False));
      if F.Size mod F.GetBytesPerPiece() = 0 then
      SubItems.Add(IntToStr(F.Size div F.GetBytesPerPiece()));
    end;
  finally
    ListView.Items.EndUpdate();
    ListViewSelectItem(ListView, nil, False);
  end;
end;

end.
