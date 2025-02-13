unit GBUtils;

interface

uses
  Graphics, PNGImage, Windows, Generics.Collections, Classes;

type
  TRegister = (rgLCDC = $40, rgSCY = $42, rgSCX, rgBGP = $47, rgOBP0, rgOBP1, rgWY, rgWX, rgKEY0, rgOPRI = $6C);
  TRegisters = set of TRegister;

const
  AllRegisters = [rgLCDC, rgSCY, rgSCX, rgBGP, rgOBP0, rgOBP1, rgWY, rgWX, rgKEY0, rgOPRI];

type
  TProject = class;

  TFile = class
    class function GetShortName(): string; virtual; abstract;
    class function GetLongName(): string; virtual; abstract;
    class function GetMinStartOffset(): Integer; virtual; abstract;
    class function GetBytesPerPiece(): Integer; virtual; abstract;
    class function GetMaxPieces(): Integer; virtual; abstract;
    class function GetID(): Integer; virtual; abstract;
    var
      FileName: string;
      FileOffset: Integer;
      Size: Integer;
      GBOffset: Integer;
      Project: TProject;
    constructor Create(AFileName: string; AFileOffset: Integer; ASize: Integer; AGBOffset: Integer; AProject: TProject);
    procedure LoadFromFile();
    procedure SaveToFile();
    class function IntToMonospaceHex(const Value, Digits: Integer; IncludePrefix: Boolean): string;
    private
      procedure DoLoadFromFile(Stream: TStream); virtual; abstract;
      procedure DoSaveToFile(Stream: TStream); virtual; abstract;
  end;

  TFileClass = class of TFile;

  TTiles0File = class(TFile)
    class function GetShortName(): string; override;
    class function GetLongName(): string; override;
    class function GetMinStartOffset(): Integer; override;
    class function GetBytesPerPiece(): Integer; override;
    class function GetMaxPieces(): Integer; override;
    class function GetID(): Integer; override;
    procedure DoLoadFromFile(Stream: TStream); override;
    procedure DoSaveToFile(Stream: TStream); override;
  end;

  TTiles1File = class(TFile)
    class function GetShortName(): string; override;
    class function GetLongName(): string; override;
    class function GetMinStartOffset(): Integer; override;
    class function GetBytesPerPiece(): Integer; override;
    class function GetMaxPieces(): Integer; override;
    class function GetID(): Integer; override;
    procedure DoLoadFromFile(Stream: TStream); override;
    procedure DoSaveToFile(Stream: TStream); override;
  end;

  TTileMapFile = class(TFile)
    class function GetShortName(): string; override;
    class function GetLongName(): string; override;
    class function GetMinStartOffset(): Integer; override;
    class function GetBytesPerPiece(): Integer; override;
    class function GetMaxPieces(): Integer; override;
    class function GetID(): Integer; override;
    procedure DoLoadFromFile(Stream: TStream); override;
    procedure DoSaveToFile(Stream: TStream); override;
  end;

  TAttributeMapFile = class(TFile)
    class function GetShortName(): string; override;
    class function GetLongName(): string; override;
    class function GetMinStartOffset(): Integer; override;
    class function GetBytesPerPiece(): Integer; override;
    class function GetMaxPieces(): Integer; override;
    class function GetID(): Integer; override;
    procedure DoLoadFromFile(Stream: TStream); override;
    procedure DoSaveToFile(Stream: TStream); override;
  end;

  TOAMFile = class(TFile)
    class function GetShortName(): string; override;
    class function GetLongName(): string; override;
    class function GetMinStartOffset(): Integer; override;
    class function GetBytesPerPiece(): Integer; override;
    class function GetMaxPieces(): Integer; override;
    class function GetID(): Integer; override;
    procedure DoLoadFromFile(Stream: TStream); override;
    procedure DoSaveToFile(Stream: TStream); override;
  end;

  TBGPalRawFile = class(TFile)
    class function GetShortName(): string; override;
    class function GetLongName(): string; override;
    class function GetMinStartOffset(): Integer; override;
    class function GetBytesPerPiece(): Integer; override;
    class function GetMaxPieces(): Integer; override;
    class function GetID(): Integer; override;
    procedure DoLoadFromFile(Stream: TStream); override;
    procedure DoSaveToFile(Stream: TStream); override;
  end;

  TOBJPalRawFile = class(TFile)
    class function GetShortName(): string; override;
    class function GetLongName(): string; override;
    class function GetMinStartOffset(): Integer; override;
    class function GetBytesPerPiece(): Integer; override;
    class function GetMaxPieces(): Integer; override;
    class function GetID(): Integer; override;
    procedure DoLoadFromFile(Stream: TStream); override;
    procedure DoSaveToFile(Stream: TStream); override;
  end;

  TOverlay = record
    FileName: string;
    Bounds: TRect;
  end;

  TTileAttributes = packed record
    private
      function GetBank: Boolean;
      function GetDMGPaletteIndex: Boolean;
      function GetPriority: Boolean;
      function GetXFlip: Boolean;
      function GetYFlip: Boolean;
      function GetCGBPaletteIndex: Byte;
      procedure SetBank(const Value: Boolean);
      procedure SetCGBPaletteIndex(const Value: Byte);
      procedure SetDMGPaletteIndex(const Value: Boolean);
      procedure SetPriority(const Value: Boolean);
      procedure SetXFlip(const Value: Boolean);
      procedure SetYFlip(const Value: Boolean);
    public
      AsByte: Byte;
      property Priority: Boolean read GetPriority write SetPriority;
      property YFlip: Boolean read GetYFlip write SetYFlip;
      property XFlip: Boolean read GetXFlip write SetXFlip;
      property DMGPaletteIndex: Boolean read GetDMGPaletteIndex write SetDMGPaletteIndex; // OAM only
      property Bank: Boolean read GetBank write SetBank;
      property CGBPaletteIndex: Byte read GetCGBPaletteIndex write SetCGBPaletteIndex;
      procedure WriteTileTo(Target: TPNGImage; X, Y: Integer; Tile: Byte; IsObj: Boolean; Project: TProject; ForceSupportBank: Boolean = False);
  end;

  TOAMObj = packed record
    Y, X, Tile: Byte;
    Attributes: TTileAttributes;
    function ContainsTile(Tile: Byte; Bank: Boolean; Project: TProject): Boolean;
    function IsOnScreen(Project: TProject): Boolean;
  end;

  TCGBColor = packed record
    private
      function GetColor: TColor;
      function GetCSSNoHash: string;
      procedure SetColor(const Value: TColor);
    public
      RGB555: Word;
      property Color: TColor read GetColor write SetColor;
      property CSSNoHash: string read GetCSSNoHash;
      function TrySetCSS(Value: string): Boolean;
  end;

  TVRAMTiles = packed array[$8000..$97FF] of Byte;
  TVRAMTileMap = packed array[$9800..$9FFF] of Byte;
  TVRAMTileAttributes = packed array[$9800..$9FFF] of TTileAttributes;
  TOAM = packed record
    case Boolean of
      True: (OAM: packed array[0..39] of TOAMObj);
      False: (Bytes: packed array[$FE00..$FE9F] of Byte);
  end;
  TCGBPalette = packed array[0..3] of TCGBColor;
  TCGBPalettes = packed array[0..7] of TCGBPalette;

  TDMGPalette = packed record
    private
      function GetColor(Index: Byte): TColor;
      function GetID(Index: Byte): Byte;
      procedure SetID(Index: Byte; const Value: Byte);
    public
      AsByte: Byte;
      property ID[Index: Byte]: Byte read GetID write SetID;
      property Color[Index: Byte]: TColor read GetColor;
  end;

  TLCDC = record
    private
      function GetBGTileMap: Boolean;
      function GetBGWindowEnablePriority: Boolean;
      function GetBGWindowTiles: Boolean;
      function GetOBJEnable: Boolean;
      function GetOBJSize: Boolean;
      function GetWindoeEnable: Boolean;
      function GetWindowTileMap: Boolean;
      procedure SetBGTileMap(const Value: Boolean);
      procedure SetBGWindowEnablePriority(const Value: Boolean);
      procedure SetBGWindowTiles(const Value: Boolean);
      procedure SetOBJEnable(const Value: Boolean);
      procedure SetOBJSize(const Value: Boolean);
      procedure SetWindowEnable(const Value: Boolean);
      procedure SetWindowTileMap(const Value: Boolean);
    public
      AsByte: Byte;
      // do we need LCD enable?
      property WindowTileMap: Boolean read GetWindowTileMap write SetWindowTileMap;
      property WindowEnable: Boolean read GetWindoeEnable write SetWindowEnable;
      property BGWindowTiles: Boolean read GetBGWindowTiles write SetBGWindowTiles;
      property BGTileMap: Boolean read GetBGTileMap write SetBGTileMap;
      property OBJSize: Boolean read GetOBJSize write SetOBJSize;
      property OBJEnable: Boolean read GetOBJEnable write SetOBJEnable;
      property BGWindowEnablePriority: Boolean read GetBGWindowEnablePriority write SetBGWindowEnablePriority;
  end;

  TTileUpdateEvent = procedure (Sender: TProject; TileAddr: Word; Bank: Boolean) of object;
  TTileMapUpdateEvent = procedure (Sender: TProject; Index, X, Y: Byte) of object;
  TPaletteUpdateEvent = procedure (Sender: TProject; IsObj: Boolean; PaletteIndex: Byte; ColorIndex: Byte) of object;
  TOAMUpdateEvent = procedure (Sender: TProject; OAMIndex: Byte) of object;
  TRegisterUpdateEvent = procedure (Sender: TProject; Registers: TRegisters) of object;
  TFullUpdateEvent = procedure (Sender: TProject) of object;

  TDnDType = (ddNone = 0, ddTile, ddOAM, ddOverlayMove, ddOverlayResize);

  TProject = class
    private
      const
        TransparentColor = $FE00FE; // impossible color
    public
      VRAM0Tiles: TVRAMTiles; // Tiles
      VRAM0Maps: TVRAMTileMap; // Tilemaps
      VRAM1Tiles: TVRAMTiles; // Tiles, Tile Attributes
      VRAM1Maps: TVRAMTileAttributes; // Tile Attributes
      OAM: TOAM;
      CGBBGPal: TCGBPalettes;
      CGBOBJPal: TCGBPalettes;
      // I/O Registers
      LCDC: TLCDC; // $FF40
      SCY: Byte; // FF42
      SCX: Byte; // FF43
      WY: Byte; // FF4A
      WX: Byte; // FF4B
      BGP: TDMGPalette; // $FF47
      OBP: array[0..1] of TDMGPalette; // $FF48/FF49
      IsCGB: Boolean; // FF4C
      OPRI: Boolean; // FF6C

      Files: TObjectList<TFile>;
      Overlays: TList<TOverlay>;

      TileUpdateEvents: TList<TTileUpdateEvent>;
      TileMapUpdateEvents: TList<TTileMapUpdateEvent>;
      PaletteUpdateEvents: TList<TPaletteUpdateEvent>;
      OAMUpdateEvents: TList<TOAMUpdateEvent>;
      RegisterUpdateEvents: TList<TRegisterUpdateEvent>;
      FullUpdateEvents: TList<TFullUpdateEvent>;

      // Cache
      TileMapImages: array[0..1] of TPNGImage;
      OAMImages: array[0..39] of TPNGIMage;

      // DnD
      DnDType: TDnDType;
      DnDData: Integer;
      DnDData2: Boolean;

      constructor Create(); reintroduce;
      destructor Destroy(); override;

      procedure ReadFromTile(Target: TPNGImage; X, Y: Integer; TileAddr: Word; Bank: Boolean; PalIndex: array of Byte; XFlip: Boolean; YFlip: Boolean);
      procedure WriteToTile(Source: TPNGImage; X, Y: Integer; TileAddr: Word; Bank: Boolean; XFlip: Boolean; YFlip: Boolean);

      procedure TriggerTileUpdate(Tile: Byte; IsObj: Boolean; Bank: Boolean); overload;
      procedure TriggerTileUpdate(TileAddr: Word; Bank: Boolean); overload;
      procedure TriggerTileMapUpdate(Index, X, Y: Byte);
      procedure TriggerPaletteUpdate(IsObj: Boolean; PaletteIndex: Byte; ColorIndex: Byte);
      procedure TriggerOAMUpdate(OAMIndex: Byte);
      procedure TriggerRegisterUpdate(Registers: TRegisters);
      procedure TriggerFullUpdate();

      procedure UpdateOAMCache();
      procedure UpdateOAMCacheByTile(Tile: Byte; Bank: Boolean; TriggerEvent: Boolean);
      procedure UpdateOAMCacheByIndex(Index: Byte);
      procedure WriteOAMCacheByIndex(Index: Byte);
      procedure UpdateTileMapCache();
      procedure UpdateTileMapCacheByTile(Tile: Byte; Bank: Boolean);
      procedure UpdateTileMapCacheByTileAddr(TileAddr: Word; Bank: Boolean);
      procedure UpdateTileMapCacheByLocation(Index, X, Y: Byte);
      procedure UpdatePAL();
      function GetOAMs(LY: Byte): TArray<Byte>; // OAM Scan
      procedure LoadFromFile(const FileName: string);
      procedure SaveToFile(const FileName: string);
      const
      { Index  | Usage
        -------+--------
             0 | Transparency
          1..4 | DMG BG
          5..7 | DMG OBJ0
         8..10 | DMG OBJ1
        11..42 | CGB BG
        43..66 | CGB OBJ }
        PalIndexToIsObj: array[0..66] of Boolean = (True,
                                                    False, False, False, False,
                                                    True, True, True,
                                                    True, True, True,
                                                    False, False, False, False,
                                                    False, False, False, False,
                                                    False, False, False, False,
                                                    False, False, False, False,
                                                    False, False, False, False,
                                                    False, False, False, False,
                                                    False, False, False, False,
                                                    False, False, False, False,
                                                    True, True, True,
                                                    True, True, True,
                                                    True, True, True,
                                                    True, True, True,
                                                    True, True, True,
                                                    True, True, True,
                                                    True, True, True,
                                                    True, True, True);
        PalIndexToPaletteIndex: array[0..66] of Byte = (0,
                                                        0,0,0,0,
                                                        0,0,0,
                                                        1,1,1,
                                                        0,0,0,0,
                                                        1,1,1,1,
                                                        2,2,2,2,
                                                        3,3,3,3,
                                                        4,4,4,4,
                                                        5,5,5,5,
                                                        6,6,6,6,
                                                        7,7,7,7,
                                                        0,0,0,
                                                        1,1,1,
                                                        2,2,2,
                                                        3,3,3,
                                                        4,4,4,
                                                        5,5,5,
                                                        6,6,6,
                                                        7,7,7);
        PalIndexToColorIndex: array[0..66] of Byte = (0,
                                                      0,1,2,3,
                                                      1,2,3,
                                                      1,2,3,
                                                      0,1,2,3,
                                                      0,1,2,3,
                                                      0,1,2,3,
                                                      0,1,2,3,
                                                      0,1,2,3,
                                                      0,1,2,3,
                                                      0,1,2,3,
                                                      0,1,2,3,
                                                      1,2,3,
                                                      1,2,3,
                                                      1,2,3,
                                                      1,2,3,
                                                      1,2,3,
                                                      1,2,3,
                                                      1,2,3,
                                                      1,2,3);
  end;

