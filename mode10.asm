model tiny
.186
.code
org 100h
_1:
jmp start

_h dw 400
_w dw 40

_stw dw 0
_fnw dw 0

start:
mov ax, 0010h
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
cmp al, 16
jne forcol

xor ax, ax
int 16h

ret

; dx - row
; cx - column
; al - color
print_pixel proc near
	push bx; shift
	push cx
	push dx
	push ax
	
	shl dx, 6
	mov bx, dx
	shr dx, 2
	add bx, dx
	mov dx, cx
	shr dx, 3
	add bx, dx
	
	and cl, 7
	mov ch, 7
	sub ch, cl
	xchg cl, ch
	mov ch, 1
	rol ch, cl

	;установка бита нужного пикселя	
	mov ax, 8
	mov dx, 3CEh
	out dx, ax
	mov al, ch
	mov dx, 3CFh
	out dx, ax

	;установка нужного цвета
	mov ax, 1
	mov dx, 3CEh
	out dx, ax
	pop ax
	push ax
	xor ax, 0Fh
	mov dx, 3CFh
	out dx, ax
	
	mov dh, byte ptr es:[bx]
	mov byte ptr es:[bx], 0FFh
	
	pop ax
	pop dx
	pop cx
	pop bx
ret
print_pixel endp


end _1