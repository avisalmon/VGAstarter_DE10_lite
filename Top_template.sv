// Designer: Mor (Mordechai) Dahan, Avi Salmon,
// Sep. 2022
// ***********************************************

`define ENABLE_ADC_CLOCK
`define ENABLE_CLOCK1
`define ENABLE_CLOCK2
`define ENABLE_SDRAM
`define ENABLE_HEX0
`define ENABLE_HEX1
`define ENABLE_HEX2
`define ENABLE_HEX3
`define ENABLE_HEX4
`define ENABLE_HEX5
`define ENABLE_KEY
`define ENABLE_LED
`define ENABLE_SW
`define ENABLE_VGA
`define ENABLE_ACCELEROMETER
`define ENABLE_ARDUINO
`define ENABLE_GPIO

module Top_template(

	//////////// ADC CLOCK: 3.3-V LVTTL //////////
`ifdef ENABLE_ADC_CLOCK
	input 		          		ADC_CLK_10,
`endif
	//////////// CLOCK 1: 3.3-V LVTTL //////////
`ifdef ENABLE_CLOCK1
	input 		          		MAX10_CLK1_50,
`endif
	//////////// CLOCK 2: 3.3-V LVTTL //////////
`ifdef ENABLE_CLOCK2
	input 		          		MAX10_CLK2_50,
`endif

	//////////// SDRAM: 3.3-V LVTTL //////////
`ifdef ENABLE_SDRAM
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,
`endif

	//////////// SEG7: 3.3-V LVTTL //////////
`ifdef ENABLE_HEX0
	output		     [7:0]		HEX0,
`endif
`ifdef ENABLE_HEX1
	output		     [7:0]		HEX1,
`endif
`ifdef ENABLE_HEX2
	output		     [7:0]		HEX2,
`endif
`ifdef ENABLE_HEX3
	output		     [7:0]		HEX3,
`endif
`ifdef ENABLE_HEX4
	output		     [7:0]		HEX4,
`endif
`ifdef ENABLE_HEX5
	output		     [7:0]		HEX5,
`endif

	//////////// KEY: 3.3 V SCHMITT TRIGGER //////////
`ifdef ENABLE_KEY
	input 		     [1:0]		KEY,
`endif

	//////////// LED: 3.3-V LVTTL //////////
`ifdef ENABLE_LED
	output		     [9:0]		LEDR,
`endif

	//////////// SW: 3.3-V LVTTL //////////
`ifdef ENABLE_SW
	input 		     [9:0]		SW,
`endif

	//////////// VGA: 3.3-V LVTTL //////////
`ifdef ENABLE_VGA
	output		     [3:0]		VGA_B,
	output		     [3:0]		VGA_G,
	output		          		VGA_HS,
	output		     [3:0]		VGA_R,
	output		          		VGA_VS,
`endif

	//////////// Accelerometer: 3.3-V LVTTL //////////
`ifdef ENABLE_ACCELEROMETER
	output		          		GSENSOR_CS_N,
	input 		     [2:1]		GSENSOR_INT,
	output		          		GSENSOR_SCLK,
	inout 		          		GSENSOR_SDI,
	inout 		          		GSENSOR_SDO,
`endif

	//////////// Arduino: 3.3-V LVTTL //////////
`ifdef ENABLE_ARDUINO
	output 		    [15:0]		ARDUINO_IO,
	inout 		          		ARDUINO_RESET_N,
`endif

	//////////// GPIO, GPIO connect to GPIO Default: 3.3-V LVTTL //////////
`ifdef ENABLE_GPIO
	inout 		    [35:0]		GPIO
