// Pattern Generator
//
// Designer: Avi Salmon,
// 4/12/2021
// ***********************************************
// 
// This is a VGA test pattern generator. 
//
// ************************************************

module pattern_generator (
	input 			clk_25,
	
	input 	[31:0] pxl_x,
	input		[31:0] pxl_y,
	
	output	[3:0] red_pattern,
	output	[3:0] green_pattern,
	output	[3:0] blue_pattern
	
);

always_comb begin
	red_pattern = 0;
	green_pattern = 0;
	blue_pattern = 0;
	
	if (pxl_y < 240) begin
			case (pxl_x[7:5]) 
				3'd0: red_pattern = 4'hF;
				3'd1: green_pattern = 4'hF;
				3'd2: blue_pattern = 4'hF;
				3'd3: begin
						red_pattern = 4'hF;
						green_pattern = 4'hF;
						end
				3'd4: begin
						red_pattern = 4'hF;
						blue_pattern = 4'hF;
						end
				3'd5: begin
						green_pattern = 4'hF;
						blue_pattern = 4'hF;
						end
				3'd6: begin
						red_pattern = 4'hF;
						green_pattern = 4'hF;
						green_pattern = 4'hF;
						end
				3'd7: begin
						red_pattern = 4'h8;
						green_pattern = 4'h8;
						end
			endcase
		end
		
	else if (pxl_y < 400) begin
			case (pxl_x[9:7]) 
				3'd0: red_pattern = 4'hF;
				3'd1: green_pattern = 4'hF;
				3'd2: blue_pattern = 4'hF;
				3'd3: begin
						red_pattern = 4'hF;
						green_pattern = 4'hF;
						end
				3'd4: begin
						red_pattern = 4'hF;
						blue_pattern = 4'hF;
						end
				3'd5: begin
						green_pattern = 4'hF;
						blue_pattern = 4'hF;
						end
				3'd6: begin
						red_pattern = 4'hF;
						green_pattern = 4'hF;
						green_pattern = 4'hF;
						end
				3'd7: begin
						red_pattern = 4'h8;
						green_pattern = 4'h8;
						end
			endcase
		end
	else begin
						red_pattern = pxl_x[8:5];
						green_pattern = pxl_x[7:4];
						green_pattern = pxl_x[7:4];
		end

end

endmodule
