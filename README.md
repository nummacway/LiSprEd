# Little Sprite Editor

This is a graphics editor for Game Boy games. It is primarily intended for demaking. It may still be usedful for editing all kinds of games that have no maps greater than VRAM.


## Requirements

- Windows (or probably Wine)
- Effective FHD (2K recommended)


## Building

Get Delphi community edition and build.

The tool was made with Delphi 12.1. Because PNGDelphi has [a very bad bug](https://embt.atlassian.net/servicedesk/customer/portal/1/RSS-2662) (you must have filed a Delphi issue to access that link) when displaying scaled paletted PNGs, this repository contains a copy of that file with a patch I made. There is a chance that this patch will not work with other versions. The _OAM_ editor of this tool will be mostly useless without that patch.


## Features
- No proprietary formats - 100% hardware memory dumps, held together by an INI file (named `.lse`).
- Any input box that accepts numbers (except for the spin edits) will work with decimal or hex numbers, the latter can be entered as `0x42`, `x42` or `$42`.
- Combine stacked objects and (optionally) the background for more colors - but paint without caring. Right as you draw, the tool will make all necessary pixel adjustments to make sure your drawn color will show.
- Use drag-and-drop for most actions.
- Place images you want to recreate (demake) on the editor, which can be moved, resized, hidden or painted "through" (like if they weren't there).


## Missing Features

This is a very early preview. Missing features, among many others, are:
- Quit/save confirmation
- End offsets in file offset editor
- OAM sprite lock (ignore sprite when drawing)
- _Files_ list drag and drop
- Relative paths for _File_&#8288;s.
- Drag and drop in _Palettes_ window
- Optional updating of uses when moving tiles around (how to deal with 8×16 OBJs?)
- Palette color editing using Windows color picker (double-click)
- OAM entry swap (currently only OAM entry copy is supported)
- General polishing
- Maybe export-only palette file formats (`LD [HL] n8` in compiled and ASM code variants).


## MDI Children

### Files

**Note:** _File_ (capitalized and in italics) refers to an entry in the list of this window. A file can be used by multiple _File_&#8288;s.

Here you can define he _File_&#8288;s to work with. The main `.lse` file only contains the data from this window and the _I/O Registers_ window, as well as overlays. VRAM, OAM, CGB palettes **must** be stored in _File_&#8288;s to not lose the corresponding data on exit. The following file types exist:
- Tiles on Bank 0
- Tiles on Bank 1 (CGB only)
- Tile Maps (there is only one file type for both maps, as both use consecutive memory on the same bank)
- Attribute Maps (dito, but CGB only)
- Object Attribute Memory
- CGB BG Palettes
- CGB OBJ PAL

You have the complete freedom and full control over the use of the _File_&#8288;s. You can use multiple areas of the same file, or store the same data in multiple files - there is absoluty no limit. Configuring offsets is done by setting a start offset in your file, the number of bytes or "pieces" (items) and 

- _Add File_: Pick a file and load it. First you pick a file, then you pick the _File_ type and set the offsets that are in the file. When done, the _File_ is loaded into the tool's VRAM/OAM/Palette and corresponding content is overwritten.
  - _Auto-Add Emulicious Exports..._: Loads files created by using the _Save As..._ feature in Emulicious' memory editor: `.vrm` (VRAM), `.pal` (Palettes) and `.bin` (OAM) are added, depending on which of them are present. It does not matter which of the three you select in the file picker. Instead of adding and configuring 7 _File_&#8288;s, this feature does this automatically.
- _New File_: Same as _Add File_, but the _File_ does not have to exist and is not loaded (but saved) when done.
- _Edit Offsets_: Configure the selected _File_.
- _Save As_: Pick a new file name for the selected _File_. The _File_ is saved when done.
- _Remove File_: Remove the selected file from the list. The _File_ will no longer be written when you save, but the current content will be kept in memory.
- _Reload Files_: Load all _File_&#8288;s like they were just added. Does not wipe memory before, so memory that no longer corresponds to a _File_ (but did so before) is retained.


### Tiles

Just a viewer of the tile data in VRAM. Left is bank 0, right is bank 1.

Non-obvious usage:
- Drag and drop to swap tiles. Hold <kbd>Ctrl<kbd> to copy instead.
- Drag and drop on _Tilemaps_ window to use the tile where dropped.
- Drag and drop on _OAM_ window to use the tile where dropped.


### Tilemaps

Mostly self-explanatory. You can select a tile to edit its properties. The selected tile is in orange.

The _Copy_ feature allows you to copy the selected tile's properties to the next tile you selected. Its drop down menu allows you to set which properties will be affected by this. This can be any of the properties to the left. The tile number can also be incremented or decremented before the selected tile is copied (in CGB mode, banks will switch when the tile number overflows or underflows).

Non-obvious usage:
- Right-click equals _Copy_ mode.


### I/O registers

Mostly self-explanatory.


### Palettes

Mostly self-explanatory.

Left-click or right-click a palette entry to select it, which means you can draw with this color in the _Main Preview & Editor_ window (see below). OBJ Transparent color is found in the bottom left of this window and is the only palette-ID-unaware color. Only one selected color can be OBJ Transparent because one opaque color will be in the color editor.

The color editor can be used to edit the selected color. You have various options to do so:
- Change R, G, B values (0-31)
- Change CGB Word value
- Edit hex color (CSS)
- Set the color to the color in the circle in the top right of the group box. This circle holds a color picked from your desktop (and most-importantly Editor overlays). To change it, click the circle, hold your mouse button and release it on the pixel to pick the color from.


### OAM

Displays OAM content. Each object is represented by an image of its tile(s), and a four-line label with its properties (OAM data): First row is Y, second is X, third is tile bank and number, fourth is flags. The flags are displayed as follows:
- `P` is for priority
- `Y` is for Y flip
- `X` is for X flip
- `A` is for DMG palette 0
- `B` is for DMG palette 1
- Bank is displayed in the third line instead
- `0` to `7` is for the corresponding CGB palette

Edit OAM by clicking the corresponding row in the label to the right of the image. Clicking the third row only allows you to edit the tile number, whereas the bank is edited using the fourth (flags) row, as it is technically a flag. The fourth row brings up a popup menu which serves as a simple flag editor.

Non-obvious usage:
- Drag and drop on _Main Preview & Editor_ to place.
- Drag and drop on other OAM to copy (will soon be changed to swap, with modifier hotkeys to move and copy).


### Main Preview & Editor

Used to paint. If you try to paint in a color+palette-ref (the color (value) itself does not currently matter) that corresponds to neither background nor any object in that location, a beep is heard instead. If a pixel is modified, all other objects' pixels in that location are painted in transparent instead, making sure your painted color is visible even when stacking multiple objects for more colors.

Use the color picker to pick a color (left-click or right-click).

Use the pointer icon in the toolbar to move and resize overlays. Use its dropdown to add new overlays, or to remove them (by clicking the name).

Non-obvious usage:
- Holding <kbd>Ctrl<kbd> equals color picker tool.
- If the _Overlays_ checkbox has the focus, use <kbd>Space</kbd> to toggle.
