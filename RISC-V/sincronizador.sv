`timescale 1ns / 1ps

module sincronizador(
    input logic clk_i, 
    input logic button_i, 
    output logic button_o 
);

    
    enum logic [2:0] {IDLE, ACTIVE, DONE} state; 
    logic [2:0] pulse_counter; 
    logic button_prev; 

    
    always_ff @(posedge clk_i) begin
        button_prev <= button_i;
    end

    
    always_ff @(posedge clk_i) begin
        case (state)
            IDLE: begin
                if (button_prev == 1'b0 && button_i == 1'b1) begin
                    pulse_counter <= 3'b100; 
                    state <= ACTIVE; 
                end else begin
                    state <= IDLE; 
                end
            end
            ACTIVE: begin
                if (pulse_counter > 3'b000) begin
                    pulse_counter <= pulse_counter - 1; 
                    state <= ACTIVE; 
                end else begin
                    state <= DONE; 
                end
            end
            DONE: begin
                state <= IDLE; 
            end
        endcase
    end

    
    always_comb begin
        button_o = (state == ACTIVE) ? 1'b1 : 1'b0;
    end

endmodule