const
  FileClasses: array[0..6] of TFileClass = (TTiles0File, TTiles1File, TTileMapFile, TAttributeMapFile, TOAMFile, TBGPalRawFile, TOBJPalRawFile);

var
  RGBFullRange: Boolean = True; // False: shl 3; True: /31*255

  ForegroundIsTrans: Boolean;
  ForegroundIsObj: Boolean;
  ForegroundPaletteIndex: Byte;
  ForegroundColorIndex: Byte;
  ForegroundIndex: Integer;
  BackgroundIsTrans: Boolean;
  BackgroundIsObj: Boolean;
  BackgroundPaletteIndex: Byte;
  BackgroundColorIndex: Byte;
  BackgroundIndex: Integer;


implementation

{ TTileAttributes }

uses
  SysUtils, Types, Math, Generics.Defaults, IniFiles;

function TTileAttributes.GetBank: Boolean;
begin
  Result := (AsByte and $08) <> 0;
end;

function TTileAttributes.GetCGBPaletteIndex: Byte;
begin
  Result := AsByte and 7;
end;

function TTileAttributes.GetDMGPaletteIndex: Boolean;
begin
  Result := (AsByte and $10) <> 0;
end;

function TTileAttributes.GetPriority: Boolean;
begin
  Result := (AsByte and $80) <> 0;
