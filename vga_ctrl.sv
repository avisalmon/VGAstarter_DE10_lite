// VGA control
//
// Designer: Avi Salmon,
// 30/10/2021
// ***********************************************
// 
// The VGA controler is reponsible for both the gamin graphical output and the Text output. 
//	It holds a text memory and a font bit map.
// on the Graphical side it is just transmiting to the system the current pixel to draw and 
//	receives the vcolor to transmit. 
// compressing of the colors, if needed, are don external to this module. This mosule suppoerts 
// full 4b x 3 colors VGA. 
//
// ************************************************


module vga_ctrl (
	input 			clk_50, 				
	input 			clk_25,
	input 			resetN,
	input		[1:0]	key,
	
	input 	[6:0]	text_add_col,
	input		[5:0]	text_add_row,
	input				wr_en,
	
	output 	[31:0] pxl_x,
	output	[31:0] pxl_y,
	
	output	[3:0] red,
	output	[3:0] green,
	output	[3:0] blue,
	output			h_sync,
	output			v_sync,
	
	input		[1:0] cfg // 00=game; 01 = text; 11 = test pattern
	
);

wire	[3:0]	red_text, green_text, blue_text;
wire	[3:0]	red_game, green_game, blue_game;
wire	[3:0]	red_pattern, green_pattern, blue_pattern;
wire	[3:0] red_out, green_out, blue_out;
wire			start_of_frame;

wire			disp_ena;


reg 			v_sync_1;


// vga scan for all rendering machines.
  vga_controller control (
     .pixel_clk  (clk_25),
     .reset_n    (resetN),
     .h_sync     (h_sync),
     .v_sync     (v_sync),
     .disp_ena   (disp_ena),
     .column     (pxl_x),
     .row        (pxl_y)
     );
	  
	  
// start of frame pulse - rise in the start of v_sync and servs to update anything needed before the next frame.
always @(posedge clk_25) begin
	v_sync_1 <= v_sync;
end	

assign start_of_frame = ~v_sync_1 & v_sync;



// screen out display picker / enable
assign red = (disp_ena == 1'b0) ? 4'b0000 : red_out ;
assign green = (disp_ena == 1'b0) ? 4'b0000 : green_out ;
assign blue = (disp_ena == 1'b0) ? 4'b0000 : blue_out ;

assign red_out = 	(cfg == 2'b00) ? red_game :
						(cfg == 2'b01) ? red_text :
						(cfg == 2'b11) ? red_pattern:
											  4'b0000; // default
								
assign green_out =	(cfg == 2'b00) ? green_game :
							(cfg == 2'b01) ? green_text :
							(cfg == 2'b11) ? green_pattern:
											  4'b0000; // default

assign blue_out = 	(cfg == 2'b00) ? blue_game :
							(cfg == 2'b01) ? blue_text :
							(cfg == 2'b11) ? blue_pattern:
											  4'b0000; // default
											  
// GAME Screen control
// **** TBD ****


// Game screen control


game_unit game_unit_inst(
	.clk_25(clk_25),
	.resetN(resetN),
	.h_sync(h_sync),
	.pxl_x(pxl_x),
	.pxl_y(pxl_y),
	.key(key),
	.red_game(red_game), 
	.green_game(green_game),
	.blue_game(blue_game)	
);

											  
// Text screen control
// **** TBD ****

text_screen text_screen_inst1(
	.clk_25(clk_25),
	.resetN(resetN),
	.text_add(14'd0),
	.wr_en(1'b0),
	.pxl_x(pxl_x),
	.pxl_y(pxl_y),
	.red_text(red_text),
	.green_text(green_text),
	.blue_text(blue_text)	
);

			

// Pattern control
// **** TBD ****	

pattern_generator pattern_generator_inst(
	.clk_25(clk_25),
	.pxl_x(pxl_x),
	.pxl_y(pxl_y),
	.red_pattern(red_pattern),
	.green_pattern(green_pattern),
	.blue_pattern(blue_pattern)
);


endmodule
