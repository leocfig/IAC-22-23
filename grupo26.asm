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
; - relatório
; - colisões - será que o código está bem?
; - delay de pausa


; **********************************************************************
; * Constantes
; **********************************************************************

; Constantes numéricas

MENOS_CINCO             EQU -5
MENOS_UM                EQU -1
DOIS                    EQU 2
TRES                    EQU 3
QUATRO                  EQU 4
CINCO                   EQU 5
SEIS                    EQU 6
SETE                    EQU 7
DEZ                     EQU 10
CATORZE                 EQU 14
VINTE_CINCO             EQU 25
VINTE_NOVE              EQU 29
TRINTA_DOIS             EQU 32
CINQUENTA_NOVE          EQU 59
SESSENTA_QUATRO         EQU 64
CEM                     EQU 100
DUZENTOS_CINQUENTA_SEIS EQU 256         
CENTO_TRES              EQU 103
CENTO_QUARENTA_QUATRO   EQU 144
FATOR                   EQU 1000        ; uma potência de 10 (para obter os dígitos)
TAMANHO_PILHA           EQU 100H        ; tamanho de cada pilha, em words
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
ATRASO			        EQU	8000H		; atraso para limitar a velocidade de movimento do boneco
N_ASTEROIDES			EQU 4		    ; número de asteroides
N_SONDAS    			EQU 3		    ; número máximo de sondas
ALCANCE_MAX    			EQU 12		    ; número máximo de movimentos das sondas

; Multimédia

VIDEO_COMECO            EQU 0           ; video de comeco corresponde ao primeiro video (video/som numero 0)
VIDEO_JOGO              EQU 1           ; video de fundo enquanto o jogo decorre corresponde ao segundo video (video/som numero 1)
VIDEO_FIM               EQU 2           ; video de fundo enquanto o jogo foi terminado, corresponde ao terceiro video (video/som numero 2)
SOM_DISPARO             EQU 3           ; som do disparo, corresponde ao primeiro som (video/som numero 3)
SOM_ATINGE_MIN          EQU 4           ; som da sonda a atingir um asteroide minerável, corresponde ao segundo som (video/som numero 4)
SOM_ATINGE_NAO_MIN      EQU 5           ; som da sonda a atingir um asteroide não minerável, corresponde ao terceiro som (video/som numero 5)
SOM_FIM                 EQU 6           ; som quando o jogo é terminado, corresponde ao quarto som (video/som numero 6)
SOM_EXPLOSAO            EQU 7           ; som da explosão com a nave, corresponde ao quarto som (video/som numero 7)
SOM_JOGO                EQU 8           ; som do jogo, corresponde ao quinto som (video/som numero 8)
SOM_ENERGIA             EQU 9           ; som que ocorre qunado há a perda de energia, corresponde ao sexto som (video/som numero 9)
SOM_INICIO              EQU 10          ; som do início, antes do começo do jogo, corresponde ao sétimo som (video/som numero 10)

CENARIO_COMECO          EQU 0           ; cenario frontal de comeco corresponde à primeira imagem (imagem numero 0)
CENARIO_PAUSA           EQU 1           ; cenario frontal de pausa corresponde à segunda imagem (imagem numero 1)
ECRA_DERROTA            EQU 2           ; ecra de derrota por colisão, corresponde à terceira imagem (imagem numero 2)
ECRA_SEM_ENERGIA        EQU 3           ; ecra de derrota por falta de energia, corresponde à quarta imagem (imagem numero 3)
CENARIO_FIM             EQU 4           ; cenario frontal de término de jogo corresponde à quinta imagem (imagem numero 4)


; Comandos

COMANDOS				  EQU 6000H			    ; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    		  EQU COMANDOS + 0AH	; endereço do comando para definir a linha
DEFINE_COLUNA   		  EQU COMANDOS + 0CH	; endereço do comando para definir a coluna
DEFINE_PIXEL    		  EQU COMANDOS + 12H	; endereço do comando para escrever um pixel
APAGA_AVISO     		  EQU COMANDOS + 40H	; endereço do comando para apagar o aviso 
                                                ; de nenhum cenário selecionado
APAGA_ECRÃ	 		      EQU COMANDOS + 02H	; endereço do comando para apagar os pixels já desenhados
APAGA_CENARIO 		      EQU COMANDOS + 44H	; endereço do comando para apagar o atual cenario frontal
APAGA_VIDEO_SOM 	      EQU COMANDOS + 68H	; endereço do comando para apagar todos os vídeo/som
SELECIONA_CENARIO_FUNDO   EQU COMANDOS + 42H	; endereço do comando para selecionar uma imagem de fundo
SELECIONA_CENARIO_FRONTAL EQU COMANDOS + 46H	; endereço do comando para exibir algo no ecrã,sobreposto ao que já lá está
SELECIONA_ECRA            EQU COMANDOS + 04H	; endereço do comando para selecionar um ecra
INICIA_VIDEO_SOM          EQU COMANDOS + 5AH	; endereço do comando para iniciar vídeos/sons
REP_VIDEO_SOM             EQU COMANDOS + 5CH	; endereço do comando para reproduzir vídeos/sons em loop
PAUSA_VIDEO_SOM           EQU COMANDOS + 62H    ; endereço do comando para suspender a reprodução de todos os vídeos/sons
CONTI_VIDEO_SOM           EQU COMANDOS + 64H    ; endereço do comando para continuar a reprodução de todos os vídeos/sons
OBTEM_COR_PIXEL           EQU COMANDOS + 10H    ; endereço do comando para obter a cor do pixel na posição corrente
OBTEM_ECRA                EQU COMANDOS + 04H    ; endereço do comando para obter o ecrã atualmente selecionado


; Dimensoes

LARGURA_AST			    EQU	5			; largura do asteroides
ALTURA_AST			    EQU	5			; altura do asteroides
LARGURA_NAVE            EQU 17          ; largura da nave
ALTURA_NAVE             EQU 9           ; altura da nave
LINHA_NAVE              EQU 24          ; linha em que começa a nave
COLUNA_NAVE             EQU 24          ; coluna em que começa a nave
LINHA_NAVE_LUZES        EQU 26          ; linha em que começa a mudança das luzes
COLUNA_NAVE_LUZES       EQU 26          ; coluna em que começa a mudança das luzes
LARGURA_LUZES_NAVE      EQU 13          ; largura das luzes da nave
ALTURA_LUZES_NAVE       EQU 4           ; altura das luzes da nave
COLUNA_SONDA_ESQ        EQU 26          ; coluna em que é dispara a sonda da esquerda
COLUNA_SONDA_MEIO       EQU 32          ; coluna em que é dispara a sonda do meio
COLUNA_SONDA_DIR        EQU 38          ; coluna em que é dispara a sonda da direita
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


