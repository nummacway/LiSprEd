unit UnitOverlays;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.ExtDlgs;

type
  TFormOverlays = class(TForm)
    Panel1: TPanel;
    ButtonLoad: TButton;
    ButtonEdit: TButton;
    ButtonRemove: TButton;
    ButtonReload: TButton;
    ListView: TListView;
    OpenPictureDialog: TOpenPictureDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOverlays: TFormOverlays;

implementation

{$R *.dfm}

end.
