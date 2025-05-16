module Encoder (
    input wire clk,
    input wire rst_n,

    input wire horario,
    input wire antihorario,

    output reg A,
    output reg B
);

reg [1:0] estado;

parameter S0 = 2'b00, // 00
          S1 = 2'b01, // 01
          S2 = 2'b10, // 10
          S3 = 2'b11; // 11
    
always @(negedge rst_n or posedge clk) begin 
    if(!rst_n) begin
        estado <= S0;
    end else if (horario && !antihorario) begin // Lógica para movimento horário
        case(estado)
            S0: estado = S2;
            S1: estado = S0;
            S2: estado = S3;
            S3: estado = S1;
            default: estado = S0;
        endcase
    end else if (!horario && antihorario) begin // Lógica para movimento anti-horário
        case(estado)
            S0: estado = S1;
            S1: estado = S3;
            S2: estado = S0;
            S3: estado = S2;
            default: estado = S0;
        endcase
    end
end

always @(*) begin
    A = estado[1]; // A é o bit mais significativo do estado
    B = estado[0]; // B é o bit menos significativo do estado
end

endmodule
