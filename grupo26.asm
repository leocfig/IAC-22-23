; *********************************************************************
; * PROJETO IAC
; * 
; * Grupo: Número 26
; *
; * Constituido por:
; *    - Gonçalo Andrez Duarte de Frias Nunes            NºIST: 107097
; *    - Leonor Costa Figueira                           NºIST: 106157
; *    - Nuno Filipe de Barros Isidoro Oliveira Martins  NºIST: 107273
; *
; *
; *********************************************************************


; Tarefas a fazer:
; - comentarios
; - por constantes daqueles nr do inc e dec



; **********************************************************************
; * Constantes
; **********************************************************************


ULTIMA_LINHA            EQU 8           ; número da última linha
CONST_DECIMAL           EQU 10H
CONST_DECIMAL_DEZ       EQU 100H
TECLA_DEC               EQU 4           ; tecla para decrementar contador
TECLA_INC               EQU 5           ; tecla para incrementar contador
TECLA_MOVE_AST          EQU 6           ; tecla que move o asteroide
TECLA_MOVE_SONDA        EQU 1           ; tecla que move a sonda
DISPLAYS                EQU 0A000H      ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN                 EQU 0C000H      ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL                 EQU 0E000H      ; endereço das colunas do teclado (periférico PIN)
LINHA_INICIAL           EQU 1           ; linha inicial do teclado a testar
MASCARA                 EQU 0FH         ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
ATRASO			        EQU	400H		; atraso para limitar a velocidade de movimento do boneco


; Comandos

COMANDOS				EQU	6000H			    ; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    		EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		    EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
SELECIONA_ECRA          EQU COMANDOS + 04H		; endereço do comando para selecionar um ecra
INICIA_SOM              EQU COMANDOS + 5AH		; endereço do comando para iniciar o som de um asteroide


; Dimensoes

LARGURA_AST			    EQU	5			; largura do asteroide
ALTURA_AST			    EQU	5			; altura do asteroide
LARGURA_NAVE            EQU 17          ; largura da nave
ALTURA_NAVE             EQU 9           ; altura da nave
LINHA_NAVE              EQU 23          ; linha em que começa a nave
COLUNA_NAVE             EQU 24          ; coluna em que começa a nave
COLUNA_SONDA            EQU 32          ; coluna em que se encontra a sonda


; Cores

VERDE   			    EQU	0F0F0H		; cor do pixel: verde em ARGB
CINZENTO_CLARO   	    EQU	0FCCCH		; cor do pixel: cinzento-claro em ARGB
AZUL_ESCURO   	        EQU	0F257H		; cor do pixel: azul-escuro em ARGB
AZUL_CLARO   			EQU	0F1DEH		; cor do pixel: azul-claro em ARGB
CINZENTO_ESCURO   	    EQU	0F555H		; cor do pixel: cinzento-escuro em ARGB
AZUL_ESMERALDA   		EQU	0F2FFH		; cor do pixel: azul-esmeralda em ARGB
LARANJA   			    EQU	0FF40H		; cor do pixel: laranja em ARGB
QUASE_PRETO   			EQU	0F333H		; cor do pixel: quase-preto em ARGB
BRANCO                  EQU 0FFFFH      ; cor do pixel: branco em ARGB
AMARELO   			    EQU	0FFF0H		; cor do pixel: amarelo em ARGB



; *****************************************************************************
; * Dados
; *****************************************************************************

PLACE                   1000H
inicio_pilha:           STACK 200H ; reserva espaco para a pilha
SP_inicial:

valor_display:          WORD  0           ; variavel que guarda o valor do display
tecla_carregada:        WORD  0           ; variavel que guarda a tecla que se encontra carregada
limite_uni_sup:         WORD  0AH
limite_uni_inf:         WORD  0
limite_dez_sup:         WORD  99H
limite_dez_inf:         WORD  0
linha_asteroide:        WORD  0           ; variavel que guarda a linha do asteroide
coluna_asteroide:       WORD  0           ; variavel que guarda a coluna do asteroide
linha_sonda:            WORD  23          ; variavel que guarda a linha da sonda


PLACE		            0500H				

DEF_ASTEROIDE:	; tabela que define o asteroide 
	WORD		LARGURA_AST, ALTURA_AST
	WORD		0,     VERDE, VERDE, VERDE,     0
	WORD		VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		0,     VERDE, VERDE, VERDE,     0

