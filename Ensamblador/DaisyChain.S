addi a1, zero, 0x20
slli a1, a1, 8
addi x01, zero, 1
and x20, x20, zero	#Contador de datos recibidos
and x21, x21, zero	#Contador de datos consumidos

.eqv 	switches 	0x00
.eqv 	leds		0x04
.eqv 	segmentos	0x08

.eqv	UART_A_ctrl	0x10
.eqv	UART_A_dato1	0x18
.eqv	UART_A_dato2	0x1C

.eqv	UART_B_ctrl	0x20
.eqv	UART_B_dato1	0x28
.eqv	UART_B_dato2	0x2C

.eqv	UART_C_ctrl	0x30
.eqv	UART_C_dato1	0x38
.eqv	UART_C_dato2	0x3C

reposo:
	sw x20, leds(a1)
	#Si se presiona el botón pasa a generacion
	lw x06, switches (a1)
	srli x06, x06, 16
	beq x06, x01, generacion
	#Si el bit new_rx es 1 pasa a procesar 
	#el UART correspondiente
	lw x06, UART_A_ctrl(a1)
	srli x06, x06, 1
	beq x06, x01, procesamiento_A
	
	lw x06, UART_B_ctrl(a1)
	srli x06, x06, 1
	beq x06, x01, procesamiento_B
	
	lw x06, UART_C_ctrl(a1)
	srli x06, x06, 1
	beq x06, x01, procesamiento_C
	#Si no entra ningun dato pasa a reposo
	j reposo
	
generacion:
	lw x06, switches(a1) 		#Carga los switches
	andi x06, x06, 0xFF		#Se usa un andi para solo tener 8 bits
	sw x01, switches(a1)		#Activa el we de los switches para poner el boton en 0
	sw x06, UART_A_dato1(a1)	#Carga el paquete en reg de datos UART A
	sw x06, UART_B_dato1(a1)	#Carga el paquete en reg de datos UART B
	sw x06, UART_C_dato1(a1)	#Carga el paquete en reg de datos UART C
	sw x01, UART_A_ctrl(a1)		#Activa send a reg de control UART A
	sw x01, UART_B_ctrl(a1)		#Activa send a reg de control UART B
	sw x01, UART_C_ctrl(a1)		#Activa send a reg de control UART C
	espera_gen:
		lw x02, UART_A_ctrl(a1) #Carga el dato en reg control UART A
		lw x03, UART_B_ctrl(a1)	#Carga el dato en reg control UART B
		lw x04, UART_C_ctrl(a1)	#Carga el dato en reg control UART C
		#Se hace una and de los 3 datos para revisar que se haya enviado en los 3 puertos
		#Si se enviaron, vuelve a reposo, sino vuelve a cargar los datos
		and x02, x02, x03
		and x02, x02, x04
		beq x02, x01, espera_gen
	j reposo

procesamiento_A:
	addi x20, x20, 1	#Se aumenta contador de datos recibidos
	sw x20, leds(a1)	#Se escribe contador en leds
	lw x07, switches(a1)	#Lee nuevamente los switches
	srli x07, x07, 8	#Corrimiento de 8 a la derecha para leer del sw 8 al 11
	lw s0, UART_A_dato2(a1)#Lee el dato recibido del UART para comparación
	lw s1, UART_A_dato2(a1)#También lee el dato pero no modifica
	andi s0, s0, 0xf	#andi para tener solo los 4 bits menos significativos
	beq x07, s0, consumir	#Si coincide el ID consume sino retransmite
	j retransmitir_A

procesamiento_B:
	addi x20, x20, 1	#Se aumenta contador de datos recibidos
	sw x20, leds(a1)	#Se escribe contador en leds
	lw x07, switches(a1)	#Lee nuevamente los switches
	srli x07, x07, 8	#Corrimiento de 8 a la derecha para leer del sw 8 al 11
	lw s0, UART_B_dato2(a1)#Lee el dato recibido del UART para comparación
	lw s1, UART_B_dato2(a1)#También lee el dato pero no modifica
	andi s0, s0, 0xf	#andi para tener solo los 4 bits menos significativos
	beq x07, s0, consumir	#Si coincide el ID consume sino retransmite
	j retransmitir_B

