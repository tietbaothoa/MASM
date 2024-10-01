extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data
	outp1	db "String: ", 0h
	outp2	db "Min = ",  0h
	outp3	db "Max = ", 0h

.data?
	Strarr	db	500 dup(?)
	Strnum	db	500 dup(?)
	num		db	10 dup(?)
	Minn	db	10 dup(?)
	Maxx	db	10 dup(?)
	nByte	dd	?

.code
main PROC
	mov		rbp, rsp
	sub		rsp, 38h
	xor		rbx, rbx

	mov		rcx, -11
	call	GetStdHandle
	mov		[rbp - 08h], rax

	mov		rcx, -10
	call	GetStdHandle
	mov		[rbp - 10h], rax

	mov		rcx, [rbp - 08h]
	mov		rdx, offset outp1
	mov		r8, sizeof outp1
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	WriteFile

	mov		rcx, [rbp - 10h]
	mov		rdx, offset Strarr
	mov		r8, 500
	mov		r9, offset nByte
	mov		[rsp - 20h], rbx
	call	ReadFile

	mov		rsi, offset Strarr
	mov		rdi, offset Strnum
	call	Split

	mov		rsi, offset Strnum
	mov		rdi, offset Minn
	call	Findmin

	mov		rsi, offset Strnum
	mov		rdi, offset Maxx
	call	Findmax

	mov		rcx, [rbp - 08h]
	mov		rdx, offset outp2
	mov		r8, sizeof outp2
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	WriteFile

	mov		rcx, [rbp - 08h]
	mov		rdx, offset Minn
	mov		r8, sizeof Minn
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	WriteFile

	mov		rcx, [rbp - 08h]
	mov		rdx, offset outp3
	mov		r8, sizeof outp3
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	WriteFile

	mov		rcx, [rbp - 08h]
	mov		rdx, offset Maxx
	mov		r8, sizeof Maxx
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess

main ENDP

Split PROC
	push	rbp
	mov		rbp, rsp
	push	rax
	mov		rax, offset num
	push	rcx
	push	rdx
	xor		rcx, rcx

	eachchar:
		xor		rdx, rdx
		mov		dl, byte ptr[rsi]
		inc		rsi
		cmp		dl, ' '
		jz		savetoint
		cmp		dl, 0Dh
		jz		savetoint
		mov		byte ptr[rax], dl
		inc		rax
		jmp		eachchar

	savetoint:
		xor		rdx, rdx
		mov		byte ptr[rax], 0Dh
		inc		rax
		push	rsi
		push	rcx
		mov		rsi, offset num
		call	atoi
		pop		rcx
		mov		dword ptr[rdi + rcx*4], eax
		inc		rcx
		pop		rsi
		cmp		byte ptr[rsi-1], 0Dh
		jz		break
		mov		rax, offset num
		jmp		eachchar

	break:
		pop		rdx
		pop		rcx
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret 

Split ENDP

Findmin PROC
	push	rbp
	mov		rbp, rsp
	push	rax
	push	rbx
	push	rcx		
	push	rdx		;min
	xor		rcx, rcx
	xor		rbx, rbx
	mov		rdx, 0FFFFFFFh
	
	compare:
		xor		rax, rax
		mov		eax, dword ptr[rsi+rcx*4]
		inc		rcx
		cmp		rax, 0h
		jz		transmintochar
		cmp		rax, rdx
		jl		setmin
		jmp		compare

	setmin:
		mov		rdx, rax
		jmp		compare

	transmintochar:
		mov		rsi, rdx
		mov		rdi, offset Minn
		call	itoa

	break:
		pop		rdx
		pop		rcx
		pop		rbx
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret
Findmin ENDP

Findmax PROC
	push	rbp
	mov		rbp, rsp
	push	rax
	push	rbx
	push	rcx		
	push	rdx		;min
	xor		rcx, rcx
	xor		rbx, rbx
	xor		rdx, rdx
	
	compare:
		xor		rax, rax
		mov		eax, dword ptr[rsi+rcx*4]
		inc		rcx
		cmp		rax, 0h
		jz		transmintochar
		cmp		rax, rdx
		jg		setmax
		jmp		compare

	setmax:
		mov		rdx, rax
		jmp		compare

	transmintochar:
		mov		rsi, rdx
		mov		rdi, offset Maxx
		call	itoa

	break:
		pop		rdx
		pop		rcx
		pop		rbx
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret
Findmax ENDP

		

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
end