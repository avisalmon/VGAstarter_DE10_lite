// Object rectangle
//
// Designer: Avi Salmon
// 25/12/2021
// ***********************************************
// 
// This module indicates if we are inside a rectangle on the screen and the reference position to top/left point
//
// ************************************************


module	obj_rect	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic [31:0] pxl_x,
					input 	logic [31:0] pxl_y,
					input 	logic signed [31:0] topLeftX, // can be negative 
					input 	logic	signed [31:0] topLeftY,   // can be negative
					
					output 	logic	[10:0] offsetX, // offset inside rectangle from top left position 
					output 	logic	[10:0] offsetY,
					output	logic	drawingRequest  // indicates pixel inside the rectangle
);

parameter  int OBJECT_WIDTH_X = 32;
parameter  int OBJECT_HEIGHT_Y = 16;



int rightX ; //coordinates of the sides  
int bottomY ;
logic insideBracket ; 

//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
assign rightX	= (topLeftX + OBJECT_WIDTH_X);
assign bottomY	= (topLeftY + OBJECT_HEIGHT_Y);
assign	insideBracket  = 	 ( (pxl_x  >= topLeftX) &&  (pxl_x < rightX) // math is made with SIGNED variables  
						   && (pxl_y  >= topLeftY) &&  (pxl_y < bottomY) )  ; // as the top left position can be negative
		


//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest	<=	1'b0;
	end
	else begin 
		// DEFUALT outputs
	      drawingRequest <= 1'b0 ;// transparent color 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
	
 
		if (insideBracket) // test if it is inside the rectangle 
		begin 
			drawingRequest <= 1'b1 ;
			offsetX	<= (pxl_x - topLeftX); //calculate relative offsets from top left corner allways a positive number 
			offsetY	<= (pxl_y - topLeftY);
		end 
		

		
	end
end 
endmodule 