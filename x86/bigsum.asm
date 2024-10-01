.386
.model flat, stdcall
option casemap: none

include C:\masm32\include\masm32.inc
include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\masm32.lib
includelib C:\masm32\lib\kernel32.lib

.data	
	cnt1	db	100 dup (?)
	cnt2	dd	0
	f0		dd	0
	f1		dd	1

