.model tiny
.data
; screen 80x25
VIDEOSTART equ 0b800h	; start of videomemory segment
;background-symbol attributes
;	   brgbirgb
EDGECOLOUR equ 01001001b
MAINCOLOUR equ 10101001b
COLOURBACK equ 00111001b
SHADOWMASK equ 0000011111111111b

.code
org 100h

background MACRO
	mov AL, '%'
	mov AH, COLOURBACK
	mov BX, VIDEOSTART
	mov ES, BX
	mov DI, 660
	mov DX, 0
	
.loop_background:
	mov CX, 60
	rep stosw
	add DI, 40
	inc DX
	cmp DX, 12
	jne .loop_background
	
ENDM

start:
	background
	mov AL, 29
	mov AH, EDGECOLOUR
	mov BX, VIDEOSTART
	mov ES, BX
	mov DI, 830	; has to be 830
	mov DX, 0

; upper bound
	mov CX, 50
	rep stosw
	add DI, 60
; main part
.loop:
	inc DX

	mov AL, 23
	stosw			; first sym

	mov AL, 127
	mov AH, MAINCOLOUR	; middle symbols
	mov CX, 48
	rep stosw

	mov AL, 23
	mov AH, EDGECOLOUR	; the last one
	stosw

	add DI, 60
	cmp DX, 8
	jne .loop

; lower bound
	mov AL, 29
	mov AH, EDGECOLOUR
	mov CX, 50
	rep stosw


	add DI, 60 + 4
	mov AX, SHADOWMASK
	mov CX, 50
	
shadow_front:	; shadow below the table
	and ES:[DI], AX
	add DI, 2
	loop shadow_front
	
	
	sub DI, 2	
	mov CX, 9
		
shadow_right:	; shadow to the right of the table
	sub DI, 80 * 2
	and ES:[DI - 2], AX
	and ES:[DI], AX
	loop shadow_right

	int 20h
end start
