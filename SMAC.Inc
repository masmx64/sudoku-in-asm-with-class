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

.586
.model flat,stdcall
option casemap:none

	include		\masm32\INCLUDE\windows.inc
	include		\masm32\INCLUDE\user32.inc
	include		\masm32\INCLUDE\kernel32.inc
	include		\masm32\INCLUDE\comctl32.inc
	include		\masm32\INCLUDE\comdlg32.inc
	include		\masm32\INCLUDE\shell32.inc
	include		\masm32\INCLUDE\advapi32.inc
	include		\masm32\INCLUDE\gdi32.inc
	include		\masm32\INCLUDE\winmm.inc
	;include		\masm32\INCLUDE\masm32.inc
	;include		\masm32\MACROS\macros.asm

	includelib	\masm32\lib\user32.lib
	includelib	\masm32\lib\kernel32.lib
	includelib	\masm32\lib\comctl32.lib
	includelib	\masm32\lib\comdlg32.lib
	includelib	\masm32\lib\shell32.lib
	includelib	\masm32\lib\advapi32.lib
	includelib	\masm32\lib\gdi32.lib
	includelib	\masm32\lib\winmm.lib
	;includelib	\masm32\lib\masm32.lib

;------------------------------------------------------------------------------
.const
;********************************************************************
;	Equ
;********************************************************************
	MAX_XY			equ			9
	
	IDI_MAIN		equ			1000
	IDC_MAIN		equ			2000
	
	IDM_MAIN		equ			3000
	IDM_SEPERATE	equ			-1
	IDM_FILE		equ			3100
	IDM_NEW			equ			3101
	IDM_OPEN		equ			3102
	IDM_SAVE		equ			3103
	IDM_CLOSE		equ			3104
	IDM_EXIT		equ			3105
	IDM_GAME		equ			3200
	IDM_GO			equ			3201
	IDM_MUSIC		equ			3300
	IDM_TOGGLE		equ			3301
	IDM_ABOUT		equ			3400
	IDM_ABOUTME		equ			3401
	
	;button images
	IDB_MAIN		equ			5000
	IDB_SEPERATE	equ			-1
	;IDB_FILE		equ			5100
	IDB_NEW			equ			5101
	IDB_OPEN		equ			5102
	IDB_SAVE		equ			5103
	IDB_CLOSE		equ			5104
	IDB_EXIT		equ			5105
	;IDB_GAME		equ			5200
	IDB_GO			equ			5201
	;IDB_MUSIC		equ			5300
	IDB_TOGGLE		equ			5301
	;IDB_ABOUT		equ			5400
	IDB_ABOUTME		equ			5401
	;hot images
	IDB_NEWH		equ			51010
	IDB_OPENH		equ			51020
	IDB_SAVEH		equ			51030
	IDB_CLOSEH		equ			51040
	IDB_EXITH		equ			51050
	;IDB_GAME		equ			52000
	IDB_GOH			equ			52010
	;IDB_MUSIC		equ			53000
	IDB_TOGGLEH		equ			53010
	;IDB_ABOUT		equ			54000
	IDB_ABOUTMEH	equ			54010
	;disabled images
	IDB_NEWD		equ			51011
	IDB_OPEND		equ			51021
	IDB_SAVED		equ			51031
	IDB_CLOSED		equ			51041
	IDB_EXITD		equ			51051
	;IDB_GAME		equ			52001
	IDB_GOD			equ			52011
	;IDB_MUSIC		equ			53001
	IDB_TOGGLED		equ			53011
	;IDB_ABOUT		equ			54001
	IDB_ABOUTMED	equ			54011
	
	IDR_MAIN		equ			8000
	IDR_MUSIC		equ			8000
		
	WM_SHELLNOTIFY	equ			WM_USER+100
	IDI_SYSTRAY		equ			1

;********************************************************************
;	STRUCT ����
;********************************************************************
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------

.data?
;********************************************************************
;
;********************************************************************
	hInstance		dd			?
	hWinMain		dd			?
	pszCommandLine	dd			?
	hIcon			dd			?
	hCursor			dd			?
	hMenu			dd			?
	hPopupMenu		dd			?
	xNID			NOTIFYICONDATA	<?>
	;xMusic			RCRES_MUSIC		<?>
	Msg				MSG				<?>
	szBuffer		db		256 dup	(?)
;--------------------------------------------------------------------------------

.data
;********************************************************************
;
;********************************************************************
	szClassName		db			'SUDOKU',0
	szAppName		db			'Sudoku Matrix Auto Calculator',0
	
	szConfirmQuit	db			'Do you want to exit?',0
	szErrorMsg		db			'Fatal error occurs',0dh,0ah,'Program terminated!',0
	
	szSysTrayTip	db			'Sudoku Matrix Auto Calculator',0dh,0ah, \
								'by kissafool',0dh,0ah, \
								'at gmail.com',0
;--------------------------------------------------------------------------------