DEF_NAVE:		; tabela que define a nave ; a nave inclui a sonda na posicao inicial
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
    MOV	 R1, 0			                 
    MOV  R3, DISPLAYS                   ; endereço do periférico dos displays
    MOV  R4, LINHA_INICIAL              ; começa-se a testar a primeira linha
    MOV  [R3], R1                       ; escreve o valor 0 nos displays
    MOV  [APAGA_AVISO], R1	            ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	            ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo número 0
    CALL desenha_nave                   ; desenha a nave
    CALL desenha_asteroide              ; desenha o asteroide
     

; corpo principal do programa

ciclo:
    CALL teclado



; *****************************************************************************
; TECLADO:       Deteta quando se carrega numa tecla do teclado
;
; Entrada(s):    
;
; Saida(s): 	
;
; *****************************************************************************

teclado:
    
    espera_tecla:                   ; neste ciclo espera-se até uma tecla ser premida
        CALL obtem_colunas          ; obtem as colunas da determinada linha
        CMP  R0, 0                  ; há tecla premida?
        JZ   proxima_linha          ; nao havendo tecla premida
        CALL obtem_valor_tecla      ; se houver uma tecla premida, calcula-se o valor da tecla
        MOV  [tecla_carregada], R2  ; altera a variavel da "tecla_carregada" para a tecla premida
        CALL avalia_tecla           ; avalia a tecla carregada e executa diferentes funcoes dependendo da tecla
        JMP  ha_tecla
    
    proxima_linha:
        CALL avanca_linha           ; nao havendo uma tecla premida, avança-se para a proxima linha
        JMP  espera_tecla

    ha_tecla:                       ; neste ciclo espera-se até NENHUMA tecla estar premida
        CALL obtem_colunas          ; obtem as colunas da determinada linha
        CMP  R0, 0                  ; há tecla premida?
        JNZ  ha_tecla               ; se ainda houver uma tecla premida, espera-se ate não haver
        MOV  [tecla_carregada], R1  ; altera a variavel da "tecla_carregada" para nenhuma tecla premida
        JMP  ciclo                  ; repete ciclo

    RET

; *****************************************************************************
; OBTEM_COLUNAS: Lê as teclas de uma determinada linha do teclado e retorna o 
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
; AVANCA_LINHA:      avanca-se para a linha seguinte
;
; Entrada(s):        R4 - linha a testar (1, 2, 4 ou 8)
;
; Saida(s): 	     R4
;
; *****************************************************************************

avanca_linha:
    PUSH R1
    MOV  R1, ULTIMA_LINHA
    CMP  R4, R1                  ; ver se a linha e' a ultima
    JNZ  inc_linha               ; se nao for a ultima linha
    MOV  R4, LINHA_INICIAL       ; se for a primeira linha, volta-se 'a primeira linha
    JMP  sai_avanca_linha
    
    inc_linha:
        SHL  R4, 1               ; para ir para a linha seguinte

    sai_avanca_linha:
        POP  R1
        RET

; *****************************************************************************
; OBTEM_VALOR_TECLA: Calcula o valor de uma determinada tecla
;
; Entrada(s):        R4 - linha a testar (1, 2, 4 ou 8)
;
; Saida(s): 	     R2 - valor calculado da posicao da tecla
;
; *****************************************************************************

obtem_valor_tecla:
    PUSH R0
    PUSH R1
    PUSH R4
    MOV  R1, 0
    MOV  R2, 0

    valor_tecla_linha:
        CMP  R4, 1                   ; verifica se o valor da tecla da linha esta' a um
        JZ   valor_tecla_coluna
        SHR  R4, 1                   ; desloca 'a direita 1 bit da linha
        INC  R1
        JNZ  valor_tecla_linha

    valor_tecla_coluna:
        CMP  R0, 1                   ; verifica se o valor da tecla da linha esta' a um
        JZ   sai_obtem_valor_tecla                    
        SHR  R0, 1                   ; desloca 'a direita 1 bit da linha
        ADD  R2, 1
        JNZ  valor_tecla_coluna
    
    sai_obtem_valor_tecla:
    SHL  R1, 2                       ; multiplicar o valor da tecla da linha por 4
    ADD  R2, R1                      ; somar o valor da tecla da linha e da coluna

    POP  R4
    POP  R1
    POP  R0
    RET


