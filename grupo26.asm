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
; - no incremento, e se chegar ao maximo
; - comentarios
; - o painel tem de ir mudando de corzinhas
; - por constantes daqueles nr do inc e dec
; - nao duplicar codigo
; - teclado?


; **********************************************************************
; * Constantes
; **********************************************************************


ULTIMA_LINHA            EQU 8
CONST_DECIMAL           EQU 10H
CONST_DECIMAL_DEZ       EQU 100H
TECLA_DEC               EQU 4
TECLA_INC               EQU 5
TECLA_MOVE_AST          EQU 6
TECLA_MOVE_SONDA        EQU 1
DISPLAYS                EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN                 EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL                 EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA_TEC               EQU 1       ; linha inicial a testar
MASCARA                 EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado


; Comandos

COMANDOS				EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    		EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		    EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
SELECIONA_ECRA          EQU COMANDOS + 04H		; endereço do comando para selecionar um ecra
INICIA_SOM              EQU COMANDOS + 5AH		; endereço do comando para iniciar o som de um asteroide
ATRASO			        EQU	400H		        ; atraso para limitar a velocidade de movimento do boneco

; Dimensoes

LARGURA_AST			    EQU	5			; largura do boneco
ALTURA_AST			    EQU	5			; altura do boneco
LARGURA_NAVE            EQU 17          ; largura da nave
ALTURA_NAVE             EQU 9           ; altura da nave
LINHA_NAVE              EQU 23
COLUNA_NAVE             EQU 24
COLUNA_SONDA            EQU 32


; Cores

VERDE   			    EQU	0F0F0H		; cor do pixel: verde em ARGB (opaco e vermelho no máximo, verde e azul a 0)
CINZENTO_CLARO   	    EQU	0FCCCH		; cor do pixel: cinzento-claro em ARGB (opaco e vermelho no máximo, verde e azul a 0)
AZUL_ESCURO   	        EQU	0F257H		; cor do pixel: azul-escuro em ARGB (opaco e vermelho no máximo, verde e azul a 0)
AZUL_CLARO   			EQU	0F1DEH		; cor do pixel: azul-claro em ARGB (opaco e vermelho no máximo, verde e azul a 0)
CINZENTO_ESCURO   	    EQU	0F555H		; cor do pixel: cinzento-escuro em ARGB (opaco e vermelho no máximo, verde e azul a 0)
AZUL_ESMERALDA   		EQU	0F2FFH		; cor do pixel: azul-esmeralda em ARGB (opaco e vermelho no máximo, verde e azul a 0)
LARANJA   			    EQU	0FF40H		; cor do pixel: laranja em ARGB (opaco e vermelho no máximo, verde e azul a 0)
QUASE_PRETO   			EQU	0F333H		; cor do pixel: quase-preto em ARGB (opaco e vermelho no máximo, verde e azul a 0)
BRANCO                  EQU 0FFFFH      ; cor do pixel: branco em ARGB (opaco e vermelho no máximo, verde e azul a 0)
AMARELO   			    EQU	0FFF0H		; cor do pixel: verde em ARGB (opaco e vermelho no máximo, verde e azul a 0)



; *****************************************************************************
; * Dados
; *****************************************************************************

PLACE                   1000H
inicio_pilha:           STACK 100H ; reserva espaco para a pilha
SP_inicial:

valor_display:          WORD  0   ; variavel que guarda o valor do display
tecla_carregada:        WORD  0   ; variavel que guarda a tecla que se encontra carregada
limite_uni_sup:         WORD  0AH
limite_uni_inf:         WORD  0
limite_dez_sup:         WORD  99H
limite_dez_inf:         WORD  0
linha_asteroide:        WORD  0   ; variavel que guarda a linha do asteroide
coluna_asteroide:       WORD  0   ; variavel que guarda a coluna do asteroide
linha_sonda:            WORD  23  ; variavel que guarda a linha da sonda


PLACE		            0500H				

DEF_ASTEROIDE:				; tabela que define o asteroide 
	WORD		LARGURA_AST, ALTURA_AST
	WORD		0,     VERDE, VERDE, VERDE,     0
	WORD		VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		0,     VERDE, VERDE, VERDE,     0

