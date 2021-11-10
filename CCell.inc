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
			nIndex	:	pointer to the current position in the pPool
 						point to a non-zero value, or set to zero position
 			pValue 	:	pointer to an array of 10 elements
 						used to store the possible values the cell can be set
 		-	Class functions:
 			Reset	:	set nX, nY, nValue & nIndex to zero, clear the Pool
 						won't change anything if the nValue is not zero
 			GetValue:	return the nValue
 			GetX	:
 			GetY	:	return the coordinates of the cell
 			TestNext:	search for next possible value in the Pool
 			BuildPool:	tick off values in the Pool according to a given mask array  
 						
COMMENT ^
 			
include Objects.inc

CCell_Init						PROTO	:DWORD
CCell_DestructorPto		TYPEDEF	PROTO	:DWORD
CCell_ResetPto			TYPEDEF	PROTO	:DWORD,	:DWORD,	:DWORD,	:DWORD
CCell_GetValuePto		TYPEDEF	PROTO	:DWORD
CCell_GetXPto			TYPEDEF	PROTO	:DWORD
CCell_GetYPto			TYPEDEF	PROTO	:DWORD
CCell_TestNextPto		TYPEDEF	PROTO	:DWORD,	:DWORD
CCell_BuildPoolPto		TYPEDEF	PROTO	:DWORD,	:DWORD

CLASS CCell
	CMETHOD	Destructor
	CMETHOD	Reset
	CMETHOD	GetValue
	CMETHOD	GetX
	CMETHOD	GetY
	CMETHOD	TestNext
	CMETHOD	BuildPool
	nX		dd	?
	nY		dd	?
	nIndex	dd	?
	pValue	dd	?
CCell ENDS

.data

	BEGIN_INIT
		dd	offset	CCell_Destructor
		dd	offset	CCell_Reset
		dd	offset	CCell_GetValue
		dd	offset	CCell_GetX
		dd	offset	CCell_GetY
		dd	offset	CCell_TestNext
		dd	offset	CCell_BuildPool
		dd	0		;nX
		dd	0		;nY
		dd	0		;nIndex
		dd	0		;pValue[]
	END_INIT

