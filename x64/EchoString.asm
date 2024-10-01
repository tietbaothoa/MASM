extrn GetStdHandle	: PROC
extrn ReadFile		: PROC 
extrn WriteFile		: PROC
extrn ExitProcess	: PROC

.data
	outp	db	"input: ", 0h
.data?	
	string	db	256 dup(?)
	nByte	dd	?	

.code
main PROC

	mov		rbp, rsp
	sub		rsp, 28h

	xor		rbx, rbx
	mov		rcx, -11
	call	GetStdHandle
	mov		[rsp - 10h], rax	;handle out

	mov		rcx, [rsp - 10h]
	mov		rdx, offset outp
	mov		r8, sizeof outp
	mov		r9, offset nByte
	push	rbx
	call	WriteFile

	mov		rcx, -10
	call	GetStdHandle
	mov		[rsp - 8h], rax		;handle in

	mov		rcx, [rsp - 8h]
	mov		rdx, offset string
	mov		r8, 256
	mov		r9, offset nByte
	push	rbx
	call	ReadFile

	xor		rbx, rbx
	mov		rcx, -11
	call	GetStdHandle
	mov		[rsp - 10h], rax	;handle out

	mov		rcx, [rsp - 10h]
	mov		rdx, offset string
	mov		r8, sizeof	string
	mov		r9, offset nByte
	push	rbx
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess

main ENDP
END

