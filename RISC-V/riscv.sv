module riscv(
    input  logic        clk_i, reset_i,
    output logic [31:0] ProgAddress_o,
    input  logic [31:0] ProgIn_i,
    output logic        we_o,
    output logic [31:0] DataAddress_o, DataOut_o,
    input  logic [31:0] DataIn_i);
    
    logic       ALUSrc, RegWrite, Jump, Zero, PCSrc;
    logic [1:0] ResultSrc, ImmSrc;
    logic [2:0] ALUControl;
    
    controller c(ProgIn_i[6:0], ProgIn_i[14:12], ProgIn_i[30], Zero,
    ResultSrc, we_o, PCSrc,
    ALUSrc, RegWrite, Jump,
    ImmSrc, ALUControl);
    
    datapath dp(clk_i, reset_i, ResultSrc, PCSrc,
    ALUSrc, RegWrite,
    ImmSrc, ALUControl,
    Zero, ProgAddress_o, ProgIn_i,
    DataAddress_o, DataOut_o, DataIn_i);
endmodule