; tabela das interrupções:

tab:
    WORD int_mover_asteroide         ; rotina de atendimento da interrupção 0
    WORD int_mover_sonda             ; rotina de atendimento da interrupção 1
    WORD int_energia                 ; rotina de atendimento da interrupção 2
    WORD int_nave                    ; rotina de atendimento da interrupção 3


; variáveis:

evento_int_mover_ast:   LOCK  0		 ; LOCK para a rotina de interrupção comunicar ao processo do asteroide
evento_int_mover_sonda: LOCK  0		 ; LOCK para a rotina de interrupção comunicar ao processo da sonda
evento_int_energia:     LOCK  0		 ; LOCK para a rotina de interrupção comunicar ao processo da energia
evento_int_nave:        LOCK  0		 ; LOCK para a rotina de interrupção comunicar ao processo da nave

tecla_carregada:        LOCK  0	     ; LOCK para o teclado comunicar aos restantes processos que tecla detetou
derrota:                LOCK  0      ; LOOK que indica se o jogo terminou e como terminou:
                                     ; 1 -> colisão; 2 -> energia; 3 -> pausa; 4 -> término do jogo
estado_energia:         WORD  0      ; indica no processo de energia se é necessário reiniciar o processo (0 -> não é necessário; 1 -> necessário)
estado_nave:            WORD  0      ; indica no processo de nave se é necessário reiniciar o processo (0 -> não é necessário; 1 -> necessário)
pausa_teclado:          WORD  0      ; indica se no processo do teclado a tecla D foi premida
termina_teclado:        WORD  0      ; indica se no processo do teclado a tecla E foi premida
pausa_energia:          WORD  0      ; indica ao processo da energia se é necessário ficar em pausa (0 -> não é necessário; 1 -> necessário)
pausa_nave:             WORD  0      ; indica ao processo da nave se é necessário ficar em pausa (0 -> não é necessário; 1 -> necessário)
colisao_sonda_ast:      WORD  4      ; guarda o valor do asteroide que colidiu com uma sonda ou quatro se não colidiu
valor_display:          WORD  0      ; variavel que guarda o valor do display


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


DEF_AST_NAO_MIN_DEST:	; tabela que define o asteroide não minerável depois da colisão
	WORD		        LARGURA_AST, ALTURA_AST
	WORD		        0,      0,      BRANCO, 0,      0
	WORD		        0,      BRANCO, 0,      BRANCO, 0
	WORD		        BRANCO, 0,      BRANCO, 0,      BRANCO
	WORD		        0,      BRANCO, 0,      BRANCO, 0
	WORD		        0,      0,      BRANCO, 0,      0


DEF_AST_MIN_DEST_1:	    ; tabela que define o asteroide minerável depois da colisão
	WORD		        LARGURA_AST, ALTURA_AST
	WORD		        0,     0,     0,     0,     0
	WORD		        0,     VERDE, VERDE, VERDE, 0   
	WORD		        0,     VERDE, VERDE, VERDE, 0
	WORD		        0,     VERDE, VERDE, VERDE, 0  
	WORD		        0,     0,     0,     0,     0


DEF_AST_MIN_DEST_2:	    ; tabela que define o asteroide minerável depois da colisão
	WORD		        LARGURA_AST, ALTURA_AST
	WORD		        0,     0,     0,     0,     0
	WORD		        0,     0,     0,     0,     0   
	WORD		        0,     0,     VERDE, 0,     0
	WORD		        0,     0,     0,     0,     0  
	WORD		        0,     0,     0,     0,     0


DEF_LUZES_NAVE:
    WORD        DEF_NAVE
    WORD        DEF_NAVE_1
    WORD        DEF_NAVE_2
    WORD        DEF_NAVE_3
    WORD        DEF_NAVE_4
    WORD        DEF_NAVE_5
    WORD        DEF_NAVE_6
    WORD        DEF_NAVE_7


DEF_NAVE:		; tabela que define a nave
	WORD		0, 0, 0, 0, 0, 0, 0, 0, CINZENTO_ESCURO,  0, 0, 0, 0, 0, 0, 0, 0
	WORD		0, 0, 0, 0, 0, 0, 0, 0, BRANCO, 0, 0, 0, 0, 0, 0, 0, 0
	WORD		0, 0, LARANJA, 0, 0, 0, 0, BRANCO, AZUL_ESMERALDA, BRANCO, 0, 0, 0, 0, LARANJA, 0, 0
	WORD		0, 0, QUASE_PRETO, 0, 0, 0, 0, CINZENTO_CLARO, AZUL_CLARO, CINZENTO_CLARO, 0, 0, 0, 0, QUASE_PRETO, 0, 0
	WORD		0, 0, CINZENTO_ESCURO, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, AZUL_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, 0, CINZENTO_ESCURO, 0, 0
	WORD		0, BRANCO, CINZENTO_ESCURO, BRANCO, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, BRANCO, CINZENTO_ESCURO, BRANCO, 0
	WORD		CINZENTO_ESCURO, BRANCO, CINZENTO_CLARO, BRANCO, CINZENTO_CLARO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_CLARO, BRANCO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_CLARO, BRANCO, CINZENTO_CLARO, BRANCO, CINZENTO_ESCURO
	WORD		CINZENTO_ESCURO, BRANCO, BRANCO, BRANCO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_CLARO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_CLARO, BRANCO, BRANCO, BRANCO, CINZENTO_ESCURO


DEF_NAVE_1:     ; tabela que define a mudança de luzes na variação 1

    WORD        BRANCO, 0, 0, 0, 0, BRANCO, AZUL_CLARO, BRANCO, 0, 0, 0, 0, BRANCO
    WORD        CINZENTO_ESCURO, 0, 0, 0, 0, CINZENTO_CLARO, AZUL_ESCURO, CINZENTO_CLARO, 0, 0, 0, 0, CINZENTO_ESCURO
    WORD        QUASE_PRETO, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, 0, QUASE_PRETO
    WORD        LARANJA, BRANCO, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, AZUL_ESMERALDA,CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, BRANCO, LARANJA


