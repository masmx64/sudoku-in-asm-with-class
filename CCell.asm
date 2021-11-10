COMMENT ^

 SPS - Sudoku Puzzle Solver
 Developed by masmx64 in masm32 v9.0 + RadAsm v2.2.1.2 
 v0.2 alpha Nov 2007
 v0.1 alpha Dec 2006

 OOP v2.27 
 Jaymeson Trudgen           and Thomas Bleeker
 NaN (Jaymeson@Hotmail.com) and Thomas (_thomas_@runbox.com)
 ------------------------------------------------------------------------------ 
 CCell	-	Class members:
 			nX		:
			nY		:	position of cell in the matrix (column & row)
 			nValue	:	the value of element in the matrix
 						A zero value is assigned if not initialized with 1~9
			nIndex	:	pointer to the current position in the pPool
 						point to a non-zero value, or set to zero position
 			pPool 	:	pointer to an array of 10 elements
 						used to store the possible values the cell can be set
 		-	Class functions:
 			Reset	:	set nX, nY, nValue & nIndex to zero, clear the Pool
 						won't change anything if the nValue is not zero
 			GetValue:	return the nValue
 			GetCurVal:	return the value indicated by nIndex in the Pool
 			IsFixed	:	check whether the cell can be changed
 						return TRUE if the cell is initialized with non-zero value
 			GetX	:
 			GetY	:	return the coordinates of the cell
 			TestNext:	search for next possible value in the Pool
 			BuildPool:	tick off values in the Pool according to a given mask array  
 						
COMMENT ^

include CCell.inc

.code

;------------------------------------------------------------------------------Constructor()
;METHOD:	Constructor
;IN:		void
;OUT:		void
;======================
CCell_Init PROC	uses edi lpTHIS :DWORD
	SET_CLASS CCell
	SetObject edi, CCell
	
	;alloc memory for Value[10]
	invoke GlobalAlloc, GPTR, (MAX_XY+1)*(sizeof DWORD)
	.if !eax
		mov [edi].pValue, eax
	.endif
	method edi, CCell, Reset, 0, 0, 0
	
	ReleaseObject edi
	ret
CCell_Init ENDP

;------------------------------------------------------------------------------Destructor()
;METHOD:	Destructor
;IN:		void
;OUT:		void
;=====================
CCell_Destructor PROC uses edi lpTHIS :DWORD
	SetObject edi, CCell
	
	;free memory of Pool
	mov eax, [edi].pPool
	.if !eax
		invoke GlobalFree, [edi].pValue
	.endif
	
	ReleaseObject edi
	ret
CCell_Destructor ENDP

;------------------------------------------------------------------------------Reset()
;METHOD:	Reset	:	set nX, nY & nValue, set nIndex to zero, clear the Pool
;IN:		X, Y, Value
;OUT:		void
;==============================================================================
CCell_Reset PROC uses esi edi lpTHIS :DWORD, dwX :DWORD, dwY :DWORD, dwValue :DWORD
	SetObject edi, CCell
	
	;set nX
	push dwX
	pop [edi].nX
	;set nY
	push dwY
	pop [edi].nY
	;set nIndex
	mov [edi].nIndex, 0
	;initialize the Value[10]
	mov esi, [edi].pValue
	xor eax, eax
	.while eax <= MAX_XY
		mov dword ptr [esi + 4*eax], eax
		inc eax
	.endw
	;set nValue
	mov eax, dwValue
	mov [edi], eax
	
	ReleaseObject edi
	ret
CCell_Reset ENDP

;------------------------------------------------------------------------------GetValue()
;METHOD:	GetValue
;IN:		void
;OUT:		eax = Value
;===================
CCell_GetValue PROC uses esi edi lpTHIS :DWORD
	SetObject edi, CCell
	
	mov esi, [edi].pValue
	mov eax, [edi].nIndex
	mov eax, dword ptr [esi + eax*sizeof dword]
	
	ReleaseObject edi
	ret
CCell_GetValue ENDP

