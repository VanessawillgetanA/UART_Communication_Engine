`timescale 1ns/1ps

module counter_tb;

reg clk;
reg reset;
wire [3:0] count;

// Instantiate the counter from other file
counter uut(
    .clk(clk),
    .reset(reset),
    .count(count)
);

// Generate waveform file
initial begin
    clk = 0; 
    reset = 1; // if clock is 0 then reset is true which means counter = 0000 to start

    $dumpfile("counter.vcd");
    $dumpvars(0, counter_tb);

    #10;
    reset = 0;
    #90;
    $finish;
end

// Generate clock
always
begin
    #5 clk = ~clk; // after 5 time units clk inverts and keeps that value
end

endmodule