DEF_NAVE_2:     ; tabela que define a mudança de luzes na variação 2
    WORD        CINZENTO_ESCURO, 0, 0, 0, 0, BRANCO, AZUL_ESCURO, BRANCO, 0, 0, 0, 0, CINZENTO_ESCURO
    WORD        QUASE_PRETO, 0, 0, 0, 0, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_CLARO, 0, 0, 0, 0, QUASE_PRETO
    WORD        LARANJA, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, AZUL_ESMERALDA, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, 0, LARANJA
    WORD        BRANCO, BRANCO, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, AZUL_CLARO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, BRANCO, BRANCO


DEF_NAVE_3:     ; tabela que define a mudança de luzes na variação 3
    WORD        QUASE_PRETO, 0, 0, 0, 0, BRANCO, CINZENTO_ESCURO, BRANCO, 0, 0, 0, 0, QUASE_PRETO
    WORD        LARANJA, 0, 0, 0, 0, CINZENTO_CLARO, AZUL_ESMERALDA, CINZENTO_CLARO, 0, 0, 0, 0, LARANJA
    WORD        BRANCO, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, AZUL_CLARO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, 0, BRANCO
    WORD        CINZENTO_ESCURO, BRANCO, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, AZUL_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, BRANCO, CINZENTO_ESCURO


DEF_NAVE_4:     ; tabela que define a mudança de luzes na variação 4
    WORD        LARANJA, 0, 0, 0, 0, BRANCO, AZUL_ESMERALDA, BRANCO, 0, 0, 0, 0, LARANJA
    WORD        BRANCO, 0, 0, 0, 0, CINZENTO_CLARO, AZUL_CLARO, CINZENTO_CLARO, 0, 0, 0, 0, BRANCO
    WORD        CINZENTO_ESCURO, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, AZUL_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, 0, CINZENTO_ESCURO
    WORD        QUASE_PRETO, BRANCO, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, BRANCO, QUASE_PRETO


DEF_NAVE_5:     ; tabela que define a mudança de luzes na variação 5
    WORD        AZUL_ESMERALDA, 0, 0, 0, 0, BRANCO, LARANJA, BRANCO, 0, 0, 0, 0, AZUL_ESMERALDA
    WORD        AZUL_CLARO, 0, 0, 0, 0, CINZENTO_CLARO, BRANCO, CINZENTO_CLARO, 0, 0, 0, 0, AZUL_CLARO
    WORD        AZUL_ESCURO, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, 0, AZUL_ESCURO
    WORD        CINZENTO_ESCURO, BRANCO, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO,QUASE_PRETO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, BRANCO,  CINZENTO_ESCURO


DEF_NAVE_6:     ; tabela que define a mudança de luzes na variação 6
    WORD        CINZENTO_ESCURO, 0, 0, 0, 0, BRANCO,QUASE_PRETO, BRANCO, 0, 0, 0, 0,  CINZENTO_ESCURO
    WORD        AZUL_ESMERALDA, 0, 0, 0, 0, CINZENTO_CLARO, LARANJA, CINZENTO_CLARO, 0, 0, 0, 0, AZUL_ESMERALDA
    WORD        AZUL_CLARO, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, BRANCO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, 0, AZUL_CLARO
    WORD        AZUL_ESCURO, BRANCO, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, BRANCO, AZUL_ESCURO


DEF_NAVE_7:     ; tabela que define a mudança de luzes na variação 7
    WORD        AZUL_ESCURO, 0, 0, 0, 0, BRANCO, CINZENTO_ESCURO, BRANCO, 0, 0, 0, 0, AZUL_ESCURO
    WORD        CINZENTO_ESCURO, 0, 0, 0, 0, CINZENTO_CLARO,QUASE_PRETO, CINZENTO_CLARO, 0, 0, 0, 0,  CINZENTO_ESCURO
    WORD        AZUL_ESMERALDA, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, LARANJA, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, 0, AZUL_ESMERALDA
    WORD        AZUL_CLARO, BRANCO, 0, 0, CINZENTO_ESCURO, CINZENTO_CLARO, BRANCO, CINZENTO_CLARO, CINZENTO_ESCURO, 0, 0, BRANCO, AZUL_CLARO



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

tipo_asteroide:     ; 0 para asteroides não mineráveis e 1 para asteroides mineráveis
    WORD 0
    WORD 0
    WORD 0
    WORD 0

ecra_asteroide:     ; ecrã onde cada um dos quatro asteroides foi desenhado
    WORD 0
    WORD 1
    WORD 2
    WORD 3

estado_asteroide:   ; variáveis que indicam no processo dos asteroides se é necessário reiniciar o processo
    WORD 0
    WORD 0
    WORD 0
    WORD 0

pausa_asteroide:    ; indica a cada instância dos processos dos asteroides se é 
                    ; necessário ficar em pausa (0 -> não é necessário; 1 -> necessário)
    WORD 0
    WORD 0
    WORD 0
    WORD 0


linha_sonda:   ; linha onde cada uma das sondas está
    WORD LINHA_SONDA_0_2
    WORD LINHA_SONDA_1
    WORD LINHA_SONDA_0_2

coluna_sonda:  ; coluna onde cada uma das sondas está
    WORD COLUNA_SONDA_ESQ
    WORD COLUNA_SONDA_MEIO
    WORD COLUNA_SONDA_DIR

estado_sonda:  ; variáveis que indicam no processo das sondas se é necessário reiniciar o processo
    WORD 0
    WORD 0
    WORD 0
    WORD 0

