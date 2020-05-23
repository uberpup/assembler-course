;local@@
.model tiny

.data
str1:	db 'Hello$', 00h
str2:	db 'Helloo$', 00h
str3:	db 'verylongstring$', 00h
str4:	db 'nnnAnA$', 00h

.code
org 100h

start:
	; test strcmp
	lea DI, str1
	lea SI, str2
	call strcmp
	
	xor DX, DX
	mov DL, CL
	
	mov AH, 02h	; display output
	int 21h
	
	
	; test strlen
	xor CX, CX
	lea DI, str3
	call strlen
	
	xor DX, DX
	xor AX, AX
	mov DX, CX
	mov AH, 02h
	int 21h
	
	;test strchr
	;xor DI, DI
	;xor AX, AX
	;lea DI, str4
	;mov AL, 'A'
	;call strchr
	;xor AX, AX
	
	;xor DX, DX
	;mov DX, DI
	;mov AH, 09h
	;int 21h
	
	mov AX, 4c00h
	int 21h

include CFUNC.ASM
	
end start
