program LiSprEd;

uses
  Vcl.Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitFiles in 'UnitFiles.pas' {FormFiles},
  UnitTiles in 'UnitTiles.pas' {FormTiles},
  UnitTilemaps in 'UnitTilemaps.pas' {FormTilemaps},
  UnitPalettes in 'UnitPalettes.pas' {FormPalettes},
  UnitRegisters in 'UnitRegisters.pas' {FormRegisters},
  UnitOAM in 'UnitOAM.pas' {FormOAM},
  UnitPreview in 'UnitPreview.pas' {FormPreview},
  UnitView in 'UnitView.pas' {FormView},
  UnitFileProperties in 'UnitFileProperties.pas' {FormFileProperties},
  GBUtils in 'GBUtils.pas',
  ClassHelpers in 'ClassHelpers.pas',
  UnitOverlays in 'UnitOverlays.pas' {FormOverlays},
  pngimage in 'pngimage.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormOverlays, FormOverlays);
  {Application.CreateForm(TFormFiles, FormFiles);
  Application.CreateForm(TFormTiles, FormTiles);
  Application.CreateForm(TFormTilemaps, FormTilemaps);
  Application.CreateForm(TFormPalettes, FormPalettes);
  Application.CreateForm(TFormRegisters, FormRegisters);
  Application.CreateForm(TFormOAM, FormOAM);
  Application.CreateForm(TFormPreview, FormPreview);
  Application.CreateForm(TFormView, FormView);
  Application.CreateForm(TFormFileProperties, FormFileProperties);    }
  Application.Run;
end.
