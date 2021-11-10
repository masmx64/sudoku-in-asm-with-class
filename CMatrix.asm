COMMENT ^

 SPS - Sudoku Puzzle Solver
 Developed by masmx64 in masm32 v9.0 + RadAsm v2.2.1.2 
 v0.2 alpha Nov 2007
 v0.1 alpha Dec 2006

 OOP v2.27 
 Jaymeson Trudgen           and Thomas Bleeker
 NaN (Jaymeson@Hotmail.com) and Thomas (_thomas_@runbox.com)
 ------------------------------------------------------------------------------ 
 CMatrix-	Class members:
 			pCell	:	pointer to an array containing the MAX_XY*MAX_XY cells
 			pCur	:	indicating pointer to the current cell processed
 			pMask	:	pointer to an array of MAX_XY elements
 						used to store the temprary mask values for building cells
		-	Class functions:
 			Reset	:	initialize the matrix with a given data array
 						setting up nX, nY, nValue, nindex & pPool of cells
 			BuildCell:	scan the row, column & the 3*3 submatrix of the cell
 						filling the temp Pool to build up the cell
 			MoveOn	:	move the current indicator to next/last cell
 			WalkThru:	step through the whole matrix to find out solutions
 			Output	:	output solution to an array for display or printing
 			Display	:	output result to a file/console
COMMENT ^
 			
include CMatrix.inc

.code

;------------------------------------------------------------------------------Constructor()
;METHOD:	Constructor
;IN:		void
;OUT:		void
;======================

CMatrix_Init PROC uses ebx esi edi lpTHIS :DWORD
	SET_CLASS CMatrix
	SetObject edi, CMatrix
	
	;alloc memory for pCells[]
	invoke GlobalAlloc, GPTR, MAX_XY*MAX_XY*(sizeof dword)
	mov [edi].pCells, eax
	;alloc memory for Mask[9]
	invoke GlobalAlloc, GPTR, MAX_XY*(sizeof dword)
	mov [edi].pMask, eax
	
	;create new objects
	xor ebx, ebx
	mov esi, [edi].pCells
	
	.while ebx < MAX_XY*MAX_XY
		newobject CCell
		mov dword ptr [esi + 4*ebx], eax
		inc ebx
	.endw
	
	;set pCur to pCell[0][0]
	mov eax, dword ptr [esi]
	mov dword ptr [edi].pCur, eax
		
	ReleaseObject edi
	ret
CMatrix_Init ENDP

;------------------------------------------------------------------------------Destructor()
;METHOD:	Destructor
;IN:		void
;OUT:		void
;=====================
CMatrix_Destructor PROC uses ebx esi edi lpTHIS :DWORD
	SetObject edi, CMatrix
	
	;destroy objects
	xor ebx, ebx
	mov esi, [edi].pCells
	.while ebx < MAX_XY*MAX_XY
		mov eax, dword ptr [esi + 4*ebx]
		.if eax
			destroy eax
		.endif
		inc ebx
	.endw
	
	;free memory
	invoke GlobalFree, [edi].pCells
	invoke GlobalFree, [edi].pMask

	ReleaseObject edi
	ret
CMatrix_Destructor ENDP

;------------------------------------------------------------------------------InitMatrix()
;METHOD:	Reset
;IN:		*pData[81] = Pointer of an array containing the original matrix data
;OUT:		eax = number of cells initialized
;===============================================================================
CMatrix_Reset PROC uses ebx esi edi lpTHIS :DWORD, lpData :DWORD

	LOCAL @x 	:DWORD
	LOCAL @y 	:DWORD
	LOCAL @div 	:BYTE
	
	SetObject edi, CMatrix

	xor ebx, ebx
	mov @div, MAX_XY
	.while ebx < MAX_XY*MAX_XY
		;calculate coordinates
		mov eax, ebx
		div @div
		push eax
		;y
		and eax, 0FH
		mov @y, eax
		;x
		pop eax
		shr eax, 8
		mov @x, eax
		;initialize data
		mov esi, [edi].pCells
		mov esi, dword ptr [esi + 4*ebx]
		mov eax, lpData
		mov eax, dword ptr [eax + 4*ebx]
		.break .if eax < 0 || eax > MAX_XY
		method esi, CCell, Reset, @x, @y, eax
		inc ebx
	.endw
	mov eax, ebx
	
	ReleaseObject edi
	ret
CMatrix_Reset ENDP

