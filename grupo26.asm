; *********************************************************************
; * PROJETO IAC
; * 
; * Grupo: N�mero 26
; *        Constituido por:
; *        -               N�IST:
; *        -               N�IST:
; *        -               N�IST:
; *
; *
; *********************************************************************


; Tarefas a fazer:
; - no incremento, e se chegar ao maximo
; - comentarios
;


; **********************************************************************
; * Constantes
; **********************************************************************


ULTIMA_LINHA EQU 8
CONST_DEC    EQU 4
CONST_INC    EQU 5
DISPLAYS     EQU 0A000H  ; endere�o dos displays de 7 segmentos (perif�rico POUT-1)
TEC_LIN      EQU 0C000H  ; endere�o das linhas do teclado (perif�rico POUT-2)
TEC_COL      EQU 0E000H  ; endere�o das colunas do teclado (perif�rico PIN)
LINHA        EQU 1       ; linha inicial a testar
MASCARA      EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado


; **********************************************************************
; * Dados
; **********************************************************************

PLACE              1000H
inicio_pilha:      STACK 100H ; reserva espaco para a pilha
SP_inicial:

valor_display:     WORD  0 ; variavel que guarda o valor do display
tecla_carregada:   WORD  0 ; variavel que guarda a tecla que se encontra carregada


; **********************************************************************
; * C�digo
; **********************************************************************

PLACE      0

inicio:

; inicializa��es
    MOV  SP, SP_inicial ; inicializa SP
    MOV  R1, 0
    MOV  R3, DISPLAYS   ; endere�o do perif�rico dos displays
    MOV  R4, LINHA      ; come�a-se a testar a primeira linha
    MOV  [R3], R1       ; escreve linha e coluna a zero nos displays


; corpo principal do programa

ciclo:


espera_tecla:                   ; neste ciclo espera-se at� uma tecla ser premida
    CALL obtem_colunas          ; obtem as colunas da determinada linha
    CMP  R0, 0                  ; h� tecla premida?
    JZ   proxima_linha          ; nao havendo tecla premida
    CALL obtem_valor_tecla      ; se houver uma tecla premida, calcula-se o valor da tecla
    MOV  [tecla_carregada], R2  ; altera a variavel da "tecla_carregada" para a tecla premida
    CALL avalia_tecla           ; avalia a tecla carregada e executa diferentes funcoes dependendo da tecla
    JMP  ha_tecla
    
    proxima_linha:
        CALL avanca_linha       ; nao havendo uma tecla premida, avan�a-se para a proxima linha
        JMP  espera_tecla
                       

ha_tecla:               ; neste ciclo espera-se at� NENHUMA tecla estar premida
    CALL obtem_colunas  ; obtem as colunas da determinada linha
    CMP  R0, 0          ; h� tecla premida?
    JNZ  ha_tecla       ; se ainda houver uma tecla premida, espera-se ate n�o haver
    MOV  [tecla_carregada], R1  ; altera a variavel da "tecla_carregada" para nenhuma tecla premida
    JMP  ciclo          ; repete ciclo



; *****************************************************************************
; obtem_colunas: L� as teclas de uma determinada linha do teclado e retorna o 
;                valor lido das respetivas colunas
;
; Entrada(s):    R4 - linha a testar (1, 2, 4 ou 8)
;
; Saida(s): 	 R0 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8)
;
; *****************************************************************************

obtem_colunas:
    PUSH R2
    PUSH R3
    PUSH R5
    MOV  R2, TEC_LIN   ; endere�o do perif�rico das linhas
    MOV  R3, TEC_COL   ; endere�o do perif�rico das colunas
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso
    MOVB [R2], R4      ; escrever no perif�rico de sa�da (linhas)
    MOVB R0, [R3]      ; ler do perif�rico de entrada (colunas)
    AND  R0, R5        ; elimina bits para al�m dos bits 0-3
    CMP  R0, 0         ; h� tecla premida?
    POP  R5
    POP  R3
    POP  R2
    RET



; *****************************************************************************
; avanca_linha:      avanca-se para a linha seguinte
;
; Entrada(s):        R4 - linha a testar (1, 2, 4 ou 8)
;
; Saida(s): 	     R4
;
; *****************************************************************************

avanca_linha:
    PUSH R1
    MOV  R1, ULTIMA_LINHA
    CMP  R4, R1              ; ver se a linha e' a ultima
    JZ   primeira_linha      ; para passar a ultima linha para a primeira
    SHL  R4, 1               ; para ir para a linha seguinte
    POP  R1
    RET

    primeira_linha:
        MOV  R4, LINHA       ; volta-se 'a primeira linha
        POP  R1
        RET

; *****************************************************************************
; obtem_valor_tecla: Calcula o valor de uma determinada tecla
;
; Entrada(s):        R4 - linha a testar (1, 2, 4 ou 8)
;
; Saida(s): 	     R2 - valor calculado da posicao da tecla
;
; *****************************************************************************

obtem_valor_tecla:
    PUSH R0
    PUSH R4
    PUSH R1
    MOV  R1, 0
    MOV  R2, 0

    valor_tecla_linha:
        CMP  R4, 1       ; verifica se o valor da tecla da linha esta' a um
        JZ   valor_tecla_coluna
        SHR  R4, 1         ; desloca 'a direita 1 bit da linha
        ADD  R1, 1
        JNZ  valor_tecla_linha

    valor_tecla_coluna:
        CMP  R0, 1       ; verifica se o valor da tecla da linha esta' a um
        JZ   cont        ;
        SHR  R0, 1         ; desloca 'a direita 1 bit da linha
        ADD  R2, 1
        JNZ  valor_tecla_coluna
    
    cont:
    SHL  R1, 2         ; multiplicar o valor da tecla da linha por 4
    ADD  R2, R1        ; somar o valor da tecla da linha e da coluna
    POP  R1
    POP  R4
    POP  R0
    RET


; *****************************************************************************
; avalia_tecla:   Executa diferentes objetivos dependendo da tecla que esta premida
;
; Entrada(s):     [tecla_carregada]
;
; Saida(s): 	  ---
;
; *****************************************************************************


avalia_tecla:
    PUSH R1
    MOV  R1, [tecla_carregada]
    CMP  R1, CONST_INC
    JZ   avalia_tecla_1
    CMP  R1, CONST_DEC
    JZ   avalia_tecla_2
    JMP  continuacao              ; se nao for nenhuma daquelas teclas

    avalia_tecla_1:
        CALL incrementa
        JMP  continuacao

    avalia_tecla_2:
        CALL decrementa

    continuacao:
    POP R1
    RET


; *****************************************************************************
; incrementa:   Incrementa uma unidade no display
;
; Entrada(s):   [R3]
;
; Saida(s): 	[R3]
;
; *****************************************************************************

incrementa:
    PUSH R1
    MOV  R1, [valor_display]
    INC  R1
    MOV  [valor_display], R1
    MOV  [R3], R1
    POP  R1
    RET



; *****************************************************************************
; decrementa:   Decrementa uma unidade no display
;
; Entrada(s):   [R3]
;
; Saida(s): 	[R3]
;
; *****************************************************************************

decrementa:
    PUSH R1
    MOV  R1, [valor_display]
    DEC  R1
    MOV  [valor_display], R1
    MOV  [R3], R1
    POP  R1
    RET