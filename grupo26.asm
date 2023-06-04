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
; - passar os desenhos para só um desenho?
; - dar spawn no mesmo sítio - asteroides
; - organizar a ordem das funções
; - organizar as constantes

; **********************************************************************
; * Constantes
; **********************************************************************


FATOR                   EQU 100        ; uma potência de 10 (para obter os dígitos)
TAMANHO_PILHA           EQU 100H        ; tamanho de cada pilha, em words
CONST_UNIDADES          EQU 10H         ; constante que se adiciona ou subtrai
                                        ; aos limites quando se muda de dezena
CONST_DEZENAS           EQU 100H        ; constante que se adiciona ou subtrai
                                        ; aos limite quando se muda de centena
DOIS                    EQU 2
TRES                    EQU 3
QUATRO                  EQU 4
CINCO                   EQU 5
SEIS                    EQU 6
SETE                    EQU 7
DEZ                     EQU 10
SESSENTA_QUATRO         EQU 64
DUZENTOS_CINQUENTA_SEIS EQU 256         
CENTO_TRES              EQU 103
CENTO_QUARENTA_QUATRO   EQU 144
TECLA_INICIO_JOGO       EQU 0CH         ; tecla que dá inicio ao jogo
TECLA_PAUSA_RET_JOGO    EQU 0DH         ; tecla que permite suspender ou continuar o jogo
TECLA_TERMINAR_JOGO     EQU 0EH         ; tecla que permite terminar o jogo
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
MASCARA_MAIOR           EQU 0FFH        ; para isolar os 4 bits de maior peso,
                                        ; ao gerar um numero aleatorio                                        
ATRASO			        EQU	400H		; atraso para limitar a velocidade de movimento do boneco
N_ASTEROIDES			EQU 4		    ; número de asteroides
N_SONDAS    			EQU 3		    ; número máximo de sondas
ALCANCE_MAX    			EQU 12		    ; número máximo de movimentos das sondas


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

LARGURA_AST			    EQU	5			; largura do asteroides
ALTURA_AST			    EQU	5			; altura do asteroides
LARGURA_NAVE            EQU 17          ; largura da nave
ALTURA_NAVE             EQU 9           ; altura da nave
LINHA_NAVE              EQU 24          ; linha em que começa a nave
COLUNA_NAVE             EQU 24          ; coluna em que começa a nave
COLUNA_SONDA            EQU 32          ; coluna em que se encontra a sonda
MAX_LINHA		        EQU 31          ; número da linha mais em baixo que o asteroide pode ocupar
LINHA_SONDA_0_2         EQU 25          ; número da linha onde são disparadas as sondas 0 e 2
LINHA_SONDA_1           EQU 23          ; número da linha onde é disparada a sonda 1

; Cores

VERDE   			    EQU	0F0F0H		; cor do pixel: verde em ARGB
VERMELHO   			    EQU	0FF00H		; cor do pixel: vermelho em ARGB
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

PLACE                        1500H

; Reserva do espaço para as pilhas dos processos

        STACK TAMANHO_PILHA                 ; reserva espaco para a pilha do processo do programa principal
SP_inicial_prog_princ:                      ; este é o endereço (1700H) com que o SP deste processo vai ser inicializado

        STACK TAMANHO_PILHA	                ; espaço reservado para a pilha do processo "controlo"
SP_inicial_controlo:	                    ; este é o endereço (1900H) com que o SP deste processo vai ser inicializado

	    STACK TAMANHO_PILHA	                ; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:	                        ; este é o endereço (1600H) com que o SP deste processo vai ser inicializado
							
	    STACK TAMANHO_PILHA	                ;espaço reservado para a pilha do processo "nave"
SP_inicial_nave:		                    ;este é o endereço (1800H) com que o SP deste processo vai ser inicializado

	    STACK TAMANHO_PILHA	                ; espaço reservado para a pilha do processo "energia"
SP_inicial_energia:		                    ; este é o endereço (2000H) com que o SP deste processo vai ser inicializado
							
	    STACK TAMANHO_PILHA	                ; espaço reservado para a pilha do processo "sonda"
SP_inicial_sonda:		                    ; este é o endereço (2200H) com que o SP deste processo vai ser inicializado

	    STACK TAMANHO_PILHA	* N_ASTEROIDES  ; espaço reservado para as pilha de todos os processos "asteroide"
