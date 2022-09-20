module seven_segment (
	input				[3:0] in_hex,
	output	reg	[7:0]	out_to_ss
);

always begin
	case (in_hex)
		4'h0: out_to_ss = 8'b11000000;
		4'h1: out_to_ss = 8'b11111001;
		4'h2: out_to_ss = 8'b10100100;
		4'h3: out_to_ss = 8'b10110000;
		4'h4: out_to_ss = 8'b10011001;
		4'h5: out_to_ss = 8'b10010010;
		4'h6: out_to_ss = 8'b10000010;
		4'h7: out_to_ss = 8'b11111000;
		4'h8: out_to_ss = 8'b10000000;
		4'h9: out_to_ss = 8'b10010000;
		4'ha: out_to_ss = 8'b00001000;
		4'hb: out_to_ss = 8'b00000011;
		4'hc: out_to_ss = 8'b01000110;
		4'hd: out_to_ss = 8'b00100001;
		4'he: out_to_ss = 8'b00000110;
		4'hf: out_to_ss = 8'b00001110;
	endcase
end

endmodule