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
 
 
; Constantes para elegir una opción dentro del menú mediante el teclado
OP_JUGAR      EQU 0
OP_NIVEL      EQU 1
OP_INSTRUC    EQU 2
OP_CREDITOS   EQU 3
OP_SALIR      EQU 4

; Denota el color del cursor que vendría siendo la flechita que se mueve al usar las teclas y también una constante para el color del texto.
COL_CURSOR    EQU 13
COL_TEXTO     EQU 15


; Macros

; ESCRIBIR: coloca el cursor y escribe un texto de un color.
; Recibe: fila, columna, texto, color | Destruye: DH, DL, SI, BL
ESCRIBIR MACRO fila, columna, texto, color
    mov dh, fila
    mov dl, columna
    call PonerCursor
    lea si, texto
    mov bl, color
    call ImprimirTexto
ENDM

.DATA
; Paleta de colores 
include paleta.inc
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
txtTitulo     db 'DINOSAURIOS Y FOSILES$'
txtSubtitulo  db 'MASTERMIND PALEOEXPEDICION$'
txtJugar      db 'JUGAR$'
txtNivel      db 'NIVEL$'
txtInstruc    db 'INSTRUCCIONES$'
txtCreditos   db 'CREDITOS$'
txtSalir      db 'SALIR$'
txtAyuda      db 'FLECHAS: MOVER    ENTER: ELEGIR$'
txtObras      db 'EN CONSTRUCCION$'
txtTecla      db 'PRESIONE UNA TECLA$'

; Sprites para el juego
include sprites.inc

.CODE

; MÓDULO DE VIDEO

; Esta función se encarga de iniciar el programa en modo gráfico una vez que se ejecute el juego. Lo hace por medio de consultas con la función OFh. De esta forma podremos estar en el modo gráfico 13h siempre
; Recibe: nada | Devuelve: modoOriginal | Destruye: nada
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
; Recibe: modoOriginal | Devuelve: nada | Destruye: nada
RestaurarVideo PROC
    push ax

    mov ah, 00h                 
    mov al, modoOriginal        
    int 10h

    pop ax
    ret
RestaurarVideo ENDP

; Este método recibe: rectX, rectY, rectAncho, rectAlto, rectColor y es el encargado de dibujar formas en el juego.
; Devuelve: nada | Destruye: nada
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

; Este método carga los colores del juego en el VGA enviando R, G, B por los puertos.
; Recibe: paletaJuego, TOTAL_COLORES | Devuelve: nada | Destruye: nada
CargarPaleta PROC
    push ax
    push cx
    push dx
    push si
 
    mov dx, 3C8h
    mov al, 0
    out dx, al                  
 
    mov dx, 3C9h                
    lea si, paletaJuego         
    mov cx, TOTAL_COLORES * 3
CP_Siguiente:
    mov al, [si]
    out dx, al
    inc si
    loop CP_Siguiente
 
    pop si
    pop dx
    pop cx
    pop ax
    ret
CargarPaleta ENDP

; MÓDULO DE TEXTO

; Este método ayuda a posicionar el cursor en la pantalla.
; Recibe: DH = fila, DL = columna | Devuelve: nada | Destruye: nada
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
; Recibe: AL = caracter, BL = color | Devuelve: nada | Destruye: nada
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
; Recibe: SI = texto terminado en $, BL = color
; Devuelve: nada | Destruye: nada
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

; Método encargado de dibujar el fondo del menú en base a la paleta de colores, utiliza también el MACRO ESCRIBIR para procesar todo el texto del juego evitando la redundancia.
; Recibe: nada | Devuelve: nada | Destruye: nada
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
    mov rectColor, CIELO_1
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
    mov rectColor, TIERRA
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
    ESCRIBIR 3, 12, txtTitulo, AMARILLO
    ESCRIBIR 4, 8, txtSubtitulo, GRIS
    ESCRIBIR 22, 4, txtAyuda, BLANCO
 
    pop si
    pop dx
    pop cx
    pop bx
    ret
