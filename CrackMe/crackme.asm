__NR_read equ 0
__NR_write equ 1
__NR_exit equ 60

%macro read_check_password 1
	mov rax, __NR_read
	xor rdi, rdi
	mov rsi, %1 
	mov rdx, 255
	syscall
	check_password %1
%endmacro 
 
%macro check_password 1 
	xor rdx, rdx
	xor rax, rax
	xor rcx, rcx
	mov rsi, %1
	mov rdi, password
	%%loop:
		mov al, [rsi + rdx]
		cmp al, 0
		je %%increase
	%%return:	
		dec al
		dec al
		cmp al, 8
		je %%increase_double
		mov cl, [rdi + rdx]
		inc rdx
		cmp al, cl
		jne .denied
		cmp al, 0	; end of both strings
		je .granted
		jmp %%loop
	%%increase:
		inc al
		inc al
		jmp %%return
	%%increase_double:
		inc al
		inc al
		inc al
		inc al
		jmp %%return
%endmacro
 
segment .text
	global _start

_start:
	xor r10, r10
.begin:
	inc r10
	mov rax, __NR_write
	mov rdi, 1
	mov rsi, greeting_msg
	mov rdx, len_greeting
	syscall
	
	read_check_password user_password

.denied:
	mov rsi, incorrect_msg
	mov rdx, len_incorrect
	mov rax, __NR_write
	mov rdi, 1
	syscall
	cmp r10, 3
	jne .begin
	mov rsi, alexander_msg
	mov rdx, len_alexander
	jmp .write

.granted:
	mov rsi, correct_msg
	mov rdx, len_correct
	
.write:
	mov rax, __NR_write
	mov rdi, 1
	syscall

.exit:
	mov rax, __NR_exit
	xor rdi, rdi
	syscall

segment .rodata
greeting_msg: db 'Enter the password:', 10
len_greeting: equ $-greeting_msg

incorrect_msg: db 'Denied', 10
len_incorrect: equ $-incorrect_msg

alexander_msg: db 'https://www.youtube.com/watch?v=BtLDidvnl8o', 10
len_alexander: equ $-alexander_msg

correct_msg: db 'Granted', 10
len_correct: equ $-correct_msg

password: db 'pgaipmjjgle', 10
len_password: equ $-password

segment .data
user_password: times 255 db 0
len_input: equ $-user_password	
