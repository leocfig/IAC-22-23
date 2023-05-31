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

; Tarefas a realizar:
;
; - padrao de transição

; **********************************************************************
; * Constantes
; **********************************************************************


TAMANHO_PILHA           EQU 100H        ; tamanho de cada pilha, em words
CONST_UNIDADES          EQU 10H         ; constante que se adiciona ou subtrai
                                        ; aos limites quando se muda de dezena
CONST_DEZENAS           EQU 100H        ; constante que se adiciona ou subtrai
                                        ; aos limite quando se muda de centena
CINCO                   EQU 5
SEIS                    EQU 6
SETE                    EQU 7
DUZENTOS_CINQUENTA_SEIS EQU 256         
CENTO_TRES              EQU 103
CENTO_QUARENTA_QUATRO   EQU 144
TECLA_INICIO_JOGO       EQU 0CH         ; tecla que dá inicio ao jogo
TECLA_0                 EQU 0           ; tecla que move a sonda para a esquerda (a 45º)
TECLA_1                 EQU 1           ; tecla que move a sonda em frente
TECLA_2                 EQU 2           ; tecla que move a sonda para a direita (a 45º)
DISPLAYS                EQU 0A000H      ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN                 EQU 0C000H      ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL                 EQU 0E000H      ; endereço das colunas do teclado (periférico PIN)
LINHA_INICIAL           EQU 1           ; linha inicial do teclado a testar
ULTIMA_LINHA            EQU 8           ; número da última linha do teclado
MASCARA_MENOR           EQU 0FH         ; para isolar os 4 bits de menor peso,
                                        ; ao ler as colunas do teclado
MASCARA_MAIOR           EQU 0FH         ; para isolar os 4 bits de maior peso,
                                        ; ao gerar um numero aleatorio                                        
ATRASO			        EQU	400H		; atraso para limitar a velocidade de movimento do boneco

; Multimédia

VIDEO_COMECO            EQU 0           ; video de comeco corresponde ao primeiro video (video/som numero 0)
VIDEO_JOGO              EQU 1           ; video de fundo enquanto o jogo decorre corresponde ao segundo video (video/som numero 1)
VIDEO_FIM               EQU 2           ; video de fundo enquanto o jogo decorre corresponde ao terceiro video (video/som numero 2)

CENARIO_COMECO          EQU 0           ; cenario frontal de comeco corresponde à primeira imagem (imagem numero 0)
CENARIO_PAUSA           EQU 1           ; cenario frontal de pausa corresponde à segunda imagem (imagem numero 1)
CENARIO_FIM             EQU 4           ; cenario frontal de pausa corresponde à quinta imagem (imagem numero 4)

ECRA_DERROTA            EQU 2           ; ecra de derrota por colisão, corresponde à terceira imagem (imagem numero 2)
ECRA_SEM_ENERGIA        EQU 3           ; ecra de derrota por falta de energia, corresponde à quarta imagem (imagem numero 3)

SOM_DISPARO             EQU 3           ; som do disparo, corresponde ao primeiro som (video/som numero 3)
SOM_ATINGE              EQU 4           ; som da sonda a atingir um asteroide, corresponde ao segundo som (video/som numero 4)
SOM_FIM                 EQU 5           ; som quando o jogo é terminado, corresponde ao terceiro som (video/som numero 5)
SOM_EXPLOSAO            EQU 6           ; som da explosão, corresponde ao quarto som (video/som numero 6)
SOM_NICE_WORK           EQU 7


; Comandos

COMANDOS				  EQU 6000H			    ; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    		  EQU COMANDOS + 0AH	; endereço do comando para definir a linha
DEFINE_COLUNA   		  EQU COMANDOS + 0CH	; endereço do comando para definir a coluna
DEFINE_PIXEL    		  EQU COMANDOS + 12H	; endereço do comando para escrever um pixel
APAGA_AVISO     		  EQU COMANDOS + 40H	; endereço do comando para apagar o aviso 
                                                ; de nenhum cenário selecionado
APAGA_ECRÃ	 		      EQU COMANDOS + 02H	; endereço do comando para apagar todos os pixels já desenhados
APAGA_CENARIO 		      EQU COMANDOS + 44H	; endereço do comando para apagar o atual cenario frontal
SELECIONA_CENARIO_FUNDO   EQU COMANDOS + 42H	; endereço do comando para selecionar uma imagem de fundo
SELECIONA_CENARIO_FRONTAL EQU COMANDOS + 46H	; endereço do comando para exibir algo no ecrã,sobreposto ao que já lá está
SELECIONA_ECRA            EQU COMANDOS + 04H	; endereço do comando para selecionar um ecra
INICIA_VIDEO_SOM          EQU COMANDOS + 5AH	; endereço do comando para iniciar vídeos/sons