DEF_NAVE:					; tabela que define o painel 
	WORD		LARGURA_NAVE, ALTURA_NAVE
	WORD		0, 0, 0, 0, 0, 0, 0, 0, AMARELO,  0, 0, 0, 0, 0, 0, 0, 0
	WORD		0, 0, 0, 0, 0, 0, 0, 0, CINZENTO_ESCURO,  0, 0, 0, 0, 0, 0, 0, 0
	WORD		0, 0, 0, 0, 0, 0, 0, 0, BRANCO, 0, 0, 0, 0, 0, 0, 0, 0
	WORD		0, 0, LARANJA, 0, 0, 0, 0, BRANCO, AZUL_ESMERALDA, BRANCO, 0, 0, 0, 0, LARANJA, 0, 0
	WORD		0, 0, QUASE_PRETO, 0, 0, 0, 0, CINZENTO_CLARO, AZUL_CLARO, CINZENTO_CLARO, 0, 0, 0, 0, QUASE_PRETO, 0, 0
	WORD		0, 0, CINZENTO_ESCURO, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, AZUL_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, 0, CINZENTO_ESCURO, 0, 0
	WORD		0, BRANCO, CINZENTO_ESCURO, BRANCO, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, BRANCO, CINZENTO_ESCURO, BRANCO, 0
	WORD		CINZENTO_ESCURO, BRANCO, CINZENTO_CLARO, BRANCO, CINZENTO_CLARO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_CLARO, BRANCO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_CLARO, BRANCO, CINZENTO_CLARO, BRANCO, CINZENTO_ESCURO 
	WORD		CINZENTO_ESCURO, BRANCO, BRANCO, BRANCO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_CLARO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_CLARO, BRANCO, BRANCO, BRANCO, CINZENTO_ESCURO

    



; **********************************************************************
; * Código
; **********************************************************************

PLACE      0

inicio:

; inicializações
    MOV  SP, SP_inicial                 ; inicializa SP
    MOV  R3, DISPLAYS                   ; endereço do periférico dos displays
    MOV  R4, LINHA_TEC                  ; começa-se a testar a primeira linha
    MOV  [R3], R1                       ; escreve linha e coluna a zero nos displays
    MOV  [APAGA_AVISO], R1	            ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	            ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    MOV	 R1, 0			                ; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
    CALL desenha_nave                   ; desenha a nave
    CALL desenha_asteroide              ; desenha o asteroide
     


; corpo principal do programa

ciclo:
    

espera_tecla:                   ; neste ciclo espera-se até uma tecla ser premida
    CALL obtem_colunas          ; obtem as colunas da determinada linha
    CMP  R0, 0                  ; há tecla premida?
    JZ   proxima_linha          ; nao havendo tecla premida
    CALL obtem_valor_tecla      ; se houver uma tecla premida, calcula-se o valor da tecla
    MOV  [tecla_carregada], R2  ; altera a variavel da "tecla_carregada" para a tecla premida
    CALL avalia_tecla           ; avalia a tecla carregada e executa diferentes funcoes dependendo da tecla
    JMP  ha_tecla
    
    proxima_linha:
        CALL avanca_linha       ; nao havendo uma tecla premida, avança-se para a proxima linha
        JMP  espera_tecla
                       

ha_tecla:               ; neste ciclo espera-se até NENHUMA tecla estar premida
    CALL obtem_colunas  ; obtem as colunas da determinada linha
    CMP  R0, 0          ; há tecla premida?
    JNZ  ha_tecla       ; se ainda houver uma tecla premida, espera-se ate não haver
    MOV  [tecla_carregada], R1  ; altera a variavel da "tecla_carregada" para nenhuma tecla premida
    JMP  ciclo          ; repete ciclo



