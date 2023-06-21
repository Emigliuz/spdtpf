.8086
.model small
.stack 100h
.data
	cartel db "ingrese un texto de hasta 5 caracteres", 0dh,0ah, 24h
	WORDLE db "WORDLE",24h
	PAGCERO db "PRUEBAAAAAAAAAAAAA",24h
	PALABRA db 5
	salto db 0dh,0ah, 24h
	PALABRA_1_LETRA_1 db "Hola",24h
	archivo db "palabras.txt", "$"
.code
	main proc
		mov ax, @data
		mov ds, ax

			mov ah, 00h 		;<-------------SELECT VIDEO MODE INT 10h
			MOV al, 0dh			;0Dh FUNCA 320x200 16 color graphics
								;10h FUNCAN BIEN TB 
								;02h/03h/04h/05h Funciona el texto resaltado pero no deja cambiar el fondo 
								;Los que funciona pero se ven horribles son: 00h/01h/ 
			int 10h      		;INTERRUPCION 10h VIDEO

			mov ah, 0Bh			;configurar color de fondo
			mov bh, 00h 		;Pagina 0
			mov bl, 01h 		;fondo color azul marino 01h
			int 10h			    ;INTERRUPCION 10h VIDEO

			;mov cx, 9           ;cantidad de veces que quiero imprimir el caracter
			;mov si, 8			;cuantas veces quiero recorrer el loop
			;mov ah, 09h 		;<-------------Write character and attribute at cursor position INT 10h
			;mov bh, 00h 		;Pagina 0
			;mov bl, 36h 		;COLOR
			;pg0cycle:
			;	mov al, PAGCERO[si]	;Paso la letra al "al" para que el int 10h lo imprima
			;	int 10h
			;	dec si
			;loop pg0cycle

			;mov ah, 08
			;int 21h


			;mov al, 20h
			;mov ah, 09h 		;<-------------Write character and attribute at cursor position INT 10h
			;mov bh, 00h 		;Pagina 0
			;mov bl, 24h 		;COLOR
			;int 10h
			
			mov ah, 0Bh			;configurar color de fondo
			mov bh, 00h 		;Pagina 0
			mov bl, 01h 		;fondo color azul marino 01h
			int 10h			    ;INTERRUPCION 10h VIDEO


			;CAMBIO EL LUGAR DEL CURSOR
			mov dh, 02h 		;Fila del cursor
			mov dl, 61h 		;columna del cursor
			call fcursorsetpositionpg0

			;IMPRIMO EL TITULO DE WORDLE
			call fprintwordletitle

			;CAMBIO EL LUGAR DEL CURSOR
			mov dh, 06h 		;Fila del cursor
			mov dl, 60h 		;columna del cursor
			call fcursorsetpositionpg0

			call palabra_cajadecarga




		mov ax, 4c00h
		int 21h
	main endp

;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;FUNCIONES
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		

	;FUNCION INT 10h --> al=20h PARA CAMBIAR EL LUGAR DEL CURSOR
	;(antes de llamarla hay que ponerle a dh=FILA.h y a dl=COLUMNA.h)
	fcursorsetposition    proc
		mov ah, 02h 				;<-------------Set cursor position INT 10h
		int 10h 					;Interrupcion 10h video
		ret
	fcursorsetposition    endp
	fcursorsetpositionpg0 proc
		mov bh, 00h 				;Pagina 0
		call fcursorsetposition
	ret 
	fcursorsetpositionpg0 endp
	fcursorsetpositionpg1 proc
		mov bh, 01h 				;Pagina 0
		call fcursorsetposition
	ret 
	fcursorsetpositionpg1 endp
	fprintwordletitle     proc
		;INICIO (Imprimir el titulo)
			mov cx, 6           ;cantidad de veces que quiero imprimir el caracter
			mov si, 5			;cuantas veces quiero recorrer el loop
			mov ah, 09h 		;<-------------Write character and attribute at cursor position INT 10h
			mov bh, 00h 		;Pagina 0
			mov bl, 36h 		;COLOR
			wordletitlewordcycle:
				mov al, wordle[si]	;Paso la letra al "al" para que el int 10h lo imprima
				int 10h
				dec si
			loop wordletitlewordcycle
		;FIN
	ret
	fprintwordletitle	  endp

	palabra_cajadecarga proc

			;CARGA SIN ECHO E IMPRESION POR INT DE VIDEO (esta hecho de esta manera asi despues se puede mayusculizar, 
			;identificar si es entre la a-z o A-Z y no sea otro caracter y saber si es enter o DEL)
			mov si, 0
			carga_palabra:
				mov ah, 08h					;>
				int 21h						;escanea sin echo en pantalla
				cmp si, 5
				je ENTER_confirmarpalabra
				cmp al, 8					;compara si la letra leida fue el backspace (la tecla DEL)
				je DEL_volveratras			;Si es DEL salta un espacio atras para reescribir la letra			
				cmp si, 06h
				je carga_palabra
				mov PALABRA[si], al
				mov cx, 1
				mov ah, 09h 				;<-------------Write character and attribute at cursor position INT 10h
				mov bh, 00h 				;Pagina 0
				mov bl, 07h 				;Color
				int 10h					    ;
				inc si
				cmp si, 6
				je finCarga_palabra
				add dl, 02h					;columna del cursor
				call fcursorsetpositionpg0
				jmp carga_palabra
			DEL_volveratras:
				cmp si, 0
				je carga_palabra
				mov ah, 09
				mov al, 0FFh  				;Imprimo caracter invisible para hacer desaparecer
				int 10h				     	;
				sub dl, 02h
				call fcursorsetpositionpg0
				mov ah, 09
				mov al, 0FFh  				;Imprimo caracter invisible para hacer desaparecer
				int 10h				     	;
				dec si
				jmp carga_palabra
			ENTER_confirmarpalabra:
				cmp al, 0Dh
				je finCarga_palabra
				dec si
				jmp carga_palabra

			finCarga_palabra:	

	ret
	palabra_cajadecarga endp

	

	end