;------------------------------------------------------------------------------BuildCell()
;METHOD:	BuildCell
;IN:		*lpCell = Pointer of the cell to be scanned
;OUT:		eax = Count of non-zero elements in the cell's pool
;==============================================================
CMatrix_BuildCell PROC uses ebx esi edi lpTHIS :DWORD, lpCell :DWORD

	LOCAL @x :DWORD
	LOCAL @y :DWORD
	LOCAL @p :DWORD
	LOCAL @div :BYTE
	
	SetObject edi, CMatrix
	
	method lpCell, CCell, GetValue
	.if !eax
		;clear the Pool
		invoke RtlZeroMemory, [edi].pMask, MAX_XY*(sizeof dword)
		;get coordinates of lpCell
		method lpCell, CCell, GetX
		mov @x, eax
		method lpCell, CCell, GetY
		mov @y, eax
		;scan
		mov @div, MAX_XY
		;row
		xor ebx, ebx
		.while ebx < MAX_XY
			;get the position of the current pCell
			mov eax, @y
			mul @div
			add eax, ebx
			;get the cell
			mov esi, [edi].pCells
			mov esi, dword ptr [esi + eax * sizeof dword]
			;fill the mask array
			method esi, CCell, GetValue
			mov esi, [edi].pMask
			mov dword ptr [esi + eax * sizeof dword], eax
			;.endif
			inc ebx
		.endw
		;column
		xor ebx, ebx
		.while ebx < MAX_XY
			;get the position in the pool
			mov eax, ebx
			mul @div
			add eax, @x
			;get the cell
			mov esi, [edi].pCell
			mov esi, [esi + 4*eax]
			method esi, CCell, GetValue
			mov esi, [edi].pMask
			mov dword ptr [esi + eax * sizeof dword], eax
			inc ebx
		.endw
		;the 3*3 sub-matrix
		xor ebx, ebx
		.while ebx < MAX_XY
			mov eax, @y
			div MAX_Y
			mul MAX_Y
			mul @divisor
			mov @p, eax
			mov eax, @x
			div MAX_X
			mul MAX_X
			add @p, eax			
			add @p, ebx
			mov eax, ebx
			div MAX_X
			mul MAX_X
			add eax, @p
			mov esi, [edi].pCells
			mov esi, dword ptr[esi + eax * sizeof dword]
			push esi
			method esi, CCell, GetValue
			mov esi, [edi].pMask
			mov dword ptr [esi + eax * sizeof dword], eax
			inc ebx
		.endw			
	.endif
	;call Cell function: BuildPool
	method lpCell, CCell, BuildPool, [edi].pMask

	ReleaseObject edi
	ret
CMatrix_BuildCell ENDP

;------------------------------------------------------------------------------MoveOn()
;METHOD		MoveOn
;IN:		blDirection = TRUE	search forward
;			      		  FALSE	search backward
;OUT:		eax         = current position of the cell
;		              	  zero 	if fail
;======================================================
CMatrix_MoveOn PROC uses ebx esi edi lpTHIS :DWORD, blDirection :DWORD

	LOCAL 	@x		:dword
	LOCAL	@y		:dword
	LOCAL 	@divisor:BYTE
	
	SetObject edi, CMatrix

	mov esi, [edi].pCur
	method esi, CCell, GetX
	mov @x, eax
	method esi, CCell, GetY
	mov @y, eax

	.if blDirection
		inc @x
		.if @x == MAX_XY
			inc @y
			xor eax, eax
			.if @y == MAX_XY
				jmp @F			;exit
			.else
				mov @x, eax		;set to the beginning of next row
			.endif
		.endif
	.else
		method esi, CCell, GetValue
		method esi, CCell, Reset, @x, @y, eax
		dec @x
		.if @x < 0
			dec @y
			xor eax, eax
			.if @y < 0
				jmp @F
			.else
				mov @x, MAX_X - 1	;set to the end of last row
			.endif
		.endif
	.endif
	
	;set pCur to new position
	mov @div, MAX_XY
	mov eax, @y
	mul @div
	add eax, @x
	mov esi, [edi].pCells
	mov esi, dword ptr [esi + eax * sizeof dword]
	mov [edi].pCur, esi
	mov eax, TRUE
@@:
	;push eax
	;method edi, CMatrix, Display, NULL
	;pop eax
	
	ReleaseObject edi
	ret
CMatrix_MoveOn ENDP

