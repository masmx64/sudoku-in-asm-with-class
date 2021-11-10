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
 			pCells	:	pointer to an array containing the MAX_XY*MAX_XY cells
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

include Objects.inc

CMatrix_Init					PROTO	:DWORD
CMatrix_DestructorPto	TYPEDEF PROTO	:DWORD
CMatrix_ResetPto		TYPEDEF PROTO	:DWORD,	:DWORD
CMatrix_BuildCellPto	TYPEDEF PROTO	:DWORD,	:DWORD
CMatrix_MoveOnPto		TYPEDEF PROTO	:DWORD,	:DWORD
CMatrix_WalkThruPto		TYPEDEF PROTO	:DWORD
CMatrix_FindPto			TYPEDEF PROTO	:DWORD
CMatrix_FindNextPto		TYPEDEF	PROTO	:DWORD
CMatrix_OutputPto		TYPEDEF	PROTO	:DWORD,	:DWORD
CMatrix_DisplayPto		TYPEDEF PROTO	:DWORD,	:DWORD

CLASS CMatrix
	CMETHOD	Destructor
	CMETHOD	Reset
	CMETHOD	BuildCell
	CMETHOD	MoveOn
	CMETHOD	WalkThru
	CMETHOD	Find
	CMETHOD	FindNext
	CMETHOD	Output
	CMETHOD	Display
	pCells	dd	?	;CCell* pcell[9][9]
	pMask	dd	?	;int*	pool[9]
	pCur	dd	?	;CCell*	pcurrent
CMatrix ENDS

.data
	BEGIN_INIT
		dd	offset	CMatrix_Destructor
		dd	offset	CMatrix_Reset
		dd	offset	CMatrix_BuildCell
		dd	offset	CMatrix_MoveOn
		dd	offset	CMatrix_WalkThru
		dd	offset	CMatrix_Find
		dd	offset	CMatrix_FindNext
		dd	offset	CMatrix_Output
		dd	offset	CMatrix_Display
		dd	0		;pCell[9][9]
		dd	0		;Mask[9]
		dd	0		;pCur
	END_INIT

.data?
	hMatrix		dd	?
	pResult		dd	81 dup	(?)

.data
	pRawData 	dd	0,0,1,0,2,0,0,7,0
				dd	0,0,9,7,4,0,0,0,0
				dd	4,0,0,6,0,0,0,0,0
				dd	0,0,0,8,0,0,0,5,9
				dd	9,0,3,0,0,0,6,0,7
				dd	2,8,0,0,0,5,0,0,0
				dd	0,0,0,0,0,2,0,0,6
				dd	0,0,0,0,6,3,7,0,0
				dd	0,1,0,0,8,0,4,0,0