SP_inicial_asteroide:	                    ; este é o endereço (2400H) com que o SP deste processo vai ser inicializado


tab:
    WORD int_mover_asteroide    ; rotina de atendimento da interrupção 0
    WORD int_mover_sonda        ; rotina de atendimento da interrupção 1
    WORD int_energia            ; rotina de atendimento da interrupção 2
    WORD int_nave               ; rotina de atendimento da interrupção 3


evento_int_mover_ast:   LOCK  0		 ; LOCK para a rotina de interrupção comunicar ao processo do asteroide
evento_int_mover_sonda: LOCK  0		 ; LOCK para a rotina de interrupção comunicar ao processo da sonda
evento_int_energia:     LOCK  0		 ; LOCK para a rotina de interrupção comunicar ao processo da energia
evento_int_nave:        LOCK  0		 ; LOCK para a rotina de interrupção comunicar ao processo da nave

tecla_carregada:        LOCK  0	     ; LOCK para o teclado comunicar aos restantes processos que tecla detetou
modo_atual:             LOCK  0      ; LOOK que controla as teclas de start, pause e stop
valor_display:          WORD  0      ; variavel que guarda o valor do display
valor_display_dec:      WORD  0      ; variavel que guarda o valor do display atual em decimal
limite_uni_sup:         WORD  0AH    ; variavel que guarda a partir do qual o valor das unidades aumenta e deixa de ser decimal
limite_uni_inf:         WORD  0      ; variavel que guarda a partir do qual o valor das unidades diminui e deixa de ser decimal
limite_dez_sup:         WORD  199H   ; variavel que guarda a partir do qual o valor das dezenas aumenta e deixa de ser decimal
limite_dez_inf:         WORD  100H   ; variavel que guarda a partir do qual o valor das dezenas diminui e deixa de ser decimal


PLACE		            0800H


; Definições de objetos

DEF_ASTEROIDE_MIN:	; tabela que define o asteroide minerável
	WORD		    LARGURA_AST, ALTURA_AST
	WORD		    0,     VERDE, VERDE, VERDE,     0
	WORD		    VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		    VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		    VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		    0,     VERDE, VERDE, VERDE,     0


DEF_ASTEROIDE_NAO_MIN:	; tabela que define o asteroide não minerável
	WORD		        LARGURA_AST, ALTURA_AST
	WORD		        VERMELHO, 0, VERMELHO, 0, VERMELHO
	WORD		        0, VERMELHO, VERMELHO, VERMELHO, 0
	WORD		        VERMELHO, VERMELHO, 0, VERMELHO, VERMELHO
	WORD		        0, VERMELHO, VERMELHO, VERMELHO, 0
	WORD		        VERMELHO, 0, VERMELHO, 0, VERMELHO


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

    
linha_asteroide:   ; linha onde cada um dos quatro asteroides está (inicializada com a linha inicial)
    WORD 0
    WORD 0
    WORD 0
    WORD 0

coluna_asteroide:  ; coluna onde cada um dos quatro asteroides está (inicializada com a coluna inicial)
    WORD 0
    WORD 0
    WORD 0
    WORD 0


;sentido_movimento:	; sentido movimento inicial de cada boneco (+1 para a direita ou para baixo, -1 para a esquerda ou para cima)
;	WORD 0, 0
;	WORD 0, 0
;	WORD 0, 0
;	WORD 0, 0


tipo_asteroide:     ; 0 para asteroides não mineráveis e 1 para asteroides mineráveis
    WORD 0
    WORD 0
    WORD 0
    WORD 0

ecra_asteroide:
    WORD 0
    WORD 1
    WORD 2
    WORD 3


linha_sonda:   ; linha onde cada uma das sondas está
    WORD 0
    WORD 0
    WORD 0

coluna_sonda:  ; coluna onde cada uma das sondas está
    WORD 0
    WORD 0
    WORD 0


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
    MOV  R11, N_ASTEROIDES                ; número de asteroides a usar
    MOV  R10, N_SONDAS                    ; número máximo de sondas a usar
    EI0					                  ; permite interrupções 0
    EI1					                  ; permite interrupções 1
    EI2					                  ; permite interrupções 2
    EI3					                  ; permite interrupções 3
	EI					                  ; permite interrupções (geral)

	; cria processos
	CALL teclado			              ; cria o processo teclado
	CALL controlo			              ; cria o processo controlo

     

