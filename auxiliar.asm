; *****************************************************************************
; INCREMENTA:   Incrementa uma unidade decimal no display
;
; Entrada(s):   [valor_display]
;
; Saida(s): 	[valor_display]
;
; *****************************************************************************

incrementa:
    PUSH R1
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11

    MOV  R1, [valor_display]        ; guarda-se o valor do display num registo
    MOV  R5, [limite_uni_sup]       ; guarda-se o valor dos limites inferiores
    MOV  R6, [limite_uni_inf]       ; e superiores das unidades e dezenas em registo  		
    MOV  R7, [limite_dez_sup]	    ; guarda-se o valor dos limites superiores e
    MOV  R8, [limite_dez_inf]	    ; inferiores das dezenas em registos
    MOV  R4, CONST_UNIDADES
    MOV  R9, CONST_DEZENAS
    CMP  R1, R7                     ; verifica se o valor do display tem o valor
                                    ; igual ao do limite superior das dezenas
    JZ   incrementa_dezenas         ; 
    INC  R1                         ; se não, incrementa 1
    CMP  R1, R5                     ; se o valor do display tem o valor
                                    ; igual ao do limite superior das unidades
    JZ   incrementa_unidades        
    

    sai_incrementa:
        MOV  [valor_display], R1    ; passa o valor de R1 (já incrementado) para o display
        MOV  [R3], R1               ; escreve o valor nos displays

        POP  R11
        POP  R10
        POP  R9
        POP  R8
        POP  R7
        POP  R6
        POP  R5
        POP  R4
        POP  R1
        RET

    incrementa_unidades:
        ADD  R1, SEIS               ; adiciona 6 (10H-0AH) de modo a passar de 
                                    ; hexadecimal para decimal no display
        ADD  R5, R4                 ; adiciona 10H aos limite superior das unidades
        ADD  R6, R4                 ; adiciona 10H aos limite inferior das unidades
        MOV  [limite_uni_sup], R5   ; atualiza os limites das unidades
        MOV  [limite_uni_inf], R6   
        
        JMP  sai_incrementa        

    incrementa_dezenas:
        MOV  R10, CENTO_TRES             ; o que temos de adicionar para passar
                                         ; de 99 para 100 em hexadecimal, pois (100H-9AH)
        MOV  R11, CENTO_QUARENTA_QUATRO  ; o que temos de adicionar para que os limites
                                         ; acompanhem a transicao da centena
        ADD  R1, R10
        ADD  R7, R9                      ; adiciona 100H aos limites superiores
        ADD  R8, R9                      ; e inferiores das dezenas para que 
                                         ; acompanhem a transicao da centena
        MOV  [limite_dez_sup], R7        ; atualiza os limites das dezenas
        MOV  [limite_dez_inf], R8
        ADD  R5, R9                      ; adiciona 99H ao limite superior das unidades
        SUB  R5, R11                     ; ajusta o limite superior das unidades
        ADD  R6, R9                      ; adiciona 99H ao limite inferior das dezenas
        MOV  [limite_uni_sup], R5        ; atualizamos os limites das unidade
        MOV  [limite_uni_inf], R6 

        JMP  sai_incrementa             

; *****************************************************************************
; DECREMENTA:   Decrementa uma unidade decimal no display
;
; Entrada(s):   [valor_display]
;
; Saida(s): 	[valor_display]
;
; *****************************************************************************

decrementa:
    PUSH R1
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11

    MOV  R1, [valor_display]               ; passa o valor do display para um registo
    MOV  R5, [limite_uni_sup]              ; guarda-se o valor dos limites inferiores
    MOV  R6, [limite_uni_inf]              ; e superiores das unidades e dezenas em registos
    MOV  R7, [limite_dez_sup]
    MOV  R8, [limite_dez_inf]
    MOV  R4, CONST_UNIDADES
    MOV  R9, CONST_DEZENAS
    CMP  R1, R6                            ; se o valor do display tem o valor
                                           ; igual ao do limite inferior das unidades
    JZ   decrementa_unidades               
    CMP  R1, R8                            ; se o valor do display tem o valor
                                           ; igual ao do limite inferior das dezenas
    JZ   decrementa_dezenas                

    DEC R1                                 ; diminui o valor do display em uma unidade

    sai_decrementa:
        MOV  [valor_display], R1           ; passa o valor (já decrementado) para o display
        MOV  [R3], R1                      ; escreve o valor nos displays

        POP  R11
        POP  R10
        POP  R9
        POP  R8
        POP  R7
        POP  R6
        POP  R5
        POP  R4
        POP  R1
        RET


    decrementa_unidades:
        SUB  R1, SETE                      ; decrementa 7 (pois 10H-9H) de modo a 
                                           ; passar de hexadecimal para decimal
        SUB  R5, R4                        ; retira 10H aos limites das unidades
        SUB  R6, R4                        ; para que o limite acompanhe o estado do display
        MOV  [limite_uni_sup], R5          ; atualiza os limites das unidades
        MOV  [limite_uni_inf], R6    
        
        JMP  sai_decrementa                

    decrementa_dezenas:
        MOV  R10, CENTO_TRES               ; o que temos de subtrair para passar
                                           ; de 99 para 100 em hexadecimal, pois (100H-9AH)
        MOV  R11, CENTO_QUARENTA_QUATRO    ; o que temos de adicionar ao limite das unidades para 
					                       ; que acompanhe a transicao para a centena acima
        SUB  R1, R10
        SUB  R7, R9                        ; retira 100H aos limites superiores
        SUB  R8, R9                        ; e inferiores das dezenas para 
					                       ; acompanhar a transicao da centena
        MOV  [limite_dez_sup], R7          ; atualiza os limites das dezenas
        MOV  [limite_dez_inf], R8
        SUB  R5, R9                        ; subtrai 99H ao limite superior das unidades
        ADD  R5, R11                       ; ajusta o limite superior das unidades
        SUB  R6, R9                        ; subtrai 99 H ao limite inferior das unidades
        MOV  [limite_uni_sup], R5          ; atualiza os limites das unidades
        MOV  [limite_uni_inf], R6 

        JMP  sai_decrementa                    



;   MOV  R9, sentido_movimento  ; tabela dos sentidos dos movimentos dos asteroides
;	MOV  [R9+R10], R3		    ; sentido de movimento da linha do asteroide
;   ADD  R9, DOIS               ; para se estabelecer o sentido de movimento da coluna
;	MOV  [R9+R10], R4		    ; sentido de movimento da coluna do asteroide