end;

function TTileAttributes.GetXFlip: Boolean;
begin
  Result := (AsByte and $20) <> 0;
end;

function TTileAttributes.GetYFlip: Boolean;
begin
  Result := (AsByte and $40) <> 0;
end;

procedure TTileAttributes.SetBank(const Value: Boolean);
begin
  if Value then
  AsByte := AsByte or $08
  else
  AsByte := AsByte and not $08;
end;

procedure TTileAttributes.SetCGBPaletteIndex(const Value: Byte);
begin
  AsByte := (Value and $07) or (AsByte and not $07);
end;

procedure TTileAttributes.SetDMGPaletteIndex(const Value: Boolean);
begin
  if Value then
  AsByte := AsByte or $10
  else
  AsByte := AsByte and not $10;
end;

procedure TTileAttributes.SetPriority(const Value: Boolean);
begin
  if Value then
  AsByte := AsByte or $80
  else
  AsByte := AsByte and not $80;
end;

procedure TTileAttributes.SetXFlip(const Value: Boolean);
begin
  if Value then
  AsByte := AsByte or $20
  else
  AsByte := AsByte and not $20;
end;

procedure TTileAttributes.SetYFlip(const Value: Boolean);
begin
  if Value then
  AsByte := AsByte or $40
  else
  AsByte := AsByte and not $40;
end;

procedure TTileAttributes.WriteTileTo(Target: TPNGImage; X, Y: Integer; Tile: Byte; IsObj: Boolean; Project: TProject; ForceSupportBank: Boolean);

var
  PalIndex: array[0..3] of Byte;
  Start: Word;
  i, j: Integer;
begin
  // Get palette indizes
  if Project.IsCGB then
  begin
    if IsObj then
    PalIndex[1] := 43+CGBPaletteIndex*3
    else
    PalIndex[0] := 11+CGBPaletteIndex*4;
  end
  else
  begin
    if IsObj then
    PalIndex[1] := 5+Byte(DMGPaletteIndex)*3
    else
    PalIndex[0] := 1;
  end;
  if IsObj then
  PalIndex[0] := 0
  else
  PalIndex[1] := PalIndex[0] + 1;
  PalIndex[2] := PalIndex[1] + 1;
  PalIndex[3] := PalIndex[2] + 1;

  // Find pixel data
  Start := $8000 + Tile * 16;
  if Tile < 128 then
  if not IsObj then
  if not Project.LCDC.GetBGWindowTiles then
  Start := $9000 + ShortInt(Tile) * 16;

  Project.ReadFromTile(Target, X, Y, Start, Bank and (ForceSupportBank or Project.IsCGB), PalIndex, (IsObj or Project.IsCGB) and XFlip, (IsObj or Project.IsCGB) and YFlip);
end;

{ TDMGPalette }

function TDMGPalette.GetColor(Index: Byte): TColor;
begin
  case ID[Index] of
    3: Result := $000000;
    2: Result := $555555;
    1: Result := $AAAAAA;
    else
       Result := $FFFFFF;
  end;
end;

function TDMGPalette.GetID(Index: Byte): Byte;
begin
  Result := (AsByte shr (Index * 2)) and $03;
end;

procedure TDMGPalette.SetID(Index: Byte; const Value: Byte);
begin
  AsByte := (AsByte and not ($03 shl (Index * 2))) or ((Value and $03) shl (Index * 2));
end;

{ TCGBColor }

