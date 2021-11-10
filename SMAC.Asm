COMMENT ^

 HS - Sudoku Puzzle Game Solver
 Developed by masmx64 in masm32 v9.0 + RadAsm v2.2.1.2 
 v0.2 alpha Nov 2007
 v0.1 alpha Dec 2006
 						
COMMENT ^

include MainProc.asm

;------------------------------------------------------------------------------Code Implementation
.code


; -----------------------------------------------------------------------------Program Entry

start:
		invoke EnsureSingleInstance
		invoke GetCommandLine
		mov pszCommandLine,eax

		invoke	InitCommonControls
		invoke	GetModuleHandle,NULL
		mov	hInstance,eax

		invoke InitInstance

		.while	TRUE
			invoke	GetMessage,offset Msg,NULL,0,0
			.break	.if eax	== 0 || eax == -1
			invoke	TranslateMessage,offset Msg
			invoke	DispatchMessage,offset Msg
		.endw
		invoke	ExitProcess,NULL

end start
