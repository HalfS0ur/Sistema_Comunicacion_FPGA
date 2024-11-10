## RISC-V single cycle processor
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

Diagrama de estados del programa: 

![image](https://github.com/EL3313/lab4-1s23-grupo-1/assets/88419042/013733ba-803c-41b0-bd79-703f9f86f239)

Diagrama de flujo del programa:
![Lab 4 ](https://github.com/EL3313/lab4-1s23-grupo-1/assets/110439118/10cc1793-eaac-4731-ac83-84c47c680588)

## Manejador de buses
Para el manejo de los buses que conectan los periféricos con el procesador es necesario desarrollar un decodificador de dispositivos de entrada y salida. Un ejemplo de este decodificador se muestra a continuación:

![image](https://github.com/EL3313/lab4-1s23-grupo-1/assets/124763075/92bb3bd3-b603-4554-8da4-4ee31aea7051)

Basándose en el diseño mostrado previamente, se realizaron modificaciones para adaptar el diseño a la aplicación a desarrollar en el laboratorio:

![image](https://github.com/EL3313/lab4-1s23-grupo-1/assets/124763075/c4a5e4d8-340d-4d22-b64f-8fb0fac18b05)

Cabe mencionar que en el diseño, es necesario tener 7 señales de write enable, una para cada dispositivo I/O.

La tabla de verdad del decodificador de dispositivos es la siguiente:

![image](https://github.com/EL3313/lab4-1s23-grupo-1/assets/124763075/d93a9e07-1ccb-49be-91a7-73161dfd3384)

