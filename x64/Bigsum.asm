extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data
	outp1	db	"Num1 = ", 0h
	outp2	db	"Num2 = ", 0h
	outp3	db	"Sum = ", 0h 
.data?
	num1	db	100 dup(?)
	num2	db	100 dup(?)
	sum		db	100 dup(?)
	len1	dd	?
	len2	dd	?
	nByte	dd	?
.code
main PROC
	mov		rbp, rsp
	sub		rsp, 38h
	xor		rbx, rbx

	mov		rcx, -10
	call	GetStdHandle
	mov		[rbp-08h], rax

	mov		rcx, -11
	call	GetStdHandle
	mov		[rbp-10h], rax

	mov		rcx, [rbp-10h]
	mov		rdx, offset outp1
	mov		r8, sizeof outp1
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	WriteFile

	mov		rcx, [rbp-08h]
	mov		rdx, offset num1
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	ReadFile

	mov		rcx, [rbp-10h]
	mov		rdx, offset outp2
	mov		r8, sizeof outp2
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	WriteFile

	mov		rcx, [rbp-08h]
	mov		rdx, offset num2
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	ReadFile

	mov		rcx, [rbp-10h]
	mov		rdx, offset outp3
	mov		r8, sizeof outp3
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	WriteFile
	
	mov		rsi, offset num1
	call	Strlen
	mov		[len1], ecx

	mov		rsi, offset num2
	call	Strlen
	mov		[len2], ecx

	mov		rsi, offset num1
	call	Reverstring

	mov		rsi, offset num2
	call	Reverstring

	mov		rsi, offset num1
	mov		rdi, offset num2
	mov		r12, offset sum
	call	bigsum

	mov		rsi, offset sum
	call	Reverstring

	mov		rcx, [rbp-10h]
	mov		rdx, offset sum
	mov		r8, sizeof sum
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	WriteFile	

	mov		rcx, 0
	call	ExitProcess

main ENDP

bigsum PROC
	push	rbp
	mov		rbp, rsp
	push	rax
	push	rbx
	push	rcx
	push	rdx
	mov		eax, [len1]
	mov		ebx, [len2]
	xor		rcx, rcx		; (int)nho

	cmplen:
		cmp		rax, rbx
		jl		insertzero1
		cmp		rax, rbx
		jg		insertzero2
		jmp		calc

	insertzero1:
		cmp		rax, rbx
		jz		calc
		mov		byte ptr [rsi + rax], '0'
		inc		rax
		jmp		insertzero1

	insertzero2:
		cmp		rax, rbx
		jz		calc
		mov		byte ptr [rdi + rbx], '0'
		inc		rbx
		jmp		insertzero2

	calc:
		xor		rax, rax
		xor		rbx, rbx
		mov		al, byte ptr[rsi]
		inc		rsi
		cmp		al, 0Dh
		jz		break
		sub		rax, 30h
		mov		bl, byte ptr[rdi]
		inc		rdi
		cmp		bl, 0Dh
		jz		break
		sub		rbx, 30h
		add		rax, rbx
		add		rax, rcx
		xor		rcx, rcx
		cmp		rax, 10
		jnl		incmem
		jmp		addchar

	incmem:
		inc		rcx
		sub		rax, 10
		jmp		addchar

	addchar:
		add		rax, 30h
		mov		byte ptr[r12], al	
		inc		r12
		jmp		calc

	addmem:
		xor		rcx, rcx
		mov		byte ptr[r12], '1'
		inc		r12
		jmp		break

	break:
		cmp		rcx, 0
		jnz		addmem
		mov		byte ptr[r12], 0Dh
		inc		r12
		mov		byte ptr[r12], 0Ah
		pop		rdx
		pop		rcx
		pop		rbx
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret

bigsum ENDP


Reverstring PROC
	push	rbp
	mov		rbp, rsp
	push	rax
	push	rcx
	push	rdx
	mov		rdx, rsi
	xor		rcx, rcx

	pushchar:
		xor		rax, rax
		mov		al, byte ptr[rsi+rcx]
		inc		rcx
		cmp		al, 0Dh
		jz		popchar
		push	rax
		jmp		pushchar

	popchar:
		xor		rax, rax
		pop		rax
		dec		rcx
		cmp		rcx, 0
		jz		break
		mov		byte ptr[rdx], al
		inc		rdx
		jmp		popchar

	break:
		mov		byte ptr[rdx], 0Dh
		inc		rdx
		mov		byte ptr[rdx], 0Ah
		pop		rax
		pop		rcx
		pop		rdx
		mov		rsp, rbp
		pop		rbp
		ret
Reverstring ENDP

Strlen PROC
	push	rbp
	mov		rbp, rsp
	push	rax
;	mov		rax, rsi
	xor		rcx, rcx

	len:
		mov		al, byte ptr[rsi]
		inc		rsi
		cmp		al, 0Dh
		jz		break
		inc		rcx
		jmp		len

	break:
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret

Strlen ENDP

end