include \masm32\lib\libc\libc.inc
includelib \masm32\lib\libc\msvcrt.lib

wsprintfA PROTO C :DWORD,:VARARG
wsprintf equ <wsprintfA>

OpenLogFile proto
LogToFile proto :dword, :dword, :dword, :DWORD
CloseLogFile proto

;------------------------------------------------------------------------------
.const
MAXSIZE		equ 1024

LOGRAWDATA	equ	0
LOGSTRING	equ 1
LOGTIME		equ	2
LOGMATRIX	equ	3
LOGCELL		equ	4

BYTE_FMT	equ	0
WORD_FMT	equ	1
DWORD_FMT	equ	2

;------------------------------------------------------------------------------
.data?
hLogFile 		dword ?
nBytesWritten 	DWORD  ?
pFileBuffer		db MAXSIZE dup (?)

.data
szLogFileName	db	"Output.txt",0
szLogFileMode	db	"a+t",0

szFmtCRLF		db	0dh, 0ah, 0
szFmtNum		db	"%d ", 0
szFmtChar		db	"%c ", 0
szFmtStr		db	"%s ", 0
szFmtRaw		db	"%02x ", 0
szFmtTime		db	"%04d-%02d-%02d %02d:%02d:%02d.%03d ",0
szFmtCellMov	db	" %d,%d  index = %d ", 0
szFmtCellBld	db	" %d,%d  build = %d ", 0

szTimeStart		db	"Sudoku Matrix Auto Calculator", 0dh, 0ah, \
					"Time start at: ", 0
szTimeEnd		db	"Time end   at: ", 0
; ---------------------------------------------------------------------------
.code

OpenLogFile proc

	invoke fopen,ADDR szLogFileName, addr szLogFileMode
	mov hLogFile,eax
	ret
OpenLogFile endp

;---------------------------------------------------------------------------
CloseLogFile proc
	.if hLogFile
		invoke fclose,hLogFile
	.endif
	ret
CloseLogFile endp

;---------------------------------------------------------------------------
LogToFile proc nLogType:dword, pLogObj:dword, nObjSize:dword, nDataType:dword
	LOCAL @hFile 			:dword
	LOCAL @SysTime 			:SYSTEMTIME
	LOCAL @pBuffer[64]		:byte
	
	pushad
	
	invoke OpenLogFile
	
	mov eax, nLogType
	.if eax == LOGRAWDATA
		invoke strcat, offset pFileBuffer, offset szFmtCRLF
		
		;get the count of leading spaces
		push pLogObj
		pop ecx
		push ecx
		pop eax
		and eax, 0FFFFFFF0h
		sub ecx, eax
		;fill the leading spaces with blank
		cld
		lea edi, @pBuffer
		mov eax, 2020h
		push ecx
		rep stosw
		pop ecx
		rep stosb
		xor eax, eax
		stosw
		invoke strcat, offset pFileBuffer, addr @pBuffer			
		;clear the buffer
		cld
		lea edi, @pBuffer
		xor eax, eax
		mov ecx, 12
		rep stosd
		
		;logging the data
		.while ecx < nObjSize
			push ecx
			
			;get the right position & add crlf to a new line
			push pLogObj
			pop esi
			
			mov eax, nDataType
			.if eax == BYTE_FMT
				add esi, ecx
				push esi
				pop eax
				and eax, 0Fh
				.if eax == 0
					push esi
					invoke strcat, offset pFileBuffer, offset szFmtCRLF
					pop esi
				.endif
				cld
				lodsb
				and eax, 0FFh
				invoke wsprintf, addr @pBuffer, offset szFmtRaw, eax
				invoke strcat, offset pFileBuffer, addr @pBuffer

			.elseif eax ==WORD_FMT
				shl ecx, 1
				add esi, ecx
				push esi
				pop eax
				and eax, 0Fh
				.if eax == 0
					push esi
					invoke strcat, offset pFileBuffer, offset szFmtCRLF
					pop esi
				.endif
				cld
				xor eax, eax
				lodsw
				push eax
				
				shr eax, 8
				and eax, 0FFh
				invoke wsprintf, addr @pBuffer, offset szFmtRaw, eax
				invoke strcat, offset pFileBuffer, addr @pBuffer
				
				pop eax
				and eax, 0FFh
				invoke wsprintf, addr @pBuffer, offset szFmtRaw, eax
				invoke strcat, offset pFileBuffer, addr @pBuffer
				
			.elseif eax == DWORD_FMT
				shl ecx, 2
				add esi, ecx
				
				push esi
				pop eax
				and eax, 0Fh
				.if eax == 0
					push esi
					invoke strcat, offset pFileBuffer, offset szFmtCRLF
					pop esi
				.endif
				cld
				lodsw
				
				push esi
				push eax
				
				shr eax, 8
				and eax, 0FFh
				invoke wsprintf, addr @pBuffer, offset szFmtRaw, eax
				invoke strcat, offset pFileBuffer, addr @pBuffer
				
				pop eax
				and eax, 0FFh
				invoke wsprintf, addr @pBuffer, offset szFmtRaw, eax
				invoke strcat, offset pFileBuffer, addr @pBuffer
				
				pop esi
				push esi
				pop eax
				and eax, 0Fh
				.if eax == 0
					push esi
					invoke strcat, offset pFileBuffer, offset szFmtCRLF
					pop esi
				.endif
				cld
				lodsw
				
				push eax
				
				shr eax, 8
				and eax, 0FFh
				invoke wsprintf, addr @pBuffer, offset szFmtRaw, eax
				invoke strcat, offset pFileBuffer, addr @pBuffer
				
				pop eax
				and eax, 0FFh
				invoke wsprintf, addr @pBuffer, offset szFmtRaw, eax
				invoke strcat, offset pFileBuffer, addr @pBuffer
				
			.endif

			;clear the buffer
			cld
			lea edi, @pBuffer
			xor eax, eax
			mov ecx, 12
			rep stosd
		
			pop ecx
			inc ecx
		.endw
		
		invoke strcat, offset pFileBuffer, offset szFmtCRLF
		;invoke strcat, offset pFileBuffer, offset szFmtCRLF
		
	.elseif eax == LOGSTRING
		mov eax, pLogObj
		invoke strcat, offset pFileBuffer, eax
		invoke strcat, offset pFileBuffer, offset szFmtCRLF
		;invoke strcat, offset pFileBuffer, offset szFmtCRLF
		
	.elseif eax == LOGTIME
	
		mov eax, pLogObj
		invoke strcat, offset pFileBuffer, eax

		invoke GetLocalTime, addr @SysTime
		
		movzx eax, @SysTime.wMilliseconds
		push eax
		
		movzx eax, @SysTime.wSecond
		push eax
		
		movzx eax, @SysTime.wMinute
		push eax
		
		movzx eax, @SysTime.wHour
		push eax
		
		movzx eax, @SysTime.wDay
		push eax
		
		movzx eax, @SysTime.wMonth
		push eax
		
		movzx eax, @SysTime.wYear
		push eax
	
		push offset szFmtTime
		lea eax, @pBuffer
		push eax

		call wsprintf
		add esp, 24h
		invoke strcat, offset pFileBuffer, addr @pBuffer
		invoke strcat, offset pFileBuffer, offset szFmtCRLF
		
	.endif
	
    invoke strlen, offset pFileBuffer
    invoke fwrite, offset pFileBuffer, 1, eax, hLogFile
    invoke RtlZeroMemory, offset pFileBuffer, MAXSIZE
    
    invoke CloseLogFile
    
	popad
	ret
LogToFile endp


