`timescale 1ns / 1ps

module mux3 #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] d0_i, d1_i, d2_i,
    input  logic [1:0]       s_i,
    output logic [WIDTH-1:0] y_o
    );
    
    assign y_o = s_i[1] ? d2_i : (s_i[0] ? d1_i : d0_i);
endmodule