;------------------------------------------------------------------------------WalkThru()
;METHOD		WalkThru
;IN:		void
;OUT:		void
;==========================
CMatrix_WalkThru PROC uses ebx esi edi lpTHIS :DWORD

	LOCAL blDirection :DWORD

	SetObject edi, CMatrix

	.while TRUE
		mov esi, [edi].pCur
		method esi, CCell, IsFixed
		.if !eax
			method esi, CCell, GetCurVal
			.if eax
				method esi, CCell, TestNext, TRUE
				.if eax
					mov blDirection, TRUE
				.else
					mov blDirection, FALSE
				.endif
			.else
				method edi, CMatrix, BuildCell, esi
				.if eax
					method esi, CCell, TestNext, TRUE
					.if eax
						mov blDirection, TRUE
					.else
						mov blDirection, FALSE
					.endif
				.else
					mov blDirection, FALSE
				.endif
			.endif
		.endif

		method edi, CMatrix, MoveOn, blDirection
		.break .if !eax
	.endw

	ReleaseObject edi
	ret
CMatrix_WalkThru ENDP

;------------------------------------------------------------------------------Find()
;METHOD		Find
;IN:		void
;OUT:		index of current cell in the pCell array
;			FALSE if fail
;===================================================
CMatrix_Find PROC uses ebx esi edi lpTHIS :DWORD
	
	LOCAL	@divisor:byte
	
	SetObject edi, CMatrix
	
	method edi, CMatrix, WalkThru
	method edi, CMatrix, Display, NULL
	
	mov @divisor, 9
	mov esi, [edi].pCur
	method esi, CCell, GetX
	push eax
	pop ebx
	method esi, CCell, GetY
	mul @divisor
	add eax, ebx
	
	ReleaseObject edi
	ret

CMatrix_Find endp

;------------------------------------------------------------------------------FindNext()
;METHOD		FindNext
;IN:		void
;OUT:		index of current cell in the pCell array
;			FALSE if fail
;===================================================
CMatrix_FindNext PROC uses ebx esi edi lpTHIS :DWORD
	
	LOCAL	@divisor:byte
	
	SetObject edi, CMatrix
	
	mov @divisor, 9

	mov esi, [edi].pCur
	method esi, CCell, GetX
	push eax
	pop ebx
	method esi, CCell, GetY
	mul @divisor
	add eax, ebx
	
	.if eax == 80	;the last cell position
		method edi, CMatrix, Find
		.if eax == 80
			method edi, CMatrix, Display, NULL
		.endif
	.endif
	
	mov esi, [edi].pCur
	method esi, CCell, GetX
	push eax
	pop ebx
	method esi, CCell, GetY
	mul @divisor
	add eax, ebx
		
	ReleaseObject edi
	ret

CMatrix_FindNext endp

;------------------------------------------------------------------------------Output()
;METHOD		Output
;IN:		*lpData = Pointer to an array[81] to store the result
;OUT:		void
;====================================================================
CMatrix_Output PROC uses ebx esi edi lpTHIS :DWORD, lpData :DWORD

	SetObject edi, CMatrix

	xor ebx, ebx

	.while ebx < 81
		mov esi, [edi].pCell
		mov esi, [esi + 4*ebx]

		method esi, CCell, IsFixed
		.if eax
			method esi, CCell, GetValue
		.else
			method esi, CCell, GetCurVal
		.endif
		mov esi, lpData
		mov dword ptr [esi + 4*ebx], eax
		
		inc ebx
	.endw

	ReleaseObject edi
	ret
CMatrix_Output ENDP

;------------------------------------------------------------------------------Display()
;METHOD		Display
;IN:		*hFile = Handle of output device, if NULL , then stdout is uses
;OUT:		void
;==============================================================================
CMatrix_Display PROC uses edi lpTHIS :DWORD, lpszFileName :DWORD
	
	LOCAL	@buffer[81]		:dword
		
	SetObject edi, CMatrix
	
	;push eax
	;mov esi, [edi].pCur
	;method esi, CCell, GetY
	;push eax
	;method esi, CCell, GetX
	;push eax
	;push offset szFmtCellMov
	;lea eax, @buffer
	;push eax
	;call wsprintf
	;add esp, 14h
	;invoke LogToFile, LOGSTRING, addr @buffer, NULL, NULL
	
	method hMatrix, CMatrix, Output, offset pResult
	invoke LogToFile, LOGRAWDATA, offset pResult, 81, DWORD_FMT

	ReleaseObject edi
	ret
CMatrix_Display ENDP

