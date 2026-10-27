/*
 * Panel Transceiver, card 1114 D (drawing 4A14, PDF page 133).
 * First-pass interface model; NOT a completed emulation of this card.
 * See doc/front-panel-backplane.md before implementing the remaining logic.
 */
`timescale 1ns / 1ps
`default_nettype none

module panel_transceiver (
	input wire clk,
	input wire MCL,
	input wire [15:0] IB_in,
	input wire [3:0] PL,
	input wire PON, ION,
	input wire [1:0] PCR,
	input wire TRA, TR2,
	input wire TRA0, TRR0, // qualified TRA/TRR PANS/PANC, from 1121
	input wire MINH, PFINT,

	/* Raw electrical phases at the 1907 interface. */
	input wire SW_0, SREG_0,
	input wire WUP_1, WUP_0, WDOWN_1, WDOWN_0,
	output wire SCL_1, SLD_0, SOUT_0,
	output wire WL20_0, WL21_0,

	output wire [15:0] IB_ut,
	output wire [3:0] RC,
	output wire COINC, OSC,
	output wire IMINH, IPFINT
);
	/* Direct wiring on the sheet, not interrupt-generating logic. */
	assign IMINH = MINH;
	assign IPFINT = PFINT;

	/*
	 * TODO: oscillator/dividers, 1907 shift timing, OPR switch capture,
	 * level counter, register selector, TRA PANS/OPR and coincidence logic.
	 * No bus contribution until those read paths are implemented. RC is
	 * parked at zero; this is NOT a register-selector implementation.
	 */
	assign IB_ut = 16'b0;
	assign RC = 4'b0;
	assign COINC = 1'b0;
	assign OSC = 1'b0;
	assign SCL_1 = 1'b0;
	assign SLD_0 = 1'b1;
	assign SOUT_0 = 1'b1;
	assign WL20_0 = 1'b1;
	assign WL21_0 = 1'b1;
endmodule
