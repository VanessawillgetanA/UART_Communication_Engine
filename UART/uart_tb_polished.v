`timescale 1ns/1ps

module uart_tx_tb;

    reg clk;              // signals that I'm going to define very soon
    reg reset;
    reg start;
    reg [7:0] data;

    wire tx;              // things that change as a result of the TB definition
    wire busy;

uart_tx uut(
    .clk(clk),              // assign pin from uart_polished.v (.clk) to the signal (clk) I defined here. Simulation won't work unless I do this
    .reset(reset),
    .start(start),
    .data(data),
    .tx(tx),
    .busy(busy)
);

always
begin                       // we need a clock so this builds it. full clock cycle is 10 time units and ~clk inverts clk each 5 time units
    #5 clk = ~clk;
end

initial
begin                       // this is the important stuff to make our uart_polished.v work
    start = 0;              // definitions (remember I mentioned those earlier?)
    reset = 1;
    clk = 0;
    data = 8'b10101101;

    $dumpfile("bananas.vcd");           // this gives us our GTKWave file name, shows it can be arbitrary haha!
    $dumpvars(0, uart_tx_tb);           // important when we compile and do vvp uart_tx_tb (sound familiar?) gives us all our cool monitor data!

    #10;
    reset = 0;                          // lets us get out of reset
    #10;
    start = 1;                          // lets us start the if(start) part of the other file, AKA lets us escape IDLE
    #10;
    start = 0;                          // lets us move to other states and does not mess up our simulation when we need to start over again

    #120;                             // arbitrary number - I wanted to make sure this simulation had enough time to fully run through
                                        // (although, it was helpful to see it successfully looping again after STOP, shows my code is good)
    $finish;
end


// Check my work (Verifies Time, State, Bit, Tx, Busy states)
// I call this with vvp uart_tx_tb (sound familiar?)
initial
begin
    $monitor(
        "Time=%0t State=%b Bit=%d TX=%b Busy=%b",
        $time,
        uut.state,
        uut.bit_counter,
        tx,
        busy
    );
end
endmodule