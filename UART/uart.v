module uart_tx(
    input clk,
    input reset,
    input start,
    input [7:0] data,

    output reg tx,
    output reg busy
);

reg [1:0] state;        // no one needs to see these internal
reg [2:0] bit_count;    // states in the simulation
reg [7:0] data_reg;

always @(posedge clk)
begin
    if (reset)
    begin
        state <= 2'b00;       // IDLE (state = 0)
        busy <= 0;            // busy is 0
        tx <= 1;              // for UART this means not communicating
        bit_count <= 3'b000;  // didn't start transmitting bits yet
        data_reg <= 8'b0;     // initialize data_reg
    end
    else
    begin
        case(state)

            2'b00: // IDLE
            begin
                busy <= 0;
                tx <= 1;

                if(start)
                begin
                    busy <= 1;
                    data_reg <= data;
                    bit_count <= 3'b000;
                    state <= 2'b01;    // START
                    tx <= 0;
                end
            end

            2'b01: // START
            begin
                busy <= 1;
                tx <= 0;
                state <= 2'b10;        // DATA
            end

            2'b10: // DATA
            begin
                busy <= 1;
                tx <= data_reg[bit_count];

                if (bit_count == 3'd7)
                begin
                    state <= 2'b11;    // STOP
                end
                else
                begin
                    bit_count <= bit_count + 1;
                end
            end
            2'b11: // STOP
            begin
                busy <= 1; // you're not done until IDLE
                tx <= 1;
                state <= 2'b00;   // IDLE
            end
        endcase
    end
end

endmodule