.386
.model flat, stdcall
option casemap: none

include C:\masm32\include\masm32.inc
include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\masm32.lib
includelib C:\masm32\lib\kernel32.lib

.data
	inp		DB	256 dup(?)
	outp	DB	256 dup(?)
	len		DD	0
.code
main PROC
	push	256
	push	offset inp
	call	StdIn

	push	offset inp
	push	offset outp
	call	reversestring

	push	offset outp
	call	StdOut

	push	0
	call	ExitProcess

main ENDP

reversestring PROC
	push	ebp
	mov		ebp, esp
	push	edx		;inp
	push	ecx		;outp
	mov		edx, [ebp+0Ch]
	mov		ecx, [ebp+08h]
	xor		esi, esi

	reverse:
		xor		ebx, ebx
		mov		bl, byte ptr[edx+esi]
		cmp		bl, 0h
		jz		popstr
		push	ebx
		inc		esi
		jmp		reverse

	popstr:
		xor		ebx, ebx
		pop		ebx
		mov		byte ptr[ecx], bl
		inc		ecx
		inc		ebx
		dec		esi
		cmp		esi, 0
		jz		break
		jmp		popstr

	break:
		pop		ecx
		pop		edx
		mov		esp, ebp
		pop		ebp
		ret		8		

reversestring ENDP

END main