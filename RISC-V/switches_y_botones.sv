`timescale 1ns / 1ps

module switches_y_botones(
    input logic clk_i,
    input logic reset_i,
    input logic we_i,
    input logic pulso_boton_i,
    input logic [15:0] switches_i,
    output logic [31:0] bs_o
);
    
    logic [16:0] registro_bs;
    logic pulso_boton_ff;
    logic pulso_boton_ff_prev;
    
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            registro_bs <= 17'b0;
            pulso_boton_ff <= 1'b0;
            pulso_boton_ff_prev <= 1'b0;
        end 
        
        else begin
            pulso_boton_ff_prev <= pulso_boton_ff;
            if (we_i || reset_i)
                pulso_boton_ff <= 1'b0;
            else if (pulso_boton_i && ~pulso_boton_ff_prev)
                pulso_boton_ff <= 1'b1;
            registro_bs <= {pulso_boton_ff, switches_i};
        end
    end
    
    assign bs_o = {15'b0, registro_bs};
    
endmodule
