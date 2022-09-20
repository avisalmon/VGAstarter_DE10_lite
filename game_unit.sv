// Game Unit
//
// Designer: Avi Salmon,
// 18/12/2021
// ***********************************************
// 
// The Game control is [PNG GAME] that is running both independently
// and also may be controlled by the CPU
//
// ************************************************

module game_unit (
	input				clk_25,
	input				resetN,
	
	input				h_sync,
	input	[31:0]	pxl_x,
	input	[31:0]	pxl_y,
	
	// TBD control addresses from CPU
	
	input	[1:0]		key,
	
	output	[3:0]	red_game,
	output	[3:0]	green_game,
	output	[3:0]	blue_game

);

wire	end_of_frame;
wire h_sync_1;
wire	[3:0]	bg_red;
wire	[3:0]	bg_green;
wire	[3:0]	bg_blue;
wire			ball_draw_request;
wire	[3:0]	ball_red;
wire	[3:0]	ball_green;
wire	[3:0]	ball_blue;
wire 	[3:0]	frame_collision;
wire 	[3:0]	player_collision;

//assign	red_game = pxl_x[7:4];
//assign	green_game = 4'd0;
//assign	blue_game = (end_of_frame == 1) ? 4'hF : 4'd0;


// End_of_frame

always @(posedge clk_25 or negedge resetN) begin
	if (resetN == 1'b0) 
		h_sync_1 <= 0;
	else
		h_sync_1 <= h_sync;
end

assign	end_of_frame = ~h_sync && h_sync_1;


// Background Unit
bg_unit bg_init_inst(
	.pxl_x(pxl_x),
	.pxl_y(pxl_y),
	.bg_red(bg_red),
	.bg_green(bg_green),
	.bg_blue(bg_blue),
	.screen(3'd0) // option for 8 backgrounds
);



// Ball
ball_unit ball_unit_inst(
	.clk_25(clk_25),
	.resetN(resetN),
	.pxl_x(pxl_x),
	.pxl_y(pxl_y),
	.ball_draw_request(ball_draw_request),
	.ball_red(ball_red),
	.ball_green(ball_green),
	.ball_blue(ball_blue),
	.end_of_frame(end_of_frame),
	.frame_collision(frame_collision),
	.player_collision(player_collision),
	
);


// Players


// Screen Information


// Game Mux
game_mux game_mux_inst(
	.bg_red(bg_red),
	.bg_green(bg_green),
	.bg_blue(bg_blue),
	
	.ball_draw_request(ball_draw_request),
	.ball_red(ball_red),
	.ball_green(ball_green),
	.ball_blue(ball_blue),
	
	.frame_collision(0),
	.player_collision(0),
	
	.red_game(red_game),
	.green_game(green_game),
	.blue_game(blue_game)	
);


// Main SM control




// 

endmodule