; Dimensoes

LARGURA_AST			    EQU	5			; largura do asteroide
ALTURA_AST			    EQU	5			; altura do asteroide
LARGURA_NAVE            EQU 17          ; largura da nave
ALTURA_NAVE             EQU 9           ; altura da nave
LINHA_NAVE              EQU 24          ; linha em que começa a nave
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

PLACE                        1000H

; Reserva do espaço para as pilhas dos processos

        STACK TAMANHO_PILHA  ; reserva espaco para a pilha do processo do programa principal
SP_inicial_prog_princ:       ; este é o endereço (1200H) com que o SP deste processo vai ser inicializado

        STACK TAMANHO_PILHA	 ; espaço reservado para a pilha do processo "controlo"
SP_inicial_controlo:	     ; este é o endereço (1400H) com que o SP deste processo vai ser inicializado

	    STACK TAMANHO_PILHA	 ; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:	         ; este é o endereço (1600H) com que o SP deste processo vai ser inicializado
							
	    STACK TAMANHO_PILHA	 ; espaço reservado para a pilha do processo "nave"
SP_inicial_nave:		     ; este é o endereço (1800H) com que o SP deste processo vai ser inicializado

	    STACK TAMANHO_PILHA	 ; espaço reservado para a pilha do processo "energia"
SP_inicial_energia:		     ; este é o endereço (2000H) com que o SP deste processo vai ser inicializado
							
	    STACK TAMANHO_PILHA	 ; espaço reservado para a pilha do processo "sonda"
SP_inicial_sonda:		     ; este é o endereço (2200H) com que o SP deste processo vai ser inicializado

	    STACK TAMANHO_PILHA	 ; espaço reservado para a pilha do processo "asteroide"
SP_inicial_asteroide:	     ; este é o endereço (2400H) com que o SP deste processo vai ser inicializado


tab:
    WORD int_mover_asteroide    ; rotina de atendimento da interrupção 0
    WORD int_mover_sonda        ; rotina de atendimento da interrupção 1
    WORD int_energia            ; rotina de atendimento da interrupção 2


evento_int_mover_ast:   LOCK  0		 ; LOCK para a rotina de interrupção comunicar ao processo ...
evento_int_mover_sonda: LOCK  0		 ; LOCK para a rotina de interrupção comunicar ao processo ...
evento_int_energia:     LOCK  0		 ; LOCK para a rotina de interrupção comunicar ao processo ...

tecla_carregada:        LOCK  0	     ; LOCK para o teclado comunicar aos restantes processos que tecla detetou
modo_atual:             LOCK  0      ; LOOK que controla as teclas de start, pause e stop
valor_display:          WORD  0      ; variavel que guarda o valor do display
limite_uni_sup:         WORD  0AH    ; variavel que guarda a partir do qual o valor das unidades aumenta e deixa de ser decimal
limite_uni_inf:         WORD  0      ; variavel que guarda a partir do qual o valor das unidades diminui e deixa de ser decimal
limite_dez_sup:         WORD  99H    ; variavel que guarda a partir do qual o valor das dezenas aumenta e deixa de ser decimal
limite_dez_inf:         WORD  0      ; variavel que guarda a partir do qual o valor das dezenas diminui e deixa de ser decimal
linha_asteroide:        WORD  0      ; variavel que guarda a linha do asteroide
coluna_asteroide:       WORD  0      ; variavel que guarda a coluna do asteroide
linha_sonda:            WORD  23     ; variavel que guarda a linha da sonda


PLACE		            0500H				

DEF_ASTEROIDE:	; tabela que define o asteroide 
	WORD		LARGURA_AST, ALTURA_AST
	WORD		0,     VERDE, VERDE, VERDE,     0
	WORD		VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		0,     VERDE, VERDE, VERDE,     0

