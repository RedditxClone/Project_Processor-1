module Add(input[15:0] src, input[15:0] dst, output[15:0] sum, output[3:0] flags);
// flags -> 0 : carry, 1 : zero, 2 : negative, 3: overflow
assign {flags[0], sum} = src + dst;
assign flags[1] = {flags[0], sum} === 0 ? 1 : 0;
assign flags[2] = sum[15] === 1 ? 1 : 0;
assign flags[3] = (src[15] == dst[15] && src[15] !== sum[15]) ? 1 : 0;

endmodule

module Invert(input[15:0] operand, output[15:0] result, output zero_flag);
// flags -> 0 : carry, 1 : zero, 2 : negative, 3: overflow
assign result = ~operand;
assign zero_flag = result === 0 ? 1 : 0;

endmodule

module NOP();
endmodule

module ALU_Execute(input clk, input[2:0] operation, input[15:0] src, input[15:0] dst, output reg[15:0] result, output reg[3:0] flags);
// flags -> 0: carry, 1: zero, 2: negative, 3: overflow

 always @ (*) begin
 	if(operation === 3'b000)	// Add
	begin
	{flags[0], result} = src + dst;
	flags[1] =  result === 0 ? 1 : 0;
	flags[2] = result[15] === 1 ? 1 : 0;
	flags[3] = (src[15] == dst[15] && src[15] !== result[15]) ? 1 : 0;
	end

	if(operation == 3'b001)		// Invert
	begin
	result = ~src;
	flags[0] =  0;
	flags[1] = result === 0 ? 1 : 0;
	flags[2] =  0;
	flags[3] =  0;
	end

	if(operation == 3'b100)		// NOP
	begin

	 end

	if(operation === 3'b011)	// Store
	begin
	result = dst;
	end

	if(operation === 3'b010)	// Load
	begin
	{flags[0], result} = src + dst;
	flags[1] =  result === 0 ? 1 : 0;
	flags[2] = result[15] === 1 ? 1 : 0;
	flags[3] = (src[15] == dst[15] && src[15] !== result[15]) ? 1 : 0;
	end
 end
endmodule