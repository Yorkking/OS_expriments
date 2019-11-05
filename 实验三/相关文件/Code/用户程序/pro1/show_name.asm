;王永康，17341155

org 0A100h

	mov ax,cs
	mov ds,ax
	mov es,ax

	mov ax,Str
	mov bp,ax
	mov ah,0x13
	mov al,1
	mov bl,10100000b
	mov bh,0

	mov cx,22
	mov dh,19
	mov dl,50

	int 10h

	ret

Str: db "Wang Yongkang,17341155"

Length equ ($-Str)


times 510-($-$$) db 0
dw 0xaa55