;------------------------------------------------------------------------------SetValue()
;METHOD:	SetValue
;IN:		Value
;OUT:		eax = Value	success
;			      zero	fail, Value not changed
;======================================================
CCell_SetValue PROC uses edi lpTHIS :DWORD, dwValue :DWORD
	SetObject edi, CCell

	mov eax, dwValue
	.if eax < 0 || eax > MAX_XY
		xor eax, eax
	.else
		mov [edi].nValue, eax
	.endif

	ReleaseObject edi
	ret
CCell_SetValue ENDP

;------------------------------------------------------------------------------GetX()
;METHOD:	GetX
;IN:		void
;OUT:		eax = nX
;===================
CCell_GetX PROC uses edi lpTHIS: DWORD
	SetObject edi, CCell
	
	mov eax, [edi].nX
		
	ReleaseObject edi
	ret
CCell_GetX endp

;------------------------------------------------------------------------------GetY()
;METHOD:	GetY
;IN:		void
;OUT:		eax = nY
;===================
CCell_GetY PROC uses edi lpTHIS :DWORD
	SetObject edi, CCell
	
	mov eax, [edi].nY
		
	ReleaseObject edi
	ret
CCell_GetY endp

;------------------------------------------------------------------------------SetX()
;METHOD:	SetX
;IN:		X
;OUT:		eax = X	success
;			      zero fail, X not changed
;==============
CCell_SetX PROC uses edi lpTHIS :DWORD, dwX :DWORD
	SetObject edi, CCell
	
	mov eax, dwX
	.if eax < 0 || eax > MAX_XY
		xor eax, eax
	.else
		mov [edi].nX, eax
	.endif
	
	ReleaseObject edi
	ret
CCell_SetX endp

;------------------------------------------------------------------------------SetY()
;METHOD:	SetY
;IN:		Y
;OUT:		eax = Y 	success
;			      zero 	fail, Y not changed
;===================================================
CCell_SetY PROC uses edi lpTHIS :DWORD, dwY :DWORD
	SetObject edi, CCell
	
	mov eax, dwY
	.if eax < 0 || eax > 9
		xor eax, eax
	.else
		mov [edi].nY, eax
	.endif
	
	ReleaseObject edi
	ret
CCell_SetY endp

;------------------------------------------------------------------------------MoveIndex()
;METHOD:	TestNext
;IN:		TRUE	Direction = Forward
;			FALSE	Direction = Backward
;OUT:		success eax = Index points to next non-zero element in Pool[]
;			fail	eax = Index = 0
;===========================================================================
CCell_TestNext PROC uses ebx esi edi lpTHIS :DWORD, blDirection :DWORD

	SetObject edi, CCell
	
	mov esi, [edi].pValue
	mov ebx, [edi].nIndex
	xor eax, eax
	
	.if blDirection
		;move forward
		inc ebx
		.while ebx <= MAX_XY
			mov eax, [esi + 4*ebx]
			.break .if eax
			inc ebx
		.endw
	.else
		;move backward
		dec ebx
		.while ebx >= 0
			mov eax, [esi + 4*ebx]
			.break .if eax
			dec ebx
		.endw
	.endif

	mov [edi].nIndex, eax
		
	ReleaseObject edi
	ret
CCell_TestNext endp

;------------------------------------------------------------------------------BuildPool()
;METHOD:	BuildPool
;IN:		*List[9] = Pointer to an array containing the mask values
;OUT:		eax = Count of non-zero elements in the Value[]
;====================================================================
CCell_BuildPool PROC uses ebx ecx esi edi lpTHIS :DWORD, lpList :DWORD

	SetObject edi, CCell
		
	method edi, CCell, GetValue
	.if eax
		;fixed, count = 0
		xor eax, eax
	.else
		mov esi, [edi].pValue
		xor ebx, ebx
		xor ecx, ecx
		.while ebx < MAX_XY
			mov eax, lpList
			mov eax, dword ptr [eax +ebx*sizeof dword]
			.if eax
				mov dword ptr [esi + eax*sizeof dword], 0
				inc ecx 
			.endif
			inc ebx
		.endw
		mov eax, ecx
	.endif
	
	ReleaseObject edi
	ret
CCell_BuildPool endp 
