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

;------------------------------------------------------------------------------
.code
;------------------------------------------------------------------------------Functions
;********************************************************************
;
;PROC	ShapeWindow
; 
;FUNC	���ô�����״ΪBMPͼ����״

;PARA	Para1 = hwnd ���ھ��
;		Para2 = pbmpname BMPͼ����Դ���Ƶ�ַ��ID
;				����BMPͼ��Ҫ��0��0����ɫΪ����ɫ
;
;RETN	eax == bmphandle  	�ɹ�
;		eax == 0 			ʧ��
;
;USAGE	invoke ShapeWindow,hwnd,pbmpname
;
;********************************************************************
ShapeWindow proc hwnd:DWORD,pbmpname:DWORD

		LOCAL	@hdc,@hbmpdc	:DWORD
		LOCAL 	@rect			:RECT
		LOCAL	@wp				:WINDOWPLACEMENT
		LOCAL	@hbmp,@holdbmp	:DWORD
		LOCAL	@bmp			:BITMAP
		LOCAL 	@x,@y,@startx	:DWORD
		LOCAL 	@hrgn			:DWORD
		LOCAL	@bkcolor		:DWORD
		LOCAL	@count			:DWORD

		invoke GetModuleHandle,NULL
		.if eax == NULL
			;���ʵ�������Ч�����˳�����
			;invoke ErrorMsg,addr szErrorMsg
			ret
		.endif

		invoke LoadBitmap,eax,pbmpname
		.if eax == NULL
			;װ��BMP�ļ�ʧ�ܣ�����
			xor eax,eax
			ret
		.endif
		
		mov @hbmp,eax
		invoke	GetObject,@hbmp,sizeof BITMAP,addr @bmp		
		.if eax == 0
			;װ��BMP�ļ�ʧ�ܣ�����
			invoke  DeleteObject,@hbmp
			xor eax,eax
			ret
		.endif		

		invoke	GetWindowRect,hwnd,addr @rect
		mov @wp.iLength,sizeof WINDOWPLACEMENT
		invoke GetWindowPlacement,hwnd,addr @wp
		.if eax == 0
			mov @wp.flags,-1
		.endif
		invoke	ShowWindow,hwnd,SW_HIDE
		invoke	MoveWindow,hwnd,@rect.left,@rect.top,@bmp.bmWidth,@bmp.bmHeight,FALSE

		invoke  GetDC,hwnd
		mov	@hdc,eax
		invoke	CreateCompatibleDC,@hdc
		mov	@hbmpdc,eax
		invoke	SelectObject,@hbmpdc,@hbmp
		mov @holdbmp,eax

		; ���㴰����״
		invoke	GetPixel,@hbmpdc,0,0
		mov	@bkcolor,eax
		invoke	CreateRectRgn,0,0,0,0
		mov	@hrgn,eax

		mov	@count,0
		mov	@y,0

		.repeat
			mov	@x,0
			mov	@startx,-1
			.repeat
				invoke	GetPixel,@hbmpdc,@x,@y
				.if	@startx == -1
					.if	eax !=	@bkcolor
						;��¼��һ���Ǳ���ɫ��λ��
						mov	eax,@x
						mov	@startx,eax
					.endif
				.else
					.if	eax ==	@bkcolor
						;�������Ѿ��зǱ���ɫ����������ɫ������ Rgn
						mov	ecx,@y
						inc	ecx
						invoke	CreateRectRgn,@startx,@y,@x,ecx
						push	eax
						invoke	CombineRgn,@hrgn,@hrgn,eax,RGN_OR
						pop	eax
						invoke	DeleteObject,eax
						inc	@count
						mov	@startx,-1
					.else
						;�������Ѿ��зǱ���ɫ�ҵ���β������ Rgn
						mov	eax,@x
						.if	eax == @bmp.bmWidth
							inc	eax
							mov	ecx,@y
							inc	ecx
							invoke	CreateRectRgn,@startx,@y,eax,ecx
							push	eax
							invoke	CombineRgn,@hrgn,@hrgn,eax,RGN_OR
							pop	eax
							invoke	DeleteObject,eax
							inc	@count
							mov	@startx,-1
						.endif
					.endif
				.endif
				inc	@x
				mov	eax,@x
			.until eax > @bmp.bmWidth
			inc	@y
			mov	eax,@y
		.until eax > @bmp.bmHeight

		.if	@count
			;����������ΪͼƬ����״
			invoke	SetWindowRgn,hwnd,@hrgn,TRUE
			invoke	BitBlt,@hdc,0,0,@bmp.bmWidth,@bmp.bmHeight,@hbmpdc,0,0,SRCCOPY
			;����������Դ
			invoke	DeleteObject,@hrgn
			invoke	SelectObject,@hbmpdc,@holdbmp
			invoke	DeleteDC,@hbmpdc
			invoke	ReleaseDC,hwnd,@hdc
			;�ָ�����
			.if @wp.flags == 0
				invoke SetWindowPlacement,hwnd,addr @wp
			.else
				invoke ShowWindow,hwnd,SW_SHOW
			.endif
			invoke	InvalidateRect,hwnd,NULL,-1
			;����BMPͼ�ξ����ȫ�ֱ�����
			mov	eax,@hbmp
			;invoke	AddGlobleVariaty,@hbmp,IDV_DELETE
		.else
			;����������Դ
			invoke	DeleteObject,@hrgn
			invoke	SelectObject,@hbmpdc,@holdbmp
			invoke	DeleteDC,@hbmpdc
			invoke	ReleaseDC,hwnd,@hdc
			;�ָ�����
			.if @wp.flags == 0
				invoke SetWindowPlacement,hwnd,addr @wp
			.else
				invoke ShowWindow,hwnd,SW_SHOW
			.endif
			;���ش���
			invoke  DeleteObject,@hbmp			
			xor eax,eax
		.endif

		ret

ShapeWindow endp
;********************************************************************
;--------------------------------------------------------------