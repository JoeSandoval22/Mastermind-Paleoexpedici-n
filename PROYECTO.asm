.MODEL SMALL            
.STACK 200h             

; Constantes para las dimensiones de la pantalla y el segmento donde empieza al memoria de video. Las dimensiones corresponden al tamaño del DOS Box.
VRAM_SEG     EQU 0A000h 
ANCHO_PANT   EQU 320
ALTO_PANT    EQU 200

.DATA
modoOriginal db ?       

.CODE

; Esta función se encarga de iniciar el programa en modo gráfico una vez que se ejecute el juego. Lo hace por medio de consultas con la función OFh. De esta forma podremos estar en el modo gráfico 13h siempre.
IniciarVideo PROC
    push ax
    push bx                     

    mov ah, 0Fh                 
    int 10h                     
    mov modoOriginal, al        

    mov ax, 0013h               
    int 10h

    pop bx
    pop ax
    ret
IniciarVideo ENDP

; Esta función se encarga de restaurar los modos anteriores para mantener el dinamismo del juego y no se pierda nada. La variable 'modoOriginal' es la encargada de reservar el modo anterior en memoria para que pueda ser recuperado.
RestaurarVideo PROC
    push ax

    mov ah, 00h                 
    mov al, modoOriginal        
    int 10h

    pop ax
    ret
RestaurarVideo ENDP


LimpiarPantalla PROC
    push ax
    push cx
    push di
    push es

    mov ah, al                 
    mov cx, VRAM_SEG
    mov es, cx                 
    xor di, di                  
    mov cx, (ANCHO_PANT*ALTO_PANT)/2  
    cld                         
    rep stosw                   

    pop es
    pop di
    pop cx
    pop ax
    ret
LimpiarPantalla ENDP

; Este método se encuentra a la espera del uso de una tecla, mantiene el control mediante el uso de la interrupción 16h y sus funciones internas.
EsperarTecla PROC
    mov ah, 00h                 
    int 16h
    ret
EsperarTecla ENDP

; Función principal que vendría siendo el MAIN, llama a los demás métodos que ayudan a iniciar el juego, de momento solo se muestra una pantalla en color azul, esto solo es el esqueleto principal del programa.
Inicio:
    mov ax, @data
    mov ds, ax                  

    call IniciarVideo

    mov al, 1                   
    call LimpiarPantalla

    call EsperarTecla

    call RestaurarVideo         

    mov ax, 4C00h              
    int 21h

END Inicio                     