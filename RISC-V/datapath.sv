`timescale 1ns / 1ps

module datapath(
    input  logic        clk_i, reset_i,
    input  logic [1:0]  ResultSrc_i,
    input  logic        PCSrc_i, ALUSrc_i,
    input  logic        RegWrite_i,
    input  logic [1:0]  ImmSrc_i,
    input  logic [2:0]  ALUControl_i,
    output logic        Zero_o,
    output logic [31:0] PC_o,
    input  logic [31:0] Instr_i,
    output logic [31:0] ALUResult_o, WriteData_o,
    input  logic [31:0] ReadData_i
    );
    
    logic [31:0] PCNext, PCPlus4, PCTarget;
    logic [31:0] ImmExt;
    logic [31:0] SrcA, SrcB;
    logic [31:0] Result;
    
// next PC logic
    flopr #(32) pcreg(clk_i, reset_i, PCNext, PC_o);
    
    adder pcadd4(PC_o, 32'd4, PCPlus4);
    
    adder pcaddbranch(PC_o, ImmExt, PCTarget);
    
    mux2 #(32) pcmux(PCPlus4, PCTarget, PCSrc_i, PCNext);
    // register file logic
    regfile rf(clk_i, RegWrite_i, Instr_i[19:15], Instr_i[24:20],
    Instr_i[11:7], Result, SrcA, WriteData_o);
    
    extend ext(Instr_i[31:7], ImmSrc_i, ImmExt);
    // ALU logic
    mux2 #(32) srcbmux(WriteData_o, ImmExt, ALUSrc_i, SrcB);
    
    alu alu(SrcA, SrcB, ALUControl_i, ALUResult_o, Zero_o);
    
    mux3 #(32) resultmux( ALUResult_o, ReadData_i, PCPlus4,
    ResultSrc_i, Result);
endmodule