sentido_movimento_sonda:	; sentido movimento inicial de cada sonda (+1 para a direita ou para baixo, -1 para a esquerda ou para cima)
	WORD -1, -1
	WORD -1, 0
	WORD -1, 1



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
    MOV  R11, N_ASTEROIDES                ; número de asteroides a usar
    MOV  R10, 0
    MOV  R9,  N_SONDAS                    ; número de sondas a usar

    MOV  R3, DISPLAYS                     ; endereço do periférico dos displays
    MOV  [R3], R1                         ; escreve o valor 0 nos displays antes de o jogo ser incializado

    EI0					                  ; permite interrupções 0
    EI1					                  ; permite interrupções 1
    EI2					                  ; permite interrupções 2
    EI3					                  ; permite interrupções 3
    EI                                    ; permite interrupções (geral)

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
    MOV  R4, 1
    MOV  [APAGA_VIDEO_SOM], R4
    MOV  [REP_VIDEO_SOM], R1              ; inicia o vídeo de início
    MOV  [SELECIONA_CENARIO_FRONTAL], R1  ; seleciona o cenário frontal número 0
    CALL som_inicio                       ; reproduz em loop o som do início
    MOV R5, TECLA_INICIO_JOGO
    MOV R6, TECLA_PAUSA_RET_JOGO
    MOV R7, TECLA_TERMINAR_JOGO
    MOV R8, 0
    MOV R9, MENOS_UM

    espera_controlo:
        MOV	R1, [tecla_carregada]	    ; bloqueia neste LOCK até uma tecla ser carregada
        CMP	R1, R5                      ; a tecla carregada é a C?
        JNZ espera_controlo             ; espera até a tecla carregada for a tecla C

    volta_inicio:
    MOV R0, 0
    MOV [derrota], R0
    MOV R2, VIDEO_JOGO
    MOV [APAGA_CENARIO], R2             ; aqui o valor do registo é irrelevante
    MOV [APAGA_VIDEO_SOM], R2           ; aqui o valor do registo é irrelevante
    MOV [REP_VIDEO_SOM], R2             ; reproduz em loop o vídeo do jogo
    CALL som_jogo                       ; reproduz em loop o som do jogo
    MOV  R0, CEM
    MOV  [valor_display], R0            ; inicializar o valor do display
    
    CMP R4, 1
    JNZ jogo_decorre                    ; se R4 for 1, então os processos são criados
    CALL cria_processos

    jogo_decorre:
        MOV R0, 0                       ; tira os processos do modo de pausa
        CALL pausa_proc

    espera_estado:
        MOV R0, [derrota]                   ; fica bloqueado neste LOCK

        CMP R0, 1                           ; se houver derrota por colisão
        JZ  derrota_colisão

        CMP R0, 2                           ; se houver derrota por falta de energia
        JZ  derrota_energia

        CMP R0, 3                           ; se o jogo foi colocado em pausa
        JZ  pausa_jogo

        CMP R0, 4                           ; se o jogo foi terminado
        JZ  termina

        JMP espera_estado

    derrota_colisão:
        MOV R0, ECRA_DERROTA
        MOV [APAGA_ECRÃ], R0
        MOV [APAGA_VIDEO_SOM], R0
        CALL som_explosao
        MOV [SELECIONA_CENARIO_FRONTAL], R0    ; muda o ecrã para o de colisão
        MOV R4, 0                              ; coloca o R4 a 0 para não voltar a criar os processos
        JMP espera_termina_ou_derrota

    derrota_energia:
        MOV R0, ECRA_SEM_ENERGIA
        MOV [APAGA_ECRÃ], R0                   ; aqui o valor do registo é irrelevante
        MOV [APAGA_VIDEO_SOM], R0              ; aqui o valor do registo é irrelevante
        CALL som_energia
        MOV [SELECIONA_CENARIO_FUNDO], R0      ; muda o ecrã para o de sem energia
        MOV  R4, 0                             ; coloca o R4 a 0 para não voltar a criar os processos
        JMP  espera_termina_ou_derrota         

    pausa_jogo:
        MOV R0, 1                              ; coloca os processos do modo de pausa
        CALL pausa_proc
        MOV R0, CENARIO_PAUSA
        MOV [SELECIONA_CENARIO_FRONTAL], R0    ; muda o ecrã para o de pausa
        MOV [PAUSA_VIDEO_SOM], R0              ; pausa-se todos os vídeo/som

        espera_pausa:
            YIELD
            MOV R0, [pausa_teclado]
            CMP R0, 1
            JZ  espera_pausa                   ; só sai daqui quando no teclado o valor da
                                               ; da variável da pausa passa para 0
            MOV R0, [termina_teclado]
            CMP R0, 1
            JZ  termina                        ; se o termina estiver a 1, é para terminar o jogo
                                               ; se o termina estiver a 0, é porque é para despausar
            MOV [APAGA_CENARIO], R0            ; apaga o cenário frontal
            MOV [CONTI_VIDEO_SOM], R0          ; continua a reproduz de todos os vídeos e sons colocados em pausa anteriormente
            JMP jogo_decorre                   ; retoma o jogo

    termina:
        CALL som_fim                           ; reproduz em loop o som do termino do jogo
        MOV  R0, VIDEO_FIM
        MOV [APAGA_ECRÃ], R0                   ; aqui o valor do registo é irrelevante
        MOV [APAGA_VIDEO_SOM], R0              ; aqui o valor do registo é irrelevante
        MOV [REP_VIDEO_SOM], R0                ; inicia o vídeo do fim do jogo
        MOV R0, CENARIO_FIM
        MOV [SELECIONA_CENARIO_FRONTAL], R0    ; coloca o cenário do fim

        espera_termina_ou_derrota:             ; o comportamento esperado pelo utilizado pelo utilizador
                                               ; é o mesmo se ocorrer uma derrota ou um término do jogo
            CALL estados_proc                  ; coloca os estados dos processos a 1
            MOV R4, 8
            CALL obtem_colunas                 ; neste caso, por espera_termina ser um ciclo bloqueante,
                                               ; pode-se chamar uma rotina do teclado sem interferir com 
                                               ; o processo do teclado em si
            JZ  espera_termina_ou_derrota
            CALL obtem_valor_tecla
            MOV R4, 0 
            CMP R2, R5
            JZ  volta_inicio
            JMP espera_termina_ou_derrota

        
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
    MOV  R5, TECLA_PAUSA_RET_JOGO
    MOV  R6, TECLA_TERMINAR_JOGO
    MOV  R9, TECLA_INICIO_JOGO
    
    espera_tecla:                   ; neste ciclo espera-se até uma tecla ser premida
        WAIT				        ; ter um ponto de fuga (aqui pode comutar para outro processo)
        MOV  R0, 0
        MOV  [termina_teclado], R0
        CALL obtem_colunas          ; obtem as colunas da determinada linha
        CMP  R0, 0                  ; há tecla premida?
        JZ   proxima_linha          ; nao havendo tecla premida
        CALL obtem_valor_tecla      ; se houver uma tecla premida, calcula-se o valor da tecla
        MOV  [tecla_carregada], R2  ; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada

        verificar_pausa:
            CMP R2, R5
            JNZ verificar_termino
            MOV R7, [pausa_teclado]
            MOV R8, 1
            SUB R8, R7              ; 1 menos o valor na variável da pausa_teclado é o novo valor da variável pausa_teclado
            MOV [pausa_teclado], R8 ; guarda-se o valor na variável
            CMP R8, 1               ; se esse valor for 1, significa que é para pausar o jogo, e
            JNZ ha_tecla            ; só se for para pausar o jogo é que se vai desbloquear o processo do controlo
            MOV R7, 3
            MOV [derrota], R7       ; desbloqueia os processos que aqui estiverem bloqueados
            JMP ha_tecla

        verificar_termino:
            CMP R2, R6
            JNZ ha_tecla
            MOV R8, 1
            MOV [termina_teclado], R8
            MOV R8, 0
            MOV [pausa_teclado], R8 ; se é para terminar o jogo, já não se está em pausa
            MOV R7, 4
            MOV [derrota], R7       ; desbloqueia os processos que aqui estiverem bloqueados
            JMP ha_tecla

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
    MOV  R1, 0
    MOV  [estado_nave], R1         ; inicializa o valor do estado do processo da nave a 0
    MOV R1, LINHA_NAVE
    MOV R2, COLUNA_NAVE
    MOV R4, DEF_LUZES_NAVE         ; tabela das tabelas dos instrumentos da nave
    MOV R5, LARGURA_NAVE
    MOV R6, ALTURA_NAVE
    MOV R7, R4       
    MOV R8, CATORZE                ; catorze (2 x 7 words) é o necessário para chegar à última tabela
    ADD R7, R8                     ; endereço da última tabela das luzes da nave
                                   ; dentro da tabela das tabelas dos instrumentos da nave
    CALL desenha_nave

    espera_nave:
        
        MOV R9, [evento_int_nave]  ; este processo é aqui bloqueado, e só vai ser
                                   ; desbloqueado com a respetiva rotina de interrupção
        
        YIELD
        MOV  R9, [pausa_nave]
        CMP  R9, 1
        JZ   espera_nave
        
        ADD R4, 2
        MOV R1, LINHA_NAVE_LUZES
        MOV R2, COLUNA_NAVE_LUZES
        MOV R5, LARGURA_LUZES_NAVE
        MOV R6, ALTURA_LUZES_NAVE

        MOV  R0, [estado_nave]     ; coloca o estado do jogo em R0
        CMP  R0, 0                 ; se o estado do jogo não for jogável, repõe-se a nave
        JNZ  nave
        
        CALL desenha_nave          ; produz o efeito das luzes quando a interrupção ocorre

        CMP  R4, R7
        JZ   nave

        JMP  espera_nave


