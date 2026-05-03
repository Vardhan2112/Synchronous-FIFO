`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2025 12:32:53
// Design Name: 
// Module Name: fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo #(parameter DEPTH=8, WIDTH=16)(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [WIDTH-1:0]wr_data,
    output reg [WIDTH-1:0]rd_data,
    output full,
    output empty
    );
    
    reg [2:0]wr_ptr,rd_ptr;
    reg [3:0] count;
    
    assign full=(count==DEPTH);
    assign empty=(count==0);
    
    reg [WIDTH-1:0] fifo[DEPTH-1:0];
    
    //read
    always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            rd_ptr<=0;
        end
        else
        begin
            if(rd_en==1 && !empty)
            begin
                rd_data<=fifo[rd_ptr];
                rd_ptr<=rd_ptr+1; 
            end
        end
    end
    
    //write
    always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            wr_ptr<=0;
        end
        else
        begin
            if(wr_en==1 && !full)
            begin
                fifo[wr_ptr]<=wr_data;
                wr_ptr<=wr_ptr+1;
            end
        end
    end
    
    //count
    always@(posedge clk or negedge rst)
    begin
        if(!rst)
            count<=0;
        else
            case({wr_en && !full,rd_en && !empty})
                2'b00:count<=count;
                2'b11:count<=count;
                2'b10:count<=count+1;
                2'b01:count<=count-1;
            endcase
    end
    
endmodule

//or
/*`timescale 1ns / 1ps

module sync_fifo_oneslot #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 16 
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  wr_en,
    input  wire                  rd_en,
    input  wire [DATA_WIDTH-1:0] data_in,
    
    output reg  [DATA_WIDTH-1:0] data_out,
    output wire                  empty,
    output wire                  full
);

    localparam PTR_WIDTH = $clog2(DEPTH);

    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];
    reg [PTR_WIDTH-1:0]  wr_ptr;
    reg [PTR_WIDTH-1:0]  rd_ptr;

    assign empty = (wr_ptr == rd_ptr);

    assign full  = ((wr_ptr + 1'b1) == rd_ptr);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr   <= 0;
            rd_ptr   <= 0;
            data_out <= {DATA_WIDTH{1'b0}};
        end else begin
            
            // Write Operation
            if (wr_en && !full) begin
                fifo_mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
            end
            
            // Read Operation
            if (rd_en && !empty) begin
                data_out <= fifo_mem[rd_ptr];
                rd_ptr <= rd_ptr + 1'b1;
            end
        end
    end

endmodule

//or
`timescale 1ns / 1ps

module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 16
)(
    input  wire                  clk,
    input  wire                  rst_n,  
    input  wire                  wr_en,
    input  wire                  rd_en,
    input  wire [DATA_WIDTH-1:0] data_in,
    
    output reg  [DATA_WIDTH-1:0] data_out,
    output wire                  empty,
    output wire                  full,
);

.
    localparam PTR_WIDTH = $clog2(DEPTH);

    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];

    reg [PTR_WIDTH:0] wr_ptr;
    reg [PTR_WIDTH:0] rd_ptr;


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr   <= 0;
        end else begin
 
            
            if (wr_en) begin
                if (!full) begin
                    fifo_mem[wr_ptr[PTR_WIDTH-1:0]] <= data_in;
                    wr_ptr <= wr_ptr + 1'b1;
                end
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr    <= 0;
            data_out  <= {DATA_WIDTH{1'b0}};
        end else begin
            if (rd_en) begin
                if (!empty) begin
                    // Read data from memory
                    data_out <= fifo_mem[rd_ptr[PTR_WIDTH-1:0]];
                    rd_ptr <= rd_ptr + 1'b1;
                end
            end
        end
    end


    assign empty = (wr_ptr == rd_ptr);

    assign full = (wr_ptr[PTR_WIDTH] != rd_ptr[PTR_WIDTH]) && 
                  (wr_ptr[PTR_WIDTH-1:0] == rd_ptr[PTR_WIDTH-1:0]);

endmodule
