.386
.model flat, stdcall
option casemap: none

include C:\masm32\include\masm32.inc
include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\masm32.lib
includelib C:\masm32\lib\kernel32.lib


.data
	num1	DB 10 DUP(?)
	num2	DB 10 DUP(?)
	num3	DB 10 DUP(?)
	sum		DD 0


.code
main PROC 
 
	push	10
	push	offset num1
	call	StdIn

	push	10
	push	offset num2
	call	StdIn

	push	offset num1
	call	atoi
	add		sum, eax

	push	offset num2
	call	atoi
	add		sum, eax

	push	sum
	push	offset num3
	call	itoa

	push	10
	push	offset num3
	call	StdOut

	push	0
	call	ExitProcess

main ENDP

atoi PROC

	push	ebp
	mov		ebp, esp
	push	ecx
	mov		ecx, [ebp+08h]
	xor		ebx, ebx
	mov		ebx, 10
	xor		eax, eax
	xor		esi, esi

	multi:
		xor		edx, edx
		mov		dl, byte ptr [ecx+esi]
		cmp		dl, 0h
		jz		break
		cmp		dl , 0Ah
		jz		break
		sub		dl, '0'
		add		eax, edx
		mul		ebx
		inc		esi
		jmp		multi

	break:
		xor		edx, edx
		div		ebx
		pop		ecx
		mov		esp, ebp
		pop		ebp
		ret		4

atoi ENDP

itoa PROC
	
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	push	edx
	mov		eax, [ebp+0Ch]
	mov		ebx, [ebp+08h]
	mov		ecx, 10
	push	69h

	divide:
		xor		edx, edx
		cmp		eax, 0
		jz		forpop
		div		ecx
		add		edx, '0'
		push	edx
		jmp		divide

	forpop:
		xor		edx, edx
		pop		edx
		cmp		dl, 69h
		jz		break
		mov		byte ptr [ebx], dl
		inc		ebx
		jmp		forpop

	break:
		mov		byte ptr[ebx], 0
		pop		edx
		pop		ecx
		pop		ebx
		pop		eax
		mov		esp, ebp
		pop		ebp
		ret		8

itoa ENDP

END main

			