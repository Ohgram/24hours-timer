`timescale 1ns/10ps
module tb();

parameter clk_cyc=10.0;

reg clk,reset,ena;

always #(clk_cyc/2.0)clk=!clk;

initial begin
	clk=1'b0;	reset=1'b1; ena=1'b1;
	@(posedge clk);//持续初始条件到第一个clk的上升沿
	repeat(2)@(posedge clk);//等待两个clk周期
	reset=0;
	repeat(4)@(posedge clk);
	reset=1;
	@(posedge clk);
	reset=0;
end

top_module u1(
	.clk	(clk),
	.reset	(reset),
	.ena	(ena),
	.pm(),
	.hh(),
	.mm(),
	.ss()
);
endmodule/*
module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    wire ena_m,ena_h,ena_pm;

    assign ena_m=(ss==8'b0101_1001)?1'b1:1'b0;
    assign ena_h=((mm==8'b0101_1001)&(ss==8'b0101_1001))?1'b1:1'b0;
    assign ena_pm=((hh==8'b00010010)&(mm==8'b0101_1001)&(ss==8'b0101_1001))?1'b1:1'b0;
        
    pm_not    u1(.clk(ena_pm),.reset(reset),.pm(pm));
    twelve  hour(.clk(clk),.reset(reset),.ena(ena_h),.h(hh));
    sixty	 min(.clk(clk),.reset(reset),.ena(ena_m),.m(mm));
    sixty	 sec(.clk(clk),.reset(reset),.ena(ena),.m(ss));
endmodule
//十二进制计数器（1——12）（增加一个置位到12的端口）
module twelve(
	input clk,
    input reset,
    input ena,
    output [7:0]h);
    wire [3:0]ones,tens;
    wire cout,reset_01,reset_12;
    assign cout=(ones==4'd9)?1'b1:1'b0;
    assign h={tens,ones};    
    assign reset_01=(h==8'b00010010)&&(ena==1'b1);//reset信号应为输入reset信号和[（）进制信号与使能信号的和]相或
    assign reset_12=reset;//reset信号输入时应置位为12（且优先级更高）
    BCD_2 one(.clk(clk),.reset(reset_01),.set(reset_12),.ena(ena),.q(ones));
    BCD_1 ten(.clk(clk),.reset(reset_01),.set(reset_12),.ena(cout),.q(tens));
endmodule
//六十进制计数器
module sixty(
	input clk,
    input reset,
    input ena,
    output  [7:0]m);
    wire [3:0]ones,tens;
    wire set,cout;
	//reg cout1;
	//always@(posedge clk)begin
	//	cout1<=cout;
	//end
    assign set=reset||(m==8'b0101_1001)&&(ena==1'b1);
    assign m={tens,ones};
    assign cout=(ones==4'd9)?1'b1:1'b0;
    BCD one(.clk(clk),.reset(set),.ena(ena),.q(ones));
    BCD ten(.clk(clk),.reset(set),.ena(cout),.q(tens));   
endmodule

//十进制BCD计数器
module BCD(
    input clk,
    input reset,
    input ena,
    output reg[3:0]q);
    always@(posedge clk) begin
        if(reset)
            q<=4'b0000;
        else	if(ena) 
            		if(q>=4'd9)
            			q<=4'd0;
            		else
                		q<=q+1'b1;
        		else
            		q<=q;
    end
endmodule

//十进制置一BCD计数器
module BCD_1(
    input clk,
    input reset,
    input ena,
    input set,
    output reg[3:0]q);
    always@(posedge clk) begin
        if(set)
            q<=4'b0001;
        else    if(ena)
            		if(reset)
            			q<=4'b0;
        			else    if(q>=4'd9)
            					q<=4'd0;
            				else
                				q<=q+1'b1;
                else 
                    q<=q;
    end
endmodule

//十进制置二BCD计数器
module BCD_2(
    input clk,
    input reset,
    input set,
    input ena,
    output reg[3:0]q);
    always@(posedge clk) begin
        if(set)
            q<=4'b0010;
        else    if(ena)
            		if(reset)
            			q<=4'b0001;
        			else    if(q>=4'd9)
            					q<=4'd0;
            				else
                				q<=q+1'b1;
        		else
           			 q<=q;
    end
endmodule
//带复位端的反相器
module pm_not(
	input clk,
    input reset,
    output reg pm);
    always@(posedge clk)begin
        if(reset) 
            pm<=1'b0;
        else 
            pm<= ~pm;
    end
endmodule*/