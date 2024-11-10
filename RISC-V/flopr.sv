module flopr #(parameter WIDTH = 8)(
    input  logic             clk_i, reset_i,
    input  logic [WIDTH-1:0] d_i,
    output logic [WIDTH-1:0] q_o
    );
    
    always_ff @(posedge clk_i, posedge reset_i)
        if (reset_i) q_o <= 0;
        else         q_o <= d_i;
endmodule