; *********************************************************************
; * PROJETO IAC
; * 
; * Grupo: Número 26
; *        Constituido por:
; *        -               NºIST:
; *        -               NºIST:
; *        -               NºIST:
; *
; *
; *********************************************************************


; Tarefas a fazer:
; - diminuir o numero de registos
; - no incremento, e se chegar ao maximo
; - comentarios
;


; **********************************************************************
; * Constantes
; **********************************************************************


ULTIMA_LINHA EQU 8
CONST_DEC    EQU 4
CONST_INC    EQU 5
DISPLAYS     EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN      EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL      EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA        EQU 1       ; linha inicial a testar
MASCARA      EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado


; **********************************************************************
; * Dados
; **********************************************************************

PLACE         1000H
inicio_pilha: STACK 100H ; reserva espaco para a pilha
SP_inicial:

valor_display:     WORD  0 ; variavel que guarda o valor do display
tecla_carregada:  WORD  0 ; variavel que guarda a tecla que se encontra carregada


; **********************************************************************
; * Código
; **********************************************************************

PLACE      0

inicio:

; inicializações
    MOV  SP, SP_inicial ; inicializa SP
    MOV  R4, DISPLAYS   ; endereço do periférico dos displays
    MOV  R6, LINHA      ; começa-se a testar a primeira linha
    MOV  R7, 0
    MOV  R1, [R4] 
    MOV  [R4], R7     ; escreve linha e coluna a zero nos displays
    MOV  R7, [R4]


; corpo principal do programa

ciclo:


espera_tecla:                   ; neste ciclo espera-se até uma tecla ser premida
    CALL obtem_colunas          ; obtem as colunas da determinada linha
    CMP  R0, 0                  ; há tecla premida?
    JZ   proxima_linha          ; nao havendo tecla premida
    CALL obtem_valor_tecla      ; se houver uma tecla premida, calcula-se o valor da tecla
    MOV  [tecla_carregada], R8  ; altera a variavel da "tecla_carregada" para a tecla premida
    CALL avalia_tecla           ; avalia a tecla carregada e executa diferentes funcoes dependendo da tecla
    JMP  ha_tecla
    
    proxima_linha:
        CALL avanca_linha       ; nao havendo uma tecla premida, avança-se para a proxima linha
        JMP  espera_tecla
                       

ha_tecla:               ; neste ciclo espera-se até NENHUMA tecla estar premida
    CALL obtem_colunas  ; obtem as colunas da determinada linha
    CMP  R0, 0          ; há tecla premida?
    JNZ  ha_tecla       ; se ainda houver uma tecla premida, espera-se ate não haver
    MOV  [tecla_carregada], R7  ; altera a variavel da "tecla_carregada" para nenhuma tecla premida
    JMP  ciclo          ; repete ciclo



; *****************************************************************************
; obtem_colunas: Lê as teclas de uma determinada linha do teclado e retorna o 
;                valor lido das respetivas colunas
;
; Entrada(s):    R6 - linha a testar (1, 2, 4 ou 8)
;
; Saida(s): 	 R0 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8)
;
; *****************************************************************************

obtem_colunas:
    PUSH R2
    PUSH R3
    PUSH R5
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso
    MOVB [R2], R6      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    POP  R5
    POP  R3
    POP  R2
    RET



; *****************************************************************************
; avanca_linha:      avanca-se para a linha seguinte
;
; Entrada(s):        R6 - linha a testar (1, 2, 4 ou 8)
;
; Saida(s): 	     R6
;
; *****************************************************************************

avanca_linha:
    PUSH R9
    MOV  R9, ULTIMA_LINHA
    CMP  R6, R9              ; ver se a linha e' a ultima
    JZ   primeira_linha      ; para passar a ultima linha para a primeira
    SHL  R6, 1               ; para ir para a linha seguinte
    POP  R9
    RET

    primeira_linha:
        MOV  R6, LINHA       ; volta-se 'a primeira linha
        POP  R9
        RET

; *****************************************************************************
; obtem_valor_tecla: Calcula o valor de uma determinada tecla
;
; Entrada(s):        R6 - linha a testar (1, 2, 4 ou 8)
;
; Saida(s): 	     R8 - valor calculado da posicao da tecla
;
; *****************************************************************************

obtem_valor_tecla:
    PUSH R0
    PUSH R6
    PUSH R7
    MOV  R7, 0
    MOV  R8, 0

    valor_tecla_linha:
        CMP  R6, 1       ; verifica se o valor da tecla da linha esta' a um
        JZ   valor_tecla_coluna
        SHR  R6, 1         ; desloca 'a direita 1 bit da linha
        ADD  R7, 1
        JNZ  valor_tecla_linha

    valor_tecla_coluna:
        CMP  R0, 1       ; verifica se o valor da tecla da linha esta' a um
        JZ   cont        ;
        SHR  R0, 1         ; desloca 'a direita 1 bit da linha
        ADD  R8, 1
        JNZ  valor_tecla_coluna
    
    cont:
    SHL  R7, 2         ; multiplicar o valor da tecla da linha por 4
    ADD  R8, R7        ; somar o valor da tecla da linha e da coluna
    POP  R7
    POP  R6
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
    PUSH R7
    MOV  R7, [tecla_carregada]
    CMP  R7, CONST_INC
    JZ   avalia_tecla_1
    CMP  R7, CONST_DEC
    JZ   avalia_tecla_2
    JMP  continuacao              ; se nao for nenhuma daquelas teclas

    avalia_tecla_1:
        CALL incrementa
        JMP  continuacao

    avalia_tecla_2:
        CALL decrementa

    continuacao:
    POP R7
    RET


; *****************************************************************************
; incrementa:   Incrementa uma unidade no display
;
; Entrada(s):   [R4]
;
; Saida(s): 	[R4]
;
; *****************************************************************************

incrementa:
    PUSH R7
    MOV  R7, [valor_display]
    INC  R7
    MOV  [valor_display], R7
    MOV  [R4], R7
    POP  R7
    RET



; *****************************************************************************
; decrementa:   Decrementa uma unidade no display
;
; Entrada(s):   [R4]
;
; Saida(s): 	[R4]
;
; *****************************************************************************

decrementa:
    PUSH R7
    MOV  R7, [valor_display]
    DEC  R7
    MOV  [valor_display], R7
    MOV  [R4], R7
    POP  R7
    RET