 #include "p16F628a.inc"    
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF    

 
RES_VECT  CODE    0x0000; processor reset vector
    GOTO    START                  

INT_VECT  CODE	  0x0004
  
   ; el código de la interrupción
    GOTO ISR 
    
    ; TODO ADD INTERRUPTS HERE IF USED
MAIN_PROG CODE                      
i equ 0x30
j equ 0x31
k equ 0x32
a equ 0x33 
n equ 0x34
 
START
    MOVLW b'10010000'  ;HABILITAR INTERRUPCIÓN EXTERNA
    MOVWF INTCON 
    MOVLW 0x07 ;Apagar comparadores
    MOVWF CMCON
    BCF STATUS, RP1 ;Cambiar al banco 1
    BSF STATUS, RP0 
    MOVLW b'00000000' ;Establecer puerto B como salida (los 8 bits del puerto)
    MOVWF TRISA
    MOVLW b'00000001' ;Establecer puerto B como salida (los 8 bits del puerto)
    MOVWF TRISB 

    BCF STATUS, RP0 ;Regresar al banco 0
    NOP
  
INICIO:
     MOVLW D'0'
     MOVWF PORTA
CICLO:
    bsf PORTB,7  ;poner el puerto B0 (bit 0 del puerto B) en 0
    call tiempo ;llamar a la rutina de tiempo
    bcf PORTB,7  ;poner el puerto B0 (bit 0 del puerto B) en 1
    call tiempo ;llamar a la rutina de tiempo
    goto CICLO  ;regresar y repetir

ISR: 
    BCF INTCON, GIE ;Disable all interrupts inside interrupt service routine
    ;... Código de la interrupción
    INCF PORTA,1
    MOVLW D'10'
    XORWF PORTA,w
    BTFSS STATUS,Z
    GOTO $+2
    CLRF PORTA
    BCF INTCON,INTF ;Clear external interrupt flag bit
    BSF INTCON, GIE ;Enable all interrupts on exit
    RETFIE		

;rutina de tiempo
tiempo:  
    nop	      ;NOPs de relleno (ajuste de tiempo)
    nop
    nop
    nop
    movlw d'108' ;establecer valor de la variable i
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
    movlw d'4' ;establecer valor de la variable k
    movwf a
    decfsz a,f  
    goto $-1 
    return	;salir de la rutina de tiempo y regresar al 
		;valor de contador de programa 58
    END