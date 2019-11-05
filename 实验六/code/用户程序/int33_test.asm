
org 0A100h
start:

    mov ax,cs
    mov ds,ax
    mov es,ax

    mov ah,0
    int 21h

    mov ah,1
    int 21h

    mov ah,2
    int 21h

    mov ah,3
    int 21h


    ret