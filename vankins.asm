.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096

.DATA
prompt1 BYTE "Enter number: ", 0

promptr BYTE "Rows: ", 0

promptc BYTE "Cols: ", 0


firstmatrix WORD 100 DUP(?)

secondmatrix WORD 100 DUP(?)

outputingnewline BYTE 0Dh, 0Ah, " ", 0Dh, 0Ah, 0

rowofmatrix BYTE 100  DUP(?)

bestroute BYTE 100 DUP(?)

cols WORD ?

rows WORD ?


totalnum WORD ?

temptotal WORD ?

tempcol WORD ?

temprow WORD ?

rightcompc WORD ?

downcompr WORD ?

deccol WORD ?

inputnum WORD ?

loca WORD ?

countr WORD ?

countc WORD ?

count WORD ?

tempvalue WORD ?

tempcomrightv WORD ?

tempcomdownv WORD ?



INCLUDE io.h
INCLUDE debug.h

.CODE
_start:

getElement MACRO matrix_addr, row, col, loc ;col gets changed
	;finding the element
	lea ebx, matrix_addr
	mov eax,0
	mov ax, row
	dec ax
	dec col
	mul cols
	add ax,col

	;getting the element
	add ax,ax
	add ebx,eax
	;mov loc, Word PTR [ebx]
	mov ax, [ebx]
	mov loc, ax
	ENDM
	

setElement MACRO matrix_addr, row, col, loc
	;finding the element index
	lea ebx,matrix_addr
	mov eax,0
	mov ax, row
	dec ax
	dec col
	mul cols
	add ax,col
	

	;putting the element into the array
	add ax,ax
	add ebx, eax
	;mov [ebx] Word PTR, loc
	mov ax, loc
	mov [ebx] , ax
	ENDM

;Reading in from the file
inputW promptr, rows
outputW rows
inputW promptc, cols
outputW cols
mov ax, rows
mov bx, cols
mul bx
mov totalnum, ax
mov temptotal, ax

lea ebx, firstmatrix

lea ecx, secondmatrix

inputW prompt1, inputnum
outputW inputnum
mov ax, inputnum

mov [ebx], ax

mov [ecx], ax

dec temptotal
addingElements:
	;outputW temptotal
	cmp temptotal, 0
	je outputingarray
	inputW prompt1, inputnum ;last element always zero????
	outputW inputnum
	mov ax, inputnum
	
	add ebx, 2
	mov [ebx], ax
	
	add ecx, 2
	mov [ecx], ax
	
	dec temptotal
	jmp addingElements

outputingarray:
	;lea ebx, firstmatrix
		;start:
		;cmp totalnum, 0
		;je outputing
		;outputW [ebx]
		;add ebx, 2
		;dec totalnum
		;jmp start
		
		
	;lea ebx, secondmatrix
	;startn:
		;cmp totalnum, 0
		;je outputing
		;outputW [ebx]
		;add ebx, 2
		;dec totalnum
		;jmp startn

;Outputting the 'matrix', gotten from grade example
outputing:
	mov countr, 0
	putElementsInRowOutter:
		mov countc, 1
		inc countr
		;mov count, 2
		lea ecx, rowofmatrix
		mov ax,rows
		cmp ax, countr
		jb done
		
		
		putElementsInRowInner:
				
				mov ax,cols
				cmp ax, countc
				jb rowout
				
				
				
				mov ax, countc
				mov deccol, ax
				
				getElement firstmatrix, countr, deccol, loca
				
				
				mov ax, countc
				cmp ax, 1
				jne notfirstcol
				
				
				mov ax, loca
				;outputW ax
				itoa [ecx], ax
				jmp next
				
				notfirstcol:
					add ecx, 6
					mov ax, loca
					;outputW ax
					itoa [ecx], ax
				next:
					
					inc countc
					jmp putElementsInRowInner
					
				rowout:
				
					output outputingnewline
				
					;cmp countr, 1
					;jne putElementsInRowOutter
					
					output rowofmatrix

					jmp putElementsInRowOutter
done:

output outputingnewline

;Best route calculation
mov ax, rows
inc ax
mov countr, ax

