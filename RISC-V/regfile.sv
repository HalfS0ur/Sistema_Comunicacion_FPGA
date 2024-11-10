`timescale 1ns / 1ps

module regfile(
    input  logic        clk_i, we3_i,
    input  logic [5:0]  a1_i, a2_i, a3_i,
    input  logic [31:0] wd3_i,
    output logic [31:0] rd1_o, rd2_o
    );
    
    logic [31:0] rf [31:0];
    
    // three ported register file
    // read two ports combinationally (A1/RD1, A2/RD2)
    // write third port on rising edge of clock (A3/WD3/WE3)
    // register 0 hardwired to 0
    always_ff @(posedge clk_i)
        if (we3_i) rf[a3_i] <= wd3_i;
        
    assign rd1_o = (a1_i != 0) ? rf[a1_i] : 0;
    assign rd2_o = (a2_i != 0) ? rf[a2_i] : 0;
endmodule