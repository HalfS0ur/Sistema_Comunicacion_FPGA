`timescale 1ns / 1ps

module leds(
    input logic clk_i,
    input logic reset_i,
    input logic we_led_i,
    input logic [31:0] dato_led_i,
    output logic [15:0] leds_o
);
    
    logic [15:0] registro_leds;
    
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            registro_leds <= 15'b0;
        end 
        
        else begin
            if (we_led_i) begin
                registro_leds <= dato_led_i[15:0];
            end
        end
    end
    
    assign leds_o = registro_leds;
    
endmodule