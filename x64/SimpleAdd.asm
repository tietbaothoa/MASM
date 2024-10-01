extrn GetStdHandle	: PROC
extrn WriteFile		: PROC
extrn ReadFile		: PROC
extrn ExitProcess	: PROC 

.data
	outp1	db	"Num1 = ", 0h
	outp2	db	"Num2 = ", 0h
	outp3	db	"Sum = ",  0h
.data?
	num1	db	20 dup(?)
	num2	db  20 dup(?)
	sum		db	21 dup(?)
	nByte	dd  ?
.code
main PROC
	mov		rbp, rsp
	sub		rsp, 38h
	xor		rbx, rbx

	mov		rcx, -10
	call	GetStdHandle
	mov		[rbp - 08h], rax

	mov		rcx, -11
	call	GetStdHandle
	mov		[rbp - 10h], rax

	mov		rcx, [rbp-10h]
	mov		rdx, offset outp1
	mov		r8, sizeof outp1
	mov		r9, offset nByte
	mov		[rsp - 20h], rbx
	call	WriteFile

	mov		rcx, [rbp-08h]
	mov		rdx, offset num1
	mov		r8, 10
	mov		r9, offset nByte
	mov		[rsp - 20h], rbx
	call	ReadFile

	mov		rcx, [rbp-10h]
	mov		rdx, offset outp2
	mov		r8, sizeof outp2
	mov		r9, offset nByte
	mov		[rsp - 20h], rbx
	call	WriteFile

	mov		rcx, [rbp-08h]
	mov		rdx, offset num2
	mov		r8, 10
	mov		r9, offset nByte
	mov		[rsp - 20h], rbx
	call	ReadFile

	mov		rcx, [rbp-10h]
	mov		rdx, offset outp3
	mov		r8, sizeof outp3
	mov		r9, offset nByte
	mov		[rsp - 20h], rbx
	call	WriteFile

	mov		rsi, offset num1
	call	atoi
	push	rax

	mov		rsi, offset num2
	call	atoi
	pop		rbx
	add		rax, rbx

	mov		rsi, rax
	mov		rdi, offset sum
	call	itoa

	mov		rcx, [rbp-10h]
	mov		rdx, offset sum
	mov		r8, sizeof sum
	mov		r9, offset nByte
	mov		[rsp - 20h], rbx
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess


main ENDP

atoi PROC	
	push	rbp
	mov		rbp, rsp
	push	rcx
	push	rdx
	xor		rax, rax
	mov		rcx, 10

	multi:
		xor		rdx, rdx
		mov		dl, byte ptr[rsi]
		inc		rsi
		cmp		dl, 0Dh
		jz		break
		sub		rdx, 30h
		add		rax, rdx
		mul		rcx
		jmp		multi

	break:	
		xor		rdx, rdx
		div		rcx
		pop		rcx
		pop		rdx
		mov		rsp, rbp
		pop		rbp
		ret

atoi ENDP

itoa PROC
	push	rbp
	mov		rbp, rsp
	push	rax
	push	rcx
	push	rdx
	mov		rax, rsi	;(int)num
	mov		rcx, 10
	push	69h

	divide:
		xor		rdx, rdx
		div		rcx
		add		rdx, 30h
		push	rdx
		cmp		rax, 0
		jz		popchr
		jmp		divide

	popchr:
		xor		rdx, rdx
		pop		rdx
		cmp		rdx, 69h
		jz		break
		mov		byte ptr[rdi], dl
		inc		rdi
		jmp		popchr

	break:	
		mov		byte ptr[rdi], 0Dh
		inc		rdi
		mov		byte ptr [rdi], 0Ah
		pop		rdx
		pop		rcx
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret
itoa ENDP

END 






