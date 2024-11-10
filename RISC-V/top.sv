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