; corpo principal do programa

ciclo:
    YIELD
    JMP ciclo






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
    MOV  R4, SESSENTA_QUATRO            ; 256 que corresponde a 100H
    MOV  R3, DISPLAYS                   ; endereço do periférico dos displays
    MOV  [R3], R2                       ; escreve o valor 100 nos displays
    MOV  [valor_display], R2
    MOV  [valor_display_dec], R4        ; inicializa-se o valor em 64

   CALL energia                        ; cria o processo energia

    loop_asteroides:
        SUB  R11, 1                     ; próximo asteroide
    	CALL asteroide			        ; cria uma nova instância do processo asteroide (o valor de R11 distingue-as)
	    CMP  R11, 0			            ; já se criaram as instâncias todas?
        JNZ	 loop_asteroides		    ; se não, continua

    loop_sondas:                        
        SUB  R10, 1                     ; próximo sonda
        CALL sonda  			        ; cria uma nova instância do processo sonda (o valor de R10 distingue-as)
        CMP  R10, 0			            ; já se criaram as instâncias todas?
        JNZ	 loop_sondas    		    ; se não, continua

    loop_2:
        YIELD
        JMP loop_2

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
        WAIT				        ; ter um ponto de fuga (aqui pode comutar para outro processo)
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
        JMP  espera_tecla           ; sai deste ciclo quando já não há nenhuma tecla premida



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
    RET

;    espera_nave:
;        MOV  R0, [evento_int_nave]  ; este processo é aqui bloqueado, e só vai ser
                                    ; desbloqueado com a respetiva rotina de interrupção

;        CALL muda_luzes            ; produz o efeito das luzes quando a interrupção ocorre

 ;       JMP espera_nave


; *****************************************************************************
; Processo
;
; ENERGIA  - Processo responsavel pela implementação do gasto periódico de energia
;
; *****************************************************************************

PROCESS SP_inicial_energia

energia:
    YIELD
    MOV  R0, [evento_int_energia]   ; este processo é aqui bloqueado, e só vai ser
                                    ; desbloqueado com a respetiva rotina de interrupção

    CALL decrementa_energia_3       ; subtrai 3 ao valor do display quando a interrrupção ocorre
    JMP energia


; *****************************************************************************
; Processo
;
; SONDA     - Processo responsavel pelo controlo do lançamento, implementar o 
;             movimento, o limite do alcance e a deteção de colisão de cada sonda
;
; *****************************************************************************

PROCESS SP_inicial_sonda

