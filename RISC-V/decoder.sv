`timescale 1ns / 1ps

module decoder(
    input  logic [6:0] op_i,
    output logic [1:0] ResultSrc_o,
    output logic       MemWrite_o,
    output logic       Branch_o, ALUSrc_o,
    output logic       RegWrite_o, Jump_o,
    output logic [1:0] ImmSrc_o,
    output logic [1:0] ALUOp_o
    );
    
    logic [10:0] controls;
    
    assign {RegWrite_o, ImmSrc_o, ALUSrc_o, MemWrite_o,
    ResultSrc_o, Branch_o, ALUOp_o, Jump_o} = controls;
    
    always_comb
        case(op_i)
            // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump
            7'b0000011: controls = 11'b1_00_1_0_01_0_00_0; // lw
            7'b0100011: controls = 11'b0_01_1_1_00_0_00_0; // sw
            7'b0110011: controls = 11'b1_xx_0_0_00_0_10_0; // R-type
            7'b1100011: controls = 11'b0_10_0_0_00_1_01_0; // beq
            7'b0010011: controls = 11'b1_00_1_0_00_0_10_0; // I-type ALU
            7'b1101111: controls = 11'b1_11_0_0_10_0_00_1; // jal
            default: controls = 11'bx_xx_x_x_xx_x_xx_x; // ???
        endcase
endmodule