DEF_NAVE:		; tabela que define a nave
	WORD		LARGURA_NAVE, ALTURA_NAVE
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
    MOV  SP, SP_inicial_prog_princ        ; inicializa SP
    MOV  BTE, tab                         ; inicializa BTE
    MOV	 R1, 0			                 
    MOV  [APAGA_AVISO], R1	              ; apaga o aviso de nenhum cenário selecionado
                                          ; (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	              ; apaga todos os pixels já desenhados 
                                          ; (o valor de R1 não é relevante)
    MOV  [INICIA_VIDEO_SOM], R1           ; inicia o vídeo 0
    MOV  [SELECIONA_CENARIO_FRONTAL], R1  ; seleciona o cenário frontal número 0

    EI0					                  ; permite interrupções 0
    EI1					                  ; permite interrupções 1
    EI2					                  ; permite interrupções 2
	EI					                  ; permite interrupções (geral)

	; cria processos
	CALL teclado			              ; cria o processo teclado
	CALL controlo			              ; cria o processo controlo

     

; corpo principal do programa

ciclo:






; *****************************************************************************
; Processo
;
; CONTROLO - Processo responsavel por tratar das teclas de começar, 
;            suspender/continuar e terminar o jogo
;
; *****************************************************************************

PROCESS SP_inicial_controlo

controlo:

    MOV R0, TECLA_INICIO_JOGO
    MOV	R1, [tecla_carregada]	        ; bloqueia neste LOCK até uma tecla ser carregada
    CMP	R1, R0                          ; a tecla carregada é a C?
    JNZ controlo                        ; espera até a tecla carregada for a tecla C

    MOV R2, VIDEO_JOGO
    MOV [APAGA_CENARIO], R2             ; aqui o valor do registo é irrelevante
    MOV [INICIA_VIDEO_SOM], R2
    CALL nave                           ; cria o processo nave

    MOV  R2, DUZENTOS_CINQUENTA_SEIS    ; 256 que corresponde a 100H
    MOV  R3, DISPLAYS                   ; endereço do periférico dos displays
    MOV  [R3], R2                       ; escreve o valor 100 nos displays



; *****************************************************************************
; Processo
;
; TECLADO - Processo que deteta quando se carrega numa tecla 
;		    do teclado e escreve o valor da tecla num LOCK
;
; *****************************************************************************

PROCESS SP_inicial_teclado

teclado:
    
    ; inicializações:
    MOV  R4, LINHA_INICIAL          ; começa-se a testar a primeira linha

    espera_tecla:                   ; neste ciclo espera-se até uma tecla ser premida
        WAIT				        ; este ciclo é potencialmente bloqueante
        CALL obtem_colunas          ; obtem as colunas da determinada linha
        CMP  R0, 0                  ; há tecla premida?
        JZ   proxima_linha          ; nao havendo tecla premida
        CALL obtem_valor_tecla      ; se houver uma tecla premida, calcula-se o valor da tecla
        MOV  [tecla_carregada], R2  ; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada
        JMP  ha_tecla
    
    proxima_linha:
        CALL avanca_linha           ; nao havendo uma tecla premida, avança-se para a proxima linha
        JMP  espera_tecla

    ha_tecla:                       ; neste ciclo espera-se até NENHUMA tecla estar premida
        YIELD				        ; este ciclo é potencialmente bloqueante
        CALL obtem_colunas          ; obtem as colunas da determinada linha
        CMP  R0, 0                  ; há tecla premida?
        JNZ  ha_tecla               ; se ainda houver uma tecla premida, espera-se ate não haver
        MOV  [tecla_carregada], R0  ; altera a variavel LOOK "tecla_carregada" para nenhuma tecla premida



; *****************************************************************************
; Processo
;
; NAVE  - Processo responsavel pelo desenho do painel de instrumentos e 
;         produzir o efeito das luzes 
;
; *****************************************************************************

PROCESS SP_inicial_nave

nave:

    CALL desenha_nave


; *****************************************************************************
; Processo
;
; ENERGIA  - Processo responsavel pela implementação do gasto periódico de energia
;
; *****************************************************************************

PROCESS SP_inicial_energia

energia:




; *****************************************************************************
; Processo
;
; SONDA     - Processo responsavel pelo controlo do lançamento, implementar o 
;             movimento, o limite do alcance e a deteção de colisão de cada sonda
;
; *****************************************************************************

PROCESS SP_inicial_sonda

sonda:

    ; inicializações
    MOV R0, TECLA_0
    MOV R1, TECLA_1
    MOV R2, TECLA_2

    espera_sonda:
        YIELD
        MOV	R3, [tecla_carregada]	        ; bloqueia neste LOCK até uma tecla ser carregada

        CMP	R3, R0                          ; a tecla carregada é a 0?
        JZ  lançar_sonda

        CMP	R3, R1                          ; a tecla carregada é a 1?
        JZ  lançar_sonda

        CMP	R3, R2                          ; a tecla carregada é a 2?
        JZ  lançar_sonda

        JMP espera_sonda                    ; se a tecla nao for nem a 0, 1 ou 2,
                                            ; espera-se até uma destas teclas serem carregadas

    lançar_sonda:
        CALL move_sonda


; *****************************************************************************
; Processo
;
; ASTEROIDE - Processo responsavel pelo controlo das ações e evolução de cada
;             um dos asteroides, incluindo verificação de colisão com a nave
;
; *****************************************************************************

PROCESS SP_inicial_asteroide

asteroide:

    CALL move_asteroide

    MOV  R0, [evento_int_mover_ast]   ; este processo é aqui bloqueado, e só vai ser
                                      ; desbloqueado com a respetiva rotina de interrupção



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
    MOV  R2, TEC_LIN         ; endereço do periférico das linhas
    MOV  R3, TEC_COL         ; endereço do periférico das colunas
    MOV  R5, MASCARA_MENOR   ; para isolar os 4 bits de menor peso
    MOVB [R2], R4            ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]            ; ler do periférico de entrada (colunas)
    AND  R0, R5              ; elimina bits para além dos bits 0-3
    CMP  R0, 0               ; há tecla premida?
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

    ; posição do asteroide:
    MOV  R1, [linha_asteroide]			 ; linha do asteroide
    MOV  R2, [coluna_asteroide]		     ; coluna do asteroide

    ; obtem os parametos do asteroide a partir da tabela:
    MOV	R4, DEF_ASTEROIDE		         ; endereço da tabela que define o asteroide 
                                         ; que é também o endereço da LARGURA_AST
    MOV	R5, [R4]                         ; obtém a largura do asteroide
    ADD	R4, 2			                 ; endereço da ALTURA_AST que define o asteroide 
                                         ; (2 porque a LARGURA_AST é uma word)
    MOV	R6, [R4]			             ; obtém a altura do asteroide
    ADD	R4, 2			                 ; endereço da cor do 1º pixel 
                                         ; (2 porque a ALTURA_AST é uma word)

    preenche_linhas:
        MOV	 R3, [R4]			         ; obtém a cor do próximo pixel do asteroide
        CALL escreve_pixel               ; preenche o determinado pixel
        ADD	 R4, 2			             ; endereço da cor do próximo pixel 
                                         ; (2 porque cada cor de pixel é uma word)
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
    MOV	R4, DEF_NAVE		      ; endereço da tabela que define a nave que
                                  ; é também o endereço da LARGURA_NAVE
    MOV	R5, [R4]                  ; obtém a largura da nave
    ADD	R4, 2			          ; endereço da ALTURA_NAVE que define a nave 
                                  ; (2 porque a LARGURA_NAVE é uma word)
    MOV	R6, [R4]			      ; obtém a altura da nave
    ADD	R4, 2			          ; endereço da cor do 1º pixel 
                                  ; (2 porque a ALTURA_NAVE é uma word)

    preenche_linha:
        MOV	 R3, [R4]			  ; obtém a cor do próximo pixel da nave
        CALL escreve_pixel        ; preenche o determinado pixel
        ADD	 R4, 2			      ; endereço da cor do próximo pixel 
                                  ; (2 porque cada cor de pixel é uma word)
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
; MOVE_SONDA:  Move a sonda com a temporização de 200 milissegundos
;
; Entrada(s):  ---
;
; Saida(s):    ---	
;
; *****************************************************************************

