# lab4-1s23
Laboratorio 4 - Microcontrolador

## Abreviaturas y definiciones

-> FPGA: Field Programmable Gate Array.

-> RISC-V:  Arquitectura de conjunto de instrucciones (ISA) de código abierto y diseño modular que se utiliza en la construcción de procesadores.

-> UART: Universal asynchronous receiver-transmitter

-> GUI: Interfaz gráfica de usuario


# 1) Uart

## 1.1 Desarrollo:

Para este laboratorio se utilizó una interfaz UART elaborada en el laboratorio #3, por lo que la documentación necesaria de los módulos utilizados para esta parte del laboratorio se encuentran en el repositorio del lab 3 respectivo.

# 2) RISC-V

## 2.1 Desarrollo

Para el desarrollo de los módulos respectivos al microcontrolador RISC-V se utilizaron los códigos de la bibliografía del curso Harrys&Harrys, donde únicamente se cambió la ALU del microcontrolador para que pudiera hacer corrimientos a la izquierda, por el resto todo es igual a la versión del libro.

### Módulo Top

Este bloque se encarga de conectar el UART y demás periféricos al microcontrolador.

#### 1. Encabezado del módulo:

```Systemverilog
module top(
    input  logic         clk_i, 
    input  logic         reset_i,
    input  logic         botonU_pi,
    input  logic         botonD_pi,
    input  logic         botonL_pi,
    input  logic         botonR_pi,
    input  logic         rx_UART_A_i,
    input  logic         rx_UART_B_i,
    input  logic         rx_UART_C_i,
    input  logic  [15:0] switches_pi,
    
    output logic [15:0] leds_o,
    output logic [3:0]  an_o,
    output logic [6:0]  seg_o,
    output logic        tx_UART_A_o,
    output logic        tx_UART_B_o,
    output logic        tx_UART_C_o    
    );
```

#### 2. Parámetros:

Este módulo no posee parámetros.

#### 3. Entradas y salidas:

Entradas:

-> clk_i: Entrada de reloj.

-> reset_i: Entrada de reset.

-> botonU_pi: Botón superior de la FPGA.

-> botonD_pi: Botón inferior de la FPGA.

-> botonL_pi: Botón izquierdo de la FPGA.

-> botonR_pi: Botón derecho de la FPGA.

-> rx_UART_A_i: Linea de datos recibidos de la interfaz UART A.

-> rx_UART_B_i: Linea de datos recibidos de la interfaz UART B.

-> rx_UART_C_i: Linea de datos recibidos de la interfaz UART C.

-> switches_pi: Switches de la FPGA.

Salidas:

-> leds_o: LEDs de la FPGA.

-> an_o: Señal del ánodo de los displays.

-> seg_o: Datos en los displays de sieto segmentos,

-> tx_UART_A_o: Linea de dato enviado de la interfaz UART A.

-> tx_UART_B_o: Linea de dato enviado de la interfaz UART B.

-> tx_UART_C_o: Linea de dato enviado de la interfaz UART C.

#### 4.Criterios de diseño:

Para construir el procesador se necesitan dos unidades principales:
- Datapath: unidad que se encarga de realizar las operaciones lógicas y aritméticas, así como las conexiones entre diversos componentes dentro del módulo.
- Controlador: se encarga de manejar las señales de control de los componentes y decodificadores según la instrucción a ejecutar.

Dentro del controlador se necesitan manejar los multiplexores, registros y extensión de signo, estos dependen de la instrucción que se necesite ejecutar tal y como se muestra a continuación:

