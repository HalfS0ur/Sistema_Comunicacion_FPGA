`timescale 1ns / 1ps

module filtro_botones(
    input logic clk_i,
    input logic botonU_pi,
    input logic botonD_pi,
    input logic botonL_pi,
    input logic botonR_pi,
    
    output logic pulso
    );
    
    logic boton_debounce;
    
    debouncer_4_a_1 antirebotes (
        .clk_i(clk_i),
        .botonU_pi(botonU_pi),
        .botonD_pi(botonD_pi),
        .botonL_pi(botonL_pi),
        .botonR_pi(botonR_pi),
        .boton_debounce_o(boton_debounce)
    );
    
    sincronizador sincroniza(
        .clk_i(clk_i),
        .button_i(boton_debounce),
        .button_o(pulso)
    );
endmodule
