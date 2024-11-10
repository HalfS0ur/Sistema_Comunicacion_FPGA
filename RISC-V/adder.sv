`timescale 1ns / 1ps

module adder(
    input  [31:0] a_i, b_i,
    output [31:0] y_o
    );
    
    assign y_o = a_i + b_i;
endmodule