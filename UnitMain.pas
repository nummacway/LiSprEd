unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GBUtils, Vcl.Menus, Vcl.ActnList,
  Vcl.StdActns, System.Actions, System.ImageList, Vcl.ImgList;

type
  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    View1: TMenuItem;
    Update1: TMenuItem;
    Open1: TMenuItem;
    ActionList1: TActionList;
    FileOpen: TFileOpen;
    FileSaveAs: TFileSaveAs;
    FileNew: TAction;
    ViewUpdate: TAction;
    FileSave: TAction;
    FileSave1: TMenuItem;
    SaveAs1: TMenuItem;
    ImageList: TImageList;
    procedure FileSaveAsAccept(Sender: TObject);
    procedure FileOpenAccept(Sender: TObject);
    procedure FileNewExecute(Sender: TObject);
    procedure ViewUpdateExecute(Sender: TObject);
    procedure FileSaveExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure ManageWindows();
    procedure AlignWindows();
    var
      Project: TProject;
      FileName: string;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  UnitFiles, UnitTiles, UnitTilemaps, UnitRegisters, UnitPreview, UnitPalettes,
  UnitOAM;

procedure TFormMain.AlignWindows;
begin
  if ClientHeight > 1300 then
  begin
    // Left column
    if Assigned(FormTilemaps) and Assigned(FormTiles) and Assigned(FormFiles) then
    begin
      FormTilemaps.Top := ClientHeight - FormTilemaps.Height;
      FormTilemaps.Left := 0;
      FormTiles.Top := FormTilemaps.Top - FormTiles.Height;
      FormTiles.Left := 0;
      FormFiles.Left := 0;
      FormFiles.Top := 0;
      if FormTiles.Top > 200 then
      FormFiles.Height := FormTiles.Top;
      if Assigned(FormPreview) then
      begin
        FormPreview.Top := 0;
        FormPreview.Left := FormFiles.Width;
        FormPreview.Height := ClientHeight;
      end;
    end;

    // Right column
    if Assigned(FormRegisters) and Assigned(FormPalettes) and Assigned(FormOAM) then
    begin
      FormRegisters.Left := ClientWidth - FormRegisters.Width;
      FormRegisters.Top := 0;
      FormPalettes.Left := FormRegisters.Left;
      FormPalettes.Top := FormRegisters.Height;
      FormOAM.Left := FormRegisters.Left;
      FormOAM.Top := FormPalettes.Top + FormPalettes.Height;
      if Assigned(FormPreview) then
      FormPreview.Width := FormRegisters.Left - FormPreview.Left;
    end;
  end
  else
  begin
    // Left column
    if Assigned(FormTilemaps) and Assigned(FormFiles) then
    begin
      FormTilemaps.Top := ClientHeight - FormTilemaps.Height;
      FormTilemaps.Left := 0;
      FormFiles.Left := 0;
      FormFiles.Top := 0;
      if FormTileMaps.Top > 200 then
      FormFiles.Height := FormTilemaps.Top;
      if Assigned(FormPreview) then
      begin
        FormPreview.Top := 0;
        FormPreview.Left := FormFiles.Width;
      end;
    end;

    if Assigned(FormTiles) and Assigned(FormRegisters) and Assigned(FormPreview) then
    begin
      FormTiles.Left := FormPreview.Left;
      FormTiles.Top := ClientHeight - FormTiles.Height;
      FormRegisters.Left := FormTiles.Left + FormTiles.Width;
      FormRegisters.Top := FormTiles.Top;
      FormPreview.Height := FormTiles.Top;
    end;

    // Right column
    if Assigned(FormRegisters) and Assigned(FormPalettes) and Assigned(FormOAM) then
    begin
      FormPalettes.Left := ClientWidth - FormRegisters.Width;
      FormPalettes.Top := 0;
      FormOAM.Left := ClientWidth - FormRegisters.Width;
      FormOAM.Top := FormPalettes.Top + FormPalettes.Height;
      FormPreview.Width := FormOAM.Left - FormPreview.Left;
    end;
  end;
end;

procedure TFormMain.FileNewExecute(Sender: TObject);
begin
  FreeAndNil(Project);
  Project := TProject.Create();
  FileName := '';
  WindowState := wsMaximized;
  ManageWindows();
  AlignWindows();
  ViewUpdate.Execute();
end;

procedure TFormMain.FileOpenAccept(Sender: TObject);
begin
  FreeAndNil(Project);
  Project := TProject.Create();
  Project.LoadFromFile(FileOpen.Dialog.FileName);
  FileName := FileOpen.Dialog.FileName;
  WindowState := wsMaximized;
  ManageWindows();
  AlignWindows();
  ViewUpdate.Execute();
end;

procedure TFormMain.FileSaveAsAccept(Sender: TObject);
begin
  Project.SaveToFile(FileSaveAs.Dialog.FileName);
  FileName := FileSaveAs.Dialog.FileName;
end;

procedure TFormMain.FileSaveExecute(Sender: TObject);
begin
  if FileExists(FileName) then
  Project.SaveToFile(FileName)
  else
  FileSaveAs.Execute();
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  OnResize := nil;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Mouse.DragImmediate := False;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  AlignWindows();
end;

procedure TFormMain.ManageWindows;
begin
  //for i := 0 to MDIChildCount - 1 do
  //Self.MDIChildCount
  if not Assigned(FormFiles) then
  Application.CreateForm(TFormFiles, FormFiles);
  FormFiles.SetProject(Project);
  if not Assigned(FormTiles) then
  Application.CreateForm(TFormTiles, FormTiles);
  FormTiles.SetProject(Project);
  if not Assigned(FormTilemaps) then
  Application.CreateForm(TFormTilemaps, FormTilemaps);
  FormTilemaps.SetProject(Project);
  if not Assigned(FormRegisters) then
  Application.CreateForm(TFormRegisters, FormRegisters);
  FormRegisters.SetProject(Project);
  if not Assigned(FormPreview) then
  Application.CreateForm(TFormPreview, FormPreview);
  FormPreview.SetProject(Project);
  if not Assigned(FormPalettes) then
  Application.CreateForm(TFormPalettes, FormPalettes);
  FormPalettes.SetProject(Project);
  if not Assigned(FormOAM) then
  Application.CreateForm(TFormOAM, FormOAM);
  FormOAM.SetProject(Project);
end;

procedure TFormMain.ViewUpdateExecute(Sender: TObject);
begin
  Project.UpdateTileMapCache();
  Project.UpdateOAMCache();
  Project.UpdatePAL();
  FormFiles.UpdateList();
  Project.TriggerFullUpdate();
end;

end.
