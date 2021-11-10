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

	include SMAC.inc
	include MainProc.inc
;--------------------------------------------------------------------------------
.code
;--------------------------------------------------------------------------------
;********************************************************************
;PROC 	EnsureSingleInstance 
;
;FUNC	ȷ��ÿ��ֻ����һ������ʵ��
;
;PARA	N/A
;
;RETN	N/A
;
;USAGE	invoke EnsureSingleInstance
;********************************************************************
EnsureSingleInstance proc

		LOCAL	@hWnd			:DWORD
		
		invoke	FindWindow,offset szClassName,NULL
		mov @hWnd,eax
		.if	eax != NULL
			;invoke PostMessage,@hWnd,WM_SHOWWINDOW,TRUE,NULL
			invoke ShowWindow,@hWnd,SW_RESTORE
			invoke SetForegroundWindow,@hWnd
			invoke ExitProcess,NULL
		.endif
		ret

EnsureSingleInstance endp
;********************************************************************
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;********************************************************************

;PROC 	InitInstance 
; 
;FUNC	ע�ᴰ���ಢ��������
;       WinMain �������̵���
;
;PARA	N/A
;
;RETN	N/A
;
;USAGE	invoke InitInstance
;********************************************************************
InitInstance proc

		LOCAL	@hwnd		:DWORD
		LOCAL	@wc			:WNDCLASSEX
		
		;ע�ᴰ����
		mov	@wc.cbSize,sizeof WNDCLASSEX
		mov	@wc.style,CS_HREDRAW or CS_VREDRAW or CS_DBLCLKS
		mov	@wc.hbrBackground,COLOR_BTNFACE+1
		
		invoke	LoadIcon,hInstance,IDI_MAIN
		mov	hIcon,eax
		mov	@wc.hIcon,eax
		mov	@wc.hIconSm,eax
		
		invoke	LoadCursor,hInstance,IDC_MAIN
		mov	hCursor,eax
		mov	@wc.hCursor,eax
				
		invoke	LoadMenu,hInstance,IDM_MAIN
		mov	hMenu,eax
		mov	@wc.lpszMenuName,0
		
		mov	eax,hInstance
		mov	@wc.hInstance,eax
		
		mov	@wc.lpszClassName,offset szClassName	;ClassName����������
		mov	@wc.lpfnWndProc,offset WndMainProc		;WndProc ���ڴ�������
		mov	@wc.cbClsExtra,0
		mov	@wc.cbWndExtra,0
				
		invoke	RegisterClassEx,addr @wc
		
		;�����������
		invoke	CreateWindowEx,	NULL,\
								offset szClassName,\
								offset szAppName,\
								WS_CAPTION or WS_SYSMENU or WS_POPUP or WS_MINIMIZEBOX,\
								;nX,nY,nWidth,nHeigth,\
								100,100,480,320,\
								NULL,\
								hMenu,\
								hInstance,NULL
		mov @hwnd,eax
		invoke ShowWindow,eax,SW_SHOWDEFAULT
		invoke UpdateWindow,@hwnd
		ret

InitInstance endp
;********************************************************************
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;********************************************************************
;
;PROC	WndMainProc
; 
;FUNC	�����ڹ���

;PARA	Para1 = hWnd
;		Para2 = uMsg
;		Para3 = wParam
;		Para4 = lParam
;
;RETN	eax == 0				�û���������Ϣ
;		eax == DefWindowProc	ȱʡ�ķ���ֵ
;
;USAGE	mov	wc.lpfnWndProc,offset WndMainProc
;
;********************************************************************
WndMainProc	proc	uses ebx edi esi, \
					hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
					
		LOCAL	@hDC	:DWORD
		LOCAL	@hbkdc	:DWORD
		LOCAL	@hbmp	:DWORD
		LOCAL	@rest	:RECT
		LOCAL	@point	:POINT
		LOCAL	@cx		:DWORD
		LOCAL	@cy		:DWORD
		LOCAL	@ps		:PAINTSTRUCT
		
		mov eax,uMsg
;********************************************************************
;	WM_CREATE
;********************************************************************		
		.if eax == WM_CREATE
			push hWnd
			pop hWinMain
			invoke InitApplication			
;********************************************************************
;	WM_PAINT
;********************************************************************
		.elseif eax == WM_PAINT
			invoke PaintProc,hWnd
;********************************************************************
;	WM_SIZE
;********************************************************************
		.elseif eax == WM_SIZE
		   .if	wParam == SIZE_MINIMIZED
		   		;��С��ʱ����Сͼ���õ����ݽṹ������Сͼ��
				mov	xNID.cbSize,sizeof NOTIFYICONDATA
				push hWnd
				pop	xNID.hwnd
				mov	xNID.uID,IDI_SYSTRAY
				mov	xNID.uFlags,NIF_ICON+NIF_MESSAGE+NIF_TIP
				mov	xNID.uCallbackMessage,WM_SHELLNOTIFY
				mov	eax,hIcon
				mov	xNID.hIcon,eax
				invoke lstrcpy, addr xNID.szTip, addr szSysTrayTip
				invoke ShowWindow,hWnd,SW_HIDE
				invoke Shell_NotifyIcon,NIM_ADD,addr xNID
		   .else
		   		;�ָ�����ʱɾ��Сͼ��
				invoke	Shell_NotifyIcon,NIM_DELETE,addr xNID
		   .endif
