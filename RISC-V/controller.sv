`timescale 1ns / 1ps

module controller(
    input  logic [6:0] op_i,
    input  logic [2:0] funct3_i,
    input  logic       funct7b5_i,
    input  logic       Zero_i,
    output logic [1:0] ResultSrc_o,
    output logic       MemWrite_o,
    output logic       PCSrc_o, ALUSrc_o,
    output logic       RegWrite_o, Jump_o,
    output logic [1:0] ImmSrc_o,
    output logic [2:0] ALUControl_o);
    
    logic [1:0] ALUOp;
    logic       Branch;
    
    decoder md(op_i, ResultSrc_o, MemWrite_o, Branch,
    ALUSrc_o, RegWrite_o, Jump_o, ImmSrc_o, ALUOp);
    
    aludec ad(op_i[5], funct3_i, funct7b5_i, ALUOp, ALUControl_o);
    
    assign PCSrc_o = Branch & Zero_i | Jump_o;
endmodule