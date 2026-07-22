module uart_tx (
    input clk,              // things we define in TB like here clk = 0 so clk start at 0 (low)
    input reset,
    input start,
    input [7:0] data,           // interesting enough GTKWave keeps this value in hexadecimal

    output reg tx,              // changes with the respective bits being sent in low = 0 and high = 1, note it reads the opposite way when starts with looking at [0] index
    output reg busy             // turns on when start and turns off (goes low) when starts over at IDLE again
);

// internal stuff we do not want to see in GTKWave

reg [7:0] display_reg;      // where we store data like what we defined in tb data = 8'b........ 
reg [2:0] bit_counter;      // keep track of how many bits are sent to tx (helps us move to STOP state)
reg [1:0] state;

// the FSM Process (IDLE, Start, Data, Stop) - its very important to keep my code organized

always @(posedge clk)
begin
    if (reset)      // IDLE
        begin
            state <= 2'b00;
            busy <= 0;
            tx <= 1;
            bit_counter <= 3'b000;
            display_reg <= 8'b0;
        end

    else
        begin
            case (state)    
                2'b00:              // IDLE
                begin
                    busy <= 0;
                    tx <= 1;
                    if (start)      // until not IDLE - data gets stored in display_reg and transitions to START state begins here...
                    begin
                        busy <= 1;
                        tx <= 0;
                        bit_counter <= 3'b000;
                        state <= 2'b01;
                        display_reg <= data;       // load in data
                    end
                end

                2'b01:              // START - we can start transmitting now and move to data. Wonder what that will do...
                begin
                    busy <= 1;
                    tx <= 0;
                    state <= 2'b10;
                end

                2'b10:              // DATA - remember when we stored our data? Now we get to transmit it!
                begin
                    busy <= 1;
                    tx <= display_reg[bit_counter];
                    if (bit_counter == 3'd7)            // checks when all the data is transmitted. If confirmed, we get to move to the next state... the STOP state!!!
                    begin
                        state <= 2'b11;
                    end
                    else                                // this says we're not done transmitted so transmit the next bit
                    begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                2'b11:             // STOP state - prepare to go back to IDLE, no more transmission. Mission Complete - round 2...
                begin
                    busy <= 0;     
                    tx <= 1;
                    state <= 2'b00;
                end
            endcase
        end
    end
endmodule