function TCGBColor.GetColor: TColor;
begin
  if RGBFullRange then
  begin
    Result := (Round((RGB555        and $001f) * 255 / 31)       ) // R
           or (Round((RGB555 shr  5 and $001f) * 255 / 31) shl  8) // G
           or (Round((RGB555 shr 10 and $001f) * 255 / 31) shl 16);// B
  end
  else
  begin
    Result := (Integer(RGB555 and $001f) shl 3) // R
           or (Integer(RGB555 and $03e0) shl 6) // G
           or (Integer(RGB555 and $ec00) shl 9);// B
  end;
end;

function TCGBColor.GetCSSNoHash: string;
var
  Color: TColor;
begin
  Color := Self.Color;
  Result := IntToHex(Byte(Color), 2) + IntToHex(Byte(Color shr 8), 2) + IntToHex(Byte(Color shr 16), 2);
end;

procedure TCGBColor.SetColor(const Value: TColor);
var
  R, G, B: Word;
begin
  R := Round((Value and $ff) * 31 / 255);
  G := Round(((Value shr 8) and $ff) * 31 / 255);
  B := Round(((Value shr 16) and $ff) * 31 / 255);
  RGB555 := R or (G shl 5) or (B shl 10);
end;

function TCGBColor.TrySetCSS(Value: string): Boolean;
var
  Temp: Integer;
begin
  Value := StringReplace(Value, '#', '', []);
  case Length(Value) of
    3: Value := Value[1] + Value[1] + Value[2] + Value[2] + Value[3] + Value[3];
    6:;
    else Exit(False);
  end;
  Result := TryStrToInt('x' + Value, Temp);
  if Result then
  Self.Color := ((Temp and $ff) shl 16) or (Temp and $ff00) or ((Temp and $ff0000) shr 16);
end;

{ TProject }

constructor TProject.Create;
var
  i: Integer;
begin
  //LCDC.AsByte := $91;
  LCDC.AsByte := $C3;
  SCY := 0;
  SCX := 0;
  WY := 0;
  WX := 0;
  BGP.AsByte := $E4; // makes more sense than the default $FC; Pokémon uses this as well
  OBP[0].AsByte := $D0; // Pokémon
  OBP[1].AsByte := $E0; // Pokémon

  // Lists
  Files := TObjectList<TFile>.Create(True);
  Overlays := TList<TOverlay>.Create();
  TileUpdateEvents := TList<TTileUpdateEvent>.Create();
  TileMapUpdateEvents := TList<TTileMapUpdateEvent>.Create();
  PaletteUpdateEvents := TList<TPaletteUpdateEvent>.Create();
  OAMUpdateEvents := TList<TOAMUpdateEvent>.Create();
  RegisterUpdateEvents := TList<TRegisterUpdateEvent>.Create();
  FullUpdateEvents := TList<TFullUpdateEvent>.Create();

  // Init cached PNGs
  for i := Low(OAMImages) to High(OAMImages) do
  OAMImages[i] := TPngImage.CreateBlank(COLOR_PALETTE, 8, 8, 16);
  TileMapImages[0] := TPngImage.CreateBlank(COLOR_PALETTE, 8, 256, 256);
  TileMapImages[1] := TPngImage.CreateBlank(COLOR_PALETTE, 8, 256, 256);
  UpdatePAL();

  for i := Low(OAMImages) to High(OAMImages) do
  OAMImages[i].TransparentColor := TransparentColor;
end;

destructor TProject.Destroy;
var
  i: Integer;
begin
  Files.Free();
  TileUpdateEvents.Free();
  TileMapUpdateEvents.Free();
  PaletteUpdateEvents.Free();
  OAMUpdateEvents.Free();
  RegisterUpdateEvents.Free();
  FullUpdateEvents.Free();
  for i := Low(OAMImages) to High(OAMImages) do
  OAMImages[i].Free();
  TileMapImages[0].Free();
  TileMapImages[1].Free();
  inherited;
end;

function TProject.GetOAMs(LY: Byte): TArray<Byte>;
type
  TIndexedOAMObj = record
    Index: Byte;
    OAMObj: TOAMObj;
  end;
function IndexedOAMObj(Index: Byte; OAMObj: TOAMObj): TIndexedOAMObj;
begin
  Result.Index := Index;
  Result.OAMObj := OAMObj;
end;
var
  MaxY: Byte;
  List: TList<TIndexedOAMObj>;
  i: Integer;
  Comparison: TComparison<TIndexedOAMObj>;
begin
  if not LCDC.OBJEnable then
  Exit;

  Comparison :=
    // used for DMG only (CGB needs no optimization)
    function(const Left, Right: TIndexedOAMObj): Integer
    begin
      // return >0 if it has to swap
      Result := Left.OAMObj.X - Right.OAMObj.X;
      if Result = 0 then
      Result := Left.Index - Right.Index;
    end;

  Inc(LY, 16);
  if LCDC.GetOBJSize() then
  MaxY := 15
  else
  MaxY := 7;

  List := TList<TIndexedOAMObj>.Create();
  try
    for i := Low(OAM.OAM) to High(OAM.OAM) do
    if InRange(LY-OAM.OAM[i].Y, 0, MaxY) then
    if List.Count < 10 then // Fetch priority always equals CGB drawing priority
    List.Add(IndexedOAMObj(i, OAM.OAM[i]));

    // It is important to run this even if we have less than 10 items, because this is also used for the drawing priority and to determine whose priority flag is used.
    if not IsCGB or OPRI then
    List.Sort(TComparer<TIndexedOAMObj>.Construct(Comparison));

    // Return result
    SetLength(Result, List.Count);
    for i := Low(Result) to High(Result) do
    Result[i] := List[i].Index;
  finally
    List.Free();
  end;
end;

procedure TProject.LoadFromFile(const FileName: string);
var
  INI: TINIFile;
  i: Integer;
  InputFile: TFile;
  ID: Integer;
function GetFileClass(): TFileClass;
var
  Temp: TFileClass;
begin
  for Temp in FileClasses do
  if Temp.GetID() = ID then
  Exit(Temp);
  raise Exception.CreateFmt('File class ID $d not found! Using an older version of the tool with a newer file?', [ID]);
end;
var
  TempOverlay: TOverlay;