; *****************************************************************************
; AVALIA_TECLA:   Executa diferentes objetivos dependendo da tecla que esta premida
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
    CMP  R1, TECLA_INC                     ; se a tecla carregada for a tecla para incrementar contador
    JZ   avalia_tecla_1
    CMP  R1, TECLA_DEC                     ; se a tecla carregada for a tecla para decrementar contador
    JZ   avalia_tecla_2
    CMP  R1, TECLA_MOVE_AST                ; se a tecla carregada for a tecla para mover o asteroide
    JZ   avalia_tecla_3
    CMP  R1, TECLA_MOVE_SONDA              ; se a tecla carregada for a tecla para mover a sonda
    JZ   avalia_tecla_4
    JMP  sai_avalia_tecla                  ; se nao for nenhuma daquelas teclas


    avalia_tecla_1:
        CALL incrementa                    
        JMP  sai_avalia_tecla

    avalia_tecla_2:
        CALL decrementa                    
        JMP  sai_avalia_tecla

    avalia_tecla_3:
        CALL move_asteroide
        JMP  sai_avalia_tecla

    avalia_tecla_4:
        CALL move_sonda
    
    sai_avalia_tecla:
    POP R2
    POP R1
    RET


; *****************************************************************************
; INCREMENTA:   Incrementa uma unidade no display
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

    MOV  R1, [valor_display]               ; passa o valor do display para um registo
    MOV  R5, [limite_uni_sup]              ; próximas 4 linhas passam o valor dos limites inferiores e superior das unidades e dezenas para registos
    MOV  R6, [limite_uni_inf]
    MOV  R7, [limite_dez_sup]
    MOV  R8, [limite_dez_inf]
    MOV  R9, CONST_DECIMAL_DEZ
    MOV  R4, CONST_DECIMAL
    CMP  R1, R7                            ; se o valor do display tem o valor das dezenas igual ao do limite superior de dezenas
    JZ   incrementa_decimal_dez
    INC  R1                                ; se não, incrementa 1
    CMP  R1, R5                            ; se o valor do display tem o valor das unidades igual ao do limite superior de unidades
    JZ   incrementa_decimal
    

    passa_display_1:
    MOV  [valor_display], R1               ; passa o valor de R1 (já incrementado) para o display
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
    ADD  R1, 6                             ; adiciona 6 de modo a passar de hexadecimal para decimal no display
    ADD  R5, R4                            ; adiciona 10H aos limites de unidade
    ADD  R6, R4
    MOV  [limite_uni_sup], R5
    MOV  [limite_uni_inf], R6    
    
    JMP  passa_display_1

    incrementa_decimal_dez:
    MOV  R10, 103                          ; o que temos de adicionar para incrementar de 99 para 100 em hexadecimal
    MOV  R11, 144
    ADD  R1, R10
    ADD  R7, R9                            ; adiciona 100H aos limites das dezenas
    ADD  R8, R9
    MOV  [limite_dez_sup], R7
    MOV  [limite_dez_inf], R8
    ADD  R5, R9
    SUB  R5, R11
    ADD  R6, R9
    MOV  [limite_uni_sup], R5              ; mudamos os limites de unidade
    MOV  [limite_uni_inf], R6 

    JMP  passa_display_1