move_sonda:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4

    MOV R4, 1
    MOV [SELECIONA_ECRA], R4        ; seleciona o ecrã 1

    CALL som_disparo

    ; posição da sonda:
    MOV  R1, [linha_sonda]	        ; linha da sonda
    MOV  R2, COLUNA_SONDA	        ; coluna da sonda
    
    ; desenhar a sonda:
    MOV	 R3, AMARELO	            ; obtém a cor do próximo pixel da sonda
    CALL escreve_pixel

    MOV  R0, [evento_int_mover_sonda] ; este processo é aqui bloqueado, e só vai ser
                                      ; desbloqueado com a respetiva rotina de interrupção
                                      
    ; apaga a sonda:
    MOV	 R3, 0			            ; obtém a cor do próximo pixel da sonda (transparente neste caso)
    CALL escreve_pixel

    ; decrementa a linha da sonda:
    MOV  R1, [linha_sonda]	        ; linha da sonda
    DEC  R1
    MOV  [linha_sonda], R1

    ; desenhar a sonda:
    MOV	 R3, AMARELO	            ; obtém a cor do próximo pixel da sonda
    CALL escreve_pixel

    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
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
    MOV	R4, DEF_ASTEROIDE	            ; endereço da tabela que define o asteroide
                                        ; que é também o endereço da LARGURA_AST
    MOV	R5, [R4]                        ; obtém a largura do asteroide
    ADD	R4, 2			                ; endereço da ALTURA_AST que define o asteroide 
                                        ; (2 porque a LARGURA_AST é uma word)
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
;
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


