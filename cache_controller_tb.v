`timescale 1ns / 1ps

module cache_controller_tb;

reg clk, reset;
reg [31:0] cpu_address, cpu_data_in;
reg cpu_read, cpu_write;
wire [31:0] cpu_data_out;
wire cache_hit;
wire [31:0] mem_address, mem_data_in;
wire [31:0] mem_data_out;
wire mem_read, mem_write;

// Instantiate the cache controller
cache_controller uut (
    .clk(clk), 
    .reset(reset), 
    .cpu_address(cpu_address), 
    .cpu_data_in(cpu_data_in), 
    .cpu_read(cpu_read), 
    .cpu_write(cpu_write), 
    .cpu_data_out(cpu_data_out), 
    .cache_hit(cache_hit), 
    .mem_address(mem_address), 
    .mem_data_in(mem_data_in), 
    .mem_data_out(mem_data_out), 
    .mem_read(mem_read), 
    .mem_write(mem_write)
);

// Clock generation
initial begin
    clk = 0;
    forever #10 clk = ~clk; // Generate a clock with 20ns period
end

// Test cases here
initial begin
    // Reset the cache
    reset = 1;
    #20; // Wait for a while
    reset = 0;

    
    // Test cache hit


    // Test cache miss


    // Write-through test


    // Write-back test


    // Tag matching test


    // Sequential read/write test


    // Random access test


    // Edge cases test


  

end

endmodule