procesamiento_C:
	addi x20, x20, 1	#Se aumenta contador de datos recibidos
	sw x20, leds(a1)	#Se escribe contador en leds
	lw x07, switches(a1)	#Lee nuevamente los switches
	srli x07, x07, 8	#Corrimiento de 8 a la derecha para leer del sw 8 al 11
	lw s0, UART_C_dato2(a1)#Lee el dato recibido del UART para comparación
	lw s1, UART_C_dato2(a1)#También lee el dato pero no modifica
	andi s0, s0, 0xf	#andi para tener solo los 4 bits menos significativos
	beq x07, s0, consumir	#Si coincide el ID consume sino retransmite
	j retransmitir_C
	
consumir:
	addi x21, x21, 1	#Aumenta contador de datos consumidos
	slli x03, x21, 8	#Corre 8 bits
	srli s1, s1, 4		#Corre el paquete del UART a la derecha para tener solo el dato
	andi s1, s1, 0xf
	add x03, x03, s1	#Paquete a 7 segmentos contador bits 8-15 y dato 0-3
	sw x03, segmentos(a1)	#Guarda el paquete en los displays y vuelve a reposo
	sw zero, UART_A_ctrl(a1)#Limpia registro de control UART A
	sw zero, UART_B_ctrl(a1)#Limpia registro de control UART B
	sw zero, UART_C_ctrl(a1)#Limpia registro de control UART C
	j reposo
	
retransmitir_A:
	sw s1, UART_B_dato1(a1)		#Carga el paquete en reg de datos UART B
	sw s1, UART_C_dato1(a1)		#Carga el paquete en reg de datos UART C
	sw x01, UART_B_ctrl(a1)		#Activa send a reg de control UART B
	sw x01, UART_C_ctrl(a1)		#Activa send a reg de control UART C
	sw zero, UART_A_ctrl(a1)	#Limpia registro de control UART A
	espera_A:
		lw x02, UART_A_ctrl(a1) #Carga el dato en reg control UART B
		lw x03, UART_B_ctrl(a1)	#Carga el dato en reg control UART C
		#Si se enviaron, vuelve a reposo, sino vuelve a cargar los datos
		and x02, x02, x03
		beq x02, x01, espera_A
	j reposo
	
retransmitir_B:
	sw s1, UART_A_dato1(a1)		#Carga el paquete en reg de datos UART A
	sw s1, UART_C_dato1(a1)		#Carga el paquete en reg de datos UART C
	sw x01, UART_A_ctrl(a1)		#Activa send a reg de control UART A
	sw x01, UART_C_ctrl(a1)		#Activa send a reg de control UART C
	sw zero, UART_B_ctrl(a1)	#Limpia registro de control UART B
	espera_B:
		lw x02, UART_A_ctrl(a1) #Carga el dato en reg control UART A
		lw x03, UART_B_ctrl(a1)	#Carga el dato en reg control UART C
		#Si se enviaron, vuelve a reposo, sino vuelve a cargar los datos
		and x02, x02, x03
		beq x02, x01, espera_B
	j reposo
	
retransmitir_C:
	sw s1, UART_A_dato1(a1)		#Carga el paquete en reg de datos UART A
	sw s1, UART_B_dato1(a1)		#Carga el paquete en reg de datos UART B
	sw x01, UART_A_ctrl(a1)		#Activa send a reg de control UART A
	sw x01, UART_B_ctrl(a1)		#Activa send a reg de control UART B
	sw zero, UART_C_ctrl(a1)	#Limpia registro de control UART C
	espera_C:
		lw x02, UART_A_ctrl(a1) #Carga el dato en reg control UART A
		lw x03, UART_B_ctrl(a1)	#Carga el dato en reg control UART B
		#Si se enviaron, vuelve a reposo, sino vuelve a cargar los datos
		and x02, x02, x03
		beq x02, x01, espera_C
	j reposo