mathrow:
	;inc countr
	dec countr
	mov ax, cols
	mov countc, ax
	
	cmp countr, 0
	je outsecondarray
	
	
	
	
	mathcol:
	
		;Check if at 1,1
		cmp countr,1
		jne noroute
		cmp countc,1
		jne noroute
		
		lea ecx, bestroute
		
		
		
		noroute:
		
		mov tempvalue, 0
		
		mov ax, countr
		mov temprow, ax
		
		mov ax, countc
		mov tempcol, ax
		
		mov ax, countc
		mov rightcompc, ax

		mov ax, countr
		mov downcompr , ax
		
		nexts:
		
		
		mov ax, tempcol
		mov deccol, ax
					
		getElement firstmatrix, temprow, deccol, loca
		
		mov ax, loca
		add tempvalue, ax
		
		mov ax, cols
		cmp tempcol, ax
		jb rowcountine
		mov ax, rows
		cmp temprow, ax
		jb rowcountine
		

		mov ax, countc
		mov deccol, ax
		
		setElement secondmatrix, countr, deccol, tempvalue
		
		;dec countr
		;jmp mathcol
		dec countc
		cmp countc, 0
		je mathrow
		
		jmp mathcol
	

		rowcountine: ;errors here maybe
		
			inc rightcompc
			mov ax, cols
			cmp rightcompc, ax
			ja selectdown
			mov ax, rightcompc
			mov deccol, ax
			getElement secondmatrix, temprow, deccol, loca
			mov ax, loca
			mov tempcomrightv, ax
			
			inc downcompr
			mov ax, rows
			cmp downcompr, ax
			ja selectright
			mov ax, tempcol
			mov deccol, ax		
			getElement secondmatrix, downcompr, deccol, loca
			mov ax, loca
			mov tempcomdownv, ax
			
			mov ax, tempcomrightv
			cmp tempcomdownv, ax
			jge selectdown
			
			selectright:
			inc tempcol
			
			mov ax, tempcol
			mov rightcompc, ax
			
			mov ax, temprow
			mov downcompr, ax
			
			;Check if at 1,1
			cmp countr,1
			jne nexts
			cmp countc,1
			jne nexts
			mov ah, "r"
			mov [ecx], ah
			add ecx, 1
		
			
			
			jmp nexts
			
			
			selectdown:
			inc temprow
			
			mov ax, temprow
			mov downcompr, ax
			
			mov ax, tempcol
			mov rightcompc, ax
			
			;Check if at 1,1
			cmp countr,1
			jne nexts
			cmp countc,1
			jne nexts
			mov ah, "d"
			mov [ecx] , ah
			add ecx, 1
			
			
			
			jmp nexts
			
			
			
			
			;inc tempcol
			
			;mov ax, cols
			;cmp tempcol, ax
			;jbe nexts
			
			
			;inc temprow
			;mov tempcol, 1
			;jmp nexts
			
		
		
	

outsecondarray:
;lea ebx, secondmatrix
		;startx:
		;cmp totalnum, 0
		;je outputsecondmatrix
		;outputW [ebx]
		;add ebx, 2
		;dec totalnum
		;jmp startx

		
outputsecondmatrix:
mov countr, 0
	putElementsInRowOutternext:
		mov countc, 1
		inc countr
		;mov count, 2
		lea ecx, rowofmatrix
		mov ax,rows
		cmp ax, countr
		jb bestrouteoutput
		
		
		putElementsInRowInnernext:
				
				mov ax,cols
				cmp ax, countc
				jb rowoutnext
				
				
				
				mov ax, countc
				mov deccol, ax
				
				getElement secondmatrix, countr, deccol, loca
				
				
				mov ax, countc
				cmp ax, 1
				jne notfirstcolnext
				
				
				mov ax, loca
				;outputW ax
				itoa [ecx], ax
				jmp nextN
				
				notfirstcolnext:
					add ecx, 6
					mov ax, loca
					;outputW ax
					itoa [ecx], ax
				nextN:
					
					inc countc
					jmp putElementsInRowInnernext
					
				rowoutnext:
				
					output outputingnewline
				
					;cmp countr, 1
					;jne putElementsInRowOutter
					
					output rowofmatrix

					jmp putElementsInRowOutternext
					
bestrouteoutput:

output outputingnewline

output bestroute

PUBLIC _start   
END