; *****************************************************************************
; Processo
;
; ENERGIA  - Processo responsavel pela implementação do gasto periódico de energia
;
; *****************************************************************************

PROCESS SP_inicial_energia

energia:
    MOV  R2, 0
    MOV  [estado_energia], R2           ; inicializa o valor do estado do processo da energia a 0
    MOV  R2, DUZENTOS_CINQUENTA_SEIS    ; 256 que corresponde a 100H
    MOV  R3, DISPLAYS                   ; endereço do periférico dos displays
    MOV  [R3], R2                       ; escreve o valor 100 nos displays
    MOV  R2, CEM
    MOV  [valor_display], R2

    espera_energia:
        
        MOV  R9, [evento_int_energia]   ; este processo é aqui bloqueado, e só vai ser
                                        ; desbloqueado com a respetiva rotina de interrupção
        YIELD
        MOV  R2, [pausa_energia]
        CMP  R2, 1
        JZ   espera_energia
        MOV  R8, -3

        CALL varia_energia              ; subtrai 3 ao valor do display quando a interrrupção ocorre
        CALL verifica_energia

        MOV  R0, [estado_energia]       ; coloca o estado do jogo em R0
        CMP  R0, 0
        JNZ  energia                    ; se o estado do jogo não for jogável, repõe-se a energia

        JMP espera_energia


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

    MOV R4, ALCANCE_MAX

    espera_tecla_sonda:
        MOV R9, R10			    ; cópia do nº de instância do processo
        SHL R9, 1			    ; multiplica por 2 porque as tabelas são de WORDS
        MOV R11, R9             ; copia o valor do dobro do nº de instância

        MOV	R3, [tecla_carregada]	   ; bloqueia neste LOCK até uma tecla ser carregada

        CMP	R3, R10                    ; a tecla carregada é a correspondente à sonda?
        JZ  continua_sonda
        JMP espera_tecla_sonda         ; se a tecla nao for a correspondente à sonda,
                                       ; espera-se até uma das teclas serem carregadas

    continua_sonda:
        MOV  R1, 0
        MOV  R8, estado_sonda
        MOV  [R8+R11], R1

        MOV  R8, linha_sonda                ; tabela das linhas das sondas
        MOV  R1, [R8+R9]                    ; linha onde está a determinada sonda
                            
        MOV  R7, coluna_sonda               ; tabela das colunas das sondas
        MOV  R2, [R7+R9]		            ; coluna onde está a determinada sonda

        MOV  R8, sentido_movimento_sonda    ; tabela dos sentidos dos movimentos das sondas
        MOV  R5, [R8+R9]                    ; obter o movimento da linha da sonda
        SHL  R9, 1                          ; multiplicar por dois
        ADD  R9, 2                          ; ajustar o valor de R9
        MOV  R6, [R8+R9]                    ; obter o movimento da coluna da sonda

    CALL som_disparo

    MOV  R8, MENOS_CINCO
    CALL varia_energia
    CALL verifica_energia

    MOV  R8, 0                            ; inicializa o contador de movimentos da sonda a 0                  

    espera_sonda:
        CALL desenha_sonda              

        CALL verifica_colisao_sonda       ; verifica se a sonda colidiu com algum asteroide
        CMP  R7, 1                        ; colidiu com algum asteroide?
        JZ   apaga_colisao                ; se sim, apaga-se a sonda

        MOV  R0, [evento_int_mover_sonda] ; este processo é aqui bloqueado, e só vai ser
                                          ; desbloqueado com a respetiva rotina de interrupção
        apaga_colisao:
            CALL apaga_sonda              ; apaga o asteroide na sua posição corrente
            CMP  R7, 1
            JZ   espera_tecla_sonda

        INC  R8                          
        CMP  R8, R4                       ; vê se chegou aos limites do alcance máximo da sonda
        JZ   espera_tecla_sonda           ; se chegou, a sonda desaparece

        MOV  R9, estado_sonda
        MOV  R0, [R9+R11]                 ; coloca o estado do jogo em R0
        CMP  R0, 0
        JNZ  espera_tecla_sonda           ; se o estado do jogo não for jogável, o asteroide desaparece

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
    MOV R7,  QUATRO

    novo_asteroide_seq:             ; usado no início ou reinício do jogo
        MOV  R1, 0
        MOV  R9, estado_asteroide
        MOV  [R9+R10], R1
        CALL inicia_asteroide       ; apenas neste caso inicial é que os asteroides são 
                                    ; distribuídos pelas cinco ações sequencialmente
        JMP  continua_asteroide

    novo_asteroide:
        MOV  R1, 0
        CALL acao_asteroide         ; determina a ação aleatória a tomar pelo asteroide

    continua_asteroide:

        MOV  R9, linha_asteroide    ; tabela das linhas dos asteroides
        MOV  [R9+R10], R1           ; inicializar o valores na tabela da linha do asteroide

        CALL gerar_asteroide        ; determina o tipo do asteroide

        MOV  R9, linha_asteroide    ; tabela das linhas dos asteroides
        MOV  R1, [R9+R10]		    ; linha onde está o determinado asteroide
                            
        MOV  R8, coluna_asteroide   ; tabela das colunas dos asteroides
        MOV  [R8+R10], R2		    ; coluna onde está o determinado asteroide

    verifica_tipo_asteroide:
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
        MOV [R9+R10], R1                ; atualizar os valores na tabela da linha do asteroide
        MOV [R8+R10], R2                ; atualizar os valores na tabela da coluna do asteroide

        CALL desenha_asteroide		    ; desenha o asteroide a partir da tabela, na sua posição atual
        
        CALL verifica_colisao_nave      ; verifica se o asteroide colidiu com a nave

        MOV  R0, [evento_int_mover_ast] ; este processo é aqui bloqueado, e só vai ser
                                        ; desbloqueado com a respetiva rotina de interrupção

        YIELD
        MOV  R3, pausa_asteroide
        MOV  R0, [R3+R10]
        CMP  R0, 1
        JZ   espera_asteroide

        CALL apaga_asteroide     		; apaga o asteroide na sua posição corrente

        MOV  R7, [colisao_sonda_ast]    
        CMP  R7, R11                    ; verifica se a instância deste processo coincide com a instância
                                        ; do asteroide que colidiu com uma sonda
        
        JZ   colisão_sonda              ; se houve colisão, o asteroide não volta a ser desenhado

        CALL testa_limites              ; vê se chegou aos limites do ecrã
        CMP  R7, 1                      ; asteroide saiu do ecrã?
        JZ   novo_asteroide             ; se sim, cria-se um novo asteroide

        MOV  R7, estado_asteroide
        MOV  R0, [R7+R10]               ; coloca o estado do jogo em R0
        CMP  R0, 0
        JNZ  novo_asteroide_seq         ; se o estado do jogo não for jogável, cria-se um novo asteroide

        ADD	R1, R5			            ; para desenhar o asteroide na nova posição
        ADD	R2, R6			        
        JMP espera_asteroide	

        colisão_sonda:
            CALL apaga_asteroide
            MOV  R5, DEF_ASTEROIDE_NAO_MIN
            MOV  R7, QUATRO
            MOV  [colisao_sonda_ast], R7

            CMP R4, R5
            JZ  colisão_não_minerável

            ; se for minerável:
            CALL som_atinge_min
            MOV  R8, VINTE_CINCO
            CALL varia_energia          ; incrementa o valor display em vinte e cinco unidades
            MOV  R4, DEF_AST_MIN_DEST_1
            CALL desenha_asteroide
            CALL atraso
            MOV  R4, DEF_AST_MIN_DEST_2
            CALL desenha_asteroide
            CALL atraso
            CALL apaga_asteroide
            JMP  novo_asteroide

            colisão_não_minerável:
            CALL som_atinge_nao_min
            MOV  R4, DEF_AST_NAO_MIN_DEST
            CALL desenha_asteroide
            CALL atraso
            CALL apaga_asteroide
            JMP  novo_asteroide



