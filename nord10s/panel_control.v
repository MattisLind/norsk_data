/*
 * Panel Control, card 1121 C/D (drawing 4A21, PDF page 143).
 * Partial model: backplane routing and ALD/ACTL reads only.
 */
`timescale 1ns / 1ps
`default_nettype none

module panel_control (
	input wire clk,
	input wire reset, // FPGA helper, separate from the card's MCL output
	input wire [15:0] IB_in,
	input wire [17:0] MR, // memory-side bus, NOT the microinstruction MIR
	input wire [3:0] PIL,
	input wire PON, COINC,
	input wire TRA, TRR, TR0, TR2, TR9, TR10,
	input wire FETCH, MDRY,
	input wire IMINH,
	input wire RC3,
	input wire [15:0] ALD, // logical value of switches 1E, 3E, 17E, 19E

	/* Raw PB aliases from the drawing, NOT P1 connector numbering. */
	input wire [15:4] PB_15_4,
	input wire SWREST_0, SWMCL_0, PLOCK_0,
	output wire [3:0] SWL_0, // PB3..PB0: CONTINUE, STOP, LOAD, MCL lamps

	output wire [15:0] IB_ut,
	output wire [3:0] PL,
	output wire TRA0, TRR0,
	output wire STOP, MCL, DECODE,
	output wire MDRY_hold // reserved active-high request to hold MDRY_0 low
);
	/* Normalize the phase inversions at the PIL -> PL buffers. */
	assign PL = PIL;

	/* TW5 and TW4 respectively; these are not the unqualified strobes. */
	assign TRA0 = TRA & TR0;
	assign TRR0 = TRR & TR0;
	assign DECODE = ~PB_15_4[12]; // SWDEC_0 -> DECODE_0, direct wire

	/*
	 * 74157 bank and 8097 bus gates: TRA 011 (ACTL) / 012 (ALD).
	 * Existing TR signals use decimal numbers: TR9=octal 11, TR10=12.
	 * IB is a logical wired-OR bus; zero means no contribution.
	 */
	assign IB_ut = TRA && TR9 ? (16'h0001 << PIL) :
	    TRA && TR10 ? ALD : 16'b0;

	/*
	 * TODO: debouncing, RUN/STOP and SINGLE latches, PANS readback,
	 * PANC writes, LOAD/RESTART, memory-ready open-collector contribution,
	 * and lamp drivers. Do not equate STOP with OPCOM or COINC with OPINT.
	 */
	assign STOP = 1'b0;
	assign MCL = 1'b0;
	assign MDRY_hold = 1'b0;
	assign SWL_0 = 4'hf;
endmodule