; *****************************************************************************
; obtem_colunas: Lê as teclas de uma determinada linha do teclado e retorna o 
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
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso
    MOVB [R2], R4      ; escrever no periférico de saída (linhas)
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
        MOV  R4, LINHA_TEC       ; volta-se 'a primeira linha
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
    PUSH R2
    MOV  R1, [tecla_carregada]
    CMP  R1, TECLA_INC
    JZ   avalia_tecla_1
    CMP  R1, TECLA_DEC
    JZ   avalia_tecla_2
    CMP  R1, TECLA_MOVE_AST
    JZ   avalia_tecla_3
    CMP  R1, TECLA_MOVE_SONDA              ; se nao for nenhuma daquelas teclas
    JZ   avalia_tecla_4
    JMP  continuacao


    avalia_tecla_1:
        CALL incrementa
        JMP  continuacao

    avalia_tecla_2:
        CALL decrementa
        JMP  continuacao

    avalia_tecla_3:
        CALL move_asteroide
        JMP  continuacao

    avalia_tecla_4:
        CALL move_sonda
    
    continuacao:
    POP R2
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
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11

    MOV  R1, [valor_display]
    MOV  R5, [limite_uni_sup]
    MOV  R6, [limite_uni_inf]
    MOV  R7, [limite_dez_sup]
    MOV  R8, [limite_dez_inf]
    MOV  R9, CONST_DECIMAL_DEZ
    MOV  R4, CONST_DECIMAL
    CMP  R1, R7
    JZ   incrementa_decimal_dez
    INC  R1
    CMP  R1, R5 
    JZ   incrementa_decimal
    

    passa_display_1:
    MOV  [valor_display], R1
    MOV  [R3], R1

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

    incrementa_decimal:
    ADD  R1, 6
    ADD  R5, R4
    ADD  R6, R4
    MOV  [limite_uni_sup], R5
    MOV  [limite_uni_inf], R6    
    
    JMP  passa_display_1

    incrementa_decimal_dez:
    MOV  R10, 103
    MOV  R11, 144
    ADD  R1, R10
    ADD  R7, R9
    ADD  R8, R9
    MOV  [limite_dez_sup], R7
    MOV  [limite_dez_inf], R8
    ADD  R5, R9
    SUB  R5, R11
    ADD  R6, R9
    MOV  [limite_uni_sup], R5
    MOV  [limite_uni_inf], R6 

    JMP  passa_display_1



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
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11

    MOV  R1, [valor_display]
    MOV  R5, [limite_uni_sup]
    MOV  R6, [limite_uni_inf]
    MOV  R4, CONST_DECIMAL
    MOV  R7, [limite_dez_sup]
    MOV  R8, [limite_dez_inf]
    MOV  R9, CONST_DECIMAL_DEZ
    CMP  R1, R6
    JZ   decrementa_decimal
    CMP  R1, R8
    JZ   decrementa_decimal_dez
    DEC R1

    passa_display_2:
    MOV  [valor_display], R1
    MOV  [R3], R1

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


    decrementa_decimal:
        SUB  R1, 7
        SUB  R5, R4
        SUB  R6, R4
        MOV  [limite_uni_sup], R5
        MOV  [limite_uni_inf], R6    
        
        JMP  passa_display_2

    decrementa_decimal_dez:
        MOV  R10, 103
        MOV  R11, 144
        SUB  R1, R10
        SUB  R7, R9
        SUB  R8, R9
        MOV  [limite_dez_sup], R7
        MOV  [limite_dez_inf], R8
        SUB  R5, R9
        ADD  R5, R11
        SUB  R6, R9
        MOV  [limite_uni_sup], R5
        MOV  [limite_uni_inf], R6 

    JMP  passa_display_1


; *****************************************************************************
; desenha_asteroide:  Desenha um asteroide
;
; Entrada(s): ---
;
; Saida(s): ---	
;
; *****************************************************************************

desenha_asteroide:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7

    MOV R7, 0
    MOV [SELECIONA_ECRA], R7

    posição_boneco_1:
        MOV  R1, [linha_asteroide]			; linha do boneco
        MOV  R2, [coluna_asteroide]		    ; coluna do boneco

    desenha_boneco:       		; desenha o boneco a partir da tabela
        MOV	R4, DEF_ASTEROIDE		; endereço da tabela que define o boneco
        MOV	R5, [R4]            ; obtém a LARGURA_AST do boneco
        ADD	R4, 2			    ; endereço da ALTURA_AST que define o boneco
        MOV	R6, [R4]			; obtém a ALTURA_AST do boneco
        ADD	R4, 2			    ; endereço da cor do 1º pixel (2 porque a ALTURA_AST é uma word)

        preenche_linha:
        MOV	 R3, [R4]			; obtém a cor do próximo pixel do boneco
        MOV  [DEFINE_LINHA], R1	; seleciona a linha
        MOV  [DEFINE_COLUNA],R2	; seleciona a coluna
        MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
        ADD	 R4, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
        ADD  R2, 1               ; próxima coluna
        SUB  R5, 1			; menos uma coluna para tratar
        JNZ  preenche_linha      ; continua até percorrer toda a LARGURA_AST do objeto
        INC  R1
        MOV  R2, [coluna_asteroide]
        SUB  R6, 1
        MOV  R5, LARGURA_AST
        JNZ  preenche_linha

    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET



