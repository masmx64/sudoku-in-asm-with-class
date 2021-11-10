;------------------------------------------------------------------------------Copyright
; CMasmApp
; MAsm Class Implementation of Application Framework for Win32
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
;------------------------------------------------------------------------------Program Description
;
; CMasmApp	... 
; 		-	Class members:
; 		-	Class functions:
;------------------------------------------------------------------------------Include Files
include Objects.inc

;------------------------------------------------------------------------------Class Definition
;Class Method Protos
;===================

CMasmApp_Init	PROTO	:DWORD

;------------------------------------------------------------------------------Class Functions
;FUNCTION POINTER PROTOS
;==============

CMasmApp_DestructorPto		TYPEDEF	PROTO	:DWORD
CMasmApp_ResetPto			TYPEDEF	PROTO	:DWORD,	:DWORD,	:DWORD,	:DWORD
CMasmApp_GetValuePto		TYPEDEF	PROTO	:DWORD
CMasmApp_GetCurValPto		TYPEDEF	PROTO	:DWORD
;CMasmApp_SetValuePto		TYPEDEF	PROTO	:DWORD,	:DWORD
CMasmApp_IsFixedPto		TYPEDEF	PROTO	:DWORD
CMasmApp_GetXPto			TYPEDEF	PROTO	:DWORD
CMasmApp_GetYPto			TYPEDEF	PROTO	:DWORD
;CMasmApp_SetXPto			TYPEDEF	PROTO	:DWORD,	:DWORD
;CMasmApp_SetYPto			TYPEDEF	PROTO	:DWORD,	:DWORD
CMasmApp_MoveIndexPto		TYPEDEF	PROTO	:DWORD,	:DWORD
CMasmApp_BuildPoolPto		TYPEDEF	PROTO	:DWORD,	:DWORD
;CMasmApp_GetCountPto		TYPEDEF	PROTO	:DWORD

;------------------------------------------------------------------------------Class Structure Implementation
;Class Structure
;==============

CLASS CMasmApp
;public:
	CMETHOD	Destructor
	CMETHOD	Reset
	CMETHOD	GetValue
	CMETHOD	GetCurVal
;	CMETHOD	SetValue
	CMETHOD	IsFixed
	CMETHOD	GetX
	CMETHOD	GetY
;	CMETHOD	SetX
;	CMETHOD	SetY
	CMETHOD	MoveIndex
	CMETHOD	BuildPool
;	CMETHOD	GetCount
;private:
	nX		dd	?
	nY		dd	?
	nIndex	dd	?
	nValue	dd	?
	pPool	dd	?

CMasmApp ENDS

;------------------------------------------------------------------------------Class Data Implementation
;Class data structure implementation
;==============

.data

	BEGIN_INIT
	;public:
		dd	offset	CMasmApp_Destructor
		dd	offset	CMasmApp_Reset
		dd	offset	CMasmApp_GetValue
		dd	offset	CMasmApp_GetCurVal
;		dd	offset	CMasmApp_SetValue
		dd	offset	CMasmApp_IsFixed
		dd	offset	CMasmApp_GetX
		dd	offset	CMasmApp_GetY
;		dd	offset	CMasmApp_SetX
;		dd	offset	CMasmApp_SetY
		dd	offset	CMasmApp_MoveIndex
		dd	offset	CMasmApp_BuildPool
;		dd	offset	CMasmApp_GetCount
	;private:
		dd	0		;nX
		dd	0		;nY
		dd	0		;nIndex
		dd	0		;nValue
		dd	0		;pPool [10]
	END_INIT

