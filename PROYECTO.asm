.MODEL SMALL            
.STACK 200h             

; Constantes para las dimensiones de la pantalla y el segmento donde empieza al memoria de video. Las dimensiones corresponden al tamaño del DOS Box.
PANTALLA     EQU 0A000h 
ANCHO_PANT   EQU 320
ALTO_PANT    EQU 200

; Constantes para el manejo de las flechas del teclado
TECLA_ARRIBA  EQU 48h
TECLA_ABAJO   EQU 50h
TECLA_ENTER   EQU 0Dh
TECLA_ESC     EQU 1Bh
 
; Colores iniciales del menú y opciones
NEGRO         EQU 0
CAFE          EQU 6
GRIS          EQU 7
AMARILLO      EQU 14
BLANCO        EQU 15
ROJO_CIELO    EQU 40
DORADO        EQU 44
 
; Constantes para elegir una opción dentro del menú mediante el teclado
OP_JUGAR      EQU 0
OP_NIVEL      EQU 1
OP_INSTRUC    EQU 2
OP_CREDITOS   EQU 3
OP_SALIR      EQU 4

; Denota el color del cursor que vendría siendo la flechita que se mueve al usar las teclas y también una constante para el color del texto.
COL_CURSOR    EQU 13
COL_TEXTO     EQU 15

.DATA
; Variable que recupera el modo de pantalla
modoOriginal db ?  
; Variable global para manejar el menú de opciones
opcionActual db 0  

; Coordenadas para manejar la ubicación de los objetos en el menú
rectX         dw ?
rectY         dw ?
rectAncho     dw ?
rectAlto      dw ?
rectColor     db ?
 
; Textos del menu
txtTitulo     db 'VIVOS Y FOSILES$'
txtSubtitulo  db 'MASTERMIND PALEOEXPEDICION$'
txtJugar      db 'JUGAR$'
txtNivel      db 'NIVEL$'
txtInstruc    db 'INSTRUCCIONES$'
txtCreditos   db 'CREDITOS$'
txtSalir      db 'SALIR$'
txtAyuda      db 'FLECHAS: MOVER    ENTER: ELEGIR$'
txtObras      db 'EN CONSTRUCCION$'
txtTecla      db 'PRESIONE UNA TECLA$'

.CODE

; MÓDULO DE VIDEO

; Esta función se encarga de iniciar el programa en modo gráfico una vez que se ejecute el juego. Lo hace por medio de consultas con la función OFh. De esta forma podremos estar en el modo gráfico 13h siempre
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

; Esta función se encarga de restaurar los modos anteriores para mantener el dinamismo del juego y no se pierda nada. La variable 'modoOriginal' es la encargada de reservar el modo anterior en memoria para que pueda ser recuperado
RestaurarVideo PROC
    push ax

    mov ah, 00h                 
    mov al, modoOriginal        
    int 10h

    pop ax
    ret
RestaurarVideo ENDP


LlenarRect PROC
    push ax
    push bx
    push cx
    push dx
    push di
    push es
 
    mov ax, PANTALLA
    mov es, ax
 
    mov ax, rectY
    mov bx, ANCHO_PANT
    mul bx
    add ax, rectX
    mov di, ax
 
    mov bx, ANCHO_PANT
    sub bx, rectAncho
 
    mov al, rectColor
    mov dx, rectAlto
 
LR_Fila:
    mov cx, rectAncho
LR_Pixel:
    mov es:[di], al
    inc di
    loop LR_Pixel
 
    add di, bx
    dec dx
    jnz LR_Fila
 
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
LlenarRect ENDP

; MÓDULO DE TEXTO

; Este método ayuda a posicionar el cursor en la pantalla.
PonerCursor PROC
    push ax
    push bx
 
    mov ah, 02h
    mov bh, 0
    int 10h
 
    pop bx
    pop ax
    ret
PonerCursor ENDP

; Imprime carácter a carácter.
ImprimirCaracter PROC
    push ax
    push bx
 
    mov ah, 0Eh
    mov bh, 0
    int 10h
 
    pop bx
    pop ax
    ret
ImprimirCaracter ENDP

; Esta función imprime textos completos del juego, esta depende del método que imprime caracteres de forma individual.
ImprimirTexto PROC
    push ax
    push si
 
IT_Siguiente:
    mov al, [si]
    cmp al, '$'
    je IT_Fin
    call ImprimirCaracter
    inc si
    jmp IT_Siguiente
 
IT_Fin:
    pop si
    pop ax
    ret
ImprimirTexto ENDP

; MÓDULO DE MENU

DibujarFondoMenu PROC
    push bx
    push cx
    push dx
    push si
 
    ; Cielo
    mov rectX, 0
    mov rectY, 0
    mov rectAncho, 320
    mov rectAlto, 32
    mov rectColor, ROJO_CIELO
    mov cx, 5
DFM_Franja:
    call LlenarRect
    add rectY, 32
    inc rectColor
    loop DFM_Franja
 
    ; Suelo
    mov rectX, 0
    mov rectY, 160
    mov rectAncho, 320
    mov rectAlto, 40
    mov rectColor, CAFE
    call LlenarRect
 
    ; Franja del titulo
    mov rectX, 0
    mov rectY, 16
    mov rectAncho, 320
    mov rectAlto, 32
    mov rectColor, NEGRO
    call LlenarRect
 
    ; Recuadro de opciones
    mov rectX, 86
    mov rectY, 54
    mov rectAncho, 148
    mov rectAlto, 100
    mov rectColor, DORADO
    call LlenarRect
 
    mov rectX, 88
    mov rectY, 56
    mov rectAncho, 144
    mov rectAlto, 96
    mov rectColor, NEGRO
    call LlenarRect
 
    ; Franja de ayuda
    mov rectX, 0
    mov rectY, 172
    mov rectAncho, 320
    mov rectAlto, 16
    mov rectColor, NEGRO
    call LlenarRect
 
    ; Textos
    mov dh, 3
    mov dl, 12
    call PonerCursor
    lea si, txtTitulo
    mov bl, AMARILLO
    call ImprimirTexto
 
    mov dh, 4
    mov dl, 8
    call PonerCursor
    lea si, txtSubtitulo
    mov bl, GRIS
    call ImprimirTexto
 
    mov dh, 22
    mov dl, 4
    call PonerCursor
    lea si, txtAyuda
    mov bl, BLANCO
    call ImprimirTexto
 
    pop si
    pop dx
    pop cx
    pop bx
    ret
DibujarFondoMenu ENDP


; Este método se encuentra a la espera del uso de una tecla, mantiene el control mediante el uso de la interrupción 16h y sus funciones internas
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
    call DibujarFondoMenu

    mov ah, 00h
    int 16h

    call RestaurarVideo         
    mov ah, 04Ch

    mov al, 0             
    int 21h
END Inicio                     