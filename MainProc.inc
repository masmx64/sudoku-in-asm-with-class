;------------------------------------------------------------------------------Copyright
; SMAC
; Sudoku Matrix Auto-Calculator
;
; Developed under masm32 v9.0 with oop supported
;
; by masmx64
;    v0.1 alpha
;    Dec 8, 2006
; "~~
; '00'
;  -		kissafool
; (&?`'.	@gamil.com
; JL		qq42266724
;------------------------------------------------------------------------------Copyright
; OBJECTS.INC - VERSION:  2.27 (SEPT 19, 2001)
; developed by NaN    (Jaymeson@Hotmail.com) and
;              Thomas (_thomas_@runbox.com)
; Copyright 9/19/01  Jaymeson Trudgen and Thomas Bleeker
;------------------------------------------------------------------------------Include Files
	include		LogFile.asm
	include		XmMusic.asm
	include		CCell.asm
	include		CMatrix.asm
	include		ShapeWindow.asm
	include		ToolBar.asm
	
;------------------------------------------------------------------------------Functions Definition
EnsureSingleInstance 	PROTO
InitInstance 			PROTO
WndMainProc 			PROTO :DWORD,:DWORD,:DWORD,:DWORD
QuitApplication			PROTO
InitApplication			PROTO
PaintProc				PROTO :DWORD
PlayMusicEx				PROTO :DWORD
