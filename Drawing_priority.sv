// Designer: Mor (Mordechai) Dahan,
// Sep. 2022
// ***********************************************

module Drawing_priority (
	
	input					clk,
	input					resetN,
	
	input		[11:0]	RGB_1,
	input					draw_1,
	
	input		[11:0]	RGB_2,
	input					draw_2,
	
	input		[11:0]	RGB_bg,
	
	output	[3:0]		Red_level,
	output	[3:0]		Green_level,
	output	[3:0]		Blue_level
	
	);
	
always @(posedge clk or negedge resetN) begin
	if (!resetN) begin
		Red_level <= 4'hF;
		Green_level <= 4'hF;
		Blue_level <= 4'hF;
	end
	else begin
		if (draw_1) begin
			Red_level <= RGB_1[11:8];
			Green_level <= RGB_1[7:4];
			Blue_level <= RGB_1[3:0];
		end
		
		else if (draw_2) begin
			Red_level <= RGB_2[11:8];
			Green_level <= RGB_2[7:4];
			Blue_level <= RGB_2[3:0];
		end
		
		else
			Red_level <= RGB_bg[11:8];
			Green_level <= RGB_bg[7:4];
			Blue_level <= RGB_bg[3:0];
	end
end
	
endmodule