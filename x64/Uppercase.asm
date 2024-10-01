extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data
	outp1	db "String: ", 0h
	outp2	db "String after uppercase: ",  0h

.data?
	String	db	100 dup(?)
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
	mov		rdx, offset String
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp - 20h], rbx
	call	ReadFile

	mov		rbx, offset String
	call	Uppercase

	mov		rcx, [rbp - 08h]
	mov		rdx, offset outp2
	mov		r8, sizeof outp2
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	WriteFile

	mov		rcx, [rbp - 08h]
	mov		rdx, offset String
	mov		r8, sizeof String
	mov		r9, offset nByte
	mov		[rsp-20h], rbx
	call	WriteFile	

	mov		rcx, 0
	call	ExitProcess

main ENDP

Uppercase PROC
	push	rbp
	mov		rbp, rsp
	push	rax
	push	rcx
	push	rdx
	mov		rdx, offset String
	xor		rcx, rcx

	cmptoupper:
		xor		rax, rax
		mov		al, byte ptr[rbx + rcx]
		inc		rcx
		cmp		al, 0Dh
		jz		break
		cmp		al, 'a'
		jl		notlower
		cmp		al, 'z'
		jg		notlower
		jmp		upper

	notlower:
		mov		byte ptr[rdx], al
		inc		rdx
		jmp		cmptoupper

	upper:
		sub		al, 20h
		mov		byte ptr[rdx], al
		inc		rdx
		jmp		cmptoupper

	break:
		mov		byte ptr[rdx], 0Dh
		inc		rdx
		mov		byte ptr[rdx], 0Ah
		pop		rdx
		pop		rcx
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret

Uppercase ENDP

end