sonda:
    MOV R1, TAMANHO_PILHA   ; tamanho em palavras da pilha de cada processo
    MUL R1, R10             ; TAMANHO_PILHA vezes o nº da instância da sonda
    SUB	SP, R1              ; inicializa SP desta sonda

    MOV R9, R10			    ; cópia do nº de instância do processo
	SHL R9, 1			    ; multiplica por 2 porque as tabelas são de WORDS

    MOV R4, ALCANCE_MAX

    espera_tecla_sonda:
        YIELD
        
        ; inicializações
        MOV R0, TECLA_0
        MOV R1, TECLA_1
        MOV R2, TECLA_2

        MOV	R3, [tecla_carregada]	   ; bloqueia neste LOCK até uma tecla ser carregada

        CMP	R3, R0                     ; a tecla carregada é a 0?
        JZ  sonda_0

        CMP	R3, R1                     ; a tecla carregada é a 1?
        JZ  sonda_1

        CMP	R3, R2                     ; a tecla carregada é a 2?
        JZ  sonda_2

        JMP espera_tecla_sonda         ; se a tecla nao for nem a 0, 1 ou 2,
                                       ; espera-se até uma destas teclas serem carregadas

    sonda_0:                        ; caso em que a sonda sai do canto esquerdo da nave
        MOV  R1, LINHA_SONDA_0_2    ; a linha inicial desta sonda
        MOV  R0, 26                 ; a coluna inicial desta sonda
        MOV  R5, -1                 ; o sentido de movimento da linha desta sonda
        MOV  R6, -1                 ; o sentido de movimento da coluna desta sonda
        JMP continua_sonda

    sonda_1:                        ; caso em que a sonda sai do meio da nave
        MOV  R1, LINHA_SONDA_1      ; a linha inicial desta sonda
        MOV  R0, 32                 ; a coluna inicial desta sonda
        MOV  R5, -1                 ; o sentido de movimento da linha desta sonda
        MOV  R6, 0                  ; o sentido de movimento da coluna desta sonda
        JMP continua_sonda

    sonda_2:                        ; caso em que a sonda sai do canto direito da nave
        MOV  R1, LINHA_SONDA_0_2    ; a linha inicial desta sonda
        MOV  R0, 38                 ; a coluna inicial desta sonda
        MOV  R5, -1                 ; o sentido de movimento da linha desta sonda
        MOV  R6, 1                  ; o sentido de movimento da coluna desta sonda

    continua_sonda:
        MOV  R8, linha_sonda        ; tabela das linhas das sondas
        MOV  [R8+R9], R1            ; linha onde está a determinada sonda
                            
        MOV  R7, coluna_sonda       ; tabela das colunas das sondas
        MOV  [R7+R9], R0		    ; coluna onde está a determinada sonda
        MOV  R2, R0

    CALL som_disparo
    MOV  R10, 0                     ; inicializa o número de movimentos da determinada sonda

    espera_sonda:

        CALL desenha_sonda              

        MOV  R0, [evento_int_mover_sonda] ; este processo é aqui bloqueado, e só vai ser
                                          ; desbloqueado com a respetiva rotina de interrupção

        CALL apaga_sonda                  ; apaga o asteroide na sua posição corrente
        INC  R10                          ; incrementa o número de movimentos da determinada sonda

        CMP  R10, R4                      ; vê se chegou aos limites do alcance máximo da sonda
        JZ   espera_tecla_sonda           ; se chegou, a sonda desaparece

        ADD	R1, R5			              ; para desenhar a sonda na nova posição
        ADD	R2, R6

        JMP  espera_sonda


; *****************************************************************************
; Processo
;
; ASTEROIDE - Processo responsavel pelo controlo das ações e evolução de cada
;             um dos asteroides, incluindo verificação de colisão com a nave
;
; *****************************************************************************

PROCESS SP_inicial_asteroide

asteroide:
    MOV R1, TAMANHO_PILHA   ; tamanho em palavras da pilha de cada processo
    MUL R1, R11             ; TAMANHO_PILHA vezes o nº da instância do asteroide
    SUB	SP, R1              ; inicializa SP deste asteroide

    MOV R10, R11			; cópia do nº de instância do processo
	SHL R10, 1			    ; multiplica por 2 porque as tabelas são de WORDS

    CALL inicia_asteroide    ; apenas neste caso inicial é que os asteroides são 
                             ; distribuídos pelas cinco ações sequencialmente
    JMP  continua_asteroide

    novo_asteroide:
        CALL acao_asteroide     ; determina a ação aleatória a tomar pelo asteroide

    continua_asteroide:
        CALL gerar_asteroide    ; determina o tipo do asteroide

        MOV  R9, linha_asteroide    ; tabela das linhas dos asteroides
        MOV  R1, [R9+R10]		    ; linha onde está o determinado asteroide
                            
        MOV  R8, coluna_asteroide   ; tabela das colunas dos asteroides
        MOV  [R8+R10], R0		    ; coluna onde está o determinado asteroide
        MOV  R2, R0

        MOV  R3, tipo_asteroide     ; tabela dos tipos dos asteroides
        MOV  R4, [R3+R10]           ; tipo do determinado asteroide
        CMP  R4, 1                  ; se o determinado asteroide for minerável
        JZ   tipo_minerável

        tipo_nao_minerável:
            MOV  R4, DEF_ASTEROIDE_NAO_MIN  ; endereço da tabela que define o asteroide
            JMP  espera_asteroide

        tipo_minerável:
            MOV  R4, DEF_ASTEROIDE_MIN      ; endereço da tabela que define o asteroide

    espera_asteroide:
        CALL desenha_asteroide		    ; desenha o asteroide a partir da tabela, na sua posição atual

        MOV  R0, [evento_int_mover_ast] ; este processo é aqui bloqueado, e só vai ser
                                        ; desbloqueado com a respetiva rotina de interrupção

        CALL apaga_asteroide     		; apaga o asteroide na sua posição corrente

        CALL testa_limites              ; vê se chegou aos limites do ecrã
        CMP  R7, 1                      ; se o asteroide saiu do ecrã
        JZ   novo_asteroide             ; cria-se um novo asteroide

        ADD	R1, R5			            ; para desenhar o asteroide na nova posição
        ADD	R2, R6			        
        JMP espera_asteroide	


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
; 
; DESENHA_ASTEROIDE   - Desenha um asteroide na linha e coluna indicadas
;			            com a forma e cor definidas na tabela indicada.
;
; Entrada(s):         R1  - linha
;                     R2  - coluna
;                     R4  - tabela que define o asteroide
;                     R10 - instância do processo
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

    MOV R3, ecra_asteroide               ; tabela do ecrã do asteroide
    MOV R7, [R3+R10]
    MOV [SELECIONA_ECRA], R7             ; seleciona o determinado ecrã

    MOV R7, R2                           ; para guardar o valor da coluna inicial

    ; obtem os parametos do asteroide a partir da tabela:
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
        MOV  R2, R7                      ; volta a inicializar a coluna
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

    MOV R7, QUATRO 
    MOV [SELECIONA_ECRA], R7      ; seleciona o ecrã 4

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
; MUDA_LUZES:    Altera o conjunto de luzes no painel de instrumentos da nave
;                com a temporização de 300 milissegundos
;
; Entrada(s):    ---
;
; Saida(s):      ---	
;
; *****************************************************************************

