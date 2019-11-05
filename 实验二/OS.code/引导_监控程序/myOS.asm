org  07c00h		
OffSetOfUserPrg1 equ 0A100h
Start:
	
	mov ax,cs 
	mov ds,ax
	mov es,ax
	  
	mov	bp, Message		 	 
	mov	cx, MessageLength  
	mov	ax, 1301h		 
	mov	bx, 0007h		 
      mov dh, 0		      
	mov	dl, 0			
	int	10h			 

	mov	bp, Message1		 	 
	mov	cx, MessageLength1
	mov   dh,1
	int	10h

	mov	bp, Message2		 	 
	mov	cx, MessageLength2
	mov   dh,2
	int	10h

	mov cl,3

      jmp OffSetOfUserPrg1

      jmp $ 

                     
Message:
      db 'loading...'
	
MessageLength  equ ($-Message)


      times 510-($-$$) db 0
      db 0x55,0xaa