`endif
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire				clk_25;
wire				clk_50;
wire				clk_100;

wire	[31:0]	pxl_x;
wire	[31:0]	pxl_y;
wire				h_sync_wire;
wire				v_sync_wire;
wire	[3:0]		vga_r_wire;
wire	[3:0]		vga_g_wire;
wire	[3:0]		vga_b_wire;

wire	[3:0]		r_intel;
wire	[3:0]		g_intel;
wire	[3:0]		b_intel;
wire				draw_intel;

wire	[3:0]		r_ghost;
wire	[3:0]		g_ghost;
wire	[3:0]		b_ghost;
wire				draw_ghost;

assign VGA_HS = h_sync_wire;
assign VGA_VS = v_sync_wire;
assign VGA_R = vga_r_wire;
assign VGA_G = vga_g_wire;
assign VGA_B = vga_b_wire;


wire	[7:0]		lcd_db;
wire				lcd_reset;
wire				lcd_wr;
wire				lcd_d_c;
wire				lcd_rd;
wire				lcd_buzzer;
wire				lcd_status_led;

wire	[3:0]		Red_level;
wire	[3:0]		Green_level;
wire	[3:0]		Blue_level;
wire 				Drawing;

wire	[11:0]	a0;
wire	[11:0]	a1;
wire	[11:0]	a2;
wire	[11:0]	a3;
wire	[11:0]	a4;
wire	[11:0]	a5;

wire	[31:0]	topLeft_x_intel;
wire	[31:0]	topLeft_y_intel;

wire	[31:0]	topLeft_x_ghost;
wire	[31:0]	topLeft_y_ghost;

assign ARDUINO_IO[7:0]	= lcd_db;
assign ARDUINO_IO[8] 	= lcd_reset;
assign ARDUINO_IO[9]		= lcd_wr;
assign ARDUINO_IO[10]	= lcd_d_c;
assign ARDUINO_IO[11]	= lcd_rd;
assign ARDUINO_IO[12]	= lcd_buzzer;
assign ARDUINO_IO[13]	= lcd_status_led;


//=======================================================
//  Structural coding
//=======================================================

// SWITCHES:
//
// 9	8	7	6	5	4	3	2	1	0
//	|	|								|
//	ResetN							manual start lcd
//  	|
//		cfg[1:0]


// Screens control (LCD and VGA)
Screens_dispaly Screen_control(
	.clk_25(clk_25),
	.clk_100(clk_100),
	.Red_level(Red_level),
	.Green_level(Green_level),
	.Blue_level(Blue_level),
	.pxl_x(pxl_x),
	.pxl_y(pxl_y),
	.Red(vga_r_wire),
	.Green(vga_g_wire),
	.Blue(vga_b_wire),
	.h_sync(h_sync_wire),
	.v_sync(v_sync_wire),
	.lcd_db(lcd_db),
	.lcd_reset(lcd_reset),
	.lcd_wr(lcd_wr),
	.lcd_d_c(lcd_d_c),
	.lcd_rd(lcd_rd)
);

// Utilities

// 25M clk generation
pll25	pll25_inst (
	.areset ( 1'b0 ),
	.inclk0 ( MAX10_CLK1_50 ),
	.c0 ( clk_25 ),
	.c1 ( clk_50 ),
	.c2 ( clk_100 ),
	.locked ( )
	);


// ALIVE and Version

assign HEX0 = 8'b11111111;
assign HEX1 = 8'b11111111;
assign HEX2 = 8'b11111111;
assign HEX3 = 8'b11111111;

// Analog Read Module
analog_input analog_input_inst(
	.clk(ADC_CLK_10),
	.a0(a0), // LEFT/RIGHT Left = High, Right = middle, 0 = nothing
	.a1(a1), // UP/DOWN - Hihg up, midle down. 0 nothing
	.a2(a2), // Select button HIGH is pressed
	.a3(a3), // Button A 0 is pressed
	.a4(a4),	// Button B 0 is pressed
	.a5(a5) // Wheel input
	);
	
	assign LEDR[0] = a3 < 2048 ? 1 : 0; // A
	assign LEDR[1] = a4 < 2048 ? 1 : 0; // B
	assign LEDR[2] = a2 > 12'hCFF ? 1 : 0; // Select
	assign LEDR[3] = a2 < 12'hCFF & a2 > 12'h5FF ? 1 : 0; // Start
	assign LEDR[9] = a0 > 12'hCFF ? 1 : 0; // Left
	assign LEDR[8] = a0 < 12'hCFF & a0 > 12'h5FF ? 1 : 0; // Right
	assign LEDR[7] = a1 > 12'hCFF ? 1 : 0; // UP
	assign LEDR[6] = a1 < 12'hCFF & a1 > 12'h5FF ? 1 : 0; // DOWN
	
	
	seven_segment ss5(
	.in_hex(a5[11:8]),
	.out_to_ss(HEX5)
);

	seven_segment ss4(
	.in_hex(a5[7:4]),
	.out_to_ss(HEX4)
);

Drawing_priority drawing_mux(
	.clk(clk_25),
	.resetN(SW[9]),
	.RGB_1({r_intel,g_intel,b_intel}),
	.draw_1(draw_intel),
	.RGB_2({r_ghost,g_ghost,b_ghost}),
	.draw_2(draw_ghost),
	.RGB_bg(12'hFFF),
	.Red_level(Red_level),
	.Green_level(Green_level),
	.Blue_level(Blue_level)
	
	);
	
Move_Intel move_inst1(
	.clk(clk_25),
	.resetN(SW[9]),
	.wheel(a5),
	.up(a1 > 12'hCFF ? 1 : 0),
	.down(a1 < 12'hCFF & a1 > 12'h5FF ? 1 : 0),
	
	.topLeft_x(topLeft_x_intel),
	.topLeft_y(topLeft_y_intel)
	);
	
Move_Ghost move_inst2(
	.clk(clk_25),
	.resetN(SW[9]),
	.collision(draw_intel && draw_ghost),
	
	.topLeft_x(topLeft_x_ghost),
	.topLeft_y(topLeft_y_ghost)
	);

Draw_Intel draw_inst1(
	.clk(clk_25),
	.resetN(SW[9]),
	
	.pxl_x(pxl_x),
	.pxl_y(pxl_y),
	
	.topLeft_x(topLeft_x_intel),
	.topLeft_y(topLeft_y_intel),
	
	.width(32'd128),
	.high(32'd64),
	
	.Red_level(r_intel),
	.Green_level(g_intel),
	.Blue_level(b_intel),
	.Drawing(draw_intel)
	);
	
Draw_Ghost draw_inst2(
	.clk(clk_25),
	.resetN(SW[9]),
	
	.pxl_x(pxl_x),
	.pxl_y(pxl_y),
	
	.topLeft_x(topLeft_x_ghost),
	.topLeft_y(topLeft_y_ghost),
	
	.width(32'd64),
	.high(32'd64),
	
	.Red_level(r_ghost),
	.Green_level(g_ghost),
	.Blue_level(b_ghost),
	.Drawing(draw_ghost)
	);



endmodule
