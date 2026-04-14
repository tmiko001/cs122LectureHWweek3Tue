`timescale 1ns / 1ps

`include "shift_register.sv"

module testbench();

// Signals for UUT connection
reg Clk;
reg data;
reg rst = 0;
reg wr_en;
wire [31:0] out_msb;
wire [31:0] out_lsb;
reg pass;

// Instantiate the unit under test
shift_register #(.DIRECTION(1)) uut_MSB (Clk, rst, data, wr_en, out_msb);
shift_register #(.DIRECTION(0)) uut_LSB (Clk, rst, data, wr_en, out_lsb);

initial begin
    // Set up output to VCDD file
    $dumpfile("tb.vcd");
    $dumpvars(0, testbench);

    // Initialize testbench variables
    pass = 1'b1;

    // Simulate the clock signal
    Clk = 1'b0;
    forever begin
        #10 Clk = ~Clk;
    end
end

// Test Stimulus
task reset(input r);
    @(negedge Clk);
    rst <= r;
    @(posedge Clk);
endtask

task shift_in_bit(input d, we);
    @(negedge Clk);
    data <= d;
    wr_en <= we;
    @(posedge Clk);
endtask

task test_MSB();
begin
    reset(1'b1);
    reset(1'b0);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    #15;
    wr_en = 1'b0;
    pass &= out_msb == 32'h9AA90000;
end
endtask

task test_LSB();
begin
    reset(1'b1);
    reset(1'b0);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    shift_in_bit(1'b1, 1'b1);
    shift_in_bit(1'b0, 1'b1);
    #15;
    wr_en = 1'b0;
    pass &= out_lsb == 32'h8D3A;
end
endtask

// Write Checker
initial begin

    @(negedge Clk); test_MSB();

    @(negedge Clk); test_LSB(); 

    if (pass) begin
        $display("Tests Passed!");
    end else begin
        $display("Failed tests");
    end

    $finish();
end

endmodule