; Rotinas

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
; Entrada(s):    R1  - linha
;                R2  - coluna
;                R5  - largura
;                R6  - altura
;                R4  - tabela que define a nave
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
    PUSH R8
    
    MOV R8, R5
    MOV R7, QUATRO 
    MOV [SELECIONA_ECRA], R7      ; seleciona o ecrã 4
    MOV R7, R2
    MOV R4, [R4]

    preenche_linha:
        MOV	 R3, [R4]			  ; obtém a cor do próximo pixel da nave
        CALL escreve_pixel        ; preenche o determinado pixel
        ADD	 R4, 2			      ; endereço da cor do próximo pixel 
                                  ; (2 porque cada cor de pixel é uma word)
        INC  R2                   ; próxima coluna
        DEC  R5 			      ; menos uma coluna para tratar
        JNZ  preenche_linha       ; continua até percorrer toda a largura da nave
        INC  R1                   ; avança-se para a proxima linha
        MOV  R2, R7               ; volta a inicializar a coluna
        SUB  R6, 1                ; menos uma linha para tratar
        MOV  R5, R8               ; volta a inicializar a largura da nave
        JNZ  preenche_linha       ; volta ao preenche_linha até a largura ser 0

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
    MOV  R1, MASCARA_MAIOR   ; para isolar os 4 bits de maior peso
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
    JLT  sai_gerar_numero_aleatorio_4   ; quere-se um número inferir a 5
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
        MOV [R2+R10], R1
        JMP sai_gerar_asteroide

    mineravel:                  ; o asteroide fica minerável
        MOV R1, 1
        MOV [R2+R10], R1

    sai_gerar_asteroide:
        POP R2
        POP R1
        POP R0
        RET


; *****************************************************************************
; VARIA_ENERGIA        - varia a energia da nave
;
; Entrada(s):          R8
;
; Saida(s):            ---
;
; *****************************************************************************

varia_energia:
    PUSH R1
    PUSH R4
    PUSH R5
    
    MOV  R5, DISPLAYS
    MOV  R4, [valor_display]
    ADD  R4, R8
    MOV  [valor_display], R4
    CALL converte_decimal
    MOV  [R5], R1
    
    POP R5
    POP R4
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
; SOM_ATINGE_MIN    - toca o som da sonda a atingir um asteroide minerável
;
; Entrada(s):       ---
;
; Saida(s):         ---
;
; *****************************************************************************

som_atinge_min:
    PUSH R0
    MOV R0, SOM_ATINGE_MIN
    MOV [INICIA_VIDEO_SOM], R0       ; toca o som
    POP R0
    RET


; *****************************************************************************
; SOM_ATINGE_NAO_MIN    - toca o som da sonda a atingir um asteroide não minerável
;
; Entrada(s):           ---
;
; Saida(s):             ---
;
; *****************************************************************************

