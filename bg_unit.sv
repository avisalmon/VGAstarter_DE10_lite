// Background Unit
//
// Designer: Avi Salmon,
// 25/12/2021
// ***********************************************
// 
// This module will produce the default game background. 
// we have an option for 8 kind of backgrounds depends on the input "screen"
//
// ************************************************

module bg_unit (
	inout 	[31:0] pxl_x,
	input 	[31:0] pxl_y,
	
	output	[3:0] bg_red,
	output	[3:0] bg_green,
	output	[3:0] bg_blue,
	
	input		[2:0] screen
	
);

assign bg_red = 4'b1111; //pxl_x[4:1];
assign bg_green = 4'b1111; //pxl_y[4:1];
assign bg_blue = 4'b1111; //pxl_y[5:2];


endmodule
