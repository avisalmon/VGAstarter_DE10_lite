// Designer: Mor (Mordechai) Dahan,
// Sep. 2022
// ***********************************************

module Move_Ghost (
	
	input					clk,
	input					resetN,
	
	input					collision,
	
	output	[31:0]	topLeft_x,
	output	[31:0]	topLeft_y
	
	);
	
localparam [31:0]	x_init = 32'd50;
localparam [31:0]	y_init = 32'd400;
localparam [31:0]	divider = 32'd125_000;

wire [31:0]	counter;
wire [31:0]	y_temp;
wire [31:0]	x_temp;
integer y_speed = 1;
integer x_speed = 1;
integer x_border = 5;
integer y_border = 5;

assign topLeft_x = x_temp;
assign topLeft_y = y_temp;
	
always @(posedge clk or negedge resetN) begin
	if (!resetN) begin
		x_temp <= x_init;
		y_temp <= y_init;
		counter <= 0;
	end
	else begin
		counter <= counter+1;
		
		if(collision) begin
			x_speed <= -x_speed;
			y_speed <= -y_speed;
			x_temp <= x_temp - x_speed;
			y_temp <= y_temp - y_speed;
			counter <= 0;
		end
		
		if(x_temp + x_speed <= x_border || x_temp + x_speed >= 640-x_border-64) begin
			x_speed <= -x_speed;
			x_temp <= x_temp - x_speed;
			counter <= 0;
		end
		
		if(y_temp + y_speed <= y_border || y_temp + y_speed >= 480-y_border-64) begin
			y_speed <= -y_speed;
			y_temp <= y_temp - y_speed;
			counter <= 0;
		end
		
		if (counter >= divider) begin
			counter <= 0;
			x_temp <= x_temp + x_speed;
			y_temp <= y_temp + y_speed;
		end
	end
end
	
endmodule	