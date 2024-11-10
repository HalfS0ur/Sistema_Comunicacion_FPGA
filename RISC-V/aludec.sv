`timescale 1ns / 1ps

module aludec(
    input  logic       opb5_i,
    input  logic [2:0] funct3_i,
    input  logic       funct7b5_i,
    input  logic [1:0] ALUOp_i,
    output logic [2:0] ALUControl_o
    );
    
    logic RtypeSub;
    assign RtypeSub = funct7b5_i & opb5_i; // TRUE for R-type subtract
    
    always_comb
        case(ALUOp_i)
            2'b00: ALUControl_o = 3'b000; // addition
            2'b01: ALUControl_o = 3'b001; // subtraction
        default: 
            case(funct3_i) // R-type or I-type ALU
                    3'b000: 
                        if (RtypeSub) ALUControl_o = 3'b001; // sub
                        else ALUControl_o = 3'b000; // add, addi
                    3'b001: ALUControl_o = 3'b110; // sll, slli
                    3'b010: ALUControl_o = 3'b101; // slt, slti
                    3'b100: ALUControl_o = 3'b100; // xor, xori
                    3'b101: ALUControl_o = 3'b111; // srl, srli
                    3'b110: ALUControl_o = 3'b011; // or, ori
                    3'b111: ALUControl_o = 3'b010; // and, andi
                    default: ALUControl_o = 3'bxxx; // ???
            endcase
        endcase
endmodule