som_atinge_nao_min:
    PUSH R0
    MOV R0, SOM_ATINGE_NAO_MIN
    MOV [INICIA_VIDEO_SOM], R0       ; toca o som
    POP R0
    RET



; *****************************************************************************
; SOM_INICIO    - toca o som quando o jogo está à espera de ser começado
;
; Entrada(s):   ---
;
; Saida(s):     ---

; *****************************************************************************

som_inicio:
    PUSH R0
    MOV R0, SOM_INICIO
    MOV [INICIA_VIDEO_SOM], R0       ; toca o som
    POP R0
    RET


; *****************************************************************************
; SOM_JOGO      - toca o som quando o jogo está a ocorrer
;
; Entrada(s):   ---
;
; Saida(s):     ---

; *****************************************************************************

som_jogo:
    PUSH R0
    MOV R0, SOM_JOGO
    MOV [REP_VIDEO_SOM], R0       ; toca o som
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
    MOV [REP_VIDEO_SOM], R0       ; toca o som
    POP R0
    RET


; *****************************************************************************
; SOM_ENERGIA   - toca o som quando a nave fica sem energia
;
; Entrada(s):   ---
;
; Saida(s):     ---

; *****************************************************************************

som_energia:
    PUSH R0
    MOV R0, SOM_ENERGIA
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
; ACAO_ASTEROIDE - determina qual das cinco ações vai o asteroide tomar 
;
; Entrada(s):     ---
;
; Saida(s):       R2 - coluna inicial do asteroide
;                 R5 - o sentido de movimento inicial da linha do asteroide
;                 R6 - o sentido de movimento inicial da coluna do asteroide
;
; *****************************************************************************
  
acao_asteroide:

    PUSH R0
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
        MOV  R2, 0              ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, 1              ; o sentido de movimento da coluna deste asteroide
        JMP  sai_acao_asteroide

    acao_1:                     ; caso em que o asteroide aparece no canto superior direito
        MOV  R2, CINQUENTA_NOVE ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, -1             ; o sentido de movimento da coluna deste asteroide
        JMP  sai_acao_asteroide

    acao_2:                     ; caso em que o asteroide aparece no meio e desce na vertical
        MOV  R2, VINTE_NOVE     ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, 0              ; o sentido de movimento da coluna deste asteroide
        JMP  sai_acao_asteroide
        
    acao_3:                     ; caso em que o asteroide aparece no meio e desloca-se 45º para a direita
        MOV  R2, VINTE_NOVE     ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, 1              ; o sentido de movimento da coluna deste asteroide
        JMP  sai_acao_asteroide

    acao_4:                     ; caso em que o asteroide aparece no meio e desloca-se 45º para a esquerda
        MOV  R2, VINTE_NOVE     ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, -1             ; o sentido de movimento da coluna deste asteroide

    sai_acao_asteroide:
        POP R0
        RET


; *****************************************************************************
; INICIA_ASTEROIDE - atribui aos asteroides sequencialmente as possíveis ações
;
; Entrada(s):      R11 - instância do processo
;
; Saida(s):        R2 - coluna inicial do asteroide
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
        MOV  R2, 0              ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, 1              ; o sentido de movimento da coluna deste asteroide
        JMP  sai_inicia_asteroide

    inicia_1:                   ; caso em que o asteroide aparece no meio e desloca-se 45º para a esquerda
        MOV  R2, VINTE_NOVE     ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, -1             ; o sentido de movimento da coluna deste asteroide; caso em que o asteroide aparece no canto superior direito
        JMP  sai_inicia_asteroide

    inicia_2:                   ; caso em que o asteroide aparece no meio e desce na vertical
        MOV  R2, VINTE_NOVE     ; a coluna inicial deste asteroide
        MOV  R5, 1              ; o sentido de movimento da linha deste asteroide
        MOV  R6, 0              ; o sentido de movimento da coluna deste asteroide
        JMP  sai_inicia_asteroide
        
    inicia_3:                   ; caso em que o asteroide aparece no meio e desloca-se 45º para a direita
        MOV  R2, VINTE_NOVE     ; a coluna inicial deste asteroide
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
        JLT sai_testa_limites   ; se não estava no limite, o R7 mantém-se a 0
        MOV R7, 1

    sai_testa_limites:	
        POP	R5
        POP R1
        RET
	

; *****************************************************************************
; VERIFICA_COLISAO_NAVE:   Verifica se houve colisão entre o asteroide e a nave
;
; Entrada(s):              R10 - instância do processo
;
; Saida(s): 	           
;
; *****************************************************************************

verifica_colisao_nave:

    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8

    MOV  R0, LINHA_NAVE
    MOV  R1, LINHA_NAVE_LUZES           ; a linha dos extremos da nave coincide 
                                        ; com a linha inicial das luzes
    MOV  R2, COLUNA_SONDA_ESQ           ; a coluna do extremo da esquerda
    MOV  R3, COLUNA_SONDA_DIR           ; a coluna do extremo da direita

    MOV  R4, linha_asteroide            ; tabela das linhas dos asteroides
    MOV  R5, [R4+R10]                   ; primeira linha do objeto do asteroide
    ADD  R5, QUATRO                     ; para chegar à última linha do asteroide

    MOV  R6, coluna_asteroide           ; tabela das colunas dos asteroides
    MOV  R7, [R6+R10]                   ; primeira coluna do objeto do asteroide
    MOV  R8, R7
    ADD  R8, QUATRO                     ; para chegar à última coluna do asteroide

    CMP  R5, R0                         ; compara a última linha do asteroide
                                        ; com a primeira linha da nave
    JLT  sai_verifica_colisao_nave      ; se não houver colisão, sai da rotina

    CMP  R8, R2                         ; compara a última coluna do asteroide
                                        ; com a coluna do extremo esquerdo
    JLT  sai_verifica_colisao_nave      ; se não houver colisão, sai da rotina

    CMP  R7, R3                         ; compara a primeira coluna do asteroide
                                        ; com a coluna do extremo direito
    JGT  sai_verifica_colisao_nave      ; se não houver colisão, sai da rotina

    JMP  ha_colisao
    
    CMP  R5, R1                         ; compara a última linha do asteroide
                                        ; com a primeira linha dos extremos da nave
    JLT  sai_verifica_colisao_nave      ; se não houver colisão, sai da rotina

    ha_colisao:                         ; se chegar a este ponto, houve colisao
        MOV R1, 1
        MOV [derrota], R1               ; desbloqueia os processos que aqui estiverem bloqueados

    sai_verifica_colisao_nave:
        POP  R8
        POP  R7
        POP  R6
        POP  R5
        POP  R4
        POP  R3
        POP  R2
        POP  R1
        POP  R0
        RET


