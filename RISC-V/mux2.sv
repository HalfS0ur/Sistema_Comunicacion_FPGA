`timescale 1ns / 1ps

module mux2 #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] d0_i, d1_i,
    input  logic             s_i,
    output logic [WIDTH-1:0] y_o
    );
    
    assign y_o = s_i ? d1_i : d0_i;
endmodule
