// testbench file

`timescale 1ns/1ps    // define time unit and precision

module and_gate_tb;   // module begins here and contains everything until 'endmodule' at bottom

reg a; // signal 'a' testbench can assign value to
reg b;
wire y;

and_gate uut (        // use AND from other file (compile simultaneously in Icarus so 
                      // this file has direct access to the module in the other file)
                      // uut means **unit under test** and the name is arbitrary 
    .a(a),            // .module_pin(my_signal)
    .b(b),
    .y(y)
);

initial begin  // execute everything inside when simulation starts (like int main())
    $dumpfile("and_gate.vcd");  // create an output file
    $dumpvars(0, and_gate_tb);  // create place to store your signals

    a = 0; b = 0; #10; // apply inputs and wait 10 units of time (here is ns with ps precision #.###)
    a = 0; b = 1; #10;
    a = 1; b = 0; #10;
    a = 1; b = 1; #10;

    $finish; // tells the simulator to stop
end

endmodule