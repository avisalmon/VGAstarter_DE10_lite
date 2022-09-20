// Designer: Mor (Mordechai) Dahan,
// Sep. 2022
// ***********************************************

module Move_Intel (
	
	input					clk,
	input					resetN,
	
	//input					enable,
	input		[11:0]	wheel,
	input					up,
	input					down,
	
	output	[31:0]	topLeft_x,
	output	[31:0]	topLeft_y
	
	);
	
localparam [31:0]	x_init = 32'd0;
localparam [31:0]	y_init = 32'd400;
localparam [31:0]	divider = 32'd250_000;

wire [31:0]	counter;
wire [31:0]	y_temp;

assign topLeft_x = (wheel/6 < 640-128) ? wheel/6 : 640-128;
//assign topLeft_x = (wheel[11:2]<32'd640) ? wheel[11:2] : 32'd640;
assign topLeft_y = y_temp;
	
always @(posedge clk or negedge resetN) begin
	if (!resetN) begin
		//topLeft_x <= x_init;
		y_temp <= y_init;
		counter <= 0;
	end
	else begin
		counter <= counter+1;
		
		if (counter >= divider) begin
			counter <= 0;
			if(up && y_temp >= 1)
				y_temp <= y_temp - 1;
			if (down && y_temp <= 480-64)
				y_temp <= y_temp + 1;
		end
	end
end
	
endmodule	