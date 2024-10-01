.386
.model flat, stdcall
option casemap: none

include C:\masm32\include\masm32.inc
include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\masm32.lib
includelib C:\masm32\lib\kernel32.lib

.data
	inp		db 40 dup(?)

.code
main PROC
	
	push	40
	push	offset inp
	call	StdIn
	xor		esi, esi

	upper:

		mov		ecx, offset inp
		cmp		byte ptr [ecx+esi], 'a'
		jl		notlower
		cmp		byte ptr [ecx+esi], 'z'
		jg		notlower
		sub		byte ptr [ecx+esi], 32
		inc		esi
		cmp		byte ptr [ecx+esi], 0
		jz		print
		jmp		upper

		notlower:
			inc		esi
			jmp		upper
			
		print:
			push	40
			push	offset inp
			call	StdOut
			

	push	0
	call	ExitProcess

main ENDP
END main