;********************************************************************
;	WM_COMMAND
;********************************************************************
		.elseif eax == WM_COMMAND
		   .if	lParam == 0
		   		;�˵�����
				mov	eax,wParam
				.if ax == IDM_ABOUTME
					invoke MessageBox,hWnd,offset szClassName,offset szAppName,MB_OK
				.elseif ax == IDM_EXIT
					invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
				.elseif ax == IDM_GO
					;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					newobject CMatrix
					mov hMatrix, eax
															
					method hMatrix, CMatrix, InitMatrix, offset pRawData
					
					invoke LogToFile, LOGTIME, offset szTimeStart, NULL, NULL
					
					method hMatrix, CMatrix, Find
					;.while eax == 80
					;	method hMatrix, CMatrix, FindNext
					;.endw
					
					invoke LogToFile, LOGTIME, offset szTimeEnd, NULL, NULL
					
					destroy hMatrix
					;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
				.endif
		   .endif
;********************************************************************
;	WM_SHELLNOTIFY
;	--------------------------------	
;	�Զ�����Ϣ��Сͼ��˵�������¼�
;********************************************************************
		.elseif eax == WM_SHELLNOTIFY
		  	.if wParam == 1
				.if lParam == WM_RBUTTONDOWN
					;����Ҽ������˵�
					;invoke	ModifyMenu,hMenu,0,MF_BYPOSITION,IDM_RESTORE,addr szMenuRestore
					invoke	GetCursorPos,addr @point
					invoke	SetForegroundWindow,hWnd
					;invoke	TrackPopupMenu,hMenu,TPM_RIGHTALIGN,@point.x,@point.y,NULL,hWnd,NULL
					invoke	PostMessage,hWnd,WM_NULL,0,0
				.elseif lParam == WM_LBUTTONDBLCLK
					invoke ShowWindow,hWnd,SW_RESTORE
					invoke SetForegroundWindow,hWnd
					invoke Shell_NotifyIcon,NIM_DELETE,addr xNID
				.endif
		   .endif
;********************************************************************
;	WM_CLOSE
;********************************************************************
		.elseif eax == WM_CLOSE
			invoke MessageBox,hWnd,offset szConfirmQuit,offset szAppName,MB_OKCANCEL + MB_ICONQUESTION
			.if eax == IDOK
				invoke	Shell_NotifyIcon,NIM_DELETE,addr xNID
				invoke QuitApplication
			.endif
		.elseif eax == WM_DESTROY
			invoke	PostQuitMessage,NULL
;********************************************************************
		.else
			;�� DefWindowProc ������ķ���ֵ���ܸı�
			invoke	DefWindowProc,hWnd,uMsg,wParam,lParam
			ret
		.endif
		;WndProc ���� Windows ��Ϣ�󣬱����� Eax �з��� 0
		xor	eax,eax
		ret
WndMainProc	endp
;********************************************************************
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;********************************************************************
;
;PROC 	QuitApplication 
; 
;FUNC	�����˳���������
;
;PARA	N/A
;
;RETN	N/A
;
;USAGE	invoke QuitApplication
;********************************************************************
QuitApplication proc

		mov xMusic.xmIsPlaying,FALSE
		invoke PlayMusicEx,offset xMusic ;ֹͣ���ֵĲ���
		invoke	DestroyMenu,hMenu
		invoke	DestroyWindow,hWinMain
		ret
QuitApplication endp
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;********************************************************************
;PROC 	InitApplication 
;
;FUNC	��ʼ������
;		WM_CREATE ��������
;
;PARA	N/A
;
;RETN	N/A
;
;USAGE	invoke InitApplication
;********************************************************************
InitApplication		proc

		;invoke InitMenuBar
		;invoke InitToolBar
		invoke PreInitData, ADDR xToolBar
		invoke InitToolBar, eax
		;invoke StatusBar
		;invoke GameWindow
		;invoke CommandWindow
		;invoke InitMusic
		;invoke PlayMusicEx,TRUE
		mov xMusic.xmID,IDR_MUSIC
		mov xMusic.xmHandle,NULL
		mov xMusic.xmIsPlaying,TRUE
		invoke PlayMusicEx,addr xMusic		
		ret
		
InitApplication		endp
;********************************************************************
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;********************************************************************
;PROC 	PaintProc 
;
;FUNC	�����ػ溯��
;		WM_PAINT ��������
;
;PARA	Para1 = hWnd ���ھ��
;
;RETN	N/A
;
;USAGE	invoke PaintProc,hWnd
;********************************************************************
PaintProc proc hWnd:DWORD

		LOCAL	@hDC		:DWORD
		LOCAL	@hpaintDC	:DWORD
		LOCAL	@ps			:PAINTSTRUCT

		invoke	BeginPaint,hWnd,addr @ps
		mov	@hDC,eax
		invoke CreateCompatibleDC,@hDC
		mov @hpaintDC,eax
		
		;invoke GetDC,hWinMain
		invoke TextOut,@hDC,100,100,offset szAppName,29

		invoke 	DeleteObject,@hpaintDC
		invoke	EndPaint,hWnd,addr @ps

		ret
PaintProc endp
;********************************************************************
;--------------------------------------------------------------------------------

