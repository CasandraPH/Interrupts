#include "p16F628a.inc"    ;incluir librerias relacionadas con el dispositivo
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF 
 ; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program
    
INT_VECT CODE  0x004  ; interrupt vector
	;ISR code 

	DECFSZ CNT 
	GOTO $+7
	MOVLW B'00000001'
	XORWF PORTB, F
	MOVLW D'4' ; 50mS * value  ;8-->iguales 50ms   31-->doble 2s   4-->mitad
	MOVWF CNT
		    ; 256uS * 195 =~ 50mS
		    ; 255 - 195 = 60
	MOVLW D'190' ; preload value 270
	MOVWF TMR0
	bcf INTCON, T0IF ; clr TMR0 interrupt flag
	retfie  ; return from interrupt
   
MAIN_PROG CODE                      ; let linker place main program

CNT equ 0x20 
i equ 0x30
j equ 0x31
k equ 0x32
 
START
 
			; setup registers		
			; setp TMR0 operation
			; internal clock, pos edge, prescale 256
    
    MOVLW 0x07		;Apagar comparadores
    MOVWF CMCON
    BSF	STATUS, RP0
    MOVLW 0x00
    MOVWF TRISA
    MOVWF TRISB
    movlw b'10000111' 
    movwf OPTION_REG
    BCF	STATUS, RP0 ; BANK 0	

			; setup TMR0 INT
    bsf INTCON, GIE	; enable global interrupt
    bsf INTCON, T0IE	; enable TMR0 interrupt
    bcf INTCON, T0IF	; clr TMR0 interrupt flag to turn on, 
			; must be cleared after interrupt
			; 256uS * 195 =~ 50mS
			; 255 - 195 = 60
    MOVLW D'60'		; preload value
    MOVWF TMR0
    MOVLW D'10'		; 50mS * 20 = 1 Sec.
    MOVWF CNT
    CLRF PORTA
    CLRF PORTB

    
inicio:	
     
    bcf PORTB,7  ;poner el puerto B7 (bit 7 del puerto B) en 0
    call tiempo ;llamar a la rutina de tiempo

    nop	       ;NOPs de relleno (ajuste de tiempo)
    nop
    nop
    nop
    bsf PORTB,7  ;poner el puerto B0 (bit 0 del puerto B) en 1
    call tiempo ;llamar a la rutina de tiempo

    nop          ;NOPs de relleno (ajuste de tiempo)
    nop
    
    goto inicio  ;regresar y repetir
  
;rutina de tiempo
tiempo:  
    nop	      ;NOPs de relleno (ajuste de tiempo)
    nop
    nop
    nop
    movlw d'54' ;establecer valor de la variable i
    movwf i
iloop:
    nop	      ;NOPs de relleno (ajuste de tiempo)
    nop
    nop
    nop
    nop
    movlw d'50' ;establecer valor de la variable j
    movwf j
jloop:	
    nop         ;NOPs de relleno (ajuste de tiempo)
    movlw d'60' ;establecer valor de la variable k
    movwf k
kloop:	
    decfsz k,f  
    goto kloop
    decfsz j,f
    goto jloop
    decfsz i,f
    goto iloop
    return	;salir de la rutina de tiempo y regresar al 
			;valor de contador de programa
    

    END