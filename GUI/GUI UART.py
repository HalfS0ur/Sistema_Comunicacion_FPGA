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
        dato = data_in[0] >> 4  # Desplazar los datos para obtener los bits de dato
        direccion = data_in[0] & 0x0F  # Hacer AND para obtener los 4 bits de dirección

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

label_data_received = tk.Label(window, text="Dato recibido: 0x00", font=font)  
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
