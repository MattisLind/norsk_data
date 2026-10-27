/*
 * Lamp Register, card 1115 E/F (drawing 4A15, PDF page 135).
 * First-pass interface model; storage and display timing are TODO.
 */
`timescale 1ns / 1ps
`default_nettype none

module lamp_register (
	input wire clk,
	input wire MCL, // FPGA reset helper; no MCL terminal identified on 1115
	input wire [15:0] IB,
	input wire [17:0] BA,
	input wire [3:0] RC, PL,
	input wire TRR, TR2,
	input wire DECODE, FETCH, DMA, MDRY,
	input wire BREFRESH, BREQ,
	input wire OSC,
	output wire [17:0] WL_0
);
	/*
	 * TODO: 74170 address/data banks, RC-controlled bank selection,
	 * level-activity capture and monostable lamp persistence. This card
	 * samples IB; it does not drive IB. Raw active-low lamps stay off.
	 */
	assign WL_0 = {18{1'b1}};
endmodule
