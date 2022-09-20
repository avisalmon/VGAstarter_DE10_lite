module analog_input (

input							clk,
output	reg	[11:0]	a0,
output	reg	[11:0]	a1,
output	reg	[11:0]	a2,
output	reg	[11:0]	a3,
output	reg	[11:0]	a4,
output	reg	[11:0]	a5
	
);

wire					adc_write;
wire					adc_read;
wire		[31:0]	adc_read_data;
wire		[31:0]	adc_write_data;
wire		[2:0]		adc_address;
wire					adc_wait_request;

//reg		[11:0]	a0;
//reg		[11:0]	a1;
//reg		[11:0]	a2;
//reg		[11:0]	a3;
//reg		[11:0]	a4;
//reg		[11:0]	a5;


adc u0 (
	.clk_clk               (clk),               //       clk.clk
	.reset_reset_n         (1),         //     reset.reset_n
	.adc_slave_write       (adc_write),       // adc_slave.write
	.adc_slave_readdata    (adc_read_data),    //          .readdata
	.adc_slave_writedata   (adc_write_data),   //          .writedata
	.adc_slave_address     (adc_address),     //          .address
	.adc_slave_waitrequest (adc_wait_request), //          .waitrequest
	.adc_slave_read        (adc_read)         //          .read
);

always @(posedge clk) begin
	if (adc_read == 1 & adc_wait_request == 0 & adc_address == 0) begin
		a0 <= adc_read_data;
	end
	if (adc_read == 1 & adc_wait_request == 0 & adc_address == 1) begin
		a1 <= adc_read_data;
	end
	if (adc_read == 1 & adc_wait_request == 0 & adc_address == 2) begin
		a2 <= adc_read_data;
	end
	if (adc_read == 1 & adc_wait_request == 0 & adc_address == 3) begin
		a3 <= adc_read_data;
	end
	if (adc_read == 1 & adc_wait_request == 0 & adc_address == 4) begin
		a4 <= adc_read_data;
	end
	if (adc_read == 1 & adc_wait_request == 0 & adc_address == 5) begin
		a5 <= adc_read_data;
	end
	
end

// Control FSM

enum int unsigned { 
	ADC_IDLE 		= 32'h00_00_00_00, 
	ADC_WRITE_0		= 32'h00_00_00_01,
	ADC_WRITE_0_r	= 32'h00_00_00_02,
	ADC_WRITE_1		= 32'h00_00_00_04,
	ADC_WRITE_1_r	= 32'h00_00_00_08,
	ADC_READ_0		= 32'h00_00_01_00,
	ADC_READ_0_r	= 32'h00_00_02_00,
	ADC_READ_1		= 32'h00_00_04_00,
	ADC_READ_1_r	= 32'h00_00_08_00,
	ADC_READ_2		= 32'h00_00_10_00,
	ADC_READ_2_r	= 32'h00_00_20_00,
	ADC_READ_3		= 32'h00_00_40_00,
	ADC_READ_3_r	= 32'h00_00_80_00,
	ADC_READ_4		= 32'h00_01_00_00,
	ADC_READ_4_r	= 32'h00_02_00_00,
	ADC_READ_5		= 32'h00_04_00_00,
	ADC_READ_5_r	= 32'h00_08_00_00
	} adc_state, adc_next_state;

always_comb 
	begin
		adc_next_state = ADC_IDLE;
		adc_read = 0;
		adc_write = 0;
		adc_address = 0;
		adc_write_data = 0;
		
		case(adc_state)
		
		ADC_IDLE: 		begin
								adc_next_state = ADC_WRITE_0;
							end
					 
		ADC_WRITE_0: 	begin
								adc_write = 1;
								adc_address = 0;
								adc_next_state = ADC_WRITE_0_r;
							end
							
		ADC_WRITE_0_r:	begin
								adc_write = 1;
								adc_address = 0;
								if (adc_wait_request == 0) begin
									adc_next_state = ADC_WRITE_1;
								end
								else begin
									adc_next_state = ADC_WRITE_0_r;
								end
							end
							
		ADC_WRITE_1: 	begin
								adc_write = 1;
								adc_address = 1;
								adc_next_state = ADC_WRITE_1_r;
							end
							
		ADC_WRITE_1_r:	begin
								adc_write = 1;
								adc_address = 1;
								if (adc_wait_request == 0) begin
									adc_next_state = ADC_READ_0;
								end
								else begin
									adc_next_state = ADC_WRITE_1_r;
								end
							end
							
							
		ADC_READ_0: 	begin
								adc_read = 1;
								adc_address = 0;
								adc_next_state = ADC_READ_0_r;
							end
							
		ADC_READ_0_r:	begin
								adc_read = 1;
								adc_address = 0;
								if (adc_wait_request == 0) begin
									adc_next_state = ADC_READ_1;
								end
								else begin
									adc_next_state = ADC_READ_0_r;
								end
							end
							
		ADC_READ_1: 	begin
								adc_read = 1;
								adc_address = 1;
								adc_next_state = ADC_READ_1_r;
							end
							
		ADC_READ_1_r:	begin
								adc_read = 1;
								adc_address = 1;
								if (adc_wait_request == 0) begin
									adc_next_state = ADC_READ_2;
								end
								else begin
									adc_next_state = ADC_READ_1_r;
								end
							end
		
		ADC_READ_2: 	begin
								adc_read = 1;
								adc_address = 2;
								adc_next_state = ADC_READ_2_r;
							end
							
		ADC_READ_2_r:	begin
								adc_read = 1;
								adc_address = 2;
								if (adc_wait_request == 0) begin
									adc_next_state = ADC_READ_3;
								end
								else begin
									adc_next_state = ADC_READ_0_r;
								end
							end
							
		ADC_READ_3: 	begin
								adc_read = 1;
								adc_address = 3;
								adc_next_state = ADC_READ_3_r;
							end
							
		ADC_READ_3_r:	begin
								adc_read = 1;
								adc_address = 3;
								if (adc_wait_request == 0) begin
									adc_next_state = ADC_READ_4;
								end
								else begin
									adc_next_state = ADC_READ_3_r;
								end
							end
							
		ADC_READ_4: 	begin
								adc_read = 1;
								adc_address = 4;
								adc_next_state = ADC_READ_4_r;
							end
							
		ADC_READ_4_r:	begin
								adc_read = 1;
								adc_address = 4;
								if (adc_wait_request == 0) begin
									adc_next_state = ADC_READ_5;
								end
								else begin
									adc_next_state = ADC_READ_4_r;
								end
							end
							
		ADC_READ_5: 	begin
								adc_read = 1;
								adc_address = 5;
								adc_next_state = ADC_READ_5_r;
							end
							
		ADC_READ_5_r:	begin
								adc_read = 1;
								adc_address = 5;
								if (adc_wait_request == 0) begin
									adc_next_state = ADC_WRITE_0;
								end
								else begin
									adc_next_state = ADC_READ_5_r;
								end
							end
			endcase
		end
		
		always_ff @(posedge clk) begin
			adc_state <= adc_next_state;
		end

endmodule
