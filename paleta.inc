; paleta.inc - GENERADO por herramientas/convertir_sprites.py
; No editar a mano: cambiar los colores y volver a ejecutar.

; Indices de los colores de la interfaz
NEGRO          EQU 0
BLANCO         EQU 1
GRIS           EQU 2
AMARILLO       EQU 3
DORADO         EQU 4
CIELO_1        EQU 5
CIELO_2        EQU 6
CIELO_3        EQU 7
CIELO_4        EQU 8
CIELO_5        EQU 9
TIERRA_OSCURA  EQU 10
TIERRA         EQU 11
VERDE_SELVA    EQU 12
ROJO           EQU 13
VERDE_VIVO     EQU 14
HUESO          EQU 15
VOLCAN         EQU 16
LAVA           EQU 17

TOTAL_COLORES  EQU 92

; Un renglon por color: R, G, B (0-63)
paletaJuego LABEL BYTE
    db  0,  0,  0    ;   0 NEGRO / transparente
    db 63, 63, 63    ;   1 BLANCO
    db 44, 42, 38    ;   2 GRIS
    db 63, 54, 18    ;   3 AMARILLO
    db 49, 35, 11    ;   4 DORADO
    db 13,  7, 17    ;   5 CIELO_1
    db 26,  9, 18    ;   6 CIELO_2
    db 41, 14, 13    ;   7 CIELO_3
    db 54, 26, 10    ;   8 CIELO_4
    db 61, 41, 16    ;   9 CIELO_5
    db 21, 13,  7    ;  10 TIERRA_OSCURA
    db 34, 23, 13    ;  11 TIERRA
    db 10, 22, 10    ;  12 VERDE_SELVA
    db 47,  9,  7    ;  13 ROJO
    db 22, 52, 16    ;  14 VERDE_VIVO
    db 58, 55, 46    ;  15 HUESO
    db 15, 11, 11    ;  16 VOLCAN
    db 60, 22,  5    ;  17 LAVA
    db  0,  0,  0    ;  18 libre
    db  0,  0,  0    ;  19 libre
    db  0,  0,  0    ;  20 libre
    db  0,  0,  0    ;  21 libre
    db  0,  0,  0    ;  22 libre
    db  0,  0,  0    ;  23 libre
    db  0,  0,  0    ;  24 libre
    db  0,  0,  0    ;  25 libre
    db  0,  0,  0    ;  26 libre
    db  0,  0,  0    ;  27 libre
    db  0,  0,  0    ;  28 libre
    db  0,  0,  0    ;  29 libre
    db  0,  0,  0    ;  30 libre
    db  0,  0,  0    ;  31 libre
    db 29, 16, 34    ;  32 sprites
    db 52, 51, 24    ;  33 sprites
    db 51, 31, 58    ;  34 sprites
    db 63, 63, 63    ;  35 sprites
    db 12, 15, 14    ;  36 sprites
    db 18, 26, 12    ;  37 sprites
    db 43, 12, 12    ;  38 sprites
    db  0,  0,  0    ;  39 sprites
    db 22, 21, 20    ;  40 sprites
    db 18, 26, 11    ;  41 sprites
    db 20, 18,  9    ;  42 sprites
    db  5,  5,  5    ;  43 sprites
    db 18, 17, 17    ;  44 sprites
    db 25, 14, 12    ;  45 sprites
    db  8,  8, 13    ;  46 sprites
    db 34, 15, 11    ;  47 sprites
    db 34,  7,  2    ;  48 sprites
    db 33, 31, 33    ;  49 sprites
    db 24, 38, 63    ;  50 sprites
    db 15, 15, 29    ;  51 sprites
    db 57, 54, 16    ;  52 sprites
    db 41, 37,  9    ;  53 sprites
    db  9,  6,  0    ;  54 sprites
    db 17, 10, 15    ;  55 sprites
    db 23,  2,  2    ;  56 sprites
    db  3,  3,  3    ;  57 sprites
    db 47, 40, 22    ;  58 sprites
    db 21, 17,  7    ;  59 sprites
    db 20, 14,  2    ;  60 sprites
    db 35, 37, 18    ;  61 sprites
    db 30, 32, 10    ;  62 sprites
    db 51, 49, 13    ;  63 sprites
    db 34, 27, 12    ;  64 sprites
    db 40, 31, 11    ;  65 sprites
    db 52, 51, 21    ;  66 sprites
    db 11,  7,  7    ;  67 sprites
    db 52, 51, 39    ;  68 sprites
    db 56, 55, 38    ;  69 sprites
    db 59, 58, 39    ;  70 sprites
    db 45, 43, 22    ;  71 sprites
    db 51, 49, 26    ;  72 sprites
    db 42, 40, 27    ;  73 sprites
    db 11, 27,  0    ;  74 sprites
    db  8, 16,  3    ;  75 sprites
    db  5,  4,  4    ;  76 sprites
    db 24, 38, 12    ;  77 sprites
    db 62, 60, 13    ;  78 sprites
    db 60,  1,  1    ;  79 sprites
    db  6, 39, 46    ;  80 sprites
    db 23, 51, 57    ;  81 sprites
    db 56, 24,  2    ;  82 sprites
    db 62, 30,  7    ;  83 sprites
    db 45, 20,  4    ;  84 sprites
    db 10, 10, 10    ;  85 sprites
    db 20, 20, 21    ;  86 sprites
    db 18, 18, 21    ;  87 sprites
    db 55, 28,  9    ;  88 sprites
    db 46,  1,  1    ;  89 sprites
    db 47, 46, 23    ;  90 sprites
    db 16, 35,  3    ;  91 sprites
