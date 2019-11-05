org  07c00h		
OffSetOfUserPrg1 equ 5000h
OffSetOfUserPrg2 equ 3000h
OffSetOfUserPrg3 equ 3000h
OffSetOfUserPrg4 equ 0A100h


Start:
	
	mov ax,cs 
	mov ds,ax
	mov es,ax
	  
	mov	bp, Message		 	 
	mov	cx, MessageLength  
	mov	ax, 1301h		 
	mov	bx, 0007h		 
      mov   dh, 0		      
	mov	dl, 0			
	int	10h			 

      ;读文件信息进2扇区
                               ;设置段地址（不能直接mov es,段地址）
       

      ;读取原语进11扇区
     ; mov ax,cs                ;段地址 ; 存放数据的内存基地址
      ;mov es,ax                ;设置段地址（不能直接mov es,段地址）
     ; mov bx, OffSetOfUserPrg3  ;偏移地址; 存放数据的内存偏移地址
     ; mov ah,2                 ; 功能号
     ; mov al,1                 ;扇区数
     ; mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
     ; mov dh,0                 ;磁头号 ; 起始编号为0
     ; mov ch,0                 ;柱面号 ; 起始编号为0
     ; mov cl,11               ;起始扇区号 ; 起始编号为1
     ; int 13H ;    


	mov ax,cs                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov bx, OffSetOfUserPrg1  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,6                ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,3                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域中
      jmp OffSetOfUserPrg1


      jmp $ 

                     
Message:
      db 'loading...'
	
MessageLength  equ ($-Message)


      times 510-($-$$) db 0
      db 0x55,0xaa