begin
  INI := TIniFile.Create(Filename);
  try
    // Registers
    LCDC.AsByte := INI.ReadInteger('Registers', 'LCDC', LCDC.AsByte);
    SCY := INI.ReadInteger('Registers', 'SCY', SCY);
    SCX := INI.ReadInteger('Registers', 'SCX', SCX);
    WY := INI.ReadInteger('Registers', 'WY', WY);
    WX := INI.ReadInteger('Registers', 'WX', WX);
    BGP.AsByte := INI.ReadInteger('Registers', 'BGP', BGP.AsByte);
    OBP[0].AsByte := INI.ReadInteger('Registers', 'OBP0', OBP[0].AsByte);
    OBP[1].AsByte := INI.ReadInteger('Registers', 'OBP1', OBP[1].AsByte);
    OPRI := INI.ReadBool('Registers', 'OPRI', OPRI);
    IsCGB := (INI.ReadInteger('Registers', 'KEY0', $04) and $04) = 0;

    // Files
    for i := 0 to INI.ReadInteger('Files', 'Count', 0) - 1 do
    begin
      ID := INI.ReadInteger('File' + IntToStr(i), 'ID', -1);
      InputFile := GetFileClass().Create(
        INI.ReadString('File' + IntToStr(i), 'FileName', ''),
        INI.ReadInteger('File' + IntToStr(i), 'FileOffset', 0),
        INI.ReadInteger('File' + IntToStr(i), 'Size', 0),
        INI.ReadInteger('File' + IntToStr(i), 'GBOffset', 0),
        Self);
      InputFile.LoadFromFile();
      Files.Add(InputFile);
    end;
    // Overlays
    for i := 0 to INI.ReadInteger('Overlays', 'Count', 0) - 1 do
    begin
      TempOverlay.FileName := INI.ReadString('Overlay' + IntToStr(i), 'FileName', '');
      TempOverlay.Bounds.Left := INI.ReadInteger('Overlay' + IntToStr(i), 'Left', 0);
      TempOverlay.Bounds.Top := INI.ReadInteger('Overlay' + IntToStr(i), 'Top', 0);
      TempOverlay.Bounds.Width := INI.ReadInteger('Overlay' + IntToStr(i), 'Width', 0);
      TempOverlay.Bounds.Height := INI.ReadInteger('Overlay' + IntToStr(i), 'Height', 0);
      Overlays.Add(TempOverlay);
    end;
  finally
    INI.Free();
  end;
end;

procedure TProject.SaveToFile(const FileName: string);
var
  INI: TINIFile;
  i: Integer;
begin
  INI := TIniFile.Create(Filename);
  try
    // Registers
    INI.WriteInteger('Registers', 'LCDC', LCDC.AsByte);
    INI.WriteInteger('Registers', 'SCY', SCY);
    INI.WriteInteger('Registers', 'SCX', SCX);
    INI.WriteInteger('Registers', 'WY', WY);
    INI.WriteInteger('Registers', 'WX', WX);
    INI.WriteInteger('Registers', 'BGP', BGP.AsByte);
    INI.WriteInteger('Registers', 'OBP0', OBP[0].AsByte);
    INI.WriteInteger('Registers', 'OBP1', OBP[1].AsByte);
    INI.WriteBool('Registers', 'OPRI', OPRI);
    if IsCGB then
    INI.WriteInteger('Registers', 'KEY0', $80)
    else
    INI.WriteInteger('Registers', 'KEY0', $04);

    // Files
    INI.WriteInteger('Files', 'Count', Files.Count);
    for i := 0 to Files.Count - 1 do
    begin
      INI.WriteInteger('File' + IntToStr(i), 'ID', Files[i].GetID());
      INI.WriteString('File' + IntToStr(i), 'FileName', Files[i].FileName);
      INI.WriteInteger('File' + IntToStr(i), 'FileOffset', Files[i].FileOffset);
      INI.WriteInteger('File' + IntToStr(i), 'Size', Files[i].Size);
      INI.WriteInteger('File' + IntToStr(i), 'GBOffset', Files[i].GBOffset);
      Files[i].SaveToFile();
      // TODO: Save
    end;

    INI.WriteInteger('Overlays', 'Count', Overlays.Count);
    for i := 0 to Overlays.Count - 1 do
    begin
      INI.WriteString('Overlay' + IntToStr(i), 'FileName', Overlays[i].FileName);
      INI.WriteInteger('Overlay' + IntToStr(i), 'Left', Overlays[i].Bounds.Left);
      INI.WriteInteger('Overlay' + IntToStr(i), 'Top', Overlays[i].Bounds.Top);
      INI.WriteInteger('Overlay' + IntToStr(i), 'Width', Overlays[i].Bounds.Width);
      INI.WriteInteger('Overlay' + IntToStr(i), 'Height', Overlays[i].Bounds.Height);
    end;
  finally
    INI.Free();
  end;
end;

procedure TProject.TriggerFullUpdate;
var
  Event: TFullUpdateEvent;
begin
  for Event in FullUpdateEvents do
  Event(Self);
end;

procedure TProject.TriggerOAMUpdate(OAMIndex: Byte);
var
  Event: TOAMUpdateEvent;
begin
  for Event in OAMUpdateEvents do
  Event(Self, OAMIndex);
end;

procedure TProject.TriggerPaletteUpdate(IsObj: Boolean; PaletteIndex, ColorIndex: Byte);
var
  Event: TPaletteUpdateEvent;
begin
  for Event in PaletteUpdateEvents do
  Event(Self, IsObj, PaletteIndex, ColorIndex);
end;

procedure TProject.TriggerRegisterUpdate(Registers: TRegisters);
var
  Event: TRegisterUpdateEvent;
begin
  for Event in RegisterUpdateEvents do
  Event(Self, Registers);
end;

procedure TProject.TriggerTileMapUpdate(Index, X, Y: Byte);
var
  Event: TTileMapUpdateEvent;
begin
  for Event in TileMapUpdateEvents do
  Event(Self, Index, X, Y);
end;

procedure TProject.TriggerTileUpdate(TileAddr: Word; Bank: Boolean);
var
  Event: TTileUpdateEvent;
begin
  for Event in TileUpdateEvents do
  Event(Self, TileAddr, Bank);
end;

procedure TProject.TriggerTileUpdate(Tile: Byte; IsObj, Bank: Boolean);
begin
  if (Tile >= 128) or IsObj then
  TriggerTileUpdate($8000 + 16*Tile, Bank)
  else
  if LCDC.BGWindowTiles then
  TriggerTileUpdate($8000 + 16*Tile, Bank)
  else
  TriggerTileUpdate($9000 + 16*ShortInt(Tile), Bank)
end;

procedure TProject.UpdateOAMCache();
var
  i: Integer;
begin
  for i := Low(OAMImages) to High(OAMImages) do
  UpdateOAMCacheByIndex(i);
end;

procedure TProject.UpdateOAMCacheByIndex(Index: Byte);
begin
  if LCDC.GetOBJSize then
  begin
    if OAM.OAM[Index].Attributes.YFlip then
    begin
      OAM.OAM[Index].Attributes.WriteTileTo(OAMImages[Index], 0, 8, OAM.OAM[Index].Tile and $FE, True, Self);
      OAM.OAM[Index].Attributes.WriteTileTo(OAMImages[Index], 0, 0, OAM.OAM[Index].Tile or $1, True, Self);
    end
    else
    begin
      OAM.OAM[Index].Attributes.WriteTileTo(OAMImages[Index], 0, 0, OAM.OAM[Index].Tile and $FE, True, Self);
      OAM.OAM[Index].Attributes.WriteTileTo(OAMImages[Index], 0, 8, OAM.OAM[Index].Tile or $1, True, Self);
    end;
  end
  else
  OAM.OAM[Index].Attributes.WriteTileTo(OAMImages[Index], 0, 0, OAM.OAM[Index].Tile, True, Self);
