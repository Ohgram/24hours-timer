module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
	reg [3:0]s_low,s_high;
	wire reset_s;
	reg [3:0]m_low,m_high;
	wire reset_m,ena_m;
	reg [3:0]h_low,h_high;
	wire reset_h,ena_h;
	//秒
	assign ss={s_high,s_low};
	//当秒记到59时下一个clk周期复位为00
	assign reset_s=reset||((ss==8'b0101_1001)&&ena);
	always@(posedge clk)begin
		if(reset_s)begin//复位使秒为00
			s_high<=4'b0;
			s_low<=4'b0;
		end
		else	
			if(ena)	begin
				//当秒的个位记到9下一个clk周期十位进一且个位归零
				if(ena&&(s_low==4'b1001))begin
					s_low<=4'b0;
					s_high<=s_high+1'b1;
				end
				else
					s_low<=s_low+1'b1;
			end
			else begin
				s_high<=s_high;
				s_low<=s_low;
			end
	end
	//分
	assign mm={m_high,m_low};
	//当秒记到59且分也记到59时下一个clk周期复位为00
	assign reset_m=reset||((mm==8'h59)&&(ss==8'h59)&&ena);
	//分的使能信号应该为秒记到59
	assign ena_m=(ss==8'b0101_1001);
	always@(posedge clk)begin
		if(reset_m)begin//复位使分为00
			m_high<=4'b0;
			m_low<=4'b0;
		end
		else
			if(ena_m)
				//当分的个位记到9下一个clk周期十位进一且个位归零
				if(m_low==4'b1001)begin
					m_low<=4'b0;
					m_high<=m_high+1'b1;
				end
				else
					m_low<=m_low+1'b1;
			else begin
				m_high<=m_high;
				m_low<=m_low;
			end
	end
	//时
	assign hh={h_high,h_low};
	assign reset_h=reset;
	//时的使能信号应该为秒和分都记到59
	assign ena_h=(ss==8'h59)&&(mm==8'h59);
	always@(posedge clk)begin
		if(reset_h)begin
			h_high<=4'b0001;
			h_low<=4'b0010;
		end
		else if(ena_h)
				//当时记到12后下个clk周期变为01
				if((h_low==4'b0010)&&(h_high==4'b0001))begin
					h_low<=4'b0001;
					h_high<=4'b0;
				end
				//当时的个位记到9下一个clk周期十位进一且个位归零
				else if(h_low==4'b1001)begin
						h_high<=h_high+1'b1;
						h_low<=4'b0;
					end				
					else
						h_low<=h_low+1'b1;
			else begin
				h_high<=h_high;
				h_low<=h_low;
			end
	end
	//PM
	always@(posedge clk)begin
		if(reset)//复位使时钟变为中午12点即pm为0
			pm<=0;
			//每当时钟为11：59：59的下个时钟周期使pm信号翻转
		else if((ss==8'h59)&&(mm==8'h59)&&(hh==8'h11))
			pm<= ~pm;
			else
			pm<=pm;
	end
endmodule