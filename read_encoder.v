module Read_Encoder (
    input wire clk,
    input wire rst_n,

    input wire A,
    input wire B,

    output reg [1:0] dir // 00 = Sem movimento, 01 = Horário, 10 = Anti-horário
);

// Sentido horário: 00 → 10 → 11 → 01 → 00
// Sentido anti-horário: 00 → 01 → 11 → 10 → 00

reg[1:0] estadoAnterior;
parameter hor = 2'b01; // Horário
parameter ant = 2'b10; // Anti-horário

always @(negedge rst_n or posedge clk) begin 
    if(!rst_n) begin
        estadoAnterior <= 2'b00;
        dir <= 2'b00;
    end else begin
        case({estadoAnterior, {A,B}}) // Junta os 2 bits do estado anterior com os 2 bits de A e B
            4'b0001, // 00 -> 01
            4'b0111, // 01 -> 11
            4'b1110, // 11 -> 10
            4'b1000: // 10 -> 00
            dir <= ant; // Anti-horário

            4'b0010, // 00 -> 10
            4'b1011, // 10 -> 11
            4'b1101, // 11 -> 01
            4'b0100: // 01 -> 00
            dir <= hor; // Horário

            default:
            dir <= 2'b00; // Sem movimento reconhecido
        endcase
        estadoAnterior <= {A,B}; // Atualiza o estado anterior
    end
end

endmodule