muda_luzes:







; *****************************************************************************
; APAGA_ASTEROIDE - Apaga um boneco na linha e coluna indicadas
;			        com a forma definida na tabela indicada.
;
; Entrada(s):       R1 - linha do asteroide
;                   R2 - coluna do asteroide
;                   R4 - tabela que define o asteroide
;                   R10 - instância do processo
;
; Saida(s):         ---
;
; *****************************************************************************

apaga_asteroide:
    PUSH    R1
    PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R6
	PUSH	R7

    MOV R3, ecra_asteroide              ; tabela do ecrã do asteroide
    MOV R7, [R3+R10]
    MOV [SELECIONA_ECRA], R7            ; seleciona o determinado ecrã

    MOV R7, R2                      ; para guardar o valor da coluna inicial

    ; obtem os parametros do asteroide a partir da tabela:
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
        MOV  R2, R7                    ; volta a inicializar a coluna
        DEC  R6                        ; menos uma linha para tratar
        MOV  R5, LARGURA_AST           ; volta a inicializar a largura do asteroide
        JNZ  apaga_linhas              ; volta ao apaga_linhas até a largura ser 0

    POP R7
    POP R6
    POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP	R1
    RET


; *****************************************************************************
; DESENHA_SONDA     - Desenha a sonda do ecra onde foi desenhado
;
; Entrada(s):       R1 - linha da sonda
;                   R2 - coluna da sonda
;
; Saida(s):         ---
;
; *****************************************************************************

desenha_sonda:
    PUSH R3
    MOV  R3, QUATRO 
    MOV [SELECIONA_ECRA], R3    ; seleciona o ecrã 4

    MOV	 R3, AMARELO            ; obtém a cor do próximo pixel da sonda (amarelo neste caso)
    CALL escreve_pixel
    POP  R3
    RET


; *****************************************************************************
; APAGA_SONDA       - Apaga a sonda do ecra onde foi desenhado
;
; Entrada(s):       R1 - linha da sonda
;                   R2 - coluna da sonda
;
; Saida(s):         ---
;
; *****************************************************************************

apaga_sonda:
    PUSH R3
    MOV  R3, QUATRO 
    MOV [SELECIONA_ECRA], R3    ; seleciona o ecrã 4

    MOV	 R3, 0                  ; obtém a cor do próximo pixel da sonda (transparente neste caso)
    CALL escreve_pixel
    POP  R3
    RET


; *****************************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas

; Entrada(s):   R1 - linha do objeto
;               R2 - coluna do objeto
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
    MOV  R0, [TEC_COL]       ; lê-se o periférico de entrada obtendo assim valores aleatorios
    MOV  R1, MASCARA_MAIOR
    AND  R0, R1              ; isola os bits de maior peso
    SHR  R0, CINCO           ; coloca os bits de maior peso nos bits 2 a 0
    POP  R1
    RET