; *****************************************************************************
; VERIFICA_COLISAO_SONDA: Verifica se houve colisão entre o asteroide e a sonda
;
; Entrada(s):             R1 - linha da sonda
;                         R2 - coluna da sonda
;
; Saida(s): 	          R7 - indicador que fica a um se a sonda colidiu com algum dos asteroides
;
; *****************************************************************************

verifica_colisao_sonda:

    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R8
    PUSH R9
    PUSH R10

    MOV  R3, VERDE
    MOV  R4, VERMELHO
    MOV  R7, 0                                
    MOV  R9, QUATRO

    MOV  [DEFINE_LINHA],  R1		; seleciona a linha
	MOV  [DEFINE_COLUNA], R2		; seleciona a coluna
    MOV  R10, QUATRO

    obtem_cor:
        SUB  R10, 1 
        MOV  [SELECIONA_ECRA], R10   
        MOV  R5, [OBTEM_COR_PIXEL]      ; obtém a cor do pixel

        CMP  R5, R3                     ; se a cor do pixel onde a sonda se encontra for verde,
                                        ; então a sonda colidiu com um asteroide minerável
        JZ   houve_colisao

        CMP  R5, R4                     ; se a cor do pixel onde a sonda se encontra for vermelha,
                                        ; então a sonda colidiu com um asteroide não minerável
        JZ   houve_colisao
        CMP  R10, 0
        JNZ  obtem_cor 
       
    JMP sai_verifica_colisao_sonda

    houve_colisao:
        MOV  R7, 1
        MOV  [colisao_sonda_ast], R10    ; escreve na variável a instância do asteroide
                                         ; em que houve colisão
            
    sai_verifica_colisao_sonda:
    
    POP  R10
    POP  R9
    POP  R8
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET


; *****************************************************************************
; CONVERTE_DECIMAL: Obtem-se um número hexadecimal cujos nibbles (conjuntos de 4
;                   bits) sejam os dígitos do número decimal correspondente
;
; Entrada(s):       R4
;
; Saida(s): 	    R1
;
; *****************************************************************************

converte_decimal:

    PUSH R0
    PUSH R2
    PUSH R3
    PUSH R4
    MOV  R0, FATOR                      ; R0 -> fator: uma potência de 10 (para obter os dígitos)
                                        ; fator a mil pois são três dígitos
    MOV  R1, 0                          ; resultado
    MOV  R2, DEZ

    espera_converte:
        MOD  R4, R0                     ; R4 -> número: o valor a converter nesta iteração
        DIV  R0, R2
        MOV  R3, R4
        DIV  R3, R0                     ; R3 -> dígito
        SHL  R1, 4                      ; desloca, para dar espaço ao novo dígito
        OR   R1, R3                     ; vai compondo o resultado
        CMP  R0, R2                     ; resultado fica com o valor pretendido
        JLT  sai_converte_decimal
        JMP  espera_converte

    sai_converte_decimal:
        POP  R4
        POP  R3
        POP  R2
        POP  R0
        RET


; *****************************************************************************
; CRIA_PROCESSOS:   Cria os processos necessários para o funcionamento do jogo
;
; Entrada(s):       R4
;
; Saida(s): 	    ---
;
; *****************************************************************************

cria_processos:

    PUSH R9
    MOV  R9, N_SONDAS

    CALL energia                        ; cria o processo energia
    CALL nave                           ; cria o processo nave

    loop_asteroides:
        SUB  R11, 1                     ; próximo asteroide
    	CALL asteroide			        ; cria uma nova instância do processo asteroide (o valor de R11 distingue-as)
	    CMP  R11, 0			            ; já se criaram as instâncias todas?
        JNZ	 loop_asteroides		    ; se não, continua

    loop_sondas:                        
        CALL sonda  			        ; cria uma nova instância do processo sonda (o valor de R10 distingue-as)
        INC  R10
        CMP  R10, R9			        ; já se criaram as instâncias todas?
        JNZ	 loop_sondas    		    ; se não, continua

    POP R9
    RET


; *****************************************************************************
; VERIFICA_ENERGIA: Verifica se a energia não chegou ao 0
;
; Entrada(s):       ---
;
; Saida(s): 	    ---
;
; *****************************************************************************

verifica_energia:
    PUSH R0
    PUSH R1

    MOV  R0, [valor_display]
    CMP  R0, 0                       ; se o valor da energia for superior a 0, não há derrota
    JGT  sai_verifica_energia        ; se o valor da energia for inferior ou igual a 0
                                     ; então ocorre derrota por perda de energia
    MOV  R0, DISPLAYS
    MOV  R1, 0
    MOV  [R0], R1                    ; coloca os displays a 0, mesmo que o valor da energia 
                                     ; fosse inferior a 0
    MOV  R1, 2
    MOV  [derrota], R1               ; desbloqueia os processos que aqui estiverem bloqueados

    sai_verifica_energia:
    POP  R1
    POP  R0
    RET


; *****************************************************************************
; ESTADOS_PROC:     Coloca os estados dos processos a 1, para indicar aos
;                   processos que é necessário reiniciar
;
; Entrada(s):       ---
;
; Saida(s): 	    ---
;
; *****************************************************************************

estados_proc:

    PUSH R1

    MOV R1, 1
    MOV [estado_energia], R1
    MOV [estado_nave], R1

    MOV R0, estado_asteroide
    MOV [R0], R1
    ADD R0, 2
    MOV [R0], R1
    ADD R0, 2
    MOV [R0], R1
    ADD R0, 2
    MOV [R0], R1

    MOV R0, estado_sonda
    MOV [R0], R1
    ADD R0, 2
    MOV [R0], R1
    ADD R0, 2
    MOV [R0], R1
    ADD R0, 2
    MOV [R0], R1

    POP R1
    RET


; *****************************************************************************
; PAUSA_PROC:       Coloca os processos em pausa ou despausa, dependendo do 
;                   argumento (0-despausa; 1-pausa)
;
; Entrada(s):       R0
;
; Saida(s): 	    ---
;
; *****************************************************************************

pausa_proc:
    PUSH R1

    MOV [pausa_energia], R0
    MOV [pausa_nave], R0
    MOV R1, pausa_asteroide
    MOV [R1], R0
    ADD R1, 2
    MOV [R1], R0
    ADD R1, 2
    MOV [R1], R0
    ADD R1, 2
    MOV [R1], R0

    POP R1
    RET