// Code your design here
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.02.2021 13:58:28
// Design Name: 
// Module Name: LiftC
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


module LiftC(clk,reset,req_floor,stop,door,Up,Down,y);



    input clk,reset;
    input [3:0] req_floor;
    output reg door=1'b1;
    output reg Up=1'b0;
    output reg Down=1'b0;
    output reg stop=1'b1;

    output [3:0] y;
    reg [3:0] cf=4'b0001 ;

    reg [31:0]clkdiv=32'd0;

    reg [3:0] temp;
    always @(posedge clk)
    begin
        clkdiv <= clkdiv+1;
    end
    always @ (posedge clkdiv[24])
    begin
        temp<=cf;

        if(reset)
            begin
                cf<=4'b0001;
                stop<=1'b1;
                door <= 1'b1;
                Up<=1'b0;
                Down<=1'b0;
            end
        else
            begin
                if((req_floor != 4'b0001) && (req_floor != 4'b0010) && (req_floor != 4'b0100) && (req_floor != 4'b1000)&&(req_floor!=4'b0000) )
                    begin
                        cf<=temp;
                    end
                else
                    begin
                        if(req_floor == 4'b0000)
                            begin
                                cf<=temp;
                            end
                        else if(req_floor < cf )
                            begin
                                cf<=cf >> 1;
                                door<=1'b0;
                                stop<=1'b0;
                                Up<=1'b0;
                                Down<=1'b1;
                            end


                        else if (req_floor > cf)
                            begin
                                cf <= cf << 1;
                                door<=1'b0;
                                stop<=1'b0;
                                Up<=1'b1;
                                Down<=1'b0;
                            end

                        else if(req_floor == cf )
                            begin
                                cf <= req_floor;
                                door<=1'b1;
                                stop<=1'b1;
                                Up<=1'b0;
                                Down<=1'b0;
                            end
                        


                    end


            end
    end

    assign y = cf;

endmodule