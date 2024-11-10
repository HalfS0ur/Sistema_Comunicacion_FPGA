addi x01, zero, 1
addi x02, zero, 0x20
slli x02, x02, 8
addi x05, zero, 0x20
slli x05, x05, 8 #La direccion de los switches se guarda en x05
addi x02, x02, 0x38 #Carga la dir. del reg de datos
addi x04, x02, -8 #Carga la dir. del reg de control

addi x07, zero, 0x20
slli x07, x07, 8
addi x07, x07, 4
sw x02, 0(x07)

addi x10, zero, 0x20
slli x10, x10, 8
addi x10, x10, 8
sw x02, 0(x10)

REVISA_SEND:
lw x06, 0(x05)
srli x06, x06, 16
beq x06, zero, REVISA_SEND

#Empieza la carga y transmisión de datos
sw x01, 0(x05) #Activa el we de los switches para poner el boton en 0
addi x03, zero, 0x48 #Carga la H
sw x03, 0(x02) #Envia la H al registro de datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_H:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_H

addi x03, zero, 0x65 #Carga la e
sw x03, 0(x02) #Envia la e al reg. datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_E:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_E

addi x03, zero, 0x6C #Carga la l
sw x03, 0(x02) #Envia la e al reg. datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_L:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_L

addi x03, zero, 0x6C #Carga la l
sw x03, 0(x02) #Envia la e al reg. datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_L1:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_L1

addi x03, zero, 0x6F #Carga la o
sw x03, 0(x02) #Envia la e al reg. datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_O:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_O

addi x03, zero, 0x20 #Carga espacio
sw x03, 0(x02) #Envia la e al reg. datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_ESPACIO:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_ESPACIO

addi x03, zero, 0x57 #Carga la w
sw x03, 0(x02) #Envia la e al reg. datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_W:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_W

addi x03, zero, 0x6F #Carga la o
sw x03, 0(x02) #Envia la e al reg. datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_O1:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_O1

addi x03, zero, 0x72 #Carga la r
sw x03, 0(x02) #Envia la e al reg. datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_R:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_R

addi x03, zero, 0x6C #Carga la l
sw x03, 0(x02) #Envia la e al reg. datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_L2:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_L2

addi x03, zero, 0x64 #Carga la d
sw x03, 0(x02) #Envia la e al reg. datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_D:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_D

addi x03, zero, 0x21 #Carga la !
sw x03, 0(x02) #Envia la e al reg. datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_SE:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_SE

addi x03, zero, 0x0D #Carga salto de linea
sw x03, 0(x02) #Envia la e al reg. datos
sw x01, 0(x04) #Envia el send al reg de control
ESPERA_SL:
lw x31, 0(x04) #Carga el dato del registro de control
beq x31, x01, ESPERA_SL