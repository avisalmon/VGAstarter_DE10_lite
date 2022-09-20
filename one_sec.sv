module one_sec (
	input clk, resetN,
	output reg one_sec,
	output reg [3:0] one_sec_count
);

reg [31:0] count;

always @(posedge clk) begin

	if (count > 50_000_000) 
		begin
			count <= 0;
			one_sec <= 1;
		end
	else 
		begin
		count = count + 1;
		one_sec <= 0;
		end
end

always @(posedge clk) begin
	if (one_sec) one_sec_count += 1; 
	
end

endmodule