end;

procedure TProject.UpdateOAMCacheByTile(Tile: Byte; Bank: Boolean; TriggerEvent: Boolean);
var
  i: Integer;
begin
  for i := Low(OAMImages) to High(OAMImages) do
  if OAM.OAM[i].ContainsTile(Tile, Bank, Self) then
  begin
    UpdateOAMCacheByIndex(i);
    if TriggerEvent then
    TriggerOAMUpdate(i);
  end;
end;

procedure TProject.UpdatePAL();
type
  // Defining my own version of this record for easier handling (uses TColor and defined palPalEntry in the correct size)
  tagLOGPALETTE = packed record
    palVersion: Word;
    palNumEntries: Word;
    palPalEntry: packed array[Byte] of TColor; // it's the same as tagPALETTEENTRY considering we're running on a Little Endian processor
  end;
var
  i, j: Byte;
  PAL: tagLOGPALETTE;
  NewPAL: HPALETTE;
begin
  {

  Index  | Usage
  -------+--------
       0 | Transparency
    1..4 | DMG BG
    5..7 | DMG OBJ0
   8..10 | DMG OBJ1
  11..42 | CGB BG
  43..66 | CGB OBJ

  }
  PAL.palVersion := $300;
  PAL.palNumEntries := 256;
  PAL.palPalEntry[0] := TransparentColor;
  for i := 0 to 3 do
  PAL.palPalEntry[1+i] := BGP.Color[i];
  for i := 1 to 3 do
  PAL.palPalEntry[4+i] := OBP[0].Color[i];
  for i := 1 to 3 do
  PAL.palPalEntry[7+i] := OBP[1].Color[i];
  for j := 0 to 7 do
  for i := 0 to 3 do
  PAL.palPalEntry[11+j*4+i] := CGBBGPal[j][i].Color;
  for j := 0 to 7 do
  for i := 1 to 3 do
  PAL.palPalEntry[42+j*3+i] := CGBOBJPal[j][i].Color;
  //SetPaletteEntries(PAL, 0, 256, Entries[0])
  NewPAL := CreatePalette(@PAL);


  for i := Low(OAMImages) to High(OAMImages) do
  OAMImages[i].Palette := NewPAL;
  TileMapImages[0].Palette := NewPAL;
  TileMapImages[1].Palette := NewPAL;

  // Some general information on GDI palette handling, although the advice is really bad: https://stackoverflow.com/questions/1240673/how-can-i-access-the-palette-of-a-tpicture-graphic
end;

procedure TProject.UpdateTileMapCache();
var
  Index, x, y: Integer;
begin
  for Index := 0 to 1 do
  for x := 0 to 31 do
  for y := 0 to 31 do
  VRAM1Maps[Low(VRAM1Maps) or (Index shl 10) or (y shl 5) or x].WriteTileTo(TileMapImages[Index], x shl 3, y shl 3, VRAM0Maps[Low(VRAM0Maps) or (Index shl 10) or (y shl 5) or x], False, Self);
end;

procedure TProject.UpdateTileMapCacheByLocation(Index, X, Y: Byte);
begin
  VRAM1Maps[Low(VRAM1Maps) or (Index shl 10) or (y shl 5) or x].WriteTileTo(TileMapImages[Index], x shl 3, y shl 3, VRAM0Maps[Low(VRAM0Maps) or (Index shl 10) or (y shl 5) or x], False, Self);
end;

procedure TProject.UpdateTileMapCacheByTile(Tile: Byte; Bank: Boolean);
var
  Index, x, y: Integer;
  Offset: Integer;
begin
  for Index := 0 to 1 do
  for x := 0 to 31 do
  for y := 0 to 31 do
  if VRAM0Maps[Low(VRAM0Maps) or (Index shl 10) or (y shl 5) or x] = Tile then
  VRAM1Maps[Low(VRAM1Maps) or (Index shl 10) or (y shl 5) or x].WriteTileTo(TileMapImages[Index], x shl 3, y shl 3, Tile, False, Self);
end;

procedure TProject.UpdateTileMapCacheByTileAddr(TileAddr: Word; Bank: Boolean);
begin
  if LCDC.BGWindowTiles then
  begin
    if TileAddr < $9000 then
    UpdateTileMapCacheByTile(Byte((TileAddr - $8000) div 16), Bank);
  end
  else
  begin
    if TileAddr >= $8800 then
    UpdateTileMapCacheByTile(Byte((TileAddr - $8000) div 16), Bank);
  end;
end;

procedure TProject.ReadFromTile(Target: TPNGImage; X, Y: Integer; TileAddr: Word; Bank: Boolean; PalIndex: array of Byte; XFlip, YFlip: Boolean);
var
  i, j: Integer;
  Data: array[0..15] of Byte;
  Temp: Byte;
  Scanline: PByte;
begin
  // Get bytes
  if Bank then
  for i := 0 to 15 do
  Data[i] := VRAM1Tiles[TileAddr+i]
  else
  for i := 0 to 15 do
  Data[i] := VRAM0Tiles[TileAddr+i];

  if YFlip then
  for i := 0 to 3 do
  begin
    Temp := Data[i*2];
    Data[i*2] := Data[14-i*2];
    Data[14-i*2] := Temp;
    Temp := Data[1+i*2];
    Data[1+i*2] := Data[15-i*2];
    Data[15-i*2] := Temp;
  end;

  if XFlip then
  for j := 0 to 15 do
  begin
    Temp := 0;
    for i := 0 to 7 do
    Temp := (Temp shl 1) or (1 and (Data[j] shr i));
    Data[j] := Temp;
  end;

  // Decode data
  for j := 0 to 7 do
  begin
    Scanline := Target.Scanline[Y+j];
    Inc(Scanline, X);
    for i := 0 to 7 do
    begin
      Scanline^ := PalIndex[((Data[j*2] shr (7-i)) and 1) or (((Data[j*2+1] shr (7-i)) and 1) shl 1)];
      Inc(Scanline);
    end;
  end;
end;