; *****************************************************************************
; GERAR_NUMERO_ALEATORIO_4 - gera um número aleatorio entre 0 e 4
;
; Entrada(s):   ---
;
; Saida(s):     R0
;
; *****************************************************************************


gerar_numero_aleatorio_4:
    CALL gerar_numero_aleatorio
    CMP  R0, CINCO
    JLT  sai_gerar_numero_aleatorio_4
    JMP  gerar_numero_aleatorio_4

    sai_gerar_numero_aleatorio_4:
        RET


; *****************************************************************************
; GERAR_ASTEROIDE - gera um asteroide do tipo minerável (25%) ou não minerável (75%)
;
; Entrada(s):     R10 - instância do processo
;
; Saida(s):       ---
;
; *****************************************************************************


gerar_asteroide:
    PUSH R0
    PUSH R1
    PUSH R2
    MOV  R2, tipo_asteroide     ; tabela dos tipos dos asteroides
    CALL gerar_numero_aleatorio ; gera um numero entre 0 e 7
    CMP  R0, DOIS               ; o número ser inferior a 2 (ser 0 ou 1) tem uma
                                ; probabilidade de 25%
    JLT  mineravel              ; se for inferior a 2

    nao_mineravel:              ; o asteroide fica não minerável
        MOV R1, 0
        MOV [R2 + R10], R1
        JMP sai_gerar_asteroide

    mineravel:                  ; o asteroide fica minerável
        MOV R1, 1
        MOV [R2 + R10], R1

    sai_gerar_asteroide:
        POP R2
        POP R1
        POP R0
        RET


; *****************************************************************************
; DECREMENTA_ENERGIA_3 - decrementa 3 ao valor da energia da nave
;
; Entrada(s):          ---
;
; Saida(s):            ---
;
; *****************************************************************************

decrementa_energia_3:
    PUSH R4
    PUsH R5
    
    MOV  R5, 4
    ciclo_decrementa_3:
    SUB  R5, 1
    ;MOV  R4, [valor_display_dec]
    ;SUB  R4, 3                      ; subtrai 3 ao valor do display
    CALL decrementa
    CMP  R5, 0
    JNZ  ciclo_decrementa_3
    ;CALL converte_decimal
    ;MOV  R1, DISPLAYS               ; endereço do periférico dos displays
    MOV  [R1], R1                  ; escreve o valor subtraído nos displays
    MOV  [valor_display_dec], R1
    
    
    POP R5
    POP R4
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


; *****************************************************************************
; INT_NAVE         - Rotina de atendimento da interrupção 3
;			         Interrupção responsável pelo conjunto de luzes no painel
;                    de instrumentos da nave
;
; *****************************************************************************

int_nave:
	MOV	[evento_int_nave], R0	        ; desbloqueia processo responsável pelas
                                        ; luzes da nave (qualquer registo serve) 
	RFE



; *****************************************************************************
; CONVERTE_DECIMAL     - Rotina que converte um valor hexadecimal em decimal
;
; Entrada(s):          R4
;
; Saida(s):            R1
;
; *****************************************************************************

converte_decimal: ;TPC

    PUSH R0
    PUSH R2
    PUSH R3
    PUSH R4

    MOV  R0, FATOR
    MOV  R1, 0          ; resultado
    MOV  R2, DEZ


    espera_converte:
        MOD  R4, R0
        DIV  R0, R2
        ;CMP  R0, R2
        ;JLT  sai_converte_decimal
        CMP  R0, 0
        JZ   sai_converte_decimal
        MOV  R3, R4
        DIV  R3, R0
        SHL  R1, 4
        OR   R1, R3
        JMP  espera_converte

    sai_converte_decimal:
        POP  R4
        POP  R3
        POP  R2
        POP  R0
        RET



; *****************************************************************************
; ACAO_ASTEROIDE - determina qual das cinco ações vai o asteroide tomar 
;
; Entrada(s):     ---
;
; Saida(s):       R0 - coluna inicial do asteroide
;                 R5 - o sentido de movimento inicial da linha do asteroide
;                 R6 - o sentido de movimento inicial da coluna do asteroide
;
; *****************************************************************************
  
