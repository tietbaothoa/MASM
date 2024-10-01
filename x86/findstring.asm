.386
.model flat, stdcall
option casemap: none

include C:\masm32\include\masm32.inc
include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\masm32.lib
includelib C:\masm32\lib\kernel32.lib

.data
	str1	db 100 dup(?)
	str2	db 10 dup(?)
	index	db 5 dup(?)
	result	db 100 dup(?)
	count	dd 5 dup(?)
	nl		dd 0Ah
	len		dd 0 
	cnt		dd 0

.code
main PROC
	push	256
	push	offset str1
	call	StdIn

	push	256
	push	offset str2
	call	StdIn

	push	offset str2
	call	strlen
	mov		len, eax

 	push	offset str1
	push	offset str2
	call	findstring

	push	offset count
	call	StdOut

	push	offset nl
	call	StdOut

	push	offset result
	call	StdOut

	push	0
	call	ExitProcess

main ENDP


findstring PROC
	push	ebp
	mov		ebp, esp
	push	edx		;str1
	push	ecx		;str2
	push	eax
	mov		edx, [ebp+0Ch]
	mov		ecx, [ebp+08h]
	xor		esi, esi
	xor		edi, edi

	findstr:
		xor		eax, eax
		xor		ebx, ebx
		mov		bl, byte ptr[edx+esi]
		cmp		bl, 0h
		jz		break
		cmp		bl, byte ptr[ecx+eax]
		jz		nextchar
		inc		esi
		jmp		findstr

	nextchar:
		cmp		byte ptr[ecx+eax], 0h
		jz		increment
		mov		bl, byte ptr[edx+esi]
		cmp		bl, byte ptr[ecx+eax]
		jnz		findstr
		inc		eax
		inc		esi
		jmp		nextchar

	increment:
		inc		edi
		sub		esi, len
		push	esi
		push	offset index
		call	itoa
		add		esi, len
		push	offset index
		push	offset result
		call	addchar
		sub		esi, len
		inc		esi
		jmp		findstr

	break:
		push	edi
		push	offset count
		call	itoa
		pop		eax
		pop		ecx
		pop		edx
		mov		esp, ebp
		pop		ebp
		ret		8

findstring ENDP

addchar PROC
	push	ebp
	mov		ebp, esp
	push	edx
	push	ecx
	mov		edx, [ebp+0Ch]	;index
	mov		ecx, [ebp+08h]	;result
	push	esi
	push	edi
	xor		esi, esi

	addchr:
		mov		edi, cnt
		xor		ebx, ebx
		mov		bl, byte ptr[edx+esi]
		cmp		bl, 0h
		jz		done
		mov		byte ptr[ecx+edi], bl
		inc		esi
		inc		edi
		mov		cnt, edi
		jmp		addchr

	done:
		mov		byte ptr[ecx+edi], 20h
		inc		edi
		mov		cnt, edi
		pop		edi
		pop		esi
		pop		ecx
		pop		edx
		mov		esp, ebp
		pop		ebp
		ret		8

addchar ENDP

itoa PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	edx
	push	ecx
	push	edi
	mov		eax, [ebp+0Ch]	;edi
	mov		ebx, [ebp+08h]	;count
	mov		ecx, 10
	xor		edi, edi
	push	69h

	for_div:
		xor		edx, edx
		div		ecx
		or		edx, 30h
		push	edx
		cmp		eax, 0
		jz		pop_itoa
		jmp		for_div

	pop_itoa:
		pop		edx
		cmp		dl, 69h
		jz		break
		mov		byte ptr [ebx + edi], dl
		inc		edi
		jmp		pop_itoa

	break:
		mov		byte ptr [ebx+edi], 0
		pop		edi
		pop		ecx
		pop		edx
		pop		ebx
		pop		eax
		mov		esp, ebp
		pop		ebp
		ret		8

itoa ENDP

		
strlen PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+08h]
	push	esi
	xor		esi, esi
	xor		eax, eax
		
	next_char:
		cmp		byte ptr [ecx+esi], 0
		jz		finished
		inc		esi
		jmp		next_char

	finished:
		mov		eax, esi
		pop		esi
		pop		ebp
		ret		4
strlen ENDP

END main