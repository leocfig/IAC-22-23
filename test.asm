
DISPLAYS     EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)

PLACE      0

inicio:

MOV  R4, DISPLAYS   ; endereço do periférico dos displays
MOV  R7, 0
MOV  R1, [R4] 
MOV  [R4], R7     ; escreve linha e coluna a zero nos displays
MOV  R7, [R4]

JMP  inicio