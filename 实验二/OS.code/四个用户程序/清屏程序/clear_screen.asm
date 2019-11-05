org 0A100h


	mov ax,cs 
	mov ds,ax
	mov es,ax

	mov ah,0x00 
	mov al,0x03 
	int 0x10 

	

	jmp 07c00h

times 510-($-$$) db 0
    db 0x55,0xaa