; *****************************************************************************
; GERAR_NUMERO_ALEATORIO - gera um número aleatorio entre 0 e 7
;
; Entrada(s):   ---
;
; Saida(s):     R0
;
; *****************************************************************************


gerar_numero_aleatorio:
    PUSH R1
    MOV R0, [TEC_COL]       ; lê-se o periférico de entrada obtendo assim valores aleatorios
    MOV R1, MASCARA_MAIOR
    AND R0, R1              ; isola os bits de maior peso
    SHR R0, CINCO           ; coloca os bits de maior peso nos bits 2 a 0
    POP R1
    RET



; Rotinas responsáveis pelo som

; *****************************************************************************
; SOM_DISPARO - toca o som do disparo de uma sonda
;
; Entrada(s):   ---
;
; Saida(s):     ---
;
; *****************************************************************************

som_disparo:
    PUSH R0
    MOV  R0, SOM_DISPARO
    MOV  [INICIA_VIDEO_SOM], R0       ; toca o som
    POP  R0
    RET


; *****************************************************************************
; SOM_ATINGE    - toca o som da sonda a atingir um asteroide
;
; Entrada(s):   ---
;
; Saida(s):     ---
;
; *****************************************************************************

som_atinge:
    PUSH R0
    MOV R0, SOM_ATINGE
    MOV [INICIA_VIDEO_SOM], R0       ; toca o som
    POP R0
    RET



; *****************************************************************************
; SOM_FIM       - toca o som quando o jogo é terminado
;
; Entrada(s):   ---
;
; Saida(s):     ---

; *****************************************************************************

som_fim:
    PUSH R0
    MOV R0, SOM_FIM
    MOV [INICIA_VIDEO_SOM], R0       ; toca o som
    POP R0
    RET


; *****************************************************************************
; SOM_EXPLOSAO  - toca o som quando a nave explode
;
; Entrada(s):   ---
;
; Saida(s):     ---

; *****************************************************************************

som_explosao:
    PUSH R0
    MOV R0, SOM_EXPLOSAO
    MOV [INICIA_VIDEO_SOM], R0       ; toca o som
    POP R0
    RET


; *****************************************************************************
; SOM_NICE_WORK - toca o som quando um asteroide minerável é atingido
;
; Entrada(s):   ---
;
; Saida(s):     ---
;
; *****************************************************************************

som_nice_work:
    PUSH R0
    MOV R0, SOM_NICE_WORK
    MOV [INICIA_VIDEO_SOM], R0       ; toca o som
    POP R0
    RET
    


; Rotinas de interrupcao


; *****************************************************************************
; INT_MOVER_ASTEROIDE - Rotina de atendimento da interrupção 0
;			            Interrupção responsável pelos asteroides
;
; *****************************************************************************

int_mover_asteroide:
	MOV	[evento_int_mover_ast], R0	    ; desbloqueia o processo responsável
                                        ; pelos asteroides (qualquer registo serve) 
	RFE


; *****************************************************************************
; INT_MOVER_SONDA    - Rotina de atendimento da interrupção 1
;			           Interrupção responsável pela sonda
;
; *****************************************************************************

int_mover_sonda:
	MOV	[evento_int_mover_sonda], R0	; desbloqueia o processo responsável 
                                        ; pela sonda (qualquer registo serve) 
	RFE


; *****************************************************************************
; INT_ENERGIA       - Rotina de atendimento da interrupção 2
;			          Interrupção responsável pela energia da nave
;
; *****************************************************************************

int_energia:
	MOV	[evento_int_energia], R0	    ; desbloqueia processo responsável pela
                                        ; energia da nave (qualquer registo serve) 
	RFE

