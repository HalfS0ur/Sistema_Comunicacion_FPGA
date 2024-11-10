`timescale 1ns / 1ps

module decodificador_direcciones(
    input logic we_i,
    input logic [31:0] addr_i,
    
    output logic [6:0] sel_mux_o,
    output logic we_RAM_o,
    output logic we_switches_o,
    output logic we_LED_o,
    output logic we_7_segmentos_o,
    output logic we_UART_A_o,
    output logic we_UART_B_o,
    output logic we_UART_C_o
    );
    
    always_comb begin
        if((addr_i >= 0) && (addr_i <= 32'h0FFC))begin
            sel_mux_o = 7'b0000000; //Una esntrada en el mux que siempre este en 0 cuando accesa ROM
            we_RAM_o  = 0;
            we_switches_o = 0;
            we_LED_o = 0;
            we_7_segmentos_o = 0;
            we_UART_A_o = 0;
            we_UART_B_o = 0;
            we_UART_C_o = 0;
        end
        
        else if((addr_i >= 32'h1000) && (addr_i <= 32'h13FC))begin
            sel_mux_o = 7'b0000001;
            we_RAM_o  = we_i;
            we_switches_o = 0;
            we_LED_o = 0;
            we_7_segmentos_o = 0;
            we_UART_A_o = 0;
            we_UART_B_o = 0;
            we_UART_C_o = 0;
        end
        
        else if((addr_i >= 32'h2000) && (addr_i < 32'h2004))begin
            sel_mux_o = 7'b0000010;
            we_RAM_o  = 0;
            we_switches_o = we_i;
            we_LED_o = 0;
            we_7_segmentos_o = 0;
            we_UART_A_o = 0;
            we_UART_B_o = 0;
            we_UART_C_o = 0;
        end
        
        else if((addr_i >= 32'h2004) && (addr_i < 32'h2008))begin
            sel_mux_o = 7'b0000100;
            we_RAM_o  = 0;
            we_switches_o = 0;
            we_LED_o = we_i;
            we_7_segmentos_o = 0;
            we_UART_A_o = 0;
            we_UART_B_o = 0;
            we_UART_C_o = 0;
        end
        
        else if((addr_i >= 32'h2008) && (addr_i < 32'h200C))begin
            sel_mux_o = 7'b0001000;
            we_RAM_o  = 0;
            we_switches_o = 0;
            we_LED_o = 0;
            we_7_segmentos_o = we_i;
            we_UART_A_o = 0;
            we_UART_B_o = 0;
            we_UART_C_o = 0;
        end
        
        else if(addr_i == 32'h2010) begin
            sel_mux_o = 7'b0010000;
            we_RAM_o  = 0;
            we_switches_o = 0;
            we_LED_o = 0;
            we_7_segmentos_o = 0;
            we_UART_A_o = we_i;
            we_UART_B_o = 0;
            we_UART_C_o = 0;
        end
        
        else if((addr_i >= 32'h2018) && (addr_i < 32'h2020))begin
            sel_mux_o = 7'b0010000;
            we_RAM_o  = 0;
            we_switches_o = 0;
            we_LED_o = 0;
            we_7_segmentos_o = 0;
            we_UART_A_o = we_i;
            we_UART_B_o = 0;
            we_UART_C_o = 0;
        end
        
        else if(addr_i == 32'h2020) begin
            sel_mux_o = 7'b0100000;
            we_RAM_o  = 0;
            we_switches_o = 0;
            we_LED_o = 0;
            we_7_segmentos_o = 0;
            we_UART_A_o = 0;
            we_UART_B_o = we_i;
            we_UART_C_o = 0;
        end
        
        else if((addr_i >= 32'h2028) && (addr_i < 32'h2030))begin
            sel_mux_o = 7'b0100000;
            we_RAM_o  = 0;
            we_switches_o = 0;
            we_LED_o = 0;
            we_7_segmentos_o = 0;
            we_UART_A_o = 0;
            we_UART_B_o = we_i;
            we_UART_C_o = 0;
        end
        
        else if(addr_i == 32'h2030) begin
            sel_mux_o = 7'b1000000;
            we_RAM_o  = 0;
            we_switches_o = 0;
            we_LED_o = 0;
            we_7_segmentos_o = 0;
            we_UART_A_o = 0;
            we_UART_B_o = 0;
            we_UART_C_o = we_i;
        end
        
        else if((addr_i >= 32'h2038) && (addr_i <= 32'h203C))begin
            sel_mux_o = 7'b1000000;
            we_RAM_o  = 0;
            we_switches_o = 0;
            we_LED_o = 0;
            we_7_segmentos_o = 0;
            we_UART_A_o = 0;
            we_UART_B_o = 0;
            we_UART_C_o = we_i;
        end
        
        else begin
            sel_mux_o = 7'b0000000;
            we_RAM_o  = 0;
            we_switches_o = 0;
            we_LED_o = 0;
            we_7_segmentos_o = 0;
            we_UART_A_o = 0;
            we_UART_B_o = 0;
            we_UART_C_o = 0;
        end
    end
endmodule