procedure TProject.WriteOAMCacheByIndex(Index: Byte);
begin
  if LCDC.OBJSize then
  begin
    if OAM.OAM[Index].Attributes.YFlip then
    begin
      WriteToTile(OAMImages[Index], 0, 8, $8000 + 16 * (OAM.OAM[Index].Tile and $FE), OAM.OAM[Index].Attributes.Bank, OAM.OAM[Index].Attributes.XFlip, True);
      WriteToTile(OAMImages[Index], 0, 0, $8000 + 16 * (OAM.OAM[Index].Tile or 1), OAM.OAM[Index].Attributes.Bank, OAM.OAM[Index].Attributes.XFlip, True);
    end
    else
    begin
      WriteToTile(OAMImages[Index], 0, 0, $8000 + 16 * (OAM.OAM[Index].Tile and $FE), OAM.OAM[Index].Attributes.Bank, OAM.OAM[Index].Attributes.XFlip, False);
      WriteToTile(OAMImages[Index], 0, 8, $8000 + 16 * (OAM.OAM[Index].Tile or 1), OAM.OAM[Index].Attributes.Bank, OAM.OAM[Index].Attributes.XFlip, False);
    end;
  end
  else
  begin
    WriteToTile(OAMImages[Index], 0, 0, $8000 + 16 * OAM.OAM[Index].Tile, OAM.OAM[Index].Attributes.Bank, OAM.OAM[Index].Attributes.XFlip, OAM.OAM[Index].Attributes.YFlip);
  end;
end;

procedure TProject.WriteToTile(Source: TPNGImage; X, Y: Integer; TileAddr: Word; Bank, XFlip, YFlip: Boolean);
var
  Data: array[0..15] of Byte;
  Temp: Byte;
  Scanline: PByte;
  i, j: Integer;
begin
  for j := 0 to 7 do
  begin
    Scanline := Source.Scanline[Y+j];
    Inc(Scanline, X);
    for i := 0 to 7 do
    begin
      Data[j*2]   := Byte(Data[j*2] shl 1) or (PalIndexToColorIndex[Scanline^] and 1);
      Data[j*2+1] := Byte(Data[j*2+1] shl 1) or (PalIndexToColorIndex[Scanline^] shr 1);
      Inc(Scanline);
    end;
  end;

  if YFlip then
  for i := 0 to 3 do
  begin
    Temp := Data[i*2];
    Data[i*2] := Data[14-i*2];
    Data[14-i*2] := Temp;
    Temp := Data[1+i*2];
    Data[1+i*2] := Data[15-i*2];
    Data[15-i*2] := Temp;
  end;

  if XFlip then
  for j := 0 to 15 do
  begin
    Temp := 0;
    for i := 0 to 7 do
    Temp := (Temp shl 1) or (1 and (Data[j] shr i));
    Data[j] := Temp;
  end;


  if Bank then
  for i := 0 to 15 do
  VRAM1Tiles[TileAddr+i] := Data[i]
  else
  for i := 0 to 15 do
  VRAM0Tiles[TileAddr+i] := Data[i];
end;

{ TLCDC }

function TLCDC.GetBGTileMap: Boolean;
begin
  Result := (AsByte and $08) <> 0;
end;

function TLCDC.GetBGWindowEnablePriority: Boolean;
begin
  Result := (AsByte and $01) <> 0;
end;

function TLCDC.GetBGWindowTiles: Boolean;
begin
  Result := (AsByte and $10) <> 0;
end;

function TLCDC.GetOBJEnable: Boolean;
begin
  Result := (AsByte and $02) <> 0;
end;

function TLCDC.GetOBJSize: Boolean;
begin
  Result := (AsByte and $04) <> 0;
end;

function TLCDC.GetWindoeEnable: Boolean;
begin
  Result := (AsByte and $20) <> 0;
end;

function TLCDC.GetWindowTileMap: Boolean;
begin
  Result := (AsByte and $40) <> 0;
end;

procedure TLCDC.SetBGTileMap(const Value: Boolean);
begin
  if Value then
  AsByte := AsByte or $08
  else
  AsByte := AsByte and not $08;
end;

procedure TLCDC.SetBGWindowEnablePriority(const Value: Boolean);
begin
  if Value then
  AsByte := AsByte or $01
  else
  AsByte := AsByte and not $01;
end;

procedure TLCDC.SetBGWindowTiles(const Value: Boolean);
begin
  if Value then
  AsByte := AsByte or $10
  else
  AsByte := AsByte and not $10;
end;

procedure TLCDC.SetOBJEnable(const Value: Boolean);
begin
  if Value then
  AsByte := AsByte or $02
  else
  AsByte := AsByte and not $02;
end;

procedure TLCDC.SetOBJSize(const Value: Boolean);
begin
  if Value then
  AsByte := AsByte or $04
  else
  AsByte := AsByte and not $04;
end;

procedure TLCDC.SetWindowEnable(const Value: Boolean);
begin
  if Value then
  AsByte := AsByte or $20
  else
  AsByte := AsByte and not $20;
end;

procedure TLCDC.SetWindowTileMap(const Value: Boolean);
begin
  if Value then
  AsByte := AsByte or $40
  else
  AsByte := AsByte and not $40;
end;

{ TFile }

constructor TFile.Create(AFileName: string; AFileOffset, ASize, AGBOffset: Integer; AProject: TProject);
begin
  FileName := AFileName;
  FileOffset := AFileOffset;
  Size := ASize;
  GBOffset := AGBOffset;
  Project := AProject;
end;

class function TFile.IntToMonospaceHex(const Value, Digits: Integer; IncludePrefix: Boolean): string;
function UCS4Chr(const c: Cardinal): UnicodeString;
begin
  if c < $10000 then
  Result := Chr(c)
  else
  Result := Chr((c - $10000) shr 10 and $3FF or $D800) + Chr(c and $3FF or $DC00);
end;
var
  Temp: string;
  i: Integer;
begin
  Temp := IntToHex(Value, Digits);
  if IncludePrefix then
  Result := UCS4Chr($1D6A1)
  else
  Result := '';
  for i := 1 to Length(Temp) do
  case Temp[i] of
    '0'..'9': Result := Result + UCS4Chr(120822 - Ord('0') + Ord(Temp[i]));
    'A'..'F': Result := Result + UCS4Chr(120432 - Ord('A') + Ord(Temp[i]));
  end;
end;

procedure TFile.LoadFromFile;
var
  FS: TFileStream;
begin
  FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    FS.Position := FileOffset;
    DoLoadFromFile(FS);
  finally
    FS.Free();
  end;
end;

procedure TFile.SaveToFile;
var
  FS: TFileStream;
begin
  if FileExists(FileName) then
  FS := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone)
  else
  FS := TFileStream.Create(FileName, fmCreate);
  try
    FS.Position := FileOffset;
    DoSaveToFile(FS);
  finally
    FS.Free();
  end;
end;

{ TTiles0File }

procedure TTiles0File.DoLoadFromFile(Stream: TStream);
begin
  Stream.Read(Project.VRAM0Tiles[GBOffset], Size);
end;

procedure TTiles0File.DoSaveToFile(Stream: TStream);
begin
  Stream.Write(Project.VRAM0Tiles[GBOffset], Size);
end;

class function TTiles0File.GetBytesPerPiece: Integer;
begin
  Result := 16;
end;

class function TTiles0File.GetID: Integer;
begin
  Result := 0;
end;

