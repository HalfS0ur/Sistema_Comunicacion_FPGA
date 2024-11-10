`timescale 1ns / 1ps

module debouncer_4_a_1 (
    input logic clk_i,
    input logic botonU_pi,
    input logic botonD_pi,
    input logic botonL_pi,
    input logic botonR_pi,
    output logic boton_debounce_o
);

    parameter CUENTA_DB = 15; //originalmente en 5 mi gente, sigan viendo

    logic [CUENTA_DB-1:0] cuenta = 0;
    logic [3:0] boton_pasado = 4'b1111;
    logic [3:0] boton_debounceado = 4'b1111; // Initialize to 4'b1111

    always @(posedge clk_i) begin
        if (botonU_pi != boton_pasado[0] || botonD_pi != boton_pasado[1] || botonL_pi != boton_pasado[2] || botonR_pi != boton_pasado[3]) begin
            cuenta <= cuenta + 1;
            if (cuenta == (2**CUENTA_DB) - 1) begin
                boton_pasado <= boton_debounceado;
                boton_debounceado <= {botonU_pi, botonD_pi, botonL_pi, botonR_pi};
            end
        end else begin
            cuenta <= 0;
            boton_debounceado <= 4'b1111; // No change in debounce state
        end
    end

    assign boton_debounce_o = (boton_debounceado != 4'b1111);

endmodule