; *****************************************************************************
; DECREMENTA:   Decrementa uma unidade no display
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
    MOV  R5, [limite_uni_sup]              ; próximas 4 linhas passam o valor dos limites inferiores e superior das unidades e dezenas para registos
    MOV  R6, [limite_uni_inf]
    MOV  R7, [limite_dez_sup]
    MOV  R8, [limite_dez_inf]
    MOV  R4, CONST_DECIMAL
    MOV  R9, CONST_DECIMAL_DEZ
    CMP  R1, R6                            ; verifica se o valor do display corresponde ao limite inferior das unidades
    JZ   decrementa_decimal
    CMP  R1, R8                            ; verifica se o valor do display corresponde ao limite inferior das dezenas
    JZ   decrementa_decimal_dez
    DEC R1

    passa_display_2:
    MOV  [valor_display], R1               ; passa o valor (já decrementado) para o display
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
        SUB  R1, 7                         ; decrementa de forma especial devido à passagem de hexadecimal para decimal
        SUB  R5, R4                        ; retira 10H aos limites das unidades
        SUB  R6, R4
        MOV  [limite_uni_sup], R5
        MOV  [limite_uni_inf], R6    
        
        JMP  passa_display_2

    decrementa_decimal_dez:
        MOV  R10, 103
        MOV  R11, 144
        SUB  R1, R10
        SUB  R7, R9                        ; retira 100H aos limites das dezenas
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
; DESENHA_ASTEROIDE:  Desenha um asteroide
;
; Entrada(s):         ---
;
; Saida(s):           ---	
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
    MOV [SELECIONA_ECRA], R7             ; seleciona o ecrã 0

    MOV  R1, [linha_asteroide]			 ; linha do asteroide
    MOV  R2, [coluna_asteroide]		     ; coluna do asteroide

    ; obtem os parametos do asteroide a partir da tabela:
    MOV	R4, DEF_ASTEROIDE		         ; endereço da tabela que define o asteroide que é também o endereço da LARGURA_AST
    MOV	R5, [R4]                         ; obtém a largura do asteroide
    ADD	R4, 2			                 ; endereço da ALTURA_AST que define o asteroide (2 porque a LARGURA_AST é uma word)
    MOV	R6, [R4]			             ; obtém a altura do asteroide
    ADD	R4, 2			                 ; endereço da cor do 1º pixel (2 porque a ALTURA_AST é uma word)

    preenche_linhas:
        MOV	 R3, [R4]			         ; obtém a cor do próximo pixel do asteroide
        CALL escreve_pixel               ; preenche o determinado pixel
        ADD	 R4, 2			             ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
        INC  R2                          ; próxima coluna
        DEC  R5 			             ; menos uma coluna para tratar
        JNZ  preenche_linhas             ; continua até percorrer toda a largura do objeto
        INC  R1                          ; avança-se para a proxima linha
        MOV  R2, [coluna_asteroide]      ; volta a inicializar a coluna
        DEC  R6                          ; menos uma linha para tratar
        MOV  R5, LARGURA_AST             ; volta a inicializar a largura do asteroide
        JNZ  preenche_linhas             ; volta ao preenche_linhas até a largura ser 0

    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET


; *****************************************************************************
; MOVE_ASTEROIDE:  Move o asteroide
;
; Entrada(s):      ---
;
; Saida(s):        ---	
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

        MOV R7, 0
        MOV [INICIA_SOM], R7           ; inicia o som 0

        CALL atraso 		           ; atraso para limitar a velocidade de movimento do asteroide		

        ; posição do asteroide:
        MOV  R1, [linha_asteroide]	   ; linha do asteroide
        MOV  R2, [coluna_asteroide]    ; coluna do asteroide

        CALL apaga_asteroide

        ; incremento da posicao do asteroide:
        MOV  R1, [linha_asteroide]	   ; linha do asteroide
        MOV  R2, [coluna_asteroide]    ; coluna do asteroide
        INC  R1
        INC  R2
        MOV  [linha_asteroide], R1     ; atualiza a linha do asteroide
        MOV  [coluna_asteroide], R2    ; atualiza a coluna do asteroide
        
        CALL desenha_asteroide

        POP R7
        POP R6
        POP R5
        POP R4
        POP R3
        POP R2
        POP R1
        RET


; *****************************************************************************
; DESENHA_NAVE:  Desenha a nave (ou painel de instrumentos da nave)
;
; Entrada(s):    ---
;
; Saida(s):      ---	
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
    MOV [SELECIONA_ECRA], R7      ; seleciona o ecrã 1

    ; posição da nave
    MOV  R1, LINHA_NAVE			  ; linha da nave
    MOV  R2, COLUNA_NAVE		  ; coluna da nave

    ; obtem os parametros da nave a partir da tabela
    MOV	R4, DEF_NAVE		      ; endereço da tabela que define a nave que é também o endereço da LARGURA_NAVE
    MOV	R5, [R4]                  ; obtém a largura da nave
    ADD	R4, 2			          ; endereço da ALTURA_NAVE que define a nave (2 porque a LARGURA_NAVE é uma word)
    MOV	R6, [R4]			      ; obtém a altura da nave
    ADD	R4, 2			          ; endereço da cor do 1º pixel (2 porque a ALTURA_NAVE é uma word)

    preenche_linha:
        MOV	 R3, [R4]			  ; obtém a cor do próximo pixel da nave
        CALL escreve_pixel        ; preenche o determinado pixel
        ADD	 R4, 2			      ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
        INC  R2                   ; próxima coluna
        DEC  R5 			      ; menos uma coluna para tratar
        JNZ  preenche_linha       ; continua até percorrer toda a largura da nave
        INC  R1                   ; avança-se para a proxima linha
        MOV  R2, COLUNA_NAVE      ; volta a inicializar a coluna
        SUB  R6, 1                ; menos uma linha para tratar
        MOV  R5, LARGURA_NAVE     ; volta a inicializar a largura da nave
        JNZ  preenche_linha       ; volta ao preenche_linha até a largura ser 0

    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET


; *****************************************************************************
; MOVE_SONDA:  Move a sonda
;
; Entrada(s):  ---
;
; Saida(s):    ---	
;
; *****************************************************************************

move_sonda:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4

    CALL atraso		                    ; atraso para limitar a velocidade de movimento da sonda	

    MOV R4, 1
    MOV [SELECIONA_ECRA], R4            ; seleciona o ecrã 1

    ; posição da sonda:
    MOV  R1, [linha_sonda]	            ; linha da sonda
    MOV  R2, COLUNA_SONDA	            ; coluna da sonda
    
    ; apaga a sonda:
    MOV	 R3, 0			                ; obtém a cor do próximo pixel da sonda (transparente neste caso)
    CALL escreve_pixel

    ; decrementa a linha da sonda:
    MOV  R1, [linha_sonda]	            ; linha da sonda
    DEC  R1
    MOV  [linha_sonda], R1

    ; desenhar a sonda:
    MOV	 R3, AMARELO	                ; obtém a cor do próximo pixel da sonda
    CALL escreve_pixel

    POP R4
    POP R3
    POP R2
    POP R1
    RET


; *****************************************************************************
; APAGA_ASTEROIDE - Apaga o asteroide do ecra onde foi desenhado

; Entrada(s):       R1 - linha do asteroide
;                   R2 - coluna do asteroide
;
; Saida(s):         ---
;
; *****************************************************************************

apaga_asteroide:

    ; obtem os parametros do asteroide a partir da tabela:
    MOV	R4, DEF_ASTEROIDE	            ; endereço da tabela que define o asteroide que é também o endereço da LARGURA_AST
    MOV	R5, [R4]                        ; obtém a largura do asteroide
    ADD	R4, 2			                ; endereço da ALTURA_AST que define o asteroide (2 porque a LARGURA_AST é uma word)
    MOV	R6, [R4]			            ; obtém a altura do asteroide

    apaga_linhas:
        MOV	 R3, 0			           ; obtém a cor do próximo pixel do asteroide (neste caso, transparente)
        CALL escreve_pixel             ; preenche o determinado pixel
        INC  R2                        ; próxima coluna
        DEC  R5          		       ; menos uma coluna para tratar
        JNZ  apaga_linhas              ; continua até percorrer toda a largura do asteroide
        INC  R1                        ; avança-se para a proxima linha
        MOV  R2, [coluna_asteroide]    ; volta a inicializar a coluna
        DEC  R6                        ; menos uma linha para tratar
        MOV  R5, LARGURA_AST           ; volta a inicializar a largura do asteroide
        JNZ  apaga_linhas              ; volta ao apaga_linhas até a largura ser 0

    RET

; *****************************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas

; Entrada(s):   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; Saida(s):     ---
;
; *****************************************************************************

escreve_pixel:
	MOV  [DEFINE_LINHA],  R1		; seleciona a linha
	MOV  [DEFINE_COLUNA], R2		; seleciona a coluna
	MOV  [DEFINE_PIXEL],  R3		; altera a cor do pixel na linha e coluna já selecionadas
	RET


; *****************************************************************************
; ATRASO -      Executa um ciclo para implementar um atraso

; Entrada(s):   ---
;
; Saida(s):     ---
;
; *****************************************************************************

atraso:
	PUSH R0
    MOV  R0, ATRASO

    ciclo_atraso:
        SUB	R0, 1
        JNZ	ciclo_atraso
        POP	R0
        RET