class function TTiles0File.GetLongName: string;
begin
  Result := 'Tiles on Bank 0';
end;

class function TTiles0File.GetMaxPieces: Integer;
begin
  Result := 384;
end;

class function TTiles0File.GetMinStartOffset: Integer;
begin
  Result := $8000;
end;

class function TTiles0File.GetShortName: string;
begin
  Result := 'Tiles 0';
end;

{ TTiles1File }

procedure TTiles1File.DoLoadFromFile(Stream: TStream);
begin
  Stream.Read(Project.VRAM1Tiles[GBOffset], Size);
end;

procedure TTiles1File.DoSaveToFile(Stream: TStream);
begin
  Stream.Write(Project.VRAM1Tiles[GBOffset], Size);
end;

class function TTiles1File.GetBytesPerPiece: Integer;
begin
  Result := 16;
end;

class function TTiles1File.GetID: Integer;
begin
  Result := 1;
end;

class function TTiles1File.GetLongName: string;
begin
  Result := 'Tiles on Bank 1';
end;

class function TTiles1File.GetMaxPieces: Integer;
begin
  Result := 384;
end;

class function TTiles1File.GetMinStartOffset: Integer;
begin
  Result := $8000;
end;

class function TTiles1File.GetShortName: string;
begin
  Result := 'Tiles 1';
end;

{ TTileMapFile }

procedure TTileMapFile.DoLoadFromFile(Stream: TStream);
begin
  Stream.Read(Project.VRAM0Maps[GBOffset], Size);
end;

procedure TTileMapFile.DoSaveToFile(Stream: TStream);
begin
  Stream.Write(Project.VRAM0Maps[GBOffset], Size);
end;

class function TTileMapFile.GetBytesPerPiece: Integer;
begin
  Result := 1;
end;

class function TTileMapFile.GetID: Integer;
begin
  Result := 2;
end;

class function TTileMapFile.GetLongName: string;
begin
  Result := 'Tile Map (0 or 1)';
end;

class function TTileMapFile.GetMaxPieces: Integer;
begin
  Result := 32*32*2;
end;

class function TTileMapFile.GetMinStartOffset: Integer;
begin
  Result := $9800;
end;

class function TTileMapFile.GetShortName: string;
begin
  Result := 'Tile Map';
end;

{ TAttributeMapFile }

procedure TAttributeMapFile.DoLoadFromFile(Stream: TStream);
begin
  Stream.Read(Project.VRAM1Maps[GBOffset], Size);
end;

procedure TAttributeMapFile.DoSaveToFile(Stream: TStream);
begin
  Stream.Write(Project.VRAM1Maps[GBOffset], Size);
end;

class function TAttributeMapFile.GetBytesPerPiece: Integer;
begin
  Result := 1;
end;

class function TAttributeMapFile.GetID: Integer;
begin
  Result := 3;
end;

class function TAttributeMapFile.GetLongName: string;
begin
  Result := 'Attribute Map (0 or 1)';
end;

class function TAttributeMapFile.GetMaxPieces: Integer;
begin
  Result := 32*32*2;
end;

class function TAttributeMapFile.GetMinStartOffset: Integer;
begin
  Result := $9800;
end;

class function TAttributeMapFile.GetShortName: string;
begin
  Result := 'Attr Map';
end;

{ TOAMFile }

procedure TOAMFile.DoLoadFromFile(Stream: TStream);
begin
  Stream.Read(Project.OAM.Bytes[GBOffset], Size);
end;

procedure TOAMFile.DoSaveToFile(Stream: TStream);
begin
  Stream.Write(Project.OAM.Bytes[GBOffset], Size);
end;

class function TOAMFile.GetBytesPerPiece: Integer;
begin
  Result := 4;
end;

class function TOAMFile.GetID: Integer;
begin
  Result := 4;
end;

class function TOAMFile.GetLongName: string;
begin
  Result := 'Object Attribute Memory';
end;

class function TOAMFile.GetMaxPieces: Integer;
begin
  Result := 40;
end;

class function TOAMFile.GetMinStartOffset: Integer;
begin
  Result := $FE00;
end;

class function TOAMFile.GetShortName: string;
begin
  Result := 'OAM';
end;

{ TBGPalRawFile }

procedure TBGPalRawFile.DoLoadFromFile(Stream: TStream);
begin
  Stream.Read(Project.CGBBGPal[GBOffset], Size);
end;

procedure TBGPalRawFile.DoSaveToFile(Stream: TStream);
begin
  Stream.Write(Project.CGBBGPal[GBOffset], Size);
end;

class function TBGPalRawFile.GetBytesPerPiece: Integer;
begin
  Result := 8;
end;

class function TBGPalRawFile.GetID: Integer;
begin
  Result := 5;
end;

class function TBGPalRawFile.GetLongName: string;
begin
  Result := 'CGB Background Palettes';
end;

class function TBGPalRawFile.GetMaxPieces: Integer;
begin
  Result := 8;
end;

class function TBGPalRawFile.GetMinStartOffset: Integer;
begin
  Result := 0;
end;

class function TBGPalRawFile.GetShortName: string;
begin
  Result := 'BG Pal';
end;

{ TOBJPalRawFile }

procedure TOBJPalRawFile.DoLoadFromFile(Stream: TStream);
begin
  Stream.Read(Project.CGBOBJPal[GBOffset], Size);
end;

procedure TOBJPalRawFile.DoSaveToFile(Stream: TStream);
begin
  Stream.Write(Project.CGBOBJPal[GBOffset], Size);
end;

class function TOBJPalRawFile.GetBytesPerPiece: Integer;
begin
  Result := 8;
end;

class function TOBJPalRawFile.GetID: Integer;
begin
  Result := 6;
end;

class function TOBJPalRawFile.GetLongName: string;
begin
  Result := 'CGB Object Palettes';
end;

class function TOBJPalRawFile.GetMaxPieces: Integer;
begin
  Result := 8;
end;

class function TOBJPalRawFile.GetMinStartOffset: Integer;
begin
  Result := 0;
end;

class function TOBJPalRawFile.GetShortName: string;
begin
  Result := 'OBJ Pal';
end;

{ TOAMObj }

function TOAMObj.ContainsTile(Tile: Byte; Bank: Boolean;
  Project: TProject): Boolean;
begin
  if Bank <> Attributes.Bank then
  Exit(False);
  if Project.LCDC.OBJSize then
  Result := (Tile and $FE) = (Self.Tile and $FE)
  else
  Result := Tile = Self.Tile;
end;

function TOAMObj.IsOnScreen(Project: TProject): Boolean;
begin
  if X = 0 then
  Exit(False);
  if X >= 168 then
  Exit(False);
  if Y >= 160 then
  Exit(False);
  if Y = 0 then
  Exit(False);
  if not Project.LCDC.OBJSize then
  if Y <= 8 then
  Exit(False);
  Result := True;
end;

end.

