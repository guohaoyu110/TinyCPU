`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: OpenHEC
// Engineer: www.iopenhec.com
// 
// Create Date: 2016/06/16 13:56:36
// Design Name: 
// Module Name: lab_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: WebOnline Experiment Top Interface
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
/////////Lab Top Module Start (Don't Edit)   /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module lab_top
(
	/*
	 *		Clock Signals   
	 *		20MHz			
	 */	
	input	wire			lab_clk,
	
	/*
	 *		Step Signals   
	 *					
	 */		
	input	wire			step_clk,
	
	/* 	 	Reset  Signals	 
	 *		HIGH_ACTIVE OR LOW_ACTIVE
	 *	  	Deterimined by WEB Optition
	 */
	input	wire			lab_reset,
	
	/*
	 *  SW 
	 * input Signals  
	 */
	input	wire			SW00,
	input	wire			SW01,
	input	wire			SW02,
	input	wire			SW03,
	input	wire			SW04,
	input	wire			SW05,
	input	wire			SW06,
	input	wire			SW07,
	input	wire			SW08,
	input	wire			SW09,
	input	wire			SW10,
	input	wire			SW11,
	input	wire			SW12,
	input	wire			SW13,
	input	wire			SW14,
	input	wire			SW15,
	input	wire			SW16,
	input	wire			SW17,
	input	wire			SW18,
	input	wire			SW19,
	input	wire			SW20,
	input	wire			SW21,
	input	wire			SW22,
	input	wire			SW23,
	input	wire			SW24,
	input	wire			SW25,
	input	wire			SW26,
	input	wire			SW27,
	input	wire			SW28,
	input	wire			SW29,
	input	wire			SW30,
	input	wire			SW31,

	/*
	 *   LED 
	 * output Signals  
	 */
	output	wire			LED00,
	output	wire			LED01,
	output	wire			LED02,
	output	wire			LED03,
	output	wire			LED04,
	output	wire			LED05,
	output	wire			LED06,
	output	wire			LED07,
	output	wire			LED08,
	output	wire			LED09,
	output	wire			LED10,
	output	wire			LED11,
	output	wire			LED12,
	output	wire			LED13,
	output	wire			LED14,
	output	wire			LED15,
	output	wire			LED16,
	output	wire			LED17,
	output	wire			LED18,
	output	wire			LED19,
	output	wire			LED20,
	output	wire			LED21,
	output	wire			LED22,
	output	wire			LED23,
	output	wire			LED24,
	output	wire			LED25,
	output	wire			LED26,
	output	wire			LED27,
	output	wire			LED28,
	output	wire			LED29,
	output	wire			LED30,
	output	wire			LED31,
	
	/*
	 *   Register 8-bit 
	 * 	 Input	Signals
	 */
	input	wire	[ 7: 0]	R8IN0,
	input	wire	[ 7: 0]	R8IN1,
	input	wire	[ 7: 0]	R8IN2,
	input	wire	[ 7: 0]	R8IN3,
	input	wire	[ 7: 0]	R8IN4,
	input	wire	[ 7: 0]	R8IN5,
	input	wire	[ 7: 0]	R8IN6,
	input	wire	[ 7: 0]	R8IN7,

	/*
	 *   Register 8-bit 
	 * 	 Output	Signals
	 */	
	output	wire	[ 7: 0]	R8OUT0,
	output	wire	[ 7: 0]	R8OUT1,
	output	wire	[ 7: 0]	R8OUT2,
	output	wire	[ 7: 0]	R8OUT3,
	output	wire	[ 7: 0]	R8OUT4,
	output	wire	[ 7: 0]	R8OUT5,
	output	wire	[ 7: 0]	R8OUT6,
	output	wire	[ 7: 0]	R8OUT7,
	
	/*
	 *   Register 16-bit 
	 * 	 Input	Signals
	 */
	input	wire	[15: 0]	R16IN0,
	input	wire	[15: 0]	R16IN1,
	input	wire	[15: 0]	R16IN2,
	input	wire	[15: 0]	R16IN3,
	input	wire	[15: 0]	R16IN4,
	input	wire	[15: 0]	R16IN5,
	input	wire	[15: 0]	R16IN6,
	input	wire	[15: 0]	R16IN7,

	/*
	 *   Register 16-bit 
	 * 	 Output	Signals
	 */	
	output	wire	[15: 0]	R16OUT0,
	output	wire	[15: 0]	R16OUT1,
	output	wire	[15: 0]	R16OUT2,
	output	wire	[15: 0]	R16OUT3,
	output	wire	[15: 0]	R16OUT4,
	output	wire	[15: 0]	R16OUT5,
	output	wire	[15: 0]	R16OUT6,
	output	wire	[15: 0]	R16OUT7,
	
	/*
	 *   Register 32-bit 
	 * 	 Input	Signals
	 */
	input	wire	[31: 0]	R32IN0,
	input	wire	[31: 0]	R32IN1,
	input	wire	[31: 0]	R32IN2,
	input	wire	[31: 0]	R32IN3,
	input	wire	[31: 0]	R32IN4,
	input	wire	[31: 0]	R32IN5,
	input	wire	[31: 0]	R32IN6,
	input	wire	[31: 0]	R32IN7,

	/*
	 *   Register 32-bit 
	 * 	 Output	Signals
	 */	
	output	wire	[31: 0]	R32OUT0,
	output	wire	[31: 0]	R32OUT1,
	output	wire	[31: 0]	R32OUT2,
	output	wire	[31: 0]	R32OUT3,
	output	wire	[31: 0]	R32OUT4,
	output	wire	[31: 0]	R32OUT5,
	output	wire	[31: 0]	R32OUT6,
	output	wire	[31: 0]	R32OUT7,	
	
	/*
     *   Instruction ROM Interface 
     *
	 *   32-bit Address	 
	 * 	 BaseAddr = 0x40000000
	 *	 HighAddr = 0x40000800
	 *   Size	 =  2K
     */
    output	wire	[31: 0]    inst_addr,
    input	wire    [31: 0]    inst_data,
    
    /*
     *  Mapped RAM0  Interface  
	 *
	 *  32-bit Address
     *  BaseAddr = 0x00000000
	 *	HighAddr = 0x03ffffff
	 *	Range = 64M
     */
    output   wire               ram_clk,
    output   wire               ram_rst,         
    output	wire	[31: 0]		ram0_raddr,
    input	wire    [31: 0]		ram0_rdata,
    output	wire	        	ram0_ren,
    input	wire            	ram0_rvalid,
    output	wire    [31: 0] 	ram0_waddr,
    output	wire    [31: 0] 	ram0_wdata,
    output	wire            	ram0_wen,
	output	wire	[3 : 0]		ram0_sel,
    input	wire            	ram0_wready,
	
	/*
     *  Mapped RAM1  Interface  
	 *
	 *  32-bit Address
     *  BaseAddr = 0x04000000
	 *	HighAddr = 0x07ffffff
	*	Range = 64M
     */ 
    output	wire	[31: 0]		ram1_raddr,
    input	wire    [31: 0]		ram1_rdata,
    output	wire	        	ram1_ren,
    input	wire            	ram1_rvalid,
    output	wire    [31: 0] 	ram1_waddr,
    output	wire    [31: 0] 	ram1_wdata,
    output	wire            	ram1_wen,
	output	wire	[3 : 0]		ram1_sel,
    input	wire            	ram1_wready	
);

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////	Lab Top Module End (Don't Edit) /////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////



/********************************************************************************
 **************				Memory Interface Start			*********************
 **************		editable if use the menmory interface   *********************
 ********************************************************************************/
	//RAM0 Read Interface
	assign	ram0_ren = 1'b0;
	assign	ram0_raddr = 32'b0;	
	//RAM0 Write Interface
	assign	ram0_waddr = 32'b0;
	assign	ram0_wen = 1'b0;
	assign	ram0_sel = 4'b0000;
	assign	ram0_wdata = 32'b0;
	//RAM1 Read Interface
	assign	ram1_ren = 1'b0;
	assign	ram1_raddr = 32'b0;
	//RAM1 Write Interface
	assign	ram1_waddr = 32'b0;
	assign	ram1_wen = 1'b0;
	assign	ram1_sel = 4'b0000;
	assign	ram1_wdata = 32'b0;
	//RAM CLK AND RESET
	assign ram_clk = step_clk;
	assign ram_rst = 1'b1;
/********************************************************************************
 **************				Memory Interface End		    *********************
 **************		editable if use the menmory interface   *********************
 ********************************************************************************/	
	

	
/********************************************************************************
 **************				IO Register		Start			*********************
 **************If used output siginals under module logic,  *********************
 **************Note the corresponding assign output siginals*********************
 ********************************************************************************/
	/*
	**	SW LED
	**
	*/
	assign	LED00 = SW00;
	assign	LED01 = SW01;
	assign	LED02 = SW02;
	assign	LED03 = SW03;
	assign	LED04 = SW04;
	assign	LED05 = SW05;
	assign	LED06 = SW06;
	assign	LED07 = SW07;
	assign	LED08 = SW08;
	assign	LED09 = SW09;
	assign	LED10 = SW10;
	assign	LED11 = SW11;
	assign	LED12 = SW12;
	assign	LED13 = SW13;
	assign	LED14 = SW14;
	assign	LED15 = SW15;
	assign	LED16 = SW16;
	assign	LED17 = SW17;
	assign	LED18 = SW18;
	assign	LED19 = SW19;
	assign	LED20 = SW20;
	assign	LED21 = SW21;
	assign	LED22 = SW22;
	assign	LED23 = SW23;
	assign	LED24 = SW24;
	assign	LED25 = SW25;
	assign	LED26 = SW26;
	assign	LED27 = SW27;
	assign	LED28 = SW28;
	assign	LED29 = SW29;
	assign  LED30 = SW30;
	assign  LED31 = SW31;
	
	/*
	**	8-bit Register 
	**
	*/	
	assign R8OUT0 = R8IN0;
	assign R8OUT1 = R8IN1;
	assign R8OUT2 = R8IN2;
	assign R8OUT3 = R8IN3;
	assign R8OUT4 = R8IN4;
	assign R8OUT5 = R8IN5;
	assign R8OUT6 = R8IN6;
	assign R8OUT7 = R8IN7;
	
	
	/*
	**	16-bit Register 
	**
	*/
	//assign in_data1 = R16IN0;
	//assign R16OUT0 = out_data;
	//assign R16OUT1 = R16IN1;
	//assign R16OUT2 = R16IN2;
	//assign R16OUT3 = R16IN3;
	//assign R16OUT4 = R16IN4;
	//assign R16OUT5 = R16IN5;
	//assign R16OUT6 = R16IN6;
	//assign R16OUT7 = R16IN7;
	
	/*
	**	32-bit Register 
	**
	*/
	//assign R32OUT0 = R32IN0;
	assign R32OUT1 = R32IN1;
	assign R32OUT2 = R32IN2;
	assign R32OUT3 = R32IN3;
	assign R32OUT4 = R32IN4;
	assign R32OUT5 = R32IN5;
	assign R32OUT6 = R32IN6;
	assign R32OUT7 = R32IN7;

/********************************************************************************
 **************				IO Register	End					*********************
 **************If used output siginals under module logic,  *********************
 **************Note the corresponding assign output siginals*********************
 ********************************************************************************/


 
 
 
 /********************************************************************************
 **************			User Custom Zone Start				*********************
 **************			generate_target wrapper Top 		*********************
 ********************************************************************************/
	
	tinycpu user_wrapper_top_uut
	(
		    .clk(step_clk),
            .micro_ins1(R32OUT0),
            .A_port1(R16OUT0),
			.B_port1(R16OUT1),
			.PC_out1(R16OUT2),
			.IR1(R16OUT3),
			.CU_entry1(R16OUT4),
			.MPC_out1(R16OUT5),
			.F1(R16OUT6),
			.DBUS_out1(R16OUT7),
			.rst(lab_reset)
	);
	 
 /********************************************************************************
 **************			User Custom Zone End				*********************
 **************			generate_target wrapper Top 		*********************
 ********************************************************************************/

endmodule
