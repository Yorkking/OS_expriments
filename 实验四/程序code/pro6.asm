;;wang yongkang,haha
org 09000h
start:
	mov ax,cs	
	mov ds,ax
	mov es,ax
		
  int 33

	int 34

	int 35

	int 36
	
	ret
	jmp $
	
times 510-($-$$) db 0
dw 0xaa55		
