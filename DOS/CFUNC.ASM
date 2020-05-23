; args (void* s, int c, size_t n) - void
; AL - c, ES:DI - s address, CX - n
; DI, CX spoiled
memset PROC	
	cld 
	rep stosb	; ES:[DI] = AL, CX > 0; CX--, DI++
	ret
	ENDP

; args (/* same */) first n for first instance of c in s - void
; AL - c, ES:DI - s address, CX - n
; ES:DI - occurence address, ZF set 0/1 if not found/found
; CX spoiled
memchr PROC
	cld
	repne scasb	  ; ES:[DI] != AL, CX > 0; DI++; CX--; 
	dec DI
	ret
	ENDP

; args (void* dest, const void* src, size_t n) - void
; ES:DI - dest address, DS:SI - src address, CX - n
; DI, SI, CX spoiled
memcpy PROC
 	cld
	rep movsb	; ES:[DI] = DS:[SI]; DI++; SI++; CX--;
	ret
	ENDP	

; args (const void* s1, const void* s2, size_t n) - int
; ES:DI - s1 address, DS:SI - s2 address, CX - n
; DI, SI, CX spoiled
memcmp PROC
	mov SI, AX
	mov DI, DX
	repe cmpsb	; while (ES:[DI] == DS:[SI]) DI++; SI++; CX--;
	ret
	ENDP

; args (const char* s) - size_t
; ES:DI - s
; return value CX - string's length
; AL, DI spoiled
strlen PROC
	mov AL, 0
	MOV CX, 0ffffh
	call memchr
	mov DI, CX
	mov CX, 0ffffh
	sub CX, DI
	dec CX
	ret
	ENDP

; args (char* dest, const char* src) - char
; ES:DI - dest, DS:SI - src
; DI, SI, CX - spoiled
strcpy PROC 
	push DI
	call strlen
	pop DI
	call memcpy
	ret
	ENDP

; args (const char* s, int c) - char*
; ES:DI - s, AL - c
; rv - ES:DI, ZF set
; CX - spoiled
strchr PROC
	push DI
	call strlen
	pop DI
	call memchr
	ret
	ENDP

; args (const char* s1, const char* s2) - int
; ES:DI - s1, DS:SI - s2
; CX - ans
strcmp PROC
@@loop:	cmp byte ptr ES:[DI], 00h
		jz @@end_f
		cmp byte ptr DS:[SI], 00h
		jz @@end_s
		cmpsb
		je @@loop

		dec SI
		dec DI
		mov BL, DS:[SI]
		cmp byte ptr ES:[DI], BL
		jb @@second_greater
		mov BL, 01h
		mov CL, BL
		ret
		
@@second_greater:	
		mov BL, 02h
		mov CL, BL
		ret

@@end_f:	
		cmp byte ptr DS:[SI], 00h
		jz @@equal

@@end_s:	
		cmp byte ptr ES:[DI], 00h
		jz @@equal

@@equal:
		xor CL, CL
		mov CL, BL
		ret
		ENDP
