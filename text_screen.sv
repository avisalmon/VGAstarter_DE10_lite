// Text Screen
//
// Designer: Avi Salmon,
// 2/12/2021
// ***********************************************
// 
// Text screen area. holds the ASCII memory space to present on the screen.
// 80 characters wide
// 60 characters deep
// Each character is folowed by 8 bit Meta data:
// 7	6	5	4	3	2	1	0
//		|	|	|	|	|	|	|
// 	U Underline prints the lowest line in a charecter
//			BR	Background RED
//				BG Backgrund Green
//					BB Backgrund Blue
//						FR Forground Red
//							FG Forground green
//								FB Forground Blue
// Input Address: 16K, 8b
// add[13:8]	- Colum 0-79
//	add[7:1]		- Row 0-59
// add[0] - 0=ASCII, 1=Meta
//
// The way it is implemented is that it is 3 pixles behind. 
// ***********************************************

module text_screen ( 				
	input 				clk_25,
	input 				resetN,
	
	input 	[13:0]	text_add,
	input					wr_en,
	
	input 	[31:0] pxl_x,
	input		[31:0] pxl_y,
	
	output	[3:0] red_text,
	output	[3:0] green_text,
	output	[3:0] blue_text
	
);


wire	[7:0]		text_data;
wire	[7:0]		font_data;
reg	[2:0]		pxl_y_buf1;
reg	[2:0]		pxl_x_buf1;
reg	[2:0]		pxl_x_buf2;
wire				text_pixel_out;


// Text_ram holds the ASCII characters for the screen 
	
text_ram_a	text_ram_a_inst (
	.address_a({pxl_y[8:3], pxl_x[9:3]}),
	.address_b( 13'd0),
	.clock(clk_25),
	.data_a (),
	.data_b (),
	.wren_a (1'b0),
	.wren_b (1'b0),
	.q_a (text_data),
	.q_b ()
	);

	
always @(posedge clk_25) begin
	pxl_y_buf1[2:0] <= pxl_y[2:0];
end
	
// Font ROM holds the font bitmaps. address[10:0], q[7:0]

font_rom	font_rom_inst (
	.address({text_data[7:0],pxl_y_buf1[2:0]}),
	.clock(clk_25),
	.q(font_data[7:0])
	);
	
always @(posedge clk_25 or negedge resetN) begin
	if (resetN == 1'b0) 
		pxl_x_buf1[2:0] <= 3'b0;
	else
		pxl_x_buf1[2:0] <= pxl_x[2:0];
end

always @(posedge clk_25) begin
	pxl_x_buf2[2:0] <= pxl_x_buf1[2:0];
end

// final pixel drawing. TBD Mate data
always_comb begin
   unique casez (pxl_x_buf2)
        3'd0:    text_pixel_out = font_data[0];
        3'd1:    text_pixel_out = font_data[1];
        3'd2:    text_pixel_out = font_data[2];
        3'd3:    text_pixel_out = font_data[3];
		  3'd4:    text_pixel_out = font_data[4];
        3'd5:    text_pixel_out = font_data[5];
        3'd6:    text_pixel_out = font_data[6];
        3'd7:    text_pixel_out = font_data[7];
        default : text_pixel_out = 1'b0; 
   endcase
end

// place holder for META decision
assign red_text = 	( text_pixel_out == 1'b0) ? 4'b0000 : 4'b1111;
assign green_text = 	( text_pixel_out == 1'b0) ? 4'b0000 : 4'b1111;
assign blue_text = 	( text_pixel_out == 1'b0) ? 4'b0000 : 4'b1111;

endmodule
