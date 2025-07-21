`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2025 12:44:25
// Design Name: 
// Module Name: tb
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


module tb;

parameter WIDTH=16,DEPTH=8;
    reg clk;
    reg rst;
    
    
    reg wr_en;
    reg rd_en;
    reg [WIDTH-1:0]wr_data;
    wire [WIDTH-1:0]rd_data;
    wire full;
    wire empty;
    
    reg stop;
    
    fifo m(clk,rst,wr_en,rd_en,wr_data,rd_data,full,empty);
    
    initial
    begin
        clk=0;
        forever #5 clk=~clk;
    end
    initial begin
    //clk 	<= 0;
    rst 	<= 0;
    wr_en 	<= 0;
    rd_en 	<= 0;
    stop  	<= 0;

    #4 rst <= 1;
  end
  
    integer k;
    initial
    begin
        #8 wr_en=1;
        for(k=0;k<10;k=k+1)
        begin
            if(full==0)wr_data=k;
            #10;
        end
        #10
        rd_en=1;
        wr_en=0;
        for(k=0;k<10;k=k+1)
        begin
            $display("%d",rd_data);
            #10;
        end
        #10 $finish;
    end

endmodule
