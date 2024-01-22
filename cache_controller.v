module cache_controller(
    // Inputs/Outputs for interfacing with CPU and main memory
    input clk, input reset, input [31:0] cpu_address, input [31:0] cpu_data_in, 
    input cpu_read, input cpu_write, output reg [31:0] cpu_data_out, 
    output reg cache_hit, output reg [31:0] mem_address, output reg [31:0] mem_data_in, 
    input [31:0] mem_data_out, output reg mem_read, output reg mem_write
);

// Cache configuration parameters
parameter CACHE_SIZE = 256; // Number of cache lines
parameter WORD_SIZE = 32;   // Word size in bits
parameter BLOCK_SIZE = 32;  // Block size in bits

// Cache line structure
typedef struct {
    reg valid;
    reg dirty;
    reg [21:0] tag;
    reg [WORD_SIZE-1:0] data;
} cache_line_t;


// Cache memory declaration
cache_line_t cache [0:CACHE_SIZE-1];

// Address breakdown for cache indexing
wire [21:0] tag = cpu_address[31:10]; // Extract tag from address
wire [7:0] index = cpu_address[9:2];  // Extract index from address
wire [1:0] offset = cpu_address[1:0]; // Extract offset from address

integer i;

// Cache controller logic
always @(posedge clk) begin
    if (reset) {
        for (i = 0; i < CACHE_SIZE; i = i + 1) {
            cache[i].valid = 0;
            cache[i].tag = 0;
            cache[i].data = 0;
            cache[i].dirty = 0; // Reset dirty bit
        }
    }
    else {
        // Cache read operation
        if (cpu_read) {
            if (cache[index].valid && cache[index].tag == tag) {
                // Cache hit
                cache_hit = 1;
                cpu_data_out = cache[index].data;
            } else {
                // Cache miss
                cache_hit = 0;
                if (cache[index].valid && cache[index].dirty) {
                    // Write back dirty cache line to memory
                    mem_address = {cache[index].tag, index}; // Reconstruct full address
                    mem_data_in = cache[index].data;
                    mem_write = 1;
                }
                // Load new data into cache
                cache[index].valid = 1;
                cache[index].tag = tag;
                cache[index].data = mem_data_out;
                cache[index].dirty = 0; // Reset dirty bit
            }
        }
        // Cache write operation
        if (cpu_write) {
            cache[index].data = cpu_data_in;
            cache[index].valid = 1;
            cache[index].tag = tag;
            cache[index].dirty = 1; // Set dirty bit
        }

    end
end

endmodule
