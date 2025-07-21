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
            case({wr_en,rd_en})
                2'b00:count<=count;
                2'b11:count<=count;
                2'b10:count<=count+1;
                2'b01:count<=count-1;
            endcase
    end
    
endmodule
