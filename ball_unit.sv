// Ball Unit
//
// Designer: Avi Salmon,
// 25/12/2021
// ***********************************************
// 
// This module owns the ball.  
//
// ************************************************

module ball_unit (
	input				clk_25,
	input				resetN,
	
	input	[31:0]	pxl_x,
	input	[31:0]	pxl_y,
	
	output			ball_draw_request,
	output [3:0]	ball_red,
	output [3:0]	ball_green,
	output [3:0]	ball_blue,
	
	input				end_of_frame,
	input	[3:0]		frame_collision,
	input	[3:0]		player_collision

);

wire	[10:0]	offsetX;
wire	[10:0]	offsetY;
wire				InsideRectangle;
wire	[7:0]		RGBout_zip;
wire	[3:0]		HitEdgeCode;


// Check if we are inside the ball area

obj_rect obj_rect_ball(
	.clk(clk_25),
	.resetN(resetN),
	.pxl_x(pxl_x),
	.pxl_y(pxl_y),
	.topLeftX(32'd100),
	.topLeftY(32'd100),
	.offsetX(offsetX),
	.offsetY(offsetY),
	.drawingRequest(InsideRectangle)
);

// and if we are, get the right pixle from the bitmap. 

smileyBitMap_31_16 smileyBitMap_31_16_inst(
	.clk(clk_25),
	.resetN(resetN),
	.offsetX(offsetX),
	.offsetY(offsetY),
	.InsideRectangle(InsideRectangle),
	.drawingRequest(ball_draw_request),
	.RGBout(RGBout_zip),
	.HitEdgeCode(HitEdgeCode)
);

// color zip is: (RRRGGGBB)

assign ball_red = {RGBout_zip[7:5],1'b0};
assign ball_green = {RGBout_zip[4:2],1'b0};
assign ball_blue = {RGBout_zip[1:0],2'b00};



endmodule

	