`timescale 1ns/1ps  // define time units and precision

module uart_tx_tb;  // define module

reg clk;            // define our signals (inputs can be initialized by TB)
reg reset;          // (outputs are signals driven by the hardware)
reg start;
reg [7:0] data;

wire tx;
wire busy;

// Instantiate from other module
uart_tx uut(
    .clk(clk),
    .reset(reset),
    .start(start),
    .data(data),
    .tx(tx),
    .busy(busy)
);

// Generate the Clock
always
begin
    #5 clk = ~clk;
end

// Set up the inputs and Simulation Details
initial
begin
    clk = 0;
    reset = 1;
    start = 0;
    data = 8'b10100110;

    $dumpfile("uart_tx.vcd");
    $dumpvars(0, uart_tx_tb);

    #10;
    reset = 0;

    // TODO: Start a transmission
    #10;
    start = 1;

    #10;
    start = 0;

    #100;       
    $finish;
end


// Check my work (Verifies Time, State, Bit, Tx, Busy states)
initial
begin
    $monitor(
        "Time=%0t State=%b Bit=%d TX=%b Busy=%b",
        $time,
        uut.state,
        uut.bit_count,
        tx,
        busy
    );
end
endmodule