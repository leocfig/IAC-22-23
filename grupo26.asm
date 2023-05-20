; *********************************************************************
; * IST-UL
; * Modulo:    lab3.asm
; * Descrição: Exemplifica o acesso a um teclado.
; *            Lê uma linha do teclado, verificando se há alguma tecla
; *            premida nessa linha.
; *
; *
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
; 

ULTIMA_LINHA EQU 8
CONST_DEC    EQU 4
CONST_INC    EQU 5
DISPLAYS     EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN      EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL      EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA        EQU 1       ; linha inicial a testar
MASCARA      EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

; **********************************************************************
; * Código
; **********************************************************************

PLACE      0
inicio:		
; inicializações
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV  R6, LINHA     ; testar a linha em consideraçao
    MOV  R10, 0
    MOV  R15, 0

; corpo principal do programa
ciclo:
    MOV  R6, LINHA     ; volta 'a primeira linha
    MOVB [R4], R15      ; escreve linha e coluna a zero nos displays


espera_tecla:          ; neste ciclo espera-se até uma tecla ser premida
    MOV  R7, 0         ; inicializa o valor da tecla da linha
    MOV  R8, 0         ; inicializa o valor da tecla da coluna
    MOV  R9, R6        ; guarda o valor da linha
    MOVB [R2], R6      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JZ   avanca_linha  ; se nenhuma tecla premida, repete
                       ; vai mostrar a linha e a coluna da tecla
                       
valor_tecla_linha:
    MOV  R11, 1
    CMP  R6, R11       ; verifica se o valor da tecla da linha esta' a um
    JZ  valor_tecla_coluna
    SHR  R6, 1         ; desloca 'a direita 1 bit da linha
    ADD  R7, 1
    JNZ  valor_tecla_linha

valor_tecla_coluna:
    CMP  R0, R11       ; verifica se o valor da tecla da linha esta' a um
    JZ   obtem_valor   ;
    SHR  R0, 1         ; desloca 'a direita 1 bit da linha
    ADD  R8, 1
    JNZ  valor_tecla_coluna

obtem_valor:
    SHL  R7, 2         ; multiplicar o valor da tecla da linha por 4
    ADD  R8, R7        ; somar o valor da tecla da linha e da coluna
    MOV  R10, R8
    CMP  R10, CONST_INC
    JZ   incrementa
    CMP  R10, CONST_DEC
    JZ   decrementa

ha_tecla:              ; neste ciclo espera-se até NENHUMA tecla estar premida
    MOV  R1, R9        ; testar a linha em consideração (R1 tinha sido alterado)
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver

    MOV  R12, ULTIMA_LINHA
    CMP  R9, R12       ; ver se a linha e' a ultima
    JNZ  avanca_linha  ; ir para a linha seguinte
    MOV  R6, R9        ; atualiza o valor atual da linha
    JMP  ciclo         ; repete ciclo

avanca_linha:
    MOV  R12, 8
    CMP  R9, R12       ; ver se a linha e' a ultima
    JZ   ciclo 
    SHL  R9, 1         ; para ir para a linha seguinte
    MOV  R6, R9        ; atualiza o valor atual da linha
    JMP  espera_tecla  ; repete ciclo

incrementa:
    INC  [R4]
    MOVB [R4], R15
    JMP  espera_tecla

decrementa:
    SUB  R15, 1
    MOVB [R4], R15
    JMP  espera_tecla