; *****************************************************************************
; move_asteroide:  Move o asteroide
;
; Entrada(s): ---
;
; Saida(s): ---	
;
; *****************************************************************************
    
    move_asteroide:

        PUSH R1
        PUSH R2
        PUSH R3
        PUSH R4
        PUSH R5
        PUSH R6
        PUSH R7
        PUSH R8

        MOV R8, 0
        MOV [INICIA_SOM], R8

        MOV	R7, ATRASO		       ; atraso para limitar a velocidade de movimento do boneco		

        ciclo_atraso:
            SUB	R7, 1
            JNZ	ciclo_atraso

        posição_asteroide:
            MOV  R1, [linha_asteroide]	   ; linha do boneco
            MOV  R2, [coluna_asteroide]    ; coluna do boneco


        apaga_asteroide:       		; desenha o boneco a partir da tabela
            MOV	R4, DEF_ASTEROIDE	; endereço da tabela que define o boneco
            MOV	R5, [R4]            ; obtém a LARGURA_AST do boneco
            ADD	R4, 2			    ; endereço da ALTURA_AST que define o boneco
            MOV	R6, [R4]			; obtém a ALTURA_AST do boneco

        apaga_linha:
            MOV	 R3, 0			    ; obtém a cor do próximo pixel do boneco
            MOV  [DEFINE_LINHA], R1	; seleciona a linha
            MOV  [DEFINE_COLUNA],R2	; seleciona a coluna
            MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
            INC  R2                 ; próxima coluna
            DEC  R5          		; menos uma coluna para tratar
            JNZ  apaga_linha     ; continua até percorrer toda a LARGURA_AST do objeto
            INC  R1
            MOV  R2, [coluna_asteroide]
            DEC  R6
            MOV  R5, LARGURA_AST
            JNZ  apaga_linha

        incremento_posicao_ast:
            MOV  R1, [linha_asteroide]	   ; linha do boneco
            MOV  R2, [coluna_asteroide]    ; coluna do boneco
            INC  R1
            INC  R2
            MOV  [linha_asteroide], R1
            MOV  [coluna_asteroide], R2
        

        CALL desenha_asteroide

        POP R8
        POP R7
        POP R6
        POP R5
        POP R4
        POP R3
        POP R2
        POP R1
        RET


; *****************************************************************************
; desenha_nave:  Desenha uma nave
;
; Entrada(s): ---
;
; Saida(s): ---	
;
; *****************************************************************************

desenha_nave:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7

    MOV R7, 1
    MOV [SELECIONA_ECRA], R7

    posição_nave:
        MOV  R1, LINHA_NAVE			; linha do boneco
        MOV  R2, COLUNA_NAVE		; coluna do boneco

    imprime_nave:       		; desenha o boneco a partir da tabela
        MOV	R4, DEF_NAVE		; endereço da tabela que define o boneco
        MOV	R5, [R4]            ; obtém a LARGURA_AST do boneco
        ADD	R4, 2			    ; endereço da ALTURA_AST que define o boneco
        MOV	R6, [R4]			; obtém a ALTURA_AST do boneco
        ADD	R4, 2			    ; endereço da cor do 1º pixel (2 porque a ALTURA_AST é uma word)

        preenche_linha_2:
        MOV	 R3, [R4]			; obtém a cor do próximo pixel do boneco
        MOV  [DEFINE_LINHA], R1	; seleciona a linha
        MOV  [DEFINE_COLUNA],R2	; seleciona a coluna
        MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
        ADD	 R4, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
        ADD  R2, 1               ; próxima coluna
        SUB  R5, 1			; menos uma coluna para tratar
        JNZ  preenche_linha_2      ; continua até percorrer toda a LARGURA_AST do objeto
        INC  R1
        MOV  R2, COLUNA_NAVE
        SUB  R6, 1
        MOV  R5, LARGURA_NAVE
        JNZ  preenche_linha_2

    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET


; *****************************************************************************
; move_sonda:  Move a sonda;
;
; Entrada(s): ---
;
; Saida(s): ---	
;
; *****************************************************************************

    move_sonda:

        PUSH R1
        PUSH R2
        PUSH R3
        PUSH R4

        MOV	R4, ATRASO		       ; atraso para limitar a velocidade de movimento do boneco		

        ciclo_atraso_2:
            SUB	R4, 1
            JNZ	ciclo_atraso_2

        posição_sonda:
            MOV  R1, [linha_sonda]	; linha do boneco
            MOV  R2, COLUNA_SONDA	; coluna do boneco
        
        apaga_sonda:
            MOV	 R3, 0			    ; obtém a cor do próximo pixel do boneco
            MOV  [DEFINE_LINHA], R1	; seleciona a linha
            MOV  [DEFINE_COLUNA],R2	; seleciona a coluna
            MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas

        decremento_linha_sonda:
            MOV  R1, [linha_sonda]	   ; linha do boneco
            DEC  R1
            MOV  [linha_sonda], R1

        desenha_sonda:
            MOV	 R3, AMARELO	    ; obtém a cor do próximo pixel do boneco
            MOV  [DEFINE_LINHA], R1	; seleciona a linha
            MOV  [DEFINE_COLUNA],R2	; seleciona a coluna
            MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas

        POP R4
        POP R3
        POP R2
        POP R1
        RET

