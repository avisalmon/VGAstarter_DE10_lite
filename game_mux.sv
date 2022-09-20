// Game MUX
//
// Designer: Avi Salmon,
// 25/12/2021
// ***********************************************
// 
// This module decides what to draw out of all objects that wants to draw now. 
//
// ************************************************

module game_mux (
	input		[3:0] bg_red,
	input		[3:0] bg_green,
	input		[3:0] bg_blue,
	
	input				ball_draw_request,
	input		[3:0] ball_red,
	input		[3:0] ball_green,
	input		[3:0] ball_blue,
	
	input				frame_collision,
	input				player_collision,

	output	[3:0] red_game,
	output	[3:0] green_game,
	output	[3:0] blue_game

);

always_comb begin
    if (ball_draw_request == 1'b1)begin
			red_game = ball_red;
			green_game = ball_green;
			blue_game = ball_blue;
		end
    else begin
			red_game = bg_red;
			green_game = bg_green;
			blue_game = bg_blue;
		end
end //always_comb


endmodule
