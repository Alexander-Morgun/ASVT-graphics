model tiny
.186
.code
org 100h
_1:
jmp start

_h dw 200
_w dw 1
_stw dw 24
_fnw dw 0

start:
mov ax, 0013h
int 10h
mov ax, 0A000h
push ax
pop es

mov al, 0; color
forcol:
	mov dx, 0h

	mov cx, _stw
	add cx, _w
	mov _fnw, cx
	
	fori:
		mov cx, _stw
		forj:
			call print_pixel	
		inc cx
		cmp cx, _fnw
		jne forj
	inc dx
	cmp dx, _h
	jne fori
	
	mov cx, _fnw
	mov _stw, cx

inc al
jnz forcol

xor ax, ax
int 16h

ret

; dx - row
; cx - column
; al - color
print_pixel proc near
	push bx; shift
	push dx
	shl dx, 8
	mov bx, dx
	shr dx, 2
	add bx, dx
	add bx, cx
	mov byte ptr es:[bx], al	
	pop dx
	pop bx
ret
print_pixel endp



end _1