![imagen](https://github.com/EL3313/lab4-1s23-grupo-1/assets/39966622/3b43b8ac-265f-4f10-aa22-86b7070bca63)

Además, se necesita un decodificador para indicar a la ALU cuál operación debe ejecutar:

![imagen](https://github.com/EL3313/lab4-1s23-grupo-1/assets/39966622/2e7b186e-c7a7-4c7a-8017-4f89da791b12)

Al unir el datapath con sus respectivos componentes con la unidad de control, luce como el siguiente esquemático:

![imagen](https://github.com/EL3313/lab4-1s23-grupo-1/assets/39966622/5972728a-1dbb-4860-8105-934b8379b43b)

Cabe resaltar que tanto la memoria de datos como de instrucciones son componentes externos, por lo que se deben crear los respectivos canales hacia estos componentes.
Diagrama de flujo del programa:
![Lab 4 ](https://github.com/EL3313/lab4-1s23-grupo-1/assets/110439118/10cc1793-eaac-4731-ac83-84c47c680588)

 Manejador de buses
Para el manejo de los buses que conectan los periféricos con el procesador es necesario desarrollar un decodificador de dispositivos de entrada y salida. Un ejemplo de este decodificador se muestra a continuación:

![image](https://github.com/EL3313/lab4-1s23-grupo-1/assets/124763075/92bb3bd3-b603-4554-8da4-4ee31aea7051)

Basándose en el diseño mostrado previamente, se realizaron modificaciones para adaptar el diseño a la aplicación a desarrollar en el laboratorio:

![image](https://github.com/EL3313/lab4-1s23-grupo-1/assets/124763075/c4a5e4d8-340d-4d22-b64f-8fb0fac18b05)

Cabe mencionar que en el diseño, es necesario tener 7 señales de write enable, una para cada dispositivo I/O.

La tabla de verdad del decodificador de dispositivos es la siguiente:

![image](https://github.com/EL3313/lab4-1s23-grupo-1/assets/124763075/d93a9e07-1ccb-49be-91a7-73161dfd3384)

A continuación se muestra el resto del código:

```Systemverilog
logic [31:0] ProgAddress, ProgIn, DataIn;
    logic        clock;
    logic        write_enable;
    logic        clk_1kHz_o;
    
    //Señales Procesador
    logic [31:0] data_out;
    
    //Señales deco
    logic [6:0] sel_mux_perif;
    logic we_RAM;
    logic we_switches;
    logic we_led;
    logic we_7_seg;
    logic we_UART_A;
    logic we_UART_B;
    logic we_UART_C;
    logic [31:0] direccion_datos;
    
    //Señales mux disp
    logic [31:0] dato_perif;
    logic [31:0] dato_RAM;
    logic [31:0] dato_switches;
    logic [31:0] dato_UART_A;
    logic [31:0] dato_UART_B;
    logic [31:0] dato_UART_C;
    
    //Señales botones/switches
    logic pulso;
    
    // instantiate processor and memories
    clk_wiz_0 clock10MHz(
        .clk_in1    (clk_i),
        .clk_out1   (clock),
        .reset      (reset_i)
    );
    
    riscv rvsingle(
        .clk_i          (clock),
        .reset_i        (reset_i),
        .ProgAddress_o  (ProgAddress),
        .ProgIn_i       (ProgIn),
        .we_o           (write_enable),
        .DataAddress_o  (direccion_datos),
        .DataOut_o      (data_out),
        .DataIn_i       (dato_perif)
    );
    
    ROM imem(
        .a      (ProgAddress >> 2),
        .spo    (ProgIn)
    );
        
    decodificador_direcciones deco_dir(
        .we_i(write_enable),
        .addr_i(direccion_datos),
        .sel_mux_o(sel_mux_perif),
        .we_RAM_o(we_RAM),
        .we_switches_o(we_switches),
        .we_LED_o(we_led),
        .we_7_segmentos_o(we_7_seg),
        .we_UART_A_o(we_UART_A),
        .we_UART_B_o(we_UART_B),
        .we_UART_C_o(we_UART_C)
    );
    
    RAM dmem(
        .clk    (clock),
        .we     (we_RAM),
        .a      (direccion_datos),
        .d      (data_out),
        .spo    (dato_RAM)
    );
    
    switches_y_botones switches(
        .clk_i(clock),
        .reset_i(reset_i),
        .we_i(we_switches),
        .pulso_boton_i(pulso),
        .switches_i(switches_pi),
        .bs_o(dato_switches)
    );
    
    leds leds(
        .clk_i(clock),
        .reset_i(reset_i),
        .we_led_i(we_led),
        .dato_led_i(data_out),
        .leds_o(leds_o)
    );
    
    display_7_segmentos disp_7seg(
        .clk_i(clock),
        .clk_disp_i(clk_1kHz_o),
        .reset_i(reset_i),
        .dato_i(data_out),
        .we_i(we_7_seg),
        .an_o(an_o),
        .seg_o(seg_o)
    );
    
    interfaz_periferico_UART UART_A(
        .clk_i(clock),
        .rst_i(reset_i),
        .entrada_i(data_out),
        .rx(rx_UART_A_i),
        .reg_sel_i(direccion_datos [3]),
        .wr_i(we_UART_A),
        .tx(tx_UART_A_o),
        .salida_o(dato_UART_A),
        .addr_i(direccion_datos [2])
    );
    
    interfaz_periferico_UART UART_B(
        .clk_i(clock),
        .rst_i(reset_i),
        .entrada_i(data_out),
        .rx(rx_UART_B_i),
        .reg_sel_i(direccion_datos [3]),
        .wr_i(we_UART_B),
        .tx(tx_UART_B_o),
        .salida_o(dato_UART_B),
        .addr_i(direccion_datos [2])
    );
    
    interfaz_periferico_UART UART_C(
        .clk_i(clock),
        .rst_i(reset_i),
        .entrada_i(data_out),
        .rx(rx_UART_C_i),
        .reg_sel_i(direccion_datos [3]),
        .wr_i(we_UART_C),
        .tx(tx_UART_C_o),
        .salida_o(dato_UART_C),
        .addr_i(direccion_datos [2])
    );
    
    mux_7_a_1 mux_perifericos(
        .zero_i(0),
        .dato_RAM_i(dato_RAM),
        .dato_switches_i(dato_switches),
        .dato_LED_i(0),
        .dato_7_segmentos_i(0),
        .dato_UART_A_i(dato_UART_A),
        .dato_UART_B_i(dato_UART_B),
        .dato_UART_C_i(dato_UART_C),
        .sel_dispositivo_i(sel_mux_perif),
        .data_o(dato_perif)
    );
    
    filtro_botones acondicionamiento(
        .clk_i(clock),
        .botonU_pi(botonU_pi),
        .botonD_pi(botonD_pi),
        .botonL_pi(botonL_pi),
        .botonR_pi(botonR_pi),
        .pulso(pulso)
    );
    
    clk_7_segmentos reloj_soporte (
        .clk_i(clock),
        .reset_i(reset_i),
        .clk_1kHz_o(clk_1kHz_o)
    );
                    
endmodule
```
Se instancian:

-> clk_wiz_0

-> riscv

-> ROM

-> decodificador_direcciones

-> RAM

-> switches_y_botones

-> leds

-> display_7_segmentos

-> interfaz_periferico_UART

-> mux_7_a_1

-> filtro_botones

-> clk_7_segmentos

# 3) Ensamblador

Para la parte de ensamblador se realizó un código para poder ingresar el archivo .coe en la memoria rom del microprocesador que pudiera manipular distintos periféricos, tales como interruptores, LEDs, displays y tres interfaces UARTs, con tal que pudiera recibir y enviar datos.

## Inicialización del Código:

Se inicializan los registros a utilizar y se establecen constantes que representan las distintas direcciones de memoria de los periféricos.

```Ensamblador
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
```
## Reposo:
El estado de los LEDs se actualiza.

Si se presiona un interruptor, el programa entra en la fase de generación.

Si los UARTs A, B o C tienen datos nuevos para procesar, el programa entra en una fase de procesamiento específica para ese UART.

Si no se cumple ninguna de las condiciones anteriores, el programa vuelve al estado de reposo.

```Ensamblador
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
```

## Generación
Los datos de los interruptores se envían a través de los UARTs A, B, y C.

El programa entra en un bucle de espera hasta que se envían los datos a través de los tres UARTs.

Luego, el programa vuelve al estado de reposo.

```Ensamblador
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
```
## Procesamiento
Este se repite 3 veces, ya que se ocupa procesar datos en cada una de las FPGA´s

El contador de datos recibidos se incrementa y se muestra en los LEDs.

El programa lee los datos de los interruptores y los compara con los datos recibidos de los UARTs.

Si los datos coinciden, el programa entra en la fase de consumir, de lo contrario, entra en la fase de retransmitir.
```Ensambladaor
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
```

## Consumir:
El contador de datos consumidos se incrementa.

Se prepara un paquete de datos para los segmentos del display y se escribe en los segmentos del display.

Se limpian los registros de control de los UARTs.

Luego, el programa vuelve al estado de reposo.

```Ensamblador
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
```

## Retransmitir

En este caso al igual que con el de procesamiento, también se repite 3 veces, uno para cada UART disponible.

Los datos se retransmiten a través de los otros dos UARTs.

El programa entra en un bucle de espera hasta que se envían los datos a través de los otros dos UARTs.

Luego, el programa vuelve al estado de reposo.

```Ensamblador
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
```
# 4) GUI
A continuación se mencionan ciertos detalles de la GUI a utilzar para poder observar la comunicación entre las FPGA´s y una computadora.

Primero, se importan varias librerías que se utilizan en el código:

serial: esta librería se utiliza para la comunicación a través del puerto serie.

threading: se utiliza para crear un hilo independiente para leer datos del puerto serie.

tkinter: es una librería para crear interfaces gráficas de usuario.

PIL (Python Imaging Library): se utiliza para manipular imágenes, que se utilizan en los botones en la interfaz de usuario.

pygame: se utiliza para reproducir sonidos en respuesta a las acciones del usuario.

Luego, se inicializa la comunicación serie con el dispositivo conectado al puerto COM6 y se configura la velocidad de transmisión (baudrate) en 9600.

A continuación, el programa define varias funciones:

send_data(): Recoge los datos ingresados por el usuario en la interfaz gráfica de usuario, los convierte en un formato que puede ser enviado a través del puerto serie, y envía los datos al dispositivo. Actualiza la interfaz de usuario para mostrar el dato enviado y el número total de datos enviados.

clear_data(): Borra los datos ingresados por el usuario en la interfaz de usuario y reproduce un sonido.

read_serial_data(): Esta función, que se ejecuta en su propio hilo, lee continuamente datos del dispositivo a través del puerto serie. Divide los datos entrantes en dos partes, reproduce un sonido específico dependiendo de los datos, y actualiza la interfaz de usuario para mostrar los datos recibidos.

move_to_next_box(): Esta función se utiliza para manejar el movimiento del cursor entre las cajas de entrada en la interfaz de usuario, dependiendo de la entrada del usuario.

start_serial_communication(): Esta función inicia el hilo que lee datos del dispositivo.

Las funciones play_sound(), play_send_sound(), play_clear_sound(), play_receive_sound(), y play_consume_sound(): Estas funciones utilizan pygame para reproducir diferentes sonidos en respuesta a las acciones del usuario.

on_image_click(): Esta función se ejecuta cuando el usuario hace clic en una imagen en la interfaz de usuario. Envía los datos ingresados por el usuario y reproduce un sonido.

Después de definir estas funciones, el programa crea una interfaz de usuario con tkinter. La interfaz de usuario incluye un título, varias cajas de texto para la entrada de datos, botones con imágenes para enviar y borrar los datos, y varias etiquetas que muestran los datos enviados y recibidos y otros datos relevantes.

Finalmente, el programa inicia la comunicación serie y lanza la interfaz de usuario.

A continuación el Código completo:
```Python
import serial
import threading
import tkinter as tk
from tkinter import ttk
from tkinter.font import Font
from PIL import Image, ImageTk
import pygame

ser = serial.Serial("COM6")  # Abrir el puerto COM6
ser.baudrate = 9600  # Definir baud rate a 9600

datos_recibidos = 0
datos_consumidos = 0
total_datos_enviados = 0

def send_data():
    global total_datos_enviados

    data_str = ""
    for entry in entry_boxes:
        data_str += entry.get()  # Tomar el dato de cada cuadrito

    data_int = int(data_str, 2)  # Convertir la entrada a entero
    data_out = bytes([data_int])  # Convertir el int a bytes

    ser.write(data_out)  # Enviar el dato
    num_datos_enviados = len(data_out)  # Contar el número de bytes enviados
    total_datos_enviados += num_datos_enviados  # Actualizar el contador total

    label_data_sent.config(text="Dato enviado: " + hex(data_int))
    label_datos_enviados.config(text="Datos enviados: " + str(total_datos_enviados))

def clear_data():
    for entry in entry_boxes:
        entry.delete(0, tk.END)  # Borrar el contenido de las cajas

    play_clear_sound()

def read_serial_data():
    global datos_recibidos, datos_consumidos

    while True:
        data_in = ser.read(1)  # Leer los 8 bits entrantes
        datos_recibidos += 1

        # Separar la entrada de 8 bits en 2 entradas de 4 bits
        dato = data_in[0] >> 4  # Shift the 8-bit data to the right by 4 bits to get the first 4 bits
        direccion = data_in[0] & 0x0F  # Use bitwise AND with 0x0F to get the last 4 bits

        if direccion == 0:
            datos_consumidos += 1
            play_consume_sound()
        else:
            play_receive_sound()

        label_data_received.config(text="Dato recibido: " + hex(data_in[0]))
        label_dato.config(text="Dato: " + hex(dato))
        label_direccion.config(text="Direccion: " + hex(direccion))
        label_datos_recibidos.config(text="Datos recibidos: " + str(datos_recibidos))
        label_datos_consumidos.config(text="Datos consumidos: " + str(datos_consumidos))

def move_to_next_box(event, index):
    current_entry = entry_boxes[index]
    current_text = current_entry.get()

    if current_text == '0' or current_text == '1' or event.keysym == 'BackSpace':
        if event.keysym == 'BackSpace' and index > 0 and current_text == '':
            entry_boxes[index - 1].focus()
        elif event.keysym != 'BackSpace' and current_text != '':
            current_entry.tk_focusNext().focus()

def start_serial_communication():
    serial_thread = threading.Thread(target=read_serial_data)
    serial_thread.start()

def play_sound(sound_file):
    pygame.mixer.init()
    pygame.mixer.music.load(sound_file)
    pygame.mixer.music.play()
    pygame.mixer.music.fadeout(2000)

def play_send_sound():
    sound_file = "siganviendo.mp3"
    play_sound(sound_file)

def play_clear_sound():
    sound_file = "woo.mp3"
    play_sound(sound_file)

def play_receive_sound():
    sound_file = "recibido.mp3"
    play_sound(sound_file)

def play_consume_sound():
    sound_file = "consumir.mp3"
    play_sound(sound_file)

def on_image_click():
    send_data()
    play_send_sound()

# Crear la ventana
window = tk.Tk()
window.title("GUI UART")
window.geometry("600x400")

# Importar la imagen
image = Image.open("imagen.png")
image = image.resize((150, 95))
photo = ImageTk.PhotoImage(image)

imageBorr = Image.open("salute.png")
imageBorr = imageBorr.resize((150, 95))
photoBorr = ImageTk.PhotoImage(imageBorr)

# Definir la letra
font = Font(family="Comic Sans MS", size=18)

title_label = tk.Label(window, text="CompuMundoHiperMegaRed", font=("Comic Sans MS", 20, "bold"))
title_label.grid(row=0, column=3, columnspan=8, sticky="N")

# Crear los elementos de la GUI
label_instruction = tk.Label(window, text="Dato a enviar:", font=font)

entry_boxes = []
for i in range(9):
    if i == 0:
        empty_label = tk.Label(window, text="", font=font)
        empty_label.grid(row=1, column=i)
    else:
        entry = tk.Entry(window, width=3, justify='center', font=font)
        entry.grid(row=1, column=i, sticky="NSEW")
        entry.bind('<KeyRelease>', lambda event, index=i - 1: move_to_next_box(event, index))
        entry_boxes.append(entry)

button_send = tk.Button(window, image=photo, command=on_image_click, bd=0, relief=tk.FLAT)
button_send.grid(row=3, column=0, columnspan=8, sticky="W")

button_clear = tk.Button(window, image=photoBorr, command=clear_data, bd=0, relief=tk.FLAT)
button_clear.grid(row=3, column=5, columnspan=8)

label_data_sent = tk.Label(window, text="Dato enviado:", font=font)
label_data_sent.grid(row=6, column=0, columnspan=8, sticky="W")

label_data_received = tk.Label(window, text="Dato recibido: 0x00", font=font)  # Default value is 0x00
label_data_received.grid(row=4, column=8, columnspan=8, sticky="E")

label_dato = tk.Label(window, text="Dato:", font=font)
label_dato.grid(row=5, column=8, columnspan=8, sticky="E")

label_direccion = tk.Label(window, text="Direccion:", font=font)
label_direccion.grid(row=6, column=8, columnspan=8, sticky="E")

label_datos_enviados = tk.Label(window, text="Datos enviados:", font=font)
label_datos_enviados.grid(row=7, column=0, columnspan=8, sticky="W")

label_datos_recibidos = tk.Label(window, text="Datos recibidos:", font=font)
label_datos_recibidos.grid(row=7, column=8, columnspan=8, sticky="E")

label_datos_consumidos = tk.Label(window, text="Datos consumidos:", font=font)
label_datos_consumidos.grid(row=9, column=8, columnspan=8, sticky="E")

# Iniciar la comunicacion serial
start_serial_communication()

# Iniciar tkinter
window.mainloop()


```
# 5. Funcionalidad
En las siguientes imágenes se presenta el sistema funcionando en varias FPGAs. También, se puede observar la GUI em funcionamiento. 
![image](https://github.com/EL3313/lab4-1s23-grupo-1/assets/110439118/a7d8a260-7edf-4b7b-bb6a-9181d33a46b2)
![image](https://github.com/EL3313/lab4-1s23-grupo-1/assets/110439118/8730a715-52fc-478e-ac87-4f54e7bb54e6)
![image](https://github.com/EL3313/lab4-1s23-grupo-1/assets/110439118/ef71afff-0d7c-4fe7-b375-2961769289f2)