acao_asteroide:
    CALL gerar_numero_aleatorio_4  ; gera um número aleatório entre 0 e 4, deste
                                   ; modo é garantido a equiprobabilidade das
                                   ; cinco combinações possíveis de coluna/direção

    CMP  R0, 0
    JZ   acao_0

    CMP  R0, 1
    JZ   acao_1

    CMP  R0, DOIS
    JZ   acao_2

    CMP  R0, TRES
    JZ   acao_3

    CMP  R0, QUATRO
    JZ   acao_4

    acao_0:                     ; caso em que o asteroide aparece no canto superior esquerdo
        MOV  R0, 0              ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, 1              ; o sentido de movimento da coluna deste asteroide
        JMP  sai_acao_asteroide

    acao_1:                     ; caso em que o asteroide aparece no canto superior direito
        MOV  R0, 59             ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, -1             ; o sentido de movimento da coluna deste asteroide
        JMP  sai_acao_asteroide

    acao_2:                     ; caso em que o asteroide aparece no meio e desce na vertical
        MOV  R0, 29             ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, 0              ; o sentido de movimento da coluna deste asteroide
        JMP  sai_acao_asteroide
        
    acao_3:                     ; caso em que o asteroide aparece no meio e desloca-se 45º para a direita
        MOV  R0, 29             ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, 1              ; o sentido de movimento da coluna deste asteroide
        JMP  sai_acao_asteroide

    acao_4:                     ; caso em que o asteroide aparece no meio e desloca-se 45º para a esquerda
        MOV  R0, 29             ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, -1             ; o sentido de movimento da coluna deste asteroide

    sai_acao_asteroide:
        RET


; *****************************************************************************
; INICIA_ASTEROIDE - atribui aos asteroides sequencialmente as possíveis ações
;
; Entrada(s):      R11 - instância do processo
;
; Saida(s):        R0 - coluna inicial do asteroide
;                  R5 - o sentido de movimento inicial da linha do asteroide
;                  R6 - o sentido de movimento inicial da coluna do asteroide
;
; *****************************************************************************

inicia_asteroide:

    CMP  R11, 0
    JZ   inicia_0

    CMP  R11, 1
    JZ   inicia_1

    CMP  R11, DOIS
    JZ   inicia_2

    CMP  R11, TRES
    JZ   inicia_3

    inicia_0:                   ; caso em que o asteroide aparece no canto superior esquerdo
        MOV  R0, 0              ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, 1              ; o sentido de movimento da coluna deste asteroide
        JMP  sai_inicia_asteroide

    inicia_1:                   ; caso em que o asteroide aparece no meio e desloca-se 45º para a esquerda
        MOV  R0, 29             ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, -1             ; o sentido de movimento da coluna deste asteroide; caso em que o asteroide aparece no canto superior direito
        JMP  sai_inicia_asteroide

    inicia_2:                   ; caso em que o asteroide aparece no meio e desce na vertical
        MOV  R0, 29             ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, 0              ; o sentido de movimento da coluna deste asteroide
        JMP  sai_inicia_asteroide
        
    inicia_3:                   ; caso em que o asteroide aparece no meio e desloca-se 45º para a direita
        MOV  R0, 29             ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, 1              ; o sentido de movimento da coluna deste asteroide; caso em que o asteroide aparece no canto superior direito

    sai_inicia_asteroide:
        RET



; *****************************************************************************
; TESTA_LIMITES - Testa se o asteroide chegou aos limites do ecrã e nesse caso
;			      inverte o sentido de movimento
;
; Entrada(s): 	  R1 - linha em que o asteroide está
;
; Saida(s): 	  R7 - indicador que fica a um se o asteroide chegou aos limites do ecrã
;
; *****************************************************************************

testa_limites:
    PUSH    R1
	PUSH	R5
    MOV     R7, 0
    
    testa_limite_inferior:		; vê se o asteroide chegou ao limite inferior do ecrã
        MOV	R5, MAX_LINHA
        DEC R1                  ; decrementar 1 da primeira posição em que 
                                ; o asteroide já desapareceu por completo
        CMP	R1, R5
        JNZ sai_testa_limites   ; se não estava no limite, o R7 mantém-se a 0
        MOV R7, 1

    sai_testa_limites:	
        POP	R5
        POP R1
        RET
	
	
	
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

