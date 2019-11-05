;王永康，17341155

org 0A100h

	mov ax,cs
	mov ds,ax
	mov es,ax

	mov ax,Str
	mov bp,ax
	mov ah,0x13
	mov al,1
	mov bl,00000101b
	mov bh,0

	mov cx,Length
	mov dh,20
	mov dl,5

	int 10h

	ret

Str: db "SYSU OS! Welcome!!!!"

Length equ ($-Str)


times 510-($-$$) db 0
dw 0xaa55





