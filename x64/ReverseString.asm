extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data
	outp1	db	"String: "
	outp2	db	"String after reverse: "

.data?
	String	db 100 dup(?)
	nByte	dd	?
.code
main PROC

	mov		rbp, rsp
	sub		rsp, 38h
	xor		rbx, rbx

	mov		rcx, -11
	call	GetStdHandle
	mov		[rbp - 8h], rax

	mov		rcx, -10
	call	GetStdHandle
	mov		[rbp - 10h], rax

	mov		rcx, [rbp - 8h]
	mov		rdx, offset outp1
	mov		r8, sizeof outp1
	mov		r9, offset nByte
	mov		[rsp - 20h], rbx
	call	WriteFile

	mov		rcx, [rbp - 10h]
	mov		rdx, offset	String
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp - 20h], rbx
	call	ReadFile

	xor		r15, r15
	mov		r10, offset String

	mov		rsi, offset String
	call	Reverstring

	mov		rcx, [rbp - 08h]
	mov		rdx, offset String
	mov		r8, sizeof String
	mov		r9, offset nByte
	mov		[rsp - 20h], rbx
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess
	

main ENDP

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

end 