DibujarFondoMenu ENDP


; Recibe: SI = texto, DH = fila, CL = numero de opcion
; Devuelve: nada | Destruye: nada
DibujarOpcion PROC
    push ax
    push bx
    push dx
 
    cmp cl, opcionActual
    jne DO_Normal
 
    mov al, '>'
    mov bl, AMARILLO
    jmp DO_Dibujar
 
DO_Normal:
    mov al, ' '
    mov bl, GRIS
 
DO_Dibujar:
    mov dl, COL_CURSOR
    call PonerCursor
    call ImprimirCaracter
 
    mov dl, COL_TEXTO
    call PonerCursor
    call ImprimirTexto
 
    pop dx
    pop bx
    pop ax
    ret
DibujarOpcion ENDP


; Recibe: opcionActual | Devuelve: nada | Destruye: nada
DibujarOpciones PROC
    push cx
    push dx
    push si
 
    lea si, txtJugar
    mov dh, 8
    mov cl, OP_JUGAR
    call DibujarOpcion
 
    lea si, txtNivel
    mov dh, 10
    mov cl, OP_NIVEL
    call DibujarOpcion
 
    lea si, txtInstruc
    mov dh, 12
    mov cl, OP_INSTRUC
    call DibujarOpcion
 
    lea si, txtCreditos
    mov dh, 14
    mov cl, OP_CREDITOS
    call DibujarOpcion
 
    lea si, txtSalir
    mov dh, 16
    mov cl, OP_SALIR
    call DibujarOpcion
 
    pop si
    pop dx
    pop cx
    ret
DibujarOpciones ENDP

; Recibe: nada | Devuelve: AL = opcion elegida | Destruye: AX
Menu PROC
    call DibujarFondoMenu
 
M_Leer:
    call DibujarOpciones
 
    mov ah, 00h
    int 16h
 
    cmp al, TECLA_ENTER
    je M_Elegir
    cmp al, TECLA_ESC
    je M_Escape
    cmp ah, TECLA_ARRIBA
    je M_Subir
    cmp ah, TECLA_ABAJO
    je M_Bajar
    jmp M_Leer
 
M_Subir:
    cmp opcionActual, OP_JUGAR
    jne M_Restar
    mov opcionActual, OP_SALIR
    jmp M_Leer
M_Restar:
    dec opcionActual
    jmp M_Leer
 
M_Bajar:
    cmp opcionActual, OP_SALIR
    jne M_Sumar
    mov opcionActual, OP_JUGAR
    jmp M_Leer
M_Sumar:
    inc opcionActual
    jmp M_Leer
 
M_Escape:
    mov opcionActual, OP_SALIR
 
M_Elegir:
    mov al, opcionActual
    ret
Menu ENDP


; Recibe: nada | Devuelve: nada | Destruye: nada
PantallaPendiente PROC
    push ax
    push bx
    push dx
    push si
 
    mov rectX, 0
    mov rectY, 0
    mov rectAncho, 320
    mov rectAlto, 200
    mov rectColor, NEGRO
    call LlenarRect
 
    ESCRIBIR 11, 12, txtObras, AMARILLO
    ESCRIBIR 13, 11, txtTecla, GRIS
 
    mov ah, 00h
    int 16h
 
    pop si
    pop dx
    pop bx
    pop ax
    ret
PantallaPendiente ENDP

; Función principal que vendría siendo el MAIN, llama a los demás métodos que ayudan a iniciar el juego, de momento solo se muestra una pantalla en color azul, esto solo es el esqueleto principal del programa.
Inicio:
    mov ax, @data
    mov ds, ax

    call IniciarVideo
    call CargarPaleta
CicloPrincipal:
    call Menu
    cmp al, OP_SALIR
    je Salir
    call PantallaPendiente
    jmp CicloPrincipal
 
Salir:    
    call RestaurarVideo   

    mov ah, 04Ch
    mov al, 0             
    int 21h
END Inicio                     