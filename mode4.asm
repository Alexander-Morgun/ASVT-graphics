model tiny
.186
.code
org 100h
_1:
jmp start

_h dw 200
_w dw 80

_stw dw 0
_fnw dw 0

start:
mov ax, 0004h
int 10h

mov bl, 0
mov bh, 1
mov ah, 0Bh
int 10h

mov ax, 0B800h
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
	cmp dx, 200
	jne fori
	
	mov cx, _fnw
	mov _stw, cx

inc al
cmp al, 4
jne forcol

xor ax, ax
int 16h

ret

; dx - row
; cx - column
; al - color
print_pixel proc near
	push bx; bx - shift
	push cx
	push dx
	mov ah, dl; color - al, row - ah
	shr dx, 1
	shl dx, 6
	mov bx, dx
	shr dx, 2
	add bx, dx
	mov dx, cx
	shr dx, 2
	add bx, dx
	and ah, 1b
	jz notAdd
		add bx, 2000h
	notAdd:
	and cl, 3
	xor cl, 3; ch = 3 - ch
	rol cl, 1
	or al, 0FCh
	mov ah, byte ptr es:[bx]
	ror ah, cl
	or ah, 3
	and ah, al
	rol ah, cl
	mov byte ptr es:[bx], ah
	and ax, 3
	pop dx
	pop cx
	pop bx
ret
print_pixel endp


end _1