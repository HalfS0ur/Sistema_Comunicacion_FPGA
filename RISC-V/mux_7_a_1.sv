`timescale 1ns / 1ps

module mux_7_a_1 (
  input logic zero_i,
  input logic [31:0] dato_RAM_i,
  input logic [31:0] dato_switches_i,
  input logic [31:0] dato_LED_i,
  input logic [31:0] dato_7_segmentos_i,
  input logic [31:0] dato_UART_A_i,
  input logic [31:0] dato_UART_B_i,
  input logic [31:0] dato_UART_C_i,
  input logic [6:0] sel_dispositivo_i,
  output logic [31:0] data_o
);

  always @*
    case (sel_dispositivo_i)
      7'b0000000: data_o = zero_i;
      7'b0000001: data_o = dato_RAM_i;
      7'b0000010: data_o = dato_switches_i;
      7'b0000100: data_o = dato_LED_i;
      7'b0001000: data_o =  dato_7_segmentos_i;
      7'b0010000: data_o = dato_UART_A_i;
      7'b0100000: data_o = dato_UART_B_i;
      7'b1000000: data_o = dato_UART_C_i;
      default: data_o = 1'b0; // Default value if none of the above cases match
    endcase

endmodule
