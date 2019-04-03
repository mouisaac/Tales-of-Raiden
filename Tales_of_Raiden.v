/*
Arthor: Yu-Hsiang(Isaac) Mou, Ze Jin
Name: Tales of Raiden (dodging game)
Start time: March 8, 2019
Finish time: April 2, 2019

This is a CSCB58 final course project
*/

module TalesOfRaiden
    (
        CLOCK_50,                        //    On Board 50 MHz
        // Your inputs and outputs here
        KEY,
        SW,
        HEX0,
        HEX1,
		HEX4,
		HEX5,
		LEDR
        // The ports below are for the VGA output.
        VGA_CLK,                           //    VGA Clock
        VGA_HS,                            //    VGA H_SYNC
        VGA_VS,                            //    VGA V_SYNC
        VGA_BLANK_N,                        //    VGA BLANK
        VGA_SYNC_N,                        //    VGA SYNC
        VGA_R,                           //    VGA Red[9:0]
        VGA_G,                             //    VGA Green[9:0]
        VGA_B                           //    VGA Blue[9:0]
    );
    // Declare your inputs and outputs here
    input   CLOCK_50;                //    50 MHz
    input   [17:0]   SW;
    input   [3:0]   KEY;
    output   [6:0] HEX0;
    output   [6:0] HEX1;
	 output [6:0] HEX4;
	 output [6:0] HEX5;
	 output [0:0] LEDR;
    // Do not change the following outputs
    output            VGA_CLK;                   //    VGA Clock
    output            VGA_HS;                    //    VGA H_SYNC
    output            VGA_VS;                    //    VGA V_SYNC
    output            VGA_BLANK_N;                //    VGA BLANK
    output            VGA_SYNC_N;                //    VGA SYNC
    output    [9:0]    VGA_R;                   //    VGA Red[9:0]
    output    [9:0]    VGA_G;                     //    VGA Green[9:0]
    output    [9:0]    VGA_B;                   //    VGA Blue[9:0]
   
   
   /*
   !!!CAUTION!!!
   Before you start reading my code, I want to say a few words.
   I have my own rules and conventions for all the different variable names, I have no problem understanding them.
   However, I'm almost certain that you won't be able to grasp those at first glance.
   So I strongly recommend you to look at the comments first to better understand how each peice intertwined together.
   */
   
   
   
   	// real reset for almost every "object"
    reg resetn;
    // reset for the VGA (basically restart the screen)
	 wire resetn2;
	 // always set it to high (it is active low, so we don't accidentally turn off the VGA)
	 assign resetn2 = alwaysOne;
	 
	 // wires for erase all
	 wire [8:0] x_outree;
	 wire [7:0] y_outree;
	 wire [2:0] col_outree;
	 // used to erase everything at the very end, when we want to restart the game
	 erase_all erase(.clock(CLOCK_50), .drawEn(1'b1), .x_out(x_outree), .y_out(y_outree), .col_out(colour_outree));


	// first explosion - small
	 wire [8:0] x_outb1;
	 wire [7:0] y_outb1;
	 wire [2:0] col_outb1;
	 explo1 expb111(.clock(CLOCK_50), .drawEn(1'b1), .x_out(x_outb1), .y_out(y_outb1), .col_out(colour_outb1));

	 // clean the first explosion
	 wire [8:0] x_outb1c;
	 wire [7:0] y_outb1c;
	 wire [2:0] col_outb1c;
	 explo1_after expb111c(.clock(CLOCK_50), .drawEn(1'b1), .x_out(x_outb1c), .y_out(y_outb1c), .col_out(colour_outb1c));

	// second explosion - median
	 wire [8:0] x_outb2;
	 wire [7:0] y_outb2;
	 wire [2:0] col_outb2;
	 explo1 expb222(.clock(CLOCK_50), .drawEn(1'b1), .x_out(x_outb2), .y_out(y_outb2), .col_out(colour_outb2));

	 // clean the second explosion
	 wire [8:0] x_outb2c;
	 wire [7:0] y_outb2c;
	 wire [2:0] col_outb2c;
	 explo1_after expb222c(.clock(CLOCK_50), .drawEn(1'b1), .x_out(x_outb2c), .y_out(y_outb2c), .col_out(colour_outb2c));

	// third explosion - large
	 wire [8:0] x_outb3;
	 wire [7:0] y_outb3;
	 wire [2:0] col_outb3;
	 explo1 expb333(.clock(CLOCK_50), .drawEn(1'b1), .x_out(x_outb3), .y_out(y_outb3), .col_out(colour_outb3));

	 // clean the third explosion
	 wire [8:0] x_outb3c;
	 wire [7:0] y_outb3c;
	 wire [2:0] col_outb3c;
	 explo1_after expb333c(.clock(CLOCK_50), .drawEn(1'b1), .x_out(x_outb3c), .y_out(y_outb3c), .col_out(colour_outb3c));

	 
	 // end game screen (you win)
	 wire [8:0] x_outw;
	 wire [7:0] y_outw;
	 wire [2:0] col_outw;
	 winn wwwin(.clock(CLOCK_50), .drawEn(1'b1), .x_out(x_outw), .y_out(y_outw), .col_out(colour_outw));

	 
	 
	 // erase the background and write PAUSE on the middle (used when pausing the game)
	 wire [8:0] x_out;
	 wire [7:0] y_out;
	 wire [2:0] col_out;
	 wire wipe;
	 assign wipe = SW[4:4];
	 reset_background reset(.clock(CLOCK_50), .drawEn(wipe), .x_out(x_out), .y_out(y_out), .col_out(colour_out));

	// erase PAUSE (used after pausing)
	wire res;
	wire res2;
	 wire [8:0] x_out2;
	 wire [7:0] y_out2;
	 wire [2:0] colour_out2;
	 
	reset_background_after rb1(CLOCK_50, ~wipe, x_out2, y_out2, colour_out2, res);
	 
	 // start screen (game name, totem, instruction to start)
	wire [8:0] x_outs;
	 wire [7:0] y_outs;
	 wire [2:0] colour_outs;
	 wire starts;
	 // use SW17 to start/restart
	 assign starts = SW[17:17];
	 startss ret(.clock(CLOCK_50), .drawEn(~starts), .x_out(x_outs), .y_out(y_outs), .col_out(colour_outs));

	// clean the start screen (used when SW17 is on)
	 wire [8:0] x_outs2;
	 wire [7:0] y_outs2;
	 wire [2:0] colour_outs2;
	 starts_after rb2(CLOCK_50, starts, x_outs2, y_outs2, colour_outs2, res2);
   
    // Create the colour, x, y, and writeEn wires that are inputs to the controller.
    reg [2:0] colour;																																																																																																																																																																																																																																																																																																																																																																																																																					
    reg [9:0] x;
    reg [8:0] y;
    reg writeEn;
	
	// used for debugging (counter for "aftergame" (after 60 seconds))
	hex_display s60bwwww(.IN(bw), .OUT1(HEX5), .OUT2(HEX4));
	
	
	// 60 second game counter (count in seconds, start at 0, stop at 60)
	hex_display s60(.IN(s), .OUT1(HEX1), .OUT2(HEX0));
	// small power of 2 tables used for all relevant counters
	// 2^25=33554432
	// 2^26=67108864
	// 2^27=134217728
	// 2^28=268435456
	// 2^29=536870912
	// 2^30=1073741824
	// 2^31=2147483648
	// 2^32=4294967298
	// 2^32/50000000=85.899
	
	
	// s is used as the input to the above 60s counter
	// this is basically a rate divider (so s is counting in seconds)
	reg [25:0] Q;
	reg [5:0] s;
	reg hexc;
	always@(posedge CLOCK_50)
		begin
			if (resetn == 1'b0)
			begin
				s <= 1'b0;
				Q <= 1'b0;
			end
			// keep the value of s for entering the last state(s)
			else if (s == 6'b111111)
			begin
				s <= s;
			end
			// reset Q per second
			else if (Q == 26'd49999999)
			begin
				s <= s + 1'b1;
				Q <= 1'b0;
			end
			// increment Q per clock cycle (hexc is an enable for the hex counter)
			else if (hexc == 1'b1)
				Q <= Q + 1'b1;
			
		end


	// this is a rate divider which counts in almost 3/5 seconds (for explosion effect)
	reg [25:0] k;
	reg [2:0] bw;
	reg hexcc;
	
	always@(posedge CLOCK_50)
		begin
			if (resetn == 1'b0)
			begin
				bw <= 1'b0;
				k <= 1'b0;
			end
			// keep the value of bw for entering different explosion states
			else if (bw == 3'b111)
			begin
				bw <= bw;
			end
			// start counting when s counts to the end (so the game is in the ending state and missile is launched)
			else if (s == 6'b111111 && k == 26'd29999999)
			begin
				bw <= bw + 1'b1;
				k <= 1'b0;
			end
			else if (hexcc == 1'b1)
			begin
				k <= k + 1'b1;
			end
			
		end
	
		
    // Create an Instance of a VGA controller - there can be only one!
    // Define the number of colours as well as the initial background
    // image file (.MIF) for the controller.
    vga_adapter VGA(
            .resetn(resetn2),
            .clock(CLOCK_50),
            .colour(colour),
            .x(x),
            .y(y),
            .plot(writeEn),
            /* Signals for the DAC to drive the monitor. */
            .VGA_R(VGA_R),
            .VGA_G(VGA_G),
            .VGA_B(VGA_B),
            .VGA_HS(VGA_HS),
            .VGA_VS(VGA_VS),
            .VGA_BLANK(VGA_BLANK_N),
            .VGA_SYNC(VGA_SYNC_N),
            .VGA_CLK(VGA_CLK));
    defparam VGA.RESOLUTION = "320x240";
    defparam VGA.MONOCHROME = "FALSE";
    defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
    defparam VGA.BACKGROUND_IMAGE = "DE2.mif";


	// constants for readability
    reg alwaysOne = 1'b1;
    reg alwaysZero = 1'b0;
	 reg [1:0] speed1 = 2'b00;
	 reg [1:0] speed2 = 2'b01;
	 reg [1:0] speed3 = 2'b10;
	 
	// player aircraft (start from the bottom - middle, use key to control)
    wire [8:0] x_coor_player;
	 wire [7:0] y_coor_player;
	 wire [2:0] colour_player;
	 wire plotAir_player;
	 aircraft p1(
			.clock(CLOCK_50),
			.resetn(resetn),
			.init_x(9'b010001000),
			.init_y(8'b11111111),
			.colour_in(3'b111),
			.speed_in(speed2),
			.move_left(~KEY[3]),
			.move_right(~KEY[0]),
			.move_up(~KEY[2]),
			.move_down(~KEY[1]),
			.draw_coor_x(x_coor_player), 
			.draw_coor_y(y_coor_player),
			.colour_air_out(colour_player),
			.plotAir_out(plotAir_player),
			.pause(wipe)
			);
			
			
	// small aircraft a1 (moves right and down, occasionally up)
	 reg [8:0] x_a1 = 9'b011100011;
	 reg [7:0] y_a1 = 8'b00010000;
	 wire [8:0] x_coor_a1;
	 wire [7:0] y_coor_a1;
	 wire [2:0] color_a1;
	 wire plotAir_a1;

	 smallAircraft a1(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(alwaysZero),
			.move_right(move),
			.move_up(~move2),
			.move_down(move2),
			.init_x(x_a1),
			.init_y(y_a1),
			.colour_in(3'b100),
			.speed_in(speed2),
			.x_coor_out(x_coor_a1), 
			.y_coor_out(y_coor_a1),
			.colour_air_out(color_a1),
			.plotAir_out(plotAir_a1),
			.pause(wipe || pppp)
			);
	
	// counters to determine the movement of a1
	wire move, move2;
	wire [29:0] rate, rate2;
	reg [26:0] restart = 27'b100000000000000000000000000;
	reg [26:0] mid = 27'b01000000000111111000000000;
	reg [26:0] restart2 = 27'b100001100000000000011111000;
	reg [26:0] mid2 = 27'b00011111111100000000000000;

	 RateDividerForTurn rdt1a1(CLOCK_50, rate, 1'b1, restart);
	 assign move= (rate >= mid) ? 1 : 0; 
	 RateDividerForTurn rdt2a1(CLOCK_50, rate2, 1'b1, restart2);
	 assign move2 = (rate2 >= mid2) ? 1 : 0; 
	
	

	// counters to determine the movement of a2
	wire movea2, move2a2;
	wire [8:0] x_coor_a2;
	 wire [7:0] y_coor_a2;
	 wire [2:0] color_a2;
	 wire plotAir_a2;
    reg  [8:0] x_a2 = 9'b011101011;
    reg  [7:0] y_a2 = 8'b00001101;
	reg [26:0] restarta2 = 27'b111100000000000000000000000;
	reg [26:0] mida2 = 27'b10100011000110000000000000;
    wire [26:0] ratea2;
	 RateDividerForTurn rrta2(CLOCK_50, ratea2, 1'b1, restarta2);
	 assign movea2 = (ratea2 >= mida2) ? 1 : 0;
	// enemy aircraft a2 (moves left and down)
	 enemyAircraft a2(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(movea2),
			.move_right(alwaysZero),
			.move_up(alwaysZero),
			.move_down(~movea2),
			.init_x(x_a2),
			.init_y(y_a2),
			.colour_in(3'b001),
			.speed_in(speed1),
			.x_coor_out(x_coor_a2), 
			.y_coor_out(y_coor_a2),
			.colour_air_out(color_a2),
			.plotAir_out(plotAir_a2),
			.pause(wipe || pppp)
			);

	
	// enemy aircraft n2 (moves right, up and down)
	wire moven2, moven3;
	wire [8:0] x_coor_n2;
	 wire [7:0] y_coor_n2;
	 wire [2:0] color_n2;
	 wire plotAir_n2;
	
	enemyAircraft n2(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(alwaysZero),
			.move_right(~moven2),
			.move_up(moven3),
			.move_down(moven2),
			.init_x(x_n2),
			.init_y(y_n2),
			.colour_in(3'b001),
			.speed_in(speed2),
			.x_coor_out(x_coor_n2), 
			.y_coor_out(y_coor_n2),
			.colour_air_out(color_n2),
			.plotAir_out(plotAir_n2),
			.pause(wipe || pppp)
			);
	
	// counters to determine the movement of n2
	reg  [8:0] x_n2 = 9'b000000011;
    reg  [7:0] y_n2 = 8'b11111101;
	reg [26:0] restartn2 = 27'b111111000000000000000000000;
	reg [26:0] midn2 = 27'b10100011000110000000000000;
    wire [26:0] raten2;
	 RateDividerForTurn rrtn2(CLOCK_50, raten2, eeee, restartn2);
	 assign moven2 = (raten2 >= midn2) ? 1 : 0;
	 
	reg [26:0] restartn3 = 27'b111100000000000000000000000;
	reg [26:0] midn3 = 27'b01100011000110000000000000;
    wire [26:0] raten3;
	 RateDividerForTurn rrtn3(CLOCK_50, raten3, eeee, restartn3);
	 assign moven3 = (raten3 >= midn3) ? 1 : 0;
	
	
	
	// enemy aircraft n3 (moves right and down, sometimes up)
	wire moven4, moven5;
	wire [8:0] x_coor_n3;
	 wire [7:0] y_coor_n3;
	 wire [2:0] color_n3;
	 wire plotAir_n3;
	
	enemyAircraft n3(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(alwaysZero),
			.move_right(moven4),
			.move_up(~moven5),
			.move_down(~move4),
			.init_x(x_n3),
			.init_y(y_n3),
			.colour_in(3'b011),
			.speed_in(speed2),
			.x_coor_out(x_coor_n3), 
			.y_coor_out(y_coor_n3),
			.colour_air_out(color_n3),
			.plotAir_out(plotAir_n3),
			.pause(wipe || pppp)
			);
	
	// counters to determine the movement of n3
	reg  [8:0] x_n3 = 9'b101000011;
    reg  [7:0] y_n3 = 8'b00011101;
	reg [26:0] restartn4 = 27'b111111100000000000000000000;
	reg [26:0] midn4 = 27'b10110011000110000000000000;
    wire [26:0] raten4;
	 RateDividerForTurn rrtn4(CLOCK_50, raten4, eeee, restartn4);
	 assign moven4 = (raten3 >= midn3) ? 1 : 0;
	 
	reg [26:0] restartn5 = 27'b11111000000000000000000000;
	reg [26:0] midn5 = 27'b01110011000110000000000000;
    wire [26:0] raten5;
	 RateDividerForTurn rrtn5(CLOCK_50, raten5, eeee, restartn5);
	 assign moven5 = (raten5 >= midn5) ? 1 : 0;
		
	
	// enemy aircraft a4 (moves left and right)
	wire [8:0] x_coor_a4;
	 wire [7:0] y_coor_a4;
	 wire [2:0] color_a4;
	 wire plotAir_a4;
		
		 enemyAircraft a4(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(righta4),
			.move_right(~righta4),
			.move_up(alwaysZero),
			.move_down(alwaysZero),
			.init_x(9'b110101111),
			.init_y(8'b01010000),
			.colour_in(3'b011),
			.speed_in(speed2),
			.x_coor_out(x_coor_a4), 
			.y_coor_out(y_coor_a4),
			.colour_air_out(color_a4),
			.plotAir_out(plotAir_a4),
			.pause(wipe || pppp)
			);
		
		// counter to determine the movement of a4
		reg eeee; // enable for most of the enemy aircrafts
		wire righta4;
		wire [8:0] ch;
		reg [28:0] B = 29'b1000000000000000100000000000;
		RateDividerForTurn rrta4(CLOCK_50, ch, eeee, 29'b1111111111111111111111111111);
		assign righta4= (ch > B) ? 0 : 1;
	
	
	
	// small aircrafts from L to L4
	
	reg llll;  // reset for L aircrafts
	wire [8:0] x_coor_l;
	 wire [7:0] y_coor_l;
	 wire [2:0] color_l;
	 wire plotAir_l;
	 	wire moveleft2;
		
		 smallAircraft l(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(moveleft2),
			.move_right(~moveleft2),
			.move_up(alwaysZero),
			.move_down(alwaysZero),
			.init_x(9'b010000100),
			.init_y(8'b11101110),
			.colour_in(3'b010),
			.speed_in(speed1),
			.x_coor_out(x_coor_l), 
			.y_coor_out(y_coor_l),
			.colour_air_out(color_l),
			.plotAir_out(plotAir_l),
			.pause(wipe || pppp)
			);
		
		
	reg [28:0] restartl = 29'b1111101111111111111111111111;
	reg [28:0] midal = 29'b1000000000000000100000000000;
    wire [28:0] ratel;
	 RateDividerForTurn rrtl2(CLOCK_50, ratel, llll, restartl);
	 assign moveleft2 = (ratel >= midal) ? 1 : 0;
	
	
	
	wire [8:0] x_coor_l2;
	 wire [7:0] y_coor_l2;
	 wire [2:0] color_l2;
	 wire plotAir_l2;
		
		 smallAircraft l2(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(moveleft2),
			.move_right(~moveleft2),
			.move_up(alwaysZero),
			.move_down(alwaysZero),
			.init_x(9'b010000100),
			.init_y(8'b01000000),
			.colour_in(3'b010),
			.speed_in(speed1),
			.x_coor_out(x_coor_l2), 
			.y_coor_out(y_coor_l2),
			.colour_air_out(color_l2),
			.plotAir_out(plotAir_l2),
			.pause(wipe || pppp)
			);
		
		
	wire [8:0] x_coor_l3;
	 wire [7:0] y_coor_l3;
	 wire [2:0] color_l3;
	 wire plotAir_l3;
		
		 smallAircraft l3(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(moveleft2),
			.move_right(~moveleft2),
			.move_up(alwaysZero),
			.move_down(alwaysZero),
			.init_x(9'b010000100),
			.init_y(8'b00001111),
			.colour_in(3'b010),
			.speed_in(speed1),
			.x_coor_out(x_coor_l3), 
			.y_coor_out(y_coor_l3),
			.colour_air_out(color_l3),
			.plotAir_out(plotAir_l3),
			.pause(wipe || pppp)
			);
			
		wire [8:0] x_coor_l4;
	 wire [7:0] y_coor_l4;
	 wire [2:0] color_l4;
	 wire plotAir_l4;
	
			 smallAircraft l4(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(moveleft2),
			.move_right(~moveleft2),
			.move_up(alwaysZero),
			.move_down(alwaysZero),
			.init_x(9'b010000100),
			.init_y(8'b10011111),
			.colour_in(3'b010),
			.speed_in(speed1),
			.x_coor_out(x_coor_l4), 
			.y_coor_out(y_coor_l4),
			.colour_air_out(color_l4),
			.plotAir_out(plotAir_l4),
			.pause(wipe || pppp)
			);
	
			
			
			
	// small aircrafts from i to i4
	
	reg iiii;  // reset for i aircrafts
	wire [8:0] x_coor_li;
	 wire [7:0] y_coor_li;
	 wire [2:0] color_li;
	 wire plotAir_li;
	 	wire moveright2;
		
		 smallAircraft li(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(~moveright2),
			.move_right(moveright2),
			.move_up(alwaysZero),
			.move_down(alwaysZero),
			.init_x(9'b111110100),
			.init_y(8'b10101110),
			.colour_in(3'b100),
			.speed_in(speed1),
			.x_coor_out(x_coor_li), 
			.y_coor_out(y_coor_li),
			.colour_air_out(color_li),
			.plotAir_out(plotAir_li),
			.pause(wipe || pppp)
			);
		
		
	reg [28:0] restartli = 29'b1111001111111111111111111111;
	reg [28:0] midali = 29'b1000000000000000100000000000;
    wire [28:0] rateli;
	 RateDividerForTurn rrtli2(CLOCK_50, rateli, iiii, restartli);
	 assign moveright2 = (rateli >= midali) ? 1 : 0;
	
	
	
		wire [8:0] x_coor_li2;
	 wire [7:0] y_coor_li2;
	 wire [2:0] color_li2;
	 wire plotAir_li2;
		
		 smallAircraft li2(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(~moveright2),
			.move_right(moveright2),
			.move_up(alwaysZero),
			.move_down(alwaysZero),
			.init_x(9'b111110100),
			.init_y(8'b00011101),
			.colour_in(3'b100),
			.speed_in(speed1),
			.x_coor_out(x_coor_li2), 
			.y_coor_out(y_coor_li2),
			.colour_air_out(color_li2),
			.plotAir_out(plotAir_li2),
			.pause(wipe || pppp)
			);
		
		
	wire [8:0] x_coor_li3;
	 wire [7:0] y_coor_li3;
	 wire [2:0] color_li3;
	 wire plotAir_li3;
		
		 smallAircraft li3(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(~moveright2),
			.move_right(moveright2),
			.move_up(alwaysZero),
			.move_down(alwaysZero),
			.init_x(9'b111110100),
			.init_y(8'b11101101),
			.colour_in(3'b100),
			.speed_in(speed1),
			.x_coor_out(x_coor_li3), 
			.y_coor_out(y_coor_li3),
			.colour_air_out(color_li3),
			.plotAir_out(plotAir_li3),
			.pause(wipe || pppp)
			);
			
		
	wire [8:0] x_coor_li4;
	 wire [7:0] y_coor_li4;
	 wire [2:0] color_li4;
	 wire plotAir_li4;
	
			 smallAircraft li4(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(~moveright2),
			.move_right(moveright2),
			.move_up(alwaysZero),
			.move_down(alwaysZero),
			.init_x(9'b111110100),
			.init_y(8'b01101101),
			.colour_in(3'b100),
			.speed_in(speed1),
			.x_coor_out(x_coor_li4), 
			.y_coor_out(y_coor_li4),
			.colour_air_out(color_li4),
			.plotAir_out(plotAir_li4),
			.pause(wipe || pppp)
			);
	
	
	
	// small aircrafts from r to r4
	
	reg rrrr; // reset for R aircrafts when entering the stay state right before drawing them (they will appear next)
	wire [8:0] x_coor_r;
	 wire [7:0] y_coor_r;
	 wire [2:0] color_r;
	 wire plotAir_r;
	 
	 wire moveup, moveup2, moveup3, moveup4;
		
		 smallAircraft r(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(alwaysZero),
			.move_right(alwaysZero),
			.move_up(moveup),
			.move_down(~moveup),
			.init_x(9'b100001111),
			.init_y(8'b00000100),
			.colour_in(3'b110),
			.speed_in(speed1),
			.x_coor_out(x_coor_r), 
			.y_coor_out(y_coor_r),
			.colour_air_out(color_r),
			.plotAir_out(plotAir_r),
			.pause(wipe || pppp)
			);
		
	reg [28:0] restartr = 29'b111111111111111111111111110;
	reg [28:0] midar = 29'b010000000000000000000000000;
    wire [28:0] rater;
	 RateDividerForTurn rrtr(CLOCK_50, rater, rrrr, restartr);
	 assign moveup = (rater >= midar) ? 1 : 0;
	 
	 
	 
	wire [8:0] x_coor_r2;
	 wire [7:0] y_coor_r2;
	 wire [2:0] color_r2;
	 wire plotAir_r2;
		
		 smallAircraft r2(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(alwaysZero),
			.move_right(alwaysZero),
			.move_up(moveup2),
			.move_down(~moveup2),
			.init_x(9'b101000111),
			.init_y(8'b00000100),
			.colour_in(3'b110),
			.speed_in(speed1),
			.x_coor_out(x_coor_r2), 
			.y_coor_out(y_coor_r2),
			.colour_air_out(color_r2),
			.plotAir_out(plotAir_r2),
			.pause(wipe || pppp)
			);
		
	reg [28:0] restartr2 = 29'b111111111111111111111101110; // 27b
	reg [28:0] midar2 = 29'b100000000000000000000000000; // 27b
    wire [28:0] rater2;
	 RateDividerForTurn rrtr2(CLOCK_50, rater2, rrrr, restartr2);
	 assign moveup2 = (rater2 >= midar2) ? 1 : 0;
	 
	 
	 
	wire [8:0] x_coor_r3;
	 wire [7:0] y_coor_r3;
	 wire [2:0] color_r3;
	 wire plotAir_r3;
		
		 smallAircraft r3(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(alwaysZero),
			.move_right(alwaysZero),
			.move_up(moveup3),
			.move_down(~moveup3),
			.init_x(9'b011001011),
			.init_y(8'b00000100),
			.colour_in(3'b110),
			.speed_in(speed1),
			.x_coor_out(x_coor_r3), 
			.y_coor_out(y_coor_r3),
			.colour_air_out(color_r3),
			.plotAir_out(plotAir_r3),
			.pause(wipe || pppp)
			);
		
	reg [28:0] restartr3 = 29'b111111111111111111110101110; // 27b
	reg [28:0] midar3 = 29'b100000000000000000000000000; // 27b
    wire [28:0] rater3;
	 RateDividerForTurn rrtr3(CLOCK_50, rater3, rrrr, restartr3);
	 assign moveup3 = (rater3 >= midar3) ? 1 : 0;
	
	
	wire [8:0] x_coor_r4;
	 wire [7:0] y_coor_r4;
	 wire [2:0] color_r4;
	 wire plotAir_r4;
		
		 smallAircraft r4(
			.clock(CLOCK_50),
			.resetn(resetn),
			.move_left(alwaysZero),
			.move_right(alwaysZero),
			.move_up(moveup4),
			.move_down(~moveup4),
			.init_x(9'b000011101),
			.init_y(8'b00000100),
			.colour_in(3'b110),
			.speed_in(speed1),
			.x_coor_out(x_coor_r4), 
			.y_coor_out(y_coor_r4),
			.colour_air_out(color_r4),
			.plotAir_out(plotAir_r4),
			.pause(wipe || pppp)
			);
		
	reg [28:0] restartr4 = 29'b101111111111111011110101110; // 27b
	reg [28:0] midar4 = 29'b100000000000000000000000000; // 27b
    wire [28:0] rater4;
	 RateDividerForTurn rrtr4(CLOCK_50, rater4, rrrr, restartr4);
	 assign moveup4 = (rater4 >= midar4) ? 1 : 0;
		
		
		

	// BOSS aircraft (start at the middle, upper left)
	 wire [8:0] x_coor_a3;
	 wire [7:0] y_coor_a3;
	 wire [2:0] color_a3;
	 wire plotAir_a3;
	 bossAircraft e1(
			.clock(CLOCK_50),
			.resetn(resetn),
			.init_x(9'b010011000),
			.init_y(8'b001111110),
			.colour_in(3'b101),
			.speed_in(speed2),
			.move_left(L),
			.move_right(R),
			.move_up(U),
			.move_down(D),
			.x_coor_out(x_coor_a3), 
			.y_coor_out(y_coor_a3),
			.colour_air_out(color_a3),
			.plotAir_out(plotAir_a3),
			.pause(paa || pppp || wipe)
			);
	
	// counters for "circular" movement (right -> down -> left -> up)
	wire R, L, U, D;
	wire [30:0] rateb;
	/*
	smaller circle
	reg [30:0] restarts = 31'd268435440;
	reg [30:0] quar1 = 31'd67108860;
	reg [30:0] quar2 = 31'd134217720;
	reg [30:0] quar3 = 31'd201326580;
	*/
	// slightly bigger circle
	reg [31:0] restarts = 31'd107108660;
	reg [31:0] quar1 = 31'd26777165;
	reg [31:0] quar2 = 31'd53554330;
	reg [31:0] quar3 = 31'd80331495;

	 
	 RateDividerForTurn rdtboss(CLOCK_50, rateb, 1'b1, restarts);
	 assign R = (rateb > 0 && rateb < quar1) ? 1 : 0; 
	 assign D = (rateb > quar1 && rateb < quar2) ? 1 : 0;
	 assign L = (rateb > quar2 && rateb < quar3) ? 1 : 0;
	 assign U = (rateb > quar3) ? 1 : 0;

	// counter to determine the occasional "stops" that the boss will perform
	wire paa;
		reg [28:0] restartrpaa = 29'b011111111111111011110101110; // 27b
	reg [28:0] midarpaa = 29'b011110000000000000000000000; // 27b
    wire [28:0] raterpaa;
	 RateDividerForTurn rrtpaa(CLOCK_50, raterpaa, mmmm, restartrpaa);
	 assign paa = (raterpaa >= midarpaa) ? 1 : 0;
	
	// missile (will appear at the bottom middle)
	
	reg mmmm; // reset for missile
	wire [8:0] x_coor_m;
	 wire [7:0] y_coor_m;
	 wire [2:0] color_m;
	 wire plotAir_m;
	 missile m1(
			.clock(CLOCK_50),
			.resetn(resetn),
			.init_x(9'b010000110),
			.init_y(8'b11101100),
			.colour_in(3'b100),
			.speed_in(speed1),
			.move_left(alwaysZero),
			.move_right(alwaysZero),
			.move_up(alwaysOne),
			.move_down(alwaysZero),
			.x_coor_out(x_coor_m),
			.y_coor_out(y_coor_m),
			.colour_air_out(color_m),
			.plotAir_out(plotAir_m),
			.pause(wipe || pppp)
			);
	
	
	
	// all the counters for different enemy "waves"
	
	reg E; // enable for "stay" counters (stay until their turn)
	// first
	wire [29:0] scount2;
	wire stay2;
	reg [29:0] B282 = 30'd234217728;
	StayCounter sc_2(.clock(CLOCK_50), .Clear_b(resetn), .E(E), .stay(scount2), .duration(30'd536870910));
	assign stay2= (scount2 > B282) ? 0 : 1;
	
	// second
	wire [29:0] scount;
	wire stay1;
	reg [29:0] B28 = 30'd468435456;
	StayCounter sc_1(.clock(CLOCK_50), .Clear_b(resetn), .E(E), .stay(scount), .duration(30'd1073741820));
	assign stay1= (scount > B28) ? 0 : 1;
	
	// third
	wire [30:0] scount3;
	wire stay3;
	reg [30:0] B2828 = 31'd702653184;
	StayCounter sc_3(.clock(CLOCK_50), .Clear_b(resetn), .E(E), .stay(scount3), .duration(31'd1610612730));
	assign stay3= (scount3 > B2828) ? 0 : 1;
	
	
	// forth
	wire [31:0] scount4;
	wire stay4;
	reg [31:0] B28282 = 32'd1073741820;
	StayCounter sc_4(.clock(CLOCK_50), .Clear_b(resetn), .E(E), .stay(scount4), .duration(32'd2147483640));
	assign stay4= (scount4 > B28282) ? 0 : 1;
	
	// last
	wire [31:0] scountboss;
	wire stayboss;
	reg [31:0] s30 = 32'd1594967290;
	StayCounter sc_b(.clock(CLOCK_50), .Clear_b(resetn), .E(E), .stay(scountboss), .duration(32'd3094967290));
	assign stayboss= (scountboss > s30) ? 0 : 1;
	
	
	// checking bits for switching states (from drawing to cleaning)
	
	// check for the start screen
	wire chec;
	reg [19:0] ccc;
	assign chec = (ccc == 20'd0) ? 0: 1;
	
	// check for the pause screen
	wire chec2;
	reg [19:0] ccc2;
	assign chec2 = (ccc2 == 20'd0) ? 0: 1;
	
	// check for the first explosion
	wire checb1;
	reg [19:0] cccb1;
	assign checb1 = (cccb1 == 20'd0) ? 0: 1;
	
	// check for the second explosion
	wire checb2;
	reg [19:0] cccb2;
	assign checb2 = (cccb2 == 20'd0) ? 0: 1;
	
	// check for the third explosion
	wire checb3;
	reg [19:0] cccb3;
	assign checb3 = (cccb3 == 20'd0) ? 0: 1;
	
	// check for the end screen
	wire checw;
	reg [19:0] cccw;
	assign checw = (cccw == 20'd0) ? 0: 1;

	//Check Crash
	 reg [8:0] ploting_coor_x;
	 reg [7:0] ploting_coor_y;
	 reg startChecking = 1'b0;
	 // check players collision
	 always @(posedge CLOCK_50)
    begin
		//startChecking <= 0;
		// check before any enemy aircraft plot
		// into any of player's coordinate
		// then we have a crash and reset player
		
		// exact pattern of the actual plotting (according to the wave design)
		if (finished_checking)
		begin
			startChecking <= 1'b0;
		end
		if (plotAir_a1)
			begin
				ploting_coor_x <= x_coor_a1;
				ploting_coor_y <= y_coor_a1;
				startChecking <= 1'b1;
			end
		else if (plotAir_a1)
         begin
				ploting_coor_x <= x_coor_a1;                       
				ploting_coor_y <= y_coor_a1;
				startChecking <= 1'b1;
         end
		
					
		else if (stay2)  
           begin
				startChecking <= 1'b0;
           end
			
		else if (plotAir_l)
			begin
				ploting_coor_x <= x_coor_l;
				ploting_coor_y <= y_coor_l;
				startChecking <= 1'b1;
			end
			
		else if (plotAir_l2)
			begin
				ploting_coor_x <= x_coor_l2;
				ploting_coor_y <= y_coor_l2;
				startChecking <= 1'b1;
			end
		else if (plotAir_l3)
			begin
				ploting_coor_x <= x_coor_l3;
				ploting_coor_y <= y_coor_l3;
				startChecking <= 1'b1;
		end
		
		else if (plotAir_l4)
			begin
				ploting_coor_x <= x_coor_l4;
				ploting_coor_y <= y_coor_l4;
				startChecking <= 1'b1;
			end
		
		else if (stay1)  
           begin
					startChecking <= 1'b0;
           end
	
		else if (plotAir_r)
			begin
				ploting_coor_x <= x_coor_r;
				ploting_coor_y <= y_coor_r;
				startChecking <= 1'b1;
			end

		else if (plotAir_r2)
			begin
				ploting_coor_x <= x_coor_r2;
				ploting_coor_y <= y_coor_r2;
				startChecking <= 1'b1;
			end
		
		else if (plotAir_r3)
			begin
				ploting_coor_x <= x_coor_r3;
				ploting_coor_y <= y_coor_r3;
				startChecking <= 1'b1;
			end
		else if (plotAir_r4)
			begin
				ploting_coor_x <= x_coor_r4;
				ploting_coor_y <= y_coor_r4;
				startChecking <= 1'b1;
			end

		else if (plotAir_a2) 
			begin
				 ploting_coor_x <= x_coor_a2;              
				 ploting_coor_y <= y_coor_a2;
				 startChecking <= 1'b1;
			end
			
		else if (plotAir_li)
			begin
				ploting_coor_x <= x_coor_li;
				ploting_coor_y <= y_coor_li;
				startChecking <= 1'b1;
			end
		
		else if (plotAir_li2)
			begin
				ploting_coor_x <= x_coor_li2;
				ploting_coor_y <= y_coor_li2;
				startChecking <= 1'b1;

			end
		else if (plotAir_li3)
			begin
				ploting_coor_x <= x_coor_li3;
				ploting_coor_y <= y_coor_li3;
				startChecking <= 1'b1;
			end
		
		else if (plotAir_li4)
			begin
				ploting_coor_x <= x_coor_li4;
				ploting_coor_y <= y_coor_li4;
				startChecking <= 1'b1;
			end
	
		else if (stay4)  
            begin
					startChecking <= 1'b0;
            end
		
		else if (plotAir_a4) 
			begin
				 ploting_coor_x <= x_coor_a4;              
				 ploting_coor_y <= y_coor_a4;
				 startChecking <= 1'b1;
			end
		
		else if (plotAir_n2) 
			begin
				 ploting_coor_x <= x_coor_n2;              
				 ploting_coor_y <= y_coor_n2;
				 startChecking <= 1'b1;
			end
		
		else if (plotAir_n3) 
			begin
				 ploting_coor_x <= x_coor_n3;              
				 ploting_coor_y <= y_coor_n3;
				 startChecking <= 1'b1;
			end
		
		else if (stayboss)  
            begin
					startChecking <= 1'b0;
            end
		
		else if (plotAir_a3) 
			begin
				 ploting_coor_x <= x_coor_a3;              
				 ploting_coor_y <= y_coor_a3;
				 startChecking <= 1'b1;
			end
    end

	 wire enable_check, finished_checking, checkPlot;
	 wire [8:0] check_coor_x;
	 wire [7:0] check_coor_y;
	 
	 Counter320 c6(.clock(CLOCK_50), .Clear_b(1'b1), .Enable(startChecking), .q(check_coor_x));
	 assign enable_check = (check_coor_x == 9'd320) ? 1 : 0;
	 Counter240 c4(.clock(CLOCK_50), .Clear_b(1'b1), .Enable(enable_check), .q(check_coor_y));
	 assign finished_checking = (check_coor_y == 18'd240) ? 1 : 0;
	 PlotAircraft check(.clk(CLOCK_50),
					.characterPositionX(cur_coor_x_p),
					.characterPositionY(cur_coor_y_p),
					.drawingPositionX(check_coor_x),
					.drawingPositionY(check_coor_y),
					.plot(checkPlot)
					);
	 // active 0 crash
	 reg crashed = 1'b1;
	 always @(posedge CLOCK_50)
    begin
		if (checkPlot)
			begin
			if(check_coor_x == ploting_coor_x && check_coor_y == ploting_coor_y)
				crashed <= 1'b0;
			end
			/*
			else
			begin
				crashed <= 1'b1;
			end
			*/
    end
    
    
    reg pppp; // pause for all aircrafts when reaching end screen
	 assign LEDR[0:0] = ~crashed; // debug for crash
 
    //The following for processing player movement and aircraft movement
    // For example: if player is moving ,then link the vga to the player, if the aircraft is moving, than link the vga to the aircraft
    // The following is for choosing output according to the "state" of the game
    always @(posedge CLOCK_50)
    begin
			writeEn <= 1'b0;
			// after end screen, wipe everything
			if (s == 6'b111111 && ~starts && checw == 1'b1)
				begin
                writeEn <= 1'b1;    
                x <= x_outree;        
                y <= y_outree;
                colour <= colour_outree;
					 E <= 1'b0;
					 hexc <= 1'b0;
					 hexcc <= 1'b0;
					 cccw <= cccw - 1'b1;
					 resetn <= 1'b0;
					 E <= 1'b0;
					 hexc <= 1'b0;
					 pppp <= 1'b0;
					 
            end
            // draw start screen
			if (~starts)
				begin
					 ccc2 <= 20'd767990;
					 //chec <= 1;
                writeEn <= 1'b1;
                x <= x_outs;
                y <= y_outs;
                colour <= colour_outs;
					 resetn <= 1'b0;
					 E <= 1'b0;
					 hexc <= 1'b0;
					 hexcc <= 1'b0;
					 pppp <= 1'b0;
            end
            // wipe start screen
			else if (starts && chec2 == 1'b1)
				begin
				writeEn <= res2;
				x <= x_outs2;
				y <= y_outs2;
				colour <= colour_outs2;
				ccc2 <= ccc2 - 1'b1;
				resetn <= 1'b1;
				E <= 1'b1;
				hexc <= 1'b1;
				pppp <= 1'b0;
 				end
			
			// pause the screen
			else if (wipe)
				begin
					 ccc <= 20'd767990;
					 //chec <= 1;
                writeEn <= 1'b1;    
                x <= x_out;        
                y <= y_out;
                colour <= colour_out;
					 E <= 1'b0;
					 hexc <= 1'b0;
            end
            // wipe the pause screen
			else if (~wipe && chec == 1'b1)
				begin
				writeEn <= 1'b1;
				x <= x_out2;
				y <= y_out2;
				colour <= colour_out2;
				ccc <= ccc - 1'b1;
				E <= 1'b1;
				end
			// plot player aircraft
			else if(plotAir_player) 
            begin
                writeEn <= 1'b1;
                E <= 1'b1;
					 hexc <= 1'b1;
					 x <= x_coor_player;       
                y <= y_coor_player;
                colour <= colour_player;
            end
            // plot aircraft a1
			else if (plotAir_a1)
            begin
                writeEn <= 1'b1;
					 E <= 1'b1;
					 hexc <= 1'b1;	
                x <= x_coor_a1;                       
                y <= y_coor_a1;
                colour <= color_a1;
            end
			
			// plot aircrafts below only when stay2 finished counting
			else if (stay2)  
            begin
                writeEn <= 1'b0;
					 E <= 1'b1;
					 hexc <= 1'b1;
					 llll <= 1'b1;
            end
					
			// plot aircraft L to L4
			
			else if (plotAir_l)
			begin
					writeEn <= 1'b1;
					x <= x_coor_l;
					y <= y_coor_l;
					colour <= color_l;
					E <= 1'b1;
					hexc <= 1'b1;
			end
			
			else if (plotAir_l2)
			begin
					writeEn <= 1'b1;
					x <= x_coor_l2;
					y <= y_coor_l2;
					colour <= color_l2;
					E <= 1'b1;
					hexc <= 1'b1;

			end
			else if (plotAir_l3)
			begin
					writeEn <= 1'b1;
					x <= x_coor_l3;
					y <= y_coor_l3;
					colour <= color_l3;
					E <= 1'b1;
					hexc <= 1'b1;
			end
			
			else if (plotAir_l4)
			begin
					writeEn <= 1'b1;
					x <= x_coor_l4;
					y <= y_coor_l4;
					colour <= color_l4;
					E <= 1'b1;
					hexc <= 1'b1;
			end
			
			
			// plot below when stay1 finishes counting
			
			else if (stay1)  
            begin
                writeEn <= 1'b0;
						E <= 1'b1;
						hexc <= 1'b1;
						rrrr <= 1'b1;
            end
			
			// plot aircraft r to r4
			
			else if (plotAir_r)
			begin
					writeEn <= 1'b1;
					x <= x_coor_r;
					y <= y_coor_r;
					colour <= color_r;
					E <= 1'b1;
					hexc <= 1'b1;
			end

			else if (plotAir_r2)
			begin
					writeEn <= 1'b1;
					x <= x_coor_r2;
					y <= y_coor_r2;
					colour <= color_r2;
					E <= 1'b1;
					hexc <= 1'b1;
			end
			
			else if (plotAir_r3)
			begin
					writeEn <= 1'b1;
					x <= x_coor_r3;
					y <= y_coor_r3;
					colour <= color_r3;
					E <= 1'b1;
					hexc <= 1'b1;
			end
			
			else if (plotAir_r4)
			begin
					writeEn <= 1'b1;
					x <= x_coor_r4;
					y <= y_coor_r4;
					colour <= color_r4;
					E <= 1'b1;
					hexc <= 1'b1;
			end
			
			// plot below until stay3 finishes counting
			
			else if (stay3)  
            begin
                writeEn <= 1'b0;
						E <= 1'b1;
						hexc <= 1'b1;
						//eeee <= 1'b1;
						iiii <= 1'b1;
            end
            
            // plot a2, i to i4

			else if (plotAir_a2) 
            begin
                writeEn <= 1'b1;
                x <= x_coor_a2;              
                y <= y_coor_a2;
                colour <= color_a2;
					 E <= 1'b1;
					 hexc <= 1'b1;
            end
				
			
			else if (plotAir_li)
			begin
					writeEn <= 1'b1;
					x <= x_coor_li;
					y <= y_coor_li;
					colour <= color_li;
					E <= 1'b1;
					hexc <= 1'b1;
			end
			
			else if (plotAir_li2)
			begin
					writeEn <= 1'b1;
					x <= x_coor_li2;
					y <= y_coor_li2;
					colour <= color_li2;
					E <= 1'b1;
					hexc <= 1'b1;

			end
			else if (plotAir_li3)
			begin
					writeEn <= 1'b1;
					x <= x_coor_li3;
					y <= y_coor_li3;
					colour <= color_li3;
					E <= 1'b1;
					hexc <= 1'b1;
			end
			
			else if (plotAir_li4)
			begin
					writeEn <= 1'b1;
					x <= x_coor_li4;
					y <= y_coor_li4;
					colour <= color_li4;
					E <= 1'b1;
					hexc <= 1'b1;
			end
			
			
			// plot below until stay4 finishes counting
			else if (stay4)  
            begin
                writeEn <= 1'b0;
						E <= 1'b1;
						hexc <= 1'b1;
						eeee <= 1'b1;
            end
            
            // plot a4, n2, n3
			
			else if (plotAir_a4) 
            begin
                writeEn <= 1'b1;
                x <= x_coor_a4;              
                y <= y_coor_a4;
                colour <= color_a4;
					 E <= 1'b1;
					 hexc <= 1'b1;
            end
			
			else if (plotAir_n2) 
            begin
                writeEn <= 1'b1;
                x <= x_coor_n2;              
                y <= y_coor_n2;
                colour <= color_n2;
					 E <= 1'b1;
					 hexc <= 1'b1;
            end
			
			else if (plotAir_n3) 
            begin
                writeEn <= 1'b1;
                x <= x_coor_n3;              
                y <= y_coor_n3;
                colour <= color_n3;
					 E <= 1'b1;
					 hexc <= 1'b1;
            end
			
			
			// plot boss until stayboss finishes counting (about 30s)
				
			else if (stayboss)  
            begin
                writeEn <= 1'b0; 
					E <= 1'b1;	
					hexc <= 1'b1;
					hexcc <= 1'b1;
            end
			
			else if (plotAir_a3) 
            begin
                writeEn <= 1'b1;
                x <= x_coor_a3;              
                y <= y_coor_a3;
                colour <= color_a3;
					 E <= 1'b1;
					 hexc <= 1'b1;
            end
			
			// first explosion (shock wave)
			else if (bw == 3'b001)
				begin
					 cccb1 <= 20'd767990;
                writeEn <= 1'b1;
                x <= x_outb1;
                y <= y_outb1;
                colour <= colour_outb1;
					 //resetn <= 1'b0;
					 E <= 1'b0;
					 hexc <= 1'b1;
					 hexcc <= 1'b1;
            end
			
			// clean first explosion
			else if (bw == 3'b010 && checb1 == 1'b1)
				begin
				writeEn <= 1'b1;
				x <= x_outb1c;
				y <= y_outb1c;
				colour <= colour_outb1c;
				cccb1 <= cccb1 - 1'b1;
				//resetn <= 1'b1;
				E <= 1'b1;
				hexc <= 1'b1;
				hexcc <= 1'b1;
 				end
			
			// second explosion (shock wave)
			else if (bw == 3'b011)
				begin
					 cccb2 <= 20'd767990;
                writeEn <= 1'b1;
                x <= x_outb2;
                y <= y_outb2;
                colour <= colour_outb2;
					 //resetn <= 1'b0;
					 E <= 1'b0;
					 hexc <= 1'b1;
					 hexcc <= 1'b1;
            end
			
			// clean second explosion
			else if (bw == 3'b100 && checb2 == 1'b1)
				begin
				writeEn <= 1'b1;
				x <= x_outb2c;
				y <= y_outb2c;
				colour <= colour_outb2c;
				cccb2 <= cccb2 - 1'b1;
				//resetn <= 1'b1;
				E <= 1'b1;
				hexc <= 1'b1;
				hexcc <= 1'b1;
 				end
			
			// third explosion (shock wave)
			else if (bw == 3'b101)
				begin
					 cccb3 <= 20'd767990;
                writeEn <= 1'b1;
                x <= x_outb3;
                y <= y_outb3;
                colour <= colour_outb3;
					 //resetn <= 1'b0;
					 E <= 1'b0;
					 hexc <= 1'b1;
					 hexcc <= 1'b1;
            end
			
			// clean third explosion (shock wave)
			else if (bw == 3'b110 && checb3 == 1'b1)
				begin
				writeEn <= 1'b1;
				x <= x_outb3c;
				y <= y_outb3c;
				colour <= colour_outb3c;
				cccb3 <= cccb3 - 1'b1;
				E <= 1'b1;
				hexc <= 1'b1;
				hexcc <= 1'b1;
				cccw <= 20'd767990;
 				end
			
			// end screen (you win, restart instruction)
			else if ((s == 6'b111111 && bw == 3'b111) || SW[5:5])
				begin
					 //chec <= 1;
					 cccw <= cccw - 1'b1;
                writeEn <= 1'b1;
                x <= x_outw;    
                y <= y_outw;
                colour <= colour_outw;
					 E <= 1'b0;
					 hexc <= 1'b1;
					 //resetn <= 1'b0;
					 hexcc <= 1'b1;
					 pppp <= 1'b1;
					 
            end
			
			// launch missile
			else if (plotAir_m && (s == 6'b111011 || s == 6'b111100 || s == 6'b111101))
				begin
					 mmmm <= 1'b1;
				    writeEn <= 1'b1;
                x <= x_coor_m;              
                y <= y_coor_m;
                colour <= color_m;
					 E <= 1'b1;
					 hexc <= 1'b1;
					 hexcc <= 1'b1;
				end
			
			// start counting
			else if (bw == 3'b000 && s > 6'b111101)
			begin
				hexcc <= 1'b1;
				hexc <= 1'b1;
				E <= 1'b1;
			end
			
			// default: do not plot
			else
				begin
					writeEn <= 1'b0;
				end
    end
       
endmodule

// packed module for player aircraft
module aircraft(clock, resetn, pause, init_x, init_y, colour_in, speed_in, move_left, move_right, move_up, move_down, cur_coor_x, cur_coor_y, draw_coor_x, draw_coor_y, colour_air_out, plotAir_out);
	 input clock, resetn, pause;
	 input [2:0] colour_in;
	 input [1:0] speed_in;
	 input [8:0] init_x;
	 input [7:0] init_y;
	 input move_left, move_right, move_up, move_down;
	 output [8:0] draw_coor_x;
	 output [7:0] draw_coor_y;
	 output [8:0] cur_coor_x;
	 output [7:0] cur_coor_y;
	 output [2:0] colour_air_out;
	 output plotAir_out;
    wire ld_x_car0, ld_y_car0;
    wire [3:0] stateNum_car0;
    reg  [8:0] car0_coord = 7'b0101111;
    wire [2:0] colour_car0;
    wire [8:0] x_car0;
    wire [7:0] y_car0;
    wire writeEn_car0;
	 wire finished_drawing;
	 wire draw_enable_0;
    reg [25:0] counter_for_car0 = 26'b0000000000000000000000001;
    reg [7:0] init_y_c0 = 7'b0101010;   
    // Instansiate datapath                              
    datapath d_d(
			.clk(clock),
			.ld_x(ld_x_car0),
			.ld_y(ld_y_car0),
			.in_x(init_x),
			.in_y(init_y),
			.reset_n(resetn),
			.x_coor(x_car0),
			.y_coor(y_car0),
			.colour(colour_car0),
			.write(writeEn_car0),
			.stateNum(stateNum_car0),
			.acolour(colour_in));
   
    // Instansiate FSM control
    control c_c(.clk(clock),
						  .move_r(move_right),
						  .move_l(move_left),
						  .move_d(move_down),
						  .move_u(move_up),
						  .reset_n(resetn),
						  .ld_x(ld_x_car0),
						  .ld_y(ld_y_car0),
						  .stateNum(stateNum_car0),
						  .pause(pause),
						  .dingding(counter_for_car0),
						  .how_fast(speed_in),
						  .draw_finished(finished_drawing),
						  .draw_enable(draw_enable_0));
	 // draw aircraft
	 wire enable;
	 wire [8:0] x_coor;
	 wire [7:0] y_coor;
	 Counter320 c6(.clock(clock), .Clear_b(1'b1), .Enable(draw_enable_0), .q(x_coor));
	 assign enable = (x_coor == 9'd320) ? 1 : 0;
	 Counter240 c4(.clock(clock), .Clear_b(1'b1), .Enable(enable), .q(y_coor));
	 assign finished_drawing = (y_coor == 18'd240) ? 1 : 0;
    wire [9:0] score;
    wire reset_game;
	 wire plotAir;
	 PlotAircraft a1(.clk(clock),
					.characterPositionX(x_car0),
					.characterPositionY(y_car0),
					.drawingPositionX(x_coor),
					.drawingPositionY(y_coor),
					.plot(plotAir)
					);
	 assign draw_coor_x = x_coor;
	 assign draw_coor_y = y_coor;
	 assign cur_coor_x = x_car0;
	 assign cur_coor_y = y_car0;
	 assign colour_air_out = colour_car0;
	 assign plotAir_out = plotAir;
endmodule

// packed module for small aircraft
module smallAircraft(clock, resetn, pause, init_x, init_y, colour_in, speed_in, move_left, move_right, move_up, move_down, x_coor_out, y_coor_out, colour_air_out, plotAir_out);
	 input clock, resetn, pause;
	 input [2:0] colour_in;
	 input [1:0] speed_in;
	 input [8:0] init_x;
	 input [7:0] init_y;
	 input move_left, move_right, move_up, move_down;
	 output [8:0] x_coor_out;
	 output [7:0] y_coor_out;
	 output [2:0] colour_air_out;
	 output plotAir_out;
    wire ld_x_car0, ld_y_car0;
    wire [3:0] stateNum_car0;
    reg  [8:0] car0_coord = 7'b0101111;
    wire [2:0] colour_car0;
    wire [8:0] x_car0;
    wire [7:0] y_car0;
    wire writeEn_car0;
	 wire finished_drawing;
	 wire draw_enable_0;
    reg [25:0] counter_for_car0 = 26'b00000000000000000000000001;
    reg [7:0] init_y_c0 = 7'b0101010;
    // Instansiate datapath                                
    datapath d_d(
			.clk(clock),
			.ld_x(ld_x_car0),
			.ld_y(ld_y_car0),
			.in_x(init_x),
			.in_y(init_y),
			.reset_n(resetn),
			.x_coor(x_car0),
			.y_coor(y_car0),
			.colour(colour_car0),
			.write(writeEn_car0),
			.stateNum(stateNum_car0),
			.acolour(colour_in));
   
    // Instansiate FSM control
    control c_c(.clk(clock),
						  .move_r(move_right),
						  .move_l(move_left),
						  .move_d(move_down),
						  .move_u(move_up),
						  .reset_n(resetn),
						  .ld_x(ld_x_car0),
						  .ld_y(ld_y_car0),
						  .stateNum(stateNum_car0),
						  .pause(pause),
						  .dingding(counter_for_car0),
						  .how_fast(speed2),
						  .draw_finished(finished_drawing),
						  .draw_enable(draw_enable_0));
	 // draw aircraft
	 wire enable;
	 wire [8:0] x_coor;
	 wire [7:0] y_coor;
	 Counter320 c6(.clock(clock), .Clear_b(1'b1), .Enable(draw_enable_0), .q(x_coor));
	 assign enable = (x_coor == 9'd320) ? 1 : 0;
	 Counter240 c4(.clock(clock), .Clear_b(1'b1), .Enable(enable), .q(y_coor));
	 assign finished_drawing = (y_coor == 18'd240) ? 1 : 0;
    wire [9:0] score;
    wire reset_game;
	 wire plotAir;
	 PlotSmall a1(.clk(clock),
					.characterPositionX(x_car0),
					.characterPositionY(y_car0),
					.drawingPositionX(x_coor),
					.drawingPositionY(y_coor),
					.plot(plotAir)
					);
	 assign x_coor_out = x_coor;
	 assign y_coor_out = y_coor;
	 assign colour_air_out = colour_car0;
	 assign plotAir_out = plotAir;
endmodule

// packed module for enemy aircraft
module enemyAircraft(clock, resetn, pause, init_x, init_y, colour_in, speed_in, move_left, move_right, move_up, move_down, x_coor_out, y_coor_out, colour_air_out, plotAir_out);
	 input clock, resetn, pause;
	 input [2:0] colour_in;
	 input [1:0] speed_in;
	 input [8:0] init_x;
	 input [7:0] init_y;
	 input move_left, move_right, move_up, move_down;
	 output [8:0] x_coor_out;
	 output [7:0] y_coor_out;
	 output [2:0] colour_air_out;
	 output plotAir_out;
    wire ld_x_car0, ld_y_car0;
    wire [3:0] stateNum_car0;
    reg  [8:0] car0_coord = 7'b0101111;
    wire [2:0] colour_car0;
    wire [8:0] x_car0;
    wire [7:0] y_car0;
    wire writeEn_car0;
	 wire finished_drawing;
	 wire draw_enable_0;
    reg [25:0] counter_for_car0 = 26'b00000000000000000000001000;
    reg [7:0] init_y_c0 = 7'b0101010;
    // Instansiate datapath                                
    datapath d_d(
			.clk(clock),
			.ld_x(ld_x_car0),
			.ld_y(ld_y_car0),
			.in_x(init_x),
			.in_y(init_y),
			.reset_n(resetn),
			.x_coor(x_car0),
			.y_coor(y_car0),
			.colour(colour_car0),
			.write(writeEn_car0),
			.stateNum(stateNum_car0),
			.acolour(colour_in));
   
    // Instansiate FSM control
    control c_c(.clk(clock),
						  .move_r(move_right),
						  .move_l(move_left),
						  .move_d(move_down),
						  .move_u(move_up),
						  .reset_n(resetn),
						  .ld_x(ld_x_car0),
						  .ld_y(ld_y_car0),
						  .stateNum(stateNum_car0),
						  .pause(pause),
						  .dingding(counter_for_car0),
						  .how_fast(speed2),
						  .draw_finished(finished_drawing),
						  .draw_enable(draw_enable_0));
	 // draw aircraft
	 wire enable;
	 wire [8:0] x_coor;
	 wire [7:0] y_coor;
	 Counter320 c6(.clock(clock), .Clear_b(1'b1), .Enable(draw_enable_0), .q(x_coor));
	 assign enable = (x_coor == 9'd320) ? 1 : 0;
	 Counter240 c4(.clock(clock), .Clear_b(1'b1), .Enable(enable), .q(y_coor));
	 assign finished_drawing = (y_coor == 18'd240) ? 1 : 0;
    wire [9:0] score;
    wire reset_game;
	 wire plotAir;
	 PlotEnemyAircraft a1(.clk(clock),
					.characterPositionX(x_car0),
					.characterPositionY(y_car0),
					.drawingPositionX(x_coor),
					.drawingPositionY(y_coor),
					.plot(plotAir)
					);
	 assign x_coor_out = x_coor;
	 assign y_coor_out = y_coor;
	 assign colour_air_out = colour_car0;
	 assign plotAir_out = plotAir;
endmodule


// packed module for boss aircraft
module bossAircraft(clock, resetn, pause, init_x, init_y, colour_in, speed_in, move_left, move_right, move_up, move_down, x_coor_out, y_coor_out, colour_air_out, plotAir_out);
	 input clock, resetn, pause;
	 input [2:0] colour_in;
	 input [1:0] speed_in;
	 input [8:0] init_x;
	 input [7:0] init_y;
	 input move_left, move_right, move_up, move_down;
	 output [8:0] x_coor_out;
	 output [7:0] y_coor_out;
	 output [2:0] colour_air_out;
	 output plotAir_out;
    wire ld_x_car0, ld_y_car0;
    wire [3:0] stateNum_car0;
    reg  [8:0] car0_coord = 7'b0101111;
    wire [2:0] colour_car0;
    wire [8:0] x_car0;
    wire [7:0] y_car0;
    wire writeEn_car0;
	 wire finished_drawing;
	 wire draw_enable_0;
    reg [25:0] counter_for_car0 = 26'b00000000000000000000000001;
    reg [7:0] init_y_c0 = 7'b0101010;
    // Instansiate datapath                                
    datapath d_d(
			.clk(clock),
			.ld_x(ld_x_car0),
			.ld_y(ld_y_car0),
			.in_x(init_x),
			.in_y(init_y),
			.reset_n(resetn),
			.x_coor(x_car0),
			.y_coor(y_car0),
			.colour(colour_car0),
			.write(writeEn_car0),
			.stateNum(stateNum_car0),
			.acolour(colour_in));
   
    // Instansiate FSM control
    control c_c(.clk(clock),
						  .move_r(move_right),
						  .move_l(move_left),
						  .move_d(move_down),
						  .move_u(move_up),
						  .reset_n(resetn),
						  .ld_x(ld_x_car0),
						  .ld_y(ld_y_car0),
						  .stateNum(stateNum_car0),
						  .pause(pause),
						  .dingding(counter_for_car0),
						  .how_fast(speed2),
						  .draw_finished(finished_drawing),
						  .draw_enable(draw_enable_0));
	 // draw aircraft
	 wire enable;
	 wire [8:0] x_coor;
	 wire [7:0] y_coor;
	 Counter320 c6(.clock(clock), .Clear_b(1'b1), .Enable(draw_enable_0), .q(x_coor));
	 assign enable = (x_coor == 9'd320) ? 1 : 0;
	 Counter240 c4(.clock(clock), .Clear_b(1'b1), .Enable(enable), .q(y_coor));
	 assign finished_drawing = (y_coor == 18'd240) ? 1 : 0;
    wire [9:0] score;
    wire reset_game;
	 wire plotAir;
	 PlotBoss a1(.clk(clock),
					.characterPositionX(x_car0),
					.characterPositionY(y_car0),
					.drawingPositionX(x_coor),
					.drawingPositionY(y_coor),
					.plot(plotAir)
					);
	 assign x_coor_out = x_coor;
	 assign y_coor_out = y_coor;
	 assign colour_air_out = colour_car0;
	 assign plotAir_out = plotAir;
endmodule

// control module
module control(clk, move_r, move_l, move_d, move_u, reset_n, ld_x, ld_y, stateNum, pause, dingding, how_fast, draw_finished, draw_enable);
    input [25:0] dingding; //counter
    input pause;
    input clk, move_r, move_l, move_d, move_u, reset_n;
	 input [1:0] how_fast;
	 input draw_finished;
    reg [3:0] curr, next;
    output reg ld_y, ld_x;
    output reg [3:0] stateNum;
	 output reg draw_enable;
    localparam S_CLEAR              = 4'b0001;
    localparam S_LOAD_X             = 4'b0010;
	 localparam cleanUp              = 4'b0101;
	 localparam temp_selecting_state = 4'b0100;
    localparam clear_all            = 4'b0000;
	 localparam print_left           = 4'b0111;
    localparam print_right          = 4'b1011;
    localparam print_up             = 4'b1101;
    localparam print_down           = 4'b1110;
	 localparam drawing              = 4'b1111;
    localparam after_drawing        = 4'b1100;

    wire [26:0] press_now;   
    wire [26:0] press_now_for_car;   
    wire result_press_now;
	 reg [25:0] speed;
    
	 always @(*)
	 begin
		if (how_fast == 2'b00)
		   speed <= 26'b0101111101011110000100;
		else if (how_fast == 2'b01)
		   speed <= 26'b010111110101111000010;
		else
		   speed <= 26'b01011111010111100001;
	 end

	 // counter with speed as cycle input, and press_now as q output
	 RateDividerForCar player_counter1(clk, press_now, reset_n, speed);
	 // result_press_now = 1 if when counter decremented to dingding
    assign result_press_now = (press_now == dingding) ? 1 : 0;

    always @(*)
    begin: state_table
        case (curr)
				// S_CLEAR is the default state that doesnt do anything
            S_CLEAR: next = S_LOAD_X;

            S_LOAD_X: next = temp_selecting_state;

				// if reset then cleanup
				// else 
				// 	if any movement, wait for counter decrements to dingding then clear_all
				//    else S_LOAD_Y
            temp_selecting_state: next = pause ? temp_selecting_state : (((move_r || move_l || move_d || move_u) && result_press_now) ? clear_all : temp_selecting_state);

				// clear the current pixel before drawing the next pixel
            clear_all:
					 // draw the next pixel
                begin
                    if(move_r)
                        //next = draw_finished ? print_right : clear_all;
								next = draw_finished ? print_right : clear_all;
                    else if (move_l)    // if player isnt moving, then let the car move
                        //next = draw_finished ? print_left : clear_all;
								next = draw_finished ? print_left : clear_all;
                    else if (move_d)   // if player isnt moving, then let the car move
                        //next = draw_finished ? print_down : clear_all;
								next = draw_finished ? print_down : clear_all;
                    else if (move_u)   // if player isnt moving, then let the car move
                        //next = draw_finished ? print_up : clear_all;
								next = draw_finished ? print_up : clear_all;
                end

            //print_left: next = reset_game ? S_LOAD_Y : (draw_finished ? after_drawing : print_left);
				print_left: next = drawing;
            //print_right: next = reset_game ? S_LOAD_Y : (draw_finished ? after_drawing : print_right);

				print_right: next = drawing;
				//print_right: next = reset_game ? S_LOAD_Y : after_drawing;

            //print_up: next = reset_game ? S_LOAD_Y : (draw_finished ? after_drawing : print_up);
				print_up: next = drawing;

            //print_down: next = reset_game ? S_LOAD_Y : (draw_finished ? after_drawing : print_down);
				print_down: next = drawing;

            //after_drawing: next= temp_selecting_state;
				drawing: next = draw_finished ? after_drawing : drawing;

				after_drawing: next= temp_selecting_state;

				default: next = S_CLEAR;

        endcase
    end

    always@(*)
    begin: enable_signals
        ld_x = 1'b0;
        stateNum = 4'b0000;
		  draw_enable = 1'b0;
        case (curr)
            S_LOAD_X: begin
                ld_x = 1'b1;
                end

            cleanUp: begin
                stateNum = 4'b0101;
                //write = 1'b1;
                end
            clear_all: begin
                stateNum = 4'b0101;
					 draw_enable = 1'b1;
                //write = 1'b1;
                end

            print_left: begin
                stateNum = 4'b0111;
                //write = 1'b1;
                end

            print_right: begin
                stateNum = 4'b1011;
                //write = 1'b1;
                end

            print_up: begin
                stateNum = 4'b1101;
                //write = 1'b1;
                end

            print_down: begin
                stateNum = 4'b1110;
                //write = 1'b1;
                end

				drawing: begin
                stateNum = 4'b1111;
					 draw_enable = 1'b1;
                end

        endcase
    end

    always @(posedge clk)
    begin: states
        if(!reset_n)
            curr <= S_LOAD_X;
        else
            curr <= next;
    end

endmodule

// datapath module
module datapath(clk, ld_x, ld_y, in_x, in_y, reset_n, x_coor, y_coor, colour, stateNum, write, acolour, draw_finished);
    input clk;
    input [8:0] in_x;
    input [7:0] in_y;
    input [2:0] acolour;
    input ld_x, ld_y;
    input reset_n;
    output reg [2:0] colour;
    output reg write;
	 reg [8:0] x;
	 reg [7:0] y;
    output reg [8:0] x_coor;
    output reg [7:0] y_coor;
	 output draw_finished;
    input [3:0] stateNum;

    always @(posedge clk)
    begin
			write <= 1'b0;
			if(!reset_n)
				begin
            x <= 9'd0;
            y <= 8'd0;
            colour <= 3'd0;
				end
			else
				begin
            if(ld_x)
                begin
                    x <= in_x;
                    y <= in_y;
                end
            // The following is for cleanUp and clear_all
            else if(stateNum == 4'b0101)
                begin
                    colour <= 3'b000;
                    write <= 1'b1;
						  x_coor <= x;
						  y_coor <= y;
                end
            // The following is for moving left
            else if(stateNum == 4'b0111)   
                begin
						if (x == 9'd3)
							x <= 9'd317;
						else
							x <= x - 1'b1;
                  colour <= acolour;
                end
            // The following is for print_right
            else if(stateNum == 4'b1011)   
                begin
						if (x == 9'd317)
							x <= 9'd0;
						else
							x <= x + 1'b1;
                  colour <= acolour;
                end
            else if(stateNum == 4'b1101)//for moving up
                begin
						if (y == 9'd3)
							y <= 9'd237;
						else
							y <= y - 1'b1;
                  colour <= acolour;
                end
            // The following is for moving down
            else if(stateNum == 4'b1110)
					 begin
						if (y == 9'd237)
							y <= 9'd3;
						else
							y <= y + 1'b1;
                  colour <= acolour;
                end
				// drawing state
            else if(stateNum == 4'b1111)   
                begin
                    write <= 1'b1;
						  x_coor <= x;
						  y_coor <= y;
                end
        end
    end
   
endmodule

module Counter4Bit(clock, Clear_b, Enable, q);
	input clock, Clear_b, Enable;
	output reg [8:0] q;
	
	always @(posedge clock)
	begin
		if (Clear_b == 1'b0)
			q <= 0;
		else if (q == 4'b111)
			q <= 0;
		else if (Enable == 1'b1)
			q <= q + 1'b1;
	end

endmodule

module RateDividerForCar (clock, q, Clear_b, how_speedy);  // aircrafts are not actually cars but they are both vehicles 
    input [0:0] clock;
    input [0:0] Clear_b;
	 input [25:0] how_speedy;
    output reg [26:0] q;
    always@(posedge clock)
    begin
        if (q == how_speedy)
            q <= 0;
        else if (clock == 1'b1) 
            q <= q + 1'b1; 
    end
endmodule


// counter for x
module Counter320(clock, Clear_b, Enable, q);
	input clock, Clear_b, Enable;
	output reg [9:0] q;
	
	always @(posedge clock)
	begin
		if (Clear_b == 1'b0)
			q <= 0;
		else if (q == 10'd320)
			q <= 0;
		else if (Enable == 1'b1)
			q <= q +1'b1;
	end

endmodule

// counter for y
module Counter240(clock, Clear_b, Enable, q);
	input clock, Clear_b, Enable;
	output reg [9:0] q;
	
	always @(posedge clock)
	begin
		if (Clear_b == 1'b0)
			q <= 0;
		else if (q == 10'd240)
			q <= 0;
		else if (Enable == 1'b1)
			q <= q +1'b1;
	end

endmodule

// packed module for missile
module missile(clock, resetn, pause, init_x, init_y, colour_in, speed_in, move_left, move_right, move_up, move_down, x_coor_out, y_coor_out, colour_air_out, plotAir_out);
	 input clock, resetn, pause;
	 input [2:0] colour_in;
	 input [1:0] speed_in;
	 input [8:0] init_x;
	 input [7:0] init_y;
	 input move_left, move_right, move_up, move_down;
	 output [8:0] x_coor_out;
	 output [7:0] y_coor_out;
	 output [2:0] colour_air_out;
	 output plotAir_out;
    wire ld_x_car0, ld_y_car0;
    wire [3:0] stateNum_car0;
    reg  [8:0] car0_coord = 7'b0101111;
    wire [2:0] colour_car0;
    wire [8:0] x_car0;
    wire [7:0] y_car0;
    wire writeEn_car0;
	 wire finished_drawing;
	 wire draw_enable_0;
    reg [25:0] counter_for_car0 = 26'b00000000000000000000000001;
    reg [7:0] init_y_c0 = 7'b0101010;
    // Instansiate datapath                                
    datapath d_d(
			.clk(clock),
			.ld_x(ld_x_car0),
			.ld_y(ld_y_car0),
			.in_x(init_x),
			.in_y(init_y),
			.reset_n(resetn),
			.x_coor(x_car0),
			.y_coor(y_car0),
			.colour(colour_car0),
			.write(writeEn_car0),
			.stateNum(stateNum_car0),
			.acolour(colour_in));
   
    // Instansiate FSM control
    control c_c(.clk(clock),
						  .move_r(move_right),
						  .move_l(move_left),
						  .move_d(move_down),
						  .move_u(move_up),
						  .reset_n(resetn),
						  .ld_x(ld_x_car0),
						  .ld_y(ld_y_car0),
						  .stateNum(stateNum_car0),
						  .pause(pause),
						  .dingding(counter_for_car0),
						  .how_fast(speed2),
						  .draw_finished(finished_drawing),
						  .draw_enable(draw_enable_0));
	 // draw missile
	 wire enable;
	 wire [8:0] x_coor;
	 wire [7:0] y_coor;
	 Counter320 c6(.clock(clock), .Clear_b(1'b1), .Enable(draw_enable_0), .q(x_coor));
	 assign enable = (x_coor == 9'd320) ? 1 : 0;
	 Counter240 c4(.clock(clock), .Clear_b(1'b1), .Enable(enable), .q(y_coor));
	 assign finished_drawing = (y_coor == 18'd240) ? 1 : 0;
    wire [9:0] score;
    wire reset_game;
	 wire plotAir;
	 PlotMissile a1(.clk(clock),
					.characterPositionX(x_car0),
					.characterPositionY(y_car0),
					.drawingPositionX(x_coor),
					.drawingPositionY(y_coor),
					.plot(plotAir)
					);
	 assign x_coor_out = x_coor;
	 assign y_coor_out = y_coor;
	 assign colour_air_out = colour_car0;
	 assign plotAir_out = plotAir;
endmodule

// module for plotting enemy aircraft
module PlotEnemyAircraft(
	input clk,
	input wire [9:0] characterPositionX,
	input wire [8:0] characterPositionY,
	input wire [9:0] drawingPositionX,
	input wire [8:0] drawingPositionY,
	output reg [2:0] plot
);
	reg [9:0] x;
	reg [9:0] y;
	initial begin
		x = 'd0;
		y = 'd0;
	end

	always @(posedge clk) begin
		x <= (drawingPositionX - characterPositionX + 16);
		y <= (drawingPositionY - characterPositionY + 20);
		if(x==14 && y==2) begin	plot <= 1'b1;	end
		else if(x==15 && y==2) begin	plot <= 1'b1;	end
		else if(x==14 && y==3) begin	plot <= 1'b1;	end
		else if(x==15 && y==3) begin	plot <= 1'b1;	end
		else if(x==14 && y==4) begin	plot <= 1'b1;	end
		else if(x==15 && y==4) begin	plot <= 1'b1;	end
		else if(x==11 && y==5) begin	plot <= 1'b1;	end
		else if(x==14 && y==5) begin	plot <= 1'b1;	end
		else if(x==15 && y==5) begin	plot <= 1'b1;	end
		else if(x==17 && y==5) begin	plot <= 1'b1;	end
		else if(x==18 && y==5) begin	plot <= 1'b1;	end
		else if(x==13 && y==7) begin	plot <= 1'b1;	end
		else if(x==14 && y==7) begin	plot <= 1'b1;	end
		else if(x==15 && y==7) begin	plot <= 1'b1;	end
		else if(x==16 && y==7) begin	plot <= 1'b1;	end
		else if(x==13 && y==8) begin	plot <= 1'b1;	end
		else if(x==14 && y==8) begin	plot <= 1'b1;	end
		else if(x==15 && y==8) begin	plot <= 1'b1;	end
		else if(x==16 && y==8) begin	plot <= 1'b1;	end
		else if(x==13 && y==9) begin	plot <= 1'b1;	end
		else if(x==14 && y==9) begin	plot <= 1'b1;	end
		else if(x==15 && y==9) begin	plot <= 1'b1;	end
		else if(x==16 && y==9) begin	plot <= 1'b1;	end
		else if(x==13 && y==10) begin	plot <= 1'b1;	end
		else if(x==14 && y==10) begin	plot <= 1'b1;	end
		else if(x==15 && y==10) begin	plot <= 1'b1;	end
		else if(x==16 && y==10) begin	plot <= 1'b1;	end
		else if(x==14 && y==11) begin	plot <= 1'b1;	end
		else if(x==15 && y==11) begin	plot <= 1'b1;	end
		else if(x==16 && y==11) begin	plot <= 1'b1;	end
		else if(x==10 && y==12) begin	plot <= 1'b1;	end
		else if(x==11 && y==12) begin	plot <= 1'b1;	end
		else if(x==13 && y==12) begin	plot <= 1'b1;	end
		else if(x==14 && y==12) begin	plot <= 1'b1;	end
		else if(x==15 && y==12) begin	plot <= 1'b1;	end
		else if(x==16 && y==12) begin	plot <= 1'b1;	end
		else if(x==18 && y==12) begin	plot <= 1'b1;	end
		else if(x==19 && y==12) begin	plot <= 1'b1;	end
		else if(x==8 && y==13) begin	plot <= 1'b1;	end
		else if(x==10 && y==13) begin	plot <= 1'b1;	end
		else if(x==11 && y==13) begin	plot <= 1'b1;	end
		else if(x==13 && y==13) begin	plot <= 1'b1;	end
		else if(x==14 && y==13) begin	plot <= 1'b1;	end
		else if(x==15 && y==13) begin	plot <= 1'b1;	end
		else if(x==16 && y==13) begin	plot <= 1'b1;	end
		else if(x==18 && y==13) begin	plot <= 1'b1;	end
		else if(x==19 && y==13) begin	plot <= 1'b1;	end
		else if(x==21 && y==13) begin	plot <= 1'b1;	end
		else if(x==8 && y==14) begin	plot <= 1'b1;	end
		else if(x==10 && y==14) begin	plot <= 1'b1;	end
		else if(x==11 && y==14) begin	plot <= 1'b1;	end
		else if(x==13 && y==14) begin	plot <= 1'b1;	end
		else if(x==14 && y==14) begin	plot <= 1'b1;	end
		else if(x==15 && y==14) begin	plot <= 1'b1;	end
		else if(x==16 && y==14) begin	plot <= 1'b1;	end
		else if(x==18 && y==14) begin	plot <= 1'b1;	end
		else if(x==19 && y==14) begin	plot <= 1'b1;	end
		else if(x==21 && y==14) begin	plot <= 1'b1;	end
		else if(x==1 && y==15) begin	plot <= 1'b1;	end
		else if(x==2 && y==15) begin	plot <= 1'b1;	end
		else if(x==8 && y==15) begin	plot <= 1'b1;	end
		else if(x==10 && y==15) begin	plot <= 1'b1;	end
		else if(x==11 && y==15) begin	plot <= 1'b1;	end
		else if(x==14 && y==15) begin	plot <= 1'b1;	end
		else if(x==15 && y==15) begin	plot <= 1'b1;	end
		else if(x==16 && y==15) begin	plot <= 1'b1;	end
		else if(x==17 && y==15) begin	plot <= 1'b1;	end
		else if(x==18 && y==15) begin	plot <= 1'b1;	end
		else if(x==19 && y==15) begin	plot <= 1'b1;	end
		else if(x==21 && y==15) begin	plot <= 1'b1;	end
		else if(x==25 && y==15) begin	plot <= 1'b1;	end
		else if(x==27 && y==15) begin	plot <= 1'b1;	end
		else if(x==28 && y==15) begin	plot <= 1'b1;	end
		else if(x==1 && y==16) begin	plot <= 1'b1;	end
		else if(x==2 && y==16) begin	plot <= 1'b1;	end
		else if(x==4 && y==16) begin	plot <= 1'b1;	end
		else if(x==5 && y==16) begin	plot <= 1'b1;	end
		else if(x==8 && y==16) begin	plot <= 1'b1;	end
		else if(x==9 && y==16) begin	plot <= 1'b1;	end
		else if(x==10 && y==16) begin	plot <= 1'b1;	end
		else if(x==11 && y==16) begin	plot <= 1'b1;	end
		else if(x==12 && y==16) begin	plot <= 1'b1;	end
		else if(x==17 && y==16) begin	plot <= 1'b1;	end
		else if(x==18 && y==16) begin	plot <= 1'b1;	end
		else if(x==19 && y==16) begin	plot <= 1'b1;	end
		else if(x==21 && y==16) begin	plot <= 1'b1;	end
		else if(x==24 && y==16) begin	plot <= 1'b1;	end
		else if(x==25 && y==16) begin	plot <= 1'b1;	end
		else if(x==27 && y==16) begin	plot <= 1'b1;	end
		else if(x==28 && y==16) begin	plot <= 1'b1;	end
		else if(x==1 && y==17) begin	plot <= 1'b1;	end
		else if(x==2 && y==17) begin	plot <= 1'b1;	end
		else if(x==4 && y==17) begin	plot <= 1'b1;	end
		else if(x==5 && y==17) begin	plot <= 1'b1;	end
		else if(x==6 && y==17) begin	plot <= 1'b1;	end
		else if(x==8 && y==17) begin	plot <= 1'b1;	end
		else if(x==10 && y==17) begin	plot <= 1'b1;	end
		else if(x==11 && y==17) begin	plot <= 1'b1;	end
		else if(x==12 && y==17) begin	plot <= 1'b1;	end
		else if(x==13 && y==17) begin	plot <= 1'b1;	end
		else if(x==14 && y==17) begin	plot <= 1'b1;	end
		else if(x==15 && y==17) begin	plot <= 1'b1;	end
		else if(x==16 && y==17) begin	plot <= 1'b1;	end
		else if(x==17 && y==17) begin	plot <= 1'b1;	end
		else if(x==18 && y==17) begin	plot <= 1'b1;	end
		else if(x==19 && y==17) begin	plot <= 1'b1;	end
		else if(x==21 && y==17) begin	plot <= 1'b1;	end
		else if(x==23 && y==17) begin	plot <= 1'b1;	end
		else if(x==24 && y==17) begin	plot <= 1'b1;	end
		else if(x==25 && y==17) begin	plot <= 1'b1;	end
		else if(x==27 && y==17) begin	plot <= 1'b1;	end
		else if(x==28 && y==17) begin	plot <= 1'b1;	end
		else if(x==2 && y==18) begin	plot <= 1'b1;	end
		else if(x==4 && y==18) begin	plot <= 1'b1;	end
		else if(x==5 && y==18) begin	plot <= 1'b1;	end
		else if(x==6 && y==18) begin	plot <= 1'b1;	end
		else if(x==7 && y==18) begin	plot <= 1'b1;	end
		else if(x==10 && y==18) begin	plot <= 1'b1;	end
		else if(x==11 && y==18) begin	plot <= 1'b1;	end
		else if(x==12 && y==18) begin	plot <= 1'b1;	end
		else if(x==13 && y==18) begin	plot <= 1'b1;	end
		else if(x==14 && y==18) begin	plot <= 1'b1;	end
		else if(x==15 && y==18) begin	plot <= 1'b1;	end
		else if(x==16 && y==18) begin	plot <= 1'b1;	end
		else if(x==17 && y==18) begin	plot <= 1'b1;	end
		else if(x==18 && y==18) begin	plot <= 1'b1;	end
		else if(x==19 && y==18) begin	plot <= 1'b1;	end
		else if(x==22 && y==18) begin	plot <= 1'b1;	end
		else if(x==23 && y==18) begin	plot <= 1'b1;	end
		else if(x==24 && y==18) begin	plot <= 1'b1;	end
		else if(x==25 && y==18) begin	plot <= 1'b1;	end
		else if(x==27 && y==18) begin	plot <= 1'b1;	end
		else if(x==28 && y==18) begin	plot <= 1'b1;	end
		else if(x==1 && y==19) begin	plot <= 1'b1;	end
		else if(x==2 && y==19) begin	plot <= 1'b1;	end
		else if(x==4 && y==19) begin	plot <= 1'b1;	end
		else if(x==5 && y==19) begin	plot <= 1'b1;	end
		else if(x==6 && y==19) begin	plot <= 1'b1;	end
		else if(x==7 && y==19) begin	plot <= 1'b1;	end
		else if(x==10 && y==19) begin	plot <= 1'b1;	end
		else if(x==11 && y==19) begin	plot <= 1'b1;	end
		else if(x==12 && y==19) begin	plot <= 1'b1;	end
		else if(x==13 && y==19) begin	plot <= 1'b1;	end
		else if(x==14 && y==19) begin	plot <= 1'b1;	end
		else if(x==15 && y==19) begin	plot <= 1'b1;	end
		else if(x==16 && y==19) begin	plot <= 1'b1;	end
		else if(x==17 && y==19) begin	plot <= 1'b1;	end
		else if(x==18 && y==19) begin	plot <= 1'b1;	end
		else if(x==19 && y==19) begin	plot <= 1'b1;	end
		else if(x==21 && y==19) begin	plot <= 1'b1;	end
		else if(x==22 && y==19) begin	plot <= 1'b1;	end
		else if(x==23 && y==19) begin	plot <= 1'b1;	end
		else if(x==24 && y==19) begin	plot <= 1'b1;	end
		else if(x==25 && y==19) begin	plot <= 1'b1;	end
		else if(x==27 && y==19) begin	plot <= 1'b1;	end
		else if(x==28 && y==19) begin	plot <= 1'b1;	end
		else if(x==2 && y==20) begin	plot <= 1'b1;	end
		else if(x==4 && y==20) begin	plot <= 1'b1;	end
		else if(x==6 && y==20) begin	plot <= 1'b1;	end
		else if(x==7 && y==20) begin	plot <= 1'b1;	end
		else if(x==8 && y==20) begin	plot <= 1'b1;	end
		else if(x==10 && y==20) begin	plot <= 1'b1;	end
		else if(x==11 && y==20) begin	plot <= 1'b1;	end
		else if(x==12 && y==20) begin	plot <= 1'b1;	end
		else if(x==13 && y==20) begin	plot <= 1'b1;	end
		else if(x==14 && y==20) begin	plot <= 1'b1;	end
		else if(x==15 && y==20) begin	plot <= 1'b1;	end
		else if(x==16 && y==20) begin	plot <= 1'b1;	end
		else if(x==17 && y==20) begin	plot <= 1'b1;	end
		else if(x==18 && y==20) begin	plot <= 1'b1;	end
		else if(x==19 && y==20) begin	plot <= 1'b1;	end
		else if(x==21 && y==20) begin	plot <= 1'b1;	end
		else if(x==22 && y==20) begin	plot <= 1'b1;	end
		else if(x==23 && y==20) begin	plot <= 1'b1;	end
		else if(x==25 && y==20) begin	plot <= 1'b1;	end
		else if(x==27 && y==20) begin	plot <= 1'b1;	end
		else if(x==28 && y==20) begin	plot <= 1'b1;	end
		else if(x==1 && y==21) begin	plot <= 1'b1;	end
		else if(x==2 && y==21) begin	plot <= 1'b1;	end
		else if(x==4 && y==21) begin	plot <= 1'b1;	end
		else if(x==7 && y==21) begin	plot <= 1'b1;	end
		else if(x==8 && y==21) begin	plot <= 1'b1;	end
		else if(x==10 && y==21) begin	plot <= 1'b1;	end
		else if(x==11 && y==21) begin	plot <= 1'b1;	end
		else if(x==12 && y==21) begin	plot <= 1'b1;	end
		else if(x==13 && y==21) begin	plot <= 1'b1;	end
		else if(x==14 && y==21) begin	plot <= 1'b1;	end
		else if(x==15 && y==21) begin	plot <= 1'b1;	end
		else if(x==16 && y==21) begin	plot <= 1'b1;	end
		else if(x==17 && y==21) begin	plot <= 1'b1;	end
		else if(x==18 && y==21) begin	plot <= 1'b1;	end
		else if(x==19 && y==21) begin	plot <= 1'b1;	end
		else if(x==21 && y==21) begin	plot <= 1'b1;	end
		else if(x==22 && y==21) begin	plot <= 1'b1;	end
		else if(x==25 && y==21) begin	plot <= 1'b1;	end
		else if(x==27 && y==21) begin	plot <= 1'b1;	end
		else if(x==28 && y==21) begin	plot <= 1'b1;	end
		else if(x==1 && y==22) begin	plot <= 1'b1;	end
		else if(x==2 && y==22) begin	plot <= 1'b1;	end
		else if(x==10 && y==22) begin	plot <= 1'b1;	end
		else if(x==11 && y==22) begin	plot <= 1'b1;	end
		else if(x==12 && y==22) begin	plot <= 1'b1;	end
		else if(x==17 && y==22) begin	plot <= 1'b1;	end
		else if(x==18 && y==22) begin	plot <= 1'b1;	end
		else if(x==19 && y==22) begin	plot <= 1'b1;	end
		else if(x==27 && y==22) begin	plot <= 1'b1;	end
		else if(x==28 && y==22) begin	plot <= 1'b1;	end
		else if(x==1 && y==23) begin	plot <= 1'b1;	end
		else if(x==2 && y==23) begin	plot <= 1'b1;	end
		else if(x==7 && y==23) begin	plot <= 1'b1;	end
		else if(x==10 && y==23) begin	plot <= 1'b1;	end
		else if(x==11 && y==23) begin	plot <= 1'b1;	end
		else if(x==12 && y==23) begin	plot <= 1'b1;	end
		else if(x==13 && y==23) begin	plot <= 1'b1;	end
		else if(x==14 && y==23) begin	plot <= 1'b1;	end
		else if(x==15 && y==23) begin	plot <= 1'b1;	end
		else if(x==16 && y==23) begin	plot <= 1'b1;	end
		else if(x==17 && y==23) begin	plot <= 1'b1;	end
		else if(x==18 && y==23) begin	plot <= 1'b1;	end
		else if(x==19 && y==23) begin	plot <= 1'b1;	end
		else if(x==22 && y==23) begin	plot <= 1'b1;	end
		else if(x==27 && y==23) begin	plot <= 1'b1;	end
		else if(x==28 && y==23) begin	plot <= 1'b1;	end
		else if(x==2 && y==24) begin	plot <= 1'b1;	end
		else if(x==7 && y==24) begin	plot <= 1'b1;	end
		else if(x==8 && y==24) begin	plot <= 1'b1;	end
		else if(x==10 && y==24) begin	plot <= 1'b1;	end
		else if(x==11 && y==24) begin	plot <= 1'b1;	end
		else if(x==12 && y==24) begin	plot <= 1'b1;	end
		else if(x==13 && y==24) begin	plot <= 1'b1;	end
		else if(x==14 && y==24) begin	plot <= 1'b1;	end
		else if(x==15 && y==24) begin	plot <= 1'b1;	end
		else if(x==16 && y==24) begin	plot <= 1'b1;	end
		else if(x==17 && y==24) begin	plot <= 1'b1;	end
		else if(x==18 && y==24) begin	plot <= 1'b1;	end
		else if(x==19 && y==24) begin	plot <= 1'b1;	end
		else if(x==21 && y==24) begin	plot <= 1'b1;	end
		else if(x==22 && y==24) begin	plot <= 1'b1;	end
		else if(x==27 && y==24) begin	plot <= 1'b1;	end
		else if(x==28 && y==24) begin	plot <= 1'b1;	end
		else if(x==7 && y==25) begin	plot <= 1'b1;	end
		else if(x==8 && y==25) begin	plot <= 1'b1;	end
		else if(x==10 && y==25) begin	plot <= 1'b1;	end
		else if(x==11 && y==25) begin	plot <= 1'b1;	end
		else if(x==12 && y==25) begin	plot <= 1'b1;	end
		else if(x==17 && y==25) begin	plot <= 1'b1;	end
		else if(x==18 && y==25) begin	plot <= 1'b1;	end
		else if(x==19 && y==25) begin	plot <= 1'b1;	end
		else if(x==21 && y==25) begin	plot <= 1'b1;	end
		else if(x==22 && y==25) begin	plot <= 1'b1;	end
		else if(x==8 && y==26) begin	plot <= 1'b1;	end
		else if(x==10 && y==26) begin	plot <= 1'b1;	end
		else if(x==11 && y==26) begin	plot <= 1'b1;	end
		else if(x==12 && y==26) begin	plot <= 1'b1;	end
		else if(x==13 && y==26) begin	plot <= 1'b1;	end
		else if(x==14 && y==26) begin	plot <= 1'b1;	end
		else if(x==15 && y==26) begin	plot <= 1'b1;	end
		else if(x==16 && y==26) begin	plot <= 1'b1;	end
		else if(x==17 && y==26) begin	plot <= 1'b1;	end
		else if(x==18 && y==26) begin	plot <= 1'b1;	end
		else if(x==19 && y==26) begin	plot <= 1'b1;	end
		else if(x==21 && y==26) begin	plot <= 1'b1;	end
		else if(x==22 && y==26) begin	plot <= 1'b1;	end
		else if(x==10 && y==27) begin	plot <= 1'b1;	end
		else if(x==11 && y==27) begin	plot <= 1'b1;	end
		else if(x==12 && y==27) begin	plot <= 1'b1;	end
		else if(x==13 && y==27) begin	plot <= 1'b1;	end
		else if(x==14 && y==27) begin	plot <= 1'b1;	end
		else if(x==15 && y==27) begin	plot <= 1'b1;	end
		else if(x==16 && y==27) begin	plot <= 1'b1;	end
		else if(x==17 && y==27) begin	plot <= 1'b1;	end
		else if(x==18 && y==27) begin	plot <= 1'b1;	end
		else if(x==19 && y==27) begin	plot <= 1'b1;	end
		else if(x==21 && y==27) begin	plot <= 1'b1;	end
		else if(x==22 && y==27) begin	plot <= 1'b1;	end
		else if(x==10 && y==28) begin	plot <= 1'b1;	end
		else if(x==11 && y==28) begin	plot <= 1'b1;	end
		else if(x==12 && y==28) begin	plot <= 1'b1;	end
		else if(x==17 && y==28) begin	plot <= 1'b1;	end
		else if(x==18 && y==28) begin	plot <= 1'b1;	end
		else if(x==19 && y==28) begin	plot <= 1'b1;	end
		else if(x==21 && y==28) begin	plot <= 1'b1;	end
		else if(x==10 && y==29) begin	plot <= 1'b1;	end
		else if(x==11 && y==29) begin	plot <= 1'b1;	end
		else if(x==12 && y==29) begin	plot <= 1'b1;	end
		else if(x==17 && y==29) begin	plot <= 1'b1;	end
		else if(x==18 && y==29) begin	plot <= 1'b1;	end
		else if(x==19 && y==29) begin	plot <= 1'b1;	end
		else if(x==10 && y==30) begin	plot <= 1'b1;	end
		else if(x==11 && y==30) begin	plot <= 1'b1;	end
		else if(x==12 && y==30) begin	plot <= 1'b1;	end
		else if(x==13 && y==30) begin	plot <= 1'b1;	end
		else if(x==14 && y==30) begin	plot <= 1'b1;	end
		else if(x==15 && y==30) begin	plot <= 1'b1;	end
		else if(x==16 && y==30) begin	plot <= 1'b1;	end
		else if(x==17 && y==30) begin	plot <= 1'b1;	end
		else if(x==18 && y==30) begin	plot <= 1'b1;	end
		else if(x==19 && y==30) begin	plot <= 1'b1;	end
		else if(x==11 && y==31) begin	plot <= 1'b1;	end
		else if(x==12 && y==31) begin	plot <= 1'b1;	end
		else if(x==17 && y==31) begin	plot <= 1'b1;	end
		else if(x==18 && y==31) begin	plot <= 1'b1;	end
		else if(x==19 && y==31) begin	plot <= 1'b1;	end
		else if(x==11 && y==32) begin	plot <= 1'b1;	end
		else if(x==12 && y==32) begin	plot <= 1'b1;	end
		else if(x==17 && y==32) begin	plot <= 1'b1;	end
		else if(x==18 && y==32) begin	plot <= 1'b1;	end
		else if(x==12 && y==33) begin	plot <= 1'b1;	end
		else if(x==13 && y==33) begin	plot <= 1'b1;	end
		else if(x==14 && y==33) begin	plot <= 1'b1;	end
		else if(x==15 && y==33) begin	plot <= 1'b1;	end
		else if(x==16 && y==33) begin	plot <= 1'b1;	end
		else if(x==17 && y==33) begin	plot <= 1'b1;	end
		else if(x==18 && y==33) begin	plot <= 1'b1;	end
		else if(x==12 && y==34) begin	plot <= 1'b1;	end
		else if(x==13 && y==34) begin	plot <= 1'b1;	end
		else if(x==14 && y==34) begin	plot <= 1'b1;	end
		else if(x==15 && y==34) begin	plot <= 1'b1;	end
		else if(x==16 && y==34) begin	plot <= 1'b1;	end
		else if(x==17 && y==34) begin	plot <= 1'b1;	end
		else if(x==13 && y==35) begin	plot <= 1'b1;	end
		else if(x==14 && y==35) begin	plot <= 1'b1;	end
		else if(x==15 && y==35) begin	plot <= 1'b1;	end
		else if(x==16 && y==35) begin	plot <= 1'b1;	end
		else if(x==17 && y==35) begin	plot <= 1'b1;	end
		else if(x==13 && y==36) begin	plot <= 1'b1;	end
		else if(x==14 && y==36) begin	plot <= 1'b1;	end
		else if(x==15 && y==36) begin	plot <= 1'b1;	end
		else if(x==16 && y==36) begin	plot <= 1'b1;	end
		else if(x==17 && y==36) begin	plot <= 1'b1;	end
		else if(x==14 && y==37) begin	plot <= 1'b1;	end
		else if(x==15 && y==37) begin	plot <= 1'b1;	end
		else if(x==16 && y==37) begin	plot <= 1'b1;	end
		else begin plot <= 1'b0; end// Width: 30, Height: 39
	end
endmodule

module PlotAircraft(
	input clk,
	input wire [9:0] characterPositionX,
	input wire [8:0] characterPositionY,
	input wire [9:0] drawingPositionX,
	input wire [8:0] drawingPositionY,
	output reg [2:0] plot
);
	reg [9:0] x;
	reg [9:0] y;
	initial begin
		x = 'd0;
		y = 'd0;
	end

	always @(posedge clk) begin
		x <= (drawingPositionX - characterPositionX + 11);
		y <= (drawingPositionY - characterPositionY + 13);
		if(x==10 && y==1) begin	plot <= 1'b1;	end
		else if(x==9 && y==2) begin	plot <= 1'b1;	end
		else if(x==10 && y==2) begin	plot <= 1'b1;	end
		else if(x==11 && y==2) begin	plot <= 1'b1;	end
		else if(x==9 && y==3) begin	plot <= 1'b1;	end
		else if(x==10 && y==3) begin	plot <= 1'b1;	end
		else if(x==11 && y==3) begin	plot <= 1'b1;	end
		else if(x==8 && y==4) begin	plot <= 1'b1;	end
		else if(x==10 && y==4) begin	plot <= 1'b1;	end
		else if(x==11 && y==4) begin	plot <= 1'b1;	end
		else if(x==8 && y==5) begin	plot <= 1'b1;	end
		else if(x==11 && y==5) begin	plot <= 1'b1;	end
		else if(x==8 && y==6) begin	plot <= 1'b1;	end
		else if(x==9 && y==6) begin	plot <= 1'b1;	end
		else if(x==11 && y==6) begin	plot <= 1'b1;	end
		else if(x==8 && y==7) begin	plot <= 1'b1;	end
		else if(x==11 && y==7) begin	plot <= 1'b1;	end
		else if(x==8 && y==8) begin	plot <= 1'b1;	end
		else if(x==9 && y==8) begin	plot <= 1'b1;	end
		else if(x==10 && y==8) begin	plot <= 1'b1;	end
		else if(x==11 && y==8) begin	plot <= 1'b1;	end
		else if(x==8 && y==9) begin	plot <= 1'b1;	end
		else if(x==9 && y==9) begin	plot <= 1'b1;	end
		else if(x==11 && y==9) begin	plot <= 1'b1;	end
		else if(x==12 && y==9) begin	plot <= 1'b1;	end
		else if(x==8 && y==10) begin	plot <= 1'b1;	end
		else if(x==10 && y==10) begin	plot <= 1'b1;	end
		else if(x==12 && y==10) begin	plot <= 1'b1;	end
		else if(x==13 && y==10) begin	plot <= 1'b1;	end
		else if(x==6 && y==11) begin	plot <= 1'b1;	end
		else if(x==7 && y==11) begin	plot <= 1'b1;	end
		else if(x==10 && y==11) begin	plot <= 1'b1;	end
		else if(x==13 && y==11) begin	plot <= 1'b1;	end
		else if(x==14 && y==11) begin	plot <= 1'b1;	end
		else if(x==5 && y==12) begin	plot <= 1'b1;	end
		else if(x==6 && y==12) begin	plot <= 1'b1;	end
		else if(x==10 && y==12) begin	plot <= 1'b1;	end
		else if(x==12 && y==12) begin	plot <= 1'b1;	end
		else if(x==13 && y==12) begin	plot <= 1'b1;	end
		else if(x==14 && y==12) begin	plot <= 1'b1;	end
		else if(x==15 && y==12) begin	plot <= 1'b1;	end
		else if(x==4 && y==13) begin	plot <= 1'b1;	end
		else if(x==5 && y==13) begin	plot <= 1'b1;	end
		else if(x==6 && y==13) begin	plot <= 1'b1;	end
		else if(x==7 && y==13) begin	plot <= 1'b1;	end
		else if(x==9 && y==13) begin	plot <= 1'b1;	end
		else if(x==10 && y==13) begin	plot <= 1'b1;	end
		else if(x==12 && y==13) begin	plot <= 1'b1;	end
		else if(x==14 && y==13) begin	plot <= 1'b1;	end
		else if(x==15 && y==13) begin	plot <= 1'b1;	end
		else if(x==16 && y==13) begin	plot <= 1'b1;	end
		else if(x==3 && y==14) begin	plot <= 1'b1;	end
		else if(x==4 && y==14) begin	plot <= 1'b1;	end
		else if(x==5 && y==14) begin	plot <= 1'b1;	end
		else if(x==7 && y==14) begin	plot <= 1'b1;	end
		else if(x==9 && y==14) begin	plot <= 1'b1;	end
		else if(x==10 && y==14) begin	plot <= 1'b1;	end
		else if(x==12 && y==14) begin	plot <= 1'b1;	end
		else if(x==14 && y==14) begin	plot <= 1'b1;	end
		else if(x==15 && y==14) begin	plot <= 1'b1;	end
		else if(x==16 && y==14) begin	plot <= 1'b1;	end
		else if(x==17 && y==14) begin	plot <= 1'b1;	end
		else if(x==2 && y==15) begin	plot <= 1'b1;	end
		else if(x==3 && y==15) begin	plot <= 1'b1;	end
		else if(x==4 && y==15) begin	plot <= 1'b1;	end
		else if(x==5 && y==15) begin	plot <= 1'b1;	end
		else if(x==8 && y==15) begin	plot <= 1'b1;	end
		else if(x==9 && y==15) begin	plot <= 1'b1;	end
		else if(x==10 && y==15) begin	plot <= 1'b1;	end
		else if(x==11 && y==15) begin	plot <= 1'b1;	end
		else if(x==14 && y==15) begin	plot <= 1'b1;	end
		else if(x==15 && y==15) begin	plot <= 1'b1;	end
		else if(x==16 && y==15) begin	plot <= 1'b1;	end
		else if(x==17 && y==15) begin	plot <= 1'b1;	end
		else if(x==18 && y==15) begin	plot <= 1'b1;	end
		else if(x==1 && y==16) begin	plot <= 1'b1;	end
		else if(x==2 && y==16) begin	plot <= 1'b1;	end
		else if(x==3 && y==16) begin	plot <= 1'b1;	end
		else if(x==4 && y==16) begin	plot <= 1'b1;	end
		else if(x==5 && y==16) begin	plot <= 1'b1;	end
		else if(x==8 && y==16) begin	plot <= 1'b1;	end
		else if(x==9 && y==16) begin	plot <= 1'b1;	end
		else if(x==10 && y==16) begin	plot <= 1'b1;	end
		else if(x==11 && y==16) begin	plot <= 1'b1;	end
		else if(x==12 && y==16) begin	plot <= 1'b1;	end
		else if(x==18 && y==16) begin	plot <= 1'b1;	end
		else if(x==8 && y==17) begin	plot <= 1'b1;	end
		else if(x==10 && y==17) begin	plot <= 1'b1;	end
		else if(x==12 && y==17) begin	plot <= 1'b1;	end
		else if(x==16 && y==17) begin	plot <= 1'b1;	end
		else begin plot <= 1'b0; end// Width: 20, Height: 25
	end
endmodule

module PlotSmall(
	input clk,
	input wire [9:0] characterPositionX,
	input wire [8:0] characterPositionY,
	input wire [9:0] drawingPositionX,
	input wire [8:0] drawingPositionY,
	output reg [2:0] plot
);
	reg [9:0] x;
	reg [9:0] y;
	initial begin
		x = 'd0;
		y = 'd0;
	end

	always @(posedge clk) begin
		x <= (drawingPositionX - characterPositionX + 9);
		y <= (drawingPositionY - characterPositionY + 7);
		if(x==7 && y==2) begin	plot <= 1'b1;	end
		else if(x==8 && y==2) begin	plot <= 1'b1;	end
		else if(x==9 && y==2) begin	plot <= 1'b1;	end
		else if(x==7 && y==3) begin	plot <= 1'b1;	end
		else if(x==8 && y==3) begin	plot <= 1'b1;	end
		else if(x==9 && y==3) begin	plot <= 1'b1;	end
		else if(x==2 && y==4) begin	plot <= 1'b1;	end
		else if(x==3 && y==4) begin	plot <= 1'b1;	end
		else if(x==4 && y==4) begin	plot <= 1'b1;	end
		else if(x==5 && y==4) begin	plot <= 1'b1;	end
		else if(x==6 && y==4) begin	plot <= 1'b1;	end
		else if(x==7 && y==4) begin	plot <= 1'b1;	end
		else if(x==8 && y==4) begin	plot <= 1'b1;	end
		else if(x==9 && y==4) begin	plot <= 1'b1;	end
		else if(x==10 && y==4) begin	plot <= 1'b1;	end
		else if(x==11 && y==4) begin	plot <= 1'b1;	end
		else if(x==12 && y==4) begin	plot <= 1'b1;	end
		else if(x==13 && y==4) begin	plot <= 1'b1;	end
		else if(x==14 && y==4) begin	plot <= 1'b1;	end
		else if(x==3 && y==5) begin	plot <= 1'b1;	end
		else if(x==4 && y==5) begin	plot <= 1'b1;	end
		else if(x==5 && y==5) begin	plot <= 1'b1;	end
		else if(x==6 && y==5) begin	plot <= 1'b1;	end
		else if(x==7 && y==5) begin	plot <= 1'b1;	end
		else if(x==9 && y==5) begin	plot <= 1'b1;	end
		else if(x==10 && y==5) begin	plot <= 1'b1;	end
		else if(x==11 && y==5) begin	plot <= 1'b1;	end
		else if(x==12 && y==5) begin	plot <= 1'b1;	end
		else if(x==13 && y==5) begin	plot <= 1'b1;	end
		else if(x==4 && y==6) begin	plot <= 1'b1;	end
		else if(x==5 && y==6) begin	plot <= 1'b1;	end
		else if(x==6 && y==6) begin	plot <= 1'b1;	end
		else if(x==7 && y==6) begin	plot <= 1'b1;	end
		else if(x==9 && y==6) begin	plot <= 1'b1;	end
		else if(x==10 && y==6) begin	plot <= 1'b1;	end
		else if(x==11 && y==6) begin	plot <= 1'b1;	end
		else if(x==12 && y==6) begin	plot <= 1'b1;	end
		else if(x==5 && y==7) begin	plot <= 1'b1;	end
		else if(x==6 && y==7) begin	plot <= 1'b1;	end
		else if(x==7 && y==7) begin	plot <= 1'b1;	end
		else if(x==9 && y==7) begin	plot <= 1'b1;	end
		else if(x==10 && y==7) begin	plot <= 1'b1;	end
		else if(x==11 && y==7) begin	plot <= 1'b1;	end
		else if(x==6 && y==8) begin	plot <= 1'b1;	end
		else if(x==7 && y==8) begin	plot <= 1'b1;	end
		else if(x==8 && y==8) begin	plot <= 1'b1;	end
		else if(x==9 && y==8) begin	plot <= 1'b1;	end
		else if(x==10 && y==8) begin	plot <= 1'b1;	end
		else if(x==7 && y==9) begin	plot <= 1'b1;	end
		else if(x==8 && y==9) begin	plot <= 1'b1;	end
		else if(x==9 && y==9) begin	plot <= 1'b1;	end
		else begin plot <= 1'b0; end// Width: 16, Height: 12
	end
endmodule

// module for plotting boss aircraft
module PlotBoss(
	input clk,
	input wire [9:0] characterPositionX,
	input wire [8:0] characterPositionY,
	input wire [9:0] drawingPositionX,
	input wire [8:0] drawingPositionY,
	output reg [2:0] plot
);
	reg [9:0] x;
	reg [9:0] y;
	initial begin
		x = 'd0;
		y = 'd0;
	end

	always @(posedge clk) begin
		x <= (drawingPositionX - characterPositionX + 35);
		y <= (drawingPositionY - characterPositionY + 23);
		if(x==17 && y==3) begin	plot <= 1'b1;	end
		else if(x==50 && y==3) begin	plot <= 1'b1;	end
		else if(x==51 && y==3) begin	plot <= 1'b1;	end
		else if(x==17 && y==4) begin	plot <= 1'b1;	end
		else if(x==18 && y==4) begin	plot <= 1'b1;	end
		else if(x==50 && y==4) begin	plot <= 1'b1;	end
		else if(x==51 && y==4) begin	plot <= 1'b1;	end
		else if(x==16 && y==5) begin	plot <= 1'b1;	end
		else if(x==17 && y==5) begin	plot <= 1'b1;	end
		else if(x==18 && y==5) begin	plot <= 1'b1;	end
		else if(x==19 && y==5) begin	plot <= 1'b1;	end
		else if(x==50 && y==5) begin	plot <= 1'b1;	end
		else if(x==51 && y==5) begin	plot <= 1'b1;	end
		else if(x==17 && y==6) begin	plot <= 1'b1;	end
		else if(x==18 && y==6) begin	plot <= 1'b1;	end
		else if(x==19 && y==6) begin	plot <= 1'b1;	end
		else if(x==32 && y==6) begin	plot <= 1'b1;	end
		else if(x==33 && y==6) begin	plot <= 1'b1;	end
		else if(x==34 && y==6) begin	plot <= 1'b1;	end
		else if(x==35 && y==6) begin	plot <= 1'b1;	end
		else if(x==36 && y==6) begin	plot <= 1'b1;	end
		else if(x==50 && y==6) begin	plot <= 1'b1;	end
		else if(x==53 && y==6) begin	plot <= 1'b1;	end
		else if(x==14 && y==7) begin	plot <= 1'b1;	end
		else if(x==15 && y==7) begin	plot <= 1'b1;	end
		else if(x==16 && y==7) begin	plot <= 1'b1;	end
		else if(x==17 && y==7) begin	plot <= 1'b1;	end
		else if(x==18 && y==7) begin	plot <= 1'b1;	end
		else if(x==19 && y==7) begin	plot <= 1'b1;	end
		else if(x==31 && y==7) begin	plot <= 1'b1;	end
		else if(x==32 && y==7) begin	plot <= 1'b1;	end
		else if(x==33 && y==7) begin	plot <= 1'b1;	end
		else if(x==34 && y==7) begin	plot <= 1'b1;	end
		else if(x==35 && y==7) begin	plot <= 1'b1;	end
		else if(x==36 && y==7) begin	plot <= 1'b1;	end
		else if(x==37 && y==7) begin	plot <= 1'b1;	end
		else if(x==41 && y==7) begin	plot <= 1'b1;	end
		else if(x==51 && y==7) begin	plot <= 1'b1;	end
		else if(x==14 && y==8) begin	plot <= 1'b1;	end
		else if(x==15 && y==8) begin	plot <= 1'b1;	end
		else if(x==16 && y==8) begin	plot <= 1'b1;	end
		else if(x==17 && y==8) begin	plot <= 1'b1;	end
		else if(x==18 && y==8) begin	plot <= 1'b1;	end
		else if(x==19 && y==8) begin	plot <= 1'b1;	end
		else if(x==31 && y==8) begin	plot <= 1'b1;	end
		else if(x==32 && y==8) begin	plot <= 1'b1;	end
		else if(x==33 && y==8) begin	plot <= 1'b1;	end
		else if(x==34 && y==8) begin	plot <= 1'b1;	end
		else if(x==35 && y==8) begin	plot <= 1'b1;	end
		else if(x==36 && y==8) begin	plot <= 1'b1;	end
		else if(x==37 && y==8) begin	plot <= 1'b1;	end
		else if(x==41 && y==8) begin	plot <= 1'b1;	end
		else if(x==51 && y==8) begin	plot <= 1'b1;	end
		else if(x==52 && y==8) begin	plot <= 1'b1;	end
		else if(x==7 && y==9) begin	plot <= 1'b1;	end
		else if(x==8 && y==9) begin	plot <= 1'b1;	end
		else if(x==15 && y==9) begin	plot <= 1'b1;	end
		else if(x==16 && y==9) begin	plot <= 1'b1;	end
		else if(x==17 && y==9) begin	plot <= 1'b1;	end
		else if(x==18 && y==9) begin	plot <= 1'b1;	end
		else if(x==19 && y==9) begin	plot <= 1'b1;	end
		else if(x==27 && y==9) begin	plot <= 1'b1;	end
		else if(x==28 && y==9) begin	plot <= 1'b1;	end
		else if(x==29 && y==9) begin	plot <= 1'b1;	end
		else if(x==30 && y==9) begin	plot <= 1'b1;	end
		else if(x==31 && y==9) begin	plot <= 1'b1;	end
		else if(x==32 && y==9) begin	plot <= 1'b1;	end
		else if(x==33 && y==9) begin	plot <= 1'b1;	end
		else if(x==34 && y==9) begin	plot <= 1'b1;	end
		else if(x==35 && y==9) begin	plot <= 1'b1;	end
		else if(x==36 && y==9) begin	plot <= 1'b1;	end
		else if(x==37 && y==9) begin	plot <= 1'b1;	end
		else if(x==38 && y==9) begin	plot <= 1'b1;	end
		else if(x==39 && y==9) begin	plot <= 1'b1;	end
		else if(x==40 && y==9) begin	plot <= 1'b1;	end
		else if(x==41 && y==9) begin	plot <= 1'b1;	end
		else if(x==42 && y==9) begin	plot <= 1'b1;	end
		else if(x==51 && y==9) begin	plot <= 1'b1;	end
		else if(x==52 && y==9) begin	plot <= 1'b1;	end
		else if(x==53 && y==9) begin	plot <= 1'b1;	end
		else if(x==54 && y==9) begin	plot <= 1'b1;	end
		else if(x==55 && y==9) begin	plot <= 1'b1;	end
		else if(x==59 && y==9) begin	plot <= 1'b1;	end
		else if(x==7 && y==10) begin	plot <= 1'b1;	end
		else if(x==8 && y==10) begin	plot <= 1'b1;	end
		else if(x==9 && y==10) begin	plot <= 1'b1;	end
		else if(x==10 && y==10) begin	plot <= 1'b1;	end
		else if(x==11 && y==10) begin	plot <= 1'b1;	end
		else if(x==12 && y==10) begin	plot <= 1'b1;	end
		else if(x==13 && y==10) begin	plot <= 1'b1;	end
		else if(x==14 && y==10) begin	plot <= 1'b1;	end
		else if(x==15 && y==10) begin	plot <= 1'b1;	end
		else if(x==16 && y==10) begin	plot <= 1'b1;	end
		else if(x==17 && y==10) begin	plot <= 1'b1;	end
		else if(x==18 && y==10) begin	plot <= 1'b1;	end
		else if(x==27 && y==10) begin	plot <= 1'b1;	end
		else if(x==28 && y==10) begin	plot <= 1'b1;	end
		else if(x==29 && y==10) begin	plot <= 1'b1;	end
		else if(x==30 && y==10) begin	plot <= 1'b1;	end
		else if(x==31 && y==10) begin	plot <= 1'b1;	end
		else if(x==32 && y==10) begin	plot <= 1'b1;	end
		else if(x==33 && y==10) begin	plot <= 1'b1;	end
		else if(x==34 && y==10) begin	plot <= 1'b1;	end
		else if(x==35 && y==10) begin	plot <= 1'b1;	end
		else if(x==36 && y==10) begin	plot <= 1'b1;	end
		else if(x==37 && y==10) begin	plot <= 1'b1;	end
		else if(x==38 && y==10) begin	plot <= 1'b1;	end
		else if(x==39 && y==10) begin	plot <= 1'b1;	end
		else if(x==40 && y==10) begin	plot <= 1'b1;	end
		else if(x==41 && y==10) begin	plot <= 1'b1;	end
		else if(x==49 && y==10) begin	plot <= 1'b1;	end
		else if(x==50 && y==10) begin	plot <= 1'b1;	end
		else if(x==51 && y==10) begin	plot <= 1'b1;	end
		else if(x==52 && y==10) begin	plot <= 1'b1;	end
		else if(x==53 && y==10) begin	plot <= 1'b1;	end
		else if(x==54 && y==10) begin	plot <= 1'b1;	end
		else if(x==55 && y==10) begin	plot <= 1'b1;	end
		else if(x==59 && y==10) begin	plot <= 1'b1;	end
		else if(x==60 && y==10) begin	plot <= 1'b1;	end
		else if(x==7 && y==11) begin	plot <= 1'b1;	end
		else if(x==8 && y==11) begin	plot <= 1'b1;	end
		else if(x==9 && y==11) begin	plot <= 1'b1;	end
		else if(x==10 && y==11) begin	plot <= 1'b1;	end
		else if(x==11 && y==11) begin	plot <= 1'b1;	end
		else if(x==12 && y==11) begin	plot <= 1'b1;	end
		else if(x==13 && y==11) begin	plot <= 1'b1;	end
		else if(x==14 && y==11) begin	plot <= 1'b1;	end
		else if(x==15 && y==11) begin	plot <= 1'b1;	end
		else if(x==16 && y==11) begin	plot <= 1'b1;	end
		else if(x==17 && y==11) begin	plot <= 1'b1;	end
		else if(x==27 && y==11) begin	plot <= 1'b1;	end
		else if(x==28 && y==11) begin	plot <= 1'b1;	end
		else if(x==29 && y==11) begin	plot <= 1'b1;	end
		else if(x==30 && y==11) begin	plot <= 1'b1;	end
		else if(x==31 && y==11) begin	plot <= 1'b1;	end
		else if(x==32 && y==11) begin	plot <= 1'b1;	end
		else if(x==33 && y==11) begin	plot <= 1'b1;	end
		else if(x==34 && y==11) begin	plot <= 1'b1;	end
		else if(x==35 && y==11) begin	plot <= 1'b1;	end
		else if(x==36 && y==11) begin	plot <= 1'b1;	end
		else if(x==37 && y==11) begin	plot <= 1'b1;	end
		else if(x==38 && y==11) begin	plot <= 1'b1;	end
		else if(x==39 && y==11) begin	plot <= 1'b1;	end
		else if(x==40 && y==11) begin	plot <= 1'b1;	end
		else if(x==48 && y==11) begin	plot <= 1'b1;	end
		else if(x==49 && y==11) begin	plot <= 1'b1;	end
		else if(x==50 && y==11) begin	plot <= 1'b1;	end
		else if(x==51 && y==11) begin	plot <= 1'b1;	end
		else if(x==52 && y==11) begin	plot <= 1'b1;	end
		else if(x==53 && y==11) begin	plot <= 1'b1;	end
		else if(x==54 && y==11) begin	plot <= 1'b1;	end
		else if(x==55 && y==11) begin	plot <= 1'b1;	end
		else if(x==59 && y==11) begin	plot <= 1'b1;	end
		else if(x==60 && y==11) begin	plot <= 1'b1;	end
		else if(x==6 && y==12) begin	plot <= 1'b1;	end
		else if(x==7 && y==12) begin	plot <= 1'b1;	end
		else if(x==8 && y==12) begin	plot <= 1'b1;	end
		else if(x==9 && y==12) begin	plot <= 1'b1;	end
		else if(x==10 && y==12) begin	plot <= 1'b1;	end
		else if(x==11 && y==12) begin	plot <= 1'b1;	end
		else if(x==12 && y==12) begin	plot <= 1'b1;	end
		else if(x==13 && y==12) begin	plot <= 1'b1;	end
		else if(x==14 && y==12) begin	plot <= 1'b1;	end
		else if(x==15 && y==12) begin	plot <= 1'b1;	end
		else if(x==16 && y==12) begin	plot <= 1'b1;	end
		else if(x==17 && y==12) begin	plot <= 1'b1;	end
		else if(x==29 && y==12) begin	plot <= 1'b1;	end
		else if(x==30 && y==12) begin	plot <= 1'b1;	end
		else if(x==31 && y==12) begin	plot <= 1'b1;	end
		else if(x==32 && y==12) begin	plot <= 1'b1;	end
		else if(x==33 && y==12) begin	plot <= 1'b1;	end
		else if(x==34 && y==12) begin	plot <= 1'b1;	end
		else if(x==35 && y==12) begin	plot <= 1'b1;	end
		else if(x==36 && y==12) begin	plot <= 1'b1;	end
		else if(x==37 && y==12) begin	plot <= 1'b1;	end
		else if(x==38 && y==12) begin	plot <= 1'b1;	end
		else if(x==39 && y==12) begin	plot <= 1'b1;	end
		else if(x==40 && y==12) begin	plot <= 1'b1;	end
		else if(x==50 && y==12) begin	plot <= 1'b1;	end
		else if(x==51 && y==12) begin	plot <= 1'b1;	end
		else if(x==52 && y==12) begin	plot <= 1'b1;	end
		else if(x==53 && y==12) begin	plot <= 1'b1;	end
		else if(x==54 && y==12) begin	plot <= 1'b1;	end
		else if(x==55 && y==12) begin	plot <= 1'b1;	end
		else if(x==56 && y==12) begin	plot <= 1'b1;	end
		else if(x==57 && y==12) begin	plot <= 1'b1;	end
		else if(x==58 && y==12) begin	plot <= 1'b1;	end
		else if(x==59 && y==12) begin	plot <= 1'b1;	end
		else if(x==60 && y==12) begin	plot <= 1'b1;	end
		else if(x==61 && y==12) begin	plot <= 1'b1;	end
		else if(x==5 && y==13) begin	plot <= 1'b1;	end
		else if(x==6 && y==13) begin	plot <= 1'b1;	end
		else if(x==7 && y==13) begin	plot <= 1'b1;	end
		else if(x==11 && y==13) begin	plot <= 1'b1;	end
		else if(x==12 && y==13) begin	plot <= 1'b1;	end
		else if(x==13 && y==13) begin	plot <= 1'b1;	end
		else if(x==14 && y==13) begin	plot <= 1'b1;	end
		else if(x==15 && y==13) begin	plot <= 1'b1;	end
		else if(x==16 && y==13) begin	plot <= 1'b1;	end
		else if(x==17 && y==13) begin	plot <= 1'b1;	end
		else if(x==18 && y==13) begin	plot <= 1'b1;	end
		else if(x==19 && y==13) begin	plot <= 1'b1;	end
		else if(x==29 && y==13) begin	plot <= 1'b1;	end
		else if(x==30 && y==13) begin	plot <= 1'b1;	end
		else if(x==31 && y==13) begin	plot <= 1'b1;	end
		else if(x==32 && y==13) begin	plot <= 1'b1;	end
		else if(x==33 && y==13) begin	plot <= 1'b1;	end
		else if(x==34 && y==13) begin	plot <= 1'b1;	end
		else if(x==35 && y==13) begin	plot <= 1'b1;	end
		else if(x==36 && y==13) begin	plot <= 1'b1;	end
		else if(x==37 && y==13) begin	plot <= 1'b1;	end
		else if(x==38 && y==13) begin	plot <= 1'b1;	end
		else if(x==39 && y==13) begin	plot <= 1'b1;	end
		else if(x==40 && y==13) begin	plot <= 1'b1;	end
		else if(x==49 && y==13) begin	plot <= 1'b1;	end
		else if(x==50 && y==13) begin	plot <= 1'b1;	end
		else if(x==51 && y==13) begin	plot <= 1'b1;	end
		else if(x==52 && y==13) begin	plot <= 1'b1;	end
		else if(x==53 && y==13) begin	plot <= 1'b1;	end
		else if(x==54 && y==13) begin	plot <= 1'b1;	end
		else if(x==55 && y==13) begin	plot <= 1'b1;	end
		else if(x==56 && y==13) begin	plot <= 1'b1;	end
		else if(x==57 && y==13) begin	plot <= 1'b1;	end
		else if(x==58 && y==13) begin	plot <= 1'b1;	end
		else if(x==59 && y==13) begin	plot <= 1'b1;	end
		else if(x==60 && y==13) begin	plot <= 1'b1;	end
		else if(x==61 && y==13) begin	plot <= 1'b1;	end
		else if(x==62 && y==13) begin	plot <= 1'b1;	end
		else if(x==5 && y==14) begin	plot <= 1'b1;	end
		else if(x==6 && y==14) begin	plot <= 1'b1;	end
		else if(x==7 && y==14) begin	plot <= 1'b1;	end
		else if(x==12 && y==14) begin	plot <= 1'b1;	end
		else if(x==13 && y==14) begin	plot <= 1'b1;	end
		else if(x==14 && y==14) begin	plot <= 1'b1;	end
		else if(x==15 && y==14) begin	plot <= 1'b1;	end
		else if(x==16 && y==14) begin	plot <= 1'b1;	end
		else if(x==17 && y==14) begin	plot <= 1'b1;	end
		else if(x==18 && y==14) begin	plot <= 1'b1;	end
		else if(x==19 && y==14) begin	plot <= 1'b1;	end
		else if(x==20 && y==14) begin	plot <= 1'b1;	end
		else if(x==29 && y==14) begin	plot <= 1'b1;	end
		else if(x==30 && y==14) begin	plot <= 1'b1;	end
		else if(x==31 && y==14) begin	plot <= 1'b1;	end
		else if(x==38 && y==14) begin	plot <= 1'b1;	end
		else if(x==39 && y==14) begin	plot <= 1'b1;	end
		else if(x==40 && y==14) begin	plot <= 1'b1;	end
		else if(x==48 && y==14) begin	plot <= 1'b1;	end
		else if(x==49 && y==14) begin	plot <= 1'b1;	end
		else if(x==50 && y==14) begin	plot <= 1'b1;	end
		else if(x==51 && y==14) begin	plot <= 1'b1;	end
		else if(x==52 && y==14) begin	plot <= 1'b1;	end
		else if(x==53 && y==14) begin	plot <= 1'b1;	end
		else if(x==59 && y==14) begin	plot <= 1'b1;	end
		else if(x==60 && y==14) begin	plot <= 1'b1;	end
		else if(x==61 && y==14) begin	plot <= 1'b1;	end
		else if(x==62 && y==14) begin	plot <= 1'b1;	end
		else if(x==4 && y==15) begin	plot <= 1'b1;	end
		else if(x==5 && y==15) begin	plot <= 1'b1;	end
		else if(x==6 && y==15) begin	plot <= 1'b1;	end
		else if(x==7 && y==15) begin	plot <= 1'b1;	end
		else if(x==8 && y==15) begin	plot <= 1'b1;	end
		else if(x==9 && y==15) begin	plot <= 1'b1;	end
		else if(x==15 && y==15) begin	plot <= 1'b1;	end
		else if(x==16 && y==15) begin	plot <= 1'b1;	end
		else if(x==17 && y==15) begin	plot <= 1'b1;	end
		else if(x==18 && y==15) begin	plot <= 1'b1;	end
		else if(x==19 && y==15) begin	plot <= 1'b1;	end
		else if(x==20 && y==15) begin	plot <= 1'b1;	end
		else if(x==29 && y==15) begin	plot <= 1'b1;	end
		else if(x==30 && y==15) begin	plot <= 1'b1;	end
		else if(x==31 && y==15) begin	plot <= 1'b1;	end
		else if(x==38 && y==15) begin	plot <= 1'b1;	end
		else if(x==39 && y==15) begin	plot <= 1'b1;	end
		else if(x==40 && y==15) begin	plot <= 1'b1;	end
		else if(x==47 && y==15) begin	plot <= 1'b1;	end
		else if(x==48 && y==15) begin	plot <= 1'b1;	end
		else if(x==49 && y==15) begin	plot <= 1'b1;	end
		else if(x==50 && y==15) begin	plot <= 1'b1;	end
		else if(x==51 && y==15) begin	plot <= 1'b1;	end
		else if(x==52 && y==15) begin	plot <= 1'b1;	end
		else if(x==58 && y==15) begin	plot <= 1'b1;	end
		else if(x==59 && y==15) begin	plot <= 1'b1;	end
		else if(x==60 && y==15) begin	plot <= 1'b1;	end
		else if(x==61 && y==15) begin	plot <= 1'b1;	end
		else if(x==62 && y==15) begin	plot <= 1'b1;	end
		else if(x==5 && y==16) begin	plot <= 1'b1;	end
		else if(x==6 && y==16) begin	plot <= 1'b1;	end
		else if(x==7 && y==16) begin	plot <= 1'b1;	end
		else if(x==8 && y==16) begin	plot <= 1'b1;	end
		else if(x==9 && y==16) begin	plot <= 1'b1;	end
		else if(x==10 && y==16) begin	plot <= 1'b1;	end
		else if(x==16 && y==16) begin	plot <= 1'b1;	end
		else if(x==17 && y==16) begin	plot <= 1'b1;	end
		else if(x==18 && y==16) begin	plot <= 1'b1;	end
		else if(x==19 && y==16) begin	plot <= 1'b1;	end
		else if(x==20 && y==16) begin	plot <= 1'b1;	end
		else if(x==21 && y==16) begin	plot <= 1'b1;	end
		else if(x==22 && y==16) begin	plot <= 1'b1;	end
		else if(x==29 && y==16) begin	plot <= 1'b1;	end
		else if(x==30 && y==16) begin	plot <= 1'b1;	end
		else if(x==31 && y==16) begin	plot <= 1'b1;	end
		else if(x==38 && y==16) begin	plot <= 1'b1;	end
		else if(x==39 && y==16) begin	plot <= 1'b1;	end
		else if(x==40 && y==16) begin	plot <= 1'b1;	end
		else if(x==41 && y==16) begin	plot <= 1'b1;	end
		else if(x==46 && y==16) begin	plot <= 1'b1;	end
		else if(x==47 && y==16) begin	plot <= 1'b1;	end
		else if(x==48 && y==16) begin	plot <= 1'b1;	end
		else if(x==49 && y==16) begin	plot <= 1'b1;	end
		else if(x==50 && y==16) begin	plot <= 1'b1;	end
		else if(x==57 && y==16) begin	plot <= 1'b1;	end
		else if(x==58 && y==16) begin	plot <= 1'b1;	end
		else if(x==59 && y==16) begin	plot <= 1'b1;	end
		else if(x==60 && y==16) begin	plot <= 1'b1;	end
		else if(x==61 && y==16) begin	plot <= 1'b1;	end
		else if(x==62 && y==16) begin	plot <= 1'b1;	end
		else if(x==63 && y==16) begin	plot <= 1'b1;	end
		else if(x==6 && y==17) begin	plot <= 1'b1;	end
		else if(x==7 && y==17) begin	plot <= 1'b1;	end
		else if(x==8 && y==17) begin	plot <= 1'b1;	end
		else if(x==9 && y==17) begin	plot <= 1'b1;	end
		else if(x==10 && y==17) begin	plot <= 1'b1;	end
		else if(x==11 && y==17) begin	plot <= 1'b1;	end
		else if(x==20 && y==17) begin	plot <= 1'b1;	end
		else if(x==21 && y==17) begin	plot <= 1'b1;	end
		else if(x==22 && y==17) begin	plot <= 1'b1;	end
		else if(x==23 && y==17) begin	plot <= 1'b1;	end
		else if(x==29 && y==17) begin	plot <= 1'b1;	end
		else if(x==30 && y==17) begin	plot <= 1'b1;	end
		else if(x==31 && y==17) begin	plot <= 1'b1;	end
		else if(x==38 && y==17) begin	plot <= 1'b1;	end
		else if(x==39 && y==17) begin	plot <= 1'b1;	end
		else if(x==40 && y==17) begin	plot <= 1'b1;	end
		else if(x==41 && y==17) begin	plot <= 1'b1;	end
		else if(x==45 && y==17) begin	plot <= 1'b1;	end
		else if(x==46 && y==17) begin	plot <= 1'b1;	end
		else if(x==47 && y==17) begin	plot <= 1'b1;	end
		else if(x==48 && y==17) begin	plot <= 1'b1;	end
		else if(x==49 && y==17) begin	plot <= 1'b1;	end
		else if(x==56 && y==17) begin	plot <= 1'b1;	end
		else if(x==57 && y==17) begin	plot <= 1'b1;	end
		else if(x==58 && y==17) begin	plot <= 1'b1;	end
		else if(x==59 && y==17) begin	plot <= 1'b1;	end
		else if(x==62 && y==17) begin	plot <= 1'b1;	end
		else if(x==63 && y==17) begin	plot <= 1'b1;	end
		else if(x==10 && y==18) begin	plot <= 1'b1;	end
		else if(x==11 && y==18) begin	plot <= 1'b1;	end
		else if(x==12 && y==18) begin	plot <= 1'b1;	end
		else if(x==13 && y==18) begin	plot <= 1'b1;	end
		else if(x==14 && y==18) begin	plot <= 1'b1;	end
		else if(x==20 && y==18) begin	plot <= 1'b1;	end
		else if(x==21 && y==18) begin	plot <= 1'b1;	end
		else if(x==22 && y==18) begin	plot <= 1'b1;	end
		else if(x==23 && y==18) begin	plot <= 1'b1;	end
		else if(x==24 && y==18) begin	plot <= 1'b1;	end
		else if(x==25 && y==18) begin	plot <= 1'b1;	end
		else if(x==26 && y==18) begin	plot <= 1'b1;	end
		else if(x==27 && y==18) begin	plot <= 1'b1;	end
		else if(x==28 && y==18) begin	plot <= 1'b1;	end
		else if(x==29 && y==18) begin	plot <= 1'b1;	end
		else if(x==30 && y==18) begin	plot <= 1'b1;	end
		else if(x==31 && y==18) begin	plot <= 1'b1;	end
		else if(x==32 && y==18) begin	plot <= 1'b1;	end
		else if(x==36 && y==18) begin	plot <= 1'b1;	end
		else if(x==37 && y==18) begin	plot <= 1'b1;	end
		else if(x==38 && y==18) begin	plot <= 1'b1;	end
		else if(x==39 && y==18) begin	plot <= 1'b1;	end
		else if(x==40 && y==18) begin	plot <= 1'b1;	end
		else if(x==41 && y==18) begin	plot <= 1'b1;	end
		else if(x==42 && y==18) begin	plot <= 1'b1;	end
		else if(x==43 && y==18) begin	plot <= 1'b1;	end
		else if(x==44 && y==18) begin	plot <= 1'b1;	end
		else if(x==45 && y==18) begin	plot <= 1'b1;	end
		else if(x==46 && y==18) begin	plot <= 1'b1;	end
		else if(x==52 && y==18) begin	plot <= 1'b1;	end
		else if(x==53 && y==18) begin	plot <= 1'b1;	end
		else if(x==54 && y==18) begin	plot <= 1'b1;	end
		else if(x==55 && y==18) begin	plot <= 1'b1;	end
		else if(x==56 && y==18) begin	plot <= 1'b1;	end
		else if(x==57 && y==18) begin	plot <= 1'b1;	end
		else if(x==58 && y==18) begin	plot <= 1'b1;	end
		else if(x==11 && y==19) begin	plot <= 1'b1;	end
		else if(x==12 && y==19) begin	plot <= 1'b1;	end
		else if(x==13 && y==19) begin	plot <= 1'b1;	end
		else if(x==14 && y==19) begin	plot <= 1'b1;	end
		else if(x==15 && y==19) begin	plot <= 1'b1;	end
		else if(x==16 && y==19) begin	plot <= 1'b1;	end
		else if(x==20 && y==19) begin	plot <= 1'b1;	end
		else if(x==21 && y==19) begin	plot <= 1'b1;	end
		else if(x==22 && y==19) begin	plot <= 1'b1;	end
		else if(x==23 && y==19) begin	plot <= 1'b1;	end
		else if(x==24 && y==19) begin	plot <= 1'b1;	end
		else if(x==25 && y==19) begin	plot <= 1'b1;	end
		else if(x==26 && y==19) begin	plot <= 1'b1;	end
		else if(x==27 && y==19) begin	plot <= 1'b1;	end
		else if(x==28 && y==19) begin	plot <= 1'b1;	end
		else if(x==29 && y==19) begin	plot <= 1'b1;	end
		else if(x==30 && y==19) begin	plot <= 1'b1;	end
		else if(x==31 && y==19) begin	plot <= 1'b1;	end
		else if(x==32 && y==19) begin	plot <= 1'b1;	end
		else if(x==36 && y==19) begin	plot <= 1'b1;	end
		else if(x==37 && y==19) begin	plot <= 1'b1;	end
		else if(x==38 && y==19) begin	plot <= 1'b1;	end
		else if(x==39 && y==19) begin	plot <= 1'b1;	end
		else if(x==40 && y==19) begin	plot <= 1'b1;	end
		else if(x==41 && y==19) begin	plot <= 1'b1;	end
		else if(x==42 && y==19) begin	plot <= 1'b1;	end
		else if(x==43 && y==19) begin	plot <= 1'b1;	end
		else if(x==44 && y==19) begin	plot <= 1'b1;	end
		else if(x==45 && y==19) begin	plot <= 1'b1;	end
		else if(x==46 && y==19) begin	plot <= 1'b1;	end
		else if(x==51 && y==19) begin	plot <= 1'b1;	end
		else if(x==52 && y==19) begin	plot <= 1'b1;	end
		else if(x==53 && y==19) begin	plot <= 1'b1;	end
		else if(x==54 && y==19) begin	plot <= 1'b1;	end
		else if(x==55 && y==19) begin	plot <= 1'b1;	end
		else if(x==56 && y==19) begin	plot <= 1'b1;	end
		else if(x==57 && y==19) begin	plot <= 1'b1;	end
		else if(x==11 && y==20) begin	plot <= 1'b1;	end
		else if(x==12 && y==20) begin	plot <= 1'b1;	end
		else if(x==13 && y==20) begin	plot <= 1'b1;	end
		else if(x==14 && y==20) begin	plot <= 1'b1;	end
		else if(x==15 && y==20) begin	plot <= 1'b1;	end
		else if(x==16 && y==20) begin	plot <= 1'b1;	end
		else if(x==17 && y==20) begin	plot <= 1'b1;	end
		else if(x==20 && y==20) begin	plot <= 1'b1;	end
		else if(x==21 && y==20) begin	plot <= 1'b1;	end
		else if(x==22 && y==20) begin	plot <= 1'b1;	end
		else if(x==27 && y==20) begin	plot <= 1'b1;	end
		else if(x==28 && y==20) begin	plot <= 1'b1;	end
		else if(x==29 && y==20) begin	plot <= 1'b1;	end
		else if(x==30 && y==20) begin	plot <= 1'b1;	end
		else if(x==31 && y==20) begin	plot <= 1'b1;	end
		else if(x==32 && y==20) begin	plot <= 1'b1;	end
		else if(x==36 && y==20) begin	plot <= 1'b1;	end
		else if(x==37 && y==20) begin	plot <= 1'b1;	end
		else if(x==38 && y==20) begin	plot <= 1'b1;	end
		else if(x==39 && y==20) begin	plot <= 1'b1;	end
		else if(x==40 && y==20) begin	plot <= 1'b1;	end
		else if(x==45 && y==20) begin	plot <= 1'b1;	end
		else if(x==46 && y==20) begin	plot <= 1'b1;	end
		else if(x==50 && y==20) begin	plot <= 1'b1;	end
		else if(x==51 && y==20) begin	plot <= 1'b1;	end
		else if(x==52 && y==20) begin	plot <= 1'b1;	end
		else if(x==53 && y==20) begin	plot <= 1'b1;	end
		else if(x==54 && y==20) begin	plot <= 1'b1;	end
		else if(x==55 && y==20) begin	plot <= 1'b1;	end
		else if(x==56 && y==20) begin	plot <= 1'b1;	end
		else if(x==13 && y==21) begin	plot <= 1'b1;	end
		else if(x==14 && y==21) begin	plot <= 1'b1;	end
		else if(x==15 && y==21) begin	plot <= 1'b1;	end
		else if(x==16 && y==21) begin	plot <= 1'b1;	end
		else if(x==17 && y==21) begin	plot <= 1'b1;	end
		else if(x==18 && y==21) begin	plot <= 1'b1;	end
		else if(x==19 && y==21) begin	plot <= 1'b1;	end
		else if(x==20 && y==21) begin	plot <= 1'b1;	end
		else if(x==21 && y==21) begin	plot <= 1'b1;	end
		else if(x==22 && y==21) begin	plot <= 1'b1;	end
		else if(x==29 && y==21) begin	plot <= 1'b1;	end
		else if(x==30 && y==21) begin	plot <= 1'b1;	end
		else if(x==31 && y==21) begin	plot <= 1'b1;	end
		else if(x==32 && y==21) begin	plot <= 1'b1;	end
		else if(x==36 && y==21) begin	plot <= 1'b1;	end
		else if(x==37 && y==21) begin	plot <= 1'b1;	end
		else if(x==44 && y==21) begin	plot <= 1'b1;	end
		else if(x==45 && y==21) begin	plot <= 1'b1;	end
		else if(x==46 && y==21) begin	plot <= 1'b1;	end
		else if(x==47 && y==21) begin	plot <= 1'b1;	end
		else if(x==48 && y==21) begin	plot <= 1'b1;	end
		else if(x==49 && y==21) begin	plot <= 1'b1;	end
		else if(x==53 && y==21) begin	plot <= 1'b1;	end
		else if(x==54 && y==21) begin	plot <= 1'b1;	end
		else if(x==14 && y==22) begin	plot <= 1'b1;	end
		else if(x==15 && y==22) begin	plot <= 1'b1;	end
		else if(x==16 && y==22) begin	plot <= 1'b1;	end
		else if(x==17 && y==22) begin	plot <= 1'b1;	end
		else if(x==18 && y==22) begin	plot <= 1'b1;	end
		else if(x==19 && y==22) begin	plot <= 1'b1;	end
		else if(x==20 && y==22) begin	plot <= 1'b1;	end
		else if(x==21 && y==22) begin	plot <= 1'b1;	end
		else if(x==22 && y==22) begin	plot <= 1'b1;	end
		else if(x==23 && y==22) begin	plot <= 1'b1;	end
		else if(x==30 && y==22) begin	plot <= 1'b1;	end
		else if(x==31 && y==22) begin	plot <= 1'b1;	end
		else if(x==32 && y==22) begin	plot <= 1'b1;	end
		else if(x==43 && y==22) begin	plot <= 1'b1;	end
		else if(x==44 && y==22) begin	plot <= 1'b1;	end
		else if(x==45 && y==22) begin	plot <= 1'b1;	end
		else if(x==46 && y==22) begin	plot <= 1'b1;	end
		else if(x==47 && y==22) begin	plot <= 1'b1;	end
		else if(x==48 && y==22) begin	plot <= 1'b1;	end
		else if(x==20 && y==23) begin	plot <= 1'b1;	end
		else if(x==21 && y==23) begin	plot <= 1'b1;	end
		else if(x==22 && y==23) begin	plot <= 1'b1;	end
		else if(x==23 && y==23) begin	plot <= 1'b1;	end
		else if(x==32 && y==23) begin	plot <= 1'b1;	end
		else if(x==42 && y==23) begin	plot <= 1'b1;	end
		else if(x==43 && y==23) begin	plot <= 1'b1;	end
		else if(x==44 && y==23) begin	plot <= 1'b1;	end
		else if(x==45 && y==23) begin	plot <= 1'b1;	end
		else if(x==46 && y==23) begin	plot <= 1'b1;	end
		else if(x==24 && y==24) begin	plot <= 1'b1;	end
		else if(x==25 && y==24) begin	plot <= 1'b1;	end
		else if(x==26 && y==24) begin	plot <= 1'b1;	end
		else if(x==39 && y==24) begin	plot <= 1'b1;	end
		else if(x==40 && y==24) begin	plot <= 1'b1;	end
		else if(x==41 && y==24) begin	plot <= 1'b1;	end
		else if(x==42 && y==24) begin	plot <= 1'b1;	end
		else if(x==43 && y==24) begin	plot <= 1'b1;	end
		else if(x==25 && y==25) begin	plot <= 1'b1;	end
		else if(x==26 && y==25) begin	plot <= 1'b1;	end
		else if(x==27 && y==25) begin	plot <= 1'b1;	end
		else if(x==28 && y==25) begin	plot <= 1'b1;	end
		else if(x==29 && y==25) begin	plot <= 1'b1;	end
		else if(x==30 && y==25) begin	plot <= 1'b1;	end
		else if(x==31 && y==25) begin	plot <= 1'b1;	end
		else if(x==37 && y==25) begin	plot <= 1'b1;	end
		else if(x==38 && y==25) begin	plot <= 1'b1;	end
		else if(x==39 && y==25) begin	plot <= 1'b1;	end
		else if(x==40 && y==25) begin	plot <= 1'b1;	end
		else if(x==41 && y==25) begin	plot <= 1'b1;	end
		else if(x==42 && y==25) begin	plot <= 1'b1;	end
		else if(x==26 && y==26) begin	plot <= 1'b1;	end
		else if(x==27 && y==26) begin	plot <= 1'b1;	end
		else if(x==28 && y==26) begin	plot <= 1'b1;	end
		else if(x==29 && y==26) begin	plot <= 1'b1;	end
		else if(x==30 && y==26) begin	plot <= 1'b1;	end
		else if(x==31 && y==26) begin	plot <= 1'b1;	end
		else if(x==32 && y==26) begin	plot <= 1'b1;	end
		else if(x==36 && y==26) begin	plot <= 1'b1;	end
		else if(x==37 && y==26) begin	plot <= 1'b1;	end
		else if(x==38 && y==26) begin	plot <= 1'b1;	end
		else if(x==39 && y==26) begin	plot <= 1'b1;	end
		else if(x==40 && y==26) begin	plot <= 1'b1;	end
		else if(x==41 && y==26) begin	plot <= 1'b1;	end
		else if(x==27 && y==27) begin	plot <= 1'b1;	end
		else if(x==28 && y==27) begin	plot <= 1'b1;	end
		else if(x==29 && y==27) begin	plot <= 1'b1;	end
		else if(x==30 && y==27) begin	plot <= 1'b1;	end
		else if(x==31 && y==27) begin	plot <= 1'b1;	end
		else if(x==38 && y==27) begin	plot <= 1'b1;	end
		else if(x==39 && y==27) begin	plot <= 1'b1;	end
		else if(x==40 && y==27) begin	plot <= 1'b1;	end
		else if(x==28 && y==28) begin	plot <= 1'b1;	end
		else if(x==29 && y==28) begin	plot <= 1'b1;	end
		else if(x==30 && y==28) begin	plot <= 1'b1;	end
		else if(x==31 && y==28) begin	plot <= 1'b1;	end
		else if(x==38 && y==28) begin	plot <= 1'b1;	end
		else if(x==39 && y==28) begin	plot <= 1'b1;	end
		else if(x==40 && y==28) begin	plot <= 1'b1;	end
		else if(x==29 && y==29) begin	plot <= 1'b1;	end
		else if(x==30 && y==29) begin	plot <= 1'b1;	end
		else if(x==31 && y==29) begin	plot <= 1'b1;	end
		else if(x==38 && y==29) begin	plot <= 1'b1;	end
		else if(x==39 && y==29) begin	plot <= 1'b1;	end
		else if(x==40 && y==29) begin	plot <= 1'b1;	end
		else if(x==30 && y==30) begin	plot <= 1'b1;	end
		else if(x==31 && y==30) begin	plot <= 1'b1;	end
		else if(x==38 && y==30) begin	plot <= 1'b1;	end
		else if(x==39 && y==30) begin	plot <= 1'b1;	end
		else if(x==30 && y==31) begin	plot <= 1'b1;	end
		else if(x==31 && y==31) begin	plot <= 1'b1;	end
		else if(x==32 && y==31) begin	plot <= 1'b1;	end
		else if(x==33 && y==31) begin	plot <= 1'b1;	end
		else if(x==34 && y==31) begin	plot <= 1'b1;	end
		else if(x==35 && y==31) begin	plot <= 1'b1;	end
		else if(x==36 && y==31) begin	plot <= 1'b1;	end
		else if(x==37 && y==31) begin	plot <= 1'b1;	end
		else if(x==38 && y==31) begin	plot <= 1'b1;	end
		else if(x==30 && y==32) begin	plot <= 1'b1;	end
		else if(x==31 && y==32) begin	plot <= 1'b1;	end
		else if(x==32 && y==32) begin	plot <= 1'b1;	end
		else if(x==33 && y==32) begin	plot <= 1'b1;	end
		else if(x==34 && y==32) begin	plot <= 1'b1;	end
		else if(x==35 && y==32) begin	plot <= 1'b1;	end
		else if(x==36 && y==32) begin	plot <= 1'b1;	end
		else if(x==37 && y==32) begin	plot <= 1'b1;	end
		else if(x==38 && y==32) begin	plot <= 1'b1;	end
		else if(x==32 && y==33) begin	plot <= 1'b1;	end
		else if(x==33 && y==33) begin	plot <= 1'b1;	end
		else if(x==34 && y==33) begin	plot <= 1'b1;	end
		else if(x==35 && y==33) begin	plot <= 1'b1;	end
		else if(x==32 && y==34) begin	plot <= 1'b1;	end
		else if(x==33 && y==34) begin	plot <= 1'b1;	end
		else if(x==34 && y==34) begin	plot <= 1'b1;	end
		else if(x==35 && y==34) begin	plot <= 1'b1;	end
		else if(x==33 && y==35) begin	plot <= 1'b1;	end
		else if(x==34 && y==35) begin	plot <= 1'b1;	end
		else if(x==35 && y==35) begin	plot <= 1'b1;	end
		else if(x==33 && y==36) begin	plot <= 1'b1;	end
		else if(x==34 && y==36) begin	plot <= 1'b1;	end
		else if(x==33 && y==37) begin	plot <= 1'b1;	end
		else if(x==34 && y==37) begin	plot <= 1'b1;	end
		else if(x==33 && y==38) begin	plot <= 1'b1;	end
		else if(x==34 && y==38) begin	plot <= 1'b1;	end
		else if(x==33 && y==39) begin	plot <= 1'b1;	end
		else if(x==34 && y==39) begin	plot <= 1'b1;	end
		else begin plot <= 1'b0; end// Width: 68, Height: 45
	end
endmodule


// rate divider for "turn" (used to determine aircraft movements)
module RateDividerForTurn (clock, q, Clear_b, restart);
    input [0:0] clock;
    input [0:0] Clear_b;
	input [26:0] restart;
    output reg [26:0] q;

    always@(posedge clock)   // triggered every time clock rises
    begin
        if (q == restart)
            begin
				q <= 0; // q reset to 0
				end
			else if (Clear_b == 1'b0)
				begin
				q <= 0;
				end
        else if (clock == 1'b1) 
			begin
            q <= q + 1'b1;  // increment q
			end
    end
endmodule

// counter for "stay"
module StayCounter (clock, stay, Clear_b, duration, E);
    input clock;
    input Clear_b;
	 input [31:0] duration;
	 input E;
	 output reg [31:0] stay; //29b = 1073741824
	 

    always@(posedge clock)
    begin
			if (Clear_b == 1'b0)
				stay <= 1'b0;
        if (stay == duration)
            stay <= stay; // keep the value so aircrafts won't disappear
        else if (clock == 1'b1 && E) 
				stay <= stay + 1'b1;
    end
endmodule

// module for erasing the whole screen (plot black for all x, y)
module erase_all(clock, drawEn, x_out, y_out, col_out);
	input drawEn, clock;
	output [8:0] x_out;
	output [7:0] y_out;
	output [2:0] col_out;
	reg [6:0] x;
	reg [6:0] y;
	reg [16:0] counter;
	assign col_out = 3'b000;
	always @(posedge clock)
	begin
	// 
		if (!drawEn)
			counter <= 17'b000000000000;
		else if (drawEn)
		begin
		// 
			if (counter == 17'b11111111111111111)
				counter <= 17'b000000000000;
			else
			// update the counter
				counter <= counter + 1'b1;
		end
	end

	assign x_out = x + counter[8:0];
	assign y_out = y + counter[16:9];
endmodule


// module for "resetting" the background while plotting the word PAUSE
module reset_background(clock, drawEn, x_out, y_out, col_out);
	input drawEn, clock;
	output [8:0] x_out;
	output [7:0] y_out;
	output [2:0] col_out;
	reg [6:0] x;
	reg [6:0] y;
	wire p;
	// 
	reg [16:0] counter;
	assign col_out = p ? 3'b001 : 3'b000;
	PAUSE(clock, 9'b010001011, 8'b10000000, x + counter[8:0], y + counter[16:9], p);
	always @(posedge clock)
	begin
	// 
		if (!drawEn)
			counter <= 17'b000000000000;
		else if (drawEn)
		begin
		// 
			if (counter == 17'b11111111111111111)
				counter <= 17'b000000000000;
			else
			// update the counter
				counter <= counter + 1'b1;
		end
	end

	assign x_out = x + counter[8:0];
	assign y_out = y + counter[16:9];
endmodule


// module for cleaning the word PAUSE (plot the same word in black)
module reset_background_after(clock, drawEn, x_out, y_out, col_out, res);
	input drawEn, clock;
	output [8:0] x_out;
	output [7:0] y_out;
	output [2:0] col_out;
	output res;
	reg [6:0] x;
	reg [6:0] y;
	wire p;
	// 
	reg [16:0] counter;
	assign col_out = 3'b000;
	assign res = p ? 1 : 0;
	PAUSE(clock, 9'b010001011, 8'b10000000, x + counter[8:0], y + counter[16:9], p);
	always @(posedge clock)
	begin
	// 
		if (!drawEn)
			counter <= 17'b000000000000;
		else if (drawEn)
		begin
		// 
			if (counter == 17'b11111111111111111)
				counter <= 17'b000000000000;
			else
			// update the counter
				counter <= counter + 1'b1;
		end
	end

	assign x_out = x + counter[8:0];
	assign y_out = y + counter[16:9];
endmodule


// module for drawing the start screen
module startss(clock, drawEn, x_out, y_out, col_out);
	input drawEn, clock;
	output [8:0] x_out;
	output [7:0] y_out;
	output [2:0] col_out;
	reg [6:0] x;
	reg [6:0] y;
	wire p;
	// 
	reg [16:0] counter;
	assign col_out = p ? 3'b100 : 3'b000;
	sss(clock, 9'b010010111, 8'b10000000, x + counter[8:0], y + counter[16:9], p);
	always @(posedge clock)
	begin
	// 
		if (!drawEn)
			counter <= 17'b000000000000;
		else if (drawEn)
		begin
		// 
			if (counter == 17'b11111111111111111)
				counter <= 17'b000000000000;
			else
			// update the counter
				counter <= counter + 1'b1;
		end
	end

	assign x_out = x + counter[8:0];
	assign y_out = y + counter[16:9];
endmodule


// module for drawing the start screen
module starts_after(clock, drawEn, x_out, y_out, col_out, res);
	input drawEn, clock;
	output [8:0] x_out;
	output [7:0] y_out;
	output [2:0] col_out;
	output res;
	reg [6:0] x;
	reg [6:0] y;
	wire p;
	// 
	reg [16:0] counter;
	assign col_out = 3'b000;
	assign res = p ? 1 : 0;
	sss(clock, 9'b010010111, 8'b10000000, x + counter[8:0], y + counter[16:9], p);
	always @(posedge clock)
	begin
	// 
		if (!drawEn)
			counter <= 17'b000000000000;
		else if (drawEn)
		begin
		// 
			if (counter == 17'b11111111111111111)
				counter <= 17'b000000000000;
			else
			// update the counter
				counter <= counter + 1'b1;
		end
	end

	assign x_out = x + counter[8:0];
	assign y_out = y + counter[16:9];
endmodule


// module for drawing the first explosion
module explo1(clock, drawEn, x_out, y_out, col_out);
	input drawEn, clock;
	output [8:0] x_out;
	output [7:0] y_out;
	output [2:0] col_out;
	reg [6:0] x;
	reg [6:0] y;
	wire p;
	// 
	reg [16:0] counter;
	assign col_out = p ? 3'b110 : 3'b000;
	b111(clock, 9'b010010111, 8'b10000000, x + counter[8:0], y + counter[16:9], p);
	always @(posedge clock)
	begin
	// 
		if (!drawEn)
			counter <= 17'b000000000000;
		else if (drawEn)
		begin
		// 
			if (counter == 17'b11111111111111111)
				counter <= 17'b000000000000;
			else
			// update the counter
				counter <= counter + 1'b1;
		end
	end

	assign x_out = x + counter[8:0];
	assign y_out = y + counter[16:9];
endmodule


// module for drawing the first explosion
module explo1_after(clock, drawEn, x_out, y_out, col_out, res);
	input drawEn, clock;
	output [8:0] x_out;
	output [7:0] y_out;
	output [2:0] col_out;
	output res;
	reg [6:0] x;
	reg [6:0] y;
	wire p;
	// 
	reg [16:0] counter;
	assign col_out = 3'b000;
	assign res = p ? 1 : 0;
	b111(clock, 9'b010010111, 8'b10000000, x + counter[8:0], y + counter[16:9], p);
	always @(posedge clock)
	begin
	// 
		if (!drawEn)
			counter <= 17'b000000000000;
		else if (drawEn)
		begin
		// 
			if (counter == 17'b11111111111111111)
				counter <= 17'b000000000000;
			else
			// update the counter
				counter <= counter + 1'b1;
		end
	end

	assign x_out = x + counter[8:0];
	assign y_out = y + counter[16:9];
endmodule

// module for drawing the second explosion
module explo2(clock, drawEn, x_out, y_out, col_out);
	input drawEn, clock;
	output [8:0] x_out;
	output [7:0] y_out;
	output [2:0] col_out;
	reg [6:0] x;
	reg [6:0] y;
	wire p;
	// 
	reg [16:0] counter;
	assign col_out = p ? 3'b110 : 3'b000;
	b222(clock, 9'b010010111, 8'b10000000, x + counter[8:0], y + counter[16:9], p);
	always @(posedge clock)
	begin
	// 
		if (!drawEn)
			counter <= 17'b000000000000;
		else if (drawEn)
		begin
		// 
			if (counter == 17'b11111111111111111)
				counter <= 17'b000000000000;
			else
			// update the counter
				counter <= counter + 1'b1;
		end
	end

	assign x_out = x + counter[8:0];
	assign y_out = y + counter[16:9];
endmodule


// module for drawing the second explosion
module explo2_after(clock, drawEn, x_out, y_out, col_out, res);
	input drawEn, clock;
	output [8:0] x_out;
	output [7:0] y_out;
	output [2:0] col_out;
	output res;
	reg [6:0] x;
	reg [6:0] y;
	wire p;
	// 
	reg [16:0] counter;
	assign col_out = 3'b000;
	assign res = p ? 1 : 0;
	b222(clock, 9'b010010111, 8'b10000000, x + counter[8:0], y + counter[16:9], p);
	always @(posedge clock)
	begin
	// 
		if (!drawEn)
			counter <= 17'b000000000000;
		else if (drawEn)
		begin
		// 
			if (counter == 17'b11111111111111111)
				counter <= 17'b000000000000;
			else
			// update the counter
				counter <= counter + 1'b1;
		end
	end

	assign x_out = x + counter[8:0];
	assign y_out = y + counter[16:9];
endmodule

// module for drawing the third explosion
module explo3(clock, drawEn, x_out, y_out, col_out);
	input drawEn, clock;
	output [8:0] x_out;
	output [7:0] y_out;
	output [2:0] col_out;
	reg [6:0] x;
	reg [6:0] y;
	wire p;
	// 
	reg [16:0] counter;
	assign col_out = p ? 3'b110 : 3'b000;
	b333(clock, 9'b010010111, 8'b10000000, x + counter[8:0], y + counter[16:9], p);
	always @(posedge clock)
	begin
	// 
		if (!drawEn)
			counter <= 17'b000000000000;
		else if (drawEn)
		begin
		// 
			if (counter == 17'b11111111111111111)
				counter <= 17'b000000000000;
			else
			// update the counter
				counter <= counter + 1'b1;
		end
	end

	assign x_out = x + counter[8:0];
	assign y_out = y + counter[16:9];
endmodule


// module for cleaning the third explosion
module explo3_after(clock, drawEn, x_out, y_out, col_out, res);
	input drawEn, clock;
	output [8:0] x_out;
	output [7:0] y_out;
	output [2:0] col_out;
	output res;
	reg [6:0] x;
	reg [6:0] y;
	wire p;
	// 
	reg [16:0] counter;
	assign col_out = 3'b000;
	assign res = p ? 1 : 0;
	b333(clock, 9'b010010111, 8'b10000000, x + counter[8:0], y + counter[16:9], p);
	always @(posedge clock)
	begin
	// 
		if (!drawEn)
			counter <= 17'b000000000000;
		else if (drawEn)
		begin
		// 
			if (counter == 17'b11111111111111111)
				counter <= 17'b000000000000;
			else
			// update the counter
				counter <= counter + 1'b1;
		end
	end

	assign x_out = x + counter[8:0];
	assign y_out = y + counter[16:9];
endmodule

// module for drawing the winning screen (end screen)
module winn(clock, drawEn, x_out, y_out, col_out);
	input drawEn, clock;
	output [8:0] x_out;
	output [7:0] y_out;
	output [2:0] col_out;
	reg [6:0] x;
	reg [6:0] y;
	wire p;
	// 
	reg [16:0] counter;
	assign col_out = p ? 3'b101 : 3'b000;
	ywinn(clock, 9'b010010111, 8'b10000000, x + counter[8:0], y + counter[16:9], p);
	always @(posedge clock)
	begin
	// 
		if (!drawEn)
			counter <= 17'b000000000000;
		else if (drawEn)
		begin
		// 
			if (counter == 17'b11111111111111111)
				counter <= 17'b000000000000;
			else
			// update the counter
				counter <= counter + 1'b1;
		end
	end

	assign x_out = x + counter[8:0];
	assign y_out = y + counter[16:9];
endmodule


// module for plotting the missile
module PlotMissile(
	input clk,
	input wire [9:0] characterPositionX,
	input wire [8:0] characterPositionY,
	input wire [9:0] drawingPositionX,
	input wire [8:0] drawingPositionY,
	output reg [2:0] plot
);
	reg [9:0] x;
	reg [9:0] y;
	initial begin
		x = 'd0;
		y = 'd0;
	end

	always @(posedge clk) begin
		x <= (drawingPositionX - characterPositionX + 11);
		y <= (drawingPositionY - characterPositionY + 30);
		if(x==9 && y==2) begin	plot <= 1'b1;	end
		else if(x==10 && y==2) begin	plot <= 1'b1;	end
		else if(x==8 && y==3) begin	plot <= 1'b1;	end
		else if(x==9 && y==3) begin	plot <= 1'b1;	end
		else if(x==10 && y==3) begin	plot <= 1'b1;	end
		else if(x==11 && y==3) begin	plot <= 1'b1;	end
		else if(x==8 && y==4) begin	plot <= 1'b1;	end
		else if(x==9 && y==4) begin	plot <= 1'b1;	end
		else if(x==10 && y==4) begin	plot <= 1'b1;	end
		else if(x==11 && y==4) begin	plot <= 1'b1;	end
		else if(x==7 && y==5) begin	plot <= 1'b1;	end
		else if(x==8 && y==5) begin	plot <= 1'b1;	end
		else if(x==9 && y==5) begin	plot <= 1'b1;	end
		else if(x==10 && y==5) begin	plot <= 1'b1;	end
		else if(x==11 && y==5) begin	plot <= 1'b1;	end
		else if(x==12 && y==5) begin	plot <= 1'b1;	end
		else if(x==7 && y==6) begin	plot <= 1'b1;	end
		else if(x==8 && y==6) begin	plot <= 1'b1;	end
		else if(x==9 && y==6) begin	plot <= 1'b1;	end
		else if(x==10 && y==6) begin	plot <= 1'b1;	end
		else if(x==11 && y==6) begin	plot <= 1'b1;	end
		else if(x==12 && y==6) begin	plot <= 1'b1;	end
		else if(x==6 && y==7) begin	plot <= 1'b1;	end
		else if(x==7 && y==7) begin	plot <= 1'b1;	end
		else if(x==8 && y==7) begin	plot <= 1'b1;	end
		else if(x==9 && y==7) begin	plot <= 1'b1;	end
		else if(x==10 && y==7) begin	plot <= 1'b1;	end
		else if(x==11 && y==7) begin	plot <= 1'b1;	end
		else if(x==12 && y==7) begin	plot <= 1'b1;	end
		else if(x==13 && y==7) begin	plot <= 1'b1;	end
		else if(x==6 && y==8) begin	plot <= 1'b1;	end
		else if(x==7 && y==8) begin	plot <= 1'b1;	end
		else if(x==8 && y==8) begin	plot <= 1'b1;	end
		else if(x==9 && y==8) begin	plot <= 1'b1;	end
		else if(x==10 && y==8) begin	plot <= 1'b1;	end
		else if(x==11 && y==8) begin	plot <= 1'b1;	end
		else if(x==12 && y==8) begin	plot <= 1'b1;	end
		else if(x==13 && y==8) begin	plot <= 1'b1;	end
		else if(x==5 && y==9) begin	plot <= 1'b1;	end
		else if(x==6 && y==9) begin	plot <= 1'b1;	end
		else if(x==7 && y==9) begin	plot <= 1'b1;	end
		else if(x==8 && y==9) begin	plot <= 1'b1;	end
		else if(x==9 && y==9) begin	plot <= 1'b1;	end
		else if(x==10 && y==9) begin	plot <= 1'b1;	end
		else if(x==11 && y==9) begin	plot <= 1'b1;	end
		else if(x==12 && y==9) begin	plot <= 1'b1;	end
		else if(x==13 && y==9) begin	plot <= 1'b1;	end
		else if(x==14 && y==9) begin	plot <= 1'b1;	end
		else if(x==5 && y==10) begin	plot <= 1'b1;	end
		else if(x==6 && y==10) begin	plot <= 1'b1;	end
		else if(x==7 && y==10) begin	plot <= 1'b1;	end
		else if(x==8 && y==10) begin	plot <= 1'b1;	end
		else if(x==9 && y==10) begin	plot <= 1'b1;	end
		else if(x==10 && y==10) begin	plot <= 1'b1;	end
		else if(x==11 && y==10) begin	plot <= 1'b1;	end
		else if(x==12 && y==10) begin	plot <= 1'b1;	end
		else if(x==13 && y==10) begin	plot <= 1'b1;	end
		else if(x==14 && y==10) begin	plot <= 1'b1;	end
		else if(x==5 && y==11) begin	plot <= 1'b1;	end
		else if(x==6 && y==11) begin	plot <= 1'b1;	end
		else if(x==7 && y==11) begin	plot <= 1'b1;	end
		else if(x==8 && y==11) begin	plot <= 1'b1;	end
		else if(x==9 && y==11) begin	plot <= 1'b1;	end
		else if(x==10 && y==11) begin	plot <= 1'b1;	end
		else if(x==11 && y==11) begin	plot <= 1'b1;	end
		else if(x==12 && y==11) begin	plot <= 1'b1;	end
		else if(x==13 && y==11) begin	plot <= 1'b1;	end
		else if(x==14 && y==11) begin	plot <= 1'b1;	end
		else if(x==5 && y==12) begin	plot <= 1'b1;	end
		else if(x==6 && y==12) begin	plot <= 1'b1;	end
		else if(x==7 && y==12) begin	plot <= 1'b1;	end
		else if(x==8 && y==12) begin	plot <= 1'b1;	end
		else if(x==9 && y==12) begin	plot <= 1'b1;	end
		else if(x==10 && y==12) begin	plot <= 1'b1;	end
		else if(x==11 && y==12) begin	plot <= 1'b1;	end
		else if(x==12 && y==12) begin	plot <= 1'b1;	end
		else if(x==13 && y==12) begin	plot <= 1'b1;	end
		else if(x==14 && y==12) begin	plot <= 1'b1;	end
		else if(x==5 && y==13) begin	plot <= 1'b1;	end
		else if(x==6 && y==13) begin	plot <= 1'b1;	end
		else if(x==7 && y==13) begin	plot <= 1'b1;	end
		else if(x==8 && y==13) begin	plot <= 1'b1;	end
		else if(x==9 && y==13) begin	plot <= 1'b1;	end
		else if(x==10 && y==13) begin	plot <= 1'b1;	end
		else if(x==11 && y==13) begin	plot <= 1'b1;	end
		else if(x==12 && y==13) begin	plot <= 1'b1;	end
		else if(x==13 && y==13) begin	plot <= 1'b1;	end
		else if(x==14 && y==13) begin	plot <= 1'b1;	end
		else if(x==5 && y==14) begin	plot <= 1'b1;	end
		else if(x==6 && y==14) begin	plot <= 1'b1;	end
		else if(x==7 && y==14) begin	plot <= 1'b1;	end
		else if(x==8 && y==14) begin	plot <= 1'b1;	end
		else if(x==9 && y==14) begin	plot <= 1'b1;	end
		else if(x==10 && y==14) begin	plot <= 1'b1;	end
		else if(x==11 && y==14) begin	plot <= 1'b1;	end
		else if(x==12 && y==14) begin	plot <= 1'b1;	end
		else if(x==13 && y==14) begin	plot <= 1'b1;	end
		else if(x==14 && y==14) begin	plot <= 1'b1;	end
		else if(x==5 && y==15) begin	plot <= 1'b1;	end
		else if(x==6 && y==15) begin	plot <= 1'b1;	end
		else if(x==12 && y==15) begin	plot <= 1'b1;	end
		else if(x==13 && y==15) begin	plot <= 1'b1;	end
		else if(x==14 && y==15) begin	plot <= 1'b1;	end
		else if(x==5 && y==16) begin	plot <= 1'b1;	end
		else if(x==6 && y==16) begin	plot <= 1'b1;	end
		else if(x==9 && y==16) begin	plot <= 1'b1;	end
		else if(x==10 && y==16) begin	plot <= 1'b1;	end
		else if(x==13 && y==16) begin	plot <= 1'b1;	end
		else if(x==14 && y==16) begin	plot <= 1'b1;	end
		else if(x==5 && y==17) begin	plot <= 1'b1;	end
		else if(x==6 && y==17) begin	plot <= 1'b1;	end
		else if(x==9 && y==17) begin	plot <= 1'b1;	end
		else if(x==10 && y==17) begin	plot <= 1'b1;	end
		else if(x==11 && y==17) begin	plot <= 1'b1;	end
		else if(x==13 && y==17) begin	plot <= 1'b1;	end
		else if(x==14 && y==17) begin	plot <= 1'b1;	end
		else if(x==4 && y==18) begin	plot <= 1'b1;	end
		else if(x==5 && y==18) begin	plot <= 1'b1;	end
		else if(x==6 && y==18) begin	plot <= 1'b1;	end
		else if(x==13 && y==18) begin	plot <= 1'b1;	end
		else if(x==14 && y==18) begin	plot <= 1'b1;	end
		else if(x==15 && y==18) begin	plot <= 1'b1;	end
		else if(x==3 && y==19) begin	plot <= 1'b1;	end
		else if(x==4 && y==19) begin	plot <= 1'b1;	end
		else if(x==5 && y==19) begin	plot <= 1'b1;	end
		else if(x==6 && y==19) begin	plot <= 1'b1;	end
		else if(x==9 && y==19) begin	plot <= 1'b1;	end
		else if(x==10 && y==19) begin	plot <= 1'b1;	end
		else if(x==11 && y==19) begin	plot <= 1'b1;	end
		else if(x==13 && y==19) begin	plot <= 1'b1;	end
		else if(x==14 && y==19) begin	plot <= 1'b1;	end
		else if(x==15 && y==19) begin	plot <= 1'b1;	end
		else if(x==16 && y==19) begin	plot <= 1'b1;	end
		else if(x==2 && y==20) begin	plot <= 1'b1;	end
		else if(x==3 && y==20) begin	plot <= 1'b1;	end
		else if(x==4 && y==20) begin	plot <= 1'b1;	end
		else if(x==5 && y==20) begin	plot <= 1'b1;	end
		else if(x==6 && y==20) begin	plot <= 1'b1;	end
		else if(x==9 && y==20) begin	plot <= 1'b1;	end
		else if(x==10 && y==20) begin	plot <= 1'b1;	end
		else if(x==13 && y==20) begin	plot <= 1'b1;	end
		else if(x==14 && y==20) begin	plot <= 1'b1;	end
		else if(x==15 && y==20) begin	plot <= 1'b1;	end
		else if(x==16 && y==20) begin	plot <= 1'b1;	end
		else if(x==17 && y==20) begin	plot <= 1'b1;	end
		else if(x==1 && y==21) begin	plot <= 1'b1;	end
		else if(x==2 && y==21) begin	plot <= 1'b1;	end
		else if(x==3 && y==21) begin	plot <= 1'b1;	end
		else if(x==4 && y==21) begin	plot <= 1'b1;	end
		else if(x==5 && y==21) begin	plot <= 1'b1;	end
		else if(x==6 && y==21) begin	plot <= 1'b1;	end
		else if(x==12 && y==21) begin	plot <= 1'b1;	end
		else if(x==13 && y==21) begin	plot <= 1'b1;	end
		else if(x==14 && y==21) begin	plot <= 1'b1;	end
		else if(x==15 && y==21) begin	plot <= 1'b1;	end
		else if(x==16 && y==21) begin	plot <= 1'b1;	end
		else if(x==17 && y==21) begin	plot <= 1'b1;	end
		else if(x==18 && y==21) begin	plot <= 1'b1;	end
		else if(x==1 && y==22) begin	plot <= 1'b1;	end
		else if(x==2 && y==22) begin	plot <= 1'b1;	end
		else if(x==3 && y==22) begin	plot <= 1'b1;	end
		else if(x==4 && y==22) begin	plot <= 1'b1;	end
		else if(x==5 && y==22) begin	plot <= 1'b1;	end
		else if(x==6 && y==22) begin	plot <= 1'b1;	end
		else if(x==7 && y==22) begin	plot <= 1'b1;	end
		else if(x==8 && y==22) begin	plot <= 1'b1;	end
		else if(x==9 && y==22) begin	plot <= 1'b1;	end
		else if(x==10 && y==22) begin	plot <= 1'b1;	end
		else if(x==11 && y==22) begin	plot <= 1'b1;	end
		else if(x==12 && y==22) begin	plot <= 1'b1;	end
		else if(x==13 && y==22) begin	plot <= 1'b1;	end
		else if(x==14 && y==22) begin	plot <= 1'b1;	end
		else if(x==15 && y==22) begin	plot <= 1'b1;	end
		else if(x==16 && y==22) begin	plot <= 1'b1;	end
		else if(x==17 && y==22) begin	plot <= 1'b1;	end
		else if(x==18 && y==22) begin	plot <= 1'b1;	end
		else if(x==1 && y==23) begin	plot <= 1'b1;	end
		else if(x==2 && y==23) begin	plot <= 1'b1;	end
		else if(x==3 && y==23) begin	plot <= 1'b1;	end
		else if(x==4 && y==23) begin	plot <= 1'b1;	end
		else if(x==5 && y==23) begin	plot <= 1'b1;	end
		else if(x==6 && y==23) begin	plot <= 1'b1;	end
		else if(x==7 && y==23) begin	plot <= 1'b1;	end
		else if(x==8 && y==23) begin	plot <= 1'b1;	end
		else if(x==9 && y==23) begin	plot <= 1'b1;	end
		else if(x==10 && y==23) begin	plot <= 1'b1;	end
		else if(x==11 && y==23) begin	plot <= 1'b1;	end
		else if(x==12 && y==23) begin	plot <= 1'b1;	end
		else if(x==13 && y==23) begin	plot <= 1'b1;	end
		else if(x==14 && y==23) begin	plot <= 1'b1;	end
		else if(x==15 && y==23) begin	plot <= 1'b1;	end
		else if(x==16 && y==23) begin	plot <= 1'b1;	end
		else if(x==17 && y==23) begin	plot <= 1'b1;	end
		else if(x==18 && y==23) begin	plot <= 1'b1;	end
		else if(x==1 && y==24) begin	plot <= 1'b1;	end
		else if(x==2 && y==24) begin	plot <= 1'b1;	end
		else if(x==3 && y==24) begin	plot <= 1'b1;	end
		else if(x==4 && y==24) begin	plot <= 1'b1;	end
		else if(x==5 && y==24) begin	plot <= 1'b1;	end
		else if(x==6 && y==24) begin	plot <= 1'b1;	end
		else if(x==7 && y==24) begin	plot <= 1'b1;	end
		else if(x==8 && y==24) begin	plot <= 1'b1;	end
		else if(x==9 && y==24) begin	plot <= 1'b1;	end
		else if(x==10 && y==24) begin	plot <= 1'b1;	end
		else if(x==11 && y==24) begin	plot <= 1'b1;	end
		else if(x==12 && y==24) begin	plot <= 1'b1;	end
		else if(x==13 && y==24) begin	plot <= 1'b1;	end
		else if(x==14 && y==24) begin	plot <= 1'b1;	end
		else if(x==15 && y==24) begin	plot <= 1'b1;	end
		else if(x==16 && y==24) begin	plot <= 1'b1;	end
		else if(x==17 && y==24) begin	plot <= 1'b1;	end
		else if(x==18 && y==24) begin	plot <= 1'b1;	end
		else if(x==1 && y==25) begin	plot <= 1'b1;	end
		else if(x==2 && y==25) begin	plot <= 1'b1;	end
		else if(x==3 && y==25) begin	plot <= 1'b1;	end
		else if(x==4 && y==25) begin	plot <= 1'b1;	end
		else if(x==5 && y==25) begin	plot <= 1'b1;	end
		else if(x==6 && y==25) begin	plot <= 1'b1;	end
		else if(x==13 && y==25) begin	plot <= 1'b1;	end
		else if(x==14 && y==25) begin	plot <= 1'b1;	end
		else if(x==15 && y==25) begin	plot <= 1'b1;	end
		else if(x==16 && y==25) begin	plot <= 1'b1;	end
		else if(x==17 && y==25) begin	plot <= 1'b1;	end
		else if(x==18 && y==25) begin	plot <= 1'b1;	end
		else if(x==1 && y==26) begin	plot <= 1'b1;	end
		else if(x==2 && y==26) begin	plot <= 1'b1;	end
		else if(x==3 && y==26) begin	plot <= 1'b1;	end
		else if(x==4 && y==26) begin	plot <= 1'b1;	end
		else if(x==5 && y==26) begin	plot <= 1'b1;	end
		else if(x==6 && y==26) begin	plot <= 1'b1;	end
		else if(x==9 && y==26) begin	plot <= 1'b1;	end
		else if(x==10 && y==26) begin	plot <= 1'b1;	end
		else if(x==11 && y==26) begin	plot <= 1'b1;	end
		else if(x==12 && y==26) begin	plot <= 1'b1;	end
		else if(x==13 && y==26) begin	plot <= 1'b1;	end
		else if(x==14 && y==26) begin	plot <= 1'b1;	end
		else if(x==15 && y==26) begin	plot <= 1'b1;	end
		else if(x==16 && y==26) begin	plot <= 1'b1;	end
		else if(x==17 && y==26) begin	plot <= 1'b1;	end
		else if(x==18 && y==26) begin	plot <= 1'b1;	end
		else if(x==1 && y==27) begin	plot <= 1'b1;	end
		else if(x==2 && y==27) begin	plot <= 1'b1;	end
		else if(x==3 && y==27) begin	plot <= 1'b1;	end
		else if(x==5 && y==27) begin	plot <= 1'b1;	end
		else if(x==6 && y==27) begin	plot <= 1'b1;	end
		else if(x==9 && y==27) begin	plot <= 1'b1;	end
		else if(x==10 && y==27) begin	plot <= 1'b1;	end
		else if(x==11 && y==27) begin	plot <= 1'b1;	end
		else if(x==12 && y==27) begin	plot <= 1'b1;	end
		else if(x==13 && y==27) begin	plot <= 1'b1;	end
		else if(x==14 && y==27) begin	plot <= 1'b1;	end
		else if(x==16 && y==27) begin	plot <= 1'b1;	end
		else if(x==17 && y==27) begin	plot <= 1'b1;	end
		else if(x==18 && y==27) begin	plot <= 1'b1;	end
		else if(x==2 && y==28) begin	plot <= 1'b1;	end
		else if(x==5 && y==28) begin	plot <= 1'b1;	end
		else if(x==6 && y==28) begin	plot <= 1'b1;	end
		else if(x==12 && y==28) begin	plot <= 1'b1;	end
		else if(x==13 && y==28) begin	plot <= 1'b1;	end
		else if(x==14 && y==28) begin	plot <= 1'b1;	end
		else if(x==17 && y==28) begin	plot <= 1'b1;	end
		else if(x==5 && y==29) begin	plot <= 1'b1;	end
		else if(x==6 && y==29) begin	plot <= 1'b1;	end
		else if(x==7 && y==29) begin	plot <= 1'b1;	end
		else if(x==8 && y==29) begin	plot <= 1'b1;	end
		else if(x==9 && y==29) begin	plot <= 1'b1;	end
		else if(x==10 && y==29) begin	plot <= 1'b1;	end
		else if(x==13 && y==29) begin	plot <= 1'b1;	end
		else if(x==14 && y==29) begin	plot <= 1'b1;	end
		else if(x==5 && y==30) begin	plot <= 1'b1;	end
		else if(x==6 && y==30) begin	plot <= 1'b1;	end
		else if(x==7 && y==30) begin	plot <= 1'b1;	end
		else if(x==8 && y==30) begin	plot <= 1'b1;	end
		else if(x==9 && y==30) begin	plot <= 1'b1;	end
		else if(x==10 && y==30) begin	plot <= 1'b1;	end
		else if(x==13 && y==30) begin	plot <= 1'b1;	end
		else if(x==14 && y==30) begin	plot <= 1'b1;	end
		else if(x==5 && y==31) begin	plot <= 1'b1;	end
		else if(x==6 && y==31) begin	plot <= 1'b1;	end
		else if(x==7 && y==31) begin	plot <= 1'b1;	end
		else if(x==8 && y==31) begin	plot <= 1'b1;	end
		else if(x==9 && y==31) begin	plot <= 1'b1;	end
		else if(x==10 && y==31) begin	plot <= 1'b1;	end
		else if(x==13 && y==31) begin	plot <= 1'b1;	end
		else if(x==14 && y==31) begin	plot <= 1'b1;	end
		else if(x==5 && y==32) begin	plot <= 1'b1;	end
		else if(x==6 && y==32) begin	plot <= 1'b1;	end
		else if(x==12 && y==32) begin	plot <= 1'b1;	end
		else if(x==13 && y==32) begin	plot <= 1'b1;	end
		else if(x==14 && y==32) begin	plot <= 1'b1;	end
		else if(x==5 && y==33) begin	plot <= 1'b1;	end
		else if(x==6 && y==33) begin	plot <= 1'b1;	end
		else if(x==7 && y==33) begin	plot <= 1'b1;	end
		else if(x==8 && y==33) begin	plot <= 1'b1;	end
		else if(x==9 && y==33) begin	plot <= 1'b1;	end
		else if(x==10 && y==33) begin	plot <= 1'b1;	end
		else if(x==11 && y==33) begin	plot <= 1'b1;	end
		else if(x==12 && y==33) begin	plot <= 1'b1;	end
		else if(x==13 && y==33) begin	plot <= 1'b1;	end
		else if(x==14 && y==33) begin	plot <= 1'b1;	end
		else if(x==5 && y==34) begin	plot <= 1'b1;	end
		else if(x==6 && y==34) begin	plot <= 1'b1;	end
		else if(x==7 && y==34) begin	plot <= 1'b1;	end
		else if(x==8 && y==34) begin	plot <= 1'b1;	end
		else if(x==9 && y==34) begin	plot <= 1'b1;	end
		else if(x==10 && y==34) begin	plot <= 1'b1;	end
		else if(x==11 && y==34) begin	plot <= 1'b1;	end
		else if(x==12 && y==34) begin	plot <= 1'b1;	end
		else if(x==13 && y==34) begin	plot <= 1'b1;	end
		else if(x==14 && y==34) begin	plot <= 1'b1;	end
		else if(x==5 && y==35) begin	plot <= 1'b1;	end
		else if(x==6 && y==35) begin	plot <= 1'b1;	end
		else if(x==7 && y==35) begin	plot <= 1'b1;	end
		else if(x==8 && y==35) begin	plot <= 1'b1;	end
		else if(x==12 && y==35) begin	plot <= 1'b1;	end
		else if(x==13 && y==35) begin	plot <= 1'b1;	end
		else if(x==14 && y==35) begin	plot <= 1'b1;	end
		else if(x==5 && y==36) begin	plot <= 1'b1;	end
		else if(x==6 && y==36) begin	plot <= 1'b1;	end
		else if(x==9 && y==36) begin	plot <= 1'b1;	end
		else if(x==10 && y==36) begin	plot <= 1'b1;	end
		else if(x==13 && y==36) begin	plot <= 1'b1;	end
		else if(x==14 && y==36) begin	plot <= 1'b1;	end
		else if(x==5 && y==37) begin	plot <= 1'b1;	end
		else if(x==6 && y==37) begin	plot <= 1'b1;	end
		else if(x==9 && y==37) begin	plot <= 1'b1;	end
		else if(x==10 && y==37) begin	plot <= 1'b1;	end
		else if(x==11 && y==37) begin	plot <= 1'b1;	end
		else if(x==13 && y==37) begin	plot <= 1'b1;	end
		else if(x==14 && y==37) begin	plot <= 1'b1;	end
		else if(x==5 && y==38) begin	plot <= 1'b1;	end
		else if(x==6 && y==38) begin	plot <= 1'b1;	end
		else if(x==7 && y==38) begin	plot <= 1'b1;	end
		else if(x==10 && y==38) begin	plot <= 1'b1;	end
		else if(x==11 && y==38) begin	plot <= 1'b1;	end
		else if(x==13 && y==38) begin	plot <= 1'b1;	end
		else if(x==14 && y==38) begin	plot <= 1'b1;	end
		else if(x==5 && y==39) begin	plot <= 1'b1;	end
		else if(x==6 && y==39) begin	plot <= 1'b1;	end
		else if(x==8 && y==39) begin	plot <= 1'b1;	end
		else if(x==12 && y==39) begin	plot <= 1'b1;	end
		else if(x==13 && y==39) begin	plot <= 1'b1;	end
		else if(x==14 && y==39) begin	plot <= 1'b1;	end
		else if(x==5 && y==40) begin	plot <= 1'b1;	end
		else if(x==6 && y==40) begin	plot <= 1'b1;	end
		else if(x==8 && y==40) begin	plot <= 1'b1;	end
		else if(x==9 && y==40) begin	plot <= 1'b1;	end
		else if(x==13 && y==40) begin	plot <= 1'b1;	end
		else if(x==14 && y==40) begin	plot <= 1'b1;	end
		else if(x==5 && y==41) begin	plot <= 1'b1;	end
		else if(x==6 && y==41) begin	plot <= 1'b1;	end
		else if(x==8 && y==41) begin	plot <= 1'b1;	end
		else if(x==9 && y==41) begin	plot <= 1'b1;	end
		else if(x==10 && y==41) begin	plot <= 1'b1;	end
		else if(x==11 && y==41) begin	plot <= 1'b1;	end
		else if(x==13 && y==41) begin	plot <= 1'b1;	end
		else if(x==14 && y==41) begin	plot <= 1'b1;	end
		else if(x==5 && y==42) begin	plot <= 1'b1;	end
		else if(x==6 && y==42) begin	plot <= 1'b1;	end
		else if(x==7 && y==42) begin	plot <= 1'b1;	end
		else if(x==13 && y==42) begin	plot <= 1'b1;	end
		else if(x==14 && y==42) begin	plot <= 1'b1;	end
		else if(x==5 && y==43) begin	plot <= 1'b1;	end
		else if(x==6 && y==43) begin	plot <= 1'b1;	end
		else if(x==7 && y==43) begin	plot <= 1'b1;	end
		else if(x==8 && y==43) begin	plot <= 1'b1;	end
		else if(x==9 && y==43) begin	plot <= 1'b1;	end
		else if(x==10 && y==43) begin	plot <= 1'b1;	end
		else if(x==11 && y==43) begin	plot <= 1'b1;	end
		else if(x==12 && y==43) begin	plot <= 1'b1;	end
		else if(x==13 && y==43) begin	plot <= 1'b1;	end
		else if(x==14 && y==43) begin	plot <= 1'b1;	end
		else if(x==5 && y==44) begin	plot <= 1'b1;	end
		else if(x==6 && y==44) begin	plot <= 1'b1;	end
		else if(x==7 && y==44) begin	plot <= 1'b1;	end
		else if(x==8 && y==44) begin	plot <= 1'b1;	end
		else if(x==9 && y==44) begin	plot <= 1'b1;	end
		else if(x==10 && y==44) begin	plot <= 1'b1;	end
		else if(x==11 && y==44) begin	plot <= 1'b1;	end
		else if(x==12 && y==44) begin	plot <= 1'b1;	end
		else if(x==13 && y==44) begin	plot <= 1'b1;	end
		else if(x==14 && y==44) begin	plot <= 1'b1;	end
		else if(x==5 && y==45) begin	plot <= 1'b1;	end
		else if(x==6 && y==45) begin	plot <= 1'b1;	end
		else if(x==7 && y==45) begin	plot <= 1'b1;	end
		else if(x==8 && y==45) begin	plot <= 1'b1;	end
		else if(x==9 && y==45) begin	plot <= 1'b1;	end
		else if(x==10 && y==45) begin	plot <= 1'b1;	end
		else if(x==11 && y==45) begin	plot <= 1'b1;	end
		else if(x==12 && y==45) begin	plot <= 1'b1;	end
		else if(x==13 && y==45) begin	plot <= 1'b1;	end
		else if(x==14 && y==45) begin	plot <= 1'b1;	end
		else if(x==4 && y==46) begin	plot <= 1'b1;	end
		else if(x==5 && y==46) begin	plot <= 1'b1;	end
		else if(x==6 && y==46) begin	plot <= 1'b1;	end
		else if(x==7 && y==46) begin	plot <= 1'b1;	end
		else if(x==8 && y==46) begin	plot <= 1'b1;	end
		else if(x==9 && y==46) begin	plot <= 1'b1;	end
		else if(x==10 && y==46) begin	plot <= 1'b1;	end
		else if(x==11 && y==46) begin	plot <= 1'b1;	end
		else if(x==12 && y==46) begin	plot <= 1'b1;	end
		else if(x==13 && y==46) begin	plot <= 1'b1;	end
		else if(x==14 && y==46) begin	plot <= 1'b1;	end
		else if(x==15 && y==46) begin	plot <= 1'b1;	end
		else if(x==3 && y==47) begin	plot <= 1'b1;	end
		else if(x==4 && y==47) begin	plot <= 1'b1;	end
		else if(x==5 && y==47) begin	plot <= 1'b1;	end
		else if(x==6 && y==47) begin	plot <= 1'b1;	end
		else if(x==7 && y==47) begin	plot <= 1'b1;	end
		else if(x==8 && y==47) begin	plot <= 1'b1;	end
		else if(x==9 && y==47) begin	plot <= 1'b1;	end
		else if(x==10 && y==47) begin	plot <= 1'b1;	end
		else if(x==11 && y==47) begin	plot <= 1'b1;	end
		else if(x==12 && y==47) begin	plot <= 1'b1;	end
		else if(x==13 && y==47) begin	plot <= 1'b1;	end
		else if(x==14 && y==47) begin	plot <= 1'b1;	end
		else if(x==15 && y==47) begin	plot <= 1'b1;	end
		else if(x==16 && y==47) begin	plot <= 1'b1;	end
		else if(x==2 && y==48) begin	plot <= 1'b1;	end
		else if(x==3 && y==48) begin	plot <= 1'b1;	end
		else if(x==4 && y==48) begin	plot <= 1'b1;	end
		else if(x==5 && y==48) begin	plot <= 1'b1;	end
		else if(x==6 && y==48) begin	plot <= 1'b1;	end
		else if(x==7 && y==48) begin	plot <= 1'b1;	end
		else if(x==8 && y==48) begin	plot <= 1'b1;	end
		else if(x==9 && y==48) begin	plot <= 1'b1;	end
		else if(x==10 && y==48) begin	plot <= 1'b1;	end
		else if(x==11 && y==48) begin	plot <= 1'b1;	end
		else if(x==12 && y==48) begin	plot <= 1'b1;	end
		else if(x==13 && y==48) begin	plot <= 1'b1;	end
		else if(x==14 && y==48) begin	plot <= 1'b1;	end
		else if(x==15 && y==48) begin	plot <= 1'b1;	end
		else if(x==16 && y==48) begin	plot <= 1'b1;	end
		else if(x==17 && y==48) begin	plot <= 1'b1;	end
		else if(x==1 && y==49) begin	plot <= 1'b1;	end
		else if(x==2 && y==49) begin	plot <= 1'b1;	end
		else if(x==3 && y==49) begin	plot <= 1'b1;	end
		else if(x==4 && y==49) begin	plot <= 1'b1;	end
		else if(x==5 && y==49) begin	plot <= 1'b1;	end
		else if(x==6 && y==49) begin	plot <= 1'b1;	end
		else if(x==7 && y==49) begin	plot <= 1'b1;	end
		else if(x==8 && y==49) begin	plot <= 1'b1;	end
		else if(x==9 && y==49) begin	plot <= 1'b1;	end
		else if(x==10 && y==49) begin	plot <= 1'b1;	end
		else if(x==11 && y==49) begin	plot <= 1'b1;	end
		else if(x==12 && y==49) begin	plot <= 1'b1;	end
		else if(x==13 && y==49) begin	plot <= 1'b1;	end
		else if(x==14 && y==49) begin	plot <= 1'b1;	end
		else if(x==15 && y==49) begin	plot <= 1'b1;	end
		else if(x==16 && y==49) begin	plot <= 1'b1;	end
		else if(x==17 && y==49) begin	plot <= 1'b1;	end
		else if(x==18 && y==49) begin	plot <= 1'b1;	end
		else if(x==1 && y==50) begin	plot <= 1'b1;	end
		else if(x==2 && y==50) begin	plot <= 1'b1;	end
		else if(x==3 && y==50) begin	plot <= 1'b1;	end
		else if(x==4 && y==50) begin	plot <= 1'b1;	end
		else if(x==5 && y==50) begin	plot <= 1'b1;	end
		else if(x==6 && y==50) begin	plot <= 1'b1;	end
		else if(x==7 && y==50) begin	plot <= 1'b1;	end
		else if(x==8 && y==50) begin	plot <= 1'b1;	end
		else if(x==9 && y==50) begin	plot <= 1'b1;	end
		else if(x==10 && y==50) begin	plot <= 1'b1;	end
		else if(x==11 && y==50) begin	plot <= 1'b1;	end
		else if(x==12 && y==50) begin	plot <= 1'b1;	end
		else if(x==13 && y==50) begin	plot <= 1'b1;	end
		else if(x==14 && y==50) begin	plot <= 1'b1;	end
		else if(x==15 && y==50) begin	plot <= 1'b1;	end
		else if(x==16 && y==50) begin	plot <= 1'b1;	end
		else if(x==17 && y==50) begin	plot <= 1'b1;	end
		else if(x==18 && y==50) begin	plot <= 1'b1;	end
		else if(x==1 && y==51) begin	plot <= 1'b1;	end
		else if(x==2 && y==51) begin	plot <= 1'b1;	end
		else if(x==3 && y==51) begin	plot <= 1'b1;	end
		else if(x==4 && y==51) begin	plot <= 1'b1;	end
		else if(x==5 && y==51) begin	plot <= 1'b1;	end
		else if(x==6 && y==51) begin	plot <= 1'b1;	end
		else if(x==7 && y==51) begin	plot <= 1'b1;	end
		else if(x==8 && y==51) begin	plot <= 1'b1;	end
		else if(x==9 && y==51) begin	plot <= 1'b1;	end
		else if(x==10 && y==51) begin	plot <= 1'b1;	end
		else if(x==11 && y==51) begin	plot <= 1'b1;	end
		else if(x==12 && y==51) begin	plot <= 1'b1;	end
		else if(x==13 && y==51) begin	plot <= 1'b1;	end
		else if(x==14 && y==51) begin	plot <= 1'b1;	end
		else if(x==15 && y==51) begin	plot <= 1'b1;	end
		else if(x==16 && y==51) begin	plot <= 1'b1;	end
		else if(x==17 && y==51) begin	plot <= 1'b1;	end
		else if(x==18 && y==51) begin	plot <= 1'b1;	end
		else if(x==1 && y==52) begin	plot <= 1'b1;	end
		else if(x==2 && y==52) begin	plot <= 1'b1;	end
		else if(x==3 && y==52) begin	plot <= 1'b1;	end
		else if(x==4 && y==52) begin	plot <= 1'b1;	end
		else if(x==5 && y==52) begin	plot <= 1'b1;	end
		else if(x==6 && y==52) begin	plot <= 1'b1;	end
		else if(x==7 && y==52) begin	plot <= 1'b1;	end
		else if(x==8 && y==52) begin	plot <= 1'b1;	end
		else if(x==9 && y==52) begin	plot <= 1'b1;	end
		else if(x==10 && y==52) begin	plot <= 1'b1;	end
		else if(x==11 && y==52) begin	plot <= 1'b1;	end
		else if(x==12 && y==52) begin	plot <= 1'b1;	end
		else if(x==13 && y==52) begin	plot <= 1'b1;	end
		else if(x==14 && y==52) begin	plot <= 1'b1;	end
		else if(x==15 && y==52) begin	plot <= 1'b1;	end
		else if(x==16 && y==52) begin	plot <= 1'b1;	end
		else if(x==17 && y==52) begin	plot <= 1'b1;	end
		else if(x==18 && y==52) begin	plot <= 1'b1;	end
		else if(x==1 && y==53) begin	plot <= 1'b1;	end
		else if(x==2 && y==53) begin	plot <= 1'b1;	end
		else if(x==3 && y==53) begin	plot <= 1'b1;	end
		else if(x==4 && y==53) begin	plot <= 1'b1;	end
		else if(x==5 && y==53) begin	plot <= 1'b1;	end
		else if(x==6 && y==53) begin	plot <= 1'b1;	end
		else if(x==7 && y==53) begin	plot <= 1'b1;	end
		else if(x==8 && y==53) begin	plot <= 1'b1;	end
		else if(x==9 && y==53) begin	plot <= 1'b1;	end
		else if(x==10 && y==53) begin	plot <= 1'b1;	end
		else if(x==11 && y==53) begin	plot <= 1'b1;	end
		else if(x==12 && y==53) begin	plot <= 1'b1;	end
		else if(x==13 && y==53) begin	plot <= 1'b1;	end
		else if(x==14 && y==53) begin	plot <= 1'b1;	end
		else if(x==15 && y==53) begin	plot <= 1'b1;	end
		else if(x==16 && y==53) begin	plot <= 1'b1;	end
		else if(x==17 && y==53) begin	plot <= 1'b1;	end
		else if(x==18 && y==53) begin	plot <= 1'b1;	end
		else if(x==1 && y==54) begin	plot <= 1'b1;	end
		else if(x==2 && y==54) begin	plot <= 1'b1;	end
		else if(x==3 && y==54) begin	plot <= 1'b1;	end
		else if(x==4 && y==54) begin	plot <= 1'b1;	end
		else if(x==7 && y==54) begin	plot <= 1'b1;	end
		else if(x==8 && y==54) begin	plot <= 1'b1;	end
		else if(x==9 && y==54) begin	plot <= 1'b1;	end
		else if(x==10 && y==54) begin	plot <= 1'b1;	end
		else if(x==11 && y==54) begin	plot <= 1'b1;	end
		else if(x==12 && y==54) begin	plot <= 1'b1;	end
		else if(x==15 && y==54) begin	plot <= 1'b1;	end
		else if(x==16 && y==54) begin	plot <= 1'b1;	end
		else if(x==17 && y==54) begin	plot <= 1'b1;	end
		else if(x==18 && y==54) begin	plot <= 1'b1;	end
		else if(x==1 && y==55) begin	plot <= 1'b1;	end
		else if(x==2 && y==55) begin	plot <= 1'b1;	end
		else if(x==3 && y==55) begin	plot <= 1'b1;	end
		else if(x==8 && y==55) begin	plot <= 1'b1;	end
		else if(x==9 && y==55) begin	plot <= 1'b1;	end
		else if(x==10 && y==55) begin	plot <= 1'b1;	end
		else if(x==11 && y==55) begin	plot <= 1'b1;	end
		else if(x==16 && y==55) begin	plot <= 1'b1;	end
		else if(x==17 && y==55) begin	plot <= 1'b1;	end
		else if(x==18 && y==55) begin	plot <= 1'b1;	end
		else if(x==2 && y==56) begin	plot <= 1'b1;	end
		else if(x==9 && y==56) begin	plot <= 1'b1;	end
		else if(x==10 && y==56) begin	plot <= 1'b1;	end
		else if(x==17 && y==56) begin	plot <= 1'b1;	end
		else begin plot <= 1'b0; end// Width: 21, Height: 59
	end
endmodule

// module for plotting the word PAUSE
module PAUSE(
	input clk,
	input wire [9:0] characterPositionX,
	input wire [8:0] characterPositionY,
	input wire [9:0] drawingPositionX,
	input wire [8:0] drawingPositionY,
	output reg [2:0] plot
);
	reg [9:0] x;
	reg [9:0] y;
	initial begin
		x = 'd0;
		y = 'd0;
	end

	always @(posedge clk) begin
		x <= (drawingPositionX - characterPositionX + 33);
		y <= (drawingPositionY - characterPositionY + 8);
		if(x==1 && y==1) begin	plot <= 1'b1;	end
		else if(x==2 && y==1) begin	plot <= 1'b1;	end
		else if(x==3 && y==1) begin	plot <= 1'b1;	end
		else if(x==4 && y==1) begin	plot <= 1'b1;	end
		else if(x==5 && y==1) begin	plot <= 1'b1;	end
		else if(x==6 && y==1) begin	plot <= 1'b1;	end
		else if(x==7 && y==1) begin	plot <= 1'b1;	end
		else if(x==8 && y==1) begin	plot <= 1'b1;	end
		else if(x==9 && y==1) begin	plot <= 1'b1;	end
		else if(x==15 && y==1) begin	plot <= 1'b1;	end
		else if(x==16 && y==1) begin	plot <= 1'b1;	end
		else if(x==17 && y==1) begin	plot <= 1'b1;	end
		else if(x==18 && y==1) begin	plot <= 1'b1;	end
		else if(x==19 && y==1) begin	plot <= 1'b1;	end
		else if(x==20 && y==1) begin	plot <= 1'b1;	end
		else if(x==21 && y==1) begin	plot <= 1'b1;	end
		else if(x==22 && y==1) begin	plot <= 1'b1;	end
		else if(x==26 && y==1) begin	plot <= 1'b1;	end
		else if(x==27 && y==1) begin	plot <= 1'b1;	end
		else if(x==28 && y==1) begin	plot <= 1'b1;	end
		else if(x==29 && y==1) begin	plot <= 1'b1;	end
		else if(x==34 && y==1) begin	plot <= 1'b1;	end
		else if(x==35 && y==1) begin	plot <= 1'b1;	end
		else if(x==36 && y==1) begin	plot <= 1'b1;	end
		else if(x==37 && y==1) begin	plot <= 1'b1;	end
		else if(x==41 && y==1) begin	plot <= 1'b1;	end
		else if(x==42 && y==1) begin	plot <= 1'b1;	end
		else if(x==43 && y==1) begin	plot <= 1'b1;	end
		else if(x==44 && y==1) begin	plot <= 1'b1;	end
		else if(x==45 && y==1) begin	plot <= 1'b1;	end
		else if(x==46 && y==1) begin	plot <= 1'b1;	end
		else if(x==47 && y==1) begin	plot <= 1'b1;	end
		else if(x==48 && y==1) begin	plot <= 1'b1;	end
		else if(x==49 && y==1) begin	plot <= 1'b1;	end
		else if(x==50 && y==1) begin	plot <= 1'b1;	end
		else if(x==54 && y==1) begin	plot <= 1'b1;	end
		else if(x==55 && y==1) begin	plot <= 1'b1;	end
		else if(x==56 && y==1) begin	plot <= 1'b1;	end
		else if(x==57 && y==1) begin	plot <= 1'b1;	end
		else if(x==58 && y==1) begin	plot <= 1'b1;	end
		else if(x==59 && y==1) begin	plot <= 1'b1;	end
		else if(x==60 && y==1) begin	plot <= 1'b1;	end
		else if(x==61 && y==1) begin	plot <= 1'b1;	end
		else if(x==62 && y==1) begin	plot <= 1'b1;	end
		else if(x==63 && y==1) begin	plot <= 1'b1;	end
		else if(x==1 && y==2) begin	plot <= 1'b1;	end
		else if(x==2 && y==2) begin	plot <= 1'b1;	end
		else if(x==3 && y==2) begin	plot <= 1'b1;	end
		else if(x==4 && y==2) begin	plot <= 1'b1;	end
		else if(x==5 && y==2) begin	plot <= 1'b1;	end
		else if(x==6 && y==2) begin	plot <= 1'b1;	end
		else if(x==7 && y==2) begin	plot <= 1'b1;	end
		else if(x==8 && y==2) begin	plot <= 1'b1;	end
		else if(x==9 && y==2) begin	plot <= 1'b1;	end
		else if(x==10 && y==2) begin	plot <= 1'b1;	end
		else if(x==11 && y==2) begin	plot <= 1'b1;	end
		else if(x==13 && y==2) begin	plot <= 1'b1;	end
		else if(x==14 && y==2) begin	plot <= 1'b1;	end
		else if(x==15 && y==2) begin	plot <= 1'b1;	end
		else if(x==16 && y==2) begin	plot <= 1'b1;	end
		else if(x==17 && y==2) begin	plot <= 1'b1;	end
		else if(x==18 && y==2) begin	plot <= 1'b1;	end
		else if(x==19 && y==2) begin	plot <= 1'b1;	end
		else if(x==20 && y==2) begin	plot <= 1'b1;	end
		else if(x==21 && y==2) begin	plot <= 1'b1;	end
		else if(x==22 && y==2) begin	plot <= 1'b1;	end
		else if(x==23 && y==2) begin	plot <= 1'b1;	end
		else if(x==24 && y==2) begin	plot <= 1'b1;	end
		else if(x==26 && y==2) begin	plot <= 1'b1;	end
		else if(x==27 && y==2) begin	plot <= 1'b1;	end
		else if(x==28 && y==2) begin	plot <= 1'b1;	end
		else if(x==29 && y==2) begin	plot <= 1'b1;	end
		else if(x==34 && y==2) begin	plot <= 1'b1;	end
		else if(x==35 && y==2) begin	plot <= 1'b1;	end
		else if(x==36 && y==2) begin	plot <= 1'b1;	end
		else if(x==37 && y==2) begin	plot <= 1'b1;	end
		else if(x==39 && y==2) begin	plot <= 1'b1;	end
		else if(x==40 && y==2) begin	plot <= 1'b1;	end
		else if(x==41 && y==2) begin	plot <= 1'b1;	end
		else if(x==42 && y==2) begin	plot <= 1'b1;	end
		else if(x==43 && y==2) begin	plot <= 1'b1;	end
		else if(x==44 && y==2) begin	plot <= 1'b1;	end
		else if(x==45 && y==2) begin	plot <= 1'b1;	end
		else if(x==46 && y==2) begin	plot <= 1'b1;	end
		else if(x==47 && y==2) begin	plot <= 1'b1;	end
		else if(x==48 && y==2) begin	plot <= 1'b1;	end
		else if(x==49 && y==2) begin	plot <= 1'b1;	end
		else if(x==50 && y==2) begin	plot <= 1'b1;	end
		else if(x==52 && y==2) begin	plot <= 1'b1;	end
		else if(x==53 && y==2) begin	plot <= 1'b1;	end
		else if(x==54 && y==2) begin	plot <= 1'b1;	end
		else if(x==55 && y==2) begin	plot <= 1'b1;	end
		else if(x==56 && y==2) begin	plot <= 1'b1;	end
		else if(x==57 && y==2) begin	plot <= 1'b1;	end
		else if(x==58 && y==2) begin	plot <= 1'b1;	end
		else if(x==59 && y==2) begin	plot <= 1'b1;	end
		else if(x==60 && y==2) begin	plot <= 1'b1;	end
		else if(x==61 && y==2) begin	plot <= 1'b1;	end
		else if(x==62 && y==2) begin	plot <= 1'b1;	end
		else if(x==63 && y==2) begin	plot <= 1'b1;	end
		else if(x==1 && y==3) begin	plot <= 1'b1;	end
		else if(x==2 && y==3) begin	plot <= 1'b1;	end
		else if(x==3 && y==3) begin	plot <= 1'b1;	end
		else if(x==4 && y==3) begin	plot <= 1'b1;	end
		else if(x==5 && y==3) begin	plot <= 1'b1;	end
		else if(x==6 && y==3) begin	plot <= 1'b1;	end
		else if(x==7 && y==3) begin	plot <= 1'b1;	end
		else if(x==8 && y==3) begin	plot <= 1'b1;	end
		else if(x==9 && y==3) begin	plot <= 1'b1;	end
		else if(x==10 && y==3) begin	plot <= 1'b1;	end
		else if(x==11 && y==3) begin	plot <= 1'b1;	end
		else if(x==13 && y==3) begin	plot <= 1'b1;	end
		else if(x==14 && y==3) begin	plot <= 1'b1;	end
		else if(x==15 && y==3) begin	plot <= 1'b1;	end
		else if(x==16 && y==3) begin	plot <= 1'b1;	end
		else if(x==17 && y==3) begin	plot <= 1'b1;	end
		else if(x==18 && y==3) begin	plot <= 1'b1;	end
		else if(x==19 && y==3) begin	plot <= 1'b1;	end
		else if(x==20 && y==3) begin	plot <= 1'b1;	end
		else if(x==21 && y==3) begin	plot <= 1'b1;	end
		else if(x==22 && y==3) begin	plot <= 1'b1;	end
		else if(x==23 && y==3) begin	plot <= 1'b1;	end
		else if(x==24 && y==3) begin	plot <= 1'b1;	end
		else if(x==26 && y==3) begin	plot <= 1'b1;	end
		else if(x==27 && y==3) begin	plot <= 1'b1;	end
		else if(x==28 && y==3) begin	plot <= 1'b1;	end
		else if(x==29 && y==3) begin	plot <= 1'b1;	end
		else if(x==34 && y==3) begin	plot <= 1'b1;	end
		else if(x==35 && y==3) begin	plot <= 1'b1;	end
		else if(x==36 && y==3) begin	plot <= 1'b1;	end
		else if(x==37 && y==3) begin	plot <= 1'b1;	end
		else if(x==39 && y==3) begin	plot <= 1'b1;	end
		else if(x==40 && y==3) begin	plot <= 1'b1;	end
		else if(x==41 && y==3) begin	plot <= 1'b1;	end
		else if(x==42 && y==3) begin	plot <= 1'b1;	end
		else if(x==43 && y==3) begin	plot <= 1'b1;	end
		else if(x==44 && y==3) begin	plot <= 1'b1;	end
		else if(x==45 && y==3) begin	plot <= 1'b1;	end
		else if(x==46 && y==3) begin	plot <= 1'b1;	end
		else if(x==47 && y==3) begin	plot <= 1'b1;	end
		else if(x==48 && y==3) begin	plot <= 1'b1;	end
		else if(x==49 && y==3) begin	plot <= 1'b1;	end
		else if(x==52 && y==3) begin	plot <= 1'b1;	end
		else if(x==53 && y==3) begin	plot <= 1'b1;	end
		else if(x==54 && y==3) begin	plot <= 1'b1;	end
		else if(x==55 && y==3) begin	plot <= 1'b1;	end
		else if(x==56 && y==3) begin	plot <= 1'b1;	end
		else if(x==57 && y==3) begin	plot <= 1'b1;	end
		else if(x==58 && y==3) begin	plot <= 1'b1;	end
		else if(x==59 && y==3) begin	plot <= 1'b1;	end
		else if(x==60 && y==3) begin	plot <= 1'b1;	end
		else if(x==61 && y==3) begin	plot <= 1'b1;	end
		else if(x==62 && y==3) begin	plot <= 1'b1;	end
		else if(x==1 && y==4) begin	plot <= 1'b1;	end
		else if(x==2 && y==4) begin	plot <= 1'b1;	end
		else if(x==3 && y==4) begin	plot <= 1'b1;	end
		else if(x==8 && y==4) begin	plot <= 1'b1;	end
		else if(x==9 && y==4) begin	plot <= 1'b1;	end
		else if(x==10 && y==4) begin	plot <= 1'b1;	end
		else if(x==11 && y==4) begin	plot <= 1'b1;	end
		else if(x==13 && y==4) begin	plot <= 1'b1;	end
		else if(x==14 && y==4) begin	plot <= 1'b1;	end
		else if(x==15 && y==4) begin	plot <= 1'b1;	end
		else if(x==16 && y==4) begin	plot <= 1'b1;	end
		else if(x==21 && y==4) begin	plot <= 1'b1;	end
		else if(x==22 && y==4) begin	plot <= 1'b1;	end
		else if(x==23 && y==4) begin	plot <= 1'b1;	end
		else if(x==24 && y==4) begin	plot <= 1'b1;	end
		else if(x==26 && y==4) begin	plot <= 1'b1;	end
		else if(x==27 && y==4) begin	plot <= 1'b1;	end
		else if(x==28 && y==4) begin	plot <= 1'b1;	end
		else if(x==29 && y==4) begin	plot <= 1'b1;	end
		else if(x==34 && y==4) begin	plot <= 1'b1;	end
		else if(x==35 && y==4) begin	plot <= 1'b1;	end
		else if(x==36 && y==4) begin	plot <= 1'b1;	end
		else if(x==37 && y==4) begin	plot <= 1'b1;	end
		else if(x==39 && y==4) begin	plot <= 1'b1;	end
		else if(x==40 && y==4) begin	plot <= 1'b1;	end
		else if(x==41 && y==4) begin	plot <= 1'b1;	end
		else if(x==42 && y==4) begin	plot <= 1'b1;	end
		else if(x==52 && y==4) begin	plot <= 1'b1;	end
		else if(x==53 && y==4) begin	plot <= 1'b1;	end
		else if(x==54 && y==4) begin	plot <= 1'b1;	end
		else if(x==55 && y==4) begin	plot <= 1'b1;	end
		else if(x==1 && y==5) begin	plot <= 1'b1;	end
		else if(x==2 && y==5) begin	plot <= 1'b1;	end
		else if(x==3 && y==5) begin	plot <= 1'b1;	end
		else if(x==8 && y==5) begin	plot <= 1'b1;	end
		else if(x==9 && y==5) begin	plot <= 1'b1;	end
		else if(x==10 && y==5) begin	plot <= 1'b1;	end
		else if(x==11 && y==5) begin	plot <= 1'b1;	end
		else if(x==13 && y==5) begin	plot <= 1'b1;	end
		else if(x==14 && y==5) begin	plot <= 1'b1;	end
		else if(x==15 && y==5) begin	plot <= 1'b1;	end
		else if(x==16 && y==5) begin	plot <= 1'b1;	end
		else if(x==21 && y==5) begin	plot <= 1'b1;	end
		else if(x==22 && y==5) begin	plot <= 1'b1;	end
		else if(x==23 && y==5) begin	plot <= 1'b1;	end
		else if(x==24 && y==5) begin	plot <= 1'b1;	end
		else if(x==26 && y==5) begin	plot <= 1'b1;	end
		else if(x==27 && y==5) begin	plot <= 1'b1;	end
		else if(x==28 && y==5) begin	plot <= 1'b1;	end
		else if(x==29 && y==5) begin	plot <= 1'b1;	end
		else if(x==34 && y==5) begin	plot <= 1'b1;	end
		else if(x==35 && y==5) begin	plot <= 1'b1;	end
		else if(x==36 && y==5) begin	plot <= 1'b1;	end
		else if(x==37 && y==5) begin	plot <= 1'b1;	end
		else if(x==39 && y==5) begin	plot <= 1'b1;	end
		else if(x==40 && y==5) begin	plot <= 1'b1;	end
		else if(x==41 && y==5) begin	plot <= 1'b1;	end
		else if(x==42 && y==5) begin	plot <= 1'b1;	end
		else if(x==52 && y==5) begin	plot <= 1'b1;	end
		else if(x==53 && y==5) begin	plot <= 1'b1;	end
		else if(x==54 && y==5) begin	plot <= 1'b1;	end
		else if(x==55 && y==5) begin	plot <= 1'b1;	end
		else if(x==1 && y==6) begin	plot <= 1'b1;	end
		else if(x==2 && y==6) begin	plot <= 1'b1;	end
		else if(x==3 && y==6) begin	plot <= 1'b1;	end
		else if(x==4 && y==6) begin	plot <= 1'b1;	end
		else if(x==5 && y==6) begin	plot <= 1'b1;	end
		else if(x==6 && y==6) begin	plot <= 1'b1;	end
		else if(x==7 && y==6) begin	plot <= 1'b1;	end
		else if(x==8 && y==6) begin	plot <= 1'b1;	end
		else if(x==9 && y==6) begin	plot <= 1'b1;	end
		else if(x==10 && y==6) begin	plot <= 1'b1;	end
		else if(x==11 && y==6) begin	plot <= 1'b1;	end
		else if(x==13 && y==6) begin	plot <= 1'b1;	end
		else if(x==14 && y==6) begin	plot <= 1'b1;	end
		else if(x==15 && y==6) begin	plot <= 1'b1;	end
		else if(x==16 && y==6) begin	plot <= 1'b1;	end
		else if(x==17 && y==6) begin	plot <= 1'b1;	end
		else if(x==18 && y==6) begin	plot <= 1'b1;	end
		else if(x==19 && y==6) begin	plot <= 1'b1;	end
		else if(x==20 && y==6) begin	plot <= 1'b1;	end
		else if(x==21 && y==6) begin	plot <= 1'b1;	end
		else if(x==22 && y==6) begin	plot <= 1'b1;	end
		else if(x==23 && y==6) begin	plot <= 1'b1;	end
		else if(x==24 && y==6) begin	plot <= 1'b1;	end
		else if(x==26 && y==6) begin	plot <= 1'b1;	end
		else if(x==27 && y==6) begin	plot <= 1'b1;	end
		else if(x==28 && y==6) begin	plot <= 1'b1;	end
		else if(x==29 && y==6) begin	plot <= 1'b1;	end
		else if(x==34 && y==6) begin	plot <= 1'b1;	end
		else if(x==35 && y==6) begin	plot <= 1'b1;	end
		else if(x==36 && y==6) begin	plot <= 1'b1;	end
		else if(x==37 && y==6) begin	plot <= 1'b1;	end
		else if(x==39 && y==6) begin	plot <= 1'b1;	end
		else if(x==40 && y==6) begin	plot <= 1'b1;	end
		else if(x==41 && y==6) begin	plot <= 1'b1;	end
		else if(x==42 && y==6) begin	plot <= 1'b1;	end
		else if(x==43 && y==6) begin	plot <= 1'b1;	end
		else if(x==44 && y==6) begin	plot <= 1'b1;	end
		else if(x==45 && y==6) begin	plot <= 1'b1;	end
		else if(x==46 && y==6) begin	plot <= 1'b1;	end
		else if(x==47 && y==6) begin	plot <= 1'b1;	end
		else if(x==48 && y==6) begin	plot <= 1'b1;	end
		else if(x==52 && y==6) begin	plot <= 1'b1;	end
		else if(x==53 && y==6) begin	plot <= 1'b1;	end
		else if(x==54 && y==6) begin	plot <= 1'b1;	end
		else if(x==55 && y==6) begin	plot <= 1'b1;	end
		else if(x==56 && y==6) begin	plot <= 1'b1;	end
		else if(x==57 && y==6) begin	plot <= 1'b1;	end
		else if(x==58 && y==6) begin	plot <= 1'b1;	end
		else if(x==59 && y==6) begin	plot <= 1'b1;	end
		else if(x==1 && y==7) begin	plot <= 1'b1;	end
		else if(x==2 && y==7) begin	plot <= 1'b1;	end
		else if(x==3 && y==7) begin	plot <= 1'b1;	end
		else if(x==4 && y==7) begin	plot <= 1'b1;	end
		else if(x==5 && y==7) begin	plot <= 1'b1;	end
		else if(x==6 && y==7) begin	plot <= 1'b1;	end
		else if(x==7 && y==7) begin	plot <= 1'b1;	end
		else if(x==8 && y==7) begin	plot <= 1'b1;	end
		else if(x==9 && y==7) begin	plot <= 1'b1;	end
		else if(x==10 && y==7) begin	plot <= 1'b1;	end
		else if(x==13 && y==7) begin	plot <= 1'b1;	end
		else if(x==14 && y==7) begin	plot <= 1'b1;	end
		else if(x==15 && y==7) begin	plot <= 1'b1;	end
		else if(x==16 && y==7) begin	plot <= 1'b1;	end
		else if(x==17 && y==7) begin	plot <= 1'b1;	end
		else if(x==18 && y==7) begin	plot <= 1'b1;	end
		else if(x==19 && y==7) begin	plot <= 1'b1;	end
		else if(x==20 && y==7) begin	plot <= 1'b1;	end
		else if(x==21 && y==7) begin	plot <= 1'b1;	end
		else if(x==22 && y==7) begin	plot <= 1'b1;	end
		else if(x==23 && y==7) begin	plot <= 1'b1;	end
		else if(x==24 && y==7) begin	plot <= 1'b1;	end
		else if(x==26 && y==7) begin	plot <= 1'b1;	end
		else if(x==27 && y==7) begin	plot <= 1'b1;	end
		else if(x==28 && y==7) begin	plot <= 1'b1;	end
		else if(x==29 && y==7) begin	plot <= 1'b1;	end
		else if(x==34 && y==7) begin	plot <= 1'b1;	end
		else if(x==35 && y==7) begin	plot <= 1'b1;	end
		else if(x==36 && y==7) begin	plot <= 1'b1;	end
		else if(x==37 && y==7) begin	plot <= 1'b1;	end
		else if(x==41 && y==7) begin	plot <= 1'b1;	end
		else if(x==42 && y==7) begin	plot <= 1'b1;	end
		else if(x==43 && y==7) begin	plot <= 1'b1;	end
		else if(x==44 && y==7) begin	plot <= 1'b1;	end
		else if(x==45 && y==7) begin	plot <= 1'b1;	end
		else if(x==46 && y==7) begin	plot <= 1'b1;	end
		else if(x==47 && y==7) begin	plot <= 1'b1;	end
		else if(x==48 && y==7) begin	plot <= 1'b1;	end
		else if(x==49 && y==7) begin	plot <= 1'b1;	end
		else if(x==52 && y==7) begin	plot <= 1'b1;	end
		else if(x==53 && y==7) begin	plot <= 1'b1;	end
		else if(x==54 && y==7) begin	plot <= 1'b1;	end
		else if(x==55 && y==7) begin	plot <= 1'b1;	end
		else if(x==56 && y==7) begin	plot <= 1'b1;	end
		else if(x==57 && y==7) begin	plot <= 1'b1;	end
		else if(x==58 && y==7) begin	plot <= 1'b1;	end
		else if(x==59 && y==7) begin	plot <= 1'b1;	end
		else if(x==1 && y==8) begin	plot <= 1'b1;	end
		else if(x==2 && y==8) begin	plot <= 1'b1;	end
		else if(x==3 && y==8) begin	plot <= 1'b1;	end
		else if(x==4 && y==8) begin	plot <= 1'b1;	end
		else if(x==5 && y==8) begin	plot <= 1'b1;	end
		else if(x==6 && y==8) begin	plot <= 1'b1;	end
		else if(x==7 && y==8) begin	plot <= 1'b1;	end
		else if(x==8 && y==8) begin	plot <= 1'b1;	end
		else if(x==9 && y==8) begin	plot <= 1'b1;	end
		else if(x==13 && y==8) begin	plot <= 1'b1;	end
		else if(x==14 && y==8) begin	plot <= 1'b1;	end
		else if(x==15 && y==8) begin	plot <= 1'b1;	end
		else if(x==16 && y==8) begin	plot <= 1'b1;	end
		else if(x==17 && y==8) begin	plot <= 1'b1;	end
		else if(x==18 && y==8) begin	plot <= 1'b1;	end
		else if(x==19 && y==8) begin	plot <= 1'b1;	end
		else if(x==20 && y==8) begin	plot <= 1'b1;	end
		else if(x==21 && y==8) begin	plot <= 1'b1;	end
		else if(x==22 && y==8) begin	plot <= 1'b1;	end
		else if(x==23 && y==8) begin	plot <= 1'b1;	end
		else if(x==24 && y==8) begin	plot <= 1'b1;	end
		else if(x==26 && y==8) begin	plot <= 1'b1;	end
		else if(x==27 && y==8) begin	plot <= 1'b1;	end
		else if(x==28 && y==8) begin	plot <= 1'b1;	end
		else if(x==29 && y==8) begin	plot <= 1'b1;	end
		else if(x==34 && y==8) begin	plot <= 1'b1;	end
		else if(x==35 && y==8) begin	plot <= 1'b1;	end
		else if(x==36 && y==8) begin	plot <= 1'b1;	end
		else if(x==37 && y==8) begin	plot <= 1'b1;	end
		else if(x==41 && y==8) begin	plot <= 1'b1;	end
		else if(x==42 && y==8) begin	plot <= 1'b1;	end
		else if(x==43 && y==8) begin	plot <= 1'b1;	end
		else if(x==44 && y==8) begin	plot <= 1'b1;	end
		else if(x==45 && y==8) begin	plot <= 1'b1;	end
		else if(x==46 && y==8) begin	plot <= 1'b1;	end
		else if(x==47 && y==8) begin	plot <= 1'b1;	end
		else if(x==48 && y==8) begin	plot <= 1'b1;	end
		else if(x==49 && y==8) begin	plot <= 1'b1;	end
		else if(x==50 && y==8) begin	plot <= 1'b1;	end
		else if(x==52 && y==8) begin	plot <= 1'b1;	end
		else if(x==53 && y==8) begin	plot <= 1'b1;	end
		else if(x==54 && y==8) begin	plot <= 1'b1;	end
		else if(x==55 && y==8) begin	plot <= 1'b1;	end
		else if(x==56 && y==8) begin	plot <= 1'b1;	end
		else if(x==57 && y==8) begin	plot <= 1'b1;	end
		else if(x==58 && y==8) begin	plot <= 1'b1;	end
		else if(x==59 && y==8) begin	plot <= 1'b1;	end
		else if(x==1 && y==9) begin	plot <= 1'b1;	end
		else if(x==2 && y==9) begin	plot <= 1'b1;	end
		else if(x==3 && y==9) begin	plot <= 1'b1;	end
		else if(x==4 && y==9) begin	plot <= 1'b1;	end
		else if(x==5 && y==9) begin	plot <= 1'b1;	end
		else if(x==6 && y==9) begin	plot <= 1'b1;	end
		else if(x==7 && y==9) begin	plot <= 1'b1;	end
		else if(x==8 && y==9) begin	plot <= 1'b1;	end
		else if(x==13 && y==9) begin	plot <= 1'b1;	end
		else if(x==14 && y==9) begin	plot <= 1'b1;	end
		else if(x==15 && y==9) begin	plot <= 1'b1;	end
		else if(x==16 && y==9) begin	plot <= 1'b1;	end
		else if(x==17 && y==9) begin	plot <= 1'b1;	end
		else if(x==18 && y==9) begin	plot <= 1'b1;	end
		else if(x==19 && y==9) begin	plot <= 1'b1;	end
		else if(x==20 && y==9) begin	plot <= 1'b1;	end
		else if(x==21 && y==9) begin	plot <= 1'b1;	end
		else if(x==22 && y==9) begin	plot <= 1'b1;	end
		else if(x==23 && y==9) begin	plot <= 1'b1;	end
		else if(x==24 && y==9) begin	plot <= 1'b1;	end
		else if(x==26 && y==9) begin	plot <= 1'b1;	end
		else if(x==27 && y==9) begin	plot <= 1'b1;	end
		else if(x==28 && y==9) begin	plot <= 1'b1;	end
		else if(x==29 && y==9) begin	plot <= 1'b1;	end
		else if(x==34 && y==9) begin	plot <= 1'b1;	end
		else if(x==35 && y==9) begin	plot <= 1'b1;	end
		else if(x==36 && y==9) begin	plot <= 1'b1;	end
		else if(x==37 && y==9) begin	plot <= 1'b1;	end
		else if(x==41 && y==9) begin	plot <= 1'b1;	end
		else if(x==42 && y==9) begin	plot <= 1'b1;	end
		else if(x==43 && y==9) begin	plot <= 1'b1;	end
		else if(x==44 && y==9) begin	plot <= 1'b1;	end
		else if(x==45 && y==9) begin	plot <= 1'b1;	end
		else if(x==46 && y==9) begin	plot <= 1'b1;	end
		else if(x==47 && y==9) begin	plot <= 1'b1;	end
		else if(x==48 && y==9) begin	plot <= 1'b1;	end
		else if(x==49 && y==9) begin	plot <= 1'b1;	end
		else if(x==50 && y==9) begin	plot <= 1'b1;	end
		else if(x==52 && y==9) begin	plot <= 1'b1;	end
		else if(x==53 && y==9) begin	plot <= 1'b1;	end
		else if(x==54 && y==9) begin	plot <= 1'b1;	end
		else if(x==55 && y==9) begin	plot <= 1'b1;	end
		else if(x==56 && y==9) begin	plot <= 1'b1;	end
		else if(x==57 && y==9) begin	plot <= 1'b1;	end
		else if(x==58 && y==9) begin	plot <= 1'b1;	end
		else if(x==59 && y==9) begin	plot <= 1'b1;	end
		else if(x==1 && y==10) begin	plot <= 1'b1;	end
		else if(x==2 && y==10) begin	plot <= 1'b1;	end
		else if(x==3 && y==10) begin	plot <= 1'b1;	end
		else if(x==13 && y==10) begin	plot <= 1'b1;	end
		else if(x==14 && y==10) begin	plot <= 1'b1;	end
		else if(x==15 && y==10) begin	plot <= 1'b1;	end
		else if(x==16 && y==10) begin	plot <= 1'b1;	end
		else if(x==21 && y==10) begin	plot <= 1'b1;	end
		else if(x==22 && y==10) begin	plot <= 1'b1;	end
		else if(x==23 && y==10) begin	plot <= 1'b1;	end
		else if(x==24 && y==10) begin	plot <= 1'b1;	end
		else if(x==26 && y==10) begin	plot <= 1'b1;	end
		else if(x==27 && y==10) begin	plot <= 1'b1;	end
		else if(x==28 && y==10) begin	plot <= 1'b1;	end
		else if(x==29 && y==10) begin	plot <= 1'b1;	end
		else if(x==34 && y==10) begin	plot <= 1'b1;	end
		else if(x==35 && y==10) begin	plot <= 1'b1;	end
		else if(x==36 && y==10) begin	plot <= 1'b1;	end
		else if(x==37 && y==10) begin	plot <= 1'b1;	end
		else if(x==47 && y==10) begin	plot <= 1'b1;	end
		else if(x==48 && y==10) begin	plot <= 1'b1;	end
		else if(x==49 && y==10) begin	plot <= 1'b1;	end
		else if(x==50 && y==10) begin	plot <= 1'b1;	end
		else if(x==52 && y==10) begin	plot <= 1'b1;	end
		else if(x==53 && y==10) begin	plot <= 1'b1;	end
		else if(x==54 && y==10) begin	plot <= 1'b1;	end
		else if(x==55 && y==10) begin	plot <= 1'b1;	end
		else if(x==1 && y==11) begin	plot <= 1'b1;	end
		else if(x==2 && y==11) begin	plot <= 1'b1;	end
		else if(x==3 && y==11) begin	plot <= 1'b1;	end
		else if(x==13 && y==11) begin	plot <= 1'b1;	end
		else if(x==14 && y==11) begin	plot <= 1'b1;	end
		else if(x==15 && y==11) begin	plot <= 1'b1;	end
		else if(x==16 && y==11) begin	plot <= 1'b1;	end
		else if(x==21 && y==11) begin	plot <= 1'b1;	end
		else if(x==22 && y==11) begin	plot <= 1'b1;	end
		else if(x==23 && y==11) begin	plot <= 1'b1;	end
		else if(x==24 && y==11) begin	plot <= 1'b1;	end
		else if(x==26 && y==11) begin	plot <= 1'b1;	end
		else if(x==27 && y==11) begin	plot <= 1'b1;	end
		else if(x==28 && y==11) begin	plot <= 1'b1;	end
		else if(x==29 && y==11) begin	plot <= 1'b1;	end
		else if(x==30 && y==11) begin	plot <= 1'b1;	end
		else if(x==31 && y==11) begin	plot <= 1'b1;	end
		else if(x==32 && y==11) begin	plot <= 1'b1;	end
		else if(x==33 && y==11) begin	plot <= 1'b1;	end
		else if(x==34 && y==11) begin	plot <= 1'b1;	end
		else if(x==35 && y==11) begin	plot <= 1'b1;	end
		else if(x==36 && y==11) begin	plot <= 1'b1;	end
		else if(x==37 && y==11) begin	plot <= 1'b1;	end
		else if(x==39 && y==11) begin	plot <= 1'b1;	end
		else if(x==40 && y==11) begin	plot <= 1'b1;	end
		else if(x==41 && y==11) begin	plot <= 1'b1;	end
		else if(x==42 && y==11) begin	plot <= 1'b1;	end
		else if(x==43 && y==11) begin	plot <= 1'b1;	end
		else if(x==44 && y==11) begin	plot <= 1'b1;	end
		else if(x==45 && y==11) begin	plot <= 1'b1;	end
		else if(x==46 && y==11) begin	plot <= 1'b1;	end
		else if(x==47 && y==11) begin	plot <= 1'b1;	end
		else if(x==48 && y==11) begin	plot <= 1'b1;	end
		else if(x==49 && y==11) begin	plot <= 1'b1;	end
		else if(x==50 && y==11) begin	plot <= 1'b1;	end
		else if(x==52 && y==11) begin	plot <= 1'b1;	end
		else if(x==53 && y==11) begin	plot <= 1'b1;	end
		else if(x==54 && y==11) begin	plot <= 1'b1;	end
		else if(x==55 && y==11) begin	plot <= 1'b1;	end
		else if(x==56 && y==11) begin	plot <= 1'b1;	end
		else if(x==57 && y==11) begin	plot <= 1'b1;	end
		else if(x==58 && y==11) begin	plot <= 1'b1;	end
		else if(x==59 && y==11) begin	plot <= 1'b1;	end
		else if(x==60 && y==11) begin	plot <= 1'b1;	end
		else if(x==61 && y==11) begin	plot <= 1'b1;	end
		else if(x==62 && y==11) begin	plot <= 1'b1;	end
		else if(x==1 && y==12) begin	plot <= 1'b1;	end
		else if(x==2 && y==12) begin	plot <= 1'b1;	end
		else if(x==3 && y==12) begin	plot <= 1'b1;	end
		else if(x==13 && y==12) begin	plot <= 1'b1;	end
		else if(x==14 && y==12) begin	plot <= 1'b1;	end
		else if(x==15 && y==12) begin	plot <= 1'b1;	end
		else if(x==16 && y==12) begin	plot <= 1'b1;	end
		else if(x==21 && y==12) begin	plot <= 1'b1;	end
		else if(x==22 && y==12) begin	plot <= 1'b1;	end
		else if(x==23 && y==12) begin	plot <= 1'b1;	end
		else if(x==24 && y==12) begin	plot <= 1'b1;	end
		else if(x==26 && y==12) begin	plot <= 1'b1;	end
		else if(x==27 && y==12) begin	plot <= 1'b1;	end
		else if(x==28 && y==12) begin	plot <= 1'b1;	end
		else if(x==29 && y==12) begin	plot <= 1'b1;	end
		else if(x==30 && y==12) begin	plot <= 1'b1;	end
		else if(x==31 && y==12) begin	plot <= 1'b1;	end
		else if(x==32 && y==12) begin	plot <= 1'b1;	end
		else if(x==33 && y==12) begin	plot <= 1'b1;	end
		else if(x==34 && y==12) begin	plot <= 1'b1;	end
		else if(x==35 && y==12) begin	plot <= 1'b1;	end
		else if(x==36 && y==12) begin	plot <= 1'b1;	end
		else if(x==37 && y==12) begin	plot <= 1'b1;	end
		else if(x==39 && y==12) begin	plot <= 1'b1;	end
		else if(x==40 && y==12) begin	plot <= 1'b1;	end
		else if(x==41 && y==12) begin	plot <= 1'b1;	end
		else if(x==42 && y==12) begin	plot <= 1'b1;	end
		else if(x==43 && y==12) begin	plot <= 1'b1;	end
		else if(x==44 && y==12) begin	plot <= 1'b1;	end
		else if(x==45 && y==12) begin	plot <= 1'b1;	end
		else if(x==46 && y==12) begin	plot <= 1'b1;	end
		else if(x==47 && y==12) begin	plot <= 1'b1;	end
		else if(x==48 && y==12) begin	plot <= 1'b1;	end
		else if(x==49 && y==12) begin	plot <= 1'b1;	end
		else if(x==50 && y==12) begin	plot <= 1'b1;	end
		else if(x==52 && y==12) begin	plot <= 1'b1;	end
		else if(x==53 && y==12) begin	plot <= 1'b1;	end
		else if(x==54 && y==12) begin	plot <= 1'b1;	end
		else if(x==55 && y==12) begin	plot <= 1'b1;	end
		else if(x==56 && y==12) begin	plot <= 1'b1;	end
		else if(x==57 && y==12) begin	plot <= 1'b1;	end
		else if(x==58 && y==12) begin	plot <= 1'b1;	end
		else if(x==59 && y==12) begin	plot <= 1'b1;	end
		else if(x==60 && y==12) begin	plot <= 1'b1;	end
		else if(x==61 && y==12) begin	plot <= 1'b1;	end
		else if(x==62 && y==12) begin	plot <= 1'b1;	end
		else if(x==63 && y==12) begin	plot <= 1'b1;	end
		else if(x==1 && y==13) begin	plot <= 1'b1;	end
		else if(x==2 && y==13) begin	plot <= 1'b1;	end
		else if(x==3 && y==13) begin	plot <= 1'b1;	end
		else if(x==13 && y==13) begin	plot <= 1'b1;	end
		else if(x==14 && y==13) begin	plot <= 1'b1;	end
		else if(x==15 && y==13) begin	plot <= 1'b1;	end
		else if(x==16 && y==13) begin	plot <= 1'b1;	end
		else if(x==21 && y==13) begin	plot <= 1'b1;	end
		else if(x==22 && y==13) begin	plot <= 1'b1;	end
		else if(x==23 && y==13) begin	plot <= 1'b1;	end
		else if(x==24 && y==13) begin	plot <= 1'b1;	end
		else if(x==28 && y==13) begin	plot <= 1'b1;	end
		else if(x==29 && y==13) begin	plot <= 1'b1;	end
		else if(x==30 && y==13) begin	plot <= 1'b1;	end
		else if(x==31 && y==13) begin	plot <= 1'b1;	end
		else if(x==32 && y==13) begin	plot <= 1'b1;	end
		else if(x==33 && y==13) begin	plot <= 1'b1;	end
		else if(x==34 && y==13) begin	plot <= 1'b1;	end
		else if(x==35 && y==13) begin	plot <= 1'b1;	end
		else if(x==39 && y==13) begin	plot <= 1'b1;	end
		else if(x==40 && y==13) begin	plot <= 1'b1;	end
		else if(x==41 && y==13) begin	plot <= 1'b1;	end
		else if(x==42 && y==13) begin	plot <= 1'b1;	end
		else if(x==43 && y==13) begin	plot <= 1'b1;	end
		else if(x==44 && y==13) begin	plot <= 1'b1;	end
		else if(x==45 && y==13) begin	plot <= 1'b1;	end
		else if(x==46 && y==13) begin	plot <= 1'b1;	end
		else if(x==47 && y==13) begin	plot <= 1'b1;	end
		else if(x==48 && y==13) begin	plot <= 1'b1;	end
		else if(x==54 && y==13) begin	plot <= 1'b1;	end
		else if(x==55 && y==13) begin	plot <= 1'b1;	end
		else if(x==56 && y==13) begin	plot <= 1'b1;	end
		else if(x==57 && y==13) begin	plot <= 1'b1;	end
		else if(x==58 && y==13) begin	plot <= 1'b1;	end
		else if(x==59 && y==13) begin	plot <= 1'b1;	end
		else if(x==60 && y==13) begin	plot <= 1'b1;	end
		else if(x==61 && y==13) begin	plot <= 1'b1;	end
		else if(x==62 && y==13) begin	plot <= 1'b1;	end
		else if(x==63 && y==13) begin	plot <= 1'b1;	end
		else if(x==1 && y==14) begin	plot <= 1'b1;	end
		else if(x==2 && y==14) begin	plot <= 1'b1;	end
		else if(x==3 && y==14) begin	plot <= 1'b1;	end
		else if(x==13 && y==14) begin	plot <= 1'b1;	end
		else if(x==14 && y==14) begin	plot <= 1'b1;	end
		else if(x==15 && y==14) begin	plot <= 1'b1;	end
		else if(x==16 && y==14) begin	plot <= 1'b1;	end
		else if(x==21 && y==14) begin	plot <= 1'b1;	end
		else if(x==22 && y==14) begin	plot <= 1'b1;	end
		else if(x==23 && y==14) begin	plot <= 1'b1;	end
		else if(x==24 && y==14) begin	plot <= 1'b1;	end
		else if(x==28 && y==14) begin	plot <= 1'b1;	end
		else if(x==29 && y==14) begin	plot <= 1'b1;	end
		else if(x==30 && y==14) begin	plot <= 1'b1;	end
		else if(x==31 && y==14) begin	plot <= 1'b1;	end
		else if(x==32 && y==14) begin	plot <= 1'b1;	end
		else if(x==33 && y==14) begin	plot <= 1'b1;	end
		else if(x==34 && y==14) begin	plot <= 1'b1;	end
		else if(x==35 && y==14) begin	plot <= 1'b1;	end
		else if(x==39 && y==14) begin	plot <= 1'b1;	end
		else if(x==40 && y==14) begin	plot <= 1'b1;	end
		else if(x==41 && y==14) begin	plot <= 1'b1;	end
		else if(x==42 && y==14) begin	plot <= 1'b1;	end
		else if(x==43 && y==14) begin	plot <= 1'b1;	end
		else if(x==44 && y==14) begin	plot <= 1'b1;	end
		else if(x==45 && y==14) begin	plot <= 1'b1;	end
		else if(x==46 && y==14) begin	plot <= 1'b1;	end
		else if(x==47 && y==14) begin	plot <= 1'b1;	end
		else if(x==48 && y==14) begin	plot <= 1'b1;	end
		else if(x==54 && y==14) begin	plot <= 1'b1;	end
		else if(x==55 && y==14) begin	plot <= 1'b1;	end
		else if(x==56 && y==14) begin	plot <= 1'b1;	end
		else if(x==57 && y==14) begin	plot <= 1'b1;	end
		else if(x==58 && y==14) begin	plot <= 1'b1;	end
		else if(x==59 && y==14) begin	plot <= 1'b1;	end
		else if(x==60 && y==14) begin	plot <= 1'b1;	end
		else if(x==61 && y==14) begin	plot <= 1'b1;	end
		else if(x==62 && y==14) begin	plot <= 1'b1;	end
		else if(x==63 && y==14) begin	plot <= 1'b1;	end
		else begin plot <= 1'b0; end// Width: 64, Height: 15
	end
endmodule

// module for plotting start screen with bigger lightning symbol
module sss(
	input clk,
	input wire [9:0] characterPositionX,
	input wire [8:0] characterPositionY,
	input wire [9:0] drawingPositionX,
	input wire [8:0] drawingPositionY,
	output reg [2:0] plot
);
	reg [9:0] x;
	reg [9:0] y;
	initial begin
		x = 'd0;
		y = 'd0;
	end

	always @(posedge clk) begin
		x <= (drawingPositionX - characterPositionX + 161);
		y <= (drawingPositionY - characterPositionY + 121);
		if(x==75 && y==47) begin	plot <= 1'b1;	end
		else if(x==76 && y==47) begin	plot <= 1'b1;	end
		else if(x==77 && y==47) begin	plot <= 1'b1;	end
		else if(x==78 && y==47) begin	plot <= 1'b1;	end
		else if(x==79 && y==47) begin	plot <= 1'b1;	end
		else if(x==80 && y==47) begin	plot <= 1'b1;	end
		else if(x==81 && y==47) begin	plot <= 1'b1;	end
		else if(x==82 && y==47) begin	plot <= 1'b1;	end
		else if(x==83 && y==47) begin	plot <= 1'b1;	end
		else if(x==84 && y==47) begin	plot <= 1'b1;	end
		else if(x==90 && y==47) begin	plot <= 1'b1;	end
		else if(x==91 && y==47) begin	plot <= 1'b1;	end
		else if(x==92 && y==47) begin	plot <= 1'b1;	end
		else if(x==93 && y==47) begin	plot <= 1'b1;	end
		else if(x==94 && y==47) begin	plot <= 1'b1;	end
		else if(x==95 && y==47) begin	plot <= 1'b1;	end
		else if(x==96 && y==47) begin	plot <= 1'b1;	end
		else if(x==101 && y==47) begin	plot <= 1'b1;	end
		else if(x==102 && y==47) begin	plot <= 1'b1;	end
		else if(x==103 && y==47) begin	plot <= 1'b1;	end
		else if(x==104 && y==47) begin	plot <= 1'b1;	end
		else if(x==116 && y==47) begin	plot <= 1'b1;	end
		else if(x==117 && y==47) begin	plot <= 1'b1;	end
		else if(x==118 && y==47) begin	plot <= 1'b1;	end
		else if(x==119 && y==47) begin	plot <= 1'b1;	end
		else if(x==120 && y==47) begin	plot <= 1'b1;	end
		else if(x==121 && y==47) begin	plot <= 1'b1;	end
		else if(x==122 && y==47) begin	plot <= 1'b1;	end
		else if(x==123 && y==47) begin	plot <= 1'b1;	end
		else if(x==124 && y==47) begin	plot <= 1'b1;	end
		else if(x==129 && y==47) begin	plot <= 1'b1;	end
		else if(x==130 && y==47) begin	plot <= 1'b1;	end
		else if(x==131 && y==47) begin	plot <= 1'b1;	end
		else if(x==132 && y==47) begin	plot <= 1'b1;	end
		else if(x==133 && y==47) begin	plot <= 1'b1;	end
		else if(x==134 && y==47) begin	plot <= 1'b1;	end
		else if(x==135 && y==47) begin	plot <= 1'b1;	end
		else if(x==136 && y==47) begin	plot <= 1'b1;	end
		else if(x==149 && y==47) begin	plot <= 1'b1;	end
		else if(x==150 && y==47) begin	plot <= 1'b1;	end
		else if(x==151 && y==47) begin	plot <= 1'b1;	end
		else if(x==152 && y==47) begin	plot <= 1'b1;	end
		else if(x==153 && y==47) begin	plot <= 1'b1;	end
		else if(x==154 && y==47) begin	plot <= 1'b1;	end
		else if(x==155 && y==47) begin	plot <= 1'b1;	end
		else if(x==163 && y==47) begin	plot <= 1'b1;	end
		else if(x==164 && y==47) begin	plot <= 1'b1;	end
		else if(x==165 && y==47) begin	plot <= 1'b1;	end
		else if(x==166 && y==47) begin	plot <= 1'b1;	end
		else if(x==167 && y==47) begin	plot <= 1'b1;	end
		else if(x==168 && y==47) begin	plot <= 1'b1;	end
		else if(x==169 && y==47) begin	plot <= 1'b1;	end
		else if(x==170 && y==47) begin	plot <= 1'b1;	end
		else if(x==181 && y==47) begin	plot <= 1'b1;	end
		else if(x==182 && y==47) begin	plot <= 1'b1;	end
		else if(x==183 && y==47) begin	plot <= 1'b1;	end
		else if(x==184 && y==47) begin	plot <= 1'b1;	end
		else if(x==185 && y==47) begin	plot <= 1'b1;	end
		else if(x==186 && y==47) begin	plot <= 1'b1;	end
		else if(x==187 && y==47) begin	plot <= 1'b1;	end
		else if(x==188 && y==47) begin	plot <= 1'b1;	end
		else if(x==189 && y==47) begin	plot <= 1'b1;	end
		else if(x==195 && y==47) begin	plot <= 1'b1;	end
		else if(x==196 && y==47) begin	plot <= 1'b1;	end
		else if(x==197 && y==47) begin	plot <= 1'b1;	end
		else if(x==198 && y==47) begin	plot <= 1'b1;	end
		else if(x==199 && y==47) begin	plot <= 1'b1;	end
		else if(x==200 && y==47) begin	plot <= 1'b1;	end
		else if(x==201 && y==47) begin	plot <= 1'b1;	end
		else if(x==207 && y==47) begin	plot <= 1'b1;	end
		else if(x==208 && y==47) begin	plot <= 1'b1;	end
		else if(x==209 && y==47) begin	plot <= 1'b1;	end
		else if(x==214 && y==47) begin	plot <= 1'b1;	end
		else if(x==215 && y==47) begin	plot <= 1'b1;	end
		else if(x==216 && y==47) begin	plot <= 1'b1;	end
		else if(x==217 && y==47) begin	plot <= 1'b1;	end
		else if(x==218 && y==47) begin	plot <= 1'b1;	end
		else if(x==219 && y==47) begin	plot <= 1'b1;	end
		else if(x==220 && y==47) begin	plot <= 1'b1;	end
		else if(x==221 && y==47) begin	plot <= 1'b1;	end
		else if(x==228 && y==47) begin	plot <= 1'b1;	end
		else if(x==229 && y==47) begin	plot <= 1'b1;	end
		else if(x==230 && y==47) begin	plot <= 1'b1;	end
		else if(x==231 && y==47) begin	plot <= 1'b1;	end
		else if(x==232 && y==47) begin	plot <= 1'b1;	end
		else if(x==233 && y==47) begin	plot <= 1'b1;	end
		else if(x==234 && y==47) begin	plot <= 1'b1;	end
		else if(x==235 && y==47) begin	plot <= 1'b1;	end
		else if(x==240 && y==47) begin	plot <= 1'b1;	end
		else if(x==241 && y==47) begin	plot <= 1'b1;	end
		else if(x==242 && y==47) begin	plot <= 1'b1;	end
		else if(x==243 && y==47) begin	plot <= 1'b1;	end
		else if(x==244 && y==47) begin	plot <= 1'b1;	end
		else if(x==245 && y==47) begin	plot <= 1'b1;	end
		else if(x==246 && y==47) begin	plot <= 1'b1;	end
		else if(x==247 && y==47) begin	plot <= 1'b1;	end
		else if(x==75 && y==48) begin	plot <= 1'b1;	end
		else if(x==76 && y==48) begin	plot <= 1'b1;	end
		else if(x==77 && y==48) begin	plot <= 1'b1;	end
		else if(x==78 && y==48) begin	plot <= 1'b1;	end
		else if(x==79 && y==48) begin	plot <= 1'b1;	end
		else if(x==80 && y==48) begin	plot <= 1'b1;	end
		else if(x==81 && y==48) begin	plot <= 1'b1;	end
		else if(x==82 && y==48) begin	plot <= 1'b1;	end
		else if(x==83 && y==48) begin	plot <= 1'b1;	end
		else if(x==84 && y==48) begin	plot <= 1'b1;	end
		else if(x==85 && y==48) begin	plot <= 1'b1;	end
		else if(x==89 && y==48) begin	plot <= 1'b1;	end
		else if(x==90 && y==48) begin	plot <= 1'b1;	end
		else if(x==91 && y==48) begin	plot <= 1'b1;	end
		else if(x==92 && y==48) begin	plot <= 1'b1;	end
		else if(x==93 && y==48) begin	plot <= 1'b1;	end
		else if(x==94 && y==48) begin	plot <= 1'b1;	end
		else if(x==95 && y==48) begin	plot <= 1'b1;	end
		else if(x==96 && y==48) begin	plot <= 1'b1;	end
		else if(x==97 && y==48) begin	plot <= 1'b1;	end
		else if(x==101 && y==48) begin	plot <= 1'b1;	end
		else if(x==102 && y==48) begin	plot <= 1'b1;	end
		else if(x==103 && y==48) begin	plot <= 1'b1;	end
		else if(x==104 && y==48) begin	plot <= 1'b1;	end
		else if(x==105 && y==48) begin	plot <= 1'b1;	end
		else if(x==115 && y==48) begin	plot <= 1'b1;	end
		else if(x==116 && y==48) begin	plot <= 1'b1;	end
		else if(x==117 && y==48) begin	plot <= 1'b1;	end
		else if(x==118 && y==48) begin	plot <= 1'b1;	end
		else if(x==119 && y==48) begin	plot <= 1'b1;	end
		else if(x==120 && y==48) begin	plot <= 1'b1;	end
		else if(x==121 && y==48) begin	plot <= 1'b1;	end
		else if(x==122 && y==48) begin	plot <= 1'b1;	end
		else if(x==123 && y==48) begin	plot <= 1'b1;	end
		else if(x==124 && y==48) begin	plot <= 1'b1;	end
		else if(x==129 && y==48) begin	plot <= 1'b1;	end
		else if(x==130 && y==48) begin	plot <= 1'b1;	end
		else if(x==131 && y==48) begin	plot <= 1'b1;	end
		else if(x==132 && y==48) begin	plot <= 1'b1;	end
		else if(x==133 && y==48) begin	plot <= 1'b1;	end
		else if(x==134 && y==48) begin	plot <= 1'b1;	end
		else if(x==135 && y==48) begin	plot <= 1'b1;	end
		else if(x==136 && y==48) begin	plot <= 1'b1;	end
		else if(x==137 && y==48) begin	plot <= 1'b1;	end
		else if(x==138 && y==48) begin	plot <= 1'b1;	end
		else if(x==148 && y==48) begin	plot <= 1'b1;	end
		else if(x==149 && y==48) begin	plot <= 1'b1;	end
		else if(x==150 && y==48) begin	plot <= 1'b1;	end
		else if(x==151 && y==48) begin	plot <= 1'b1;	end
		else if(x==152 && y==48) begin	plot <= 1'b1;	end
		else if(x==153 && y==48) begin	plot <= 1'b1;	end
		else if(x==154 && y==48) begin	plot <= 1'b1;	end
		else if(x==155 && y==48) begin	plot <= 1'b1;	end
		else if(x==156 && y==48) begin	plot <= 1'b1;	end
		else if(x==162 && y==48) begin	plot <= 1'b1;	end
		else if(x==163 && y==48) begin	plot <= 1'b1;	end
		else if(x==164 && y==48) begin	plot <= 1'b1;	end
		else if(x==165 && y==48) begin	plot <= 1'b1;	end
		else if(x==166 && y==48) begin	plot <= 1'b1;	end
		else if(x==167 && y==48) begin	plot <= 1'b1;	end
		else if(x==168 && y==48) begin	plot <= 1'b1;	end
		else if(x==169 && y==48) begin	plot <= 1'b1;	end
		else if(x==170 && y==48) begin	plot <= 1'b1;	end
		else if(x==180 && y==48) begin	plot <= 1'b1;	end
		else if(x==181 && y==48) begin	plot <= 1'b1;	end
		else if(x==182 && y==48) begin	plot <= 1'b1;	end
		else if(x==183 && y==48) begin	plot <= 1'b1;	end
		else if(x==184 && y==48) begin	plot <= 1'b1;	end
		else if(x==185 && y==48) begin	plot <= 1'b1;	end
		else if(x==186 && y==48) begin	plot <= 1'b1;	end
		else if(x==187 && y==48) begin	plot <= 1'b1;	end
		else if(x==188 && y==48) begin	plot <= 1'b1;	end
		else if(x==189 && y==48) begin	plot <= 1'b1;	end
		else if(x==195 && y==48) begin	plot <= 1'b1;	end
		else if(x==196 && y==48) begin	plot <= 1'b1;	end
		else if(x==197 && y==48) begin	plot <= 1'b1;	end
		else if(x==198 && y==48) begin	plot <= 1'b1;	end
		else if(x==199 && y==48) begin	plot <= 1'b1;	end
		else if(x==200 && y==48) begin	plot <= 1'b1;	end
		else if(x==201 && y==48) begin	plot <= 1'b1;	end
		else if(x==202 && y==48) begin	plot <= 1'b1;	end
		else if(x==206 && y==48) begin	plot <= 1'b1;	end
		else if(x==207 && y==48) begin	plot <= 1'b1;	end
		else if(x==208 && y==48) begin	plot <= 1'b1;	end
		else if(x==209 && y==48) begin	plot <= 1'b1;	end
		else if(x==210 && y==48) begin	plot <= 1'b1;	end
		else if(x==214 && y==48) begin	plot <= 1'b1;	end
		else if(x==215 && y==48) begin	plot <= 1'b1;	end
		else if(x==216 && y==48) begin	plot <= 1'b1;	end
		else if(x==217 && y==48) begin	plot <= 1'b1;	end
		else if(x==218 && y==48) begin	plot <= 1'b1;	end
		else if(x==219 && y==48) begin	plot <= 1'b1;	end
		else if(x==220 && y==48) begin	plot <= 1'b1;	end
		else if(x==221 && y==48) begin	plot <= 1'b1;	end
		else if(x==222 && y==48) begin	plot <= 1'b1;	end
		else if(x==227 && y==48) begin	plot <= 1'b1;	end
		else if(x==228 && y==48) begin	plot <= 1'b1;	end
		else if(x==229 && y==48) begin	plot <= 1'b1;	end
		else if(x==230 && y==48) begin	plot <= 1'b1;	end
		else if(x==231 && y==48) begin	plot <= 1'b1;	end
		else if(x==232 && y==48) begin	plot <= 1'b1;	end
		else if(x==233 && y==48) begin	plot <= 1'b1;	end
		else if(x==234 && y==48) begin	plot <= 1'b1;	end
		else if(x==235 && y==48) begin	plot <= 1'b1;	end
		else if(x==236 && y==48) begin	plot <= 1'b1;	end
		else if(x==240 && y==48) begin	plot <= 1'b1;	end
		else if(x==241 && y==48) begin	plot <= 1'b1;	end
		else if(x==242 && y==48) begin	plot <= 1'b1;	end
		else if(x==243 && y==48) begin	plot <= 1'b1;	end
		else if(x==244 && y==48) begin	plot <= 1'b1;	end
		else if(x==245 && y==48) begin	plot <= 1'b1;	end
		else if(x==246 && y==48) begin	plot <= 1'b1;	end
		else if(x==247 && y==48) begin	plot <= 1'b1;	end
		else if(x==248 && y==48) begin	plot <= 1'b1;	end
		else if(x==76 && y==49) begin	plot <= 1'b1;	end
		else if(x==78 && y==49) begin	plot <= 1'b1;	end
		else if(x==79 && y==49) begin	plot <= 1'b1;	end
		else if(x==80 && y==49) begin	plot <= 1'b1;	end
		else if(x==81 && y==49) begin	plot <= 1'b1;	end
		else if(x==82 && y==49) begin	plot <= 1'b1;	end
		else if(x==84 && y==49) begin	plot <= 1'b1;	end
		else if(x==89 && y==49) begin	plot <= 1'b1;	end
		else if(x==90 && y==49) begin	plot <= 1'b1;	end
		else if(x==91 && y==49) begin	plot <= 1'b1;	end
		else if(x==92 && y==49) begin	plot <= 1'b1;	end
		else if(x==94 && y==49) begin	plot <= 1'b1;	end
		else if(x==95 && y==49) begin	plot <= 1'b1;	end
		else if(x==96 && y==49) begin	plot <= 1'b1;	end
		else if(x==97 && y==49) begin	plot <= 1'b1;	end
		else if(x==98 && y==49) begin	plot <= 1'b1;	end
		else if(x==101 && y==49) begin	plot <= 1'b1;	end
		else if(x==102 && y==49) begin	plot <= 1'b1;	end
		else if(x==103 && y==49) begin	plot <= 1'b1;	end
		else if(x==104 && y==49) begin	plot <= 1'b1;	end
		else if(x==105 && y==49) begin	plot <= 1'b1;	end
		else if(x==115 && y==49) begin	plot <= 1'b1;	end
		else if(x==116 && y==49) begin	plot <= 1'b1;	end
		else if(x==117 && y==49) begin	plot <= 1'b1;	end
		else if(x==118 && y==49) begin	plot <= 1'b1;	end
		else if(x==119 && y==49) begin	plot <= 1'b1;	end
		else if(x==120 && y==49) begin	plot <= 1'b1;	end
		else if(x==121 && y==49) begin	plot <= 1'b1;	end
		else if(x==122 && y==49) begin	plot <= 1'b1;	end
		else if(x==123 && y==49) begin	plot <= 1'b1;	end
		else if(x==124 && y==49) begin	plot <= 1'b1;	end
		else if(x==127 && y==49) begin	plot <= 1'b1;	end
		else if(x==128 && y==49) begin	plot <= 1'b1;	end
		else if(x==129 && y==49) begin	plot <= 1'b1;	end
		else if(x==130 && y==49) begin	plot <= 1'b1;	end
		else if(x==131 && y==49) begin	plot <= 1'b1;	end
		else if(x==132 && y==49) begin	plot <= 1'b1;	end
		else if(x==133 && y==49) begin	plot <= 1'b1;	end
		else if(x==134 && y==49) begin	plot <= 1'b1;	end
		else if(x==135 && y==49) begin	plot <= 1'b1;	end
		else if(x==136 && y==49) begin	plot <= 1'b1;	end
		else if(x==137 && y==49) begin	plot <= 1'b1;	end
		else if(x==147 && y==49) begin	plot <= 1'b1;	end
		else if(x==148 && y==49) begin	plot <= 1'b1;	end
		else if(x==149 && y==49) begin	plot <= 1'b1;	end
		else if(x==150 && y==49) begin	plot <= 1'b1;	end
		else if(x==151 && y==49) begin	plot <= 1'b1;	end
		else if(x==153 && y==49) begin	plot <= 1'b1;	end
		else if(x==154 && y==49) begin	plot <= 1'b1;	end
		else if(x==155 && y==49) begin	plot <= 1'b1;	end
		else if(x==156 && y==49) begin	plot <= 1'b1;	end
		else if(x==157 && y==49) begin	plot <= 1'b1;	end
		else if(x==161 && y==49) begin	plot <= 1'b1;	end
		else if(x==162 && y==49) begin	plot <= 1'b1;	end
		else if(x==163 && y==49) begin	plot <= 1'b1;	end
		else if(x==164 && y==49) begin	plot <= 1'b1;	end
		else if(x==165 && y==49) begin	plot <= 1'b1;	end
		else if(x==167 && y==49) begin	plot <= 1'b1;	end
		else if(x==168 && y==49) begin	plot <= 1'b1;	end
		else if(x==169 && y==49) begin	plot <= 1'b1;	end
		else if(x==170 && y==49) begin	plot <= 1'b1;	end
		else if(x==180 && y==49) begin	plot <= 1'b1;	end
		else if(x==181 && y==49) begin	plot <= 1'b1;	end
		else if(x==182 && y==49) begin	plot <= 1'b1;	end
		else if(x==183 && y==49) begin	plot <= 1'b1;	end
		else if(x==184 && y==49) begin	plot <= 1'b1;	end
		else if(x==185 && y==49) begin	plot <= 1'b1;	end
		else if(x==186 && y==49) begin	plot <= 1'b1;	end
		else if(x==187 && y==49) begin	plot <= 1'b1;	end
		else if(x==188 && y==49) begin	plot <= 1'b1;	end
		else if(x==189 && y==49) begin	plot <= 1'b1;	end
		else if(x==190 && y==49) begin	plot <= 1'b1;	end
		else if(x==194 && y==49) begin	plot <= 1'b1;	end
		else if(x==195 && y==49) begin	plot <= 1'b1;	end
		else if(x==196 && y==49) begin	plot <= 1'b1;	end
		else if(x==197 && y==49) begin	plot <= 1'b1;	end
		else if(x==199 && y==49) begin	plot <= 1'b1;	end
		else if(x==200 && y==49) begin	plot <= 1'b1;	end
		else if(x==201 && y==49) begin	plot <= 1'b1;	end
		else if(x==202 && y==49) begin	plot <= 1'b1;	end
		else if(x==203 && y==49) begin	plot <= 1'b1;	end
		else if(x==206 && y==49) begin	plot <= 1'b1;	end
		else if(x==207 && y==49) begin	plot <= 1'b1;	end
		else if(x==208 && y==49) begin	plot <= 1'b1;	end
		else if(x==209 && y==49) begin	plot <= 1'b1;	end
		else if(x==210 && y==49) begin	plot <= 1'b1;	end
		else if(x==211 && y==49) begin	plot <= 1'b1;	end
		else if(x==214 && y==49) begin	plot <= 1'b1;	end
		else if(x==215 && y==49) begin	plot <= 1'b1;	end
		else if(x==216 && y==49) begin	plot <= 1'b1;	end
		else if(x==217 && y==49) begin	plot <= 1'b1;	end
		else if(x==219 && y==49) begin	plot <= 1'b1;	end
		else if(x==220 && y==49) begin	plot <= 1'b1;	end
		else if(x==221 && y==49) begin	plot <= 1'b1;	end
		else if(x==222 && y==49) begin	plot <= 1'b1;	end
		else if(x==223 && y==49) begin	plot <= 1'b1;	end
		else if(x==226 && y==49) begin	plot <= 1'b1;	end
		else if(x==227 && y==49) begin	plot <= 1'b1;	end
		else if(x==228 && y==49) begin	plot <= 1'b1;	end
		else if(x==229 && y==49) begin	plot <= 1'b1;	end
		else if(x==230 && y==49) begin	plot <= 1'b1;	end
		else if(x==231 && y==49) begin	plot <= 1'b1;	end
		else if(x==232 && y==49) begin	plot <= 1'b1;	end
		else if(x==233 && y==49) begin	plot <= 1'b1;	end
		else if(x==234 && y==49) begin	plot <= 1'b1;	end
		else if(x==235 && y==49) begin	plot <= 1'b1;	end
		else if(x==240 && y==49) begin	plot <= 1'b1;	end
		else if(x==241 && y==49) begin	plot <= 1'b1;	end
		else if(x==242 && y==49) begin	plot <= 1'b1;	end
		else if(x==243 && y==49) begin	plot <= 1'b1;	end
		else if(x==245 && y==49) begin	plot <= 1'b1;	end
		else if(x==246 && y==49) begin	plot <= 1'b1;	end
		else if(x==247 && y==49) begin	plot <= 1'b1;	end
		else if(x==248 && y==49) begin	plot <= 1'b1;	end
		else if(x==249 && y==49) begin	plot <= 1'b1;	end
		else if(x==78 && y==50) begin	plot <= 1'b1;	end
		else if(x==79 && y==50) begin	plot <= 1'b1;	end
		else if(x==80 && y==50) begin	plot <= 1'b1;	end
		else if(x==81 && y==50) begin	plot <= 1'b1;	end
		else if(x==88 && y==50) begin	plot <= 1'b1;	end
		else if(x==89 && y==50) begin	plot <= 1'b1;	end
		else if(x==90 && y==50) begin	plot <= 1'b1;	end
		else if(x==91 && y==50) begin	plot <= 1'b1;	end
		else if(x==92 && y==50) begin	plot <= 1'b1;	end
		else if(x==95 && y==50) begin	plot <= 1'b1;	end
		else if(x==96 && y==50) begin	plot <= 1'b1;	end
		else if(x==97 && y==50) begin	plot <= 1'b1;	end
		else if(x==98 && y==50) begin	plot <= 1'b1;	end
		else if(x==101 && y==50) begin	plot <= 1'b1;	end
		else if(x==102 && y==50) begin	plot <= 1'b1;	end
		else if(x==103 && y==50) begin	plot <= 1'b1;	end
		else if(x==104 && y==50) begin	plot <= 1'b1;	end
		else if(x==105 && y==50) begin	plot <= 1'b1;	end
		else if(x==115 && y==50) begin	plot <= 1'b1;	end
		else if(x==116 && y==50) begin	plot <= 1'b1;	end
		else if(x==117 && y==50) begin	plot <= 1'b1;	end
		else if(x==118 && y==50) begin	plot <= 1'b1;	end
		else if(x==127 && y==50) begin	plot <= 1'b1;	end
		else if(x==128 && y==50) begin	plot <= 1'b1;	end
		else if(x==129 && y==50) begin	plot <= 1'b1;	end
		else if(x==130 && y==50) begin	plot <= 1'b1;	end
		else if(x==131 && y==50) begin	plot <= 1'b1;	end
		else if(x==132 && y==50) begin	plot <= 1'b1;	end
		else if(x==147 && y==50) begin	plot <= 1'b1;	end
		else if(x==148 && y==50) begin	plot <= 1'b1;	end
		else if(x==149 && y==50) begin	plot <= 1'b1;	end
		else if(x==150 && y==50) begin	plot <= 1'b1;	end
		else if(x==151 && y==50) begin	plot <= 1'b1;	end
		else if(x==154 && y==50) begin	plot <= 1'b1;	end
		else if(x==155 && y==50) begin	plot <= 1'b1;	end
		else if(x==156 && y==50) begin	plot <= 1'b1;	end
		else if(x==157 && y==50) begin	plot <= 1'b1;	end
		else if(x==160 && y==50) begin	plot <= 1'b1;	end
		else if(x==161 && y==50) begin	plot <= 1'b1;	end
		else if(x==162 && y==50) begin	plot <= 1'b1;	end
		else if(x==163 && y==50) begin	plot <= 1'b1;	end
		else if(x==164 && y==50) begin	plot <= 1'b1;	end
		else if(x==180 && y==50) begin	plot <= 1'b1;	end
		else if(x==181 && y==50) begin	plot <= 1'b1;	end
		else if(x==182 && y==50) begin	plot <= 1'b1;	end
		else if(x==183 && y==50) begin	plot <= 1'b1;	end
		else if(x==184 && y==50) begin	plot <= 1'b1;	end
		else if(x==187 && y==50) begin	plot <= 1'b1;	end
		else if(x==188 && y==50) begin	plot <= 1'b1;	end
		else if(x==189 && y==50) begin	plot <= 1'b1;	end
		else if(x==190 && y==50) begin	plot <= 1'b1;	end
		else if(x==194 && y==50) begin	plot <= 1'b1;	end
		else if(x==195 && y==50) begin	plot <= 1'b1;	end
		else if(x==196 && y==50) begin	plot <= 1'b1;	end
		else if(x==197 && y==50) begin	plot <= 1'b1;	end
		else if(x==200 && y==50) begin	plot <= 1'b1;	end
		else if(x==201 && y==50) begin	plot <= 1'b1;	end
		else if(x==202 && y==50) begin	plot <= 1'b1;	end
		else if(x==203 && y==50) begin	plot <= 1'b1;	end
		else if(x==206 && y==50) begin	plot <= 1'b1;	end
		else if(x==207 && y==50) begin	plot <= 1'b1;	end
		else if(x==208 && y==50) begin	plot <= 1'b1;	end
		else if(x==209 && y==50) begin	plot <= 1'b1;	end
		else if(x==210 && y==50) begin	plot <= 1'b1;	end
		else if(x==211 && y==50) begin	plot <= 1'b1;	end
		else if(x==214 && y==50) begin	plot <= 1'b1;	end
		else if(x==215 && y==50) begin	plot <= 1'b1;	end
		else if(x==216 && y==50) begin	plot <= 1'b1;	end
		else if(x==219 && y==50) begin	plot <= 1'b1;	end
		else if(x==220 && y==50) begin	plot <= 1'b1;	end
		else if(x==221 && y==50) begin	plot <= 1'b1;	end
		else if(x==222 && y==50) begin	plot <= 1'b1;	end
		else if(x==223 && y==50) begin	plot <= 1'b1;	end
		else if(x==226 && y==50) begin	plot <= 1'b1;	end
		else if(x==227 && y==50) begin	plot <= 1'b1;	end
		else if(x==228 && y==50) begin	plot <= 1'b1;	end
		else if(x==229 && y==50) begin	plot <= 1'b1;	end
		else if(x==230 && y==50) begin	plot <= 1'b1;	end
		else if(x==240 && y==50) begin	plot <= 1'b1;	end
		else if(x==241 && y==50) begin	plot <= 1'b1;	end
		else if(x==242 && y==50) begin	plot <= 1'b1;	end
		else if(x==243 && y==50) begin	plot <= 1'b1;	end
		else if(x==246 && y==50) begin	plot <= 1'b1;	end
		else if(x==247 && y==50) begin	plot <= 1'b1;	end
		else if(x==248 && y==50) begin	plot <= 1'b1;	end
		else if(x==249 && y==50) begin	plot <= 1'b1;	end
		else if(x==79 && y==51) begin	plot <= 1'b1;	end
		else if(x==80 && y==51) begin	plot <= 1'b1;	end
		else if(x==81 && y==51) begin	plot <= 1'b1;	end
		else if(x==88 && y==51) begin	plot <= 1'b1;	end
		else if(x==89 && y==51) begin	plot <= 1'b1;	end
		else if(x==90 && y==51) begin	plot <= 1'b1;	end
		else if(x==91 && y==51) begin	plot <= 1'b1;	end
		else if(x==92 && y==51) begin	plot <= 1'b1;	end
		else if(x==95 && y==51) begin	plot <= 1'b1;	end
		else if(x==96 && y==51) begin	plot <= 1'b1;	end
		else if(x==97 && y==51) begin	plot <= 1'b1;	end
		else if(x==98 && y==51) begin	plot <= 1'b1;	end
		else if(x==101 && y==51) begin	plot <= 1'b1;	end
		else if(x==102 && y==51) begin	plot <= 1'b1;	end
		else if(x==103 && y==51) begin	plot <= 1'b1;	end
		else if(x==104 && y==51) begin	plot <= 1'b1;	end
		else if(x==105 && y==51) begin	plot <= 1'b1;	end
		else if(x==115 && y==51) begin	plot <= 1'b1;	end
		else if(x==116 && y==51) begin	plot <= 1'b1;	end
		else if(x==117 && y==51) begin	plot <= 1'b1;	end
		else if(x==118 && y==51) begin	plot <= 1'b1;	end
		else if(x==127 && y==51) begin	plot <= 1'b1;	end
		else if(x==128 && y==51) begin	plot <= 1'b1;	end
		else if(x==129 && y==51) begin	plot <= 1'b1;	end
		else if(x==130 && y==51) begin	plot <= 1'b1;	end
		else if(x==131 && y==51) begin	plot <= 1'b1;	end
		else if(x==132 && y==51) begin	plot <= 1'b1;	end
		else if(x==147 && y==51) begin	plot <= 1'b1;	end
		else if(x==148 && y==51) begin	plot <= 1'b1;	end
		else if(x==149 && y==51) begin	plot <= 1'b1;	end
		else if(x==150 && y==51) begin	plot <= 1'b1;	end
		else if(x==151 && y==51) begin	plot <= 1'b1;	end
		else if(x==154 && y==51) begin	plot <= 1'b1;	end
		else if(x==155 && y==51) begin	plot <= 1'b1;	end
		else if(x==156 && y==51) begin	plot <= 1'b1;	end
		else if(x==157 && y==51) begin	plot <= 1'b1;	end
		else if(x==160 && y==51) begin	plot <= 1'b1;	end
		else if(x==161 && y==51) begin	plot <= 1'b1;	end
		else if(x==162 && y==51) begin	plot <= 1'b1;	end
		else if(x==163 && y==51) begin	plot <= 1'b1;	end
		else if(x==164 && y==51) begin	plot <= 1'b1;	end
		else if(x==180 && y==51) begin	plot <= 1'b1;	end
		else if(x==181 && y==51) begin	plot <= 1'b1;	end
		else if(x==182 && y==51) begin	plot <= 1'b1;	end
		else if(x==183 && y==51) begin	plot <= 1'b1;	end
		else if(x==184 && y==51) begin	plot <= 1'b1;	end
		else if(x==186 && y==51) begin	plot <= 1'b1;	end
		else if(x==187 && y==51) begin	plot <= 1'b1;	end
		else if(x==188 && y==51) begin	plot <= 1'b1;	end
		else if(x==189 && y==51) begin	plot <= 1'b1;	end
		else if(x==190 && y==51) begin	plot <= 1'b1;	end
		else if(x==194 && y==51) begin	plot <= 1'b1;	end
		else if(x==195 && y==51) begin	plot <= 1'b1;	end
		else if(x==196 && y==51) begin	plot <= 1'b1;	end
		else if(x==197 && y==51) begin	plot <= 1'b1;	end
		else if(x==200 && y==51) begin	plot <= 1'b1;	end
		else if(x==201 && y==51) begin	plot <= 1'b1;	end
		else if(x==202 && y==51) begin	plot <= 1'b1;	end
		else if(x==203 && y==51) begin	plot <= 1'b1;	end
		else if(x==206 && y==51) begin	plot <= 1'b1;	end
		else if(x==207 && y==51) begin	plot <= 1'b1;	end
		else if(x==208 && y==51) begin	plot <= 1'b1;	end
		else if(x==209 && y==51) begin	plot <= 1'b1;	end
		else if(x==210 && y==51) begin	plot <= 1'b1;	end
		else if(x==211 && y==51) begin	plot <= 1'b1;	end
		else if(x==214 && y==51) begin	plot <= 1'b1;	end
		else if(x==215 && y==51) begin	plot <= 1'b1;	end
		else if(x==216 && y==51) begin	plot <= 1'b1;	end
		else if(x==219 && y==51) begin	plot <= 1'b1;	end
		else if(x==220 && y==51) begin	plot <= 1'b1;	end
		else if(x==221 && y==51) begin	plot <= 1'b1;	end
		else if(x==222 && y==51) begin	plot <= 1'b1;	end
		else if(x==223 && y==51) begin	plot <= 1'b1;	end
		else if(x==226 && y==51) begin	plot <= 1'b1;	end
		else if(x==227 && y==51) begin	plot <= 1'b1;	end
		else if(x==228 && y==51) begin	plot <= 1'b1;	end
		else if(x==229 && y==51) begin	plot <= 1'b1;	end
		else if(x==230 && y==51) begin	plot <= 1'b1;	end
		else if(x==240 && y==51) begin	plot <= 1'b1;	end
		else if(x==241 && y==51) begin	plot <= 1'b1;	end
		else if(x==242 && y==51) begin	plot <= 1'b1;	end
		else if(x==243 && y==51) begin	plot <= 1'b1;	end
		else if(x==246 && y==51) begin	plot <= 1'b1;	end
		else if(x==247 && y==51) begin	plot <= 1'b1;	end
		else if(x==248 && y==51) begin	plot <= 1'b1;	end
		else if(x==249 && y==51) begin	plot <= 1'b1;	end
		else if(x==79 && y==52) begin	plot <= 1'b1;	end
		else if(x==80 && y==52) begin	plot <= 1'b1;	end
		else if(x==81 && y==52) begin	plot <= 1'b1;	end
		else if(x==88 && y==52) begin	plot <= 1'b1;	end
		else if(x==89 && y==52) begin	plot <= 1'b1;	end
		else if(x==90 && y==52) begin	plot <= 1'b1;	end
		else if(x==91 && y==52) begin	plot <= 1'b1;	end
		else if(x==92 && y==52) begin	plot <= 1'b1;	end
		else if(x==93 && y==52) begin	plot <= 1'b1;	end
		else if(x==94 && y==52) begin	plot <= 1'b1;	end
		else if(x==95 && y==52) begin	plot <= 1'b1;	end
		else if(x==96 && y==52) begin	plot <= 1'b1;	end
		else if(x==97 && y==52) begin	plot <= 1'b1;	end
		else if(x==98 && y==52) begin	plot <= 1'b1;	end
		else if(x==101 && y==52) begin	plot <= 1'b1;	end
		else if(x==102 && y==52) begin	plot <= 1'b1;	end
		else if(x==103 && y==52) begin	plot <= 1'b1;	end
		else if(x==104 && y==52) begin	plot <= 1'b1;	end
		else if(x==105 && y==52) begin	plot <= 1'b1;	end
		else if(x==115 && y==52) begin	plot <= 1'b1;	end
		else if(x==116 && y==52) begin	plot <= 1'b1;	end
		else if(x==117 && y==52) begin	plot <= 1'b1;	end
		else if(x==118 && y==52) begin	plot <= 1'b1;	end
		else if(x==119 && y==52) begin	plot <= 1'b1;	end
		else if(x==120 && y==52) begin	plot <= 1'b1;	end
		else if(x==121 && y==52) begin	plot <= 1'b1;	end
		else if(x==127 && y==52) begin	plot <= 1'b1;	end
		else if(x==128 && y==52) begin	plot <= 1'b1;	end
		else if(x==129 && y==52) begin	plot <= 1'b1;	end
		else if(x==130 && y==52) begin	plot <= 1'b1;	end
		else if(x==131 && y==52) begin	plot <= 1'b1;	end
		else if(x==132 && y==52) begin	plot <= 1'b1;	end
		else if(x==133 && y==52) begin	plot <= 1'b1;	end
		else if(x==134 && y==52) begin	plot <= 1'b1;	end
		else if(x==135 && y==52) begin	plot <= 1'b1;	end
		else if(x==136 && y==52) begin	plot <= 1'b1;	end
		else if(x==137 && y==52) begin	plot <= 1'b1;	end
		else if(x==147 && y==52) begin	plot <= 1'b1;	end
		else if(x==148 && y==52) begin	plot <= 1'b1;	end
		else if(x==149 && y==52) begin	plot <= 1'b1;	end
		else if(x==150 && y==52) begin	plot <= 1'b1;	end
		else if(x==151 && y==52) begin	plot <= 1'b1;	end
		else if(x==154 && y==52) begin	plot <= 1'b1;	end
		else if(x==155 && y==52) begin	plot <= 1'b1;	end
		else if(x==156 && y==52) begin	plot <= 1'b1;	end
		else if(x==157 && y==52) begin	plot <= 1'b1;	end
		else if(x==160 && y==52) begin	plot <= 1'b1;	end
		else if(x==161 && y==52) begin	plot <= 1'b1;	end
		else if(x==162 && y==52) begin	plot <= 1'b1;	end
		else if(x==163 && y==52) begin	plot <= 1'b1;	end
		else if(x==164 && y==52) begin	plot <= 1'b1;	end
		else if(x==165 && y==52) begin	plot <= 1'b1;	end
		else if(x==166 && y==52) begin	plot <= 1'b1;	end
		else if(x==167 && y==52) begin	plot <= 1'b1;	end
		else if(x==180 && y==52) begin	plot <= 1'b1;	end
		else if(x==181 && y==52) begin	plot <= 1'b1;	end
		else if(x==182 && y==52) begin	plot <= 1'b1;	end
		else if(x==183 && y==52) begin	plot <= 1'b1;	end
		else if(x==184 && y==52) begin	plot <= 1'b1;	end
		else if(x==185 && y==52) begin	plot <= 1'b1;	end
		else if(x==186 && y==52) begin	plot <= 1'b1;	end
		else if(x==187 && y==52) begin	plot <= 1'b1;	end
		else if(x==188 && y==52) begin	plot <= 1'b1;	end
		else if(x==189 && y==52) begin	plot <= 1'b1;	end
		else if(x==194 && y==52) begin	plot <= 1'b1;	end
		else if(x==195 && y==52) begin	plot <= 1'b1;	end
		else if(x==196 && y==52) begin	plot <= 1'b1;	end
		else if(x==197 && y==52) begin	plot <= 1'b1;	end
		else if(x==198 && y==52) begin	plot <= 1'b1;	end
		else if(x==199 && y==52) begin	plot <= 1'b1;	end
		else if(x==200 && y==52) begin	plot <= 1'b1;	end
		else if(x==201 && y==52) begin	plot <= 1'b1;	end
		else if(x==202 && y==52) begin	plot <= 1'b1;	end
		else if(x==203 && y==52) begin	plot <= 1'b1;	end
		else if(x==206 && y==52) begin	plot <= 1'b1;	end
		else if(x==207 && y==52) begin	plot <= 1'b1;	end
		else if(x==208 && y==52) begin	plot <= 1'b1;	end
		else if(x==209 && y==52) begin	plot <= 1'b1;	end
		else if(x==210 && y==52) begin	plot <= 1'b1;	end
		else if(x==211 && y==52) begin	plot <= 1'b1;	end
		else if(x==214 && y==52) begin	plot <= 1'b1;	end
		else if(x==215 && y==52) begin	plot <= 1'b1;	end
		else if(x==216 && y==52) begin	plot <= 1'b1;	end
		else if(x==219 && y==52) begin	plot <= 1'b1;	end
		else if(x==220 && y==52) begin	plot <= 1'b1;	end
		else if(x==221 && y==52) begin	plot <= 1'b1;	end
		else if(x==222 && y==52) begin	plot <= 1'b1;	end
		else if(x==223 && y==52) begin	plot <= 1'b1;	end
		else if(x==226 && y==52) begin	plot <= 1'b1;	end
		else if(x==227 && y==52) begin	plot <= 1'b1;	end
		else if(x==228 && y==52) begin	plot <= 1'b1;	end
		else if(x==229 && y==52) begin	plot <= 1'b1;	end
		else if(x==230 && y==52) begin	plot <= 1'b1;	end
		else if(x==231 && y==52) begin	plot <= 1'b1;	end
		else if(x==232 && y==52) begin	plot <= 1'b1;	end
		else if(x==233 && y==52) begin	plot <= 1'b1;	end
		else if(x==240 && y==52) begin	plot <= 1'b1;	end
		else if(x==241 && y==52) begin	plot <= 1'b1;	end
		else if(x==242 && y==52) begin	plot <= 1'b1;	end
		else if(x==243 && y==52) begin	plot <= 1'b1;	end
		else if(x==246 && y==52) begin	plot <= 1'b1;	end
		else if(x==247 && y==52) begin	plot <= 1'b1;	end
		else if(x==248 && y==52) begin	plot <= 1'b1;	end
		else if(x==249 && y==52) begin	plot <= 1'b1;	end
		else if(x==79 && y==53) begin	plot <= 1'b1;	end
		else if(x==80 && y==53) begin	plot <= 1'b1;	end
		else if(x==81 && y==53) begin	plot <= 1'b1;	end
		else if(x==88 && y==53) begin	plot <= 1'b1;	end
		else if(x==89 && y==53) begin	plot <= 1'b1;	end
		else if(x==90 && y==53) begin	plot <= 1'b1;	end
		else if(x==91 && y==53) begin	plot <= 1'b1;	end
		else if(x==92 && y==53) begin	plot <= 1'b1;	end
		else if(x==93 && y==53) begin	plot <= 1'b1;	end
		else if(x==94 && y==53) begin	plot <= 1'b1;	end
		else if(x==95 && y==53) begin	plot <= 1'b1;	end
		else if(x==96 && y==53) begin	plot <= 1'b1;	end
		else if(x==97 && y==53) begin	plot <= 1'b1;	end
		else if(x==98 && y==53) begin	plot <= 1'b1;	end
		else if(x==101 && y==53) begin	plot <= 1'b1;	end
		else if(x==102 && y==53) begin	plot <= 1'b1;	end
		else if(x==103 && y==53) begin	plot <= 1'b1;	end
		else if(x==104 && y==53) begin	plot <= 1'b1;	end
		else if(x==105 && y==53) begin	plot <= 1'b1;	end
		else if(x==115 && y==53) begin	plot <= 1'b1;	end
		else if(x==116 && y==53) begin	plot <= 1'b1;	end
		else if(x==117 && y==53) begin	plot <= 1'b1;	end
		else if(x==118 && y==53) begin	plot <= 1'b1;	end
		else if(x==119 && y==53) begin	plot <= 1'b1;	end
		else if(x==120 && y==53) begin	plot <= 1'b1;	end
		else if(x==129 && y==53) begin	plot <= 1'b1;	end
		else if(x==130 && y==53) begin	plot <= 1'b1;	end
		else if(x==131 && y==53) begin	plot <= 1'b1;	end
		else if(x==132 && y==53) begin	plot <= 1'b1;	end
		else if(x==133 && y==53) begin	plot <= 1'b1;	end
		else if(x==134 && y==53) begin	plot <= 1'b1;	end
		else if(x==135 && y==53) begin	plot <= 1'b1;	end
		else if(x==136 && y==53) begin	plot <= 1'b1;	end
		else if(x==137 && y==53) begin	plot <= 1'b1;	end
		else if(x==147 && y==53) begin	plot <= 1'b1;	end
		else if(x==148 && y==53) begin	plot <= 1'b1;	end
		else if(x==149 && y==53) begin	plot <= 1'b1;	end
		else if(x==150 && y==53) begin	plot <= 1'b1;	end
		else if(x==151 && y==53) begin	plot <= 1'b1;	end
		else if(x==154 && y==53) begin	plot <= 1'b1;	end
		else if(x==155 && y==53) begin	plot <= 1'b1;	end
		else if(x==156 && y==53) begin	plot <= 1'b1;	end
		else if(x==157 && y==53) begin	plot <= 1'b1;	end
		else if(x==160 && y==53) begin	plot <= 1'b1;	end
		else if(x==161 && y==53) begin	plot <= 1'b1;	end
		else if(x==162 && y==53) begin	plot <= 1'b1;	end
		else if(x==163 && y==53) begin	plot <= 1'b1;	end
		else if(x==164 && y==53) begin	plot <= 1'b1;	end
		else if(x==165 && y==53) begin	plot <= 1'b1;	end
		else if(x==166 && y==53) begin	plot <= 1'b1;	end
		else if(x==180 && y==53) begin	plot <= 1'b1;	end
		else if(x==181 && y==53) begin	plot <= 1'b1;	end
		else if(x==182 && y==53) begin	plot <= 1'b1;	end
		else if(x==183 && y==53) begin	plot <= 1'b1;	end
		else if(x==184 && y==53) begin	plot <= 1'b1;	end
		else if(x==185 && y==53) begin	plot <= 1'b1;	end
		else if(x==186 && y==53) begin	plot <= 1'b1;	end
		else if(x==187 && y==53) begin	plot <= 1'b1;	end
		else if(x==188 && y==53) begin	plot <= 1'b1;	end
		else if(x==189 && y==53) begin	plot <= 1'b1;	end
		else if(x==194 && y==53) begin	plot <= 1'b1;	end
		else if(x==195 && y==53) begin	plot <= 1'b1;	end
		else if(x==196 && y==53) begin	plot <= 1'b1;	end
		else if(x==197 && y==53) begin	plot <= 1'b1;	end
		else if(x==198 && y==53) begin	plot <= 1'b1;	end
		else if(x==199 && y==53) begin	plot <= 1'b1;	end
		else if(x==200 && y==53) begin	plot <= 1'b1;	end
		else if(x==201 && y==53) begin	plot <= 1'b1;	end
		else if(x==202 && y==53) begin	plot <= 1'b1;	end
		else if(x==203 && y==53) begin	plot <= 1'b1;	end
		else if(x==206 && y==53) begin	plot <= 1'b1;	end
		else if(x==207 && y==53) begin	plot <= 1'b1;	end
		else if(x==208 && y==53) begin	plot <= 1'b1;	end
		else if(x==209 && y==53) begin	plot <= 1'b1;	end
		else if(x==210 && y==53) begin	plot <= 1'b1;	end
		else if(x==211 && y==53) begin	plot <= 1'b1;	end
		else if(x==214 && y==53) begin	plot <= 1'b1;	end
		else if(x==215 && y==53) begin	plot <= 1'b1;	end
		else if(x==216 && y==53) begin	plot <= 1'b1;	end
		else if(x==219 && y==53) begin	plot <= 1'b1;	end
		else if(x==220 && y==53) begin	plot <= 1'b1;	end
		else if(x==221 && y==53) begin	plot <= 1'b1;	end
		else if(x==222 && y==53) begin	plot <= 1'b1;	end
		else if(x==223 && y==53) begin	plot <= 1'b1;	end
		else if(x==226 && y==53) begin	plot <= 1'b1;	end
		else if(x==227 && y==53) begin	plot <= 1'b1;	end
		else if(x==228 && y==53) begin	plot <= 1'b1;	end
		else if(x==229 && y==53) begin	plot <= 1'b1;	end
		else if(x==230 && y==53) begin	plot <= 1'b1;	end
		else if(x==231 && y==53) begin	plot <= 1'b1;	end
		else if(x==232 && y==53) begin	plot <= 1'b1;	end
		else if(x==233 && y==53) begin	plot <= 1'b1;	end
		else if(x==240 && y==53) begin	plot <= 1'b1;	end
		else if(x==241 && y==53) begin	plot <= 1'b1;	end
		else if(x==242 && y==53) begin	plot <= 1'b1;	end
		else if(x==243 && y==53) begin	plot <= 1'b1;	end
		else if(x==246 && y==53) begin	plot <= 1'b1;	end
		else if(x==247 && y==53) begin	plot <= 1'b1;	end
		else if(x==248 && y==53) begin	plot <= 1'b1;	end
		else if(x==249 && y==53) begin	plot <= 1'b1;	end
		else if(x==79 && y==54) begin	plot <= 1'b1;	end
		else if(x==80 && y==54) begin	plot <= 1'b1;	end
		else if(x==81 && y==54) begin	plot <= 1'b1;	end
		else if(x==88 && y==54) begin	plot <= 1'b1;	end
		else if(x==89 && y==54) begin	plot <= 1'b1;	end
		else if(x==90 && y==54) begin	plot <= 1'b1;	end
		else if(x==91 && y==54) begin	plot <= 1'b1;	end
		else if(x==92 && y==54) begin	plot <= 1'b1;	end
		else if(x==95 && y==54) begin	plot <= 1'b1;	end
		else if(x==96 && y==54) begin	plot <= 1'b1;	end
		else if(x==97 && y==54) begin	plot <= 1'b1;	end
		else if(x==98 && y==54) begin	plot <= 1'b1;	end
		else if(x==101 && y==54) begin	plot <= 1'b1;	end
		else if(x==102 && y==54) begin	plot <= 1'b1;	end
		else if(x==103 && y==54) begin	plot <= 1'b1;	end
		else if(x==104 && y==54) begin	plot <= 1'b1;	end
		else if(x==105 && y==54) begin	plot <= 1'b1;	end
		else if(x==115 && y==54) begin	plot <= 1'b1;	end
		else if(x==116 && y==54) begin	plot <= 1'b1;	end
		else if(x==117 && y==54) begin	plot <= 1'b1;	end
		else if(x==118 && y==54) begin	plot <= 1'b1;	end
		else if(x==134 && y==54) begin	plot <= 1'b1;	end
		else if(x==135 && y==54) begin	plot <= 1'b1;	end
		else if(x==136 && y==54) begin	plot <= 1'b1;	end
		else if(x==137 && y==54) begin	plot <= 1'b1;	end
		else if(x==138 && y==54) begin	plot <= 1'b1;	end
		else if(x==147 && y==54) begin	plot <= 1'b1;	end
		else if(x==148 && y==54) begin	plot <= 1'b1;	end
		else if(x==149 && y==54) begin	plot <= 1'b1;	end
		else if(x==150 && y==54) begin	plot <= 1'b1;	end
		else if(x==151 && y==54) begin	plot <= 1'b1;	end
		else if(x==154 && y==54) begin	plot <= 1'b1;	end
		else if(x==155 && y==54) begin	plot <= 1'b1;	end
		else if(x==156 && y==54) begin	plot <= 1'b1;	end
		else if(x==157 && y==54) begin	plot <= 1'b1;	end
		else if(x==160 && y==54) begin	plot <= 1'b1;	end
		else if(x==161 && y==54) begin	plot <= 1'b1;	end
		else if(x==162 && y==54) begin	plot <= 1'b1;	end
		else if(x==163 && y==54) begin	plot <= 1'b1;	end
		else if(x==164 && y==54) begin	plot <= 1'b1;	end
		else if(x==180 && y==54) begin	plot <= 1'b1;	end
		else if(x==181 && y==54) begin	plot <= 1'b1;	end
		else if(x==182 && y==54) begin	plot <= 1'b1;	end
		else if(x==183 && y==54) begin	plot <= 1'b1;	end
		else if(x==184 && y==54) begin	plot <= 1'b1;	end
		else if(x==187 && y==54) begin	plot <= 1'b1;	end
		else if(x==188 && y==54) begin	plot <= 1'b1;	end
		else if(x==189 && y==54) begin	plot <= 1'b1;	end
		else if(x==194 && y==54) begin	plot <= 1'b1;	end
		else if(x==195 && y==54) begin	plot <= 1'b1;	end
		else if(x==196 && y==54) begin	plot <= 1'b1;	end
		else if(x==197 && y==54) begin	plot <= 1'b1;	end
		else if(x==200 && y==54) begin	plot <= 1'b1;	end
		else if(x==201 && y==54) begin	plot <= 1'b1;	end
		else if(x==202 && y==54) begin	plot <= 1'b1;	end
		else if(x==203 && y==54) begin	plot <= 1'b1;	end
		else if(x==206 && y==54) begin	plot <= 1'b1;	end
		else if(x==207 && y==54) begin	plot <= 1'b1;	end
		else if(x==208 && y==54) begin	plot <= 1'b1;	end
		else if(x==209 && y==54) begin	plot <= 1'b1;	end
		else if(x==210 && y==54) begin	plot <= 1'b1;	end
		else if(x==211 && y==54) begin	plot <= 1'b1;	end
		else if(x==214 && y==54) begin	plot <= 1'b1;	end
		else if(x==215 && y==54) begin	plot <= 1'b1;	end
		else if(x==216 && y==54) begin	plot <= 1'b1;	end
		else if(x==219 && y==54) begin	plot <= 1'b1;	end
		else if(x==220 && y==54) begin	plot <= 1'b1;	end
		else if(x==221 && y==54) begin	plot <= 1'b1;	end
		else if(x==222 && y==54) begin	plot <= 1'b1;	end
		else if(x==223 && y==54) begin	plot <= 1'b1;	end
		else if(x==226 && y==54) begin	plot <= 1'b1;	end
		else if(x==227 && y==54) begin	plot <= 1'b1;	end
		else if(x==228 && y==54) begin	plot <= 1'b1;	end
		else if(x==229 && y==54) begin	plot <= 1'b1;	end
		else if(x==230 && y==54) begin	plot <= 1'b1;	end
		else if(x==240 && y==54) begin	plot <= 1'b1;	end
		else if(x==241 && y==54) begin	plot <= 1'b1;	end
		else if(x==242 && y==54) begin	plot <= 1'b1;	end
		else if(x==243 && y==54) begin	plot <= 1'b1;	end
		else if(x==246 && y==54) begin	plot <= 1'b1;	end
		else if(x==247 && y==54) begin	plot <= 1'b1;	end
		else if(x==248 && y==54) begin	plot <= 1'b1;	end
		else if(x==249 && y==54) begin	plot <= 1'b1;	end
		else if(x==79 && y==55) begin	plot <= 1'b1;	end
		else if(x==80 && y==55) begin	plot <= 1'b1;	end
		else if(x==81 && y==55) begin	plot <= 1'b1;	end
		else if(x==88 && y==55) begin	plot <= 1'b1;	end
		else if(x==89 && y==55) begin	plot <= 1'b1;	end
		else if(x==90 && y==55) begin	plot <= 1'b1;	end
		else if(x==91 && y==55) begin	plot <= 1'b1;	end
		else if(x==92 && y==55) begin	plot <= 1'b1;	end
		else if(x==95 && y==55) begin	plot <= 1'b1;	end
		else if(x==96 && y==55) begin	plot <= 1'b1;	end
		else if(x==97 && y==55) begin	plot <= 1'b1;	end
		else if(x==98 && y==55) begin	plot <= 1'b1;	end
		else if(x==101 && y==55) begin	plot <= 1'b1;	end
		else if(x==102 && y==55) begin	plot <= 1'b1;	end
		else if(x==103 && y==55) begin	plot <= 1'b1;	end
		else if(x==104 && y==55) begin	plot <= 1'b1;	end
		else if(x==105 && y==55) begin	plot <= 1'b1;	end
		else if(x==115 && y==55) begin	plot <= 1'b1;	end
		else if(x==116 && y==55) begin	plot <= 1'b1;	end
		else if(x==117 && y==55) begin	plot <= 1'b1;	end
		else if(x==118 && y==55) begin	plot <= 1'b1;	end
		else if(x==134 && y==55) begin	plot <= 1'b1;	end
		else if(x==135 && y==55) begin	plot <= 1'b1;	end
		else if(x==136 && y==55) begin	plot <= 1'b1;	end
		else if(x==137 && y==55) begin	plot <= 1'b1;	end
		else if(x==138 && y==55) begin	plot <= 1'b1;	end
		else if(x==147 && y==55) begin	plot <= 1'b1;	end
		else if(x==148 && y==55) begin	plot <= 1'b1;	end
		else if(x==149 && y==55) begin	plot <= 1'b1;	end
		else if(x==150 && y==55) begin	plot <= 1'b1;	end
		else if(x==151 && y==55) begin	plot <= 1'b1;	end
		else if(x==154 && y==55) begin	plot <= 1'b1;	end
		else if(x==155 && y==55) begin	plot <= 1'b1;	end
		else if(x==156 && y==55) begin	plot <= 1'b1;	end
		else if(x==157 && y==55) begin	plot <= 1'b1;	end
		else if(x==160 && y==55) begin	plot <= 1'b1;	end
		else if(x==161 && y==55) begin	plot <= 1'b1;	end
		else if(x==162 && y==55) begin	plot <= 1'b1;	end
		else if(x==163 && y==55) begin	plot <= 1'b1;	end
		else if(x==164 && y==55) begin	plot <= 1'b1;	end
		else if(x==180 && y==55) begin	plot <= 1'b1;	end
		else if(x==181 && y==55) begin	plot <= 1'b1;	end
		else if(x==182 && y==55) begin	plot <= 1'b1;	end
		else if(x==183 && y==55) begin	plot <= 1'b1;	end
		else if(x==184 && y==55) begin	plot <= 1'b1;	end
		else if(x==187 && y==55) begin	plot <= 1'b1;	end
		else if(x==188 && y==55) begin	plot <= 1'b1;	end
		else if(x==189 && y==55) begin	plot <= 1'b1;	end
		else if(x==190 && y==55) begin	plot <= 1'b1;	end
		else if(x==194 && y==55) begin	plot <= 1'b1;	end
		else if(x==195 && y==55) begin	plot <= 1'b1;	end
		else if(x==196 && y==55) begin	plot <= 1'b1;	end
		else if(x==197 && y==55) begin	plot <= 1'b1;	end
		else if(x==200 && y==55) begin	plot <= 1'b1;	end
		else if(x==201 && y==55) begin	plot <= 1'b1;	end
		else if(x==202 && y==55) begin	plot <= 1'b1;	end
		else if(x==203 && y==55) begin	plot <= 1'b1;	end
		else if(x==206 && y==55) begin	plot <= 1'b1;	end
		else if(x==207 && y==55) begin	plot <= 1'b1;	end
		else if(x==208 && y==55) begin	plot <= 1'b1;	end
		else if(x==209 && y==55) begin	plot <= 1'b1;	end
		else if(x==210 && y==55) begin	plot <= 1'b1;	end
		else if(x==211 && y==55) begin	plot <= 1'b1;	end
		else if(x==214 && y==55) begin	plot <= 1'b1;	end
		else if(x==215 && y==55) begin	plot <= 1'b1;	end
		else if(x==216 && y==55) begin	plot <= 1'b1;	end
		else if(x==219 && y==55) begin	plot <= 1'b1;	end
		else if(x==220 && y==55) begin	plot <= 1'b1;	end
		else if(x==221 && y==55) begin	plot <= 1'b1;	end
		else if(x==222 && y==55) begin	plot <= 1'b1;	end
		else if(x==223 && y==55) begin	plot <= 1'b1;	end
		else if(x==226 && y==55) begin	plot <= 1'b1;	end
		else if(x==227 && y==55) begin	plot <= 1'b1;	end
		else if(x==228 && y==55) begin	plot <= 1'b1;	end
		else if(x==229 && y==55) begin	plot <= 1'b1;	end
		else if(x==230 && y==55) begin	plot <= 1'b1;	end
		else if(x==240 && y==55) begin	plot <= 1'b1;	end
		else if(x==241 && y==55) begin	plot <= 1'b1;	end
		else if(x==242 && y==55) begin	plot <= 1'b1;	end
		else if(x==243 && y==55) begin	plot <= 1'b1;	end
		else if(x==246 && y==55) begin	plot <= 1'b1;	end
		else if(x==247 && y==55) begin	plot <= 1'b1;	end
		else if(x==248 && y==55) begin	plot <= 1'b1;	end
		else if(x==249 && y==55) begin	plot <= 1'b1;	end
		else if(x==79 && y==56) begin	plot <= 1'b1;	end
		else if(x==80 && y==56) begin	plot <= 1'b1;	end
		else if(x==81 && y==56) begin	plot <= 1'b1;	end
		else if(x==88 && y==56) begin	plot <= 1'b1;	end
		else if(x==89 && y==56) begin	plot <= 1'b1;	end
		else if(x==90 && y==56) begin	plot <= 1'b1;	end
		else if(x==91 && y==56) begin	plot <= 1'b1;	end
		else if(x==92 && y==56) begin	plot <= 1'b1;	end
		else if(x==95 && y==56) begin	plot <= 1'b1;	end
		else if(x==96 && y==56) begin	plot <= 1'b1;	end
		else if(x==97 && y==56) begin	plot <= 1'b1;	end
		else if(x==98 && y==56) begin	plot <= 1'b1;	end
		else if(x==101 && y==56) begin	plot <= 1'b1;	end
		else if(x==102 && y==56) begin	plot <= 1'b1;	end
		else if(x==103 && y==56) begin	plot <= 1'b1;	end
		else if(x==104 && y==56) begin	plot <= 1'b1;	end
		else if(x==105 && y==56) begin	plot <= 1'b1;	end
		else if(x==106 && y==56) begin	plot <= 1'b1;	end
		else if(x==107 && y==56) begin	plot <= 1'b1;	end
		else if(x==108 && y==56) begin	plot <= 1'b1;	end
		else if(x==109 && y==56) begin	plot <= 1'b1;	end
		else if(x==110 && y==56) begin	plot <= 1'b1;	end
		else if(x==115 && y==56) begin	plot <= 1'b1;	end
		else if(x==116 && y==56) begin	plot <= 1'b1;	end
		else if(x==117 && y==56) begin	plot <= 1'b1;	end
		else if(x==118 && y==56) begin	plot <= 1'b1;	end
		else if(x==119 && y==56) begin	plot <= 1'b1;	end
		else if(x==120 && y==56) begin	plot <= 1'b1;	end
		else if(x==121 && y==56) begin	plot <= 1'b1;	end
		else if(x==122 && y==56) begin	plot <= 1'b1;	end
		else if(x==123 && y==56) begin	plot <= 1'b1;	end
		else if(x==124 && y==56) begin	plot <= 1'b1;	end
		else if(x==128 && y==56) begin	plot <= 1'b1;	end
		else if(x==129 && y==56) begin	plot <= 1'b1;	end
		else if(x==130 && y==56) begin	plot <= 1'b1;	end
		else if(x==131 && y==56) begin	plot <= 1'b1;	end
		else if(x==132 && y==56) begin	plot <= 1'b1;	end
		else if(x==133 && y==56) begin	plot <= 1'b1;	end
		else if(x==134 && y==56) begin	plot <= 1'b1;	end
		else if(x==135 && y==56) begin	plot <= 1'b1;	end
		else if(x==136 && y==56) begin	plot <= 1'b1;	end
		else if(x==137 && y==56) begin	plot <= 1'b1;	end
		else if(x==147 && y==56) begin	plot <= 1'b1;	end
		else if(x==148 && y==56) begin	plot <= 1'b1;	end
		else if(x==149 && y==56) begin	plot <= 1'b1;	end
		else if(x==150 && y==56) begin	plot <= 1'b1;	end
		else if(x==151 && y==56) begin	plot <= 1'b1;	end
		else if(x==152 && y==56) begin	plot <= 1'b1;	end
		else if(x==153 && y==56) begin	plot <= 1'b1;	end
		else if(x==154 && y==56) begin	plot <= 1'b1;	end
		else if(x==155 && y==56) begin	plot <= 1'b1;	end
		else if(x==156 && y==56) begin	plot <= 1'b1;	end
		else if(x==157 && y==56) begin	plot <= 1'b1;	end
		else if(x==160 && y==56) begin	plot <= 1'b1;	end
		else if(x==161 && y==56) begin	plot <= 1'b1;	end
		else if(x==162 && y==56) begin	plot <= 1'b1;	end
		else if(x==163 && y==56) begin	plot <= 1'b1;	end
		else if(x==164 && y==56) begin	plot <= 1'b1;	end
		else if(x==180 && y==56) begin	plot <= 1'b1;	end
		else if(x==181 && y==56) begin	plot <= 1'b1;	end
		else if(x==182 && y==56) begin	plot <= 1'b1;	end
		else if(x==183 && y==56) begin	plot <= 1'b1;	end
		else if(x==184 && y==56) begin	plot <= 1'b1;	end
		else if(x==187 && y==56) begin	plot <= 1'b1;	end
		else if(x==188 && y==56) begin	plot <= 1'b1;	end
		else if(x==189 && y==56) begin	plot <= 1'b1;	end
		else if(x==190 && y==56) begin	plot <= 1'b1;	end
		else if(x==194 && y==56) begin	plot <= 1'b1;	end
		else if(x==195 && y==56) begin	plot <= 1'b1;	end
		else if(x==196 && y==56) begin	plot <= 1'b1;	end
		else if(x==197 && y==56) begin	plot <= 1'b1;	end
		else if(x==200 && y==56) begin	plot <= 1'b1;	end
		else if(x==201 && y==56) begin	plot <= 1'b1;	end
		else if(x==202 && y==56) begin	plot <= 1'b1;	end
		else if(x==203 && y==56) begin	plot <= 1'b1;	end
		else if(x==206 && y==56) begin	plot <= 1'b1;	end
		else if(x==207 && y==56) begin	plot <= 1'b1;	end
		else if(x==208 && y==56) begin	plot <= 1'b1;	end
		else if(x==209 && y==56) begin	plot <= 1'b1;	end
		else if(x==210 && y==56) begin	plot <= 1'b1;	end
		else if(x==211 && y==56) begin	plot <= 1'b1;	end
		else if(x==214 && y==56) begin	plot <= 1'b1;	end
		else if(x==215 && y==56) begin	plot <= 1'b1;	end
		else if(x==216 && y==56) begin	plot <= 1'b1;	end
		else if(x==217 && y==56) begin	plot <= 1'b1;	end
		else if(x==218 && y==56) begin	plot <= 1'b1;	end
		else if(x==219 && y==56) begin	plot <= 1'b1;	end
		else if(x==220 && y==56) begin	plot <= 1'b1;	end
		else if(x==221 && y==56) begin	plot <= 1'b1;	end
		else if(x==222 && y==56) begin	plot <= 1'b1;	end
		else if(x==223 && y==56) begin	plot <= 1'b1;	end
		else if(x==226 && y==56) begin	plot <= 1'b1;	end
		else if(x==227 && y==56) begin	plot <= 1'b1;	end
		else if(x==228 && y==56) begin	plot <= 1'b1;	end
		else if(x==229 && y==56) begin	plot <= 1'b1;	end
		else if(x==230 && y==56) begin	plot <= 1'b1;	end
		else if(x==231 && y==56) begin	plot <= 1'b1;	end
		else if(x==232 && y==56) begin	plot <= 1'b1;	end
		else if(x==233 && y==56) begin	plot <= 1'b1;	end
		else if(x==234 && y==56) begin	plot <= 1'b1;	end
		else if(x==235 && y==56) begin	plot <= 1'b1;	end
		else if(x==240 && y==56) begin	plot <= 1'b1;	end
		else if(x==241 && y==56) begin	plot <= 1'b1;	end
		else if(x==242 && y==56) begin	plot <= 1'b1;	end
		else if(x==243 && y==56) begin	plot <= 1'b1;	end
		else if(x==246 && y==56) begin	plot <= 1'b1;	end
		else if(x==247 && y==56) begin	plot <= 1'b1;	end
		else if(x==248 && y==56) begin	plot <= 1'b1;	end
		else if(x==249 && y==56) begin	plot <= 1'b1;	end
		else if(x==79 && y==57) begin	plot <= 1'b1;	end
		else if(x==80 && y==57) begin	plot <= 1'b1;	end
		else if(x==81 && y==57) begin	plot <= 1'b1;	end
		else if(x==88 && y==57) begin	plot <= 1'b1;	end
		else if(x==89 && y==57) begin	plot <= 1'b1;	end
		else if(x==90 && y==57) begin	plot <= 1'b1;	end
		else if(x==91 && y==57) begin	plot <= 1'b1;	end
		else if(x==92 && y==57) begin	plot <= 1'b1;	end
		else if(x==95 && y==57) begin	plot <= 1'b1;	end
		else if(x==96 && y==57) begin	plot <= 1'b1;	end
		else if(x==97 && y==57) begin	plot <= 1'b1;	end
		else if(x==98 && y==57) begin	plot <= 1'b1;	end
		else if(x==101 && y==57) begin	plot <= 1'b1;	end
		else if(x==102 && y==57) begin	plot <= 1'b1;	end
		else if(x==103 && y==57) begin	plot <= 1'b1;	end
		else if(x==104 && y==57) begin	plot <= 1'b1;	end
		else if(x==105 && y==57) begin	plot <= 1'b1;	end
		else if(x==106 && y==57) begin	plot <= 1'b1;	end
		else if(x==107 && y==57) begin	plot <= 1'b1;	end
		else if(x==108 && y==57) begin	plot <= 1'b1;	end
		else if(x==109 && y==57) begin	plot <= 1'b1;	end
		else if(x==110 && y==57) begin	plot <= 1'b1;	end
		else if(x==111 && y==57) begin	plot <= 1'b1;	end
		else if(x==115 && y==57) begin	plot <= 1'b1;	end
		else if(x==116 && y==57) begin	plot <= 1'b1;	end
		else if(x==117 && y==57) begin	plot <= 1'b1;	end
		else if(x==118 && y==57) begin	plot <= 1'b1;	end
		else if(x==119 && y==57) begin	plot <= 1'b1;	end
		else if(x==120 && y==57) begin	plot <= 1'b1;	end
		else if(x==121 && y==57) begin	plot <= 1'b1;	end
		else if(x==122 && y==57) begin	plot <= 1'b1;	end
		else if(x==123 && y==57) begin	plot <= 1'b1;	end
		else if(x==124 && y==57) begin	plot <= 1'b1;	end
		else if(x==127 && y==57) begin	plot <= 1'b1;	end
		else if(x==128 && y==57) begin	plot <= 1'b1;	end
		else if(x==129 && y==57) begin	plot <= 1'b1;	end
		else if(x==130 && y==57) begin	plot <= 1'b1;	end
		else if(x==131 && y==57) begin	plot <= 1'b1;	end
		else if(x==132 && y==57) begin	plot <= 1'b1;	end
		else if(x==133 && y==57) begin	plot <= 1'b1;	end
		else if(x==134 && y==57) begin	plot <= 1'b1;	end
		else if(x==135 && y==57) begin	plot <= 1'b1;	end
		else if(x==136 && y==57) begin	plot <= 1'b1;	end
		else if(x==137 && y==57) begin	plot <= 1'b1;	end
		else if(x==149 && y==57) begin	plot <= 1'b1;	end
		else if(x==150 && y==57) begin	plot <= 1'b1;	end
		else if(x==151 && y==57) begin	plot <= 1'b1;	end
		else if(x==152 && y==57) begin	plot <= 1'b1;	end
		else if(x==153 && y==57) begin	plot <= 1'b1;	end
		else if(x==154 && y==57) begin	plot <= 1'b1;	end
		else if(x==155 && y==57) begin	plot <= 1'b1;	end
		else if(x==156 && y==57) begin	plot <= 1'b1;	end
		else if(x==157 && y==57) begin	plot <= 1'b1;	end
		else if(x==160 && y==57) begin	plot <= 1'b1;	end
		else if(x==161 && y==57) begin	plot <= 1'b1;	end
		else if(x==162 && y==57) begin	plot <= 1'b1;	end
		else if(x==163 && y==57) begin	plot <= 1'b1;	end
		else if(x==164 && y==57) begin	plot <= 1'b1;	end
		else if(x==180 && y==57) begin	plot <= 1'b1;	end
		else if(x==181 && y==57) begin	plot <= 1'b1;	end
		else if(x==182 && y==57) begin	plot <= 1'b1;	end
		else if(x==183 && y==57) begin	plot <= 1'b1;	end
		else if(x==184 && y==57) begin	plot <= 1'b1;	end
		else if(x==187 && y==57) begin	plot <= 1'b1;	end
		else if(x==188 && y==57) begin	plot <= 1'b1;	end
		else if(x==189 && y==57) begin	plot <= 1'b1;	end
		else if(x==190 && y==57) begin	plot <= 1'b1;	end
		else if(x==194 && y==57) begin	plot <= 1'b1;	end
		else if(x==195 && y==57) begin	plot <= 1'b1;	end
		else if(x==196 && y==57) begin	plot <= 1'b1;	end
		else if(x==197 && y==57) begin	plot <= 1'b1;	end
		else if(x==200 && y==57) begin	plot <= 1'b1;	end
		else if(x==201 && y==57) begin	plot <= 1'b1;	end
		else if(x==202 && y==57) begin	plot <= 1'b1;	end
		else if(x==203 && y==57) begin	plot <= 1'b1;	end
		else if(x==206 && y==57) begin	plot <= 1'b1;	end
		else if(x==207 && y==57) begin	plot <= 1'b1;	end
		else if(x==208 && y==57) begin	plot <= 1'b1;	end
		else if(x==209 && y==57) begin	plot <= 1'b1;	end
		else if(x==210 && y==57) begin	plot <= 1'b1;	end
		else if(x==211 && y==57) begin	plot <= 1'b1;	end
		else if(x==214 && y==57) begin	plot <= 1'b1;	end
		else if(x==215 && y==57) begin	plot <= 1'b1;	end
		else if(x==216 && y==57) begin	plot <= 1'b1;	end
		else if(x==217 && y==57) begin	plot <= 1'b1;	end
		else if(x==218 && y==57) begin	plot <= 1'b1;	end
		else if(x==219 && y==57) begin	plot <= 1'b1;	end
		else if(x==220 && y==57) begin	plot <= 1'b1;	end
		else if(x==221 && y==57) begin	plot <= 1'b1;	end
		else if(x==222 && y==57) begin	plot <= 1'b1;	end
		else if(x==223 && y==57) begin	plot <= 1'b1;	end
		else if(x==227 && y==57) begin	plot <= 1'b1;	end
		else if(x==228 && y==57) begin	plot <= 1'b1;	end
		else if(x==229 && y==57) begin	plot <= 1'b1;	end
		else if(x==230 && y==57) begin	plot <= 1'b1;	end
		else if(x==231 && y==57) begin	plot <= 1'b1;	end
		else if(x==232 && y==57) begin	plot <= 1'b1;	end
		else if(x==233 && y==57) begin	plot <= 1'b1;	end
		else if(x==234 && y==57) begin	plot <= 1'b1;	end
		else if(x==235 && y==57) begin	plot <= 1'b1;	end
		else if(x==236 && y==57) begin	plot <= 1'b1;	end
		else if(x==240 && y==57) begin	plot <= 1'b1;	end
		else if(x==241 && y==57) begin	plot <= 1'b1;	end
		else if(x==242 && y==57) begin	plot <= 1'b1;	end
		else if(x==243 && y==57) begin	plot <= 1'b1;	end
		else if(x==246 && y==57) begin	plot <= 1'b1;	end
		else if(x==247 && y==57) begin	plot <= 1'b1;	end
		else if(x==248 && y==57) begin	plot <= 1'b1;	end
		else if(x==249 && y==57) begin	plot <= 1'b1;	end
		else if(x==156 && y==108) begin	plot <= 1'b1;	end
		else if(x==155 && y==109) begin	plot <= 1'b1;	end
		else if(x==156 && y==109) begin	plot <= 1'b1;	end
		else if(x==154 && y==110) begin	plot <= 1'b1;	end
		else if(x==155 && y==110) begin	plot <= 1'b1;	end
		else if(x==153 && y==111) begin	plot <= 1'b1;	end
		else if(x==154 && y==111) begin	plot <= 1'b1;	end
		else if(x==155 && y==111) begin	plot <= 1'b1;	end
		else if(x==153 && y==112) begin	plot <= 1'b1;	end
		else if(x==154 && y==112) begin	plot <= 1'b1;	end
		else if(x==152 && y==113) begin	plot <= 1'b1;	end
		else if(x==153 && y==113) begin	plot <= 1'b1;	end
		else if(x==154 && y==113) begin	plot <= 1'b1;	end
		else if(x==155 && y==113) begin	plot <= 1'b1;	end
		else if(x==156 && y==113) begin	plot <= 1'b1;	end
		else if(x==157 && y==113) begin	plot <= 1'b1;	end
		else if(x==151 && y==114) begin	plot <= 1'b1;	end
		else if(x==152 && y==114) begin	plot <= 1'b1;	end
		else if(x==153 && y==114) begin	plot <= 1'b1;	end
		else if(x==154 && y==114) begin	plot <= 1'b1;	end
		else if(x==155 && y==114) begin	plot <= 1'b1;	end
		else if(x==156 && y==114) begin	plot <= 1'b1;	end
		else if(x==157 && y==114) begin	plot <= 1'b1;	end
		else if(x==151 && y==115) begin	plot <= 1'b1;	end
		else if(x==152 && y==115) begin	plot <= 1'b1;	end
		else if(x==153 && y==115) begin	plot <= 1'b1;	end
		else if(x==154 && y==115) begin	plot <= 1'b1;	end
		else if(x==155 && y==115) begin	plot <= 1'b1;	end
		else if(x==156 && y==115) begin	plot <= 1'b1;	end
		else if(x==154 && y==116) begin	plot <= 1'b1;	end
		else if(x==155 && y==116) begin	plot <= 1'b1;	end
		else if(x==153 && y==117) begin	plot <= 1'b1;	end
		else if(x==154 && y==117) begin	plot <= 1'b1;	end
		else if(x==152 && y==118) begin	plot <= 1'b1;	end
		else if(x==153 && y==118) begin	plot <= 1'b1;	end
		else if(x==152 && y==119) begin	plot <= 1'b1;	end
		else if(x==151 && y==120) begin	plot <= 1'b1;	end
		else if(x==104 && y==168) begin	plot <= 1'b1;	end
		else if(x==105 && y==168) begin	plot <= 1'b1;	end
		else if(x==106 && y==168) begin	plot <= 1'b1;	end
		else if(x==107 && y==168) begin	plot <= 1'b1;	end
		else if(x==108 && y==168) begin	plot <= 1'b1;	end
		else if(x==112 && y==168) begin	plot <= 1'b1;	end
		else if(x==118 && y==168) begin	plot <= 1'b1;	end
		else if(x==124 && y==168) begin	plot <= 1'b1;	end
		else if(x==130 && y==168) begin	plot <= 1'b1;	end
		else if(x==131 && y==168) begin	plot <= 1'b1;	end
		else if(x==132 && y==168) begin	plot <= 1'b1;	end
		else if(x==133 && y==168) begin	plot <= 1'b1;	end
		else if(x==134 && y==168) begin	plot <= 1'b1;	end
		else if(x==135 && y==168) begin	plot <= 1'b1;	end
		else if(x==136 && y==168) begin	plot <= 1'b1;	end
		else if(x==149 && y==168) begin	plot <= 1'b1;	end
		else if(x==150 && y==168) begin	plot <= 1'b1;	end
		else if(x==175 && y==168) begin	plot <= 1'b1;	end
		else if(x==176 && y==168) begin	plot <= 1'b1;	end
		else if(x==177 && y==168) begin	plot <= 1'b1;	end
		else if(x==178 && y==168) begin	plot <= 1'b1;	end
		else if(x==184 && y==168) begin	plot <= 1'b1;	end
		else if(x==209 && y==168) begin	plot <= 1'b1;	end
		else if(x==210 && y==168) begin	plot <= 1'b1;	end
		else if(x==103 && y==169) begin	plot <= 1'b1;	end
		else if(x==104 && y==169) begin	plot <= 1'b1;	end
		else if(x==105 && y==169) begin	plot <= 1'b1;	end
		else if(x==106 && y==169) begin	plot <= 1'b1;	end
		else if(x==107 && y==169) begin	plot <= 1'b1;	end
		else if(x==108 && y==169) begin	plot <= 1'b1;	end
		else if(x==109 && y==169) begin	plot <= 1'b1;	end
		else if(x==112 && y==169) begin	plot <= 1'b1;	end
		else if(x==118 && y==169) begin	plot <= 1'b1;	end
		else if(x==123 && y==169) begin	plot <= 1'b1;	end
		else if(x==124 && y==169) begin	plot <= 1'b1;	end
		else if(x==130 && y==169) begin	plot <= 1'b1;	end
		else if(x==131 && y==169) begin	plot <= 1'b1;	end
		else if(x==132 && y==169) begin	plot <= 1'b1;	end
		else if(x==133 && y==169) begin	plot <= 1'b1;	end
		else if(x==135 && y==169) begin	plot <= 1'b1;	end
		else if(x==136 && y==169) begin	plot <= 1'b1;	end
		else if(x==149 && y==169) begin	plot <= 1'b1;	end
		else if(x==150 && y==169) begin	plot <= 1'b1;	end
		else if(x==174 && y==169) begin	plot <= 1'b1;	end
		else if(x==175 && y==169) begin	plot <= 1'b1;	end
		else if(x==176 && y==169) begin	plot <= 1'b1;	end
		else if(x==177 && y==169) begin	plot <= 1'b1;	end
		else if(x==178 && y==169) begin	plot <= 1'b1;	end
		else if(x==179 && y==169) begin	plot <= 1'b1;	end
		else if(x==184 && y==169) begin	plot <= 1'b1;	end
		else if(x==209 && y==169) begin	plot <= 1'b1;	end
		else if(x==210 && y==169) begin	plot <= 1'b1;	end
		else if(x==103 && y==170) begin	plot <= 1'b1;	end
		else if(x==109 && y==170) begin	plot <= 1'b1;	end
		else if(x==112 && y==170) begin	plot <= 1'b1;	end
		else if(x==118 && y==170) begin	plot <= 1'b1;	end
		else if(x==122 && y==170) begin	plot <= 1'b1;	end
		else if(x==123 && y==170) begin	plot <= 1'b1;	end
		else if(x==124 && y==170) begin	plot <= 1'b1;	end
		else if(x==136 && y==170) begin	plot <= 1'b1;	end
		else if(x==149 && y==170) begin	plot <= 1'b1;	end
		else if(x==150 && y==170) begin	plot <= 1'b1;	end
		else if(x==173 && y==170) begin	plot <= 1'b1;	end
		else if(x==174 && y==170) begin	plot <= 1'b1;	end
		else if(x==179 && y==170) begin	plot <= 1'b1;	end
		else if(x==180 && y==170) begin	plot <= 1'b1;	end
		else if(x==184 && y==170) begin	plot <= 1'b1;	end
		else if(x==209 && y==170) begin	plot <= 1'b1;	end
		else if(x==210 && y==170) begin	plot <= 1'b1;	end
		else if(x==103 && y==171) begin	plot <= 1'b1;	end
		else if(x==112 && y==171) begin	plot <= 1'b1;	end
		else if(x==118 && y==171) begin	plot <= 1'b1;	end
		else if(x==121 && y==171) begin	plot <= 1'b1;	end
		else if(x==124 && y==171) begin	plot <= 1'b1;	end
		else if(x==134 && y==171) begin	plot <= 1'b1;	end
		else if(x==135 && y==171) begin	plot <= 1'b1;	end
		else if(x==148 && y==171) begin	plot <= 1'b1;	end
		else if(x==149 && y==171) begin	plot <= 1'b1;	end
		else if(x==150 && y==171) begin	plot <= 1'b1;	end
		else if(x==151 && y==171) begin	plot <= 1'b1;	end
		else if(x==152 && y==171) begin	plot <= 1'b1;	end
		else if(x==153 && y==171) begin	plot <= 1'b1;	end
		else if(x==157 && y==171) begin	plot <= 1'b1;	end
		else if(x==158 && y==171) begin	plot <= 1'b1;	end
		else if(x==159 && y==171) begin	plot <= 1'b1;	end
		else if(x==160 && y==171) begin	plot <= 1'b1;	end
		else if(x==173 && y==171) begin	plot <= 1'b1;	end
		else if(x==174 && y==171) begin	plot <= 1'b1;	end
		else if(x==182 && y==171) begin	plot <= 1'b1;	end
		else if(x==183 && y==171) begin	plot <= 1'b1;	end
		else if(x==184 && y==171) begin	plot <= 1'b1;	end
		else if(x==185 && y==171) begin	plot <= 1'b1;	end
		else if(x==186 && y==171) begin	plot <= 1'b1;	end
		else if(x==187 && y==171) begin	plot <= 1'b1;	end
		else if(x==191 && y==171) begin	plot <= 1'b1;	end
		else if(x==192 && y==171) begin	plot <= 1'b1;	end
		else if(x==193 && y==171) begin	plot <= 1'b1;	end
		else if(x==194 && y==171) begin	plot <= 1'b1;	end
		else if(x==195 && y==171) begin	plot <= 1'b1;	end
		else if(x==199 && y==171) begin	plot <= 1'b1;	end
		else if(x==202 && y==171) begin	plot <= 1'b1;	end
		else if(x==203 && y==171) begin	plot <= 1'b1;	end
		else if(x==204 && y==171) begin	plot <= 1'b1;	end
		else if(x==208 && y==171) begin	plot <= 1'b1;	end
		else if(x==209 && y==171) begin	plot <= 1'b1;	end
		else if(x==210 && y==171) begin	plot <= 1'b1;	end
		else if(x==211 && y==171) begin	plot <= 1'b1;	end
		else if(x==212 && y==171) begin	plot <= 1'b1;	end
		else if(x==213 && y==171) begin	plot <= 1'b1;	end
		else if(x==103 && y==172) begin	plot <= 1'b1;	end
		else if(x==104 && y==172) begin	plot <= 1'b1;	end
		else if(x==105 && y==172) begin	plot <= 1'b1;	end
		else if(x==106 && y==172) begin	plot <= 1'b1;	end
		else if(x==107 && y==172) begin	plot <= 1'b1;	end
		else if(x==112 && y==172) begin	plot <= 1'b1;	end
		else if(x==115 && y==172) begin	plot <= 1'b1;	end
		else if(x==118 && y==172) begin	plot <= 1'b1;	end
		else if(x==121 && y==172) begin	plot <= 1'b1;	end
		else if(x==124 && y==172) begin	plot <= 1'b1;	end
		else if(x==134 && y==172) begin	plot <= 1'b1;	end
		else if(x==135 && y==172) begin	plot <= 1'b1;	end
		else if(x==148 && y==172) begin	plot <= 1'b1;	end
		else if(x==149 && y==172) begin	plot <= 1'b1;	end
		else if(x==150 && y==172) begin	plot <= 1'b1;	end
		else if(x==151 && y==172) begin	plot <= 1'b1;	end
		else if(x==152 && y==172) begin	plot <= 1'b1;	end
		else if(x==156 && y==172) begin	plot <= 1'b1;	end
		else if(x==157 && y==172) begin	plot <= 1'b1;	end
		else if(x==158 && y==172) begin	plot <= 1'b1;	end
		else if(x==159 && y==172) begin	plot <= 1'b1;	end
		else if(x==160 && y==172) begin	plot <= 1'b1;	end
		else if(x==161 && y==172) begin	plot <= 1'b1;	end
		else if(x==174 && y==172) begin	plot <= 1'b1;	end
		else if(x==175 && y==172) begin	plot <= 1'b1;	end
		else if(x==176 && y==172) begin	plot <= 1'b1;	end
		else if(x==177 && y==172) begin	plot <= 1'b1;	end
		else if(x==178 && y==172) begin	plot <= 1'b1;	end
		else if(x==183 && y==172) begin	plot <= 1'b1;	end
		else if(x==184 && y==172) begin	plot <= 1'b1;	end
		else if(x==185 && y==172) begin	plot <= 1'b1;	end
		else if(x==186 && y==172) begin	plot <= 1'b1;	end
		else if(x==187 && y==172) begin	plot <= 1'b1;	end
		else if(x==192 && y==172) begin	plot <= 1'b1;	end
		else if(x==193 && y==172) begin	plot <= 1'b1;	end
		else if(x==194 && y==172) begin	plot <= 1'b1;	end
		else if(x==195 && y==172) begin	plot <= 1'b1;	end
		else if(x==196 && y==172) begin	plot <= 1'b1;	end
		else if(x==199 && y==172) begin	plot <= 1'b1;	end
		else if(x==200 && y==172) begin	plot <= 1'b1;	end
		else if(x==201 && y==172) begin	plot <= 1'b1;	end
		else if(x==202 && y==172) begin	plot <= 1'b1;	end
		else if(x==203 && y==172) begin	plot <= 1'b1;	end
		else if(x==204 && y==172) begin	plot <= 1'b1;	end
		else if(x==205 && y==172) begin	plot <= 1'b1;	end
		else if(x==208 && y==172) begin	plot <= 1'b1;	end
		else if(x==209 && y==172) begin	plot <= 1'b1;	end
		else if(x==210 && y==172) begin	plot <= 1'b1;	end
		else if(x==211 && y==172) begin	plot <= 1'b1;	end
		else if(x==212 && y==172) begin	plot <= 1'b1;	end
		else if(x==104 && y==173) begin	plot <= 1'b1;	end
		else if(x==105 && y==173) begin	plot <= 1'b1;	end
		else if(x==106 && y==173) begin	plot <= 1'b1;	end
		else if(x==107 && y==173) begin	plot <= 1'b1;	end
		else if(x==108 && y==173) begin	plot <= 1'b1;	end
		else if(x==112 && y==173) begin	plot <= 1'b1;	end
		else if(x==115 && y==173) begin	plot <= 1'b1;	end
		else if(x==118 && y==173) begin	plot <= 1'b1;	end
		else if(x==124 && y==173) begin	plot <= 1'b1;	end
		else if(x==134 && y==173) begin	plot <= 1'b1;	end
		else if(x==135 && y==173) begin	plot <= 1'b1;	end
		else if(x==149 && y==173) begin	plot <= 1'b1;	end
		else if(x==150 && y==173) begin	plot <= 1'b1;	end
		else if(x==155 && y==173) begin	plot <= 1'b1;	end
		else if(x==156 && y==173) begin	plot <= 1'b1;	end
		else if(x==161 && y==173) begin	plot <= 1'b1;	end
		else if(x==162 && y==173) begin	plot <= 1'b1;	end
		else if(x==175 && y==173) begin	plot <= 1'b1;	end
		else if(x==176 && y==173) begin	plot <= 1'b1;	end
		else if(x==177 && y==173) begin	plot <= 1'b1;	end
		else if(x==178 && y==173) begin	plot <= 1'b1;	end
		else if(x==184 && y==173) begin	plot <= 1'b1;	end
		else if(x==196 && y==173) begin	plot <= 1'b1;	end
		else if(x==199 && y==173) begin	plot <= 1'b1;	end
		else if(x==200 && y==173) begin	plot <= 1'b1;	end
		else if(x==201 && y==173) begin	plot <= 1'b1;	end
		else if(x==205 && y==173) begin	plot <= 1'b1;	end
		else if(x==209 && y==173) begin	plot <= 1'b1;	end
		else if(x==210 && y==173) begin	plot <= 1'b1;	end
		else if(x==109 && y==174) begin	plot <= 1'b1;	end
		else if(x==112 && y==174) begin	plot <= 1'b1;	end
		else if(x==115 && y==174) begin	plot <= 1'b1;	end
		else if(x==118 && y==174) begin	plot <= 1'b1;	end
		else if(x==124 && y==174) begin	plot <= 1'b1;	end
		else if(x==133 && y==174) begin	plot <= 1'b1;	end
		else if(x==149 && y==174) begin	plot <= 1'b1;	end
		else if(x==150 && y==174) begin	plot <= 1'b1;	end
		else if(x==155 && y==174) begin	plot <= 1'b1;	end
		else if(x==156 && y==174) begin	plot <= 1'b1;	end
		else if(x==161 && y==174) begin	plot <= 1'b1;	end
		else if(x==162 && y==174) begin	plot <= 1'b1;	end
		else if(x==179 && y==174) begin	plot <= 1'b1;	end
		else if(x==180 && y==174) begin	plot <= 1'b1;	end
		else if(x==184 && y==174) begin	plot <= 1'b1;	end
		else if(x==191 && y==174) begin	plot <= 1'b1;	end
		else if(x==192 && y==174) begin	plot <= 1'b1;	end
		else if(x==193 && y==174) begin	plot <= 1'b1;	end
		else if(x==194 && y==174) begin	plot <= 1'b1;	end
		else if(x==195 && y==174) begin	plot <= 1'b1;	end
		else if(x==196 && y==174) begin	plot <= 1'b1;	end
		else if(x==199 && y==174) begin	plot <= 1'b1;	end
		else if(x==209 && y==174) begin	plot <= 1'b1;	end
		else if(x==210 && y==174) begin	plot <= 1'b1;	end
		else if(x==103 && y==175) begin	plot <= 1'b1;	end
		else if(x==109 && y==175) begin	plot <= 1'b1;	end
		else if(x==112 && y==175) begin	plot <= 1'b1;	end
		else if(x==113 && y==175) begin	plot <= 1'b1;	end
		else if(x==114 && y==175) begin	plot <= 1'b1;	end
		else if(x==115 && y==175) begin	plot <= 1'b1;	end
		else if(x==116 && y==175) begin	plot <= 1'b1;	end
		else if(x==117 && y==175) begin	plot <= 1'b1;	end
		else if(x==118 && y==175) begin	plot <= 1'b1;	end
		else if(x==124 && y==175) begin	plot <= 1'b1;	end
		else if(x==133 && y==175) begin	plot <= 1'b1;	end
		else if(x==149 && y==175) begin	plot <= 1'b1;	end
		else if(x==150 && y==175) begin	plot <= 1'b1;	end
		else if(x==155 && y==175) begin	plot <= 1'b1;	end
		else if(x==156 && y==175) begin	plot <= 1'b1;	end
		else if(x==161 && y==175) begin	plot <= 1'b1;	end
		else if(x==162 && y==175) begin	plot <= 1'b1;	end
		else if(x==179 && y==175) begin	plot <= 1'b1;	end
		else if(x==180 && y==175) begin	plot <= 1'b1;	end
		else if(x==184 && y==175) begin	plot <= 1'b1;	end
		else if(x==190 && y==175) begin	plot <= 1'b1;	end
		else if(x==191 && y==175) begin	plot <= 1'b1;	end
		else if(x==192 && y==175) begin	plot <= 1'b1;	end
		else if(x==193 && y==175) begin	plot <= 1'b1;	end
		else if(x==195 && y==175) begin	plot <= 1'b1;	end
		else if(x==196 && y==175) begin	plot <= 1'b1;	end
		else if(x==199 && y==175) begin	plot <= 1'b1;	end
		else if(x==209 && y==175) begin	plot <= 1'b1;	end
		else if(x==210 && y==175) begin	plot <= 1'b1;	end
		else if(x==103 && y==176) begin	plot <= 1'b1;	end
		else if(x==109 && y==176) begin	plot <= 1'b1;	end
		else if(x==112 && y==176) begin	plot <= 1'b1;	end
		else if(x==113 && y==176) begin	plot <= 1'b1;	end
		else if(x==114 && y==176) begin	plot <= 1'b1;	end
		else if(x==116 && y==176) begin	plot <= 1'b1;	end
		else if(x==117 && y==176) begin	plot <= 1'b1;	end
		else if(x==118 && y==176) begin	plot <= 1'b1;	end
		else if(x==124 && y==176) begin	plot <= 1'b1;	end
		else if(x==133 && y==176) begin	plot <= 1'b1;	end
		else if(x==149 && y==176) begin	plot <= 1'b1;	end
		else if(x==150 && y==176) begin	plot <= 1'b1;	end
		else if(x==155 && y==176) begin	plot <= 1'b1;	end
		else if(x==156 && y==176) begin	plot <= 1'b1;	end
		else if(x==161 && y==176) begin	plot <= 1'b1;	end
		else if(x==162 && y==176) begin	plot <= 1'b1;	end
		else if(x==173 && y==176) begin	plot <= 1'b1;	end
		else if(x==174 && y==176) begin	plot <= 1'b1;	end
		else if(x==179 && y==176) begin	plot <= 1'b1;	end
		else if(x==180 && y==176) begin	plot <= 1'b1;	end
		else if(x==184 && y==176) begin	plot <= 1'b1;	end
		else if(x==190 && y==176) begin	plot <= 1'b1;	end
		else if(x==196 && y==176) begin	plot <= 1'b1;	end
		else if(x==199 && y==176) begin	plot <= 1'b1;	end
		else if(x==209 && y==176) begin	plot <= 1'b1;	end
		else if(x==210 && y==176) begin	plot <= 1'b1;	end
		else if(x==104 && y==177) begin	plot <= 1'b1;	end
		else if(x==105 && y==177) begin	plot <= 1'b1;	end
		else if(x==106 && y==177) begin	plot <= 1'b1;	end
		else if(x==107 && y==177) begin	plot <= 1'b1;	end
		else if(x==108 && y==177) begin	plot <= 1'b1;	end
		else if(x==112 && y==177) begin	plot <= 1'b1;	end
		else if(x==118 && y==177) begin	plot <= 1'b1;	end
		else if(x==124 && y==177) begin	plot <= 1'b1;	end
		else if(x==131 && y==177) begin	plot <= 1'b1;	end
		else if(x==132 && y==177) begin	plot <= 1'b1;	end
		else if(x==151 && y==177) begin	plot <= 1'b1;	end
		else if(x==152 && y==177) begin	plot <= 1'b1;	end
		else if(x==153 && y==177) begin	plot <= 1'b1;	end
		else if(x==157 && y==177) begin	plot <= 1'b1;	end
		else if(x==158 && y==177) begin	plot <= 1'b1;	end
		else if(x==159 && y==177) begin	plot <= 1'b1;	end
		else if(x==160 && y==177) begin	plot <= 1'b1;	end
		else if(x==175 && y==177) begin	plot <= 1'b1;	end
		else if(x==176 && y==177) begin	plot <= 1'b1;	end
		else if(x==177 && y==177) begin	plot <= 1'b1;	end
		else if(x==178 && y==177) begin	plot <= 1'b1;	end
		else if(x==185 && y==177) begin	plot <= 1'b1;	end
		else if(x==186 && y==177) begin	plot <= 1'b1;	end
		else if(x==187 && y==177) begin	plot <= 1'b1;	end
		else if(x==191 && y==177) begin	plot <= 1'b1;	end
		else if(x==192 && y==177) begin	plot <= 1'b1;	end
		else if(x==193 && y==177) begin	plot <= 1'b1;	end
		else if(x==194 && y==177) begin	plot <= 1'b1;	end
		else if(x==195 && y==177) begin	plot <= 1'b1;	end
		else if(x==196 && y==177) begin	plot <= 1'b1;	end
		else if(x==199 && y==177) begin	plot <= 1'b1;	end
		else if(x==211 && y==177) begin	plot <= 1'b1;	end
		else if(x==212 && y==177) begin	plot <= 1'b1;	end
		else if(x==213 && y==177) begin	plot <= 1'b1;	end
		else if(x==105 && y==178) begin	plot <= 1'b1;	end
		else if(x==106 && y==178) begin	plot <= 1'b1;	end
		else if(x==107 && y==178) begin	plot <= 1'b1;	end
		else if(x==112 && y==178) begin	plot <= 1'b1;	end
		else if(x==118 && y==178) begin	plot <= 1'b1;	end
		else if(x==124 && y==178) begin	plot <= 1'b1;	end
		else if(x==151 && y==178) begin	plot <= 1'b1;	end
		else if(x==152 && y==178) begin	plot <= 1'b1;	end
		else if(x==157 && y==178) begin	plot <= 1'b1;	end
		else if(x==158 && y==178) begin	plot <= 1'b1;	end
		else if(x==159 && y==178) begin	plot <= 1'b1;	end
		else if(x==160 && y==178) begin	plot <= 1'b1;	end
		else if(x==175 && y==178) begin	plot <= 1'b1;	end
		else if(x==176 && y==178) begin	plot <= 1'b1;	end
		else if(x==177 && y==178) begin	plot <= 1'b1;	end
		else if(x==178 && y==178) begin	plot <= 1'b1;	end
		else if(x==186 && y==178) begin	plot <= 1'b1;	end
		else if(x==187 && y==178) begin	plot <= 1'b1;	end
		else if(x==192 && y==178) begin	plot <= 1'b1;	end
		else if(x==193 && y==178) begin	plot <= 1'b1;	end
		else if(x==194 && y==178) begin	plot <= 1'b1;	end
		else if(x==195 && y==178) begin	plot <= 1'b1;	end
		else if(x==196 && y==178) begin	plot <= 1'b1;	end
		else if(x==199 && y==178) begin	plot <= 1'b1;	end
		else if(x==211 && y==178) begin	plot <= 1'b1;	end
		else if(x==212 && y==178) begin	plot <= 1'b1;	end
		else begin plot <= 1'b0; end// Width: 320, Height: 240
	end
endmodule

// module for plotting start screen with smaller lightning symbol
module sssmallightning(
	input clk,
	input wire [9:0] characterPositionX,
	input wire [8:0] characterPositionY,
	input wire [9:0] drawingPositionX,
	input wire [8:0] drawingPositionY,
	output reg [2:0] plot
);
	reg [9:0] x;
	reg [9:0] y;
	initial begin
		x = 'd0;
		y = 'd0;
	end

	always @(posedge clk) begin
		x <= (drawingPositionX - characterPositionX + 161);
		y <= (drawingPositionY - characterPositionY + 121);
		if(x==75 && y==47) begin	plot <= 1'b1;	end
		else if(x==76 && y==47) begin	plot <= 1'b1;	end
		else if(x==77 && y==47) begin	plot <= 1'b1;	end
		else if(x==78 && y==47) begin	plot <= 1'b1;	end
		else if(x==79 && y==47) begin	plot <= 1'b1;	end
		else if(x==80 && y==47) begin	plot <= 1'b1;	end
		else if(x==81 && y==47) begin	plot <= 1'b1;	end
		else if(x==82 && y==47) begin	plot <= 1'b1;	end
		else if(x==83 && y==47) begin	plot <= 1'b1;	end
		else if(x==84 && y==47) begin	plot <= 1'b1;	end
		else if(x==90 && y==47) begin	plot <= 1'b1;	end
		else if(x==91 && y==47) begin	plot <= 1'b1;	end
		else if(x==92 && y==47) begin	plot <= 1'b1;	end
		else if(x==93 && y==47) begin	plot <= 1'b1;	end
		else if(x==94 && y==47) begin	plot <= 1'b1;	end
		else if(x==95 && y==47) begin	plot <= 1'b1;	end
		else if(x==96 && y==47) begin	plot <= 1'b1;	end
		else if(x==101 && y==47) begin	plot <= 1'b1;	end
		else if(x==102 && y==47) begin	plot <= 1'b1;	end
		else if(x==103 && y==47) begin	plot <= 1'b1;	end
		else if(x==104 && y==47) begin	plot <= 1'b1;	end
		else if(x==116 && y==47) begin	plot <= 1'b1;	end
		else if(x==117 && y==47) begin	plot <= 1'b1;	end
		else if(x==118 && y==47) begin	plot <= 1'b1;	end
		else if(x==119 && y==47) begin	plot <= 1'b1;	end
		else if(x==120 && y==47) begin	plot <= 1'b1;	end
		else if(x==121 && y==47) begin	plot <= 1'b1;	end
		else if(x==122 && y==47) begin	plot <= 1'b1;	end
		else if(x==123 && y==47) begin	plot <= 1'b1;	end
		else if(x==124 && y==47) begin	plot <= 1'b1;	end
		else if(x==129 && y==47) begin	plot <= 1'b1;	end
		else if(x==130 && y==47) begin	plot <= 1'b1;	end
		else if(x==131 && y==47) begin	plot <= 1'b1;	end
		else if(x==132 && y==47) begin	plot <= 1'b1;	end
		else if(x==133 && y==47) begin	plot <= 1'b1;	end
		else if(x==134 && y==47) begin	plot <= 1'b1;	end
		else if(x==135 && y==47) begin	plot <= 1'b1;	end
		else if(x==136 && y==47) begin	plot <= 1'b1;	end
		else if(x==149 && y==47) begin	plot <= 1'b1;	end
		else if(x==150 && y==47) begin	plot <= 1'b1;	end
		else if(x==151 && y==47) begin	plot <= 1'b1;	end
		else if(x==152 && y==47) begin	plot <= 1'b1;	end
		else if(x==153 && y==47) begin	plot <= 1'b1;	end
		else if(x==154 && y==47) begin	plot <= 1'b1;	end
		else if(x==155 && y==47) begin	plot <= 1'b1;	end
		else if(x==163 && y==47) begin	plot <= 1'b1;	end
		else if(x==164 && y==47) begin	plot <= 1'b1;	end
		else if(x==165 && y==47) begin	plot <= 1'b1;	end
		else if(x==166 && y==47) begin	plot <= 1'b1;	end
		else if(x==167 && y==47) begin	plot <= 1'b1;	end
		else if(x==168 && y==47) begin	plot <= 1'b1;	end
		else if(x==169 && y==47) begin	plot <= 1'b1;	end
		else if(x==170 && y==47) begin	plot <= 1'b1;	end
		else if(x==181 && y==47) begin	plot <= 1'b1;	end
		else if(x==182 && y==47) begin	plot <= 1'b1;	end
		else if(x==183 && y==47) begin	plot <= 1'b1;	end
		else if(x==184 && y==47) begin	plot <= 1'b1;	end
		else if(x==185 && y==47) begin	plot <= 1'b1;	end
		else if(x==186 && y==47) begin	plot <= 1'b1;	end
		else if(x==187 && y==47) begin	plot <= 1'b1;	end
		else if(x==188 && y==47) begin	plot <= 1'b1;	end
		else if(x==189 && y==47) begin	plot <= 1'b1;	end
		else if(x==195 && y==47) begin	plot <= 1'b1;	end
		else if(x==196 && y==47) begin	plot <= 1'b1;	end
		else if(x==197 && y==47) begin	plot <= 1'b1;	end
		else if(x==198 && y==47) begin	plot <= 1'b1;	end
		else if(x==199 && y==47) begin	plot <= 1'b1;	end
		else if(x==200 && y==47) begin	plot <= 1'b1;	end
		else if(x==201 && y==47) begin	plot <= 1'b1;	end
		else if(x==207 && y==47) begin	plot <= 1'b1;	end
		else if(x==208 && y==47) begin	plot <= 1'b1;	end
		else if(x==209 && y==47) begin	plot <= 1'b1;	end
		else if(x==214 && y==47) begin	plot <= 1'b1;	end
		else if(x==215 && y==47) begin	plot <= 1'b1;	end
		else if(x==216 && y==47) begin	plot <= 1'b1;	end
		else if(x==217 && y==47) begin	plot <= 1'b1;	end
		else if(x==218 && y==47) begin	plot <= 1'b1;	end
		else if(x==219 && y==47) begin	plot <= 1'b1;	end
		else if(x==220 && y==47) begin	plot <= 1'b1;	end
		else if(x==221 && y==47) begin	plot <= 1'b1;	end
		else if(x==228 && y==47) begin	plot <= 1'b1;	end
		else if(x==229 && y==47) begin	plot <= 1'b1;	end
		else if(x==230 && y==47) begin	plot <= 1'b1;	end
		else if(x==231 && y==47) begin	plot <= 1'b1;	end
		else if(x==232 && y==47) begin	plot <= 1'b1;	end
		else if(x==233 && y==47) begin	plot <= 1'b1;	end
		else if(x==234 && y==47) begin	plot <= 1'b1;	end
		else if(x==235 && y==47) begin	plot <= 1'b1;	end
		else if(x==240 && y==47) begin	plot <= 1'b1;	end
		else if(x==241 && y==47) begin	plot <= 1'b1;	end
		else if(x==242 && y==47) begin	plot <= 1'b1;	end
		else if(x==243 && y==47) begin	plot <= 1'b1;	end
		else if(x==244 && y==47) begin	plot <= 1'b1;	end
		else if(x==245 && y==47) begin	plot <= 1'b1;	end
		else if(x==246 && y==47) begin	plot <= 1'b1;	end
		else if(x==247 && y==47) begin	plot <= 1'b1;	end
		else if(x==75 && y==48) begin	plot <= 1'b1;	end
		else if(x==76 && y==48) begin	plot <= 1'b1;	end
		else if(x==77 && y==48) begin	plot <= 1'b1;	end
		else if(x==78 && y==48) begin	plot <= 1'b1;	end
		else if(x==79 && y==48) begin	plot <= 1'b1;	end
		else if(x==80 && y==48) begin	plot <= 1'b1;	end
		else if(x==81 && y==48) begin	plot <= 1'b1;	end
		else if(x==82 && y==48) begin	plot <= 1'b1;	end
		else if(x==83 && y==48) begin	plot <= 1'b1;	end
		else if(x==84 && y==48) begin	plot <= 1'b1;	end
		else if(x==85 && y==48) begin	plot <= 1'b1;	end
		else if(x==89 && y==48) begin	plot <= 1'b1;	end
		else if(x==90 && y==48) begin	plot <= 1'b1;	end
		else if(x==91 && y==48) begin	plot <= 1'b1;	end
		else if(x==92 && y==48) begin	plot <= 1'b1;	end
		else if(x==93 && y==48) begin	plot <= 1'b1;	end
		else if(x==94 && y==48) begin	plot <= 1'b1;	end
		else if(x==95 && y==48) begin	plot <= 1'b1;	end
		else if(x==96 && y==48) begin	plot <= 1'b1;	end
		else if(x==97 && y==48) begin	plot <= 1'b1;	end
		else if(x==101 && y==48) begin	plot <= 1'b1;	end
		else if(x==102 && y==48) begin	plot <= 1'b1;	end
		else if(x==103 && y==48) begin	plot <= 1'b1;	end
		else if(x==104 && y==48) begin	plot <= 1'b1;	end
		else if(x==105 && y==48) begin	plot <= 1'b1;	end
		else if(x==115 && y==48) begin	plot <= 1'b1;	end
		else if(x==116 && y==48) begin	plot <= 1'b1;	end
		else if(x==117 && y==48) begin	plot <= 1'b1;	end
		else if(x==118 && y==48) begin	plot <= 1'b1;	end
		else if(x==119 && y==48) begin	plot <= 1'b1;	end
		else if(x==120 && y==48) begin	plot <= 1'b1;	end
		else if(x==121 && y==48) begin	plot <= 1'b1;	end
		else if(x==122 && y==48) begin	plot <= 1'b1;	end
		else if(x==123 && y==48) begin	plot <= 1'b1;	end
		else if(x==124 && y==48) begin	plot <= 1'b1;	end
		else if(x==129 && y==48) begin	plot <= 1'b1;	end
		else if(x==130 && y==48) begin	plot <= 1'b1;	end
		else if(x==131 && y==48) begin	plot <= 1'b1;	end
		else if(x==132 && y==48) begin	plot <= 1'b1;	end
		else if(x==133 && y==48) begin	plot <= 1'b1;	end
		else if(x==134 && y==48) begin	plot <= 1'b1;	end
		else if(x==135 && y==48) begin	plot <= 1'b1;	end
		else if(x==136 && y==48) begin	plot <= 1'b1;	end
		else if(x==137 && y==48) begin	plot <= 1'b1;	end
		else if(x==138 && y==48) begin	plot <= 1'b1;	end
		else if(x==148 && y==48) begin	plot <= 1'b1;	end
		else if(x==149 && y==48) begin	plot <= 1'b1;	end
		else if(x==150 && y==48) begin	plot <= 1'b1;	end
		else if(x==151 && y==48) begin	plot <= 1'b1;	end
		else if(x==152 && y==48) begin	plot <= 1'b1;	end
		else if(x==153 && y==48) begin	plot <= 1'b1;	end
		else if(x==154 && y==48) begin	plot <= 1'b1;	end
		else if(x==155 && y==48) begin	plot <= 1'b1;	end
		else if(x==156 && y==48) begin	plot <= 1'b1;	end
		else if(x==162 && y==48) begin	plot <= 1'b1;	end
		else if(x==163 && y==48) begin	plot <= 1'b1;	end
		else if(x==164 && y==48) begin	plot <= 1'b1;	end
		else if(x==165 && y==48) begin	plot <= 1'b1;	end
		else if(x==166 && y==48) begin	plot <= 1'b1;	end
		else if(x==167 && y==48) begin	plot <= 1'b1;	end
		else if(x==168 && y==48) begin	plot <= 1'b1;	end
		else if(x==169 && y==48) begin	plot <= 1'b1;	end
		else if(x==170 && y==48) begin	plot <= 1'b1;	end
		else if(x==180 && y==48) begin	plot <= 1'b1;	end
		else if(x==181 && y==48) begin	plot <= 1'b1;	end
		else if(x==182 && y==48) begin	plot <= 1'b1;	end
		else if(x==183 && y==48) begin	plot <= 1'b1;	end
		else if(x==184 && y==48) begin	plot <= 1'b1;	end
		else if(x==185 && y==48) begin	plot <= 1'b1;	end
		else if(x==186 && y==48) begin	plot <= 1'b1;	end
		else if(x==187 && y==48) begin	plot <= 1'b1;	end
		else if(x==188 && y==48) begin	plot <= 1'b1;	end
		else if(x==189 && y==48) begin	plot <= 1'b1;	end
		else if(x==195 && y==48) begin	plot <= 1'b1;	end
		else if(x==196 && y==48) begin	plot <= 1'b1;	end
		else if(x==197 && y==48) begin	plot <= 1'b1;	end
		else if(x==198 && y==48) begin	plot <= 1'b1;	end
		else if(x==199 && y==48) begin	plot <= 1'b1;	end
		else if(x==200 && y==48) begin	plot <= 1'b1;	end
		else if(x==201 && y==48) begin	plot <= 1'b1;	end
		else if(x==202 && y==48) begin	plot <= 1'b1;	end
		else if(x==206 && y==48) begin	plot <= 1'b1;	end
		else if(x==207 && y==48) begin	plot <= 1'b1;	end
		else if(x==208 && y==48) begin	plot <= 1'b1;	end
		else if(x==209 && y==48) begin	plot <= 1'b1;	end
		else if(x==210 && y==48) begin	plot <= 1'b1;	end
		else if(x==214 && y==48) begin	plot <= 1'b1;	end
		else if(x==215 && y==48) begin	plot <= 1'b1;	end
		else if(x==216 && y==48) begin	plot <= 1'b1;	end
		else if(x==217 && y==48) begin	plot <= 1'b1;	end
		else if(x==218 && y==48) begin	plot <= 1'b1;	end
		else if(x==219 && y==48) begin	plot <= 1'b1;	end
		else if(x==220 && y==48) begin	plot <= 1'b1;	end
		else if(x==221 && y==48) begin	plot <= 1'b1;	end
		else if(x==222 && y==48) begin	plot <= 1'b1;	end
		else if(x==227 && y==48) begin	plot <= 1'b1;	end
		else if(x==228 && y==48) begin	plot <= 1'b1;	end
		else if(x==229 && y==48) begin	plot <= 1'b1;	end
		else if(x==230 && y==48) begin	plot <= 1'b1;	end
		else if(x==231 && y==48) begin	plot <= 1'b1;	end
		else if(x==232 && y==48) begin	plot <= 1'b1;	end
		else if(x==233 && y==48) begin	plot <= 1'b1;	end
		else if(x==234 && y==48) begin	plot <= 1'b1;	end
		else if(x==235 && y==48) begin	plot <= 1'b1;	end
		else if(x==236 && y==48) begin	plot <= 1'b1;	end
		else if(x==240 && y==48) begin	plot <= 1'b1;	end
		else if(x==241 && y==48) begin	plot <= 1'b1;	end
		else if(x==242 && y==48) begin	plot <= 1'b1;	end
		else if(x==243 && y==48) begin	plot <= 1'b1;	end
		else if(x==244 && y==48) begin	plot <= 1'b1;	end
		else if(x==245 && y==48) begin	plot <= 1'b1;	end
		else if(x==246 && y==48) begin	plot <= 1'b1;	end
		else if(x==247 && y==48) begin	plot <= 1'b1;	end
		else if(x==248 && y==48) begin	plot <= 1'b1;	end
		else if(x==76 && y==49) begin	plot <= 1'b1;	end
		else if(x==78 && y==49) begin	plot <= 1'b1;	end
		else if(x==79 && y==49) begin	plot <= 1'b1;	end
		else if(x==80 && y==49) begin	plot <= 1'b1;	end
		else if(x==81 && y==49) begin	plot <= 1'b1;	end
		else if(x==82 && y==49) begin	plot <= 1'b1;	end
		else if(x==84 && y==49) begin	plot <= 1'b1;	end
		else if(x==89 && y==49) begin	plot <= 1'b1;	end
		else if(x==90 && y==49) begin	plot <= 1'b1;	end
		else if(x==91 && y==49) begin	plot <= 1'b1;	end
		else if(x==92 && y==49) begin	plot <= 1'b1;	end
		else if(x==94 && y==49) begin	plot <= 1'b1;	end
		else if(x==95 && y==49) begin	plot <= 1'b1;	end
		else if(x==96 && y==49) begin	plot <= 1'b1;	end
		else if(x==97 && y==49) begin	plot <= 1'b1;	end
		else if(x==98 && y==49) begin	plot <= 1'b1;	end
		else if(x==101 && y==49) begin	plot <= 1'b1;	end
		else if(x==102 && y==49) begin	plot <= 1'b1;	end
		else if(x==103 && y==49) begin	plot <= 1'b1;	end
		else if(x==104 && y==49) begin	plot <= 1'b1;	end
		else if(x==105 && y==49) begin	plot <= 1'b1;	end
		else if(x==115 && y==49) begin	plot <= 1'b1;	end
		else if(x==116 && y==49) begin	plot <= 1'b1;	end
		else if(x==117 && y==49) begin	plot <= 1'b1;	end
		else if(x==118 && y==49) begin	plot <= 1'b1;	end
		else if(x==119 && y==49) begin	plot <= 1'b1;	end
		else if(x==120 && y==49) begin	plot <= 1'b1;	end
		else if(x==121 && y==49) begin	plot <= 1'b1;	end
		else if(x==122 && y==49) begin	plot <= 1'b1;	end
		else if(x==123 && y==49) begin	plot <= 1'b1;	end
		else if(x==124 && y==49) begin	plot <= 1'b1;	end
		else if(x==127 && y==49) begin	plot <= 1'b1;	end
		else if(x==128 && y==49) begin	plot <= 1'b1;	end
		else if(x==129 && y==49) begin	plot <= 1'b1;	end
		else if(x==130 && y==49) begin	plot <= 1'b1;	end
		else if(x==131 && y==49) begin	plot <= 1'b1;	end
		else if(x==132 && y==49) begin	plot <= 1'b1;	end
		else if(x==133 && y==49) begin	plot <= 1'b1;	end
		else if(x==134 && y==49) begin	plot <= 1'b1;	end
		else if(x==135 && y==49) begin	plot <= 1'b1;	end
		else if(x==136 && y==49) begin	plot <= 1'b1;	end
		else if(x==137 && y==49) begin	plot <= 1'b1;	end
		else if(x==147 && y==49) begin	plot <= 1'b1;	end
		else if(x==148 && y==49) begin	plot <= 1'b1;	end
		else if(x==149 && y==49) begin	plot <= 1'b1;	end
		else if(x==150 && y==49) begin	plot <= 1'b1;	end
		else if(x==151 && y==49) begin	plot <= 1'b1;	end
		else if(x==153 && y==49) begin	plot <= 1'b1;	end
		else if(x==154 && y==49) begin	plot <= 1'b1;	end
		else if(x==155 && y==49) begin	plot <= 1'b1;	end
		else if(x==156 && y==49) begin	plot <= 1'b1;	end
		else if(x==157 && y==49) begin	plot <= 1'b1;	end
		else if(x==161 && y==49) begin	plot <= 1'b1;	end
		else if(x==162 && y==49) begin	plot <= 1'b1;	end
		else if(x==163 && y==49) begin	plot <= 1'b1;	end
		else if(x==164 && y==49) begin	plot <= 1'b1;	end
		else if(x==165 && y==49) begin	plot <= 1'b1;	end
		else if(x==167 && y==49) begin	plot <= 1'b1;	end
		else if(x==168 && y==49) begin	plot <= 1'b1;	end
		else if(x==169 && y==49) begin	plot <= 1'b1;	end
		else if(x==170 && y==49) begin	plot <= 1'b1;	end
		else if(x==180 && y==49) begin	plot <= 1'b1;	end
		else if(x==181 && y==49) begin	plot <= 1'b1;	end
		else if(x==182 && y==49) begin	plot <= 1'b1;	end
		else if(x==183 && y==49) begin	plot <= 1'b1;	end
		else if(x==184 && y==49) begin	plot <= 1'b1;	end
		else if(x==185 && y==49) begin	plot <= 1'b1;	end
		else if(x==186 && y==49) begin	plot <= 1'b1;	end
		else if(x==187 && y==49) begin	plot <= 1'b1;	end
		else if(x==188 && y==49) begin	plot <= 1'b1;	end
		else if(x==189 && y==49) begin	plot <= 1'b1;	end
		else if(x==190 && y==49) begin	plot <= 1'b1;	end
		else if(x==194 && y==49) begin	plot <= 1'b1;	end
		else if(x==195 && y==49) begin	plot <= 1'b1;	end
		else if(x==196 && y==49) begin	plot <= 1'b1;	end
		else if(x==197 && y==49) begin	plot <= 1'b1;	end
		else if(x==199 && y==49) begin	plot <= 1'b1;	end
		else if(x==200 && y==49) begin	plot <= 1'b1;	end
		else if(x==201 && y==49) begin	plot <= 1'b1;	end
		else if(x==202 && y==49) begin	plot <= 1'b1;	end
		else if(x==203 && y==49) begin	plot <= 1'b1;	end
		else if(x==206 && y==49) begin	plot <= 1'b1;	end
		else if(x==207 && y==49) begin	plot <= 1'b1;	end
		else if(x==208 && y==49) begin	plot <= 1'b1;	end
		else if(x==209 && y==49) begin	plot <= 1'b1;	end
		else if(x==210 && y==49) begin	plot <= 1'b1;	end
		else if(x==211 && y==49) begin	plot <= 1'b1;	end
		else if(x==214 && y==49) begin	plot <= 1'b1;	end
		else if(x==215 && y==49) begin	plot <= 1'b1;	end
		else if(x==216 && y==49) begin	plot <= 1'b1;	end
		else if(x==217 && y==49) begin	plot <= 1'b1;	end
		else if(x==219 && y==49) begin	plot <= 1'b1;	end
		else if(x==220 && y==49) begin	plot <= 1'b1;	end
		else if(x==221 && y==49) begin	plot <= 1'b1;	end
		else if(x==222 && y==49) begin	plot <= 1'b1;	end
		else if(x==223 && y==49) begin	plot <= 1'b1;	end
		else if(x==226 && y==49) begin	plot <= 1'b1;	end
		else if(x==227 && y==49) begin	plot <= 1'b1;	end
		else if(x==228 && y==49) begin	plot <= 1'b1;	end
		else if(x==229 && y==49) begin	plot <= 1'b1;	end
		else if(x==230 && y==49) begin	plot <= 1'b1;	end
		else if(x==231 && y==49) begin	plot <= 1'b1;	end
		else if(x==232 && y==49) begin	plot <= 1'b1;	end
		else if(x==233 && y==49) begin	plot <= 1'b1;	end
		else if(x==234 && y==49) begin	plot <= 1'b1;	end
		else if(x==235 && y==49) begin	plot <= 1'b1;	end
		else if(x==240 && y==49) begin	plot <= 1'b1;	end
		else if(x==241 && y==49) begin	plot <= 1'b1;	end
		else if(x==242 && y==49) begin	plot <= 1'b1;	end
		else if(x==243 && y==49) begin	plot <= 1'b1;	end
		else if(x==245 && y==49) begin	plot <= 1'b1;	end
		else if(x==246 && y==49) begin	plot <= 1'b1;	end
		else if(x==247 && y==49) begin	plot <= 1'b1;	end
		else if(x==248 && y==49) begin	plot <= 1'b1;	end
		else if(x==249 && y==49) begin	plot <= 1'b1;	end
		else if(x==78 && y==50) begin	plot <= 1'b1;	end
		else if(x==79 && y==50) begin	plot <= 1'b1;	end
		else if(x==80 && y==50) begin	plot <= 1'b1;	end
		else if(x==81 && y==50) begin	plot <= 1'b1;	end
		else if(x==88 && y==50) begin	plot <= 1'b1;	end
		else if(x==89 && y==50) begin	plot <= 1'b1;	end
		else if(x==90 && y==50) begin	plot <= 1'b1;	end
		else if(x==91 && y==50) begin	plot <= 1'b1;	end
		else if(x==92 && y==50) begin	plot <= 1'b1;	end
		else if(x==95 && y==50) begin	plot <= 1'b1;	end
		else if(x==96 && y==50) begin	plot <= 1'b1;	end
		else if(x==97 && y==50) begin	plot <= 1'b1;	end
		else if(x==98 && y==50) begin	plot <= 1'b1;	end
		else if(x==101 && y==50) begin	plot <= 1'b1;	end
		else if(x==102 && y==50) begin	plot <= 1'b1;	end
		else if(x==103 && y==50) begin	plot <= 1'b1;	end
		else if(x==104 && y==50) begin	plot <= 1'b1;	end
		else if(x==105 && y==50) begin	plot <= 1'b1;	end
		else if(x==115 && y==50) begin	plot <= 1'b1;	end
		else if(x==116 && y==50) begin	plot <= 1'b1;	end
		else if(x==117 && y==50) begin	plot <= 1'b1;	end
		else if(x==118 && y==50) begin	plot <= 1'b1;	end
		else if(x==127 && y==50) begin	plot <= 1'b1;	end
		else if(x==128 && y==50) begin	plot <= 1'b1;	end
		else if(x==129 && y==50) begin	plot <= 1'b1;	end
		else if(x==130 && y==50) begin	plot <= 1'b1;	end
		else if(x==131 && y==50) begin	plot <= 1'b1;	end
		else if(x==132 && y==50) begin	plot <= 1'b1;	end
		else if(x==147 && y==50) begin	plot <= 1'b1;	end
		else if(x==148 && y==50) begin	plot <= 1'b1;	end
		else if(x==149 && y==50) begin	plot <= 1'b1;	end
		else if(x==150 && y==50) begin	plot <= 1'b1;	end
		else if(x==151 && y==50) begin	plot <= 1'b1;	end
		else if(x==154 && y==50) begin	plot <= 1'b1;	end
		else if(x==155 && y==50) begin	plot <= 1'b1;	end
		else if(x==156 && y==50) begin	plot <= 1'b1;	end
		else if(x==157 && y==50) begin	plot <= 1'b1;	end
		else if(x==160 && y==50) begin	plot <= 1'b1;	end
		else if(x==161 && y==50) begin	plot <= 1'b1;	end
		else if(x==162 && y==50) begin	plot <= 1'b1;	end
		else if(x==163 && y==50) begin	plot <= 1'b1;	end
		else if(x==164 && y==50) begin	plot <= 1'b1;	end
		else if(x==180 && y==50) begin	plot <= 1'b1;	end
		else if(x==181 && y==50) begin	plot <= 1'b1;	end
		else if(x==182 && y==50) begin	plot <= 1'b1;	end
		else if(x==183 && y==50) begin	plot <= 1'b1;	end
		else if(x==184 && y==50) begin	plot <= 1'b1;	end
		else if(x==187 && y==50) begin	plot <= 1'b1;	end
		else if(x==188 && y==50) begin	plot <= 1'b1;	end
		else if(x==189 && y==50) begin	plot <= 1'b1;	end
		else if(x==190 && y==50) begin	plot <= 1'b1;	end
		else if(x==194 && y==50) begin	plot <= 1'b1;	end
		else if(x==195 && y==50) begin	plot <= 1'b1;	end
		else if(x==196 && y==50) begin	plot <= 1'b1;	end
		else if(x==197 && y==50) begin	plot <= 1'b1;	end
		else if(x==200 && y==50) begin	plot <= 1'b1;	end
		else if(x==201 && y==50) begin	plot <= 1'b1;	end
		else if(x==202 && y==50) begin	plot <= 1'b1;	end
		else if(x==203 && y==50) begin	plot <= 1'b1;	end
		else if(x==206 && y==50) begin	plot <= 1'b1;	end
		else if(x==207 && y==50) begin	plot <= 1'b1;	end
		else if(x==208 && y==50) begin	plot <= 1'b1;	end
		else if(x==209 && y==50) begin	plot <= 1'b1;	end
		else if(x==210 && y==50) begin	plot <= 1'b1;	end
		else if(x==211 && y==50) begin	plot <= 1'b1;	end
		else if(x==214 && y==50) begin	plot <= 1'b1;	end
		else if(x==215 && y==50) begin	plot <= 1'b1;	end
		else if(x==216 && y==50) begin	plot <= 1'b1;	end
		else if(x==219 && y==50) begin	plot <= 1'b1;	end
		else if(x==220 && y==50) begin	plot <= 1'b1;	end
		else if(x==221 && y==50) begin	plot <= 1'b1;	end
		else if(x==222 && y==50) begin	plot <= 1'b1;	end
		else if(x==223 && y==50) begin	plot <= 1'b1;	end
		else if(x==226 && y==50) begin	plot <= 1'b1;	end
		else if(x==227 && y==50) begin	plot <= 1'b1;	end
		else if(x==228 && y==50) begin	plot <= 1'b1;	end
		else if(x==229 && y==50) begin	plot <= 1'b1;	end
		else if(x==230 && y==50) begin	plot <= 1'b1;	end
		else if(x==240 && y==50) begin	plot <= 1'b1;	end
		else if(x==241 && y==50) begin	plot <= 1'b1;	end
		else if(x==242 && y==50) begin	plot <= 1'b1;	end
		else if(x==243 && y==50) begin	plot <= 1'b1;	end
		else if(x==246 && y==50) begin	plot <= 1'b1;	end
		else if(x==247 && y==50) begin	plot <= 1'b1;	end
		else if(x==248 && y==50) begin	plot <= 1'b1;	end
		else if(x==249 && y==50) begin	plot <= 1'b1;	end
		else if(x==79 && y==51) begin	plot <= 1'b1;	end
		else if(x==80 && y==51) begin	plot <= 1'b1;	end
		else if(x==81 && y==51) begin	plot <= 1'b1;	end
		else if(x==88 && y==51) begin	plot <= 1'b1;	end
		else if(x==89 && y==51) begin	plot <= 1'b1;	end
		else if(x==90 && y==51) begin	plot <= 1'b1;	end
		else if(x==91 && y==51) begin	plot <= 1'b1;	end
		else if(x==92 && y==51) begin	plot <= 1'b1;	end
		else if(x==95 && y==51) begin	plot <= 1'b1;	end
		else if(x==96 && y==51) begin	plot <= 1'b1;	end
		else if(x==97 && y==51) begin	plot <= 1'b1;	end
		else if(x==98 && y==51) begin	plot <= 1'b1;	end
		else if(x==101 && y==51) begin	plot <= 1'b1;	end
		else if(x==102 && y==51) begin	plot <= 1'b1;	end
		else if(x==103 && y==51) begin	plot <= 1'b1;	end
		else if(x==104 && y==51) begin	plot <= 1'b1;	end
		else if(x==105 && y==51) begin	plot <= 1'b1;	end
		else if(x==115 && y==51) begin	plot <= 1'b1;	end
		else if(x==116 && y==51) begin	plot <= 1'b1;	end
		else if(x==117 && y==51) begin	plot <= 1'b1;	end
		else if(x==118 && y==51) begin	plot <= 1'b1;	end
		else if(x==127 && y==51) begin	plot <= 1'b1;	end
		else if(x==128 && y==51) begin	plot <= 1'b1;	end
		else if(x==129 && y==51) begin	plot <= 1'b1;	end
		else if(x==130 && y==51) begin	plot <= 1'b1;	end
		else if(x==131 && y==51) begin	plot <= 1'b1;	end
		else if(x==132 && y==51) begin	plot <= 1'b1;	end
		else if(x==147 && y==51) begin	plot <= 1'b1;	end
		else if(x==148 && y==51) begin	plot <= 1'b1;	end
		else if(x==149 && y==51) begin	plot <= 1'b1;	end
		else if(x==150 && y==51) begin	plot <= 1'b1;	end
		else if(x==151 && y==51) begin	plot <= 1'b1;	end
		else if(x==154 && y==51) begin	plot <= 1'b1;	end
		else if(x==155 && y==51) begin	plot <= 1'b1;	end
		else if(x==156 && y==51) begin	plot <= 1'b1;	end
		else if(x==157 && y==51) begin	plot <= 1'b1;	end
		else if(x==160 && y==51) begin	plot <= 1'b1;	end
		else if(x==161 && y==51) begin	plot <= 1'b1;	end
		else if(x==162 && y==51) begin	plot <= 1'b1;	end
		else if(x==163 && y==51) begin	plot <= 1'b1;	end
		else if(x==164 && y==51) begin	plot <= 1'b1;	end
		else if(x==180 && y==51) begin	plot <= 1'b1;	end
		else if(x==181 && y==51) begin	plot <= 1'b1;	end
		else if(x==182 && y==51) begin	plot <= 1'b1;	end
		else if(x==183 && y==51) begin	plot <= 1'b1;	end
		else if(x==184 && y==51) begin	plot <= 1'b1;	end
		else if(x==186 && y==51) begin	plot <= 1'b1;	end
		else if(x==187 && y==51) begin	plot <= 1'b1;	end
		else if(x==188 && y==51) begin	plot <= 1'b1;	end
		else if(x==189 && y==51) begin	plot <= 1'b1;	end
		else if(x==190 && y==51) begin	plot <= 1'b1;	end
		else if(x==194 && y==51) begin	plot <= 1'b1;	end
		else if(x==195 && y==51) begin	plot <= 1'b1;	end
		else if(x==196 && y==51) begin	plot <= 1'b1;	end
		else if(x==197 && y==51) begin	plot <= 1'b1;	end
		else if(x==200 && y==51) begin	plot <= 1'b1;	end
		else if(x==201 && y==51) begin	plot <= 1'b1;	end
		else if(x==202 && y==51) begin	plot <= 1'b1;	end
		else if(x==203 && y==51) begin	plot <= 1'b1;	end
		else if(x==206 && y==51) begin	plot <= 1'b1;	end
		else if(x==207 && y==51) begin	plot <= 1'b1;	end
		else if(x==208 && y==51) begin	plot <= 1'b1;	end
		else if(x==209 && y==51) begin	plot <= 1'b1;	end
		else if(x==210 && y==51) begin	plot <= 1'b1;	end
		else if(x==211 && y==51) begin	plot <= 1'b1;	end
		else if(x==214 && y==51) begin	plot <= 1'b1;	end
		else if(x==215 && y==51) begin	plot <= 1'b1;	end
		else if(x==216 && y==51) begin	plot <= 1'b1;	end
		else if(x==219 && y==51) begin	plot <= 1'b1;	end
		else if(x==220 && y==51) begin	plot <= 1'b1;	end
		else if(x==221 && y==51) begin	plot <= 1'b1;	end
		else if(x==222 && y==51) begin	plot <= 1'b1;	end
		else if(x==223 && y==51) begin	plot <= 1'b1;	end
		else if(x==226 && y==51) begin	plot <= 1'b1;	end
		else if(x==227 && y==51) begin	plot <= 1'b1;	end
		else if(x==228 && y==51) begin	plot <= 1'b1;	end
		else if(x==229 && y==51) begin	plot <= 1'b1;	end
		else if(x==230 && y==51) begin	plot <= 1'b1;	end
		else if(x==240 && y==51) begin	plot <= 1'b1;	end
		else if(x==241 && y==51) begin	plot <= 1'b1;	end
		else if(x==242 && y==51) begin	plot <= 1'b1;	end
		else if(x==243 && y==51) begin	plot <= 1'b1;	end
		else if(x==246 && y==51) begin	plot <= 1'b1;	end
		else if(x==247 && y==51) begin	plot <= 1'b1;	end
		else if(x==248 && y==51) begin	plot <= 1'b1;	end
		else if(x==249 && y==51) begin	plot <= 1'b1;	end
		else if(x==79 && y==52) begin	plot <= 1'b1;	end
		else if(x==80 && y==52) begin	plot <= 1'b1;	end
		else if(x==81 && y==52) begin	plot <= 1'b1;	end
		else if(x==88 && y==52) begin	plot <= 1'b1;	end
		else if(x==89 && y==52) begin	plot <= 1'b1;	end
		else if(x==90 && y==52) begin	plot <= 1'b1;	end
		else if(x==91 && y==52) begin	plot <= 1'b1;	end
		else if(x==92 && y==52) begin	plot <= 1'b1;	end
		else if(x==93 && y==52) begin	plot <= 1'b1;	end
		else if(x==94 && y==52) begin	plot <= 1'b1;	end
		else if(x==95 && y==52) begin	plot <= 1'b1;	end
		else if(x==96 && y==52) begin	plot <= 1'b1;	end
		else if(x==97 && y==52) begin	plot <= 1'b1;	end
		else if(x==98 && y==52) begin	plot <= 1'b1;	end
		else if(x==101 && y==52) begin	plot <= 1'b1;	end
		else if(x==102 && y==52) begin	plot <= 1'b1;	end
		else if(x==103 && y==52) begin	plot <= 1'b1;	end
		else if(x==104 && y==52) begin	plot <= 1'b1;	end
		else if(x==105 && y==52) begin	plot <= 1'b1;	end
		else if(x==115 && y==52) begin	plot <= 1'b1;	end
		else if(x==116 && y==52) begin	plot <= 1'b1;	end
		else if(x==117 && y==52) begin	plot <= 1'b1;	end
		else if(x==118 && y==52) begin	plot <= 1'b1;	end
		else if(x==119 && y==52) begin	plot <= 1'b1;	end
		else if(x==120 && y==52) begin	plot <= 1'b1;	end
		else if(x==121 && y==52) begin	plot <= 1'b1;	end
		else if(x==127 && y==52) begin	plot <= 1'b1;	end
		else if(x==128 && y==52) begin	plot <= 1'b1;	end
		else if(x==129 && y==52) begin	plot <= 1'b1;	end
		else if(x==130 && y==52) begin	plot <= 1'b1;	end
		else if(x==131 && y==52) begin	plot <= 1'b1;	end
		else if(x==132 && y==52) begin	plot <= 1'b1;	end
		else if(x==133 && y==52) begin	plot <= 1'b1;	end
		else if(x==134 && y==52) begin	plot <= 1'b1;	end
		else if(x==135 && y==52) begin	plot <= 1'b1;	end
		else if(x==136 && y==52) begin	plot <= 1'b1;	end
		else if(x==137 && y==52) begin	plot <= 1'b1;	end
		else if(x==147 && y==52) begin	plot <= 1'b1;	end
		else if(x==148 && y==52) begin	plot <= 1'b1;	end
		else if(x==149 && y==52) begin	plot <= 1'b1;	end
		else if(x==150 && y==52) begin	plot <= 1'b1;	end
		else if(x==151 && y==52) begin	plot <= 1'b1;	end
		else if(x==154 && y==52) begin	plot <= 1'b1;	end
		else if(x==155 && y==52) begin	plot <= 1'b1;	end
		else if(x==156 && y==52) begin	plot <= 1'b1;	end
		else if(x==157 && y==52) begin	plot <= 1'b1;	end
		else if(x==160 && y==52) begin	plot <= 1'b1;	end
		else if(x==161 && y==52) begin	plot <= 1'b1;	end
		else if(x==162 && y==52) begin	plot <= 1'b1;	end
		else if(x==163 && y==52) begin	plot <= 1'b1;	end
		else if(x==164 && y==52) begin	plot <= 1'b1;	end
		else if(x==165 && y==52) begin	plot <= 1'b1;	end
		else if(x==166 && y==52) begin	plot <= 1'b1;	end
		else if(x==167 && y==52) begin	plot <= 1'b1;	end
		else if(x==180 && y==52) begin	plot <= 1'b1;	end
		else if(x==181 && y==52) begin	plot <= 1'b1;	end
		else if(x==182 && y==52) begin	plot <= 1'b1;	end
		else if(x==183 && y==52) begin	plot <= 1'b1;	end
		else if(x==184 && y==52) begin	plot <= 1'b1;	end
		else if(x==185 && y==52) begin	plot <= 1'b1;	end
		else if(x==186 && y==52) begin	plot <= 1'b1;	end
		else if(x==187 && y==52) begin	plot <= 1'b1;	end
		else if(x==188 && y==52) begin	plot <= 1'b1;	end
		else if(x==189 && y==52) begin	plot <= 1'b1;	end
		else if(x==194 && y==52) begin	plot <= 1'b1;	end
		else if(x==195 && y==52) begin	plot <= 1'b1;	end
		else if(x==196 && y==52) begin	plot <= 1'b1;	end
		else if(x==197 && y==52) begin	plot <= 1'b1;	end
		else if(x==198 && y==52) begin	plot <= 1'b1;	end
		else if(x==199 && y==52) begin	plot <= 1'b1;	end
		else if(x==200 && y==52) begin	plot <= 1'b1;	end
		else if(x==201 && y==52) begin	plot <= 1'b1;	end
		else if(x==202 && y==52) begin	plot <= 1'b1;	end
		else if(x==203 && y==52) begin	plot <= 1'b1;	end
		else if(x==206 && y==52) begin	plot <= 1'b1;	end
		else if(x==207 && y==52) begin	plot <= 1'b1;	end
		else if(x==208 && y==52) begin	plot <= 1'b1;	end
		else if(x==209 && y==52) begin	plot <= 1'b1;	end
		else if(x==210 && y==52) begin	plot <= 1'b1;	end
		else if(x==211 && y==52) begin	plot <= 1'b1;	end
		else if(x==214 && y==52) begin	plot <= 1'b1;	end
		else if(x==215 && y==52) begin	plot <= 1'b1;	end
		else if(x==216 && y==52) begin	plot <= 1'b1;	end
		else if(x==219 && y==52) begin	plot <= 1'b1;	end
		else if(x==220 && y==52) begin	plot <= 1'b1;	end
		else if(x==221 && y==52) begin	plot <= 1'b1;	end
		else if(x==222 && y==52) begin	plot <= 1'b1;	end
		else if(x==223 && y==52) begin	plot <= 1'b1;	end
		else if(x==226 && y==52) begin	plot <= 1'b1;	end
		else if(x==227 && y==52) begin	plot <= 1'b1;	end
		else if(x==228 && y==52) begin	plot <= 1'b1;	end
		else if(x==229 && y==52) begin	plot <= 1'b1;	end
		else if(x==230 && y==52) begin	plot <= 1'b1;	end
		else if(x==231 && y==52) begin	plot <= 1'b1;	end
		else if(x==232 && y==52) begin	plot <= 1'b1;	end
		else if(x==233 && y==52) begin	plot <= 1'b1;	end
		else if(x==240 && y==52) begin	plot <= 1'b1;	end
		else if(x==241 && y==52) begin	plot <= 1'b1;	end
		else if(x==242 && y==52) begin	plot <= 1'b1;	end
		else if(x==243 && y==52) begin	plot <= 1'b1;	end
		else if(x==246 && y==52) begin	plot <= 1'b1;	end
		else if(x==247 && y==52) begin	plot <= 1'b1;	end
		else if(x==248 && y==52) begin	plot <= 1'b1;	end
		else if(x==249 && y==52) begin	plot <= 1'b1;	end
		else if(x==79 && y==53) begin	plot <= 1'b1;	end
		else if(x==80 && y==53) begin	plot <= 1'b1;	end
		else if(x==81 && y==53) begin	plot <= 1'b1;	end
		else if(x==88 && y==53) begin	plot <= 1'b1;	end
		else if(x==89 && y==53) begin	plot <= 1'b1;	end
		else if(x==90 && y==53) begin	plot <= 1'b1;	end
		else if(x==91 && y==53) begin	plot <= 1'b1;	end
		else if(x==92 && y==53) begin	plot <= 1'b1;	end
		else if(x==93 && y==53) begin	plot <= 1'b1;	end
		else if(x==94 && y==53) begin	plot <= 1'b1;	end
		else if(x==95 && y==53) begin	plot <= 1'b1;	end
		else if(x==96 && y==53) begin	plot <= 1'b1;	end
		else if(x==97 && y==53) begin	plot <= 1'b1;	end
		else if(x==98 && y==53) begin	plot <= 1'b1;	end
		else if(x==101 && y==53) begin	plot <= 1'b1;	end
		else if(x==102 && y==53) begin	plot <= 1'b1;	end
		else if(x==103 && y==53) begin	plot <= 1'b1;	end
		else if(x==104 && y==53) begin	plot <= 1'b1;	end
		else if(x==105 && y==53) begin	plot <= 1'b1;	end
		else if(x==115 && y==53) begin	plot <= 1'b1;	end
		else if(x==116 && y==53) begin	plot <= 1'b1;	end
		else if(x==117 && y==53) begin	plot <= 1'b1;	end
		else if(x==118 && y==53) begin	plot <= 1'b1;	end
		else if(x==119 && y==53) begin	plot <= 1'b1;	end
		else if(x==120 && y==53) begin	plot <= 1'b1;	end
		else if(x==129 && y==53) begin	plot <= 1'b1;	end
		else if(x==130 && y==53) begin	plot <= 1'b1;	end
		else if(x==131 && y==53) begin	plot <= 1'b1;	end
		else if(x==132 && y==53) begin	plot <= 1'b1;	end
		else if(x==133 && y==53) begin	plot <= 1'b1;	end
		else if(x==134 && y==53) begin	plot <= 1'b1;	end
		else if(x==135 && y==53) begin	plot <= 1'b1;	end
		else if(x==136 && y==53) begin	plot <= 1'b1;	end
		else if(x==137 && y==53) begin	plot <= 1'b1;	end
		else if(x==147 && y==53) begin	plot <= 1'b1;	end
		else if(x==148 && y==53) begin	plot <= 1'b1;	end
		else if(x==149 && y==53) begin	plot <= 1'b1;	end
		else if(x==150 && y==53) begin	plot <= 1'b1;	end
		else if(x==151 && y==53) begin	plot <= 1'b1;	end
		else if(x==154 && y==53) begin	plot <= 1'b1;	end
		else if(x==155 && y==53) begin	plot <= 1'b1;	end
		else if(x==156 && y==53) begin	plot <= 1'b1;	end
		else if(x==157 && y==53) begin	plot <= 1'b1;	end
		else if(x==160 && y==53) begin	plot <= 1'b1;	end
		else if(x==161 && y==53) begin	plot <= 1'b1;	end
		else if(x==162 && y==53) begin	plot <= 1'b1;	end
		else if(x==163 && y==53) begin	plot <= 1'b1;	end
		else if(x==164 && y==53) begin	plot <= 1'b1;	end
		else if(x==165 && y==53) begin	plot <= 1'b1;	end
		else if(x==166 && y==53) begin	plot <= 1'b1;	end
		else if(x==180 && y==53) begin	plot <= 1'b1;	end
		else if(x==181 && y==53) begin	plot <= 1'b1;	end
		else if(x==182 && y==53) begin	plot <= 1'b1;	end
		else if(x==183 && y==53) begin	plot <= 1'b1;	end
		else if(x==184 && y==53) begin	plot <= 1'b1;	end
		else if(x==185 && y==53) begin	plot <= 1'b1;	end
		else if(x==186 && y==53) begin	plot <= 1'b1;	end
		else if(x==187 && y==53) begin	plot <= 1'b1;	end
		else if(x==188 && y==53) begin	plot <= 1'b1;	end
		else if(x==189 && y==53) begin	plot <= 1'b1;	end
		else if(x==194 && y==53) begin	plot <= 1'b1;	end
		else if(x==195 && y==53) begin	plot <= 1'b1;	end
		else if(x==196 && y==53) begin	plot <= 1'b1;	end
		else if(x==197 && y==53) begin	plot <= 1'b1;	end
		else if(x==198 && y==53) begin	plot <= 1'b1;	end
		else if(x==199 && y==53) begin	plot <= 1'b1;	end
		else if(x==200 && y==53) begin	plot <= 1'b1;	end
		else if(x==201 && y==53) begin	plot <= 1'b1;	end
		else if(x==202 && y==53) begin	plot <= 1'b1;	end
		else if(x==203 && y==53) begin	plot <= 1'b1;	end
		else if(x==206 && y==53) begin	plot <= 1'b1;	end
		else if(x==207 && y==53) begin	plot <= 1'b1;	end
		else if(x==208 && y==53) begin	plot <= 1'b1;	end
		else if(x==209 && y==53) begin	plot <= 1'b1;	end
		else if(x==210 && y==53) begin	plot <= 1'b1;	end
		else if(x==211 && y==53) begin	plot <= 1'b1;	end
		else if(x==214 && y==53) begin	plot <= 1'b1;	end
		else if(x==215 && y==53) begin	plot <= 1'b1;	end
		else if(x==216 && y==53) begin	plot <= 1'b1;	end
		else if(x==219 && y==53) begin	plot <= 1'b1;	end
		else if(x==220 && y==53) begin	plot <= 1'b1;	end
		else if(x==221 && y==53) begin	plot <= 1'b1;	end
		else if(x==222 && y==53) begin	plot <= 1'b1;	end
		else if(x==223 && y==53) begin	plot <= 1'b1;	end
		else if(x==226 && y==53) begin	plot <= 1'b1;	end
		else if(x==227 && y==53) begin	plot <= 1'b1;	end
		else if(x==228 && y==53) begin	plot <= 1'b1;	end
		else if(x==229 && y==53) begin	plot <= 1'b1;	end
		else if(x==230 && y==53) begin	plot <= 1'b1;	end
		else if(x==231 && y==53) begin	plot <= 1'b1;	end
		else if(x==232 && y==53) begin	plot <= 1'b1;	end
		else if(x==233 && y==53) begin	plot <= 1'b1;	end
		else if(x==240 && y==53) begin	plot <= 1'b1;	end
		else if(x==241 && y==53) begin	plot <= 1'b1;	end
		else if(x==242 && y==53) begin	plot <= 1'b1;	end
		else if(x==243 && y==53) begin	plot <= 1'b1;	end
		else if(x==246 && y==53) begin	plot <= 1'b1;	end
		else if(x==247 && y==53) begin	plot <= 1'b1;	end
		else if(x==248 && y==53) begin	plot <= 1'b1;	end
		else if(x==249 && y==53) begin	plot <= 1'b1;	end
		else if(x==79 && y==54) begin	plot <= 1'b1;	end
		else if(x==80 && y==54) begin	plot <= 1'b1;	end
		else if(x==81 && y==54) begin	plot <= 1'b1;	end
		else if(x==88 && y==54) begin	plot <= 1'b1;	end
		else if(x==89 && y==54) begin	plot <= 1'b1;	end
		else if(x==90 && y==54) begin	plot <= 1'b1;	end
		else if(x==91 && y==54) begin	plot <= 1'b1;	end
		else if(x==92 && y==54) begin	plot <= 1'b1;	end
		else if(x==95 && y==54) begin	plot <= 1'b1;	end
		else if(x==96 && y==54) begin	plot <= 1'b1;	end
		else if(x==97 && y==54) begin	plot <= 1'b1;	end
		else if(x==98 && y==54) begin	plot <= 1'b1;	end
		else if(x==101 && y==54) begin	plot <= 1'b1;	end
		else if(x==102 && y==54) begin	plot <= 1'b1;	end
		else if(x==103 && y==54) begin	plot <= 1'b1;	end
		else if(x==104 && y==54) begin	plot <= 1'b1;	end
		else if(x==105 && y==54) begin	plot <= 1'b1;	end
		else if(x==115 && y==54) begin	plot <= 1'b1;	end
		else if(x==116 && y==54) begin	plot <= 1'b1;	end
		else if(x==117 && y==54) begin	plot <= 1'b1;	end
		else if(x==118 && y==54) begin	plot <= 1'b1;	end
		else if(x==134 && y==54) begin	plot <= 1'b1;	end
		else if(x==135 && y==54) begin	plot <= 1'b1;	end
		else if(x==136 && y==54) begin	plot <= 1'b1;	end
		else if(x==137 && y==54) begin	plot <= 1'b1;	end
		else if(x==138 && y==54) begin	plot <= 1'b1;	end
		else if(x==147 && y==54) begin	plot <= 1'b1;	end
		else if(x==148 && y==54) begin	plot <= 1'b1;	end
		else if(x==149 && y==54) begin	plot <= 1'b1;	end
		else if(x==150 && y==54) begin	plot <= 1'b1;	end
		else if(x==151 && y==54) begin	plot <= 1'b1;	end
		else if(x==154 && y==54) begin	plot <= 1'b1;	end
		else if(x==155 && y==54) begin	plot <= 1'b1;	end
		else if(x==156 && y==54) begin	plot <= 1'b1;	end
		else if(x==157 && y==54) begin	plot <= 1'b1;	end
		else if(x==160 && y==54) begin	plot <= 1'b1;	end
		else if(x==161 && y==54) begin	plot <= 1'b1;	end
		else if(x==162 && y==54) begin	plot <= 1'b1;	end
		else if(x==163 && y==54) begin	plot <= 1'b1;	end
		else if(x==164 && y==54) begin	plot <= 1'b1;	end
		else if(x==180 && y==54) begin	plot <= 1'b1;	end
		else if(x==181 && y==54) begin	plot <= 1'b1;	end
		else if(x==182 && y==54) begin	plot <= 1'b1;	end
		else if(x==183 && y==54) begin	plot <= 1'b1;	end
		else if(x==184 && y==54) begin	plot <= 1'b1;	end
		else if(x==187 && y==54) begin	plot <= 1'b1;	end
		else if(x==188 && y==54) begin	plot <= 1'b1;	end
		else if(x==189 && y==54) begin	plot <= 1'b1;	end
		else if(x==194 && y==54) begin	plot <= 1'b1;	end
		else if(x==195 && y==54) begin	plot <= 1'b1;	end
		else if(x==196 && y==54) begin	plot <= 1'b1;	end
		else if(x==197 && y==54) begin	plot <= 1'b1;	end
		else if(x==200 && y==54) begin	plot <= 1'b1;	end
		else if(x==201 && y==54) begin	plot <= 1'b1;	end
		else if(x==202 && y==54) begin	plot <= 1'b1;	end
		else if(x==203 && y==54) begin	plot <= 1'b1;	end
		else if(x==206 && y==54) begin	plot <= 1'b1;	end
		else if(x==207 && y==54) begin	plot <= 1'b1;	end
		else if(x==208 && y==54) begin	plot <= 1'b1;	end
		else if(x==209 && y==54) begin	plot <= 1'b1;	end
		else if(x==210 && y==54) begin	plot <= 1'b1;	end
		else if(x==211 && y==54) begin	plot <= 1'b1;	end
		else if(x==214 && y==54) begin	plot <= 1'b1;	end
		else if(x==215 && y==54) begin	plot <= 1'b1;	end
		else if(x==216 && y==54) begin	plot <= 1'b1;	end
		else if(x==219 && y==54) begin	plot <= 1'b1;	end
		else if(x==220 && y==54) begin	plot <= 1'b1;	end
		else if(x==221 && y==54) begin	plot <= 1'b1;	end
		else if(x==222 && y==54) begin	plot <= 1'b1;	end
		else if(x==223 && y==54) begin	plot <= 1'b1;	end
		else if(x==226 && y==54) begin	plot <= 1'b1;	end
		else if(x==227 && y==54) begin	plot <= 1'b1;	end
		else if(x==228 && y==54) begin	plot <= 1'b1;	end
		else if(x==229 && y==54) begin	plot <= 1'b1;	end
		else if(x==230 && y==54) begin	plot <= 1'b1;	end
		else if(x==240 && y==54) begin	plot <= 1'b1;	end
		else if(x==241 && y==54) begin	plot <= 1'b1;	end
		else if(x==242 && y==54) begin	plot <= 1'b1;	end
		else if(x==243 && y==54) begin	plot <= 1'b1;	end
		else if(x==246 && y==54) begin	plot <= 1'b1;	end
		else if(x==247 && y==54) begin	plot <= 1'b1;	end
		else if(x==248 && y==54) begin	plot <= 1'b1;	end
		else if(x==249 && y==54) begin	plot <= 1'b1;	end
		else if(x==79 && y==55) begin	plot <= 1'b1;	end
		else if(x==80 && y==55) begin	plot <= 1'b1;	end
		else if(x==81 && y==55) begin	plot <= 1'b1;	end
		else if(x==88 && y==55) begin	plot <= 1'b1;	end
		else if(x==89 && y==55) begin	plot <= 1'b1;	end
		else if(x==90 && y==55) begin	plot <= 1'b1;	end
		else if(x==91 && y==55) begin	plot <= 1'b1;	end
		else if(x==92 && y==55) begin	plot <= 1'b1;	end
		else if(x==95 && y==55) begin	plot <= 1'b1;	end
		else if(x==96 && y==55) begin	plot <= 1'b1;	end
		else if(x==97 && y==55) begin	plot <= 1'b1;	end
		else if(x==98 && y==55) begin	plot <= 1'b1;	end
		else if(x==101 && y==55) begin	plot <= 1'b1;	end
		else if(x==102 && y==55) begin	plot <= 1'b1;	end
		else if(x==103 && y==55) begin	plot <= 1'b1;	end
		else if(x==104 && y==55) begin	plot <= 1'b1;	end
		else if(x==105 && y==55) begin	plot <= 1'b1;	end
		else if(x==115 && y==55) begin	plot <= 1'b1;	end
		else if(x==116 && y==55) begin	plot <= 1'b1;	end
		else if(x==117 && y==55) begin	plot <= 1'b1;	end
		else if(x==118 && y==55) begin	plot <= 1'b1;	end
		else if(x==134 && y==55) begin	plot <= 1'b1;	end
		else if(x==135 && y==55) begin	plot <= 1'b1;	end
		else if(x==136 && y==55) begin	plot <= 1'b1;	end
		else if(x==137 && y==55) begin	plot <= 1'b1;	end
		else if(x==138 && y==55) begin	plot <= 1'b1;	end
		else if(x==147 && y==55) begin	plot <= 1'b1;	end
		else if(x==148 && y==55) begin	plot <= 1'b1;	end
		else if(x==149 && y==55) begin	plot <= 1'b1;	end
		else if(x==150 && y==55) begin	plot <= 1'b1;	end
		else if(x==151 && y==55) begin	plot <= 1'b1;	end
		else if(x==154 && y==55) begin	plot <= 1'b1;	end
		else if(x==155 && y==55) begin	plot <= 1'b1;	end
		else if(x==156 && y==55) begin	plot <= 1'b1;	end
		else if(x==157 && y==55) begin	plot <= 1'b1;	end
		else if(x==160 && y==55) begin	plot <= 1'b1;	end
		else if(x==161 && y==55) begin	plot <= 1'b1;	end
		else if(x==162 && y==55) begin	plot <= 1'b1;	end
		else if(x==163 && y==55) begin	plot <= 1'b1;	end
		else if(x==164 && y==55) begin	plot <= 1'b1;	end
		else if(x==180 && y==55) begin	plot <= 1'b1;	end
		else if(x==181 && y==55) begin	plot <= 1'b1;	end
		else if(x==182 && y==55) begin	plot <= 1'b1;	end
		else if(x==183 && y==55) begin	plot <= 1'b1;	end
		else if(x==184 && y==55) begin	plot <= 1'b1;	end
		else if(x==187 && y==55) begin	plot <= 1'b1;	end
		else if(x==188 && y==55) begin	plot <= 1'b1;	end
		else if(x==189 && y==55) begin	plot <= 1'b1;	end
		else if(x==190 && y==55) begin	plot <= 1'b1;	end
		else if(x==194 && y==55) begin	plot <= 1'b1;	end
		else if(x==195 && y==55) begin	plot <= 1'b1;	end
		else if(x==196 && y==55) begin	plot <= 1'b1;	end
		else if(x==197 && y==55) begin	plot <= 1'b1;	end
		else if(x==200 && y==55) begin	plot <= 1'b1;	end
		else if(x==201 && y==55) begin	plot <= 1'b1;	end
		else if(x==202 && y==55) begin	plot <= 1'b1;	end
		else if(x==203 && y==55) begin	plot <= 1'b1;	end
		else if(x==206 && y==55) begin	plot <= 1'b1;	end
		else if(x==207 && y==55) begin	plot <= 1'b1;	end
		else if(x==208 && y==55) begin	plot <= 1'b1;	end
		else if(x==209 && y==55) begin	plot <= 1'b1;	end
		else if(x==210 && y==55) begin	plot <= 1'b1;	end
		else if(x==211 && y==55) begin	plot <= 1'b1;	end
		else if(x==214 && y==55) begin	plot <= 1'b1;	end
		else if(x==215 && y==55) begin	plot <= 1'b1;	end
		else if(x==216 && y==55) begin	plot <= 1'b1;	end
		else if(x==219 && y==55) begin	plot <= 1'b1;	end
		else if(x==220 && y==55) begin	plot <= 1'b1;	end
		else if(x==221 && y==55) begin	plot <= 1'b1;	end
		else if(x==222 && y==55) begin	plot <= 1'b1;	end
		else if(x==223 && y==55) begin	plot <= 1'b1;	end
		else if(x==226 && y==55) begin	plot <= 1'b1;	end
		else if(x==227 && y==55) begin	plot <= 1'b1;	end
		else if(x==228 && y==55) begin	plot <= 1'b1;	end
		else if(x==229 && y==55) begin	plot <= 1'b1;	end
		else if(x==230 && y==55) begin	plot <= 1'b1;	end
		else if(x==240 && y==55) begin	plot <= 1'b1;	end
		else if(x==241 && y==55) begin	plot <= 1'b1;	end
		else if(x==242 && y==55) begin	plot <= 1'b1;	end
		else if(x==243 && y==55) begin	plot <= 1'b1;	end
		else if(x==246 && y==55) begin	plot <= 1'b1;	end
		else if(x==247 && y==55) begin	plot <= 1'b1;	end
		else if(x==248 && y==55) begin	plot <= 1'b1;	end
		else if(x==249 && y==55) begin	plot <= 1'b1;	end
		else if(x==79 && y==56) begin	plot <= 1'b1;	end
		else if(x==80 && y==56) begin	plot <= 1'b1;	end
		else if(x==81 && y==56) begin	plot <= 1'b1;	end
		else if(x==88 && y==56) begin	plot <= 1'b1;	end
		else if(x==89 && y==56) begin	plot <= 1'b1;	end
		else if(x==90 && y==56) begin	plot <= 1'b1;	end
		else if(x==91 && y==56) begin	plot <= 1'b1;	end
		else if(x==92 && y==56) begin	plot <= 1'b1;	end
		else if(x==95 && y==56) begin	plot <= 1'b1;	end
		else if(x==96 && y==56) begin	plot <= 1'b1;	end
		else if(x==97 && y==56) begin	plot <= 1'b1;	end
		else if(x==98 && y==56) begin	plot <= 1'b1;	end
		else if(x==101 && y==56) begin	plot <= 1'b1;	end
		else if(x==102 && y==56) begin	plot <= 1'b1;	end
		else if(x==103 && y==56) begin	plot <= 1'b1;	end
		else if(x==104 && y==56) begin	plot <= 1'b1;	end
		else if(x==105 && y==56) begin	plot <= 1'b1;	end
		else if(x==106 && y==56) begin	plot <= 1'b1;	end
		else if(x==107 && y==56) begin	plot <= 1'b1;	end
		else if(x==108 && y==56) begin	plot <= 1'b1;	end
		else if(x==109 && y==56) begin	plot <= 1'b1;	end
		else if(x==110 && y==56) begin	plot <= 1'b1;	end
		else if(x==115 && y==56) begin	plot <= 1'b1;	end
		else if(x==116 && y==56) begin	plot <= 1'b1;	end
		else if(x==117 && y==56) begin	plot <= 1'b1;	end
		else if(x==118 && y==56) begin	plot <= 1'b1;	end
		else if(x==119 && y==56) begin	plot <= 1'b1;	end
		else if(x==120 && y==56) begin	plot <= 1'b1;	end
		else if(x==121 && y==56) begin	plot <= 1'b1;	end
		else if(x==122 && y==56) begin	plot <= 1'b1;	end
		else if(x==123 && y==56) begin	plot <= 1'b1;	end
		else if(x==124 && y==56) begin	plot <= 1'b1;	end
		else if(x==128 && y==56) begin	plot <= 1'b1;	end
		else if(x==129 && y==56) begin	plot <= 1'b1;	end
		else if(x==130 && y==56) begin	plot <= 1'b1;	end
		else if(x==131 && y==56) begin	plot <= 1'b1;	end
		else if(x==132 && y==56) begin	plot <= 1'b1;	end
		else if(x==133 && y==56) begin	plot <= 1'b1;	end
		else if(x==134 && y==56) begin	plot <= 1'b1;	end
		else if(x==135 && y==56) begin	plot <= 1'b1;	end
		else if(x==136 && y==56) begin	plot <= 1'b1;	end
		else if(x==137 && y==56) begin	plot <= 1'b1;	end
		else if(x==147 && y==56) begin	plot <= 1'b1;	end
		else if(x==148 && y==56) begin	plot <= 1'b1;	end
		else if(x==149 && y==56) begin	plot <= 1'b1;	end
		else if(x==150 && y==56) begin	plot <= 1'b1;	end
		else if(x==151 && y==56) begin	plot <= 1'b1;	end
		else if(x==152 && y==56) begin	plot <= 1'b1;	end
		else if(x==153 && y==56) begin	plot <= 1'b1;	end
		else if(x==154 && y==56) begin	plot <= 1'b1;	end
		else if(x==155 && y==56) begin	plot <= 1'b1;	end
		else if(x==156 && y==56) begin	plot <= 1'b1;	end
		else if(x==157 && y==56) begin	plot <= 1'b1;	end
		else if(x==160 && y==56) begin	plot <= 1'b1;	end
		else if(x==161 && y==56) begin	plot <= 1'b1;	end
		else if(x==162 && y==56) begin	plot <= 1'b1;	end
		else if(x==163 && y==56) begin	plot <= 1'b1;	end
		else if(x==164 && y==56) begin	plot <= 1'b1;	end
		else if(x==180 && y==56) begin	plot <= 1'b1;	end
		else if(x==181 && y==56) begin	plot <= 1'b1;	end
		else if(x==182 && y==56) begin	plot <= 1'b1;	end
		else if(x==183 && y==56) begin	plot <= 1'b1;	end
		else if(x==184 && y==56) begin	plot <= 1'b1;	end
		else if(x==187 && y==56) begin	plot <= 1'b1;	end
		else if(x==188 && y==56) begin	plot <= 1'b1;	end
		else if(x==189 && y==56) begin	plot <= 1'b1;	end
		else if(x==190 && y==56) begin	plot <= 1'b1;	end
		else if(x==194 && y==56) begin	plot <= 1'b1;	end
		else if(x==195 && y==56) begin	plot <= 1'b1;	end
		else if(x==196 && y==56) begin	plot <= 1'b1;	end
		else if(x==197 && y==56) begin	plot <= 1'b1;	end
		else if(x==200 && y==56) begin	plot <= 1'b1;	end
		else if(x==201 && y==56) begin	plot <= 1'b1;	end
		else if(x==202 && y==56) begin	plot <= 1'b1;	end
		else if(x==203 && y==56) begin	plot <= 1'b1;	end
		else if(x==206 && y==56) begin	plot <= 1'b1;	end
		else if(x==207 && y==56) begin	plot <= 1'b1;	end
		else if(x==208 && y==56) begin	plot <= 1'b1;	end
		else if(x==209 && y==56) begin	plot <= 1'b1;	end
		else if(x==210 && y==56) begin	plot <= 1'b1;	end
		else if(x==211 && y==56) begin	plot <= 1'b1;	end
		else if(x==214 && y==56) begin	plot <= 1'b1;	end
		else if(x==215 && y==56) begin	plot <= 1'b1;	end
		else if(x==216 && y==56) begin	plot <= 1'b1;	end
		else if(x==217 && y==56) begin	plot <= 1'b1;	end
		else if(x==218 && y==56) begin	plot <= 1'b1;	end
		else if(x==219 && y==56) begin	plot <= 1'b1;	end
		else if(x==220 && y==56) begin	plot <= 1'b1;	end
		else if(x==221 && y==56) begin	plot <= 1'b1;	end
		else if(x==222 && y==56) begin	plot <= 1'b1;	end
		else if(x==223 && y==56) begin	plot <= 1'b1;	end
		else if(x==226 && y==56) begin	plot <= 1'b1;	end
		else if(x==227 && y==56) begin	plot <= 1'b1;	end
		else if(x==228 && y==56) begin	plot <= 1'b1;	end
		else if(x==229 && y==56) begin	plot <= 1'b1;	end
		else if(x==230 && y==56) begin	plot <= 1'b1;	end
		else if(x==231 && y==56) begin	plot <= 1'b1;	end
		else if(x==232 && y==56) begin	plot <= 1'b1;	end
		else if(x==233 && y==56) begin	plot <= 1'b1;	end
		else if(x==234 && y==56) begin	plot <= 1'b1;	end
		else if(x==235 && y==56) begin	plot <= 1'b1;	end
		else if(x==240 && y==56) begin	plot <= 1'b1;	end
		else if(x==241 && y==56) begin	plot <= 1'b1;	end
		else if(x==242 && y==56) begin	plot <= 1'b1;	end
		else if(x==243 && y==56) begin	plot <= 1'b1;	end
		else if(x==246 && y==56) begin	plot <= 1'b1;	end
		else if(x==247 && y==56) begin	plot <= 1'b1;	end
		else if(x==248 && y==56) begin	plot <= 1'b1;	end
		else if(x==249 && y==56) begin	plot <= 1'b1;	end
		else if(x==79 && y==57) begin	plot <= 1'b1;	end
		else if(x==80 && y==57) begin	plot <= 1'b1;	end
		else if(x==81 && y==57) begin	plot <= 1'b1;	end
		else if(x==88 && y==57) begin	plot <= 1'b1;	end
		else if(x==89 && y==57) begin	plot <= 1'b1;	end
		else if(x==90 && y==57) begin	plot <= 1'b1;	end
		else if(x==91 && y==57) begin	plot <= 1'b1;	end
		else if(x==92 && y==57) begin	plot <= 1'b1;	end
		else if(x==95 && y==57) begin	plot <= 1'b1;	end
		else if(x==96 && y==57) begin	plot <= 1'b1;	end
		else if(x==97 && y==57) begin	plot <= 1'b1;	end
		else if(x==98 && y==57) begin	plot <= 1'b1;	end
		else if(x==101 && y==57) begin	plot <= 1'b1;	end
		else if(x==102 && y==57) begin	plot <= 1'b1;	end
		else if(x==103 && y==57) begin	plot <= 1'b1;	end
		else if(x==104 && y==57) begin	plot <= 1'b1;	end
		else if(x==105 && y==57) begin	plot <= 1'b1;	end
		else if(x==106 && y==57) begin	plot <= 1'b1;	end
		else if(x==107 && y==57) begin	plot <= 1'b1;	end
		else if(x==108 && y==57) begin	plot <= 1'b1;	end
		else if(x==109 && y==57) begin	plot <= 1'b1;	end
		else if(x==110 && y==57) begin	plot <= 1'b1;	end
		else if(x==111 && y==57) begin	plot <= 1'b1;	end
		else if(x==115 && y==57) begin	plot <= 1'b1;	end
		else if(x==116 && y==57) begin	plot <= 1'b1;	end
		else if(x==117 && y==57) begin	plot <= 1'b1;	end
		else if(x==118 && y==57) begin	plot <= 1'b1;	end
		else if(x==119 && y==57) begin	plot <= 1'b1;	end
		else if(x==120 && y==57) begin	plot <= 1'b1;	end
		else if(x==121 && y==57) begin	plot <= 1'b1;	end
		else if(x==122 && y==57) begin	plot <= 1'b1;	end
		else if(x==123 && y==57) begin	plot <= 1'b1;	end
		else if(x==124 && y==57) begin	plot <= 1'b1;	end
		else if(x==127 && y==57) begin	plot <= 1'b1;	end
		else if(x==128 && y==57) begin	plot <= 1'b1;	end
		else if(x==129 && y==57) begin	plot <= 1'b1;	end
		else if(x==130 && y==57) begin	plot <= 1'b1;	end
		else if(x==131 && y==57) begin	plot <= 1'b1;	end
		else if(x==132 && y==57) begin	plot <= 1'b1;	end
		else if(x==133 && y==57) begin	plot <= 1'b1;	end
		else if(x==134 && y==57) begin	plot <= 1'b1;	end
		else if(x==135 && y==57) begin	plot <= 1'b1;	end
		else if(x==136 && y==57) begin	plot <= 1'b1;	end
		else if(x==137 && y==57) begin	plot <= 1'b1;	end
		else if(x==149 && y==57) begin	plot <= 1'b1;	end
		else if(x==150 && y==57) begin	plot <= 1'b1;	end
		else if(x==151 && y==57) begin	plot <= 1'b1;	end
		else if(x==152 && y==57) begin	plot <= 1'b1;	end
		else if(x==153 && y==57) begin	plot <= 1'b1;	end
		else if(x==154 && y==57) begin	plot <= 1'b1;	end
		else if(x==155 && y==57) begin	plot <= 1'b1;	end
		else if(x==156 && y==57) begin	plot <= 1'b1;	end
		else if(x==157 && y==57) begin	plot <= 1'b1;	end
		else if(x==160 && y==57) begin	plot <= 1'b1;	end
		else if(x==161 && y==57) begin	plot <= 1'b1;	end
		else if(x==162 && y==57) begin	plot <= 1'b1;	end
		else if(x==163 && y==57) begin	plot <= 1'b1;	end
		else if(x==164 && y==57) begin	plot <= 1'b1;	end
		else if(x==180 && y==57) begin	plot <= 1'b1;	end
		else if(x==181 && y==57) begin	plot <= 1'b1;	end
		else if(x==182 && y==57) begin	plot <= 1'b1;	end
		else if(x==183 && y==57) begin	plot <= 1'b1;	end
		else if(x==184 && y==57) begin	plot <= 1'b1;	end
		else if(x==187 && y==57) begin	plot <= 1'b1;	end
		else if(x==188 && y==57) begin	plot <= 1'b1;	end
		else if(x==189 && y==57) begin	plot <= 1'b1;	end
		else if(x==190 && y==57) begin	plot <= 1'b1;	end
		else if(x==194 && y==57) begin	plot <= 1'b1;	end
		else if(x==195 && y==57) begin	plot <= 1'b1;	end
		else if(x==196 && y==57) begin	plot <= 1'b1;	end
		else if(x==197 && y==57) begin	plot <= 1'b1;	end
		else if(x==200 && y==57) begin	plot <= 1'b1;	end
		else if(x==201 && y==57) begin	plot <= 1'b1;	end
		else if(x==202 && y==57) begin	plot <= 1'b1;	end
		else if(x==203 && y==57) begin	plot <= 1'b1;	end
		else if(x==206 && y==57) begin	plot <= 1'b1;	end
		else if(x==207 && y==57) begin	plot <= 1'b1;	end
		else if(x==208 && y==57) begin	plot <= 1'b1;	end
		else if(x==209 && y==57) begin	plot <= 1'b1;	end
		else if(x==210 && y==57) begin	plot <= 1'b1;	end
		else if(x==211 && y==57) begin	plot <= 1'b1;	end
		else if(x==214 && y==57) begin	plot <= 1'b1;	end
		else if(x==215 && y==57) begin	plot <= 1'b1;	end
		else if(x==216 && y==57) begin	plot <= 1'b1;	end
		else if(x==217 && y==57) begin	plot <= 1'b1;	end
		else if(x==218 && y==57) begin	plot <= 1'b1;	end
		else if(x==219 && y==57) begin	plot <= 1'b1;	end
		else if(x==220 && y==57) begin	plot <= 1'b1;	end
		else if(x==221 && y==57) begin	plot <= 1'b1;	end
		else if(x==222 && y==57) begin	plot <= 1'b1;	end
		else if(x==223 && y==57) begin	plot <= 1'b1;	end
		else if(x==227 && y==57) begin	plot <= 1'b1;	end
		else if(x==228 && y==57) begin	plot <= 1'b1;	end
		else if(x==229 && y==57) begin	plot <= 1'b1;	end
		else if(x==230 && y==57) begin	plot <= 1'b1;	end
		else if(x==231 && y==57) begin	plot <= 1'b1;	end
		else if(x==232 && y==57) begin	plot <= 1'b1;	end
		else if(x==233 && y==57) begin	plot <= 1'b1;	end
		else if(x==234 && y==57) begin	plot <= 1'b1;	end
		else if(x==235 && y==57) begin	plot <= 1'b1;	end
		else if(x==236 && y==57) begin	plot <= 1'b1;	end
		else if(x==240 && y==57) begin	plot <= 1'b1;	end
		else if(x==241 && y==57) begin	plot <= 1'b1;	end
		else if(x==242 && y==57) begin	plot <= 1'b1;	end
		else if(x==243 && y==57) begin	plot <= 1'b1;	end
		else if(x==246 && y==57) begin	plot <= 1'b1;	end
		else if(x==247 && y==57) begin	plot <= 1'b1;	end
		else if(x==248 && y==57) begin	plot <= 1'b1;	end
		else if(x==249 && y==57) begin	plot <= 1'b1;	end
		else if(x==156 && y==108) begin	plot <= 1'b1;	end
		else if(x==155 && y==109) begin	plot <= 1'b1;	end
		else if(x==156 && y==109) begin	plot <= 1'b1;	end
		else if(x==154 && y==110) begin	plot <= 1'b1;	end
		else if(x==155 && y==110) begin	plot <= 1'b1;	end
		else if(x==153 && y==111) begin	plot <= 1'b1;	end
		else if(x==154 && y==111) begin	plot <= 1'b1;	end
		else if(x==155 && y==111) begin	plot <= 1'b1;	end
		else if(x==153 && y==112) begin	plot <= 1'b1;	end
		else if(x==154 && y==112) begin	plot <= 1'b1;	end
		else if(x==152 && y==113) begin	plot <= 1'b1;	end
		else if(x==153 && y==113) begin	plot <= 1'b1;	end
		else if(x==154 && y==113) begin	plot <= 1'b1;	end
		else if(x==155 && y==113) begin	plot <= 1'b1;	end
		else if(x==156 && y==113) begin	plot <= 1'b1;	end
		else if(x==157 && y==113) begin	plot <= 1'b1;	end
		else if(x==151 && y==114) begin	plot <= 1'b1;	end
		else if(x==152 && y==114) begin	plot <= 1'b1;	end
		else if(x==153 && y==114) begin	plot <= 1'b1;	end
		else if(x==154 && y==114) begin	plot <= 1'b1;	end
		else if(x==155 && y==114) begin	plot <= 1'b1;	end
		else if(x==156 && y==114) begin	plot <= 1'b1;	end
		else if(x==157 && y==114) begin	plot <= 1'b1;	end
		else if(x==151 && y==115) begin	plot <= 1'b1;	end
		else if(x==152 && y==115) begin	plot <= 1'b1;	end
		else if(x==153 && y==115) begin	plot <= 1'b1;	end
		else if(x==154 && y==115) begin	plot <= 1'b1;	end
		else if(x==155 && y==115) begin	plot <= 1'b1;	end
		else if(x==156 && y==115) begin	plot <= 1'b1;	end
		else if(x==154 && y==116) begin	plot <= 1'b1;	end
		else if(x==155 && y==116) begin	plot <= 1'b1;	end
		else if(x==153 && y==117) begin	plot <= 1'b1;	end
		else if(x==154 && y==117) begin	plot <= 1'b1;	end
		else if(x==152 && y==118) begin	plot <= 1'b1;	end
		else if(x==153 && y==118) begin	plot <= 1'b1;	end
		else if(x==152 && y==119) begin	plot <= 1'b1;	end
		else if(x==151 && y==120) begin	plot <= 1'b1;	end
		else if(x==104 && y==168) begin	plot <= 1'b1;	end
		else if(x==105 && y==168) begin	plot <= 1'b1;	end
		else if(x==106 && y==168) begin	plot <= 1'b1;	end
		else if(x==107 && y==168) begin	plot <= 1'b1;	end
		else if(x==108 && y==168) begin	plot <= 1'b1;	end
		else if(x==112 && y==168) begin	plot <= 1'b1;	end
		else if(x==118 && y==168) begin	plot <= 1'b1;	end
		else if(x==124 && y==168) begin	plot <= 1'b1;	end
		else if(x==130 && y==168) begin	plot <= 1'b1;	end
		else if(x==131 && y==168) begin	plot <= 1'b1;	end
		else if(x==132 && y==168) begin	plot <= 1'b1;	end
		else if(x==133 && y==168) begin	plot <= 1'b1;	end
		else if(x==134 && y==168) begin	plot <= 1'b1;	end
		else if(x==135 && y==168) begin	plot <= 1'b1;	end
		else if(x==136 && y==168) begin	plot <= 1'b1;	end
		else if(x==149 && y==168) begin	plot <= 1'b1;	end
		else if(x==150 && y==168) begin	plot <= 1'b1;	end
		else if(x==175 && y==168) begin	plot <= 1'b1;	end
		else if(x==176 && y==168) begin	plot <= 1'b1;	end
		else if(x==177 && y==168) begin	plot <= 1'b1;	end
		else if(x==178 && y==168) begin	plot <= 1'b1;	end
		else if(x==184 && y==168) begin	plot <= 1'b1;	end
		else if(x==209 && y==168) begin	plot <= 1'b1;	end
		else if(x==210 && y==168) begin	plot <= 1'b1;	end
		else if(x==103 && y==169) begin	plot <= 1'b1;	end
		else if(x==104 && y==169) begin	plot <= 1'b1;	end
		else if(x==105 && y==169) begin	plot <= 1'b1;	end
		else if(x==106 && y==169) begin	plot <= 1'b1;	end
		else if(x==107 && y==169) begin	plot <= 1'b1;	end
		else if(x==108 && y==169) begin	plot <= 1'b1;	end
		else if(x==109 && y==169) begin	plot <= 1'b1;	end
		else if(x==112 && y==169) begin	plot <= 1'b1;	end
		else if(x==118 && y==169) begin	plot <= 1'b1;	end
		else if(x==123 && y==169) begin	plot <= 1'b1;	end
		else if(x==124 && y==169) begin	plot <= 1'b1;	end
		else if(x==130 && y==169) begin	plot <= 1'b1;	end
		else if(x==131 && y==169) begin	plot <= 1'b1;	end
		else if(x==132 && y==169) begin	plot <= 1'b1;	end
		else if(x==133 && y==169) begin	plot <= 1'b1;	end
		else if(x==135 && y==169) begin	plot <= 1'b1;	end
		else if(x==136 && y==169) begin	plot <= 1'b1;	end
		else if(x==149 && y==169) begin	plot <= 1'b1;	end
		else if(x==150 && y==169) begin	plot <= 1'b1;	end
		else if(x==174 && y==169) begin	plot <= 1'b1;	end
		else if(x==175 && y==169) begin	plot <= 1'b1;	end
		else if(x==176 && y==169) begin	plot <= 1'b1;	end
		else if(x==177 && y==169) begin	plot <= 1'b1;	end
		else if(x==178 && y==169) begin	plot <= 1'b1;	end
		else if(x==179 && y==169) begin	plot <= 1'b1;	end
		else if(x==184 && y==169) begin	plot <= 1'b1;	end
		else if(x==209 && y==169) begin	plot <= 1'b1;	end
		else if(x==210 && y==169) begin	plot <= 1'b1;	end
		else if(x==103 && y==170) begin	plot <= 1'b1;	end
		else if(x==109 && y==170) begin	plot <= 1'b1;	end
		else if(x==112 && y==170) begin	plot <= 1'b1;	end
		else if(x==118 && y==170) begin	plot <= 1'b1;	end
		else if(x==122 && y==170) begin	plot <= 1'b1;	end
		else if(x==123 && y==170) begin	plot <= 1'b1;	end
		else if(x==124 && y==170) begin	plot <= 1'b1;	end
		else if(x==136 && y==170) begin	plot <= 1'b1;	end
		else if(x==149 && y==170) begin	plot <= 1'b1;	end
		else if(x==150 && y==170) begin	plot <= 1'b1;	end
		else if(x==173 && y==170) begin	plot <= 1'b1;	end
		else if(x==174 && y==170) begin	plot <= 1'b1;	end
		else if(x==179 && y==170) begin	plot <= 1'b1;	end
		else if(x==180 && y==170) begin	plot <= 1'b1;	end
		else if(x==184 && y==170) begin	plot <= 1'b1;	end
		else if(x==209 && y==170) begin	plot <= 1'b1;	end
		else if(x==210 && y==170) begin	plot <= 1'b1;	end
		else if(x==103 && y==171) begin	plot <= 1'b1;	end
		else if(x==112 && y==171) begin	plot <= 1'b1;	end
		else if(x==118 && y==171) begin	plot <= 1'b1;	end
		else if(x==121 && y==171) begin	plot <= 1'b1;	end
		else if(x==124 && y==171) begin	plot <= 1'b1;	end
		else if(x==134 && y==171) begin	plot <= 1'b1;	end
		else if(x==135 && y==171) begin	plot <= 1'b1;	end
		else if(x==148 && y==171) begin	plot <= 1'b1;	end
		else if(x==149 && y==171) begin	plot <= 1'b1;	end
		else if(x==150 && y==171) begin	plot <= 1'b1;	end
		else if(x==151 && y==171) begin	plot <= 1'b1;	end
		else if(x==152 && y==171) begin	plot <= 1'b1;	end
		else if(x==153 && y==171) begin	plot <= 1'b1;	end
		else if(x==157 && y==171) begin	plot <= 1'b1;	end
		else if(x==158 && y==171) begin	plot <= 1'b1;	end
		else if(x==159 && y==171) begin	plot <= 1'b1;	end
		else if(x==160 && y==171) begin	plot <= 1'b1;	end
		else if(x==173 && y==171) begin	plot <= 1'b1;	end
		else if(x==174 && y==171) begin	plot <= 1'b1;	end
		else if(x==182 && y==171) begin	plot <= 1'b1;	end
		else if(x==183 && y==171) begin	plot <= 1'b1;	end
		else if(x==184 && y==171) begin	plot <= 1'b1;	end
		else if(x==185 && y==171) begin	plot <= 1'b1;	end
		else if(x==186 && y==171) begin	plot <= 1'b1;	end
		else if(x==187 && y==171) begin	plot <= 1'b1;	end
		else if(x==191 && y==171) begin	plot <= 1'b1;	end
		else if(x==192 && y==171) begin	plot <= 1'b1;	end
		else if(x==193 && y==171) begin	plot <= 1'b1;	end
		else if(x==194 && y==171) begin	plot <= 1'b1;	end
		else if(x==195 && y==171) begin	plot <= 1'b1;	end
		else if(x==199 && y==171) begin	plot <= 1'b1;	end
		else if(x==202 && y==171) begin	plot <= 1'b1;	end
		else if(x==203 && y==171) begin	plot <= 1'b1;	end
		else if(x==204 && y==171) begin	plot <= 1'b1;	end
		else if(x==208 && y==171) begin	plot <= 1'b1;	end
		else if(x==209 && y==171) begin	plot <= 1'b1;	end
		else if(x==210 && y==171) begin	plot <= 1'b1;	end
		else if(x==211 && y==171) begin	plot <= 1'b1;	end
		else if(x==212 && y==171) begin	plot <= 1'b1;	end
		else if(x==213 && y==171) begin	plot <= 1'b1;	end
		else if(x==103 && y==172) begin	plot <= 1'b1;	end
		else if(x==104 && y==172) begin	plot <= 1'b1;	end
		else if(x==105 && y==172) begin	plot <= 1'b1;	end
		else if(x==106 && y==172) begin	plot <= 1'b1;	end
		else if(x==107 && y==172) begin	plot <= 1'b1;	end
		else if(x==112 && y==172) begin	plot <= 1'b1;	end
		else if(x==115 && y==172) begin	plot <= 1'b1;	end
		else if(x==118 && y==172) begin	plot <= 1'b1;	end
		else if(x==121 && y==172) begin	plot <= 1'b1;	end
		else if(x==124 && y==172) begin	plot <= 1'b1;	end
		else if(x==134 && y==172) begin	plot <= 1'b1;	end
		else if(x==135 && y==172) begin	plot <= 1'b1;	end
		else if(x==148 && y==172) begin	plot <= 1'b1;	end
		else if(x==149 && y==172) begin	plot <= 1'b1;	end
		else if(x==150 && y==172) begin	plot <= 1'b1;	end
		else if(x==151 && y==172) begin	plot <= 1'b1;	end
		else if(x==152 && y==172) begin	plot <= 1'b1;	end
		else if(x==156 && y==172) begin	plot <= 1'b1;	end
		else if(x==157 && y==172) begin	plot <= 1'b1;	end
		else if(x==158 && y==172) begin	plot <= 1'b1;	end
		else if(x==159 && y==172) begin	plot <= 1'b1;	end
		else if(x==160 && y==172) begin	plot <= 1'b1;	end
		else if(x==161 && y==172) begin	plot <= 1'b1;	end
		else if(x==174 && y==172) begin	plot <= 1'b1;	end
		else if(x==175 && y==172) begin	plot <= 1'b1;	end
		else if(x==176 && y==172) begin	plot <= 1'b1;	end
		else if(x==177 && y==172) begin	plot <= 1'b1;	end
		else if(x==178 && y==172) begin	plot <= 1'b1;	end
		else if(x==183 && y==172) begin	plot <= 1'b1;	end
		else if(x==184 && y==172) begin	plot <= 1'b1;	end
		else if(x==185 && y==172) begin	plot <= 1'b1;	end
		else if(x==186 && y==172) begin	plot <= 1'b1;	end
		else if(x==187 && y==172) begin	plot <= 1'b1;	end
		else if(x==192 && y==172) begin	plot <= 1'b1;	end
		else if(x==193 && y==172) begin	plot <= 1'b1;	end
		else if(x==194 && y==172) begin	plot <= 1'b1;	end
		else if(x==195 && y==172) begin	plot <= 1'b1;	end
		else if(x==196 && y==172) begin	plot <= 1'b1;	end
		else if(x==199 && y==172) begin	plot <= 1'b1;	end
		else if(x==200 && y==172) begin	plot <= 1'b1;	end
		else if(x==201 && y==172) begin	plot <= 1'b1;	end
		else if(x==202 && y==172) begin	plot <= 1'b1;	end
		else if(x==203 && y==172) begin	plot <= 1'b1;	end
		else if(x==204 && y==172) begin	plot <= 1'b1;	end
		else if(x==205 && y==172) begin	plot <= 1'b1;	end
		else if(x==208 && y==172) begin	plot <= 1'b1;	end
		else if(x==209 && y==172) begin	plot <= 1'b1;	end
		else if(x==210 && y==172) begin	plot <= 1'b1;	end
		else if(x==211 && y==172) begin	plot <= 1'b1;	end
		else if(x==212 && y==172) begin	plot <= 1'b1;	end
		else if(x==104 && y==173) begin	plot <= 1'b1;	end
		else if(x==105 && y==173) begin	plot <= 1'b1;	end
		else if(x==106 && y==173) begin	plot <= 1'b1;	end
		else if(x==107 && y==173) begin	plot <= 1'b1;	end
		else if(x==108 && y==173) begin	plot <= 1'b1;	end
		else if(x==112 && y==173) begin	plot <= 1'b1;	end
		else if(x==115 && y==173) begin	plot <= 1'b1;	end
		else if(x==118 && y==173) begin	plot <= 1'b1;	end
		else if(x==124 && y==173) begin	plot <= 1'b1;	end
		else if(x==134 && y==173) begin	plot <= 1'b1;	end
		else if(x==135 && y==173) begin	plot <= 1'b1;	end
		else if(x==149 && y==173) begin	plot <= 1'b1;	end
		else if(x==150 && y==173) begin	plot <= 1'b1;	end
		else if(x==155 && y==173) begin	plot <= 1'b1;	end
		else if(x==156 && y==173) begin	plot <= 1'b1;	end
		else if(x==161 && y==173) begin	plot <= 1'b1;	end
		else if(x==162 && y==173) begin	plot <= 1'b1;	end
		else if(x==175 && y==173) begin	plot <= 1'b1;	end
		else if(x==176 && y==173) begin	plot <= 1'b1;	end
		else if(x==177 && y==173) begin	plot <= 1'b1;	end
		else if(x==178 && y==173) begin	plot <= 1'b1;	end
		else if(x==184 && y==173) begin	plot <= 1'b1;	end
		else if(x==196 && y==173) begin	plot <= 1'b1;	end
		else if(x==199 && y==173) begin	plot <= 1'b1;	end
		else if(x==200 && y==173) begin	plot <= 1'b1;	end
		else if(x==201 && y==173) begin	plot <= 1'b1;	end
		else if(x==205 && y==173) begin	plot <= 1'b1;	end
		else if(x==209 && y==173) begin	plot <= 1'b1;	end
		else if(x==210 && y==173) begin	plot <= 1'b1;	end
		else if(x==109 && y==174) begin	plot <= 1'b1;	end
		else if(x==112 && y==174) begin	plot <= 1'b1;	end
		else if(x==115 && y==174) begin	plot <= 1'b1;	end
		else if(x==118 && y==174) begin	plot <= 1'b1;	end
		else if(x==124 && y==174) begin	plot <= 1'b1;	end
		else if(x==133 && y==174) begin	plot <= 1'b1;	end
		else if(x==149 && y==174) begin	plot <= 1'b1;	end
		else if(x==150 && y==174) begin	plot <= 1'b1;	end
		else if(x==155 && y==174) begin	plot <= 1'b1;	end
		else if(x==156 && y==174) begin	plot <= 1'b1;	end
		else if(x==161 && y==174) begin	plot <= 1'b1;	end
		else if(x==162 && y==174) begin	plot <= 1'b1;	end
		else if(x==179 && y==174) begin	plot <= 1'b1;	end
		else if(x==180 && y==174) begin	plot <= 1'b1;	end
		else if(x==184 && y==174) begin	plot <= 1'b1;	end
		else if(x==191 && y==174) begin	plot <= 1'b1;	end
		else if(x==192 && y==174) begin	plot <= 1'b1;	end
		else if(x==193 && y==174) begin	plot <= 1'b1;	end
		else if(x==194 && y==174) begin	plot <= 1'b1;	end
		else if(x==195 && y==174) begin	plot <= 1'b1;	end
		else if(x==196 && y==174) begin	plot <= 1'b1;	end
		else if(x==199 && y==174) begin	plot <= 1'b1;	end
		else if(x==209 && y==174) begin	plot <= 1'b1;	end
		else if(x==210 && y==174) begin	plot <= 1'b1;	end
		else if(x==103 && y==175) begin	plot <= 1'b1;	end
		else if(x==109 && y==175) begin	plot <= 1'b1;	end
		else if(x==112 && y==175) begin	plot <= 1'b1;	end
		else if(x==113 && y==175) begin	plot <= 1'b1;	end
		else if(x==114 && y==175) begin	plot <= 1'b1;	end
		else if(x==115 && y==175) begin	plot <= 1'b1;	end
		else if(x==116 && y==175) begin	plot <= 1'b1;	end
		else if(x==117 && y==175) begin	plot <= 1'b1;	end
		else if(x==118 && y==175) begin	plot <= 1'b1;	end
		else if(x==124 && y==175) begin	plot <= 1'b1;	end
		else if(x==133 && y==175) begin	plot <= 1'b1;	end
		else if(x==149 && y==175) begin	plot <= 1'b1;	end
		else if(x==150 && y==175) begin	plot <= 1'b1;	end
		else if(x==155 && y==175) begin	plot <= 1'b1;	end
		else if(x==156 && y==175) begin	plot <= 1'b1;	end
		else if(x==161 && y==175) begin	plot <= 1'b1;	end
		else if(x==162 && y==175) begin	plot <= 1'b1;	end
		else if(x==179 && y==175) begin	plot <= 1'b1;	end
		else if(x==180 && y==175) begin	plot <= 1'b1;	end
		else if(x==184 && y==175) begin	plot <= 1'b1;	end
		else if(x==190 && y==175) begin	plot <= 1'b1;	end
		else if(x==191 && y==175) begin	plot <= 1'b1;	end
		else if(x==192 && y==175) begin	plot <= 1'b1;	end
		else if(x==193 && y==175) begin	plot <= 1'b1;	end
		else if(x==195 && y==175) begin	plot <= 1'b1;	end
		else if(x==196 && y==175) begin	plot <= 1'b1;	end
		else if(x==199 && y==175) begin	plot <= 1'b1;	end
		else if(x==209 && y==175) begin	plot <= 1'b1;	end
		else if(x==210 && y==175) begin	plot <= 1'b1;	end
		else if(x==103 && y==176) begin	plot <= 1'b1;	end
		else if(x==109 && y==176) begin	plot <= 1'b1;	end
		else if(x==112 && y==176) begin	plot <= 1'b1;	end
		else if(x==113 && y==176) begin	plot <= 1'b1;	end
		else if(x==114 && y==176) begin	plot <= 1'b1;	end
		else if(x==116 && y==176) begin	plot <= 1'b1;	end
		else if(x==117 && y==176) begin	plot <= 1'b1;	end
		else if(x==118 && y==176) begin	plot <= 1'b1;	end
		else if(x==124 && y==176) begin	plot <= 1'b1;	end
		else if(x==133 && y==176) begin	plot <= 1'b1;	end
		else if(x==149 && y==176) begin	plot <= 1'b1;	end
		else if(x==150 && y==176) begin	plot <= 1'b1;	end
		else if(x==155 && y==176) begin	plot <= 1'b1;	end
		else if(x==156 && y==176) begin	plot <= 1'b1;	end
		else if(x==161 && y==176) begin	plot <= 1'b1;	end
		else if(x==162 && y==176) begin	plot <= 1'b1;	end
		else if(x==173 && y==176) begin	plot <= 1'b1;	end
		else if(x==174 && y==176) begin	plot <= 1'b1;	end
		else if(x==179 && y==176) begin	plot <= 1'b1;	end
		else if(x==180 && y==176) begin	plot <= 1'b1;	end
		else if(x==184 && y==176) begin	plot <= 1'b1;	end
		else if(x==190 && y==176) begin	plot <= 1'b1;	end
		else if(x==196 && y==176) begin	plot <= 1'b1;	end
		else if(x==199 && y==176) begin	plot <= 1'b1;	end
		else if(x==209 && y==176) begin	plot <= 1'b1;	end
		else if(x==210 && y==176) begin	plot <= 1'b1;	end
		else if(x==104 && y==177) begin	plot <= 1'b1;	end
		else if(x==105 && y==177) begin	plot <= 1'b1;	end
		else if(x==106 && y==177) begin	plot <= 1'b1;	end
		else if(x==107 && y==177) begin	plot <= 1'b1;	end
		else if(x==108 && y==177) begin	plot <= 1'b1;	end
		else if(x==112 && y==177) begin	plot <= 1'b1;	end
		else if(x==118 && y==177) begin	plot <= 1'b1;	end
		else if(x==124 && y==177) begin	plot <= 1'b1;	end
		else if(x==131 && y==177) begin	plot <= 1'b1;	end
		else if(x==132 && y==177) begin	plot <= 1'b1;	end
		else if(x==151 && y==177) begin	plot <= 1'b1;	end
		else if(x==152 && y==177) begin	plot <= 1'b1;	end
		else if(x==153 && y==177) begin	plot <= 1'b1;	end
		else if(x==157 && y==177) begin	plot <= 1'b1;	end
		else if(x==158 && y==177) begin	plot <= 1'b1;	end
		else if(x==159 && y==177) begin	plot <= 1'b1;	end
		else if(x==160 && y==177) begin	plot <= 1'b1;	end
		else if(x==175 && y==177) begin	plot <= 1'b1;	end
		else if(x==176 && y==177) begin	plot <= 1'b1;	end
		else if(x==177 && y==177) begin	plot <= 1'b1;	end
		else if(x==178 && y==177) begin	plot <= 1'b1;	end
		else if(x==185 && y==177) begin	plot <= 1'b1;	end
		else if(x==186 && y==177) begin	plot <= 1'b1;	end
		else if(x==187 && y==177) begin	plot <= 1'b1;	end
		else if(x==191 && y==177) begin	plot <= 1'b1;	end
		else if(x==192 && y==177) begin	plot <= 1'b1;	end
		else if(x==193 && y==177) begin	plot <= 1'b1;	end
		else if(x==194 && y==177) begin	plot <= 1'b1;	end
		else if(x==195 && y==177) begin	plot <= 1'b1;	end
		else if(x==196 && y==177) begin	plot <= 1'b1;	end
		else if(x==199 && y==177) begin	plot <= 1'b1;	end
		else if(x==211 && y==177) begin	plot <= 1'b1;	end
		else if(x==212 && y==177) begin	plot <= 1'b1;	end
		else if(x==213 && y==177) begin	plot <= 1'b1;	end
		else if(x==105 && y==178) begin	plot <= 1'b1;	end
		else if(x==106 && y==178) begin	plot <= 1'b1;	end
		else if(x==107 && y==178) begin	plot <= 1'b1;	end
		else if(x==112 && y==178) begin	plot <= 1'b1;	end
		else if(x==118 && y==178) begin	plot <= 1'b1;	end
		else if(x==124 && y==178) begin	plot <= 1'b1;	end
		else if(x==151 && y==178) begin	plot <= 1'b1;	end
		else if(x==152 && y==178) begin	plot <= 1'b1;	end
		else if(x==157 && y==178) begin	plot <= 1'b1;	end
		else if(x==158 && y==178) begin	plot <= 1'b1;	end
		else if(x==159 && y==178) begin	plot <= 1'b1;	end
		else if(x==160 && y==178) begin	plot <= 1'b1;	end
		else if(x==175 && y==178) begin	plot <= 1'b1;	end
		else if(x==176 && y==178) begin	plot <= 1'b1;	end
		else if(x==177 && y==178) begin	plot <= 1'b1;	end
		else if(x==178 && y==178) begin	plot <= 1'b1;	end
		else if(x==186 && y==178) begin	plot <= 1'b1;	end
		else if(x==187 && y==178) begin	plot <= 1'b1;	end
		else if(x==192 && y==178) begin	plot <= 1'b1;	end
		else if(x==193 && y==178) begin	plot <= 1'b1;	end
		else if(x==194 && y==178) begin	plot <= 1'b1;	end
		else if(x==195 && y==178) begin	plot <= 1'b1;	end
		else if(x==196 && y==178) begin	plot <= 1'b1;	end
		else if(x==199 && y==178) begin	plot <= 1'b1;	end
		else if(x==211 && y==178) begin	plot <= 1'b1;	end
		else if(x==212 && y==178) begin	plot <= 1'b1;	end
		else begin plot <= 1'b0; end// Width: 320, Height: 240
	end
endmodule



// The 60 second hex display for showing the time in decimals
module hex_display(IN, OUT1, OUT2);
   input [5:0] IN;
    output reg [7:0] OUT1, OUT2;
     
     always @(*)
     begin
        case(IN[5:0])
            6'b000000:
                begin
                    OUT1 = 7'b1000000; // 0
                    OUT2 = 7'b1000000; // 0
                end
            6'b000001:
                begin
                    OUT1 = 7'b1000000; // 0
                    OUT2 = 7'b1111001; // 1
                end
            6'b000010:
                begin
                    OUT1 = 7'b1000000; // 0
                    OUT2 = 7'b0100100; // 2
                end
            6'b000011:
                begin
                    OUT1 = 7'b1000000; // 0
                    OUT2 = 7'b0110000; // 3
                end
            6'b000100:
                begin
                    OUT1 = 7'b1000000; // 0
                    OUT2 = 7'b0011001; // 4
                end
            6'b000101:
                begin
                    OUT1 = 7'b1000000; // 0
                    OUT2 = 7'b0010010; // 5
                end
            6'b000110:
                begin
                    OUT1 = 7'b1000000; // 0
                    OUT2 = 7'b0000010; // 6
                end
            6'b000111:
                begin
                    OUT1 = 7'b1000000; // 0
                    OUT2 = 7'b1111000; // 7
                end
            6'b001000:
                begin
                    OUT1 = 7'b1000000; // 0
                    OUT2 = 7'b0000000; // 8
                end
            6'b001001:
                begin
                    OUT1 = 7'b1000000; // 0
                    OUT2 = 7'b0011000; // 9
                end
            6'b001010:
                begin
                    OUT1 = 7'b1111001; // 1
                    OUT2 = 7'b1000000; // 0
                end
            6'b001011:
                begin
                    OUT1 = 7'b1111001; // 1
                    OUT2 = 7'b1111001; // 1
                end
            6'b001100:
                begin
                    OUT1 = 7'b1111001; // 1
                    OUT2 = 7'b0100100; // 2
                end
            6'b001101:
                begin
                    OUT1 = 7'b1111001; // 1
                    OUT2 = 7'b0110000; // 3
                end
            6'b001110:
                begin
                    OUT1 = 7'b1111001; // 1
                    OUT2 = 7'b0011001; // 4
                end
            6'b001111:
               begin
                    OUT1 = 7'b1111001; // 1
                    OUT2 = 7'b0010010; // 5
                end
            6'b010000:
                begin
                    OUT1 = 7'b1111001; // 1
                    OUT2 = 7'b0000010; // 6
                end
            6'b010001:
                begin
                    OUT1 = 7'b1111001; // 1
                    OUT2 = 7'b1111000; // 7
                end
            6'b010010:
                begin
                    OUT1 = 7'b1111001; // 1
                    OUT2 = 7'b0000000; // 8
                end
            6'b010011:
                begin
                    OUT1 = 7'b1111001; // 1
                    OUT2 = 7'b0011000; // 9
                end
            6'b010100:
                begin
                    OUT1 = 7'b0100100; // 2
                    OUT2 = 7'b1000000; // 0
                end
            6'b010101:
                begin
                    OUT1 = 7'b0100100; // 2
                    OUT2 = 7'b1111001; // 1
                end
            6'b010110:
                begin
                    OUT1 = 7'b0100100; // 2
                    OUT2 = 7'b0100100; // 2
                end
            6'b010111:
                begin
                    OUT1 = 7'b0100100; // 2
                    OUT2 = 7'b0110000; // 3
                end
            6'b011000:
                begin
                    OUT1 = 7'b0100100; // 2
                    OUT2 = 7'b0011001; // 4
                end
            6'b011001:
                begin
                    OUT1 = 7'b0100100; // 2
                    OUT2 = 7'b0010010; // 5
                end
            6'b011010:
                begin
                    OUT1 = 7'b0100100; // 2
                    OUT2 = 7'b0000010; // 6
                end
            6'b011011:
                begin
                    OUT1 = 7'b0100100; // 2
                    OUT2 = 7'b1111000; // 7
                end
            6'b011100:
                begin
                    OUT1 = 7'b0100100; // 2
                    OUT2 = 7'b0000000; // 8
                end
            6'b011101:
                begin
                    OUT1 = 7'b0100100; // 2
                    OUT2 = 7'b0011000; // 9
                end
            6'b011110:
                begin
                    OUT1 = 7'b0110000; // 3
                    OUT2 = 7'b1000000; // 0
                end
            6'b011111:
                begin
                    OUT1 = 7'b0110000; // 3
                    OUT2 = 7'b1111001; // 1
                end
				 6'b100000:
                begin
                    OUT1 = 7'b0110000; // 3
                    OUT2 = 7'b0100100; // 2
                end

            6'b100001:
                begin
                    OUT1 = 7'b0110000; // 3
                    OUT2 = 7'b0110000; // 3
                end
            6'b100010:
                begin
                    OUT1 = 7'b0110000; // 3
                    OUT2 = 7'b0011001; // 4
                end
            6'b100011:
                begin
                    OUT1 = 7'b0110000; // 3
                    OUT2 = 7'b0010010; // 5
                end
            6'b100100:
                begin
                    OUT1 = 7'b0110000; // 3
                    OUT2 = 7'b0000010; // 6
                end
            6'b100101:
                begin
                    OUT1 = 7'b0110000; // 3
                    OUT2 = 7'b1111000; // 7
                end
            6'b100110:
                begin
                    OUT1 = 7'b0110000; // 3
                    OUT2 = 7'b0000000; // 8
                end
            6'b100111:
                begin
                    OUT1 = 7'b0110000; // 3
                    OUT2 = 7'b0011000; // 9
                end
            6'b101000:
                begin
                    OUT1 = 7'b0011001; // 4
                    OUT2 = 7'b1000000; // 0
                end
            6'b101001:
                begin
                    OUT1 = 7'b0011001; // 4
                    OUT2 = 7'b1111001; // 1
                end
            6'b101010:
                begin
                    OUT1 = 7'b0011001; // 4
                    OUT2 = 7'b0100100; // 2
                end			 
            6'b101011:
                begin
                    OUT1 = 7'b0011001; // 4
                    OUT2 = 7'b0110000; // 3
                end
            6'b101100:
                begin
                    OUT1 = 7'b0011001; // 4
                    OUT2 = 7'b0011001; // 4
                end
            6'b101101:
                begin
                    OUT1 = 7'b0011001; // 4
                    OUT2 = 7'b0010010; // 5
                end
            6'b101110:
                begin
                    OUT1 = 7'b0011001; // 4
                    OUT2 = 7'b0000010; // 6
                end
            6'b101111:
                begin
                    OUT1 = 7'b0011001; // 4
                    OUT2 = 7'b1111000; // 7
                end
            6'b110000:
                begin
                    OUT1 = 7'b0011001; // 4
                    OUT2 = 7'b0000000; // 8
                end
            6'b110001:
                begin
                    OUT1 = 7'b0011001; // 4
                    OUT2 = 7'b0011000; // 9
                end
            6'b110010:
                begin
                    OUT1 = 7'b0010010; // 5
                    OUT2 = 7'b1000000; // 0
					 end
           6'b110011:
                begin
                    OUT1 = 7'b0010010; // 5
                    OUT2 = 7'b1111001; // 1
                end
            6'b110100:
                begin
                    OUT1 = 7'b0010010; // 5
                    OUT2 = 7'b0100100; // 2
                end
					 
           6'b110101:
                begin
                    OUT1 = 7'b0010010; // 5
                    OUT2 = 7'b0110000; // 3
                end
            6'b110110:
                begin
                    OUT1 = 7'b0010010; // 5
                    OUT2 = 7'b0011001; // 4
                end
            6'b110111:
                begin
                    OUT1 = 7'b0010010; // 5
                    OUT2 = 7'b0010010; // 5
                end
            6'b111000:
                begin
                    OUT1 = 7'b0010010; // 5
                    OUT2 = 7'b0000010; // 6
                end
            6'b111001:
                begin
                    OUT1 = 7'b0010010; // 5
                    OUT2 = 7'b1111000; // 7
                end
            6'b111010:
                begin
                    OUT1 = 7'b0010010; // 5
                    OUT2 = 7'b0000000; // 8
                end
            6'b111011:
                begin
                    OUT1 = 7'b0010010; // 5
                    OUT2 = 7'b0011000; // 9
                end
            6'b111100:
                begin
                    OUT1 = 7'b0000010; // 6
                    OUT2 = 7'b1000000; // 0
					 end

            default:
                begin
                    OUT1 = 7'b1111111; // None
                    OUT2 = 7'b1111111; // None
                end
        endcase

    end
endmodule


// module for plotting the first explosion
module b111(
	input clk,
	input wire [9:0] characterPositionX,
	input wire [8:0] characterPositionY,
	input wire [9:0] drawingPositionX,
	input wire [8:0] drawingPositionY,
	output reg [2:0] plot
);
	reg [9:0] x;
	reg [9:0] y;
	initial begin
		x = 'd0;
		y = 'd0;
	end

	always @(posedge clk) begin
		x <= (drawingPositionX - characterPositionX + 45);
		y <= (drawingPositionY - characterPositionY + 40);
		if(x==43 && y==24) begin	plot <= 1'b1;	end
		else if(x==43 && y==25) begin	plot <= 1'b1;	end
		else if(x==43 && y==26) begin	plot <= 1'b1;	end
		else if(x==44 && y==26) begin	plot <= 1'b1;	end
		else if(x==43 && y==27) begin	plot <= 1'b1;	end
		else if(x==44 && y==27) begin	plot <= 1'b1;	end
		else if(x==30 && y==28) begin	plot <= 1'b1;	end
		else if(x==43 && y==28) begin	plot <= 1'b1;	end
		else if(x==44 && y==28) begin	plot <= 1'b1;	end
		else if(x==31 && y==29) begin	plot <= 1'b1;	end
		else if(x==32 && y==29) begin	plot <= 1'b1;	end
		else if(x==40 && y==29) begin	plot <= 1'b1;	end
		else if(x==41 && y==29) begin	plot <= 1'b1;	end
		else if(x==42 && y==29) begin	plot <= 1'b1;	end
		else if(x==43 && y==29) begin	plot <= 1'b1;	end
		else if(x==44 && y==29) begin	plot <= 1'b1;	end
		else if(x==32 && y==30) begin	plot <= 1'b1;	end
		else if(x==33 && y==30) begin	plot <= 1'b1;	end
		else if(x==39 && y==30) begin	plot <= 1'b1;	end
		else if(x==40 && y==30) begin	plot <= 1'b1;	end
		else if(x==41 && y==30) begin	plot <= 1'b1;	end
		else if(x==42 && y==30) begin	plot <= 1'b1;	end
		else if(x==43 && y==30) begin	plot <= 1'b1;	end
		else if(x==44 && y==30) begin	plot <= 1'b1;	end
		else if(x==45 && y==30) begin	plot <= 1'b1;	end
		else if(x==46 && y==30) begin	plot <= 1'b1;	end
		else if(x==47 && y==30) begin	plot <= 1'b1;	end
		else if(x==48 && y==30) begin	plot <= 1'b1;	end
		else if(x==32 && y==31) begin	plot <= 1'b1;	end
		else if(x==33 && y==31) begin	plot <= 1'b1;	end
		else if(x==34 && y==31) begin	plot <= 1'b1;	end
		else if(x==35 && y==31) begin	plot <= 1'b1;	end
		else if(x==38 && y==31) begin	plot <= 1'b1;	end
		else if(x==39 && y==31) begin	plot <= 1'b1;	end
		else if(x==40 && y==31) begin	plot <= 1'b1;	end
		else if(x==41 && y==31) begin	plot <= 1'b1;	end
		else if(x==42 && y==31) begin	plot <= 1'b1;	end
		else if(x==43 && y==31) begin	plot <= 1'b1;	end
		else if(x==44 && y==31) begin	plot <= 1'b1;	end
		else if(x==45 && y==31) begin	plot <= 1'b1;	end
		else if(x==46 && y==31) begin	plot <= 1'b1;	end
		else if(x==47 && y==31) begin	plot <= 1'b1;	end
		else if(x==48 && y==31) begin	plot <= 1'b1;	end
		else if(x==49 && y==31) begin	plot <= 1'b1;	end
		else if(x==33 && y==32) begin	plot <= 1'b1;	end
		else if(x==34 && y==32) begin	plot <= 1'b1;	end
		else if(x==35 && y==32) begin	plot <= 1'b1;	end
		else if(x==36 && y==32) begin	plot <= 1'b1;	end
		else if(x==37 && y==32) begin	plot <= 1'b1;	end
		else if(x==38 && y==32) begin	plot <= 1'b1;	end
		else if(x==39 && y==32) begin	plot <= 1'b1;	end
		else if(x==40 && y==32) begin	plot <= 1'b1;	end
		else if(x==41 && y==32) begin	plot <= 1'b1;	end
		else if(x==42 && y==32) begin	plot <= 1'b1;	end
		else if(x==43 && y==32) begin	plot <= 1'b1;	end
		else if(x==44 && y==32) begin	plot <= 1'b1;	end
		else if(x==45 && y==32) begin	plot <= 1'b1;	end
		else if(x==46 && y==32) begin	plot <= 1'b1;	end
		else if(x==47 && y==32) begin	plot <= 1'b1;	end
		else if(x==48 && y==32) begin	plot <= 1'b1;	end
		else if(x==49 && y==32) begin	plot <= 1'b1;	end
		else if(x==50 && y==32) begin	plot <= 1'b1;	end
		else if(x==34 && y==33) begin	plot <= 1'b1;	end
		else if(x==35 && y==33) begin	plot <= 1'b1;	end
		else if(x==36 && y==33) begin	plot <= 1'b1;	end
		else if(x==37 && y==33) begin	plot <= 1'b1;	end
		else if(x==38 && y==33) begin	plot <= 1'b1;	end
		else if(x==39 && y==33) begin	plot <= 1'b1;	end
		else if(x==40 && y==33) begin	plot <= 1'b1;	end
		else if(x==41 && y==33) begin	plot <= 1'b1;	end
		else if(x==42 && y==33) begin	plot <= 1'b1;	end
		else if(x==43 && y==33) begin	plot <= 1'b1;	end
		else if(x==44 && y==33) begin	plot <= 1'b1;	end
		else if(x==45 && y==33) begin	plot <= 1'b1;	end
		else if(x==46 && y==33) begin	plot <= 1'b1;	end
		else if(x==47 && y==33) begin	plot <= 1'b1;	end
		else if(x==48 && y==33) begin	plot <= 1'b1;	end
		else if(x==49 && y==33) begin	plot <= 1'b1;	end
		else if(x==50 && y==33) begin	plot <= 1'b1;	end
		else if(x==51 && y==33) begin	plot <= 1'b1;	end
		else if(x==57 && y==33) begin	plot <= 1'b1;	end
		else if(x==58 && y==33) begin	plot <= 1'b1;	end
		else if(x==59 && y==33) begin	plot <= 1'b1;	end
		else if(x==34 && y==34) begin	plot <= 1'b1;	end
		else if(x==35 && y==34) begin	plot <= 1'b1;	end
		else if(x==36 && y==34) begin	plot <= 1'b1;	end
		else if(x==37 && y==34) begin	plot <= 1'b1;	end
		else if(x==38 && y==34) begin	plot <= 1'b1;	end
		else if(x==39 && y==34) begin	plot <= 1'b1;	end
		else if(x==40 && y==34) begin	plot <= 1'b1;	end
		else if(x==41 && y==34) begin	plot <= 1'b1;	end
		else if(x==42 && y==34) begin	plot <= 1'b1;	end
		else if(x==43 && y==34) begin	plot <= 1'b1;	end
		else if(x==44 && y==34) begin	plot <= 1'b1;	end
		else if(x==45 && y==34) begin	plot <= 1'b1;	end
		else if(x==46 && y==34) begin	plot <= 1'b1;	end
		else if(x==47 && y==34) begin	plot <= 1'b1;	end
		else if(x==48 && y==34) begin	plot <= 1'b1;	end
		else if(x==49 && y==34) begin	plot <= 1'b1;	end
		else if(x==50 && y==34) begin	plot <= 1'b1;	end
		else if(x==51 && y==34) begin	plot <= 1'b1;	end
		else if(x==52 && y==34) begin	plot <= 1'b1;	end
		else if(x==56 && y==34) begin	plot <= 1'b1;	end
		else if(x==57 && y==34) begin	plot <= 1'b1;	end
		else if(x==58 && y==34) begin	plot <= 1'b1;	end
		else if(x==34 && y==35) begin	plot <= 1'b1;	end
		else if(x==35 && y==35) begin	plot <= 1'b1;	end
		else if(x==36 && y==35) begin	plot <= 1'b1;	end
		else if(x==37 && y==35) begin	plot <= 1'b1;	end
		else if(x==38 && y==35) begin	plot <= 1'b1;	end
		else if(x==39 && y==35) begin	plot <= 1'b1;	end
		else if(x==40 && y==35) begin	plot <= 1'b1;	end
		else if(x==41 && y==35) begin	plot <= 1'b1;	end
		else if(x==42 && y==35) begin	plot <= 1'b1;	end
		else if(x==43 && y==35) begin	plot <= 1'b1;	end
		else if(x==44 && y==35) begin	plot <= 1'b1;	end
		else if(x==45 && y==35) begin	plot <= 1'b1;	end
		else if(x==46 && y==35) begin	plot <= 1'b1;	end
		else if(x==47 && y==35) begin	plot <= 1'b1;	end
		else if(x==48 && y==35) begin	plot <= 1'b1;	end
		else if(x==49 && y==35) begin	plot <= 1'b1;	end
		else if(x==50 && y==35) begin	plot <= 1'b1;	end
		else if(x==51 && y==35) begin	plot <= 1'b1;	end
		else if(x==52 && y==35) begin	plot <= 1'b1;	end
		else if(x==53 && y==35) begin	plot <= 1'b1;	end
		else if(x==54 && y==35) begin	plot <= 1'b1;	end
		else if(x==55 && y==35) begin	plot <= 1'b1;	end
		else if(x==56 && y==35) begin	plot <= 1'b1;	end
		else if(x==57 && y==35) begin	plot <= 1'b1;	end
		else if(x==34 && y==36) begin	plot <= 1'b1;	end
		else if(x==35 && y==36) begin	plot <= 1'b1;	end
		else if(x==36 && y==36) begin	plot <= 1'b1;	end
		else if(x==37 && y==36) begin	plot <= 1'b1;	end
		else if(x==38 && y==36) begin	plot <= 1'b1;	end
		else if(x==39 && y==36) begin	plot <= 1'b1;	end
		else if(x==40 && y==36) begin	plot <= 1'b1;	end
		else if(x==41 && y==36) begin	plot <= 1'b1;	end
		else if(x==42 && y==36) begin	plot <= 1'b1;	end
		else if(x==43 && y==36) begin	plot <= 1'b1;	end
		else if(x==44 && y==36) begin	plot <= 1'b1;	end
		else if(x==45 && y==36) begin	plot <= 1'b1;	end
		else if(x==46 && y==36) begin	plot <= 1'b1;	end
		else if(x==47 && y==36) begin	plot <= 1'b1;	end
		else if(x==48 && y==36) begin	plot <= 1'b1;	end
		else if(x==49 && y==36) begin	plot <= 1'b1;	end
		else if(x==50 && y==36) begin	plot <= 1'b1;	end
		else if(x==51 && y==36) begin	plot <= 1'b1;	end
		else if(x==52 && y==36) begin	plot <= 1'b1;	end
		else if(x==53 && y==36) begin	plot <= 1'b1;	end
		else if(x==54 && y==36) begin	plot <= 1'b1;	end
		else if(x==55 && y==36) begin	plot <= 1'b1;	end
		else if(x==56 && y==36) begin	plot <= 1'b1;	end
		else if(x==34 && y==37) begin	plot <= 1'b1;	end
		else if(x==35 && y==37) begin	plot <= 1'b1;	end
		else if(x==36 && y==37) begin	plot <= 1'b1;	end
		else if(x==37 && y==37) begin	plot <= 1'b1;	end
		else if(x==38 && y==37) begin	plot <= 1'b1;	end
		else if(x==39 && y==37) begin	plot <= 1'b1;	end
		else if(x==40 && y==37) begin	plot <= 1'b1;	end
		else if(x==41 && y==37) begin	plot <= 1'b1;	end
		else if(x==42 && y==37) begin	plot <= 1'b1;	end
		else if(x==43 && y==37) begin	plot <= 1'b1;	end
		else if(x==44 && y==37) begin	plot <= 1'b1;	end
		else if(x==45 && y==37) begin	plot <= 1'b1;	end
		else if(x==46 && y==37) begin	plot <= 1'b1;	end
		else if(x==47 && y==37) begin	plot <= 1'b1;	end
		else if(x==48 && y==37) begin	plot <= 1'b1;	end
		else if(x==49 && y==37) begin	plot <= 1'b1;	end
		else if(x==50 && y==37) begin	plot <= 1'b1;	end
		else if(x==51 && y==37) begin	plot <= 1'b1;	end
		else if(x==52 && y==37) begin	plot <= 1'b1;	end
		else if(x==53 && y==37) begin	plot <= 1'b1;	end
		else if(x==54 && y==37) begin	plot <= 1'b1;	end
		else if(x==55 && y==37) begin	plot <= 1'b1;	end
		else if(x==33 && y==38) begin	plot <= 1'b1;	end
		else if(x==34 && y==38) begin	plot <= 1'b1;	end
		else if(x==35 && y==38) begin	plot <= 1'b1;	end
		else if(x==36 && y==38) begin	plot <= 1'b1;	end
		else if(x==37 && y==38) begin	plot <= 1'b1;	end
		else if(x==38 && y==38) begin	plot <= 1'b1;	end
		else if(x==39 && y==38) begin	plot <= 1'b1;	end
		else if(x==40 && y==38) begin	plot <= 1'b1;	end
		else if(x==41 && y==38) begin	plot <= 1'b1;	end
		else if(x==42 && y==38) begin	plot <= 1'b1;	end
		else if(x==43 && y==38) begin	plot <= 1'b1;	end
		else if(x==44 && y==38) begin	plot <= 1'b1;	end
		else if(x==45 && y==38) begin	plot <= 1'b1;	end
		else if(x==46 && y==38) begin	plot <= 1'b1;	end
		else if(x==47 && y==38) begin	plot <= 1'b1;	end
		else if(x==48 && y==38) begin	plot <= 1'b1;	end
		else if(x==49 && y==38) begin	plot <= 1'b1;	end
		else if(x==50 && y==38) begin	plot <= 1'b1;	end
		else if(x==51 && y==38) begin	plot <= 1'b1;	end
		else if(x==52 && y==38) begin	plot <= 1'b1;	end
		else if(x==53 && y==38) begin	plot <= 1'b1;	end
		else if(x==54 && y==38) begin	plot <= 1'b1;	end
		else if(x==33 && y==39) begin	plot <= 1'b1;	end
		else if(x==34 && y==39) begin	plot <= 1'b1;	end
		else if(x==35 && y==39) begin	plot <= 1'b1;	end
		else if(x==36 && y==39) begin	plot <= 1'b1;	end
		else if(x==37 && y==39) begin	plot <= 1'b1;	end
		else if(x==38 && y==39) begin	plot <= 1'b1;	end
		else if(x==39 && y==39) begin	plot <= 1'b1;	end
		else if(x==40 && y==39) begin	plot <= 1'b1;	end
		else if(x==41 && y==39) begin	plot <= 1'b1;	end
		else if(x==42 && y==39) begin	plot <= 1'b1;	end
		else if(x==43 && y==39) begin	plot <= 1'b1;	end
		else if(x==44 && y==39) begin	plot <= 1'b1;	end
		else if(x==45 && y==39) begin	plot <= 1'b1;	end
		else if(x==46 && y==39) begin	plot <= 1'b1;	end
		else if(x==47 && y==39) begin	plot <= 1'b1;	end
		else if(x==48 && y==39) begin	plot <= 1'b1;	end
		else if(x==49 && y==39) begin	plot <= 1'b1;	end
		else if(x==50 && y==39) begin	plot <= 1'b1;	end
		else if(x==51 && y==39) begin	plot <= 1'b1;	end
		else if(x==52 && y==39) begin	plot <= 1'b1;	end
		else if(x==53 && y==39) begin	plot <= 1'b1;	end
		else if(x==54 && y==39) begin	plot <= 1'b1;	end
		else if(x==32 && y==40) begin	plot <= 1'b1;	end
		else if(x==33 && y==40) begin	plot <= 1'b1;	end
		else if(x==34 && y==40) begin	plot <= 1'b1;	end
		else if(x==35 && y==40) begin	plot <= 1'b1;	end
		else if(x==36 && y==40) begin	plot <= 1'b1;	end
		else if(x==37 && y==40) begin	plot <= 1'b1;	end
		else if(x==38 && y==40) begin	plot <= 1'b1;	end
		else if(x==39 && y==40) begin	plot <= 1'b1;	end
		else if(x==40 && y==40) begin	plot <= 1'b1;	end
		else if(x==41 && y==40) begin	plot <= 1'b1;	end
		else if(x==42 && y==40) begin	plot <= 1'b1;	end
		else if(x==43 && y==40) begin	plot <= 1'b1;	end
		else if(x==44 && y==40) begin	plot <= 1'b1;	end
		else if(x==45 && y==40) begin	plot <= 1'b1;	end
		else if(x==46 && y==40) begin	plot <= 1'b1;	end
		else if(x==47 && y==40) begin	plot <= 1'b1;	end
		else if(x==48 && y==40) begin	plot <= 1'b1;	end
		else if(x==49 && y==40) begin	plot <= 1'b1;	end
		else if(x==50 && y==40) begin	plot <= 1'b1;	end
		else if(x==51 && y==40) begin	plot <= 1'b1;	end
		else if(x==52 && y==40) begin	plot <= 1'b1;	end
		else if(x==53 && y==40) begin	plot <= 1'b1;	end
		else if(x==54 && y==40) begin	plot <= 1'b1;	end
		else if(x==28 && y==41) begin	plot <= 1'b1;	end
		else if(x==29 && y==41) begin	plot <= 1'b1;	end
		else if(x==30 && y==41) begin	plot <= 1'b1;	end
		else if(x==31 && y==41) begin	plot <= 1'b1;	end
		else if(x==32 && y==41) begin	plot <= 1'b1;	end
		else if(x==33 && y==41) begin	plot <= 1'b1;	end
		else if(x==34 && y==41) begin	plot <= 1'b1;	end
		else if(x==35 && y==41) begin	plot <= 1'b1;	end
		else if(x==36 && y==41) begin	plot <= 1'b1;	end
		else if(x==37 && y==41) begin	plot <= 1'b1;	end
		else if(x==38 && y==41) begin	plot <= 1'b1;	end
		else if(x==39 && y==41) begin	plot <= 1'b1;	end
		else if(x==40 && y==41) begin	plot <= 1'b1;	end
		else if(x==41 && y==41) begin	plot <= 1'b1;	end
		else if(x==42 && y==41) begin	plot <= 1'b1;	end
		else if(x==43 && y==41) begin	plot <= 1'b1;	end
		else if(x==44 && y==41) begin	plot <= 1'b1;	end
		else if(x==45 && y==41) begin	plot <= 1'b1;	end
		else if(x==46 && y==41) begin	plot <= 1'b1;	end
		else if(x==47 && y==41) begin	plot <= 1'b1;	end
		else if(x==48 && y==41) begin	plot <= 1'b1;	end
		else if(x==49 && y==41) begin	plot <= 1'b1;	end
		else if(x==50 && y==41) begin	plot <= 1'b1;	end
		else if(x==51 && y==41) begin	plot <= 1'b1;	end
		else if(x==52 && y==41) begin	plot <= 1'b1;	end
		else if(x==53 && y==41) begin	plot <= 1'b1;	end
		else if(x==54 && y==41) begin	plot <= 1'b1;	end
		else if(x==31 && y==42) begin	plot <= 1'b1;	end
		else if(x==32 && y==42) begin	plot <= 1'b1;	end
		else if(x==33 && y==42) begin	plot <= 1'b1;	end
		else if(x==34 && y==42) begin	plot <= 1'b1;	end
		else if(x==35 && y==42) begin	plot <= 1'b1;	end
		else if(x==36 && y==42) begin	plot <= 1'b1;	end
		else if(x==37 && y==42) begin	plot <= 1'b1;	end
		else if(x==38 && y==42) begin	plot <= 1'b1;	end
		else if(x==39 && y==42) begin	plot <= 1'b1;	end
		else if(x==40 && y==42) begin	plot <= 1'b1;	end
		else if(x==41 && y==42) begin	plot <= 1'b1;	end
		else if(x==42 && y==42) begin	plot <= 1'b1;	end
		else if(x==43 && y==42) begin	plot <= 1'b1;	end
		else if(x==44 && y==42) begin	plot <= 1'b1;	end
		else if(x==45 && y==42) begin	plot <= 1'b1;	end
		else if(x==46 && y==42) begin	plot <= 1'b1;	end
		else if(x==47 && y==42) begin	plot <= 1'b1;	end
		else if(x==48 && y==42) begin	plot <= 1'b1;	end
		else if(x==49 && y==42) begin	plot <= 1'b1;	end
		else if(x==50 && y==42) begin	plot <= 1'b1;	end
		else if(x==51 && y==42) begin	plot <= 1'b1;	end
		else if(x==52 && y==42) begin	plot <= 1'b1;	end
		else if(x==53 && y==42) begin	plot <= 1'b1;	end
		else if(x==54 && y==42) begin	plot <= 1'b1;	end
		else if(x==55 && y==42) begin	plot <= 1'b1;	end
		else if(x==56 && y==42) begin	plot <= 1'b1;	end
		else if(x==58 && y==42) begin	plot <= 1'b1;	end
		else if(x==32 && y==43) begin	plot <= 1'b1;	end
		else if(x==33 && y==43) begin	plot <= 1'b1;	end
		else if(x==34 && y==43) begin	plot <= 1'b1;	end
		else if(x==35 && y==43) begin	plot <= 1'b1;	end
		else if(x==36 && y==43) begin	plot <= 1'b1;	end
		else if(x==37 && y==43) begin	plot <= 1'b1;	end
		else if(x==38 && y==43) begin	plot <= 1'b1;	end
		else if(x==39 && y==43) begin	plot <= 1'b1;	end
		else if(x==40 && y==43) begin	plot <= 1'b1;	end
		else if(x==41 && y==43) begin	plot <= 1'b1;	end
		else if(x==42 && y==43) begin	plot <= 1'b1;	end
		else if(x==43 && y==43) begin	plot <= 1'b1;	end
		else if(x==44 && y==43) begin	plot <= 1'b1;	end
		else if(x==45 && y==43) begin	plot <= 1'b1;	end
		else if(x==46 && y==43) begin	plot <= 1'b1;	end
		else if(x==47 && y==43) begin	plot <= 1'b1;	end
		else if(x==48 && y==43) begin	plot <= 1'b1;	end
		else if(x==49 && y==43) begin	plot <= 1'b1;	end
		else if(x==50 && y==43) begin	plot <= 1'b1;	end
		else if(x==51 && y==43) begin	plot <= 1'b1;	end
		else if(x==52 && y==43) begin	plot <= 1'b1;	end
		else if(x==53 && y==43) begin	plot <= 1'b1;	end
		else if(x==54 && y==43) begin	plot <= 1'b1;	end
		else if(x==55 && y==43) begin	plot <= 1'b1;	end
		else if(x==56 && y==43) begin	plot <= 1'b1;	end
		else if(x==57 && y==43) begin	plot <= 1'b1;	end
		else if(x==58 && y==43) begin	plot <= 1'b1;	end
		else if(x==59 && y==43) begin	plot <= 1'b1;	end
		else if(x==60 && y==43) begin	plot <= 1'b1;	end
		else if(x==33 && y==44) begin	plot <= 1'b1;	end
		else if(x==34 && y==44) begin	plot <= 1'b1;	end
		else if(x==35 && y==44) begin	plot <= 1'b1;	end
		else if(x==36 && y==44) begin	plot <= 1'b1;	end
		else if(x==37 && y==44) begin	plot <= 1'b1;	end
		else if(x==38 && y==44) begin	plot <= 1'b1;	end
		else if(x==39 && y==44) begin	plot <= 1'b1;	end
		else if(x==40 && y==44) begin	plot <= 1'b1;	end
		else if(x==41 && y==44) begin	plot <= 1'b1;	end
		else if(x==42 && y==44) begin	plot <= 1'b1;	end
		else if(x==43 && y==44) begin	plot <= 1'b1;	end
		else if(x==44 && y==44) begin	plot <= 1'b1;	end
		else if(x==45 && y==44) begin	plot <= 1'b1;	end
		else if(x==46 && y==44) begin	plot <= 1'b1;	end
		else if(x==47 && y==44) begin	plot <= 1'b1;	end
		else if(x==48 && y==44) begin	plot <= 1'b1;	end
		else if(x==49 && y==44) begin	plot <= 1'b1;	end
		else if(x==50 && y==44) begin	plot <= 1'b1;	end
		else if(x==51 && y==44) begin	plot <= 1'b1;	end
		else if(x==52 && y==44) begin	plot <= 1'b1;	end
		else if(x==53 && y==44) begin	plot <= 1'b1;	end
		else if(x==54 && y==44) begin	plot <= 1'b1;	end
		else if(x==55 && y==44) begin	plot <= 1'b1;	end
		else if(x==56 && y==44) begin	plot <= 1'b1;	end
		else if(x==33 && y==45) begin	plot <= 1'b1;	end
		else if(x==34 && y==45) begin	plot <= 1'b1;	end
		else if(x==35 && y==45) begin	plot <= 1'b1;	end
		else if(x==36 && y==45) begin	plot <= 1'b1;	end
		else if(x==37 && y==45) begin	plot <= 1'b1;	end
		else if(x==38 && y==45) begin	plot <= 1'b1;	end
		else if(x==39 && y==45) begin	plot <= 1'b1;	end
		else if(x==40 && y==45) begin	plot <= 1'b1;	end
		else if(x==41 && y==45) begin	plot <= 1'b1;	end
		else if(x==42 && y==45) begin	plot <= 1'b1;	end
		else if(x==43 && y==45) begin	plot <= 1'b1;	end
		else if(x==44 && y==45) begin	plot <= 1'b1;	end
		else if(x==45 && y==45) begin	plot <= 1'b1;	end
		else if(x==46 && y==45) begin	plot <= 1'b1;	end
		else if(x==47 && y==45) begin	plot <= 1'b1;	end
		else if(x==48 && y==45) begin	plot <= 1'b1;	end
		else if(x==49 && y==45) begin	plot <= 1'b1;	end
		else if(x==50 && y==45) begin	plot <= 1'b1;	end
		else if(x==51 && y==45) begin	plot <= 1'b1;	end
		else if(x==52 && y==45) begin	plot <= 1'b1;	end
		else if(x==53 && y==45) begin	plot <= 1'b1;	end
		else if(x==54 && y==45) begin	plot <= 1'b1;	end
		else if(x==33 && y==46) begin	plot <= 1'b1;	end
		else if(x==34 && y==46) begin	plot <= 1'b1;	end
		else if(x==35 && y==46) begin	plot <= 1'b1;	end
		else if(x==36 && y==46) begin	plot <= 1'b1;	end
		else if(x==37 && y==46) begin	plot <= 1'b1;	end
		else if(x==38 && y==46) begin	plot <= 1'b1;	end
		else if(x==39 && y==46) begin	plot <= 1'b1;	end
		else if(x==40 && y==46) begin	plot <= 1'b1;	end
		else if(x==41 && y==46) begin	plot <= 1'b1;	end
		else if(x==42 && y==46) begin	plot <= 1'b1;	end
		else if(x==43 && y==46) begin	plot <= 1'b1;	end
		else if(x==44 && y==46) begin	plot <= 1'b1;	end
		else if(x==45 && y==46) begin	plot <= 1'b1;	end
		else if(x==46 && y==46) begin	plot <= 1'b1;	end
		else if(x==47 && y==46) begin	plot <= 1'b1;	end
		else if(x==48 && y==46) begin	plot <= 1'b1;	end
		else if(x==49 && y==46) begin	plot <= 1'b1;	end
		else if(x==50 && y==46) begin	plot <= 1'b1;	end
		else if(x==51 && y==46) begin	plot <= 1'b1;	end
		else if(x==52 && y==46) begin	plot <= 1'b1;	end
		else if(x==53 && y==46) begin	plot <= 1'b1;	end
		else if(x==54 && y==46) begin	plot <= 1'b1;	end
		else if(x==33 && y==47) begin	plot <= 1'b1;	end
		else if(x==34 && y==47) begin	plot <= 1'b1;	end
		else if(x==35 && y==47) begin	plot <= 1'b1;	end
		else if(x==36 && y==47) begin	plot <= 1'b1;	end
		else if(x==37 && y==47) begin	plot <= 1'b1;	end
		else if(x==38 && y==47) begin	plot <= 1'b1;	end
		else if(x==39 && y==47) begin	plot <= 1'b1;	end
		else if(x==40 && y==47) begin	plot <= 1'b1;	end
		else if(x==41 && y==47) begin	plot <= 1'b1;	end
		else if(x==42 && y==47) begin	plot <= 1'b1;	end
		else if(x==43 && y==47) begin	plot <= 1'b1;	end
		else if(x==44 && y==47) begin	plot <= 1'b1;	end
		else if(x==45 && y==47) begin	plot <= 1'b1;	end
		else if(x==46 && y==47) begin	plot <= 1'b1;	end
		else if(x==47 && y==47) begin	plot <= 1'b1;	end
		else if(x==48 && y==47) begin	plot <= 1'b1;	end
		else if(x==49 && y==47) begin	plot <= 1'b1;	end
		else if(x==50 && y==47) begin	plot <= 1'b1;	end
		else if(x==51 && y==47) begin	plot <= 1'b1;	end
		else if(x==52 && y==47) begin	plot <= 1'b1;	end
		else if(x==53 && y==47) begin	plot <= 1'b1;	end
		else if(x==54 && y==47) begin	plot <= 1'b1;	end
		else if(x==34 && y==48) begin	plot <= 1'b1;	end
		else if(x==35 && y==48) begin	plot <= 1'b1;	end
		else if(x==36 && y==48) begin	plot <= 1'b1;	end
		else if(x==37 && y==48) begin	plot <= 1'b1;	end
		else if(x==38 && y==48) begin	plot <= 1'b1;	end
		else if(x==39 && y==48) begin	plot <= 1'b1;	end
		else if(x==40 && y==48) begin	plot <= 1'b1;	end
		else if(x==41 && y==48) begin	plot <= 1'b1;	end
		else if(x==42 && y==48) begin	plot <= 1'b1;	end
		else if(x==43 && y==48) begin	plot <= 1'b1;	end
		else if(x==44 && y==48) begin	plot <= 1'b1;	end
		else if(x==45 && y==48) begin	plot <= 1'b1;	end
		else if(x==46 && y==48) begin	plot <= 1'b1;	end
		else if(x==47 && y==48) begin	plot <= 1'b1;	end
		else if(x==48 && y==48) begin	plot <= 1'b1;	end
		else if(x==49 && y==48) begin	plot <= 1'b1;	end
		else if(x==50 && y==48) begin	plot <= 1'b1;	end
		else if(x==51 && y==48) begin	plot <= 1'b1;	end
		else if(x==52 && y==48) begin	plot <= 1'b1;	end
		else if(x==53 && y==48) begin	plot <= 1'b1;	end
		else if(x==35 && y==49) begin	plot <= 1'b1;	end
		else if(x==36 && y==49) begin	plot <= 1'b1;	end
		else if(x==37 && y==49) begin	plot <= 1'b1;	end
		else if(x==38 && y==49) begin	plot <= 1'b1;	end
		else if(x==39 && y==49) begin	plot <= 1'b1;	end
		else if(x==40 && y==49) begin	plot <= 1'b1;	end
		else if(x==41 && y==49) begin	plot <= 1'b1;	end
		else if(x==42 && y==49) begin	plot <= 1'b1;	end
		else if(x==43 && y==49) begin	plot <= 1'b1;	end
		else if(x==44 && y==49) begin	plot <= 1'b1;	end
		else if(x==45 && y==49) begin	plot <= 1'b1;	end
		else if(x==46 && y==49) begin	plot <= 1'b1;	end
		else if(x==47 && y==49) begin	plot <= 1'b1;	end
		else if(x==48 && y==49) begin	plot <= 1'b1;	end
		else if(x==49 && y==49) begin	plot <= 1'b1;	end
		else if(x==50 && y==49) begin	plot <= 1'b1;	end
		else if(x==51 && y==49) begin	plot <= 1'b1;	end
		else if(x==34 && y==50) begin	plot <= 1'b1;	end
		else if(x==35 && y==50) begin	plot <= 1'b1;	end
		else if(x==36 && y==50) begin	plot <= 1'b1;	end
		else if(x==37 && y==50) begin	plot <= 1'b1;	end
		else if(x==38 && y==50) begin	plot <= 1'b1;	end
		else if(x==39 && y==50) begin	plot <= 1'b1;	end
		else if(x==40 && y==50) begin	plot <= 1'b1;	end
		else if(x==41 && y==50) begin	plot <= 1'b1;	end
		else if(x==42 && y==50) begin	plot <= 1'b1;	end
		else if(x==43 && y==50) begin	plot <= 1'b1;	end
		else if(x==44 && y==50) begin	plot <= 1'b1;	end
		else if(x==45 && y==50) begin	plot <= 1'b1;	end
		else if(x==46 && y==50) begin	plot <= 1'b1;	end
		else if(x==47 && y==50) begin	plot <= 1'b1;	end
		else if(x==48 && y==50) begin	plot <= 1'b1;	end
		else if(x==49 && y==50) begin	plot <= 1'b1;	end
		else if(x==50 && y==50) begin	plot <= 1'b1;	end
		else if(x==51 && y==50) begin	plot <= 1'b1;	end
		else if(x==34 && y==51) begin	plot <= 1'b1;	end
		else if(x==35 && y==51) begin	plot <= 1'b1;	end
		else if(x==36 && y==51) begin	plot <= 1'b1;	end
		else if(x==38 && y==51) begin	plot <= 1'b1;	end
		else if(x==39 && y==51) begin	plot <= 1'b1;	end
		else if(x==40 && y==51) begin	plot <= 1'b1;	end
		else if(x==41 && y==51) begin	plot <= 1'b1;	end
		else if(x==42 && y==51) begin	plot <= 1'b1;	end
		else if(x==43 && y==51) begin	plot <= 1'b1;	end
		else if(x==44 && y==51) begin	plot <= 1'b1;	end
		else if(x==45 && y==51) begin	plot <= 1'b1;	end
		else if(x==46 && y==51) begin	plot <= 1'b1;	end
		else if(x==47 && y==51) begin	plot <= 1'b1;	end
		else if(x==48 && y==51) begin	plot <= 1'b1;	end
		else if(x==49 && y==51) begin	plot <= 1'b1;	end
		else if(x==50 && y==51) begin	plot <= 1'b1;	end
		else if(x==51 && y==51) begin	plot <= 1'b1;	end
		else if(x==33 && y==52) begin	plot <= 1'b1;	end
		else if(x==34 && y==52) begin	plot <= 1'b1;	end
		else if(x==39 && y==52) begin	plot <= 1'b1;	end
		else if(x==40 && y==52) begin	plot <= 1'b1;	end
		else if(x==41 && y==52) begin	plot <= 1'b1;	end
		else if(x==42 && y==52) begin	plot <= 1'b1;	end
		else if(x==43 && y==52) begin	plot <= 1'b1;	end
		else if(x==44 && y==52) begin	plot <= 1'b1;	end
		else if(x==45 && y==52) begin	plot <= 1'b1;	end
		else if(x==50 && y==52) begin	plot <= 1'b1;	end
		else if(x==51 && y==52) begin	plot <= 1'b1;	end
		else if(x==52 && y==52) begin	plot <= 1'b1;	end
		else if(x==32 && y==53) begin	plot <= 1'b1;	end
		else if(x==33 && y==53) begin	plot <= 1'b1;	end
		else if(x==51 && y==53) begin	plot <= 1'b1;	end
		else if(x==52 && y==53) begin	plot <= 1'b1;	end
		else if(x==32 && y==54) begin	plot <= 1'b1;	end
		else begin plot <= 1'b0; end// Width: 89, Height: 79
	end
endmodule


// module for plotting the second explosion
module b222(
	input clk,
	input wire [9:0] characterPositionX,
	input wire [8:0] characterPositionY,
	input wire [9:0] drawingPositionX,
	input wire [8:0] drawingPositionY,
	output reg [2:0] plot
);
	reg [9:0] x;
	reg [9:0] y;
	initial begin
		x = 'd0;
		y = 'd0;
	end

	always @(posedge clk) begin
		x <= (drawingPositionX - characterPositionX + 45);
		y <= (drawingPositionY - characterPositionY + 40);
		if(x==45 && y==12) begin	plot <= 1'b1;	end
		else if(x==44 && y==13) begin	plot <= 1'b1;	end
		else if(x==45 && y==13) begin	plot <= 1'b1;	end
		else if(x==44 && y==14) begin	plot <= 1'b1;	end
		else if(x==44 && y==15) begin	plot <= 1'b1;	end
		else if(x==44 && y==16) begin	plot <= 1'b1;	end
		else if(x==43 && y==17) begin	plot <= 1'b1;	end
		else if(x==44 && y==17) begin	plot <= 1'b1;	end
		else if(x==20 && y==18) begin	plot <= 1'b1;	end
		else if(x==43 && y==18) begin	plot <= 1'b1;	end
		else if(x==44 && y==18) begin	plot <= 1'b1;	end
		else if(x==45 && y==18) begin	plot <= 1'b1;	end
		else if(x==21 && y==19) begin	plot <= 1'b1;	end
		else if(x==43 && y==19) begin	plot <= 1'b1;	end
		else if(x==44 && y==19) begin	plot <= 1'b1;	end
		else if(x==45 && y==19) begin	plot <= 1'b1;	end
		else if(x==43 && y==20) begin	plot <= 1'b1;	end
		else if(x==44 && y==20) begin	plot <= 1'b1;	end
		else if(x==45 && y==20) begin	plot <= 1'b1;	end
		else if(x==24 && y==21) begin	plot <= 1'b1;	end
		else if(x==43 && y==21) begin	plot <= 1'b1;	end
		else if(x==44 && y==21) begin	plot <= 1'b1;	end
		else if(x==45 && y==21) begin	plot <= 1'b1;	end
		else if(x==24 && y==22) begin	plot <= 1'b1;	end
		else if(x==25 && y==22) begin	plot <= 1'b1;	end
		else if(x==26 && y==22) begin	plot <= 1'b1;	end
		else if(x==42 && y==22) begin	plot <= 1'b1;	end
		else if(x==43 && y==22) begin	plot <= 1'b1;	end
		else if(x==44 && y==22) begin	plot <= 1'b1;	end
		else if(x==45 && y==22) begin	plot <= 1'b1;	end
		else if(x==25 && y==23) begin	plot <= 1'b1;	end
		else if(x==26 && y==23) begin	plot <= 1'b1;	end
		else if(x==27 && y==23) begin	plot <= 1'b1;	end
		else if(x==42 && y==23) begin	plot <= 1'b1;	end
		else if(x==43 && y==23) begin	plot <= 1'b1;	end
		else if(x==44 && y==23) begin	plot <= 1'b1;	end
		else if(x==45 && y==23) begin	plot <= 1'b1;	end
		else if(x==71 && y==23) begin	plot <= 1'b1;	end
		else if(x==26 && y==24) begin	plot <= 1'b1;	end
		else if(x==27 && y==24) begin	plot <= 1'b1;	end
		else if(x==28 && y==24) begin	plot <= 1'b1;	end
		else if(x==37 && y==24) begin	plot <= 1'b1;	end
		else if(x==42 && y==24) begin	plot <= 1'b1;	end
		else if(x==43 && y==24) begin	plot <= 1'b1;	end
		else if(x==44 && y==24) begin	plot <= 1'b1;	end
		else if(x==45 && y==24) begin	plot <= 1'b1;	end
		else if(x==70 && y==24) begin	plot <= 1'b1;	end
		else if(x==27 && y==25) begin	plot <= 1'b1;	end
		else if(x==28 && y==25) begin	plot <= 1'b1;	end
		else if(x==29 && y==25) begin	plot <= 1'b1;	end
		else if(x==30 && y==25) begin	plot <= 1'b1;	end
		else if(x==37 && y==25) begin	plot <= 1'b1;	end
		else if(x==38 && y==25) begin	plot <= 1'b1;	end
		else if(x==42 && y==25) begin	plot <= 1'b1;	end
		else if(x==43 && y==25) begin	plot <= 1'b1;	end
		else if(x==44 && y==25) begin	plot <= 1'b1;	end
		else if(x==45 && y==25) begin	plot <= 1'b1;	end
		else if(x==68 && y==25) begin	plot <= 1'b1;	end
		else if(x==69 && y==25) begin	plot <= 1'b1;	end
		else if(x==28 && y==26) begin	plot <= 1'b1;	end
		else if(x==29 && y==26) begin	plot <= 1'b1;	end
		else if(x==30 && y==26) begin	plot <= 1'b1;	end
		else if(x==31 && y==26) begin	plot <= 1'b1;	end
		else if(x==37 && y==26) begin	plot <= 1'b1;	end
		else if(x==38 && y==26) begin	plot <= 1'b1;	end
		else if(x==39 && y==26) begin	plot <= 1'b1;	end
		else if(x==42 && y==26) begin	plot <= 1'b1;	end
		else if(x==43 && y==26) begin	plot <= 1'b1;	end
		else if(x==44 && y==26) begin	plot <= 1'b1;	end
		else if(x==45 && y==26) begin	plot <= 1'b1;	end
		else if(x==67 && y==26) begin	plot <= 1'b1;	end
		else if(x==28 && y==27) begin	plot <= 1'b1;	end
		else if(x==29 && y==27) begin	plot <= 1'b1;	end
		else if(x==30 && y==27) begin	plot <= 1'b1;	end
		else if(x==31 && y==27) begin	plot <= 1'b1;	end
		else if(x==32 && y==27) begin	plot <= 1'b1;	end
		else if(x==38 && y==27) begin	plot <= 1'b1;	end
		else if(x==39 && y==27) begin	plot <= 1'b1;	end
		else if(x==40 && y==27) begin	plot <= 1'b1;	end
		else if(x==41 && y==27) begin	plot <= 1'b1;	end
		else if(x==42 && y==27) begin	plot <= 1'b1;	end
		else if(x==43 && y==27) begin	plot <= 1'b1;	end
		else if(x==44 && y==27) begin	plot <= 1'b1;	end
		else if(x==45 && y==27) begin	plot <= 1'b1;	end
		else if(x==53 && y==27) begin	plot <= 1'b1;	end
		else if(x==54 && y==27) begin	plot <= 1'b1;	end
		else if(x==65 && y==27) begin	plot <= 1'b1;	end
		else if(x==66 && y==27) begin	plot <= 1'b1;	end
		else if(x==29 && y==28) begin	plot <= 1'b1;	end
		else if(x==30 && y==28) begin	plot <= 1'b1;	end
		else if(x==31 && y==28) begin	plot <= 1'b1;	end
		else if(x==32 && y==28) begin	plot <= 1'b1;	end
		else if(x==33 && y==28) begin	plot <= 1'b1;	end
		else if(x==34 && y==28) begin	plot <= 1'b1;	end
		else if(x==38 && y==28) begin	plot <= 1'b1;	end
		else if(x==39 && y==28) begin	plot <= 1'b1;	end
		else if(x==40 && y==28) begin	plot <= 1'b1;	end
		else if(x==41 && y==28) begin	plot <= 1'b1;	end
		else if(x==42 && y==28) begin	plot <= 1'b1;	end
		else if(x==43 && y==28) begin	plot <= 1'b1;	end
		else if(x==44 && y==28) begin	plot <= 1'b1;	end
		else if(x==45 && y==28) begin	plot <= 1'b1;	end
		else if(x==46 && y==28) begin	plot <= 1'b1;	end
		else if(x==47 && y==28) begin	plot <= 1'b1;	end
		else if(x==52 && y==28) begin	plot <= 1'b1;	end
		else if(x==53 && y==28) begin	plot <= 1'b1;	end
		else if(x==64 && y==28) begin	plot <= 1'b1;	end
		else if(x==65 && y==28) begin	plot <= 1'b1;	end
		else if(x==30 && y==29) begin	plot <= 1'b1;	end
		else if(x==31 && y==29) begin	plot <= 1'b1;	end
		else if(x==32 && y==29) begin	plot <= 1'b1;	end
		else if(x==33 && y==29) begin	plot <= 1'b1;	end
		else if(x==34 && y==29) begin	plot <= 1'b1;	end
		else if(x==35 && y==29) begin	plot <= 1'b1;	end
		else if(x==36 && y==29) begin	plot <= 1'b1;	end
		else if(x==37 && y==29) begin	plot <= 1'b1;	end
		else if(x==38 && y==29) begin	plot <= 1'b1;	end
		else if(x==39 && y==29) begin	plot <= 1'b1;	end
		else if(x==40 && y==29) begin	plot <= 1'b1;	end
		else if(x==41 && y==29) begin	plot <= 1'b1;	end
		else if(x==42 && y==29) begin	plot <= 1'b1;	end
		else if(x==43 && y==29) begin	plot <= 1'b1;	end
		else if(x==44 && y==29) begin	plot <= 1'b1;	end
		else if(x==45 && y==29) begin	plot <= 1'b1;	end
		else if(x==46 && y==29) begin	plot <= 1'b1;	end
		else if(x==47 && y==29) begin	plot <= 1'b1;	end
		else if(x==48 && y==29) begin	plot <= 1'b1;	end
		else if(x==49 && y==29) begin	plot <= 1'b1;	end
		else if(x==50 && y==29) begin	plot <= 1'b1;	end
		else if(x==51 && y==29) begin	plot <= 1'b1;	end
		else if(x==52 && y==29) begin	plot <= 1'b1;	end
		else if(x==62 && y==29) begin	plot <= 1'b1;	end
		else if(x==63 && y==29) begin	plot <= 1'b1;	end
		else if(x==64 && y==29) begin	plot <= 1'b1;	end
		else if(x==65 && y==29) begin	plot <= 1'b1;	end
		else if(x==31 && y==30) begin	plot <= 1'b1;	end
		else if(x==32 && y==30) begin	plot <= 1'b1;	end
		else if(x==33 && y==30) begin	plot <= 1'b1;	end
		else if(x==34 && y==30) begin	plot <= 1'b1;	end
		else if(x==35 && y==30) begin	plot <= 1'b1;	end
		else if(x==36 && y==30) begin	plot <= 1'b1;	end
		else if(x==37 && y==30) begin	plot <= 1'b1;	end
		else if(x==38 && y==30) begin	plot <= 1'b1;	end
		else if(x==39 && y==30) begin	plot <= 1'b1;	end
		else if(x==40 && y==30) begin	plot <= 1'b1;	end
		else if(x==41 && y==30) begin	plot <= 1'b1;	end
		else if(x==42 && y==30) begin	plot <= 1'b1;	end
		else if(x==43 && y==30) begin	plot <= 1'b1;	end
		else if(x==44 && y==30) begin	plot <= 1'b1;	end
		else if(x==45 && y==30) begin	plot <= 1'b1;	end
		else if(x==46 && y==30) begin	plot <= 1'b1;	end
		else if(x==47 && y==30) begin	plot <= 1'b1;	end
		else if(x==48 && y==30) begin	plot <= 1'b1;	end
		else if(x==49 && y==30) begin	plot <= 1'b1;	end
		else if(x==50 && y==30) begin	plot <= 1'b1;	end
		else if(x==51 && y==30) begin	plot <= 1'b1;	end
		else if(x==52 && y==30) begin	plot <= 1'b1;	end
		else if(x==61 && y==30) begin	plot <= 1'b1;	end
		else if(x==62 && y==30) begin	plot <= 1'b1;	end
		else if(x==63 && y==30) begin	plot <= 1'b1;	end
		else if(x==64 && y==30) begin	plot <= 1'b1;	end
		else if(x==31 && y==31) begin	plot <= 1'b1;	end
		else if(x==32 && y==31) begin	plot <= 1'b1;	end
		else if(x==33 && y==31) begin	plot <= 1'b1;	end
		else if(x==34 && y==31) begin	plot <= 1'b1;	end
		else if(x==35 && y==31) begin	plot <= 1'b1;	end
		else if(x==36 && y==31) begin	plot <= 1'b1;	end
		else if(x==37 && y==31) begin	plot <= 1'b1;	end
		else if(x==38 && y==31) begin	plot <= 1'b1;	end
		else if(x==39 && y==31) begin	plot <= 1'b1;	end
		else if(x==40 && y==31) begin	plot <= 1'b1;	end
		else if(x==41 && y==31) begin	plot <= 1'b1;	end
		else if(x==42 && y==31) begin	plot <= 1'b1;	end
		else if(x==43 && y==31) begin	plot <= 1'b1;	end
		else if(x==44 && y==31) begin	plot <= 1'b1;	end
		else if(x==45 && y==31) begin	plot <= 1'b1;	end
		else if(x==46 && y==31) begin	plot <= 1'b1;	end
		else if(x==47 && y==31) begin	plot <= 1'b1;	end
		else if(x==48 && y==31) begin	plot <= 1'b1;	end
		else if(x==49 && y==31) begin	plot <= 1'b1;	end
		else if(x==50 && y==31) begin	plot <= 1'b1;	end
		else if(x==51 && y==31) begin	plot <= 1'b1;	end
		else if(x==52 && y==31) begin	plot <= 1'b1;	end
		else if(x==53 && y==31) begin	plot <= 1'b1;	end
		else if(x==60 && y==31) begin	plot <= 1'b1;	end
		else if(x==61 && y==31) begin	plot <= 1'b1;	end
		else if(x==62 && y==31) begin	plot <= 1'b1;	end
		else if(x==63 && y==31) begin	plot <= 1'b1;	end
		else if(x==32 && y==32) begin	plot <= 1'b1;	end
		else if(x==33 && y==32) begin	plot <= 1'b1;	end
		else if(x==34 && y==32) begin	plot <= 1'b1;	end
		else if(x==35 && y==32) begin	plot <= 1'b1;	end
		else if(x==36 && y==32) begin	plot <= 1'b1;	end
		else if(x==37 && y==32) begin	plot <= 1'b1;	end
		else if(x==38 && y==32) begin	plot <= 1'b1;	end
		else if(x==39 && y==32) begin	plot <= 1'b1;	end
		else if(x==40 && y==32) begin	plot <= 1'b1;	end
		else if(x==41 && y==32) begin	plot <= 1'b1;	end
		else if(x==42 && y==32) begin	plot <= 1'b1;	end
		else if(x==43 && y==32) begin	plot <= 1'b1;	end
		else if(x==44 && y==32) begin	plot <= 1'b1;	end
		else if(x==45 && y==32) begin	plot <= 1'b1;	end
		else if(x==46 && y==32) begin	plot <= 1'b1;	end
		else if(x==47 && y==32) begin	plot <= 1'b1;	end
		else if(x==48 && y==32) begin	plot <= 1'b1;	end
		else if(x==49 && y==32) begin	plot <= 1'b1;	end
		else if(x==50 && y==32) begin	plot <= 1'b1;	end
		else if(x==51 && y==32) begin	plot <= 1'b1;	end
		else if(x==52 && y==32) begin	plot <= 1'b1;	end
		else if(x==53 && y==32) begin	plot <= 1'b1;	end
		else if(x==54 && y==32) begin	plot <= 1'b1;	end
		else if(x==58 && y==32) begin	plot <= 1'b1;	end
		else if(x==59 && y==32) begin	plot <= 1'b1;	end
		else if(x==60 && y==32) begin	plot <= 1'b1;	end
		else if(x==61 && y==32) begin	plot <= 1'b1;	end
		else if(x==62 && y==32) begin	plot <= 1'b1;	end
		else if(x==32 && y==33) begin	plot <= 1'b1;	end
		else if(x==33 && y==33) begin	plot <= 1'b1;	end
		else if(x==34 && y==33) begin	plot <= 1'b1;	end
		else if(x==35 && y==33) begin	plot <= 1'b1;	end
		else if(x==36 && y==33) begin	plot <= 1'b1;	end
		else if(x==37 && y==33) begin	plot <= 1'b1;	end
		else if(x==38 && y==33) begin	plot <= 1'b1;	end
		else if(x==39 && y==33) begin	plot <= 1'b1;	end
		else if(x==40 && y==33) begin	plot <= 1'b1;	end
		else if(x==41 && y==33) begin	plot <= 1'b1;	end
		else if(x==42 && y==33) begin	plot <= 1'b1;	end
		else if(x==43 && y==33) begin	plot <= 1'b1;	end
		else if(x==44 && y==33) begin	plot <= 1'b1;	end
		else if(x==45 && y==33) begin	plot <= 1'b1;	end
		else if(x==46 && y==33) begin	plot <= 1'b1;	end
		else if(x==47 && y==33) begin	plot <= 1'b1;	end
		else if(x==48 && y==33) begin	plot <= 1'b1;	end
		else if(x==49 && y==33) begin	plot <= 1'b1;	end
		else if(x==50 && y==33) begin	plot <= 1'b1;	end
		else if(x==51 && y==33) begin	plot <= 1'b1;	end
		else if(x==52 && y==33) begin	plot <= 1'b1;	end
		else if(x==53 && y==33) begin	plot <= 1'b1;	end
		else if(x==54 && y==33) begin	plot <= 1'b1;	end
		else if(x==55 && y==33) begin	plot <= 1'b1;	end
		else if(x==56 && y==33) begin	plot <= 1'b1;	end
		else if(x==57 && y==33) begin	plot <= 1'b1;	end
		else if(x==58 && y==33) begin	plot <= 1'b1;	end
		else if(x==59 && y==33) begin	plot <= 1'b1;	end
		else if(x==60 && y==33) begin	plot <= 1'b1;	end
		else if(x==61 && y==33) begin	plot <= 1'b1;	end
		else if(x==32 && y==34) begin	plot <= 1'b1;	end
		else if(x==33 && y==34) begin	plot <= 1'b1;	end
		else if(x==34 && y==34) begin	plot <= 1'b1;	end
		else if(x==35 && y==34) begin	plot <= 1'b1;	end
		else if(x==36 && y==34) begin	plot <= 1'b1;	end
		else if(x==37 && y==34) begin	plot <= 1'b1;	end
		else if(x==38 && y==34) begin	plot <= 1'b1;	end
		else if(x==39 && y==34) begin	plot <= 1'b1;	end
		else if(x==40 && y==34) begin	plot <= 1'b1;	end
		else if(x==41 && y==34) begin	plot <= 1'b1;	end
		else if(x==42 && y==34) begin	plot <= 1'b1;	end
		else if(x==43 && y==34) begin	plot <= 1'b1;	end
		else if(x==44 && y==34) begin	plot <= 1'b1;	end
		else if(x==45 && y==34) begin	plot <= 1'b1;	end
		else if(x==46 && y==34) begin	plot <= 1'b1;	end
		else if(x==47 && y==34) begin	plot <= 1'b1;	end
		else if(x==48 && y==34) begin	plot <= 1'b1;	end
		else if(x==49 && y==34) begin	plot <= 1'b1;	end
		else if(x==50 && y==34) begin	plot <= 1'b1;	end
		else if(x==51 && y==34) begin	plot <= 1'b1;	end
		else if(x==52 && y==34) begin	plot <= 1'b1;	end
		else if(x==53 && y==34) begin	plot <= 1'b1;	end
		else if(x==54 && y==34) begin	plot <= 1'b1;	end
		else if(x==55 && y==34) begin	plot <= 1'b1;	end
		else if(x==56 && y==34) begin	plot <= 1'b1;	end
		else if(x==57 && y==34) begin	plot <= 1'b1;	end
		else if(x==58 && y==34) begin	plot <= 1'b1;	end
		else if(x==59 && y==34) begin	plot <= 1'b1;	end
		else if(x==60 && y==34) begin	plot <= 1'b1;	end
		else if(x==32 && y==35) begin	plot <= 1'b1;	end
		else if(x==33 && y==35) begin	plot <= 1'b1;	end
		else if(x==34 && y==35) begin	plot <= 1'b1;	end
		else if(x==35 && y==35) begin	plot <= 1'b1;	end
		else if(x==36 && y==35) begin	plot <= 1'b1;	end
		else if(x==37 && y==35) begin	plot <= 1'b1;	end
		else if(x==38 && y==35) begin	plot <= 1'b1;	end
		else if(x==39 && y==35) begin	plot <= 1'b1;	end
		else if(x==40 && y==35) begin	plot <= 1'b1;	end
		else if(x==41 && y==35) begin	plot <= 1'b1;	end
		else if(x==42 && y==35) begin	plot <= 1'b1;	end
		else if(x==43 && y==35) begin	plot <= 1'b1;	end
		else if(x==44 && y==35) begin	plot <= 1'b1;	end
		else if(x==45 && y==35) begin	plot <= 1'b1;	end
		else if(x==46 && y==35) begin	plot <= 1'b1;	end
		else if(x==47 && y==35) begin	plot <= 1'b1;	end
		else if(x==48 && y==35) begin	plot <= 1'b1;	end
		else if(x==49 && y==35) begin	plot <= 1'b1;	end
		else if(x==50 && y==35) begin	plot <= 1'b1;	end
		else if(x==51 && y==35) begin	plot <= 1'b1;	end
		else if(x==52 && y==35) begin	plot <= 1'b1;	end
		else if(x==53 && y==35) begin	plot <= 1'b1;	end
		else if(x==54 && y==35) begin	plot <= 1'b1;	end
		else if(x==55 && y==35) begin	plot <= 1'b1;	end
		else if(x==56 && y==35) begin	plot <= 1'b1;	end
		else if(x==57 && y==35) begin	plot <= 1'b1;	end
		else if(x==58 && y==35) begin	plot <= 1'b1;	end
		else if(x==59 && y==35) begin	plot <= 1'b1;	end
		else if(x==31 && y==36) begin	plot <= 1'b1;	end
		else if(x==32 && y==36) begin	plot <= 1'b1;	end
		else if(x==33 && y==36) begin	plot <= 1'b1;	end
		else if(x==34 && y==36) begin	plot <= 1'b1;	end
		else if(x==35 && y==36) begin	plot <= 1'b1;	end
		else if(x==36 && y==36) begin	plot <= 1'b1;	end
		else if(x==37 && y==36) begin	plot <= 1'b1;	end
		else if(x==38 && y==36) begin	plot <= 1'b1;	end
		else if(x==39 && y==36) begin	plot <= 1'b1;	end
		else if(x==40 && y==36) begin	plot <= 1'b1;	end
		else if(x==41 && y==36) begin	plot <= 1'b1;	end
		else if(x==42 && y==36) begin	plot <= 1'b1;	end
		else if(x==43 && y==36) begin	plot <= 1'b1;	end
		else if(x==44 && y==36) begin	plot <= 1'b1;	end
		else if(x==45 && y==36) begin	plot <= 1'b1;	end
		else if(x==46 && y==36) begin	plot <= 1'b1;	end
		else if(x==47 && y==36) begin	plot <= 1'b1;	end
		else if(x==48 && y==36) begin	plot <= 1'b1;	end
		else if(x==49 && y==36) begin	plot <= 1'b1;	end
		else if(x==50 && y==36) begin	plot <= 1'b1;	end
		else if(x==51 && y==36) begin	plot <= 1'b1;	end
		else if(x==52 && y==36) begin	plot <= 1'b1;	end
		else if(x==53 && y==36) begin	plot <= 1'b1;	end
		else if(x==54 && y==36) begin	plot <= 1'b1;	end
		else if(x==55 && y==36) begin	plot <= 1'b1;	end
		else if(x==56 && y==36) begin	plot <= 1'b1;	end
		else if(x==57 && y==36) begin	plot <= 1'b1;	end
		else if(x==31 && y==37) begin	plot <= 1'b1;	end
		else if(x==32 && y==37) begin	plot <= 1'b1;	end
		else if(x==33 && y==37) begin	plot <= 1'b1;	end
		else if(x==34 && y==37) begin	plot <= 1'b1;	end
		else if(x==35 && y==37) begin	plot <= 1'b1;	end
		else if(x==36 && y==37) begin	plot <= 1'b1;	end
		else if(x==37 && y==37) begin	plot <= 1'b1;	end
		else if(x==38 && y==37) begin	plot <= 1'b1;	end
		else if(x==39 && y==37) begin	plot <= 1'b1;	end
		else if(x==40 && y==37) begin	plot <= 1'b1;	end
		else if(x==41 && y==37) begin	plot <= 1'b1;	end
		else if(x==42 && y==37) begin	plot <= 1'b1;	end
		else if(x==43 && y==37) begin	plot <= 1'b1;	end
		else if(x==44 && y==37) begin	plot <= 1'b1;	end
		else if(x==45 && y==37) begin	plot <= 1'b1;	end
		else if(x==46 && y==37) begin	plot <= 1'b1;	end
		else if(x==47 && y==37) begin	plot <= 1'b1;	end
		else if(x==48 && y==37) begin	plot <= 1'b1;	end
		else if(x==49 && y==37) begin	plot <= 1'b1;	end
		else if(x==50 && y==37) begin	plot <= 1'b1;	end
		else if(x==51 && y==37) begin	plot <= 1'b1;	end
		else if(x==52 && y==37) begin	plot <= 1'b1;	end
		else if(x==53 && y==37) begin	plot <= 1'b1;	end
		else if(x==54 && y==37) begin	plot <= 1'b1;	end
		else if(x==55 && y==37) begin	plot <= 1'b1;	end
		else if(x==56 && y==37) begin	plot <= 1'b1;	end
		else if(x==57 && y==37) begin	plot <= 1'b1;	end
		else if(x==32 && y==38) begin	plot <= 1'b1;	end
		else if(x==33 && y==38) begin	plot <= 1'b1;	end
		else if(x==34 && y==38) begin	plot <= 1'b1;	end
		else if(x==35 && y==38) begin	plot <= 1'b1;	end
		else if(x==36 && y==38) begin	plot <= 1'b1;	end
		else if(x==37 && y==38) begin	plot <= 1'b1;	end
		else if(x==38 && y==38) begin	plot <= 1'b1;	end
		else if(x==39 && y==38) begin	plot <= 1'b1;	end
		else if(x==40 && y==38) begin	plot <= 1'b1;	end
		else if(x==41 && y==38) begin	plot <= 1'b1;	end
		else if(x==42 && y==38) begin	plot <= 1'b1;	end
		else if(x==43 && y==38) begin	plot <= 1'b1;	end
		else if(x==44 && y==38) begin	plot <= 1'b1;	end
		else if(x==45 && y==38) begin	plot <= 1'b1;	end
		else if(x==46 && y==38) begin	plot <= 1'b1;	end
		else if(x==47 && y==38) begin	plot <= 1'b1;	end
		else if(x==48 && y==38) begin	plot <= 1'b1;	end
		else if(x==49 && y==38) begin	plot <= 1'b1;	end
		else if(x==50 && y==38) begin	plot <= 1'b1;	end
		else if(x==51 && y==38) begin	plot <= 1'b1;	end
		else if(x==52 && y==38) begin	plot <= 1'b1;	end
		else if(x==53 && y==38) begin	plot <= 1'b1;	end
		else if(x==54 && y==38) begin	plot <= 1'b1;	end
		else if(x==55 && y==38) begin	plot <= 1'b1;	end
		else if(x==56 && y==38) begin	plot <= 1'b1;	end
		else if(x==57 && y==38) begin	plot <= 1'b1;	end
		else if(x==58 && y==38) begin	plot <= 1'b1;	end
		else if(x==32 && y==39) begin	plot <= 1'b1;	end
		else if(x==33 && y==39) begin	plot <= 1'b1;	end
		else if(x==34 && y==39) begin	plot <= 1'b1;	end
		else if(x==35 && y==39) begin	plot <= 1'b1;	end
		else if(x==36 && y==39) begin	plot <= 1'b1;	end
		else if(x==37 && y==39) begin	plot <= 1'b1;	end
		else if(x==38 && y==39) begin	plot <= 1'b1;	end
		else if(x==39 && y==39) begin	plot <= 1'b1;	end
		else if(x==40 && y==39) begin	plot <= 1'b1;	end
		else if(x==41 && y==39) begin	plot <= 1'b1;	end
		else if(x==42 && y==39) begin	plot <= 1'b1;	end
		else if(x==43 && y==39) begin	plot <= 1'b1;	end
		else if(x==44 && y==39) begin	plot <= 1'b1;	end
		else if(x==45 && y==39) begin	plot <= 1'b1;	end
		else if(x==46 && y==39) begin	plot <= 1'b1;	end
		else if(x==47 && y==39) begin	plot <= 1'b1;	end
		else if(x==48 && y==39) begin	plot <= 1'b1;	end
		else if(x==49 && y==39) begin	plot <= 1'b1;	end
		else if(x==50 && y==39) begin	plot <= 1'b1;	end
		else if(x==51 && y==39) begin	plot <= 1'b1;	end
		else if(x==52 && y==39) begin	plot <= 1'b1;	end
		else if(x==53 && y==39) begin	plot <= 1'b1;	end
		else if(x==54 && y==39) begin	plot <= 1'b1;	end
		else if(x==55 && y==39) begin	plot <= 1'b1;	end
		else if(x==56 && y==39) begin	plot <= 1'b1;	end
		else if(x==57 && y==39) begin	plot <= 1'b1;	end
		else if(x==58 && y==39) begin	plot <= 1'b1;	end
		else if(x==59 && y==39) begin	plot <= 1'b1;	end
		else if(x==23 && y==40) begin	plot <= 1'b1;	end
		else if(x==24 && y==40) begin	plot <= 1'b1;	end
		else if(x==25 && y==40) begin	plot <= 1'b1;	end
		else if(x==26 && y==40) begin	plot <= 1'b1;	end
		else if(x==27 && y==40) begin	plot <= 1'b1;	end
		else if(x==28 && y==40) begin	plot <= 1'b1;	end
		else if(x==29 && y==40) begin	plot <= 1'b1;	end
		else if(x==30 && y==40) begin	plot <= 1'b1;	end
		else if(x==31 && y==40) begin	plot <= 1'b1;	end
		else if(x==32 && y==40) begin	plot <= 1'b1;	end
		else if(x==33 && y==40) begin	plot <= 1'b1;	end
		else if(x==34 && y==40) begin	plot <= 1'b1;	end
		else if(x==35 && y==40) begin	plot <= 1'b1;	end
		else if(x==36 && y==40) begin	plot <= 1'b1;	end
		else if(x==37 && y==40) begin	plot <= 1'b1;	end
		else if(x==38 && y==40) begin	plot <= 1'b1;	end
		else if(x==39 && y==40) begin	plot <= 1'b1;	end
		else if(x==40 && y==40) begin	plot <= 1'b1;	end
		else if(x==41 && y==40) begin	plot <= 1'b1;	end
		else if(x==42 && y==40) begin	plot <= 1'b1;	end
		else if(x==43 && y==40) begin	plot <= 1'b1;	end
		else if(x==44 && y==40) begin	plot <= 1'b1;	end
		else if(x==45 && y==40) begin	plot <= 1'b1;	end
		else if(x==46 && y==40) begin	plot <= 1'b1;	end
		else if(x==47 && y==40) begin	plot <= 1'b1;	end
		else if(x==48 && y==40) begin	plot <= 1'b1;	end
		else if(x==49 && y==40) begin	plot <= 1'b1;	end
		else if(x==50 && y==40) begin	plot <= 1'b1;	end
		else if(x==51 && y==40) begin	plot <= 1'b1;	end
		else if(x==52 && y==40) begin	plot <= 1'b1;	end
		else if(x==53 && y==40) begin	plot <= 1'b1;	end
		else if(x==54 && y==40) begin	plot <= 1'b1;	end
		else if(x==55 && y==40) begin	plot <= 1'b1;	end
		else if(x==56 && y==40) begin	plot <= 1'b1;	end
		else if(x==57 && y==40) begin	plot <= 1'b1;	end
		else if(x==58 && y==40) begin	plot <= 1'b1;	end
		else if(x==59 && y==40) begin	plot <= 1'b1;	end
		else if(x==16 && y==41) begin	plot <= 1'b1;	end
		else if(x==17 && y==41) begin	plot <= 1'b1;	end
		else if(x==18 && y==41) begin	plot <= 1'b1;	end
		else if(x==19 && y==41) begin	plot <= 1'b1;	end
		else if(x==20 && y==41) begin	plot <= 1'b1;	end
		else if(x==21 && y==41) begin	plot <= 1'b1;	end
		else if(x==22 && y==41) begin	plot <= 1'b1;	end
		else if(x==23 && y==41) begin	plot <= 1'b1;	end
		else if(x==24 && y==41) begin	plot <= 1'b1;	end
		else if(x==25 && y==41) begin	plot <= 1'b1;	end
		else if(x==26 && y==41) begin	plot <= 1'b1;	end
		else if(x==27 && y==41) begin	plot <= 1'b1;	end
		else if(x==28 && y==41) begin	plot <= 1'b1;	end
		else if(x==29 && y==41) begin	plot <= 1'b1;	end
		else if(x==30 && y==41) begin	plot <= 1'b1;	end
		else if(x==31 && y==41) begin	plot <= 1'b1;	end
		else if(x==32 && y==41) begin	plot <= 1'b1;	end
		else if(x==33 && y==41) begin	plot <= 1'b1;	end
		else if(x==34 && y==41) begin	plot <= 1'b1;	end
		else if(x==35 && y==41) begin	plot <= 1'b1;	end
		else if(x==36 && y==41) begin	plot <= 1'b1;	end
		else if(x==37 && y==41) begin	plot <= 1'b1;	end
		else if(x==38 && y==41) begin	plot <= 1'b1;	end
		else if(x==39 && y==41) begin	plot <= 1'b1;	end
		else if(x==40 && y==41) begin	plot <= 1'b1;	end
		else if(x==41 && y==41) begin	plot <= 1'b1;	end
		else if(x==42 && y==41) begin	plot <= 1'b1;	end
		else if(x==43 && y==41) begin	plot <= 1'b1;	end
		else if(x==44 && y==41) begin	plot <= 1'b1;	end
		else if(x==45 && y==41) begin	plot <= 1'b1;	end
		else if(x==46 && y==41) begin	plot <= 1'b1;	end
		else if(x==47 && y==41) begin	plot <= 1'b1;	end
		else if(x==48 && y==41) begin	plot <= 1'b1;	end
		else if(x==49 && y==41) begin	plot <= 1'b1;	end
		else if(x==50 && y==41) begin	plot <= 1'b1;	end
		else if(x==51 && y==41) begin	plot <= 1'b1;	end
		else if(x==52 && y==41) begin	plot <= 1'b1;	end
		else if(x==53 && y==41) begin	plot <= 1'b1;	end
		else if(x==54 && y==41) begin	plot <= 1'b1;	end
		else if(x==55 && y==41) begin	plot <= 1'b1;	end
		else if(x==56 && y==41) begin	plot <= 1'b1;	end
		else if(x==57 && y==41) begin	plot <= 1'b1;	end
		else if(x==58 && y==41) begin	plot <= 1'b1;	end
		else if(x==59 && y==41) begin	plot <= 1'b1;	end
		else if(x==18 && y==42) begin	plot <= 1'b1;	end
		else if(x==20 && y==42) begin	plot <= 1'b1;	end
		else if(x==21 && y==42) begin	plot <= 1'b1;	end
		else if(x==22 && y==42) begin	plot <= 1'b1;	end
		else if(x==23 && y==42) begin	plot <= 1'b1;	end
		else if(x==24 && y==42) begin	plot <= 1'b1;	end
		else if(x==25 && y==42) begin	plot <= 1'b1;	end
		else if(x==26 && y==42) begin	plot <= 1'b1;	end
		else if(x==27 && y==42) begin	plot <= 1'b1;	end
		else if(x==28 && y==42) begin	plot <= 1'b1;	end
		else if(x==29 && y==42) begin	plot <= 1'b1;	end
		else if(x==30 && y==42) begin	plot <= 1'b1;	end
		else if(x==31 && y==42) begin	plot <= 1'b1;	end
		else if(x==32 && y==42) begin	plot <= 1'b1;	end
		else if(x==33 && y==42) begin	plot <= 1'b1;	end
		else if(x==34 && y==42) begin	plot <= 1'b1;	end
		else if(x==35 && y==42) begin	plot <= 1'b1;	end
		else if(x==36 && y==42) begin	plot <= 1'b1;	end
		else if(x==37 && y==42) begin	plot <= 1'b1;	end
		else if(x==38 && y==42) begin	plot <= 1'b1;	end
		else if(x==39 && y==42) begin	plot <= 1'b1;	end
		else if(x==40 && y==42) begin	plot <= 1'b1;	end
		else if(x==41 && y==42) begin	plot <= 1'b1;	end
		else if(x==42 && y==42) begin	plot <= 1'b1;	end
		else if(x==43 && y==42) begin	plot <= 1'b1;	end
		else if(x==44 && y==42) begin	plot <= 1'b1;	end
		else if(x==45 && y==42) begin	plot <= 1'b1;	end
		else if(x==46 && y==42) begin	plot <= 1'b1;	end
		else if(x==47 && y==42) begin	plot <= 1'b1;	end
		else if(x==48 && y==42) begin	plot <= 1'b1;	end
		else if(x==49 && y==42) begin	plot <= 1'b1;	end
		else if(x==50 && y==42) begin	plot <= 1'b1;	end
		else if(x==51 && y==42) begin	plot <= 1'b1;	end
		else if(x==52 && y==42) begin	plot <= 1'b1;	end
		else if(x==53 && y==42) begin	plot <= 1'b1;	end
		else if(x==54 && y==42) begin	plot <= 1'b1;	end
		else if(x==55 && y==42) begin	plot <= 1'b1;	end
		else if(x==56 && y==42) begin	plot <= 1'b1;	end
		else if(x==57 && y==42) begin	plot <= 1'b1;	end
		else if(x==58 && y==42) begin	plot <= 1'b1;	end
		else if(x==59 && y==42) begin	plot <= 1'b1;	end
		else if(x==60 && y==42) begin	plot <= 1'b1;	end
		else if(x==61 && y==42) begin	plot <= 1'b1;	end
		else if(x==62 && y==42) begin	plot <= 1'b1;	end
		else if(x==63 && y==42) begin	plot <= 1'b1;	end
		else if(x==64 && y==42) begin	plot <= 1'b1;	end
		else if(x==65 && y==42) begin	plot <= 1'b1;	end
		else if(x==66 && y==42) begin	plot <= 1'b1;	end
		else if(x==67 && y==42) begin	plot <= 1'b1;	end
		else if(x==68 && y==42) begin	plot <= 1'b1;	end
		else if(x==25 && y==43) begin	plot <= 1'b1;	end
		else if(x==26 && y==43) begin	plot <= 1'b1;	end
		else if(x==27 && y==43) begin	plot <= 1'b1;	end
		else if(x==28 && y==43) begin	plot <= 1'b1;	end
		else if(x==29 && y==43) begin	plot <= 1'b1;	end
		else if(x==30 && y==43) begin	plot <= 1'b1;	end
		else if(x==31 && y==43) begin	plot <= 1'b1;	end
		else if(x==32 && y==43) begin	plot <= 1'b1;	end
		else if(x==33 && y==43) begin	plot <= 1'b1;	end
		else if(x==34 && y==43) begin	plot <= 1'b1;	end
		else if(x==35 && y==43) begin	plot <= 1'b1;	end
		else if(x==36 && y==43) begin	plot <= 1'b1;	end
		else if(x==37 && y==43) begin	plot <= 1'b1;	end
		else if(x==38 && y==43) begin	plot <= 1'b1;	end
		else if(x==39 && y==43) begin	plot <= 1'b1;	end
		else if(x==40 && y==43) begin	plot <= 1'b1;	end
		else if(x==41 && y==43) begin	plot <= 1'b1;	end
		else if(x==42 && y==43) begin	plot <= 1'b1;	end
		else if(x==43 && y==43) begin	plot <= 1'b1;	end
		else if(x==44 && y==43) begin	plot <= 1'b1;	end
		else if(x==45 && y==43) begin	plot <= 1'b1;	end
		else if(x==46 && y==43) begin	plot <= 1'b1;	end
		else if(x==47 && y==43) begin	plot <= 1'b1;	end
		else if(x==48 && y==43) begin	plot <= 1'b1;	end
		else if(x==49 && y==43) begin	plot <= 1'b1;	end
		else if(x==50 && y==43) begin	plot <= 1'b1;	end
		else if(x==51 && y==43) begin	plot <= 1'b1;	end
		else if(x==52 && y==43) begin	plot <= 1'b1;	end
		else if(x==53 && y==43) begin	plot <= 1'b1;	end
		else if(x==54 && y==43) begin	plot <= 1'b1;	end
		else if(x==55 && y==43) begin	plot <= 1'b1;	end
		else if(x==56 && y==43) begin	plot <= 1'b1;	end
		else if(x==57 && y==43) begin	plot <= 1'b1;	end
		else if(x==58 && y==43) begin	plot <= 1'b1;	end
		else if(x==59 && y==43) begin	plot <= 1'b1;	end
		else if(x==60 && y==43) begin	plot <= 1'b1;	end
		else if(x==61 && y==43) begin	plot <= 1'b1;	end
		else if(x==62 && y==43) begin	plot <= 1'b1;	end
		else if(x==63 && y==43) begin	plot <= 1'b1;	end
		else if(x==64 && y==43) begin	plot <= 1'b1;	end
		else if(x==65 && y==43) begin	plot <= 1'b1;	end
		else if(x==66 && y==43) begin	plot <= 1'b1;	end
		else if(x==67 && y==43) begin	plot <= 1'b1;	end
		else if(x==68 && y==43) begin	plot <= 1'b1;	end
		else if(x==69 && y==43) begin	plot <= 1'b1;	end
		else if(x==75 && y==43) begin	plot <= 1'b1;	end
		else if(x==31 && y==44) begin	plot <= 1'b1;	end
		else if(x==32 && y==44) begin	plot <= 1'b1;	end
		else if(x==33 && y==44) begin	plot <= 1'b1;	end
		else if(x==34 && y==44) begin	plot <= 1'b1;	end
		else if(x==35 && y==44) begin	plot <= 1'b1;	end
		else if(x==36 && y==44) begin	plot <= 1'b1;	end
		else if(x==37 && y==44) begin	plot <= 1'b1;	end
		else if(x==38 && y==44) begin	plot <= 1'b1;	end
		else if(x==39 && y==44) begin	plot <= 1'b1;	end
		else if(x==40 && y==44) begin	plot <= 1'b1;	end
		else if(x==41 && y==44) begin	plot <= 1'b1;	end
		else if(x==42 && y==44) begin	plot <= 1'b1;	end
		else if(x==43 && y==44) begin	plot <= 1'b1;	end
		else if(x==44 && y==44) begin	plot <= 1'b1;	end
		else if(x==45 && y==44) begin	plot <= 1'b1;	end
		else if(x==46 && y==44) begin	plot <= 1'b1;	end
		else if(x==47 && y==44) begin	plot <= 1'b1;	end
		else if(x==48 && y==44) begin	plot <= 1'b1;	end
		else if(x==49 && y==44) begin	plot <= 1'b1;	end
		else if(x==50 && y==44) begin	plot <= 1'b1;	end
		else if(x==51 && y==44) begin	plot <= 1'b1;	end
		else if(x==52 && y==44) begin	plot <= 1'b1;	end
		else if(x==53 && y==44) begin	plot <= 1'b1;	end
		else if(x==54 && y==44) begin	plot <= 1'b1;	end
		else if(x==55 && y==44) begin	plot <= 1'b1;	end
		else if(x==56 && y==44) begin	plot <= 1'b1;	end
		else if(x==57 && y==44) begin	plot <= 1'b1;	end
		else if(x==58 && y==44) begin	plot <= 1'b1;	end
		else if(x==59 && y==44) begin	plot <= 1'b1;	end
		else if(x==60 && y==44) begin	plot <= 1'b1;	end
		else if(x==61 && y==44) begin	plot <= 1'b1;	end
		else if(x==62 && y==44) begin	plot <= 1'b1;	end
		else if(x==63 && y==44) begin	plot <= 1'b1;	end
		else if(x==32 && y==45) begin	plot <= 1'b1;	end
		else if(x==33 && y==45) begin	plot <= 1'b1;	end
		else if(x==34 && y==45) begin	plot <= 1'b1;	end
		else if(x==35 && y==45) begin	plot <= 1'b1;	end
		else if(x==36 && y==45) begin	plot <= 1'b1;	end
		else if(x==37 && y==45) begin	plot <= 1'b1;	end
		else if(x==38 && y==45) begin	plot <= 1'b1;	end
		else if(x==39 && y==45) begin	plot <= 1'b1;	end
		else if(x==40 && y==45) begin	plot <= 1'b1;	end
		else if(x==41 && y==45) begin	plot <= 1'b1;	end
		else if(x==42 && y==45) begin	plot <= 1'b1;	end
		else if(x==43 && y==45) begin	plot <= 1'b1;	end
		else if(x==44 && y==45) begin	plot <= 1'b1;	end
		else if(x==45 && y==45) begin	plot <= 1'b1;	end
		else if(x==46 && y==45) begin	plot <= 1'b1;	end
		else if(x==47 && y==45) begin	plot <= 1'b1;	end
		else if(x==48 && y==45) begin	plot <= 1'b1;	end
		else if(x==49 && y==45) begin	plot <= 1'b1;	end
		else if(x==50 && y==45) begin	plot <= 1'b1;	end
		else if(x==51 && y==45) begin	plot <= 1'b1;	end
		else if(x==52 && y==45) begin	plot <= 1'b1;	end
		else if(x==53 && y==45) begin	plot <= 1'b1;	end
		else if(x==54 && y==45) begin	plot <= 1'b1;	end
		else if(x==55 && y==45) begin	plot <= 1'b1;	end
		else if(x==56 && y==45) begin	plot <= 1'b1;	end
		else if(x==57 && y==45) begin	plot <= 1'b1;	end
		else if(x==58 && y==45) begin	plot <= 1'b1;	end
		else if(x==31 && y==46) begin	plot <= 1'b1;	end
		else if(x==32 && y==46) begin	plot <= 1'b1;	end
		else if(x==33 && y==46) begin	plot <= 1'b1;	end
		else if(x==34 && y==46) begin	plot <= 1'b1;	end
		else if(x==35 && y==46) begin	plot <= 1'b1;	end
		else if(x==36 && y==46) begin	plot <= 1'b1;	end
		else if(x==37 && y==46) begin	plot <= 1'b1;	end
		else if(x==38 && y==46) begin	plot <= 1'b1;	end
		else if(x==39 && y==46) begin	plot <= 1'b1;	end
		else if(x==40 && y==46) begin	plot <= 1'b1;	end
		else if(x==41 && y==46) begin	plot <= 1'b1;	end
		else if(x==42 && y==46) begin	plot <= 1'b1;	end
		else if(x==43 && y==46) begin	plot <= 1'b1;	end
		else if(x==44 && y==46) begin	plot <= 1'b1;	end
		else if(x==45 && y==46) begin	plot <= 1'b1;	end
		else if(x==46 && y==46) begin	plot <= 1'b1;	end
		else if(x==47 && y==46) begin	plot <= 1'b1;	end
		else if(x==48 && y==46) begin	plot <= 1'b1;	end
		else if(x==49 && y==46) begin	plot <= 1'b1;	end
		else if(x==50 && y==46) begin	plot <= 1'b1;	end
		else if(x==51 && y==46) begin	plot <= 1'b1;	end
		else if(x==52 && y==46) begin	plot <= 1'b1;	end
		else if(x==53 && y==46) begin	plot <= 1'b1;	end
		else if(x==54 && y==46) begin	plot <= 1'b1;	end
		else if(x==55 && y==46) begin	plot <= 1'b1;	end
		else if(x==56 && y==46) begin	plot <= 1'b1;	end
		else if(x==57 && y==46) begin	plot <= 1'b1;	end
		else if(x==58 && y==46) begin	plot <= 1'b1;	end
		else if(x==30 && y==47) begin	plot <= 1'b1;	end
		else if(x==31 && y==47) begin	plot <= 1'b1;	end
		else if(x==32 && y==47) begin	plot <= 1'b1;	end
		else if(x==33 && y==47) begin	plot <= 1'b1;	end
		else if(x==34 && y==47) begin	plot <= 1'b1;	end
		else if(x==35 && y==47) begin	plot <= 1'b1;	end
		else if(x==36 && y==47) begin	plot <= 1'b1;	end
		else if(x==37 && y==47) begin	plot <= 1'b1;	end
		else if(x==38 && y==47) begin	plot <= 1'b1;	end
		else if(x==39 && y==47) begin	plot <= 1'b1;	end
		else if(x==40 && y==47) begin	plot <= 1'b1;	end
		else if(x==41 && y==47) begin	plot <= 1'b1;	end
		else if(x==42 && y==47) begin	plot <= 1'b1;	end
		else if(x==43 && y==47) begin	plot <= 1'b1;	end
		else if(x==44 && y==47) begin	plot <= 1'b1;	end
		else if(x==45 && y==47) begin	plot <= 1'b1;	end
		else if(x==46 && y==47) begin	plot <= 1'b1;	end
		else if(x==47 && y==47) begin	plot <= 1'b1;	end
		else if(x==48 && y==47) begin	plot <= 1'b1;	end
		else if(x==49 && y==47) begin	plot <= 1'b1;	end
		else if(x==50 && y==47) begin	plot <= 1'b1;	end
		else if(x==51 && y==47) begin	plot <= 1'b1;	end
		else if(x==52 && y==47) begin	plot <= 1'b1;	end
		else if(x==53 && y==47) begin	plot <= 1'b1;	end
		else if(x==54 && y==47) begin	plot <= 1'b1;	end
		else if(x==55 && y==47) begin	plot <= 1'b1;	end
		else if(x==56 && y==47) begin	plot <= 1'b1;	end
		else if(x==57 && y==47) begin	plot <= 1'b1;	end
		else if(x==58 && y==47) begin	plot <= 1'b1;	end
		else if(x==32 && y==48) begin	plot <= 1'b1;	end
		else if(x==33 && y==48) begin	plot <= 1'b1;	end
		else if(x==34 && y==48) begin	plot <= 1'b1;	end
		else if(x==35 && y==48) begin	plot <= 1'b1;	end
		else if(x==36 && y==48) begin	plot <= 1'b1;	end
		else if(x==37 && y==48) begin	plot <= 1'b1;	end
		else if(x==38 && y==48) begin	plot <= 1'b1;	end
		else if(x==39 && y==48) begin	plot <= 1'b1;	end
		else if(x==40 && y==48) begin	plot <= 1'b1;	end
		else if(x==41 && y==48) begin	plot <= 1'b1;	end
		else if(x==42 && y==48) begin	plot <= 1'b1;	end
		else if(x==43 && y==48) begin	plot <= 1'b1;	end
		else if(x==44 && y==48) begin	plot <= 1'b1;	end
		else if(x==45 && y==48) begin	plot <= 1'b1;	end
		else if(x==46 && y==48) begin	plot <= 1'b1;	end
		else if(x==47 && y==48) begin	plot <= 1'b1;	end
		else if(x==48 && y==48) begin	plot <= 1'b1;	end
		else if(x==49 && y==48) begin	plot <= 1'b1;	end
		else if(x==50 && y==48) begin	plot <= 1'b1;	end
		else if(x==51 && y==48) begin	plot <= 1'b1;	end
		else if(x==52 && y==48) begin	plot <= 1'b1;	end
		else if(x==53 && y==48) begin	plot <= 1'b1;	end
		else if(x==54 && y==48) begin	plot <= 1'b1;	end
		else if(x==55 && y==48) begin	plot <= 1'b1;	end
		else if(x==56 && y==48) begin	plot <= 1'b1;	end
		else if(x==57 && y==48) begin	plot <= 1'b1;	end
		else if(x==58 && y==48) begin	plot <= 1'b1;	end
		else if(x==59 && y==48) begin	plot <= 1'b1;	end
		else if(x==26 && y==49) begin	plot <= 1'b1;	end
		else if(x==33 && y==49) begin	plot <= 1'b1;	end
		else if(x==34 && y==49) begin	plot <= 1'b1;	end
		else if(x==35 && y==49) begin	plot <= 1'b1;	end
		else if(x==36 && y==49) begin	plot <= 1'b1;	end
		else if(x==37 && y==49) begin	plot <= 1'b1;	end
		else if(x==38 && y==49) begin	plot <= 1'b1;	end
		else if(x==39 && y==49) begin	plot <= 1'b1;	end
		else if(x==40 && y==49) begin	plot <= 1'b1;	end
		else if(x==41 && y==49) begin	plot <= 1'b1;	end
		else if(x==42 && y==49) begin	plot <= 1'b1;	end
		else if(x==43 && y==49) begin	plot <= 1'b1;	end
		else if(x==44 && y==49) begin	plot <= 1'b1;	end
		else if(x==45 && y==49) begin	plot <= 1'b1;	end
		else if(x==46 && y==49) begin	plot <= 1'b1;	end
		else if(x==47 && y==49) begin	plot <= 1'b1;	end
		else if(x==48 && y==49) begin	plot <= 1'b1;	end
		else if(x==49 && y==49) begin	plot <= 1'b1;	end
		else if(x==50 && y==49) begin	plot <= 1'b1;	end
		else if(x==51 && y==49) begin	plot <= 1'b1;	end
		else if(x==52 && y==49) begin	plot <= 1'b1;	end
		else if(x==53 && y==49) begin	plot <= 1'b1;	end
		else if(x==54 && y==49) begin	plot <= 1'b1;	end
		else if(x==55 && y==49) begin	plot <= 1'b1;	end
		else if(x==56 && y==49) begin	plot <= 1'b1;	end
		else if(x==57 && y==49) begin	plot <= 1'b1;	end
		else if(x==58 && y==49) begin	plot <= 1'b1;	end
		else if(x==59 && y==49) begin	plot <= 1'b1;	end
		else if(x==60 && y==49) begin	plot <= 1'b1;	end
		else if(x==33 && y==50) begin	plot <= 1'b1;	end
		else if(x==34 && y==50) begin	plot <= 1'b1;	end
		else if(x==35 && y==50) begin	plot <= 1'b1;	end
		else if(x==36 && y==50) begin	plot <= 1'b1;	end
		else if(x==37 && y==50) begin	plot <= 1'b1;	end
		else if(x==38 && y==50) begin	plot <= 1'b1;	end
		else if(x==39 && y==50) begin	plot <= 1'b1;	end
		else if(x==40 && y==50) begin	plot <= 1'b1;	end
		else if(x==41 && y==50) begin	plot <= 1'b1;	end
		else if(x==42 && y==50) begin	plot <= 1'b1;	end
		else if(x==43 && y==50) begin	plot <= 1'b1;	end
		else if(x==44 && y==50) begin	plot <= 1'b1;	end
		else if(x==45 && y==50) begin	plot <= 1'b1;	end
		else if(x==46 && y==50) begin	plot <= 1'b1;	end
		else if(x==47 && y==50) begin	plot <= 1'b1;	end
		else if(x==48 && y==50) begin	plot <= 1'b1;	end
		else if(x==49 && y==50) begin	plot <= 1'b1;	end
		else if(x==50 && y==50) begin	plot <= 1'b1;	end
		else if(x==51 && y==50) begin	plot <= 1'b1;	end
		else if(x==52 && y==50) begin	plot <= 1'b1;	end
		else if(x==53 && y==50) begin	plot <= 1'b1;	end
		else if(x==54 && y==50) begin	plot <= 1'b1;	end
		else if(x==55 && y==50) begin	plot <= 1'b1;	end
		else if(x==56 && y==50) begin	plot <= 1'b1;	end
		else if(x==60 && y==50) begin	plot <= 1'b1;	end
		else if(x==61 && y==50) begin	plot <= 1'b1;	end
		else if(x==32 && y==51) begin	plot <= 1'b1;	end
		else if(x==33 && y==51) begin	plot <= 1'b1;	end
		else if(x==34 && y==51) begin	plot <= 1'b1;	end
		else if(x==35 && y==51) begin	plot <= 1'b1;	end
		else if(x==36 && y==51) begin	plot <= 1'b1;	end
		else if(x==37 && y==51) begin	plot <= 1'b1;	end
		else if(x==38 && y==51) begin	plot <= 1'b1;	end
		else if(x==39 && y==51) begin	plot <= 1'b1;	end
		else if(x==40 && y==51) begin	plot <= 1'b1;	end
		else if(x==41 && y==51) begin	plot <= 1'b1;	end
		else if(x==42 && y==51) begin	plot <= 1'b1;	end
		else if(x==43 && y==51) begin	plot <= 1'b1;	end
		else if(x==44 && y==51) begin	plot <= 1'b1;	end
		else if(x==45 && y==51) begin	plot <= 1'b1;	end
		else if(x==46 && y==51) begin	plot <= 1'b1;	end
		else if(x==47 && y==51) begin	plot <= 1'b1;	end
		else if(x==48 && y==51) begin	plot <= 1'b1;	end
		else if(x==49 && y==51) begin	plot <= 1'b1;	end
		else if(x==50 && y==51) begin	plot <= 1'b1;	end
		else if(x==51 && y==51) begin	plot <= 1'b1;	end
		else if(x==52 && y==51) begin	plot <= 1'b1;	end
		else if(x==53 && y==51) begin	plot <= 1'b1;	end
		else if(x==54 && y==51) begin	plot <= 1'b1;	end
		else if(x==31 && y==52) begin	plot <= 1'b1;	end
		else if(x==32 && y==52) begin	plot <= 1'b1;	end
		else if(x==33 && y==52) begin	plot <= 1'b1;	end
		else if(x==34 && y==52) begin	plot <= 1'b1;	end
		else if(x==35 && y==52) begin	plot <= 1'b1;	end
		else if(x==36 && y==52) begin	plot <= 1'b1;	end
		else if(x==37 && y==52) begin	plot <= 1'b1;	end
		else if(x==38 && y==52) begin	plot <= 1'b1;	end
		else if(x==39 && y==52) begin	plot <= 1'b1;	end
		else if(x==40 && y==52) begin	plot <= 1'b1;	end
		else if(x==41 && y==52) begin	plot <= 1'b1;	end
		else if(x==42 && y==52) begin	plot <= 1'b1;	end
		else if(x==43 && y==52) begin	plot <= 1'b1;	end
		else if(x==44 && y==52) begin	plot <= 1'b1;	end
		else if(x==45 && y==52) begin	plot <= 1'b1;	end
		else if(x==46 && y==52) begin	plot <= 1'b1;	end
		else if(x==47 && y==52) begin	plot <= 1'b1;	end
		else if(x==48 && y==52) begin	plot <= 1'b1;	end
		else if(x==49 && y==52) begin	plot <= 1'b1;	end
		else if(x==50 && y==52) begin	plot <= 1'b1;	end
		else if(x==51 && y==52) begin	plot <= 1'b1;	end
		else if(x==52 && y==52) begin	plot <= 1'b1;	end
		else if(x==53 && y==52) begin	plot <= 1'b1;	end
		else if(x==31 && y==53) begin	plot <= 1'b1;	end
		else if(x==32 && y==53) begin	plot <= 1'b1;	end
		else if(x==33 && y==53) begin	plot <= 1'b1;	end
		else if(x==34 && y==53) begin	plot <= 1'b1;	end
		else if(x==35 && y==53) begin	plot <= 1'b1;	end
		else if(x==36 && y==53) begin	plot <= 1'b1;	end
		else if(x==37 && y==53) begin	plot <= 1'b1;	end
		else if(x==38 && y==53) begin	plot <= 1'b1;	end
		else if(x==39 && y==53) begin	plot <= 1'b1;	end
		else if(x==40 && y==53) begin	plot <= 1'b1;	end
		else if(x==41 && y==53) begin	plot <= 1'b1;	end
		else if(x==42 && y==53) begin	plot <= 1'b1;	end
		else if(x==43 && y==53) begin	plot <= 1'b1;	end
		else if(x==44 && y==53) begin	plot <= 1'b1;	end
		else if(x==45 && y==53) begin	plot <= 1'b1;	end
		else if(x==46 && y==53) begin	plot <= 1'b1;	end
		else if(x==47 && y==53) begin	plot <= 1'b1;	end
		else if(x==48 && y==53) begin	plot <= 1'b1;	end
		else if(x==49 && y==53) begin	plot <= 1'b1;	end
		else if(x==50 && y==53) begin	plot <= 1'b1;	end
		else if(x==51 && y==53) begin	plot <= 1'b1;	end
		else if(x==52 && y==53) begin	plot <= 1'b1;	end
		else if(x==53 && y==53) begin	plot <= 1'b1;	end
		else if(x==54 && y==53) begin	plot <= 1'b1;	end
		else if(x==30 && y==54) begin	plot <= 1'b1;	end
		else if(x==31 && y==54) begin	plot <= 1'b1;	end
		else if(x==32 && y==54) begin	plot <= 1'b1;	end
		else if(x==33 && y==54) begin	plot <= 1'b1;	end
		else if(x==34 && y==54) begin	plot <= 1'b1;	end
		else if(x==35 && y==54) begin	plot <= 1'b1;	end
		else if(x==37 && y==54) begin	plot <= 1'b1;	end
		else if(x==38 && y==54) begin	plot <= 1'b1;	end
		else if(x==39 && y==54) begin	plot <= 1'b1;	end
		else if(x==40 && y==54) begin	plot <= 1'b1;	end
		else if(x==41 && y==54) begin	plot <= 1'b1;	end
		else if(x==42 && y==54) begin	plot <= 1'b1;	end
		else if(x==43 && y==54) begin	plot <= 1'b1;	end
		else if(x==44 && y==54) begin	plot <= 1'b1;	end
		else if(x==45 && y==54) begin	plot <= 1'b1;	end
		else if(x==46 && y==54) begin	plot <= 1'b1;	end
		else if(x==47 && y==54) begin	plot <= 1'b1;	end
		else if(x==48 && y==54) begin	plot <= 1'b1;	end
		else if(x==49 && y==54) begin	plot <= 1'b1;	end
		else if(x==50 && y==54) begin	plot <= 1'b1;	end
		else if(x==51 && y==54) begin	plot <= 1'b1;	end
		else if(x==52 && y==54) begin	plot <= 1'b1;	end
		else if(x==53 && y==54) begin	plot <= 1'b1;	end
		else if(x==54 && y==54) begin	plot <= 1'b1;	end
		else if(x==55 && y==54) begin	plot <= 1'b1;	end
		else if(x==29 && y==55) begin	plot <= 1'b1;	end
		else if(x==30 && y==55) begin	plot <= 1'b1;	end
		else if(x==31 && y==55) begin	plot <= 1'b1;	end
		else if(x==32 && y==55) begin	plot <= 1'b1;	end
		else if(x==33 && y==55) begin	plot <= 1'b1;	end
		else if(x==41 && y==55) begin	plot <= 1'b1;	end
		else if(x==42 && y==55) begin	plot <= 1'b1;	end
		else if(x==43 && y==55) begin	plot <= 1'b1;	end
		else if(x==44 && y==55) begin	plot <= 1'b1;	end
		else if(x==50 && y==55) begin	plot <= 1'b1;	end
		else if(x==51 && y==55) begin	plot <= 1'b1;	end
		else if(x==52 && y==55) begin	plot <= 1'b1;	end
		else if(x==53 && y==55) begin	plot <= 1'b1;	end
		else if(x==54 && y==55) begin	plot <= 1'b1;	end
		else if(x==55 && y==55) begin	plot <= 1'b1;	end
		else if(x==56 && y==55) begin	plot <= 1'b1;	end
		else if(x==28 && y==56) begin	plot <= 1'b1;	end
		else if(x==29 && y==56) begin	plot <= 1'b1;	end
		else if(x==30 && y==56) begin	plot <= 1'b1;	end
		else if(x==31 && y==56) begin	plot <= 1'b1;	end
		else if(x==32 && y==56) begin	plot <= 1'b1;	end
		else if(x==41 && y==56) begin	plot <= 1'b1;	end
		else if(x==42 && y==56) begin	plot <= 1'b1;	end
		else if(x==43 && y==56) begin	plot <= 1'b1;	end
		else if(x==52 && y==56) begin	plot <= 1'b1;	end
		else if(x==53 && y==56) begin	plot <= 1'b1;	end
		else if(x==54 && y==56) begin	plot <= 1'b1;	end
		else if(x==55 && y==56) begin	plot <= 1'b1;	end
		else if(x==56 && y==56) begin	plot <= 1'b1;	end
		else if(x==57 && y==56) begin	plot <= 1'b1;	end
		else if(x==27 && y==57) begin	plot <= 1'b1;	end
		else if(x==28 && y==57) begin	plot <= 1'b1;	end
		else if(x==29 && y==57) begin	plot <= 1'b1;	end
		else if(x==30 && y==57) begin	plot <= 1'b1;	end
		else if(x==41 && y==57) begin	plot <= 1'b1;	end
		else if(x==42 && y==57) begin	plot <= 1'b1;	end
		else if(x==43 && y==57) begin	plot <= 1'b1;	end
		else if(x==53 && y==57) begin	plot <= 1'b1;	end
		else if(x==54 && y==57) begin	plot <= 1'b1;	end
		else if(x==55 && y==57) begin	plot <= 1'b1;	end
		else if(x==56 && y==57) begin	plot <= 1'b1;	end
		else if(x==57 && y==57) begin	plot <= 1'b1;	end
		else if(x==58 && y==57) begin	plot <= 1'b1;	end
		else if(x==26 && y==58) begin	plot <= 1'b1;	end
		else if(x==27 && y==58) begin	plot <= 1'b1;	end
		else if(x==28 && y==58) begin	plot <= 1'b1;	end
		else if(x==29 && y==58) begin	plot <= 1'b1;	end
		else if(x==41 && y==58) begin	plot <= 1'b1;	end
		else if(x==42 && y==58) begin	plot <= 1'b1;	end
		else if(x==43 && y==58) begin	plot <= 1'b1;	end
		else if(x==55 && y==58) begin	plot <= 1'b1;	end
		else if(x==56 && y==58) begin	plot <= 1'b1;	end
		else if(x==57 && y==58) begin	plot <= 1'b1;	end
		else if(x==58 && y==58) begin	plot <= 1'b1;	end
		else if(x==59 && y==58) begin	plot <= 1'b1;	end
		else if(x==25 && y==59) begin	plot <= 1'b1;	end
		else if(x==26 && y==59) begin	plot <= 1'b1;	end
		else if(x==27 && y==59) begin	plot <= 1'b1;	end
		else if(x==28 && y==59) begin	plot <= 1'b1;	end
		else if(x==41 && y==59) begin	plot <= 1'b1;	end
		else if(x==42 && y==59) begin	plot <= 1'b1;	end
		else if(x==56 && y==59) begin	plot <= 1'b1;	end
		else if(x==57 && y==59) begin	plot <= 1'b1;	end
		else if(x==58 && y==59) begin	plot <= 1'b1;	end
		else if(x==59 && y==59) begin	plot <= 1'b1;	end
		else if(x==60 && y==59) begin	plot <= 1'b1;	end
		else if(x==25 && y==60) begin	plot <= 1'b1;	end
		else if(x==26 && y==60) begin	plot <= 1'b1;	end
		else if(x==42 && y==60) begin	plot <= 1'b1;	end
		else if(x==58 && y==60) begin	plot <= 1'b1;	end
		else if(x==59 && y==60) begin	plot <= 1'b1;	end
		else if(x==60 && y==60) begin	plot <= 1'b1;	end
		else if(x==24 && y==61) begin	plot <= 1'b1;	end
		else if(x==25 && y==61) begin	plot <= 1'b1;	end
		else if(x==59 && y==61) begin	plot <= 1'b1;	end
		else if(x==60 && y==61) begin	plot <= 1'b1;	end
		else if(x==61 && y==61) begin	plot <= 1'b1;	end
		else if(x==60 && y==62) begin	plot <= 1'b1;	end
		else if(x==61 && y==62) begin	plot <= 1'b1;	end
		else if(x==62 && y==62) begin	plot <= 1'b1;	end
		else if(x==22 && y==63) begin	plot <= 1'b1;	end
		else if(x==61 && y==63) begin	plot <= 1'b1;	end
		else if(x==62 && y==63) begin	plot <= 1'b1;	end
		else if(x==63 && y==63) begin	plot <= 1'b1;	end
		else if(x==20 && y==64) begin	plot <= 1'b1;	end
		else if(x==21 && y==64) begin	plot <= 1'b1;	end
		else if(x==19 && y==65) begin	plot <= 1'b1;	end
		else if(x==20 && y==65) begin	plot <= 1'b1;	end
		else if(x==64 && y==65) begin	plot <= 1'b1;	end
		else if(x==65 && y==65) begin	plot <= 1'b1;	end
		else if(x==65 && y==66) begin	plot <= 1'b1;	end
		else if(x==66 && y==66) begin	plot <= 1'b1;	end
		else begin plot <= 1'b0; end// Width: 89, Height: 79
	end
endmodule

// module for plotting the third explosion
module b333(
	input clk,
	input wire [9:0] characterPositionX,
	input wire [8:0] characterPositionY,
	input wire [9:0] drawingPositionX,
	input wire [8:0] drawingPositionY,
	output reg [2:0] plot
);
	reg [9:0] x;
	reg [9:0] y;
	initial begin
		x = 'd0;
		y = 'd0;
	end

	always @(posedge clk) begin
		x <= (drawingPositionX - characterPositionX + 45);
		y <= (drawingPositionY - characterPositionY + 40);
		if(x==46 && y==9) begin	plot <= 1'b1;	end
		else if(x==46 && y==10) begin	plot <= 1'b1;	end
		else if(x==19 && y==16) begin	plot <= 1'b1;	end
		else if(x==45 && y==16) begin	plot <= 1'b1;	end
		else if(x==45 && y==17) begin	plot <= 1'b1;	end
		else if(x==22 && y==18) begin	plot <= 1'b1;	end
		else if(x==45 && y==18) begin	plot <= 1'b1;	end
		else if(x==22 && y==19) begin	plot <= 1'b1;	end
		else if(x==23 && y==19) begin	plot <= 1'b1;	end
		else if(x==23 && y==20) begin	plot <= 1'b1;	end
		else if(x==24 && y==20) begin	plot <= 1'b1;	end
		else if(x==74 && y==20) begin	plot <= 1'b1;	end
		else if(x==24 && y==21) begin	plot <= 1'b1;	end
		else if(x==25 && y==21) begin	plot <= 1'b1;	end
		else if(x==35 && y==21) begin	plot <= 1'b1;	end
		else if(x==36 && y==21) begin	plot <= 1'b1;	end
		else if(x==37 && y==21) begin	plot <= 1'b1;	end
		else if(x==38 && y==21) begin	plot <= 1'b1;	end
		else if(x==39 && y==21) begin	plot <= 1'b1;	end
		else if(x==40 && y==21) begin	plot <= 1'b1;	end
		else if(x==33 && y==22) begin	plot <= 1'b1;	end
		else if(x==34 && y==22) begin	plot <= 1'b1;	end
		else if(x==35 && y==22) begin	plot <= 1'b1;	end
		else if(x==36 && y==22) begin	plot <= 1'b1;	end
		else if(x==37 && y==22) begin	plot <= 1'b1;	end
		else if(x==38 && y==22) begin	plot <= 1'b1;	end
		else if(x==39 && y==22) begin	plot <= 1'b1;	end
		else if(x==40 && y==22) begin	plot <= 1'b1;	end
		else if(x==41 && y==22) begin	plot <= 1'b1;	end
		else if(x==44 && y==22) begin	plot <= 1'b1;	end
		else if(x==45 && y==22) begin	plot <= 1'b1;	end
		else if(x==46 && y==22) begin	plot <= 1'b1;	end
		else if(x==47 && y==22) begin	plot <= 1'b1;	end
		else if(x==48 && y==22) begin	plot <= 1'b1;	end
		else if(x==49 && y==22) begin	plot <= 1'b1;	end
		else if(x==50 && y==22) begin	plot <= 1'b1;	end
		else if(x==51 && y==22) begin	plot <= 1'b1;	end
		else if(x==52 && y==22) begin	plot <= 1'b1;	end
		else if(x==53 && y==22) begin	plot <= 1'b1;	end
		else if(x==54 && y==22) begin	plot <= 1'b1;	end
		else if(x==55 && y==22) begin	plot <= 1'b1;	end
		else if(x==56 && y==22) begin	plot <= 1'b1;	end
		else if(x==33 && y==23) begin	plot <= 1'b1;	end
		else if(x==34 && y==23) begin	plot <= 1'b1;	end
		else if(x==35 && y==23) begin	plot <= 1'b1;	end
		else if(x==36 && y==23) begin	plot <= 1'b1;	end
		else if(x==37 && y==23) begin	plot <= 1'b1;	end
		else if(x==38 && y==23) begin	plot <= 1'b1;	end
		else if(x==39 && y==23) begin	plot <= 1'b1;	end
		else if(x==40 && y==23) begin	plot <= 1'b1;	end
		else if(x==41 && y==23) begin	plot <= 1'b1;	end
		else if(x==42 && y==23) begin	plot <= 1'b1;	end
		else if(x==43 && y==23) begin	plot <= 1'b1;	end
		else if(x==44 && y==23) begin	plot <= 1'b1;	end
		else if(x==45 && y==23) begin	plot <= 1'b1;	end
		else if(x==46 && y==23) begin	plot <= 1'b1;	end
		else if(x==47 && y==23) begin	plot <= 1'b1;	end
		else if(x==48 && y==23) begin	plot <= 1'b1;	end
		else if(x==49 && y==23) begin	plot <= 1'b1;	end
		else if(x==50 && y==23) begin	plot <= 1'b1;	end
		else if(x==51 && y==23) begin	plot <= 1'b1;	end
		else if(x==52 && y==23) begin	plot <= 1'b1;	end
		else if(x==53 && y==23) begin	plot <= 1'b1;	end
		else if(x==54 && y==23) begin	plot <= 1'b1;	end
		else if(x==55 && y==23) begin	plot <= 1'b1;	end
		else if(x==56 && y==23) begin	plot <= 1'b1;	end
		else if(x==57 && y==23) begin	plot <= 1'b1;	end
		else if(x==70 && y==23) begin	plot <= 1'b1;	end
		else if(x==71 && y==23) begin	plot <= 1'b1;	end
		else if(x==27 && y==24) begin	plot <= 1'b1;	end
		else if(x==28 && y==24) begin	plot <= 1'b1;	end
		else if(x==32 && y==24) begin	plot <= 1'b1;	end
		else if(x==33 && y==24) begin	plot <= 1'b1;	end
		else if(x==34 && y==24) begin	plot <= 1'b1;	end
		else if(x==35 && y==24) begin	plot <= 1'b1;	end
		else if(x==36 && y==24) begin	plot <= 1'b1;	end
		else if(x==37 && y==24) begin	plot <= 1'b1;	end
		else if(x==38 && y==24) begin	plot <= 1'b1;	end
		else if(x==39 && y==24) begin	plot <= 1'b1;	end
		else if(x==40 && y==24) begin	plot <= 1'b1;	end
		else if(x==41 && y==24) begin	plot <= 1'b1;	end
		else if(x==42 && y==24) begin	plot <= 1'b1;	end
		else if(x==43 && y==24) begin	plot <= 1'b1;	end
		else if(x==44 && y==24) begin	plot <= 1'b1;	end
		else if(x==45 && y==24) begin	plot <= 1'b1;	end
		else if(x==46 && y==24) begin	plot <= 1'b1;	end
		else if(x==47 && y==24) begin	plot <= 1'b1;	end
		else if(x==48 && y==24) begin	plot <= 1'b1;	end
		else if(x==49 && y==24) begin	plot <= 1'b1;	end
		else if(x==50 && y==24) begin	plot <= 1'b1;	end
		else if(x==51 && y==24) begin	plot <= 1'b1;	end
		else if(x==52 && y==24) begin	plot <= 1'b1;	end
		else if(x==53 && y==24) begin	plot <= 1'b1;	end
		else if(x==54 && y==24) begin	plot <= 1'b1;	end
		else if(x==55 && y==24) begin	plot <= 1'b1;	end
		else if(x==56 && y==24) begin	plot <= 1'b1;	end
		else if(x==57 && y==24) begin	plot <= 1'b1;	end
		else if(x==69 && y==24) begin	plot <= 1'b1;	end
		else if(x==70 && y==24) begin	plot <= 1'b1;	end
		else if(x==28 && y==25) begin	plot <= 1'b1;	end
		else if(x==29 && y==25) begin	plot <= 1'b1;	end
		else if(x==32 && y==25) begin	plot <= 1'b1;	end
		else if(x==33 && y==25) begin	plot <= 1'b1;	end
		else if(x==34 && y==25) begin	plot <= 1'b1;	end
		else if(x==35 && y==25) begin	plot <= 1'b1;	end
		else if(x==36 && y==25) begin	plot <= 1'b1;	end
		else if(x==37 && y==25) begin	plot <= 1'b1;	end
		else if(x==38 && y==25) begin	plot <= 1'b1;	end
		else if(x==39 && y==25) begin	plot <= 1'b1;	end
		else if(x==40 && y==25) begin	plot <= 1'b1;	end
		else if(x==41 && y==25) begin	plot <= 1'b1;	end
		else if(x==42 && y==25) begin	plot <= 1'b1;	end
		else if(x==43 && y==25) begin	plot <= 1'b1;	end
		else if(x==44 && y==25) begin	plot <= 1'b1;	end
		else if(x==45 && y==25) begin	plot <= 1'b1;	end
		else if(x==46 && y==25) begin	plot <= 1'b1;	end
		else if(x==47 && y==25) begin	plot <= 1'b1;	end
		else if(x==48 && y==25) begin	plot <= 1'b1;	end
		else if(x==49 && y==25) begin	plot <= 1'b1;	end
		else if(x==50 && y==25) begin	plot <= 1'b1;	end
		else if(x==51 && y==25) begin	plot <= 1'b1;	end
		else if(x==52 && y==25) begin	plot <= 1'b1;	end
		else if(x==53 && y==25) begin	plot <= 1'b1;	end
		else if(x==54 && y==25) begin	plot <= 1'b1;	end
		else if(x==55 && y==25) begin	plot <= 1'b1;	end
		else if(x==56 && y==25) begin	plot <= 1'b1;	end
		else if(x==57 && y==25) begin	plot <= 1'b1;	end
		else if(x==58 && y==25) begin	plot <= 1'b1;	end
		else if(x==68 && y==25) begin	plot <= 1'b1;	end
		else if(x==69 && y==25) begin	plot <= 1'b1;	end
		else if(x==31 && y==26) begin	plot <= 1'b1;	end
		else if(x==32 && y==26) begin	plot <= 1'b1;	end
		else if(x==33 && y==26) begin	plot <= 1'b1;	end
		else if(x==34 && y==26) begin	plot <= 1'b1;	end
		else if(x==35 && y==26) begin	plot <= 1'b1;	end
		else if(x==36 && y==26) begin	plot <= 1'b1;	end
		else if(x==37 && y==26) begin	plot <= 1'b1;	end
		else if(x==38 && y==26) begin	plot <= 1'b1;	end
		else if(x==39 && y==26) begin	plot <= 1'b1;	end
		else if(x==40 && y==26) begin	plot <= 1'b1;	end
		else if(x==41 && y==26) begin	plot <= 1'b1;	end
		else if(x==42 && y==26) begin	plot <= 1'b1;	end
		else if(x==43 && y==26) begin	plot <= 1'b1;	end
		else if(x==44 && y==26) begin	plot <= 1'b1;	end
		else if(x==45 && y==26) begin	plot <= 1'b1;	end
		else if(x==46 && y==26) begin	plot <= 1'b1;	end
		else if(x==47 && y==26) begin	plot <= 1'b1;	end
		else if(x==48 && y==26) begin	plot <= 1'b1;	end
		else if(x==49 && y==26) begin	plot <= 1'b1;	end
		else if(x==50 && y==26) begin	plot <= 1'b1;	end
		else if(x==51 && y==26) begin	plot <= 1'b1;	end
		else if(x==52 && y==26) begin	plot <= 1'b1;	end
		else if(x==53 && y==26) begin	plot <= 1'b1;	end
		else if(x==54 && y==26) begin	plot <= 1'b1;	end
		else if(x==55 && y==26) begin	plot <= 1'b1;	end
		else if(x==56 && y==26) begin	plot <= 1'b1;	end
		else if(x==57 && y==26) begin	plot <= 1'b1;	end
		else if(x==58 && y==26) begin	plot <= 1'b1;	end
		else if(x==30 && y==27) begin	plot <= 1'b1;	end
		else if(x==31 && y==27) begin	plot <= 1'b1;	end
		else if(x==32 && y==27) begin	plot <= 1'b1;	end
		else if(x==33 && y==27) begin	plot <= 1'b1;	end
		else if(x==34 && y==27) begin	plot <= 1'b1;	end
		else if(x==35 && y==27) begin	plot <= 1'b1;	end
		else if(x==36 && y==27) begin	plot <= 1'b1;	end
		else if(x==37 && y==27) begin	plot <= 1'b1;	end
		else if(x==38 && y==27) begin	plot <= 1'b1;	end
		else if(x==39 && y==27) begin	plot <= 1'b1;	end
		else if(x==40 && y==27) begin	plot <= 1'b1;	end
		else if(x==41 && y==27) begin	plot <= 1'b1;	end
		else if(x==42 && y==27) begin	plot <= 1'b1;	end
		else if(x==43 && y==27) begin	plot <= 1'b1;	end
		else if(x==44 && y==27) begin	plot <= 1'b1;	end
		else if(x==45 && y==27) begin	plot <= 1'b1;	end
		else if(x==46 && y==27) begin	plot <= 1'b1;	end
		else if(x==47 && y==27) begin	plot <= 1'b1;	end
		else if(x==48 && y==27) begin	plot <= 1'b1;	end
		else if(x==49 && y==27) begin	plot <= 1'b1;	end
		else if(x==50 && y==27) begin	plot <= 1'b1;	end
		else if(x==51 && y==27) begin	plot <= 1'b1;	end
		else if(x==52 && y==27) begin	plot <= 1'b1;	end
		else if(x==53 && y==27) begin	plot <= 1'b1;	end
		else if(x==54 && y==27) begin	plot <= 1'b1;	end
		else if(x==55 && y==27) begin	plot <= 1'b1;	end
		else if(x==56 && y==27) begin	plot <= 1'b1;	end
		else if(x==57 && y==27) begin	plot <= 1'b1;	end
		else if(x==58 && y==27) begin	plot <= 1'b1;	end
		else if(x==65 && y==27) begin	plot <= 1'b1;	end
		else if(x==30 && y==28) begin	plot <= 1'b1;	end
		else if(x==31 && y==28) begin	plot <= 1'b1;	end
		else if(x==32 && y==28) begin	plot <= 1'b1;	end
		else if(x==33 && y==28) begin	plot <= 1'b1;	end
		else if(x==34 && y==28) begin	plot <= 1'b1;	end
		else if(x==35 && y==28) begin	plot <= 1'b1;	end
		else if(x==36 && y==28) begin	plot <= 1'b1;	end
		else if(x==37 && y==28) begin	plot <= 1'b1;	end
		else if(x==38 && y==28) begin	plot <= 1'b1;	end
		else if(x==39 && y==28) begin	plot <= 1'b1;	end
		else if(x==40 && y==28) begin	plot <= 1'b1;	end
		else if(x==41 && y==28) begin	plot <= 1'b1;	end
		else if(x==42 && y==28) begin	plot <= 1'b1;	end
		else if(x==43 && y==28) begin	plot <= 1'b1;	end
		else if(x==44 && y==28) begin	plot <= 1'b1;	end
		else if(x==45 && y==28) begin	plot <= 1'b1;	end
		else if(x==46 && y==28) begin	plot <= 1'b1;	end
		else if(x==47 && y==28) begin	plot <= 1'b1;	end
		else if(x==48 && y==28) begin	plot <= 1'b1;	end
		else if(x==49 && y==28) begin	plot <= 1'b1;	end
		else if(x==50 && y==28) begin	plot <= 1'b1;	end
		else if(x==51 && y==28) begin	plot <= 1'b1;	end
		else if(x==52 && y==28) begin	plot <= 1'b1;	end
		else if(x==53 && y==28) begin	plot <= 1'b1;	end
		else if(x==54 && y==28) begin	plot <= 1'b1;	end
		else if(x==55 && y==28) begin	plot <= 1'b1;	end
		else if(x==56 && y==28) begin	plot <= 1'b1;	end
		else if(x==57 && y==28) begin	plot <= 1'b1;	end
		else if(x==58 && y==28) begin	plot <= 1'b1;	end
		else if(x==63 && y==28) begin	plot <= 1'b1;	end
		else if(x==64 && y==28) begin	plot <= 1'b1;	end
		else if(x==65 && y==28) begin	plot <= 1'b1;	end
		else if(x==28 && y==29) begin	plot <= 1'b1;	end
		else if(x==29 && y==29) begin	plot <= 1'b1;	end
		else if(x==30 && y==29) begin	plot <= 1'b1;	end
		else if(x==31 && y==29) begin	plot <= 1'b1;	end
		else if(x==32 && y==29) begin	plot <= 1'b1;	end
		else if(x==33 && y==29) begin	plot <= 1'b1;	end
		else if(x==34 && y==29) begin	plot <= 1'b1;	end
		else if(x==35 && y==29) begin	plot <= 1'b1;	end
		else if(x==36 && y==29) begin	plot <= 1'b1;	end
		else if(x==37 && y==29) begin	plot <= 1'b1;	end
		else if(x==38 && y==29) begin	plot <= 1'b1;	end
		else if(x==39 && y==29) begin	plot <= 1'b1;	end
		else if(x==40 && y==29) begin	plot <= 1'b1;	end
		else if(x==41 && y==29) begin	plot <= 1'b1;	end
		else if(x==42 && y==29) begin	plot <= 1'b1;	end
		else if(x==43 && y==29) begin	plot <= 1'b1;	end
		else if(x==44 && y==29) begin	plot <= 1'b1;	end
		else if(x==45 && y==29) begin	plot <= 1'b1;	end
		else if(x==46 && y==29) begin	plot <= 1'b1;	end
		else if(x==47 && y==29) begin	plot <= 1'b1;	end
		else if(x==48 && y==29) begin	plot <= 1'b1;	end
		else if(x==49 && y==29) begin	plot <= 1'b1;	end
		else if(x==50 && y==29) begin	plot <= 1'b1;	end
		else if(x==51 && y==29) begin	plot <= 1'b1;	end
		else if(x==52 && y==29) begin	plot <= 1'b1;	end
		else if(x==53 && y==29) begin	plot <= 1'b1;	end
		else if(x==54 && y==29) begin	plot <= 1'b1;	end
		else if(x==55 && y==29) begin	plot <= 1'b1;	end
		else if(x==56 && y==29) begin	plot <= 1'b1;	end
		else if(x==57 && y==29) begin	plot <= 1'b1;	end
		else if(x==58 && y==29) begin	plot <= 1'b1;	end
		else if(x==59 && y==29) begin	plot <= 1'b1;	end
		else if(x==62 && y==29) begin	plot <= 1'b1;	end
		else if(x==63 && y==29) begin	plot <= 1'b1;	end
		else if(x==64 && y==29) begin	plot <= 1'b1;	end
		else if(x==65 && y==29) begin	plot <= 1'b1;	end
		else if(x==27 && y==30) begin	plot <= 1'b1;	end
		else if(x==28 && y==30) begin	plot <= 1'b1;	end
		else if(x==29 && y==30) begin	plot <= 1'b1;	end
		else if(x==30 && y==30) begin	plot <= 1'b1;	end
		else if(x==31 && y==30) begin	plot <= 1'b1;	end
		else if(x==32 && y==30) begin	plot <= 1'b1;	end
		else if(x==33 && y==30) begin	plot <= 1'b1;	end
		else if(x==34 && y==30) begin	plot <= 1'b1;	end
		else if(x==35 && y==30) begin	plot <= 1'b1;	end
		else if(x==36 && y==30) begin	plot <= 1'b1;	end
		else if(x==37 && y==30) begin	plot <= 1'b1;	end
		else if(x==38 && y==30) begin	plot <= 1'b1;	end
		else if(x==39 && y==30) begin	plot <= 1'b1;	end
		else if(x==40 && y==30) begin	plot <= 1'b1;	end
		else if(x==41 && y==30) begin	plot <= 1'b1;	end
		else if(x==42 && y==30) begin	plot <= 1'b1;	end
		else if(x==43 && y==30) begin	plot <= 1'b1;	end
		else if(x==44 && y==30) begin	plot <= 1'b1;	end
		else if(x==45 && y==30) begin	plot <= 1'b1;	end
		else if(x==46 && y==30) begin	plot <= 1'b1;	end
		else if(x==47 && y==30) begin	plot <= 1'b1;	end
		else if(x==48 && y==30) begin	plot <= 1'b1;	end
		else if(x==49 && y==30) begin	plot <= 1'b1;	end
		else if(x==50 && y==30) begin	plot <= 1'b1;	end
		else if(x==51 && y==30) begin	plot <= 1'b1;	end
		else if(x==52 && y==30) begin	plot <= 1'b1;	end
		else if(x==53 && y==30) begin	plot <= 1'b1;	end
		else if(x==54 && y==30) begin	plot <= 1'b1;	end
		else if(x==55 && y==30) begin	plot <= 1'b1;	end
		else if(x==56 && y==30) begin	plot <= 1'b1;	end
		else if(x==57 && y==30) begin	plot <= 1'b1;	end
		else if(x==58 && y==30) begin	plot <= 1'b1;	end
		else if(x==59 && y==30) begin	plot <= 1'b1;	end
		else if(x==62 && y==30) begin	plot <= 1'b1;	end
		else if(x==63 && y==30) begin	plot <= 1'b1;	end
		else if(x==64 && y==30) begin	plot <= 1'b1;	end
		else if(x==26 && y==31) begin	plot <= 1'b1;	end
		else if(x==27 && y==31) begin	plot <= 1'b1;	end
		else if(x==28 && y==31) begin	plot <= 1'b1;	end
		else if(x==29 && y==31) begin	plot <= 1'b1;	end
		else if(x==30 && y==31) begin	plot <= 1'b1;	end
		else if(x==31 && y==31) begin	plot <= 1'b1;	end
		else if(x==32 && y==31) begin	plot <= 1'b1;	end
		else if(x==33 && y==31) begin	plot <= 1'b1;	end
		else if(x==34 && y==31) begin	plot <= 1'b1;	end
		else if(x==35 && y==31) begin	plot <= 1'b1;	end
		else if(x==36 && y==31) begin	plot <= 1'b1;	end
		else if(x==37 && y==31) begin	plot <= 1'b1;	end
		else if(x==38 && y==31) begin	plot <= 1'b1;	end
		else if(x==39 && y==31) begin	plot <= 1'b1;	end
		else if(x==40 && y==31) begin	plot <= 1'b1;	end
		else if(x==41 && y==31) begin	plot <= 1'b1;	end
		else if(x==42 && y==31) begin	plot <= 1'b1;	end
		else if(x==43 && y==31) begin	plot <= 1'b1;	end
		else if(x==44 && y==31) begin	plot <= 1'b1;	end
		else if(x==45 && y==31) begin	plot <= 1'b1;	end
		else if(x==46 && y==31) begin	plot <= 1'b1;	end
		else if(x==47 && y==31) begin	plot <= 1'b1;	end
		else if(x==48 && y==31) begin	plot <= 1'b1;	end
		else if(x==49 && y==31) begin	plot <= 1'b1;	end
		else if(x==50 && y==31) begin	plot <= 1'b1;	end
		else if(x==51 && y==31) begin	plot <= 1'b1;	end
		else if(x==52 && y==31) begin	plot <= 1'b1;	end
		else if(x==53 && y==31) begin	plot <= 1'b1;	end
		else if(x==54 && y==31) begin	plot <= 1'b1;	end
		else if(x==55 && y==31) begin	plot <= 1'b1;	end
		else if(x==56 && y==31) begin	plot <= 1'b1;	end
		else if(x==57 && y==31) begin	plot <= 1'b1;	end
		else if(x==58 && y==31) begin	plot <= 1'b1;	end
		else if(x==59 && y==31) begin	plot <= 1'b1;	end
		else if(x==25 && y==32) begin	plot <= 1'b1;	end
		else if(x==26 && y==32) begin	plot <= 1'b1;	end
		else if(x==27 && y==32) begin	plot <= 1'b1;	end
		else if(x==28 && y==32) begin	plot <= 1'b1;	end
		else if(x==29 && y==32) begin	plot <= 1'b1;	end
		else if(x==30 && y==32) begin	plot <= 1'b1;	end
		else if(x==31 && y==32) begin	plot <= 1'b1;	end
		else if(x==32 && y==32) begin	plot <= 1'b1;	end
		else if(x==33 && y==32) begin	plot <= 1'b1;	end
		else if(x==34 && y==32) begin	plot <= 1'b1;	end
		else if(x==35 && y==32) begin	plot <= 1'b1;	end
		else if(x==36 && y==32) begin	plot <= 1'b1;	end
		else if(x==37 && y==32) begin	plot <= 1'b1;	end
		else if(x==38 && y==32) begin	plot <= 1'b1;	end
		else if(x==39 && y==32) begin	plot <= 1'b1;	end
		else if(x==40 && y==32) begin	plot <= 1'b1;	end
		else if(x==41 && y==32) begin	plot <= 1'b1;	end
		else if(x==42 && y==32) begin	plot <= 1'b1;	end
		else if(x==43 && y==32) begin	plot <= 1'b1;	end
		else if(x==44 && y==32) begin	plot <= 1'b1;	end
		else if(x==45 && y==32) begin	plot <= 1'b1;	end
		else if(x==46 && y==32) begin	plot <= 1'b1;	end
		else if(x==47 && y==32) begin	plot <= 1'b1;	end
		else if(x==48 && y==32) begin	plot <= 1'b1;	end
		else if(x==49 && y==32) begin	plot <= 1'b1;	end
		else if(x==50 && y==32) begin	plot <= 1'b1;	end
		else if(x==51 && y==32) begin	plot <= 1'b1;	end
		else if(x==52 && y==32) begin	plot <= 1'b1;	end
		else if(x==53 && y==32) begin	plot <= 1'b1;	end
		else if(x==54 && y==32) begin	plot <= 1'b1;	end
		else if(x==55 && y==32) begin	plot <= 1'b1;	end
		else if(x==56 && y==32) begin	plot <= 1'b1;	end
		else if(x==57 && y==32) begin	plot <= 1'b1;	end
		else if(x==58 && y==32) begin	plot <= 1'b1;	end
		else if(x==59 && y==32) begin	plot <= 1'b1;	end
		else if(x==24 && y==33) begin	plot <= 1'b1;	end
		else if(x==25 && y==33) begin	plot <= 1'b1;	end
		else if(x==26 && y==33) begin	plot <= 1'b1;	end
		else if(x==27 && y==33) begin	plot <= 1'b1;	end
		else if(x==28 && y==33) begin	plot <= 1'b1;	end
		else if(x==29 && y==33) begin	plot <= 1'b1;	end
		else if(x==30 && y==33) begin	plot <= 1'b1;	end
		else if(x==31 && y==33) begin	plot <= 1'b1;	end
		else if(x==32 && y==33) begin	plot <= 1'b1;	end
		else if(x==33 && y==33) begin	plot <= 1'b1;	end
		else if(x==34 && y==33) begin	plot <= 1'b1;	end
		else if(x==35 && y==33) begin	plot <= 1'b1;	end
		else if(x==36 && y==33) begin	plot <= 1'b1;	end
		else if(x==37 && y==33) begin	plot <= 1'b1;	end
		else if(x==38 && y==33) begin	plot <= 1'b1;	end
		else if(x==39 && y==33) begin	plot <= 1'b1;	end
		else if(x==40 && y==33) begin	plot <= 1'b1;	end
		else if(x==41 && y==33) begin	plot <= 1'b1;	end
		else if(x==42 && y==33) begin	plot <= 1'b1;	end
		else if(x==43 && y==33) begin	plot <= 1'b1;	end
		else if(x==44 && y==33) begin	plot <= 1'b1;	end
		else if(x==45 && y==33) begin	plot <= 1'b1;	end
		else if(x==46 && y==33) begin	plot <= 1'b1;	end
		else if(x==47 && y==33) begin	plot <= 1'b1;	end
		else if(x==48 && y==33) begin	plot <= 1'b1;	end
		else if(x==49 && y==33) begin	plot <= 1'b1;	end
		else if(x==50 && y==33) begin	plot <= 1'b1;	end
		else if(x==51 && y==33) begin	plot <= 1'b1;	end
		else if(x==52 && y==33) begin	plot <= 1'b1;	end
		else if(x==53 && y==33) begin	plot <= 1'b1;	end
		else if(x==54 && y==33) begin	plot <= 1'b1;	end
		else if(x==55 && y==33) begin	plot <= 1'b1;	end
		else if(x==56 && y==33) begin	plot <= 1'b1;	end
		else if(x==57 && y==33) begin	plot <= 1'b1;	end
		else if(x==58 && y==33) begin	plot <= 1'b1;	end
		else if(x==59 && y==33) begin	plot <= 1'b1;	end
		else if(x==60 && y==33) begin	plot <= 1'b1;	end
		else if(x==61 && y==33) begin	plot <= 1'b1;	end
		else if(x==62 && y==33) begin	plot <= 1'b1;	end
		else if(x==24 && y==34) begin	plot <= 1'b1;	end
		else if(x==25 && y==34) begin	plot <= 1'b1;	end
		else if(x==26 && y==34) begin	plot <= 1'b1;	end
		else if(x==27 && y==34) begin	plot <= 1'b1;	end
		else if(x==28 && y==34) begin	plot <= 1'b1;	end
		else if(x==29 && y==34) begin	plot <= 1'b1;	end
		else if(x==30 && y==34) begin	plot <= 1'b1;	end
		else if(x==31 && y==34) begin	plot <= 1'b1;	end
		else if(x==32 && y==34) begin	plot <= 1'b1;	end
		else if(x==33 && y==34) begin	plot <= 1'b1;	end
		else if(x==34 && y==34) begin	plot <= 1'b1;	end
		else if(x==35 && y==34) begin	plot <= 1'b1;	end
		else if(x==36 && y==34) begin	plot <= 1'b1;	end
		else if(x==37 && y==34) begin	plot <= 1'b1;	end
		else if(x==38 && y==34) begin	plot <= 1'b1;	end
		else if(x==39 && y==34) begin	plot <= 1'b1;	end
		else if(x==40 && y==34) begin	plot <= 1'b1;	end
		else if(x==41 && y==34) begin	plot <= 1'b1;	end
		else if(x==42 && y==34) begin	plot <= 1'b1;	end
		else if(x==43 && y==34) begin	plot <= 1'b1;	end
		else if(x==44 && y==34) begin	plot <= 1'b1;	end
		else if(x==45 && y==34) begin	plot <= 1'b1;	end
		else if(x==46 && y==34) begin	plot <= 1'b1;	end
		else if(x==47 && y==34) begin	plot <= 1'b1;	end
		else if(x==48 && y==34) begin	plot <= 1'b1;	end
		else if(x==49 && y==34) begin	plot <= 1'b1;	end
		else if(x==50 && y==34) begin	plot <= 1'b1;	end
		else if(x==51 && y==34) begin	plot <= 1'b1;	end
		else if(x==52 && y==34) begin	plot <= 1'b1;	end
		else if(x==53 && y==34) begin	plot <= 1'b1;	end
		else if(x==54 && y==34) begin	plot <= 1'b1;	end
		else if(x==55 && y==34) begin	plot <= 1'b1;	end
		else if(x==56 && y==34) begin	plot <= 1'b1;	end
		else if(x==57 && y==34) begin	plot <= 1'b1;	end
		else if(x==58 && y==34) begin	plot <= 1'b1;	end
		else if(x==59 && y==34) begin	plot <= 1'b1;	end
		else if(x==60 && y==34) begin	plot <= 1'b1;	end
		else if(x==61 && y==34) begin	plot <= 1'b1;	end
		else if(x==62 && y==34) begin	plot <= 1'b1;	end
		else if(x==63 && y==34) begin	plot <= 1'b1;	end
		else if(x==24 && y==35) begin	plot <= 1'b1;	end
		else if(x==25 && y==35) begin	plot <= 1'b1;	end
		else if(x==26 && y==35) begin	plot <= 1'b1;	end
		else if(x==27 && y==35) begin	plot <= 1'b1;	end
		else if(x==28 && y==35) begin	plot <= 1'b1;	end
		else if(x==29 && y==35) begin	plot <= 1'b1;	end
		else if(x==30 && y==35) begin	plot <= 1'b1;	end
		else if(x==31 && y==35) begin	plot <= 1'b1;	end
		else if(x==32 && y==35) begin	plot <= 1'b1;	end
		else if(x==33 && y==35) begin	plot <= 1'b1;	end
		else if(x==34 && y==35) begin	plot <= 1'b1;	end
		else if(x==35 && y==35) begin	plot <= 1'b1;	end
		else if(x==36 && y==35) begin	plot <= 1'b1;	end
		else if(x==37 && y==35) begin	plot <= 1'b1;	end
		else if(x==38 && y==35) begin	plot <= 1'b1;	end
		else if(x==39 && y==35) begin	plot <= 1'b1;	end
		else if(x==40 && y==35) begin	plot <= 1'b1;	end
		else if(x==41 && y==35) begin	plot <= 1'b1;	end
		else if(x==42 && y==35) begin	plot <= 1'b1;	end
		else if(x==43 && y==35) begin	plot <= 1'b1;	end
		else if(x==44 && y==35) begin	plot <= 1'b1;	end
		else if(x==45 && y==35) begin	plot <= 1'b1;	end
		else if(x==46 && y==35) begin	plot <= 1'b1;	end
		else if(x==47 && y==35) begin	plot <= 1'b1;	end
		else if(x==48 && y==35) begin	plot <= 1'b1;	end
		else if(x==49 && y==35) begin	plot <= 1'b1;	end
		else if(x==50 && y==35) begin	plot <= 1'b1;	end
		else if(x==51 && y==35) begin	plot <= 1'b1;	end
		else if(x==52 && y==35) begin	plot <= 1'b1;	end
		else if(x==53 && y==35) begin	plot <= 1'b1;	end
		else if(x==54 && y==35) begin	plot <= 1'b1;	end
		else if(x==55 && y==35) begin	plot <= 1'b1;	end
		else if(x==56 && y==35) begin	plot <= 1'b1;	end
		else if(x==57 && y==35) begin	plot <= 1'b1;	end
		else if(x==58 && y==35) begin	plot <= 1'b1;	end
		else if(x==59 && y==35) begin	plot <= 1'b1;	end
		else if(x==60 && y==35) begin	plot <= 1'b1;	end
		else if(x==61 && y==35) begin	plot <= 1'b1;	end
		else if(x==62 && y==35) begin	plot <= 1'b1;	end
		else if(x==63 && y==35) begin	plot <= 1'b1;	end
		else if(x==64 && y==35) begin	plot <= 1'b1;	end
		else if(x==24 && y==36) begin	plot <= 1'b1;	end
		else if(x==25 && y==36) begin	plot <= 1'b1;	end
		else if(x==26 && y==36) begin	plot <= 1'b1;	end
		else if(x==27 && y==36) begin	plot <= 1'b1;	end
		else if(x==28 && y==36) begin	plot <= 1'b1;	end
		else if(x==29 && y==36) begin	plot <= 1'b1;	end
		else if(x==30 && y==36) begin	plot <= 1'b1;	end
		else if(x==31 && y==36) begin	plot <= 1'b1;	end
		else if(x==32 && y==36) begin	plot <= 1'b1;	end
		else if(x==33 && y==36) begin	plot <= 1'b1;	end
		else if(x==34 && y==36) begin	plot <= 1'b1;	end
		else if(x==35 && y==36) begin	plot <= 1'b1;	end
		else if(x==36 && y==36) begin	plot <= 1'b1;	end
		else if(x==37 && y==36) begin	plot <= 1'b1;	end
		else if(x==38 && y==36) begin	plot <= 1'b1;	end
		else if(x==39 && y==36) begin	plot <= 1'b1;	end
		else if(x==40 && y==36) begin	plot <= 1'b1;	end
		else if(x==41 && y==36) begin	plot <= 1'b1;	end
		else if(x==42 && y==36) begin	plot <= 1'b1;	end
		else if(x==43 && y==36) begin	plot <= 1'b1;	end
		else if(x==44 && y==36) begin	plot <= 1'b1;	end
		else if(x==45 && y==36) begin	plot <= 1'b1;	end
		else if(x==46 && y==36) begin	plot <= 1'b1;	end
		else if(x==47 && y==36) begin	plot <= 1'b1;	end
		else if(x==48 && y==36) begin	plot <= 1'b1;	end
		else if(x==49 && y==36) begin	plot <= 1'b1;	end
		else if(x==50 && y==36) begin	plot <= 1'b1;	end
		else if(x==51 && y==36) begin	plot <= 1'b1;	end
		else if(x==52 && y==36) begin	plot <= 1'b1;	end
		else if(x==53 && y==36) begin	plot <= 1'b1;	end
		else if(x==54 && y==36) begin	plot <= 1'b1;	end
		else if(x==55 && y==36) begin	plot <= 1'b1;	end
		else if(x==56 && y==36) begin	plot <= 1'b1;	end
		else if(x==57 && y==36) begin	plot <= 1'b1;	end
		else if(x==58 && y==36) begin	plot <= 1'b1;	end
		else if(x==59 && y==36) begin	plot <= 1'b1;	end
		else if(x==60 && y==36) begin	plot <= 1'b1;	end
		else if(x==61 && y==36) begin	plot <= 1'b1;	end
		else if(x==62 && y==36) begin	plot <= 1'b1;	end
		else if(x==63 && y==36) begin	plot <= 1'b1;	end
		else if(x==64 && y==36) begin	plot <= 1'b1;	end
		else if(x==23 && y==37) begin	plot <= 1'b1;	end
		else if(x==24 && y==37) begin	plot <= 1'b1;	end
		else if(x==25 && y==37) begin	plot <= 1'b1;	end
		else if(x==26 && y==37) begin	plot <= 1'b1;	end
		else if(x==27 && y==37) begin	plot <= 1'b1;	end
		else if(x==28 && y==37) begin	plot <= 1'b1;	end
		else if(x==29 && y==37) begin	plot <= 1'b1;	end
		else if(x==30 && y==37) begin	plot <= 1'b1;	end
		else if(x==31 && y==37) begin	plot <= 1'b1;	end
		else if(x==32 && y==37) begin	plot <= 1'b1;	end
		else if(x==33 && y==37) begin	plot <= 1'b1;	end
		else if(x==34 && y==37) begin	plot <= 1'b1;	end
		else if(x==35 && y==37) begin	plot <= 1'b1;	end
		else if(x==36 && y==37) begin	plot <= 1'b1;	end
		else if(x==37 && y==37) begin	plot <= 1'b1;	end
		else if(x==38 && y==37) begin	plot <= 1'b1;	end
		else if(x==39 && y==37) begin	plot <= 1'b1;	end
		else if(x==40 && y==37) begin	plot <= 1'b1;	end
		else if(x==41 && y==37) begin	plot <= 1'b1;	end
		else if(x==42 && y==37) begin	plot <= 1'b1;	end
		else if(x==43 && y==37) begin	plot <= 1'b1;	end
		else if(x==44 && y==37) begin	plot <= 1'b1;	end
		else if(x==45 && y==37) begin	plot <= 1'b1;	end
		else if(x==46 && y==37) begin	plot <= 1'b1;	end
		else if(x==47 && y==37) begin	plot <= 1'b1;	end
		else if(x==48 && y==37) begin	plot <= 1'b1;	end
		else if(x==49 && y==37) begin	plot <= 1'b1;	end
		else if(x==50 && y==37) begin	plot <= 1'b1;	end
		else if(x==51 && y==37) begin	plot <= 1'b1;	end
		else if(x==52 && y==37) begin	plot <= 1'b1;	end
		else if(x==53 && y==37) begin	plot <= 1'b1;	end
		else if(x==54 && y==37) begin	plot <= 1'b1;	end
		else if(x==55 && y==37) begin	plot <= 1'b1;	end
		else if(x==56 && y==37) begin	plot <= 1'b1;	end
		else if(x==57 && y==37) begin	plot <= 1'b1;	end
		else if(x==58 && y==37) begin	plot <= 1'b1;	end
		else if(x==59 && y==37) begin	plot <= 1'b1;	end
		else if(x==60 && y==37) begin	plot <= 1'b1;	end
		else if(x==61 && y==37) begin	plot <= 1'b1;	end
		else if(x==62 && y==37) begin	plot <= 1'b1;	end
		else if(x==63 && y==37) begin	plot <= 1'b1;	end
		else if(x==64 && y==37) begin	plot <= 1'b1;	end
		else if(x==15 && y==38) begin	plot <= 1'b1;	end
		else if(x==16 && y==38) begin	plot <= 1'b1;	end
		else if(x==17 && y==38) begin	plot <= 1'b1;	end
		else if(x==23 && y==38) begin	plot <= 1'b1;	end
		else if(x==24 && y==38) begin	plot <= 1'b1;	end
		else if(x==25 && y==38) begin	plot <= 1'b1;	end
		else if(x==26 && y==38) begin	plot <= 1'b1;	end
		else if(x==27 && y==38) begin	plot <= 1'b1;	end
		else if(x==28 && y==38) begin	plot <= 1'b1;	end
		else if(x==29 && y==38) begin	plot <= 1'b1;	end
		else if(x==30 && y==38) begin	plot <= 1'b1;	end
		else if(x==31 && y==38) begin	plot <= 1'b1;	end
		else if(x==32 && y==38) begin	plot <= 1'b1;	end
		else if(x==33 && y==38) begin	plot <= 1'b1;	end
		else if(x==34 && y==38) begin	plot <= 1'b1;	end
		else if(x==35 && y==38) begin	plot <= 1'b1;	end
		else if(x==36 && y==38) begin	plot <= 1'b1;	end
		else if(x==37 && y==38) begin	plot <= 1'b1;	end
		else if(x==38 && y==38) begin	plot <= 1'b1;	end
		else if(x==39 && y==38) begin	plot <= 1'b1;	end
		else if(x==40 && y==38) begin	plot <= 1'b1;	end
		else if(x==41 && y==38) begin	plot <= 1'b1;	end
		else if(x==42 && y==38) begin	plot <= 1'b1;	end
		else if(x==43 && y==38) begin	plot <= 1'b1;	end
		else if(x==44 && y==38) begin	plot <= 1'b1;	end
		else if(x==45 && y==38) begin	plot <= 1'b1;	end
		else if(x==46 && y==38) begin	plot <= 1'b1;	end
		else if(x==47 && y==38) begin	plot <= 1'b1;	end
		else if(x==48 && y==38) begin	plot <= 1'b1;	end
		else if(x==49 && y==38) begin	plot <= 1'b1;	end
		else if(x==50 && y==38) begin	plot <= 1'b1;	end
		else if(x==51 && y==38) begin	plot <= 1'b1;	end
		else if(x==52 && y==38) begin	plot <= 1'b1;	end
		else if(x==53 && y==38) begin	plot <= 1'b1;	end
		else if(x==54 && y==38) begin	plot <= 1'b1;	end
		else if(x==55 && y==38) begin	plot <= 1'b1;	end
		else if(x==56 && y==38) begin	plot <= 1'b1;	end
		else if(x==57 && y==38) begin	plot <= 1'b1;	end
		else if(x==58 && y==38) begin	plot <= 1'b1;	end
		else if(x==59 && y==38) begin	plot <= 1'b1;	end
		else if(x==60 && y==38) begin	plot <= 1'b1;	end
		else if(x==61 && y==38) begin	plot <= 1'b1;	end
		else if(x==62 && y==38) begin	plot <= 1'b1;	end
		else if(x==63 && y==38) begin	plot <= 1'b1;	end
		else if(x==64 && y==38) begin	plot <= 1'b1;	end
		else if(x==15 && y==39) begin	plot <= 1'b1;	end
		else if(x==16 && y==39) begin	plot <= 1'b1;	end
		else if(x==17 && y==39) begin	plot <= 1'b1;	end
		else if(x==23 && y==39) begin	plot <= 1'b1;	end
		else if(x==24 && y==39) begin	plot <= 1'b1;	end
		else if(x==25 && y==39) begin	plot <= 1'b1;	end
		else if(x==26 && y==39) begin	plot <= 1'b1;	end
		else if(x==27 && y==39) begin	plot <= 1'b1;	end
		else if(x==28 && y==39) begin	plot <= 1'b1;	end
		else if(x==29 && y==39) begin	plot <= 1'b1;	end
		else if(x==30 && y==39) begin	plot <= 1'b1;	end
		else if(x==31 && y==39) begin	plot <= 1'b1;	end
		else if(x==32 && y==39) begin	plot <= 1'b1;	end
		else if(x==33 && y==39) begin	plot <= 1'b1;	end
		else if(x==34 && y==39) begin	plot <= 1'b1;	end
		else if(x==35 && y==39) begin	plot <= 1'b1;	end
		else if(x==36 && y==39) begin	plot <= 1'b1;	end
		else if(x==37 && y==39) begin	plot <= 1'b1;	end
		else if(x==38 && y==39) begin	plot <= 1'b1;	end
		else if(x==39 && y==39) begin	plot <= 1'b1;	end
		else if(x==40 && y==39) begin	plot <= 1'b1;	end
		else if(x==41 && y==39) begin	plot <= 1'b1;	end
		else if(x==42 && y==39) begin	plot <= 1'b1;	end
		else if(x==43 && y==39) begin	plot <= 1'b1;	end
		else if(x==44 && y==39) begin	plot <= 1'b1;	end
		else if(x==45 && y==39) begin	plot <= 1'b1;	end
		else if(x==46 && y==39) begin	plot <= 1'b1;	end
		else if(x==47 && y==39) begin	plot <= 1'b1;	end
		else if(x==48 && y==39) begin	plot <= 1'b1;	end
		else if(x==49 && y==39) begin	plot <= 1'b1;	end
		else if(x==50 && y==39) begin	plot <= 1'b1;	end
		else if(x==51 && y==39) begin	plot <= 1'b1;	end
		else if(x==52 && y==39) begin	plot <= 1'b1;	end
		else if(x==53 && y==39) begin	plot <= 1'b1;	end
		else if(x==54 && y==39) begin	plot <= 1'b1;	end
		else if(x==55 && y==39) begin	plot <= 1'b1;	end
		else if(x==56 && y==39) begin	plot <= 1'b1;	end
		else if(x==57 && y==39) begin	plot <= 1'b1;	end
		else if(x==58 && y==39) begin	plot <= 1'b1;	end
		else if(x==59 && y==39) begin	plot <= 1'b1;	end
		else if(x==60 && y==39) begin	plot <= 1'b1;	end
		else if(x==61 && y==39) begin	plot <= 1'b1;	end
		else if(x==62 && y==39) begin	plot <= 1'b1;	end
		else if(x==63 && y==39) begin	plot <= 1'b1;	end
		else if(x==68 && y==39) begin	plot <= 1'b1;	end
		else if(x==74 && y==39) begin	plot <= 1'b1;	end
		else if(x==75 && y==39) begin	plot <= 1'b1;	end
		else if(x==76 && y==39) begin	plot <= 1'b1;	end
		else if(x==24 && y==40) begin	plot <= 1'b1;	end
		else if(x==25 && y==40) begin	plot <= 1'b1;	end
		else if(x==26 && y==40) begin	plot <= 1'b1;	end
		else if(x==27 && y==40) begin	plot <= 1'b1;	end
		else if(x==28 && y==40) begin	plot <= 1'b1;	end
		else if(x==29 && y==40) begin	plot <= 1'b1;	end
		else if(x==30 && y==40) begin	plot <= 1'b1;	end
		else if(x==31 && y==40) begin	plot <= 1'b1;	end
		else if(x==32 && y==40) begin	plot <= 1'b1;	end
		else if(x==33 && y==40) begin	plot <= 1'b1;	end
		else if(x==34 && y==40) begin	plot <= 1'b1;	end
		else if(x==35 && y==40) begin	plot <= 1'b1;	end
		else if(x==36 && y==40) begin	plot <= 1'b1;	end
		else if(x==37 && y==40) begin	plot <= 1'b1;	end
		else if(x==38 && y==40) begin	plot <= 1'b1;	end
		else if(x==39 && y==40) begin	plot <= 1'b1;	end
		else if(x==40 && y==40) begin	plot <= 1'b1;	end
		else if(x==41 && y==40) begin	plot <= 1'b1;	end
		else if(x==42 && y==40) begin	plot <= 1'b1;	end
		else if(x==43 && y==40) begin	plot <= 1'b1;	end
		else if(x==44 && y==40) begin	plot <= 1'b1;	end
		else if(x==45 && y==40) begin	plot <= 1'b1;	end
		else if(x==46 && y==40) begin	plot <= 1'b1;	end
		else if(x==47 && y==40) begin	plot <= 1'b1;	end
		else if(x==48 && y==40) begin	plot <= 1'b1;	end
		else if(x==49 && y==40) begin	plot <= 1'b1;	end
		else if(x==50 && y==40) begin	plot <= 1'b1;	end
		else if(x==51 && y==40) begin	plot <= 1'b1;	end
		else if(x==52 && y==40) begin	plot <= 1'b1;	end
		else if(x==53 && y==40) begin	plot <= 1'b1;	end
		else if(x==54 && y==40) begin	plot <= 1'b1;	end
		else if(x==55 && y==40) begin	plot <= 1'b1;	end
		else if(x==56 && y==40) begin	plot <= 1'b1;	end
		else if(x==57 && y==40) begin	plot <= 1'b1;	end
		else if(x==58 && y==40) begin	plot <= 1'b1;	end
		else if(x==59 && y==40) begin	plot <= 1'b1;	end
		else if(x==60 && y==40) begin	plot <= 1'b1;	end
		else if(x==61 && y==40) begin	plot <= 1'b1;	end
		else if(x==62 && y==40) begin	plot <= 1'b1;	end
		else if(x==63 && y==40) begin	plot <= 1'b1;	end
		else if(x==75 && y==40) begin	plot <= 1'b1;	end
		else if(x==76 && y==40) begin	plot <= 1'b1;	end
		else if(x==79 && y==40) begin	plot <= 1'b1;	end
		else if(x==24 && y==41) begin	plot <= 1'b1;	end
		else if(x==25 && y==41) begin	plot <= 1'b1;	end
		else if(x==26 && y==41) begin	plot <= 1'b1;	end
		else if(x==27 && y==41) begin	plot <= 1'b1;	end
		else if(x==28 && y==41) begin	plot <= 1'b1;	end
		else if(x==29 && y==41) begin	plot <= 1'b1;	end
		else if(x==30 && y==41) begin	plot <= 1'b1;	end
		else if(x==31 && y==41) begin	plot <= 1'b1;	end
		else if(x==32 && y==41) begin	plot <= 1'b1;	end
		else if(x==33 && y==41) begin	plot <= 1'b1;	end
		else if(x==34 && y==41) begin	plot <= 1'b1;	end
		else if(x==35 && y==41) begin	plot <= 1'b1;	end
		else if(x==36 && y==41) begin	plot <= 1'b1;	end
		else if(x==37 && y==41) begin	plot <= 1'b1;	end
		else if(x==38 && y==41) begin	plot <= 1'b1;	end
		else if(x==39 && y==41) begin	plot <= 1'b1;	end
		else if(x==40 && y==41) begin	plot <= 1'b1;	end
		else if(x==41 && y==41) begin	plot <= 1'b1;	end
		else if(x==42 && y==41) begin	plot <= 1'b1;	end
		else if(x==43 && y==41) begin	plot <= 1'b1;	end
		else if(x==44 && y==41) begin	plot <= 1'b1;	end
		else if(x==45 && y==41) begin	plot <= 1'b1;	end
		else if(x==46 && y==41) begin	plot <= 1'b1;	end
		else if(x==47 && y==41) begin	plot <= 1'b1;	end
		else if(x==48 && y==41) begin	plot <= 1'b1;	end
		else if(x==49 && y==41) begin	plot <= 1'b1;	end
		else if(x==50 && y==41) begin	plot <= 1'b1;	end
		else if(x==51 && y==41) begin	plot <= 1'b1;	end
		else if(x==52 && y==41) begin	plot <= 1'b1;	end
		else if(x==53 && y==41) begin	plot <= 1'b1;	end
		else if(x==54 && y==41) begin	plot <= 1'b1;	end
		else if(x==55 && y==41) begin	plot <= 1'b1;	end
		else if(x==56 && y==41) begin	plot <= 1'b1;	end
		else if(x==57 && y==41) begin	plot <= 1'b1;	end
		else if(x==58 && y==41) begin	plot <= 1'b1;	end
		else if(x==59 && y==41) begin	plot <= 1'b1;	end
		else if(x==60 && y==41) begin	plot <= 1'b1;	end
		else if(x==61 && y==41) begin	plot <= 1'b1;	end
		else if(x==62 && y==41) begin	plot <= 1'b1;	end
		else if(x==24 && y==42) begin	plot <= 1'b1;	end
		else if(x==25 && y==42) begin	plot <= 1'b1;	end
		else if(x==26 && y==42) begin	plot <= 1'b1;	end
		else if(x==27 && y==42) begin	plot <= 1'b1;	end
		else if(x==28 && y==42) begin	plot <= 1'b1;	end
		else if(x==29 && y==42) begin	plot <= 1'b1;	end
		else if(x==30 && y==42) begin	plot <= 1'b1;	end
		else if(x==31 && y==42) begin	plot <= 1'b1;	end
		else if(x==32 && y==42) begin	plot <= 1'b1;	end
		else if(x==33 && y==42) begin	plot <= 1'b1;	end
		else if(x==34 && y==42) begin	plot <= 1'b1;	end
		else if(x==35 && y==42) begin	plot <= 1'b1;	end
		else if(x==36 && y==42) begin	plot <= 1'b1;	end
		else if(x==37 && y==42) begin	plot <= 1'b1;	end
		else if(x==38 && y==42) begin	plot <= 1'b1;	end
		else if(x==39 && y==42) begin	plot <= 1'b1;	end
		else if(x==40 && y==42) begin	plot <= 1'b1;	end
		else if(x==41 && y==42) begin	plot <= 1'b1;	end
		else if(x==42 && y==42) begin	plot <= 1'b1;	end
		else if(x==43 && y==42) begin	plot <= 1'b1;	end
		else if(x==44 && y==42) begin	plot <= 1'b1;	end
		else if(x==45 && y==42) begin	plot <= 1'b1;	end
		else if(x==46 && y==42) begin	plot <= 1'b1;	end
		else if(x==47 && y==42) begin	plot <= 1'b1;	end
		else if(x==48 && y==42) begin	plot <= 1'b1;	end
		else if(x==49 && y==42) begin	plot <= 1'b1;	end
		else if(x==50 && y==42) begin	plot <= 1'b1;	end
		else if(x==51 && y==42) begin	plot <= 1'b1;	end
		else if(x==52 && y==42) begin	plot <= 1'b1;	end
		else if(x==53 && y==42) begin	plot <= 1'b1;	end
		else if(x==54 && y==42) begin	plot <= 1'b1;	end
		else if(x==55 && y==42) begin	plot <= 1'b1;	end
		else if(x==56 && y==42) begin	plot <= 1'b1;	end
		else if(x==57 && y==42) begin	plot <= 1'b1;	end
		else if(x==58 && y==42) begin	plot <= 1'b1;	end
		else if(x==59 && y==42) begin	plot <= 1'b1;	end
		else if(x==60 && y==42) begin	plot <= 1'b1;	end
		else if(x==61 && y==42) begin	plot <= 1'b1;	end
		else if(x==24 && y==43) begin	plot <= 1'b1;	end
		else if(x==25 && y==43) begin	plot <= 1'b1;	end
		else if(x==26 && y==43) begin	plot <= 1'b1;	end
		else if(x==27 && y==43) begin	plot <= 1'b1;	end
		else if(x==28 && y==43) begin	plot <= 1'b1;	end
		else if(x==29 && y==43) begin	plot <= 1'b1;	end
		else if(x==30 && y==43) begin	plot <= 1'b1;	end
		else if(x==31 && y==43) begin	plot <= 1'b1;	end
		else if(x==32 && y==43) begin	plot <= 1'b1;	end
		else if(x==33 && y==43) begin	plot <= 1'b1;	end
		else if(x==34 && y==43) begin	plot <= 1'b1;	end
		else if(x==35 && y==43) begin	plot <= 1'b1;	end
		else if(x==36 && y==43) begin	plot <= 1'b1;	end
		else if(x==37 && y==43) begin	plot <= 1'b1;	end
		else if(x==38 && y==43) begin	plot <= 1'b1;	end
		else if(x==39 && y==43) begin	plot <= 1'b1;	end
		else if(x==40 && y==43) begin	plot <= 1'b1;	end
		else if(x==41 && y==43) begin	plot <= 1'b1;	end
		else if(x==42 && y==43) begin	plot <= 1'b1;	end
		else if(x==43 && y==43) begin	plot <= 1'b1;	end
		else if(x==44 && y==43) begin	plot <= 1'b1;	end
		else if(x==45 && y==43) begin	plot <= 1'b1;	end
		else if(x==46 && y==43) begin	plot <= 1'b1;	end
		else if(x==47 && y==43) begin	plot <= 1'b1;	end
		else if(x==48 && y==43) begin	plot <= 1'b1;	end
		else if(x==49 && y==43) begin	plot <= 1'b1;	end
		else if(x==50 && y==43) begin	plot <= 1'b1;	end
		else if(x==51 && y==43) begin	plot <= 1'b1;	end
		else if(x==52 && y==43) begin	plot <= 1'b1;	end
		else if(x==53 && y==43) begin	plot <= 1'b1;	end
		else if(x==54 && y==43) begin	plot <= 1'b1;	end
		else if(x==55 && y==43) begin	plot <= 1'b1;	end
		else if(x==56 && y==43) begin	plot <= 1'b1;	end
		else if(x==57 && y==43) begin	plot <= 1'b1;	end
		else if(x==58 && y==43) begin	plot <= 1'b1;	end
		else if(x==59 && y==43) begin	plot <= 1'b1;	end
		else if(x==60 && y==43) begin	plot <= 1'b1;	end
		else if(x==61 && y==43) begin	plot <= 1'b1;	end
		else if(x==62 && y==43) begin	plot <= 1'b1;	end
		else if(x==24 && y==44) begin	plot <= 1'b1;	end
		else if(x==25 && y==44) begin	plot <= 1'b1;	end
		else if(x==26 && y==44) begin	plot <= 1'b1;	end
		else if(x==27 && y==44) begin	plot <= 1'b1;	end
		else if(x==28 && y==44) begin	plot <= 1'b1;	end
		else if(x==29 && y==44) begin	plot <= 1'b1;	end
		else if(x==30 && y==44) begin	plot <= 1'b1;	end
		else if(x==31 && y==44) begin	plot <= 1'b1;	end
		else if(x==32 && y==44) begin	plot <= 1'b1;	end
		else if(x==33 && y==44) begin	plot <= 1'b1;	end
		else if(x==34 && y==44) begin	plot <= 1'b1;	end
		else if(x==35 && y==44) begin	plot <= 1'b1;	end
		else if(x==36 && y==44) begin	plot <= 1'b1;	end
		else if(x==37 && y==44) begin	plot <= 1'b1;	end
		else if(x==38 && y==44) begin	plot <= 1'b1;	end
		else if(x==39 && y==44) begin	plot <= 1'b1;	end
		else if(x==40 && y==44) begin	plot <= 1'b1;	end
		else if(x==41 && y==44) begin	plot <= 1'b1;	end
		else if(x==42 && y==44) begin	plot <= 1'b1;	end
		else if(x==43 && y==44) begin	plot <= 1'b1;	end
		else if(x==44 && y==44) begin	plot <= 1'b1;	end
		else if(x==45 && y==44) begin	plot <= 1'b1;	end
		else if(x==46 && y==44) begin	plot <= 1'b1;	end
		else if(x==47 && y==44) begin	plot <= 1'b1;	end
		else if(x==48 && y==44) begin	plot <= 1'b1;	end
		else if(x==49 && y==44) begin	plot <= 1'b1;	end
		else if(x==50 && y==44) begin	plot <= 1'b1;	end
		else if(x==51 && y==44) begin	plot <= 1'b1;	end
		else if(x==52 && y==44) begin	plot <= 1'b1;	end
		else if(x==53 && y==44) begin	plot <= 1'b1;	end
		else if(x==54 && y==44) begin	plot <= 1'b1;	end
		else if(x==55 && y==44) begin	plot <= 1'b1;	end
		else if(x==56 && y==44) begin	plot <= 1'b1;	end
		else if(x==57 && y==44) begin	plot <= 1'b1;	end
		else if(x==58 && y==44) begin	plot <= 1'b1;	end
		else if(x==59 && y==44) begin	plot <= 1'b1;	end
		else if(x==60 && y==44) begin	plot <= 1'b1;	end
		else if(x==61 && y==44) begin	plot <= 1'b1;	end
		else if(x==62 && y==44) begin	plot <= 1'b1;	end
		else if(x==63 && y==44) begin	plot <= 1'b1;	end
		else if(x==24 && y==45) begin	plot <= 1'b1;	end
		else if(x==25 && y==45) begin	plot <= 1'b1;	end
		else if(x==26 && y==45) begin	plot <= 1'b1;	end
		else if(x==27 && y==45) begin	plot <= 1'b1;	end
		else if(x==28 && y==45) begin	plot <= 1'b1;	end
		else if(x==29 && y==45) begin	plot <= 1'b1;	end
		else if(x==30 && y==45) begin	plot <= 1'b1;	end
		else if(x==31 && y==45) begin	plot <= 1'b1;	end
		else if(x==32 && y==45) begin	plot <= 1'b1;	end
		else if(x==33 && y==45) begin	plot <= 1'b1;	end
		else if(x==34 && y==45) begin	plot <= 1'b1;	end
		else if(x==35 && y==45) begin	plot <= 1'b1;	end
		else if(x==36 && y==45) begin	plot <= 1'b1;	end
		else if(x==37 && y==45) begin	plot <= 1'b1;	end
		else if(x==38 && y==45) begin	plot <= 1'b1;	end
		else if(x==39 && y==45) begin	plot <= 1'b1;	end
		else if(x==40 && y==45) begin	plot <= 1'b1;	end
		else if(x==41 && y==45) begin	plot <= 1'b1;	end
		else if(x==42 && y==45) begin	plot <= 1'b1;	end
		else if(x==43 && y==45) begin	plot <= 1'b1;	end
		else if(x==44 && y==45) begin	plot <= 1'b1;	end
		else if(x==45 && y==45) begin	plot <= 1'b1;	end
		else if(x==46 && y==45) begin	plot <= 1'b1;	end
		else if(x==47 && y==45) begin	plot <= 1'b1;	end
		else if(x==48 && y==45) begin	plot <= 1'b1;	end
		else if(x==49 && y==45) begin	plot <= 1'b1;	end
		else if(x==50 && y==45) begin	plot <= 1'b1;	end
		else if(x==51 && y==45) begin	plot <= 1'b1;	end
		else if(x==52 && y==45) begin	plot <= 1'b1;	end
		else if(x==53 && y==45) begin	plot <= 1'b1;	end
		else if(x==54 && y==45) begin	plot <= 1'b1;	end
		else if(x==55 && y==45) begin	plot <= 1'b1;	end
		else if(x==56 && y==45) begin	plot <= 1'b1;	end
		else if(x==57 && y==45) begin	plot <= 1'b1;	end
		else if(x==58 && y==45) begin	plot <= 1'b1;	end
		else if(x==59 && y==45) begin	plot <= 1'b1;	end
		else if(x==60 && y==45) begin	plot <= 1'b1;	end
		else if(x==61 && y==45) begin	plot <= 1'b1;	end
		else if(x==62 && y==45) begin	plot <= 1'b1;	end
		else if(x==63 && y==45) begin	plot <= 1'b1;	end
		else if(x==64 && y==45) begin	plot <= 1'b1;	end
		else if(x==24 && y==46) begin	plot <= 1'b1;	end
		else if(x==25 && y==46) begin	plot <= 1'b1;	end
		else if(x==26 && y==46) begin	plot <= 1'b1;	end
		else if(x==27 && y==46) begin	plot <= 1'b1;	end
		else if(x==28 && y==46) begin	plot <= 1'b1;	end
		else if(x==29 && y==46) begin	plot <= 1'b1;	end
		else if(x==30 && y==46) begin	plot <= 1'b1;	end
		else if(x==31 && y==46) begin	plot <= 1'b1;	end
		else if(x==32 && y==46) begin	plot <= 1'b1;	end
		else if(x==33 && y==46) begin	plot <= 1'b1;	end
		else if(x==34 && y==46) begin	plot <= 1'b1;	end
		else if(x==35 && y==46) begin	plot <= 1'b1;	end
		else if(x==36 && y==46) begin	plot <= 1'b1;	end
		else if(x==37 && y==46) begin	plot <= 1'b1;	end
		else if(x==38 && y==46) begin	plot <= 1'b1;	end
		else if(x==39 && y==46) begin	plot <= 1'b1;	end
		else if(x==40 && y==46) begin	plot <= 1'b1;	end
		else if(x==41 && y==46) begin	plot <= 1'b1;	end
		else if(x==42 && y==46) begin	plot <= 1'b1;	end
		else if(x==43 && y==46) begin	plot <= 1'b1;	end
		else if(x==44 && y==46) begin	plot <= 1'b1;	end
		else if(x==45 && y==46) begin	plot <= 1'b1;	end
		else if(x==46 && y==46) begin	plot <= 1'b1;	end
		else if(x==47 && y==46) begin	plot <= 1'b1;	end
		else if(x==48 && y==46) begin	plot <= 1'b1;	end
		else if(x==49 && y==46) begin	plot <= 1'b1;	end
		else if(x==50 && y==46) begin	plot <= 1'b1;	end
		else if(x==51 && y==46) begin	plot <= 1'b1;	end
		else if(x==52 && y==46) begin	plot <= 1'b1;	end
		else if(x==53 && y==46) begin	plot <= 1'b1;	end
		else if(x==54 && y==46) begin	plot <= 1'b1;	end
		else if(x==55 && y==46) begin	plot <= 1'b1;	end
		else if(x==56 && y==46) begin	plot <= 1'b1;	end
		else if(x==57 && y==46) begin	plot <= 1'b1;	end
		else if(x==58 && y==46) begin	plot <= 1'b1;	end
		else if(x==59 && y==46) begin	plot <= 1'b1;	end
		else if(x==60 && y==46) begin	plot <= 1'b1;	end
		else if(x==61 && y==46) begin	plot <= 1'b1;	end
		else if(x==62 && y==46) begin	plot <= 1'b1;	end
		else if(x==63 && y==46) begin	plot <= 1'b1;	end
		else if(x==64 && y==46) begin	plot <= 1'b1;	end
		else if(x==25 && y==47) begin	plot <= 1'b1;	end
		else if(x==26 && y==47) begin	plot <= 1'b1;	end
		else if(x==27 && y==47) begin	plot <= 1'b1;	end
		else if(x==28 && y==47) begin	plot <= 1'b1;	end
		else if(x==29 && y==47) begin	plot <= 1'b1;	end
		else if(x==30 && y==47) begin	plot <= 1'b1;	end
		else if(x==31 && y==47) begin	plot <= 1'b1;	end
		else if(x==32 && y==47) begin	plot <= 1'b1;	end
		else if(x==33 && y==47) begin	plot <= 1'b1;	end
		else if(x==34 && y==47) begin	plot <= 1'b1;	end
		else if(x==35 && y==47) begin	plot <= 1'b1;	end
		else if(x==36 && y==47) begin	plot <= 1'b1;	end
		else if(x==37 && y==47) begin	plot <= 1'b1;	end
		else if(x==38 && y==47) begin	plot <= 1'b1;	end
		else if(x==39 && y==47) begin	plot <= 1'b1;	end
		else if(x==40 && y==47) begin	plot <= 1'b1;	end
		else if(x==41 && y==47) begin	plot <= 1'b1;	end
		else if(x==42 && y==47) begin	plot <= 1'b1;	end
		else if(x==43 && y==47) begin	plot <= 1'b1;	end
		else if(x==44 && y==47) begin	plot <= 1'b1;	end
		else if(x==45 && y==47) begin	plot <= 1'b1;	end
		else if(x==46 && y==47) begin	plot <= 1'b1;	end
		else if(x==47 && y==47) begin	plot <= 1'b1;	end
		else if(x==48 && y==47) begin	plot <= 1'b1;	end
		else if(x==49 && y==47) begin	plot <= 1'b1;	end
		else if(x==50 && y==47) begin	plot <= 1'b1;	end
		else if(x==51 && y==47) begin	plot <= 1'b1;	end
		else if(x==52 && y==47) begin	plot <= 1'b1;	end
		else if(x==53 && y==47) begin	plot <= 1'b1;	end
		else if(x==54 && y==47) begin	plot <= 1'b1;	end
		else if(x==55 && y==47) begin	plot <= 1'b1;	end
		else if(x==56 && y==47) begin	plot <= 1'b1;	end
		else if(x==57 && y==47) begin	plot <= 1'b1;	end
		else if(x==58 && y==47) begin	plot <= 1'b1;	end
		else if(x==59 && y==47) begin	plot <= 1'b1;	end
		else if(x==60 && y==47) begin	plot <= 1'b1;	end
		else if(x==61 && y==47) begin	plot <= 1'b1;	end
		else if(x==62 && y==47) begin	plot <= 1'b1;	end
		else if(x==63 && y==47) begin	plot <= 1'b1;	end
		else if(x==64 && y==47) begin	plot <= 1'b1;	end
		else if(x==25 && y==48) begin	plot <= 1'b1;	end
		else if(x==26 && y==48) begin	plot <= 1'b1;	end
		else if(x==27 && y==48) begin	plot <= 1'b1;	end
		else if(x==28 && y==48) begin	plot <= 1'b1;	end
		else if(x==29 && y==48) begin	plot <= 1'b1;	end
		else if(x==30 && y==48) begin	plot <= 1'b1;	end
		else if(x==31 && y==48) begin	plot <= 1'b1;	end
		else if(x==32 && y==48) begin	plot <= 1'b1;	end
		else if(x==33 && y==48) begin	plot <= 1'b1;	end
		else if(x==34 && y==48) begin	plot <= 1'b1;	end
		else if(x==35 && y==48) begin	plot <= 1'b1;	end
		else if(x==36 && y==48) begin	plot <= 1'b1;	end
		else if(x==37 && y==48) begin	plot <= 1'b1;	end
		else if(x==38 && y==48) begin	plot <= 1'b1;	end
		else if(x==39 && y==48) begin	plot <= 1'b1;	end
		else if(x==40 && y==48) begin	plot <= 1'b1;	end
		else if(x==41 && y==48) begin	plot <= 1'b1;	end
		else if(x==42 && y==48) begin	plot <= 1'b1;	end
		else if(x==43 && y==48) begin	plot <= 1'b1;	end
		else if(x==44 && y==48) begin	plot <= 1'b1;	end
		else if(x==45 && y==48) begin	plot <= 1'b1;	end
		else if(x==46 && y==48) begin	plot <= 1'b1;	end
		else if(x==47 && y==48) begin	plot <= 1'b1;	end
		else if(x==48 && y==48) begin	plot <= 1'b1;	end
		else if(x==49 && y==48) begin	plot <= 1'b1;	end
		else if(x==50 && y==48) begin	plot <= 1'b1;	end
		else if(x==51 && y==48) begin	plot <= 1'b1;	end
		else if(x==52 && y==48) begin	plot <= 1'b1;	end
		else if(x==53 && y==48) begin	plot <= 1'b1;	end
		else if(x==54 && y==48) begin	plot <= 1'b1;	end
		else if(x==55 && y==48) begin	plot <= 1'b1;	end
		else if(x==56 && y==48) begin	plot <= 1'b1;	end
		else if(x==57 && y==48) begin	plot <= 1'b1;	end
		else if(x==58 && y==48) begin	plot <= 1'b1;	end
		else if(x==59 && y==48) begin	plot <= 1'b1;	end
		else if(x==60 && y==48) begin	plot <= 1'b1;	end
		else if(x==61 && y==48) begin	plot <= 1'b1;	end
		else if(x==62 && y==48) begin	plot <= 1'b1;	end
		else if(x==63 && y==48) begin	plot <= 1'b1;	end
		else if(x==25 && y==49) begin	plot <= 1'b1;	end
		else if(x==26 && y==49) begin	plot <= 1'b1;	end
		else if(x==27 && y==49) begin	plot <= 1'b1;	end
		else if(x==28 && y==49) begin	plot <= 1'b1;	end
		else if(x==29 && y==49) begin	plot <= 1'b1;	end
		else if(x==30 && y==49) begin	plot <= 1'b1;	end
		else if(x==31 && y==49) begin	plot <= 1'b1;	end
		else if(x==32 && y==49) begin	plot <= 1'b1;	end
		else if(x==33 && y==49) begin	plot <= 1'b1;	end
		else if(x==34 && y==49) begin	plot <= 1'b1;	end
		else if(x==35 && y==49) begin	plot <= 1'b1;	end
		else if(x==36 && y==49) begin	plot <= 1'b1;	end
		else if(x==37 && y==49) begin	plot <= 1'b1;	end
		else if(x==38 && y==49) begin	plot <= 1'b1;	end
		else if(x==39 && y==49) begin	plot <= 1'b1;	end
		else if(x==40 && y==49) begin	plot <= 1'b1;	end
		else if(x==41 && y==49) begin	plot <= 1'b1;	end
		else if(x==42 && y==49) begin	plot <= 1'b1;	end
		else if(x==43 && y==49) begin	plot <= 1'b1;	end
		else if(x==44 && y==49) begin	plot <= 1'b1;	end
		else if(x==45 && y==49) begin	plot <= 1'b1;	end
		else if(x==46 && y==49) begin	plot <= 1'b1;	end
		else if(x==47 && y==49) begin	plot <= 1'b1;	end
		else if(x==48 && y==49) begin	plot <= 1'b1;	end
		else if(x==49 && y==49) begin	plot <= 1'b1;	end
		else if(x==50 && y==49) begin	plot <= 1'b1;	end
		else if(x==51 && y==49) begin	plot <= 1'b1;	end
		else if(x==52 && y==49) begin	plot <= 1'b1;	end
		else if(x==53 && y==49) begin	plot <= 1'b1;	end
		else if(x==54 && y==49) begin	plot <= 1'b1;	end
		else if(x==55 && y==49) begin	plot <= 1'b1;	end
		else if(x==56 && y==49) begin	plot <= 1'b1;	end
		else if(x==57 && y==49) begin	plot <= 1'b1;	end
		else if(x==58 && y==49) begin	plot <= 1'b1;	end
		else if(x==59 && y==49) begin	plot <= 1'b1;	end
		else if(x==60 && y==49) begin	plot <= 1'b1;	end
		else if(x==61 && y==49) begin	plot <= 1'b1;	end
		else if(x==62 && y==49) begin	plot <= 1'b1;	end
		else if(x==25 && y==50) begin	plot <= 1'b1;	end
		else if(x==26 && y==50) begin	plot <= 1'b1;	end
		else if(x==27 && y==50) begin	plot <= 1'b1;	end
		else if(x==28 && y==50) begin	plot <= 1'b1;	end
		else if(x==29 && y==50) begin	plot <= 1'b1;	end
		else if(x==30 && y==50) begin	plot <= 1'b1;	end
		else if(x==31 && y==50) begin	plot <= 1'b1;	end
		else if(x==32 && y==50) begin	plot <= 1'b1;	end
		else if(x==33 && y==50) begin	plot <= 1'b1;	end
		else if(x==34 && y==50) begin	plot <= 1'b1;	end
		else if(x==35 && y==50) begin	plot <= 1'b1;	end
		else if(x==36 && y==50) begin	plot <= 1'b1;	end
		else if(x==37 && y==50) begin	plot <= 1'b1;	end
		else if(x==38 && y==50) begin	plot <= 1'b1;	end
		else if(x==39 && y==50) begin	plot <= 1'b1;	end
		else if(x==40 && y==50) begin	plot <= 1'b1;	end
		else if(x==41 && y==50) begin	plot <= 1'b1;	end
		else if(x==42 && y==50) begin	plot <= 1'b1;	end
		else if(x==43 && y==50) begin	plot <= 1'b1;	end
		else if(x==44 && y==50) begin	plot <= 1'b1;	end
		else if(x==45 && y==50) begin	plot <= 1'b1;	end
		else if(x==46 && y==50) begin	plot <= 1'b1;	end
		else if(x==47 && y==50) begin	plot <= 1'b1;	end
		else if(x==48 && y==50) begin	plot <= 1'b1;	end
		else if(x==49 && y==50) begin	plot <= 1'b1;	end
		else if(x==50 && y==50) begin	plot <= 1'b1;	end
		else if(x==51 && y==50) begin	plot <= 1'b1;	end
		else if(x==52 && y==50) begin	plot <= 1'b1;	end
		else if(x==53 && y==50) begin	plot <= 1'b1;	end
		else if(x==54 && y==50) begin	plot <= 1'b1;	end
		else if(x==55 && y==50) begin	plot <= 1'b1;	end
		else if(x==56 && y==50) begin	plot <= 1'b1;	end
		else if(x==57 && y==50) begin	plot <= 1'b1;	end
		else if(x==58 && y==50) begin	plot <= 1'b1;	end
		else if(x==59 && y==50) begin	plot <= 1'b1;	end
		else if(x==60 && y==50) begin	plot <= 1'b1;	end
		else if(x==61 && y==50) begin	plot <= 1'b1;	end
		else if(x==62 && y==50) begin	plot <= 1'b1;	end
		else if(x==25 && y==51) begin	plot <= 1'b1;	end
		else if(x==26 && y==51) begin	plot <= 1'b1;	end
		else if(x==27 && y==51) begin	plot <= 1'b1;	end
		else if(x==28 && y==51) begin	plot <= 1'b1;	end
		else if(x==29 && y==51) begin	plot <= 1'b1;	end
		else if(x==30 && y==51) begin	plot <= 1'b1;	end
		else if(x==31 && y==51) begin	plot <= 1'b1;	end
		else if(x==32 && y==51) begin	plot <= 1'b1;	end
		else if(x==33 && y==51) begin	plot <= 1'b1;	end
		else if(x==34 && y==51) begin	plot <= 1'b1;	end
		else if(x==35 && y==51) begin	plot <= 1'b1;	end
		else if(x==36 && y==51) begin	plot <= 1'b1;	end
		else if(x==37 && y==51) begin	plot <= 1'b1;	end
		else if(x==38 && y==51) begin	plot <= 1'b1;	end
		else if(x==39 && y==51) begin	plot <= 1'b1;	end
		else if(x==40 && y==51) begin	plot <= 1'b1;	end
		else if(x==41 && y==51) begin	plot <= 1'b1;	end
		else if(x==42 && y==51) begin	plot <= 1'b1;	end
		else if(x==43 && y==51) begin	plot <= 1'b1;	end
		else if(x==44 && y==51) begin	plot <= 1'b1;	end
		else if(x==45 && y==51) begin	plot <= 1'b1;	end
		else if(x==46 && y==51) begin	plot <= 1'b1;	end
		else if(x==47 && y==51) begin	plot <= 1'b1;	end
		else if(x==48 && y==51) begin	plot <= 1'b1;	end
		else if(x==49 && y==51) begin	plot <= 1'b1;	end
		else if(x==50 && y==51) begin	plot <= 1'b1;	end
		else if(x==51 && y==51) begin	plot <= 1'b1;	end
		else if(x==52 && y==51) begin	plot <= 1'b1;	end
		else if(x==53 && y==51) begin	plot <= 1'b1;	end
		else if(x==54 && y==51) begin	plot <= 1'b1;	end
		else if(x==55 && y==51) begin	plot <= 1'b1;	end
		else if(x==56 && y==51) begin	plot <= 1'b1;	end
		else if(x==57 && y==51) begin	plot <= 1'b1;	end
		else if(x==58 && y==51) begin	plot <= 1'b1;	end
		else if(x==59 && y==51) begin	plot <= 1'b1;	end
		else if(x==60 && y==51) begin	plot <= 1'b1;	end
		else if(x==61 && y==51) begin	plot <= 1'b1;	end
		else if(x==65 && y==51) begin	plot <= 1'b1;	end
		else if(x==66 && y==51) begin	plot <= 1'b1;	end
		else if(x==25 && y==52) begin	plot <= 1'b1;	end
		else if(x==26 && y==52) begin	plot <= 1'b1;	end
		else if(x==27 && y==52) begin	plot <= 1'b1;	end
		else if(x==28 && y==52) begin	plot <= 1'b1;	end
		else if(x==29 && y==52) begin	plot <= 1'b1;	end
		else if(x==30 && y==52) begin	plot <= 1'b1;	end
		else if(x==31 && y==52) begin	plot <= 1'b1;	end
		else if(x==32 && y==52) begin	plot <= 1'b1;	end
		else if(x==33 && y==52) begin	plot <= 1'b1;	end
		else if(x==34 && y==52) begin	plot <= 1'b1;	end
		else if(x==35 && y==52) begin	plot <= 1'b1;	end
		else if(x==36 && y==52) begin	plot <= 1'b1;	end
		else if(x==37 && y==52) begin	plot <= 1'b1;	end
		else if(x==38 && y==52) begin	plot <= 1'b1;	end
		else if(x==39 && y==52) begin	plot <= 1'b1;	end
		else if(x==40 && y==52) begin	plot <= 1'b1;	end
		else if(x==41 && y==52) begin	plot <= 1'b1;	end
		else if(x==42 && y==52) begin	plot <= 1'b1;	end
		else if(x==43 && y==52) begin	plot <= 1'b1;	end
		else if(x==44 && y==52) begin	plot <= 1'b1;	end
		else if(x==45 && y==52) begin	plot <= 1'b1;	end
		else if(x==46 && y==52) begin	plot <= 1'b1;	end
		else if(x==47 && y==52) begin	plot <= 1'b1;	end
		else if(x==48 && y==52) begin	plot <= 1'b1;	end
		else if(x==49 && y==52) begin	plot <= 1'b1;	end
		else if(x==50 && y==52) begin	plot <= 1'b1;	end
		else if(x==51 && y==52) begin	plot <= 1'b1;	end
		else if(x==52 && y==52) begin	plot <= 1'b1;	end
		else if(x==53 && y==52) begin	plot <= 1'b1;	end
		else if(x==54 && y==52) begin	plot <= 1'b1;	end
		else if(x==55 && y==52) begin	plot <= 1'b1;	end
		else if(x==56 && y==52) begin	plot <= 1'b1;	end
		else if(x==57 && y==52) begin	plot <= 1'b1;	end
		else if(x==58 && y==52) begin	plot <= 1'b1;	end
		else if(x==59 && y==52) begin	plot <= 1'b1;	end
		else if(x==60 && y==52) begin	plot <= 1'b1;	end
		else if(x==61 && y==52) begin	plot <= 1'b1;	end
		else if(x==26 && y==53) begin	plot <= 1'b1;	end
		else if(x==27 && y==53) begin	plot <= 1'b1;	end
		else if(x==28 && y==53) begin	plot <= 1'b1;	end
		else if(x==29 && y==53) begin	plot <= 1'b1;	end
		else if(x==30 && y==53) begin	plot <= 1'b1;	end
		else if(x==31 && y==53) begin	plot <= 1'b1;	end
		else if(x==32 && y==53) begin	plot <= 1'b1;	end
		else if(x==33 && y==53) begin	plot <= 1'b1;	end
		else if(x==34 && y==53) begin	plot <= 1'b1;	end
		else if(x==35 && y==53) begin	plot <= 1'b1;	end
		else if(x==36 && y==53) begin	plot <= 1'b1;	end
		else if(x==37 && y==53) begin	plot <= 1'b1;	end
		else if(x==38 && y==53) begin	plot <= 1'b1;	end
		else if(x==39 && y==53) begin	plot <= 1'b1;	end
		else if(x==40 && y==53) begin	plot <= 1'b1;	end
		else if(x==41 && y==53) begin	plot <= 1'b1;	end
		else if(x==42 && y==53) begin	plot <= 1'b1;	end
		else if(x==43 && y==53) begin	plot <= 1'b1;	end
		else if(x==44 && y==53) begin	plot <= 1'b1;	end
		else if(x==45 && y==53) begin	plot <= 1'b1;	end
		else if(x==46 && y==53) begin	plot <= 1'b1;	end
		else if(x==47 && y==53) begin	plot <= 1'b1;	end
		else if(x==48 && y==53) begin	plot <= 1'b1;	end
		else if(x==49 && y==53) begin	plot <= 1'b1;	end
		else if(x==50 && y==53) begin	plot <= 1'b1;	end
		else if(x==51 && y==53) begin	plot <= 1'b1;	end
		else if(x==52 && y==53) begin	plot <= 1'b1;	end
		else if(x==53 && y==53) begin	plot <= 1'b1;	end
		else if(x==54 && y==53) begin	plot <= 1'b1;	end
		else if(x==55 && y==53) begin	plot <= 1'b1;	end
		else if(x==56 && y==53) begin	plot <= 1'b1;	end
		else if(x==57 && y==53) begin	plot <= 1'b1;	end
		else if(x==58 && y==53) begin	plot <= 1'b1;	end
		else if(x==59 && y==53) begin	plot <= 1'b1;	end
		else if(x==60 && y==53) begin	plot <= 1'b1;	end
		else if(x==61 && y==53) begin	plot <= 1'b1;	end
		else if(x==29 && y==54) begin	plot <= 1'b1;	end
		else if(x==30 && y==54) begin	plot <= 1'b1;	end
		else if(x==31 && y==54) begin	plot <= 1'b1;	end
		else if(x==32 && y==54) begin	plot <= 1'b1;	end
		else if(x==33 && y==54) begin	plot <= 1'b1;	end
		else if(x==34 && y==54) begin	plot <= 1'b1;	end
		else if(x==35 && y==54) begin	plot <= 1'b1;	end
		else if(x==36 && y==54) begin	plot <= 1'b1;	end
		else if(x==37 && y==54) begin	plot <= 1'b1;	end
		else if(x==38 && y==54) begin	plot <= 1'b1;	end
		else if(x==39 && y==54) begin	plot <= 1'b1;	end
		else if(x==40 && y==54) begin	plot <= 1'b1;	end
		else if(x==41 && y==54) begin	plot <= 1'b1;	end
		else if(x==42 && y==54) begin	plot <= 1'b1;	end
		else if(x==43 && y==54) begin	plot <= 1'b1;	end
		else if(x==44 && y==54) begin	plot <= 1'b1;	end
		else if(x==45 && y==54) begin	plot <= 1'b1;	end
		else if(x==46 && y==54) begin	plot <= 1'b1;	end
		else if(x==47 && y==54) begin	plot <= 1'b1;	end
		else if(x==48 && y==54) begin	plot <= 1'b1;	end
		else if(x==49 && y==54) begin	plot <= 1'b1;	end
		else if(x==50 && y==54) begin	plot <= 1'b1;	end
		else if(x==51 && y==54) begin	plot <= 1'b1;	end
		else if(x==52 && y==54) begin	plot <= 1'b1;	end
		else if(x==53 && y==54) begin	plot <= 1'b1;	end
		else if(x==54 && y==54) begin	plot <= 1'b1;	end
		else if(x==55 && y==54) begin	plot <= 1'b1;	end
		else if(x==56 && y==54) begin	plot <= 1'b1;	end
		else if(x==57 && y==54) begin	plot <= 1'b1;	end
		else if(x==58 && y==54) begin	plot <= 1'b1;	end
		else if(x==59 && y==54) begin	plot <= 1'b1;	end
		else if(x==60 && y==54) begin	plot <= 1'b1;	end
		else if(x==31 && y==55) begin	plot <= 1'b1;	end
		else if(x==32 && y==55) begin	plot <= 1'b1;	end
		else if(x==33 && y==55) begin	plot <= 1'b1;	end
		else if(x==34 && y==55) begin	plot <= 1'b1;	end
		else if(x==35 && y==55) begin	plot <= 1'b1;	end
		else if(x==36 && y==55) begin	plot <= 1'b1;	end
		else if(x==37 && y==55) begin	plot <= 1'b1;	end
		else if(x==38 && y==55) begin	plot <= 1'b1;	end
		else if(x==39 && y==55) begin	plot <= 1'b1;	end
		else if(x==40 && y==55) begin	plot <= 1'b1;	end
		else if(x==41 && y==55) begin	plot <= 1'b1;	end
		else if(x==42 && y==55) begin	plot <= 1'b1;	end
		else if(x==43 && y==55) begin	plot <= 1'b1;	end
		else if(x==44 && y==55) begin	plot <= 1'b1;	end
		else if(x==45 && y==55) begin	plot <= 1'b1;	end
		else if(x==46 && y==55) begin	plot <= 1'b1;	end
		else if(x==47 && y==55) begin	plot <= 1'b1;	end
		else if(x==48 && y==55) begin	plot <= 1'b1;	end
		else if(x==49 && y==55) begin	plot <= 1'b1;	end
		else if(x==50 && y==55) begin	plot <= 1'b1;	end
		else if(x==51 && y==55) begin	plot <= 1'b1;	end
		else if(x==52 && y==55) begin	plot <= 1'b1;	end
		else if(x==53 && y==55) begin	plot <= 1'b1;	end
		else if(x==54 && y==55) begin	plot <= 1'b1;	end
		else if(x==56 && y==55) begin	plot <= 1'b1;	end
		else if(x==57 && y==55) begin	plot <= 1'b1;	end
		else if(x==58 && y==55) begin	plot <= 1'b1;	end
		else if(x==33 && y==56) begin	plot <= 1'b1;	end
		else if(x==34 && y==56) begin	plot <= 1'b1;	end
		else if(x==35 && y==56) begin	plot <= 1'b1;	end
		else if(x==36 && y==56) begin	plot <= 1'b1;	end
		else if(x==37 && y==56) begin	plot <= 1'b1;	end
		else if(x==38 && y==56) begin	plot <= 1'b1;	end
		else if(x==39 && y==56) begin	plot <= 1'b1;	end
		else if(x==40 && y==56) begin	plot <= 1'b1;	end
		else if(x==41 && y==56) begin	plot <= 1'b1;	end
		else if(x==42 && y==56) begin	plot <= 1'b1;	end
		else if(x==43 && y==56) begin	plot <= 1'b1;	end
		else if(x==44 && y==56) begin	plot <= 1'b1;	end
		else if(x==45 && y==56) begin	plot <= 1'b1;	end
		else if(x==46 && y==56) begin	plot <= 1'b1;	end
		else if(x==47 && y==56) begin	plot <= 1'b1;	end
		else if(x==48 && y==56) begin	plot <= 1'b1;	end
		else if(x==49 && y==56) begin	plot <= 1'b1;	end
		else if(x==50 && y==56) begin	plot <= 1'b1;	end
		else if(x==51 && y==56) begin	plot <= 1'b1;	end
		else if(x==52 && y==56) begin	plot <= 1'b1;	end
		else if(x==34 && y==57) begin	plot <= 1'b1;	end
		else if(x==35 && y==57) begin	plot <= 1'b1;	end
		else if(x==36 && y==57) begin	plot <= 1'b1;	end
		else if(x==37 && y==57) begin	plot <= 1'b1;	end
		else if(x==38 && y==57) begin	plot <= 1'b1;	end
		else if(x==39 && y==57) begin	plot <= 1'b1;	end
		else if(x==40 && y==57) begin	plot <= 1'b1;	end
		else if(x==41 && y==57) begin	plot <= 1'b1;	end
		else if(x==42 && y==57) begin	plot <= 1'b1;	end
		else if(x==43 && y==57) begin	plot <= 1'b1;	end
		else if(x==44 && y==57) begin	plot <= 1'b1;	end
		else if(x==45 && y==57) begin	plot <= 1'b1;	end
		else if(x==46 && y==57) begin	plot <= 1'b1;	end
		else if(x==47 && y==57) begin	plot <= 1'b1;	end
		else if(x==48 && y==57) begin	plot <= 1'b1;	end
		else if(x==49 && y==57) begin	plot <= 1'b1;	end
		else if(x==50 && y==57) begin	plot <= 1'b1;	end
		else if(x==51 && y==57) begin	plot <= 1'b1;	end
		else if(x==52 && y==57) begin	plot <= 1'b1;	end
		else if(x==35 && y==58) begin	plot <= 1'b1;	end
		else if(x==36 && y==58) begin	plot <= 1'b1;	end
		else if(x==37 && y==58) begin	plot <= 1'b1;	end
		else if(x==38 && y==58) begin	plot <= 1'b1;	end
		else if(x==39 && y==58) begin	plot <= 1'b1;	end
		else if(x==40 && y==58) begin	plot <= 1'b1;	end
		else if(x==41 && y==58) begin	plot <= 1'b1;	end
		else if(x==42 && y==58) begin	plot <= 1'b1;	end
		else if(x==43 && y==58) begin	plot <= 1'b1;	end
		else if(x==44 && y==58) begin	plot <= 1'b1;	end
		else if(x==45 && y==58) begin	plot <= 1'b1;	end
		else if(x==46 && y==58) begin	plot <= 1'b1;	end
		else if(x==47 && y==58) begin	plot <= 1'b1;	end
		else if(x==48 && y==58) begin	plot <= 1'b1;	end
		else if(x==49 && y==58) begin	plot <= 1'b1;	end
		else if(x==50 && y==58) begin	plot <= 1'b1;	end
		else if(x==51 && y==58) begin	plot <= 1'b1;	end
		else if(x==52 && y==58) begin	plot <= 1'b1;	end
		else if(x==59 && y==58) begin	plot <= 1'b1;	end
		else if(x==60 && y==58) begin	plot <= 1'b1;	end
		else if(x==29 && y==59) begin	plot <= 1'b1;	end
		else if(x==42 && y==59) begin	plot <= 1'b1;	end
		else if(x==43 && y==59) begin	plot <= 1'b1;	end
		else if(x==44 && y==59) begin	plot <= 1'b1;	end
		else if(x==45 && y==59) begin	plot <= 1'b1;	end
		else if(x==46 && y==59) begin	plot <= 1'b1;	end
		else if(x==47 && y==59) begin	plot <= 1'b1;	end
		else if(x==48 && y==59) begin	plot <= 1'b1;	end
		else if(x==49 && y==59) begin	plot <= 1'b1;	end
		else if(x==50 && y==59) begin	plot <= 1'b1;	end
		else if(x==51 && y==59) begin	plot <= 1'b1;	end
		else if(x==60 && y==59) begin	plot <= 1'b1;	end
		else if(x==61 && y==59) begin	plot <= 1'b1;	end
		else if(x==45 && y==60) begin	plot <= 1'b1;	end
		else if(x==46 && y==60) begin	plot <= 1'b1;	end
		else if(x==47 && y==60) begin	plot <= 1'b1;	end
		else if(x==48 && y==60) begin	plot <= 1'b1;	end
		else if(x==49 && y==60) begin	plot <= 1'b1;	end
		else if(x==50 && y==60) begin	plot <= 1'b1;	end
		else if(x==24 && y==63) begin	plot <= 1'b1;	end
		else if(x==25 && y==63) begin	plot <= 1'b1;	end
		else if(x==65 && y==63) begin	plot <= 1'b1;	end
		else if(x==66 && y==63) begin	plot <= 1'b1;	end
		else if(x==22 && y==64) begin	plot <= 1'b1;	end
		else if(x==66 && y==64) begin	plot <= 1'b1;	end
		else if(x==21 && y==65) begin	plot <= 1'b1;	end
		else if(x==22 && y==65) begin	plot <= 1'b1;	end
		else if(x==68 && y==65) begin	plot <= 1'b1;	end
		else if(x==20 && y==66) begin	plot <= 1'b1;	end
		else if(x==68 && y==66) begin	plot <= 1'b1;	end
		else if(x==69 && y==66) begin	plot <= 1'b1;	end
		else if(x==70 && y==66) begin	plot <= 1'b1;	end
		else if(x==70 && y==67) begin	plot <= 1'b1;	end
		else begin plot <= 1'b0; end// Width: 89, Height: 79
	end
endmodule

// module for plotting the end screen (you win)
module ywinn(
	input clk,
	input wire [9:0] characterPositionX,
	input wire [8:0] characterPositionY,
	input wire [9:0] drawingPositionX,
	input wire [8:0] drawingPositionY,
	output reg [2:0] plot
);
	reg [9:0] x;
	reg [9:0] y;
	initial begin
		x = 'd0;
		y = 'd0;
	end

	always @(posedge clk) begin
		x <= (drawingPositionX - characterPositionX + 161);
		y <= (drawingPositionY - characterPositionY + 121);
		if(x==103 && y==82) begin	plot <= 1'b1;	end
		else if(x==104 && y==82) begin	plot <= 1'b1;	end
		else if(x==105 && y==82) begin	plot <= 1'b1;	end
		else if(x==106 && y==82) begin	plot <= 1'b1;	end
		else if(x==111 && y==82) begin	plot <= 1'b1;	end
		else if(x==112 && y==82) begin	plot <= 1'b1;	end
		else if(x==113 && y==82) begin	plot <= 1'b1;	end
		else if(x==114 && y==82) begin	plot <= 1'b1;	end
		else if(x==115 && y==82) begin	plot <= 1'b1;	end
		else if(x==120 && y==82) begin	plot <= 1'b1;	end
		else if(x==121 && y==82) begin	plot <= 1'b1;	end
		else if(x==122 && y==82) begin	plot <= 1'b1;	end
		else if(x==123 && y==82) begin	plot <= 1'b1;	end
		else if(x==124 && y==82) begin	plot <= 1'b1;	end
		else if(x==125 && y==82) begin	plot <= 1'b1;	end
		else if(x==126 && y==82) begin	plot <= 1'b1;	end
		else if(x==127 && y==82) begin	plot <= 1'b1;	end
		else if(x==128 && y==82) begin	plot <= 1'b1;	end
		else if(x==133 && y==82) begin	plot <= 1'b1;	end
		else if(x==134 && y==82) begin	plot <= 1'b1;	end
		else if(x==135 && y==82) begin	plot <= 1'b1;	end
		else if(x==136 && y==82) begin	plot <= 1'b1;	end
		else if(x==141 && y==82) begin	plot <= 1'b1;	end
		else if(x==142 && y==82) begin	plot <= 1'b1;	end
		else if(x==143 && y==82) begin	plot <= 1'b1;	end
		else if(x==144 && y==82) begin	plot <= 1'b1;	end
		else if(x==145 && y==82) begin	plot <= 1'b1;	end
		else if(x==163 && y==82) begin	plot <= 1'b1;	end
		else if(x==164 && y==82) begin	plot <= 1'b1;	end
		else if(x==165 && y==82) begin	plot <= 1'b1;	end
		else if(x==166 && y==82) begin	plot <= 1'b1;	end
		else if(x==174 && y==82) begin	plot <= 1'b1;	end
		else if(x==175 && y==82) begin	plot <= 1'b1;	end
		else if(x==176 && y==82) begin	plot <= 1'b1;	end
		else if(x==177 && y==82) begin	plot <= 1'b1;	end
		else if(x==180 && y==82) begin	plot <= 1'b1;	end
		else if(x==181 && y==82) begin	plot <= 1'b1;	end
		else if(x==182 && y==82) begin	plot <= 1'b1;	end
		else if(x==183 && y==82) begin	plot <= 1'b1;	end
		else if(x==184 && y==82) begin	plot <= 1'b1;	end
		else if(x==185 && y==82) begin	plot <= 1'b1;	end
		else if(x==186 && y==82) begin	plot <= 1'b1;	end
		else if(x==187 && y==82) begin	plot <= 1'b1;	end
		else if(x==188 && y==82) begin	plot <= 1'b1;	end
		else if(x==189 && y==82) begin	plot <= 1'b1;	end
		else if(x==190 && y==82) begin	plot <= 1'b1;	end
		else if(x==191 && y==82) begin	plot <= 1'b1;	end
		else if(x==192 && y==82) begin	plot <= 1'b1;	end
		else if(x==195 && y==82) begin	plot <= 1'b1;	end
		else if(x==196 && y==82) begin	plot <= 1'b1;	end
		else if(x==197 && y==82) begin	plot <= 1'b1;	end
		else if(x==198 && y==82) begin	plot <= 1'b1;	end
		else if(x==204 && y==82) begin	plot <= 1'b1;	end
		else if(x==205 && y==82) begin	plot <= 1'b1;	end
		else if(x==206 && y==82) begin	plot <= 1'b1;	end
		else if(x==207 && y==82) begin	plot <= 1'b1;	end
		else if(x==103 && y==83) begin	plot <= 1'b1;	end
		else if(x==104 && y==83) begin	plot <= 1'b1;	end
		else if(x==105 && y==83) begin	plot <= 1'b1;	end
		else if(x==106 && y==83) begin	plot <= 1'b1;	end
		else if(x==111 && y==83) begin	plot <= 1'b1;	end
		else if(x==112 && y==83) begin	plot <= 1'b1;	end
		else if(x==113 && y==83) begin	plot <= 1'b1;	end
		else if(x==114 && y==83) begin	plot <= 1'b1;	end
		else if(x==115 && y==83) begin	plot <= 1'b1;	end
		else if(x==120 && y==83) begin	plot <= 1'b1;	end
		else if(x==121 && y==83) begin	plot <= 1'b1;	end
		else if(x==122 && y==83) begin	plot <= 1'b1;	end
		else if(x==123 && y==83) begin	plot <= 1'b1;	end
		else if(x==124 && y==83) begin	plot <= 1'b1;	end
		else if(x==125 && y==83) begin	plot <= 1'b1;	end
		else if(x==126 && y==83) begin	plot <= 1'b1;	end
		else if(x==127 && y==83) begin	plot <= 1'b1;	end
		else if(x==128 && y==83) begin	plot <= 1'b1;	end
		else if(x==133 && y==83) begin	plot <= 1'b1;	end
		else if(x==134 && y==83) begin	plot <= 1'b1;	end
		else if(x==135 && y==83) begin	plot <= 1'b1;	end
		else if(x==136 && y==83) begin	plot <= 1'b1;	end
		else if(x==141 && y==83) begin	plot <= 1'b1;	end
		else if(x==142 && y==83) begin	plot <= 1'b1;	end
		else if(x==143 && y==83) begin	plot <= 1'b1;	end
		else if(x==144 && y==83) begin	plot <= 1'b1;	end
		else if(x==145 && y==83) begin	plot <= 1'b1;	end
		else if(x==163 && y==83) begin	plot <= 1'b1;	end
		else if(x==164 && y==83) begin	plot <= 1'b1;	end
		else if(x==165 && y==83) begin	plot <= 1'b1;	end
		else if(x==166 && y==83) begin	plot <= 1'b1;	end
		else if(x==174 && y==83) begin	plot <= 1'b1;	end
		else if(x==175 && y==83) begin	plot <= 1'b1;	end
		else if(x==176 && y==83) begin	plot <= 1'b1;	end
		else if(x==177 && y==83) begin	plot <= 1'b1;	end
		else if(x==180 && y==83) begin	plot <= 1'b1;	end
		else if(x==181 && y==83) begin	plot <= 1'b1;	end
		else if(x==182 && y==83) begin	plot <= 1'b1;	end
		else if(x==183 && y==83) begin	plot <= 1'b1;	end
		else if(x==184 && y==83) begin	plot <= 1'b1;	end
		else if(x==185 && y==83) begin	plot <= 1'b1;	end
		else if(x==186 && y==83) begin	plot <= 1'b1;	end
		else if(x==187 && y==83) begin	plot <= 1'b1;	end
		else if(x==188 && y==83) begin	plot <= 1'b1;	end
		else if(x==189 && y==83) begin	plot <= 1'b1;	end
		else if(x==190 && y==83) begin	plot <= 1'b1;	end
		else if(x==191 && y==83) begin	plot <= 1'b1;	end
		else if(x==192 && y==83) begin	plot <= 1'b1;	end
		else if(x==195 && y==83) begin	plot <= 1'b1;	end
		else if(x==196 && y==83) begin	plot <= 1'b1;	end
		else if(x==197 && y==83) begin	plot <= 1'b1;	end
		else if(x==198 && y==83) begin	plot <= 1'b1;	end
		else if(x==204 && y==83) begin	plot <= 1'b1;	end
		else if(x==205 && y==83) begin	plot <= 1'b1;	end
		else if(x==206 && y==83) begin	plot <= 1'b1;	end
		else if(x==207 && y==83) begin	plot <= 1'b1;	end
		else if(x==103 && y==84) begin	plot <= 1'b1;	end
		else if(x==104 && y==84) begin	plot <= 1'b1;	end
		else if(x==105 && y==84) begin	plot <= 1'b1;	end
		else if(x==106 && y==84) begin	plot <= 1'b1;	end
		else if(x==111 && y==84) begin	plot <= 1'b1;	end
		else if(x==112 && y==84) begin	plot <= 1'b1;	end
		else if(x==113 && y==84) begin	plot <= 1'b1;	end
		else if(x==114 && y==84) begin	plot <= 1'b1;	end
		else if(x==115 && y==84) begin	plot <= 1'b1;	end
		else if(x==118 && y==84) begin	plot <= 1'b1;	end
		else if(x==119 && y==84) begin	plot <= 1'b1;	end
		else if(x==120 && y==84) begin	plot <= 1'b1;	end
		else if(x==121 && y==84) begin	plot <= 1'b1;	end
		else if(x==122 && y==84) begin	plot <= 1'b1;	end
		else if(x==123 && y==84) begin	plot <= 1'b1;	end
		else if(x==124 && y==84) begin	plot <= 1'b1;	end
		else if(x==125 && y==84) begin	plot <= 1'b1;	end
		else if(x==126 && y==84) begin	plot <= 1'b1;	end
		else if(x==127 && y==84) begin	plot <= 1'b1;	end
		else if(x==128 && y==84) begin	plot <= 1'b1;	end
		else if(x==129 && y==84) begin	plot <= 1'b1;	end
		else if(x==130 && y==84) begin	plot <= 1'b1;	end
		else if(x==133 && y==84) begin	plot <= 1'b1;	end
		else if(x==134 && y==84) begin	plot <= 1'b1;	end
		else if(x==135 && y==84) begin	plot <= 1'b1;	end
		else if(x==136 && y==84) begin	plot <= 1'b1;	end
		else if(x==141 && y==84) begin	plot <= 1'b1;	end
		else if(x==142 && y==84) begin	plot <= 1'b1;	end
		else if(x==143 && y==84) begin	plot <= 1'b1;	end
		else if(x==144 && y==84) begin	plot <= 1'b1;	end
		else if(x==145 && y==84) begin	plot <= 1'b1;	end
		else if(x==163 && y==84) begin	plot <= 1'b1;	end
		else if(x==164 && y==84) begin	plot <= 1'b1;	end
		else if(x==165 && y==84) begin	plot <= 1'b1;	end
		else if(x==166 && y==84) begin	plot <= 1'b1;	end
		else if(x==174 && y==84) begin	plot <= 1'b1;	end
		else if(x==175 && y==84) begin	plot <= 1'b1;	end
		else if(x==176 && y==84) begin	plot <= 1'b1;	end
		else if(x==177 && y==84) begin	plot <= 1'b1;	end
		else if(x==180 && y==84) begin	plot <= 1'b1;	end
		else if(x==181 && y==84) begin	plot <= 1'b1;	end
		else if(x==182 && y==84) begin	plot <= 1'b1;	end
		else if(x==183 && y==84) begin	plot <= 1'b1;	end
		else if(x==184 && y==84) begin	plot <= 1'b1;	end
		else if(x==185 && y==84) begin	plot <= 1'b1;	end
		else if(x==186 && y==84) begin	plot <= 1'b1;	end
		else if(x==187 && y==84) begin	plot <= 1'b1;	end
		else if(x==188 && y==84) begin	plot <= 1'b1;	end
		else if(x==189 && y==84) begin	plot <= 1'b1;	end
		else if(x==190 && y==84) begin	plot <= 1'b1;	end
		else if(x==191 && y==84) begin	plot <= 1'b1;	end
		else if(x==192 && y==84) begin	plot <= 1'b1;	end
		else if(x==195 && y==84) begin	plot <= 1'b1;	end
		else if(x==196 && y==84) begin	plot <= 1'b1;	end
		else if(x==197 && y==84) begin	plot <= 1'b1;	end
		else if(x==198 && y==84) begin	plot <= 1'b1;	end
		else if(x==199 && y==84) begin	plot <= 1'b1;	end
		else if(x==200 && y==84) begin	plot <= 1'b1;	end
		else if(x==204 && y==84) begin	plot <= 1'b1;	end
		else if(x==205 && y==84) begin	plot <= 1'b1;	end
		else if(x==206 && y==84) begin	plot <= 1'b1;	end
		else if(x==207 && y==84) begin	plot <= 1'b1;	end
		else if(x==103 && y==85) begin	plot <= 1'b1;	end
		else if(x==104 && y==85) begin	plot <= 1'b1;	end
		else if(x==105 && y==85) begin	plot <= 1'b1;	end
		else if(x==106 && y==85) begin	plot <= 1'b1;	end
		else if(x==111 && y==85) begin	plot <= 1'b1;	end
		else if(x==112 && y==85) begin	plot <= 1'b1;	end
		else if(x==113 && y==85) begin	plot <= 1'b1;	end
		else if(x==114 && y==85) begin	plot <= 1'b1;	end
		else if(x==115 && y==85) begin	plot <= 1'b1;	end
		else if(x==118 && y==85) begin	plot <= 1'b1;	end
		else if(x==119 && y==85) begin	plot <= 1'b1;	end
		else if(x==120 && y==85) begin	plot <= 1'b1;	end
		else if(x==121 && y==85) begin	plot <= 1'b1;	end
		else if(x==122 && y==85) begin	plot <= 1'b1;	end
		else if(x==123 && y==85) begin	plot <= 1'b1;	end
		else if(x==124 && y==85) begin	plot <= 1'b1;	end
		else if(x==125 && y==85) begin	plot <= 1'b1;	end
		else if(x==126 && y==85) begin	plot <= 1'b1;	end
		else if(x==127 && y==85) begin	plot <= 1'b1;	end
		else if(x==128 && y==85) begin	plot <= 1'b1;	end
		else if(x==129 && y==85) begin	plot <= 1'b1;	end
		else if(x==130 && y==85) begin	plot <= 1'b1;	end
		else if(x==133 && y==85) begin	plot <= 1'b1;	end
		else if(x==134 && y==85) begin	plot <= 1'b1;	end
		else if(x==135 && y==85) begin	plot <= 1'b1;	end
		else if(x==136 && y==85) begin	plot <= 1'b1;	end
		else if(x==141 && y==85) begin	plot <= 1'b1;	end
		else if(x==142 && y==85) begin	plot <= 1'b1;	end
		else if(x==143 && y==85) begin	plot <= 1'b1;	end
		else if(x==144 && y==85) begin	plot <= 1'b1;	end
		else if(x==145 && y==85) begin	plot <= 1'b1;	end
		else if(x==163 && y==85) begin	plot <= 1'b1;	end
		else if(x==164 && y==85) begin	plot <= 1'b1;	end
		else if(x==165 && y==85) begin	plot <= 1'b1;	end
		else if(x==166 && y==85) begin	plot <= 1'b1;	end
		else if(x==174 && y==85) begin	plot <= 1'b1;	end
		else if(x==175 && y==85) begin	plot <= 1'b1;	end
		else if(x==176 && y==85) begin	plot <= 1'b1;	end
		else if(x==177 && y==85) begin	plot <= 1'b1;	end
		else if(x==180 && y==85) begin	plot <= 1'b1;	end
		else if(x==181 && y==85) begin	plot <= 1'b1;	end
		else if(x==182 && y==85) begin	plot <= 1'b1;	end
		else if(x==183 && y==85) begin	plot <= 1'b1;	end
		else if(x==184 && y==85) begin	plot <= 1'b1;	end
		else if(x==185 && y==85) begin	plot <= 1'b1;	end
		else if(x==186 && y==85) begin	plot <= 1'b1;	end
		else if(x==187 && y==85) begin	plot <= 1'b1;	end
		else if(x==188 && y==85) begin	plot <= 1'b1;	end
		else if(x==189 && y==85) begin	plot <= 1'b1;	end
		else if(x==190 && y==85) begin	plot <= 1'b1;	end
		else if(x==191 && y==85) begin	plot <= 1'b1;	end
		else if(x==192 && y==85) begin	plot <= 1'b1;	end
		else if(x==195 && y==85) begin	plot <= 1'b1;	end
		else if(x==196 && y==85) begin	plot <= 1'b1;	end
		else if(x==197 && y==85) begin	plot <= 1'b1;	end
		else if(x==198 && y==85) begin	plot <= 1'b1;	end
		else if(x==199 && y==85) begin	plot <= 1'b1;	end
		else if(x==200 && y==85) begin	plot <= 1'b1;	end
		else if(x==201 && y==85) begin	plot <= 1'b1;	end
		else if(x==204 && y==85) begin	plot <= 1'b1;	end
		else if(x==205 && y==85) begin	plot <= 1'b1;	end
		else if(x==206 && y==85) begin	plot <= 1'b1;	end
		else if(x==207 && y==85) begin	plot <= 1'b1;	end
		else if(x==103 && y==86) begin	plot <= 1'b1;	end
		else if(x==104 && y==86) begin	plot <= 1'b1;	end
		else if(x==105 && y==86) begin	plot <= 1'b1;	end
		else if(x==106 && y==86) begin	plot <= 1'b1;	end
		else if(x==111 && y==86) begin	plot <= 1'b1;	end
		else if(x==112 && y==86) begin	plot <= 1'b1;	end
		else if(x==113 && y==86) begin	plot <= 1'b1;	end
		else if(x==114 && y==86) begin	plot <= 1'b1;	end
		else if(x==115 && y==86) begin	plot <= 1'b1;	end
		else if(x==118 && y==86) begin	plot <= 1'b1;	end
		else if(x==119 && y==86) begin	plot <= 1'b1;	end
		else if(x==120 && y==86) begin	plot <= 1'b1;	end
		else if(x==121 && y==86) begin	plot <= 1'b1;	end
		else if(x==126 && y==86) begin	plot <= 1'b1;	end
		else if(x==127 && y==86) begin	plot <= 1'b1;	end
		else if(x==128 && y==86) begin	plot <= 1'b1;	end
		else if(x==129 && y==86) begin	plot <= 1'b1;	end
		else if(x==130 && y==86) begin	plot <= 1'b1;	end
		else if(x==133 && y==86) begin	plot <= 1'b1;	end
		else if(x==134 && y==86) begin	plot <= 1'b1;	end
		else if(x==135 && y==86) begin	plot <= 1'b1;	end
		else if(x==136 && y==86) begin	plot <= 1'b1;	end
		else if(x==141 && y==86) begin	plot <= 1'b1;	end
		else if(x==142 && y==86) begin	plot <= 1'b1;	end
		else if(x==143 && y==86) begin	plot <= 1'b1;	end
		else if(x==144 && y==86) begin	plot <= 1'b1;	end
		else if(x==145 && y==86) begin	plot <= 1'b1;	end
		else if(x==163 && y==86) begin	plot <= 1'b1;	end
		else if(x==164 && y==86) begin	plot <= 1'b1;	end
		else if(x==165 && y==86) begin	plot <= 1'b1;	end
		else if(x==166 && y==86) begin	plot <= 1'b1;	end
		else if(x==174 && y==86) begin	plot <= 1'b1;	end
		else if(x==175 && y==86) begin	plot <= 1'b1;	end
		else if(x==176 && y==86) begin	plot <= 1'b1;	end
		else if(x==177 && y==86) begin	plot <= 1'b1;	end
		else if(x==184 && y==86) begin	plot <= 1'b1;	end
		else if(x==185 && y==86) begin	plot <= 1'b1;	end
		else if(x==186 && y==86) begin	plot <= 1'b1;	end
		else if(x==187 && y==86) begin	plot <= 1'b1;	end
		else if(x==188 && y==86) begin	plot <= 1'b1;	end
		else if(x==195 && y==86) begin	plot <= 1'b1;	end
		else if(x==196 && y==86) begin	plot <= 1'b1;	end
		else if(x==197 && y==86) begin	plot <= 1'b1;	end
		else if(x==198 && y==86) begin	plot <= 1'b1;	end
		else if(x==199 && y==86) begin	plot <= 1'b1;	end
		else if(x==200 && y==86) begin	plot <= 1'b1;	end
		else if(x==201 && y==86) begin	plot <= 1'b1;	end
		else if(x==202 && y==86) begin	plot <= 1'b1;	end
		else if(x==203 && y==86) begin	plot <= 1'b1;	end
		else if(x==204 && y==86) begin	plot <= 1'b1;	end
		else if(x==205 && y==86) begin	plot <= 1'b1;	end
		else if(x==206 && y==86) begin	plot <= 1'b1;	end
		else if(x==207 && y==86) begin	plot <= 1'b1;	end
		else if(x==103 && y==87) begin	plot <= 1'b1;	end
		else if(x==104 && y==87) begin	plot <= 1'b1;	end
		else if(x==105 && y==87) begin	plot <= 1'b1;	end
		else if(x==106 && y==87) begin	plot <= 1'b1;	end
		else if(x==111 && y==87) begin	plot <= 1'b1;	end
		else if(x==112 && y==87) begin	plot <= 1'b1;	end
		else if(x==113 && y==87) begin	plot <= 1'b1;	end
		else if(x==114 && y==87) begin	plot <= 1'b1;	end
		else if(x==115 && y==87) begin	plot <= 1'b1;	end
		else if(x==118 && y==87) begin	plot <= 1'b1;	end
		else if(x==119 && y==87) begin	plot <= 1'b1;	end
		else if(x==120 && y==87) begin	plot <= 1'b1;	end
		else if(x==121 && y==87) begin	plot <= 1'b1;	end
		else if(x==126 && y==87) begin	plot <= 1'b1;	end
		else if(x==127 && y==87) begin	plot <= 1'b1;	end
		else if(x==128 && y==87) begin	plot <= 1'b1;	end
		else if(x==129 && y==87) begin	plot <= 1'b1;	end
		else if(x==130 && y==87) begin	plot <= 1'b1;	end
		else if(x==133 && y==87) begin	plot <= 1'b1;	end
		else if(x==134 && y==87) begin	plot <= 1'b1;	end
		else if(x==135 && y==87) begin	plot <= 1'b1;	end
		else if(x==136 && y==87) begin	plot <= 1'b1;	end
		else if(x==141 && y==87) begin	plot <= 1'b1;	end
		else if(x==142 && y==87) begin	plot <= 1'b1;	end
		else if(x==143 && y==87) begin	plot <= 1'b1;	end
		else if(x==144 && y==87) begin	plot <= 1'b1;	end
		else if(x==145 && y==87) begin	plot <= 1'b1;	end
		else if(x==163 && y==87) begin	plot <= 1'b1;	end
		else if(x==164 && y==87) begin	plot <= 1'b1;	end
		else if(x==165 && y==87) begin	plot <= 1'b1;	end
		else if(x==166 && y==87) begin	plot <= 1'b1;	end
		else if(x==174 && y==87) begin	plot <= 1'b1;	end
		else if(x==175 && y==87) begin	plot <= 1'b1;	end
		else if(x==176 && y==87) begin	plot <= 1'b1;	end
		else if(x==177 && y==87) begin	plot <= 1'b1;	end
		else if(x==184 && y==87) begin	plot <= 1'b1;	end
		else if(x==185 && y==87) begin	plot <= 1'b1;	end
		else if(x==186 && y==87) begin	plot <= 1'b1;	end
		else if(x==187 && y==87) begin	plot <= 1'b1;	end
		else if(x==188 && y==87) begin	plot <= 1'b1;	end
		else if(x==195 && y==87) begin	plot <= 1'b1;	end
		else if(x==196 && y==87) begin	plot <= 1'b1;	end
		else if(x==197 && y==87) begin	plot <= 1'b1;	end
		else if(x==198 && y==87) begin	plot <= 1'b1;	end
		else if(x==199 && y==87) begin	plot <= 1'b1;	end
		else if(x==200 && y==87) begin	plot <= 1'b1;	end
		else if(x==201 && y==87) begin	plot <= 1'b1;	end
		else if(x==202 && y==87) begin	plot <= 1'b1;	end
		else if(x==203 && y==87) begin	plot <= 1'b1;	end
		else if(x==204 && y==87) begin	plot <= 1'b1;	end
		else if(x==205 && y==87) begin	plot <= 1'b1;	end
		else if(x==206 && y==87) begin	plot <= 1'b1;	end
		else if(x==207 && y==87) begin	plot <= 1'b1;	end
		else if(x==103 && y==88) begin	plot <= 1'b1;	end
		else if(x==104 && y==88) begin	plot <= 1'b1;	end
		else if(x==105 && y==88) begin	plot <= 1'b1;	end
		else if(x==106 && y==88) begin	plot <= 1'b1;	end
		else if(x==107 && y==88) begin	plot <= 1'b1;	end
		else if(x==108 && y==88) begin	plot <= 1'b1;	end
		else if(x==109 && y==88) begin	plot <= 1'b1;	end
		else if(x==110 && y==88) begin	plot <= 1'b1;	end
		else if(x==111 && y==88) begin	plot <= 1'b1;	end
		else if(x==112 && y==88) begin	plot <= 1'b1;	end
		else if(x==113 && y==88) begin	plot <= 1'b1;	end
		else if(x==114 && y==88) begin	plot <= 1'b1;	end
		else if(x==115 && y==88) begin	plot <= 1'b1;	end
		else if(x==118 && y==88) begin	plot <= 1'b1;	end
		else if(x==119 && y==88) begin	plot <= 1'b1;	end
		else if(x==120 && y==88) begin	plot <= 1'b1;	end
		else if(x==121 && y==88) begin	plot <= 1'b1;	end
		else if(x==126 && y==88) begin	plot <= 1'b1;	end
		else if(x==127 && y==88) begin	plot <= 1'b1;	end
		else if(x==128 && y==88) begin	plot <= 1'b1;	end
		else if(x==129 && y==88) begin	plot <= 1'b1;	end
		else if(x==130 && y==88) begin	plot <= 1'b1;	end
		else if(x==133 && y==88) begin	plot <= 1'b1;	end
		else if(x==134 && y==88) begin	plot <= 1'b1;	end
		else if(x==135 && y==88) begin	plot <= 1'b1;	end
		else if(x==136 && y==88) begin	plot <= 1'b1;	end
		else if(x==141 && y==88) begin	plot <= 1'b1;	end
		else if(x==142 && y==88) begin	plot <= 1'b1;	end
		else if(x==143 && y==88) begin	plot <= 1'b1;	end
		else if(x==144 && y==88) begin	plot <= 1'b1;	end
		else if(x==145 && y==88) begin	plot <= 1'b1;	end
		else if(x==163 && y==88) begin	plot <= 1'b1;	end
		else if(x==164 && y==88) begin	plot <= 1'b1;	end
		else if(x==165 && y==88) begin	plot <= 1'b1;	end
		else if(x==166 && y==88) begin	plot <= 1'b1;	end
		else if(x==169 && y==88) begin	plot <= 1'b1;	end
		else if(x==170 && y==88) begin	plot <= 1'b1;	end
		else if(x==174 && y==88) begin	plot <= 1'b1;	end
		else if(x==175 && y==88) begin	plot <= 1'b1;	end
		else if(x==176 && y==88) begin	plot <= 1'b1;	end
		else if(x==177 && y==88) begin	plot <= 1'b1;	end
		else if(x==184 && y==88) begin	plot <= 1'b1;	end
		else if(x==185 && y==88) begin	plot <= 1'b1;	end
		else if(x==186 && y==88) begin	plot <= 1'b1;	end
		else if(x==187 && y==88) begin	plot <= 1'b1;	end
		else if(x==188 && y==88) begin	plot <= 1'b1;	end
		else if(x==195 && y==88) begin	plot <= 1'b1;	end
		else if(x==196 && y==88) begin	plot <= 1'b1;	end
		else if(x==197 && y==88) begin	plot <= 1'b1;	end
		else if(x==198 && y==88) begin	plot <= 1'b1;	end
		else if(x==199 && y==88) begin	plot <= 1'b1;	end
		else if(x==200 && y==88) begin	plot <= 1'b1;	end
		else if(x==201 && y==88) begin	plot <= 1'b1;	end
		else if(x==202 && y==88) begin	plot <= 1'b1;	end
		else if(x==203 && y==88) begin	plot <= 1'b1;	end
		else if(x==204 && y==88) begin	plot <= 1'b1;	end
		else if(x==205 && y==88) begin	plot <= 1'b1;	end
		else if(x==206 && y==88) begin	plot <= 1'b1;	end
		else if(x==207 && y==88) begin	plot <= 1'b1;	end
		else if(x==103 && y==89) begin	plot <= 1'b1;	end
		else if(x==104 && y==89) begin	plot <= 1'b1;	end
		else if(x==105 && y==89) begin	plot <= 1'b1;	end
		else if(x==106 && y==89) begin	plot <= 1'b1;	end
		else if(x==107 && y==89) begin	plot <= 1'b1;	end
		else if(x==108 && y==89) begin	plot <= 1'b1;	end
		else if(x==109 && y==89) begin	plot <= 1'b1;	end
		else if(x==110 && y==89) begin	plot <= 1'b1;	end
		else if(x==111 && y==89) begin	plot <= 1'b1;	end
		else if(x==112 && y==89) begin	plot <= 1'b1;	end
		else if(x==113 && y==89) begin	plot <= 1'b1;	end
		else if(x==114 && y==89) begin	plot <= 1'b1;	end
		else if(x==115 && y==89) begin	plot <= 1'b1;	end
		else if(x==118 && y==89) begin	plot <= 1'b1;	end
		else if(x==119 && y==89) begin	plot <= 1'b1;	end
		else if(x==120 && y==89) begin	plot <= 1'b1;	end
		else if(x==121 && y==89) begin	plot <= 1'b1;	end
		else if(x==126 && y==89) begin	plot <= 1'b1;	end
		else if(x==127 && y==89) begin	plot <= 1'b1;	end
		else if(x==128 && y==89) begin	plot <= 1'b1;	end
		else if(x==129 && y==89) begin	plot <= 1'b1;	end
		else if(x==130 && y==89) begin	plot <= 1'b1;	end
		else if(x==133 && y==89) begin	plot <= 1'b1;	end
		else if(x==134 && y==89) begin	plot <= 1'b1;	end
		else if(x==135 && y==89) begin	plot <= 1'b1;	end
		else if(x==136 && y==89) begin	plot <= 1'b1;	end
		else if(x==141 && y==89) begin	plot <= 1'b1;	end
		else if(x==142 && y==89) begin	plot <= 1'b1;	end
		else if(x==143 && y==89) begin	plot <= 1'b1;	end
		else if(x==144 && y==89) begin	plot <= 1'b1;	end
		else if(x==145 && y==89) begin	plot <= 1'b1;	end
		else if(x==163 && y==89) begin	plot <= 1'b1;	end
		else if(x==164 && y==89) begin	plot <= 1'b1;	end
		else if(x==165 && y==89) begin	plot <= 1'b1;	end
		else if(x==166 && y==89) begin	plot <= 1'b1;	end
		else if(x==169 && y==89) begin	plot <= 1'b1;	end
		else if(x==170 && y==89) begin	plot <= 1'b1;	end
		else if(x==173 && y==89) begin	plot <= 1'b1;	end
		else if(x==174 && y==89) begin	plot <= 1'b1;	end
		else if(x==175 && y==89) begin	plot <= 1'b1;	end
		else if(x==176 && y==89) begin	plot <= 1'b1;	end
		else if(x==177 && y==89) begin	plot <= 1'b1;	end
		else if(x==184 && y==89) begin	plot <= 1'b1;	end
		else if(x==185 && y==89) begin	plot <= 1'b1;	end
		else if(x==186 && y==89) begin	plot <= 1'b1;	end
		else if(x==187 && y==89) begin	plot <= 1'b1;	end
		else if(x==188 && y==89) begin	plot <= 1'b1;	end
		else if(x==195 && y==89) begin	plot <= 1'b1;	end
		else if(x==196 && y==89) begin	plot <= 1'b1;	end
		else if(x==197 && y==89) begin	plot <= 1'b1;	end
		else if(x==198 && y==89) begin	plot <= 1'b1;	end
		else if(x==199 && y==89) begin	plot <= 1'b1;	end
		else if(x==200 && y==89) begin	plot <= 1'b1;	end
		else if(x==201 && y==89) begin	plot <= 1'b1;	end
		else if(x==202 && y==89) begin	plot <= 1'b1;	end
		else if(x==203 && y==89) begin	plot <= 1'b1;	end
		else if(x==204 && y==89) begin	plot <= 1'b1;	end
		else if(x==205 && y==89) begin	plot <= 1'b1;	end
		else if(x==206 && y==89) begin	plot <= 1'b1;	end
		else if(x==207 && y==89) begin	plot <= 1'b1;	end
		else if(x==104 && y==90) begin	plot <= 1'b1;	end
		else if(x==105 && y==90) begin	plot <= 1'b1;	end
		else if(x==106 && y==90) begin	plot <= 1'b1;	end
		else if(x==107 && y==90) begin	plot <= 1'b1;	end
		else if(x==108 && y==90) begin	plot <= 1'b1;	end
		else if(x==109 && y==90) begin	plot <= 1'b1;	end
		else if(x==110 && y==90) begin	plot <= 1'b1;	end
		else if(x==111 && y==90) begin	plot <= 1'b1;	end
		else if(x==112 && y==90) begin	plot <= 1'b1;	end
		else if(x==113 && y==90) begin	plot <= 1'b1;	end
		else if(x==118 && y==90) begin	plot <= 1'b1;	end
		else if(x==119 && y==90) begin	plot <= 1'b1;	end
		else if(x==120 && y==90) begin	plot <= 1'b1;	end
		else if(x==121 && y==90) begin	plot <= 1'b1;	end
		else if(x==126 && y==90) begin	plot <= 1'b1;	end
		else if(x==127 && y==90) begin	plot <= 1'b1;	end
		else if(x==128 && y==90) begin	plot <= 1'b1;	end
		else if(x==129 && y==90) begin	plot <= 1'b1;	end
		else if(x==130 && y==90) begin	plot <= 1'b1;	end
		else if(x==133 && y==90) begin	plot <= 1'b1;	end
		else if(x==134 && y==90) begin	plot <= 1'b1;	end
		else if(x==135 && y==90) begin	plot <= 1'b1;	end
		else if(x==136 && y==90) begin	plot <= 1'b1;	end
		else if(x==141 && y==90) begin	plot <= 1'b1;	end
		else if(x==142 && y==90) begin	plot <= 1'b1;	end
		else if(x==143 && y==90) begin	plot <= 1'b1;	end
		else if(x==144 && y==90) begin	plot <= 1'b1;	end
		else if(x==145 && y==90) begin	plot <= 1'b1;	end
		else if(x==163 && y==90) begin	plot <= 1'b1;	end
		else if(x==164 && y==90) begin	plot <= 1'b1;	end
		else if(x==165 && y==90) begin	plot <= 1'b1;	end
		else if(x==166 && y==90) begin	plot <= 1'b1;	end
		else if(x==167 && y==90) begin	plot <= 1'b1;	end
		else if(x==168 && y==90) begin	plot <= 1'b1;	end
		else if(x==169 && y==90) begin	plot <= 1'b1;	end
		else if(x==170 && y==90) begin	plot <= 1'b1;	end
		else if(x==171 && y==90) begin	plot <= 1'b1;	end
		else if(x==172 && y==90) begin	plot <= 1'b1;	end
		else if(x==173 && y==90) begin	plot <= 1'b1;	end
		else if(x==174 && y==90) begin	plot <= 1'b1;	end
		else if(x==175 && y==90) begin	plot <= 1'b1;	end
		else if(x==176 && y==90) begin	plot <= 1'b1;	end
		else if(x==177 && y==90) begin	plot <= 1'b1;	end
		else if(x==184 && y==90) begin	plot <= 1'b1;	end
		else if(x==185 && y==90) begin	plot <= 1'b1;	end
		else if(x==186 && y==90) begin	plot <= 1'b1;	end
		else if(x==187 && y==90) begin	plot <= 1'b1;	end
		else if(x==188 && y==90) begin	plot <= 1'b1;	end
		else if(x==195 && y==90) begin	plot <= 1'b1;	end
		else if(x==196 && y==90) begin	plot <= 1'b1;	end
		else if(x==197 && y==90) begin	plot <= 1'b1;	end
		else if(x==198 && y==90) begin	plot <= 1'b1;	end
		else if(x==199 && y==90) begin	plot <= 1'b1;	end
		else if(x==201 && y==90) begin	plot <= 1'b1;	end
		else if(x==202 && y==90) begin	plot <= 1'b1;	end
		else if(x==203 && y==90) begin	plot <= 1'b1;	end
		else if(x==204 && y==90) begin	plot <= 1'b1;	end
		else if(x==205 && y==90) begin	plot <= 1'b1;	end
		else if(x==206 && y==90) begin	plot <= 1'b1;	end
		else if(x==207 && y==90) begin	plot <= 1'b1;	end
		else if(x==105 && y==91) begin	plot <= 1'b1;	end
		else if(x==106 && y==91) begin	plot <= 1'b1;	end
		else if(x==107 && y==91) begin	plot <= 1'b1;	end
		else if(x==108 && y==91) begin	plot <= 1'b1;	end
		else if(x==109 && y==91) begin	plot <= 1'b1;	end
		else if(x==110 && y==91) begin	plot <= 1'b1;	end
		else if(x==111 && y==91) begin	plot <= 1'b1;	end
		else if(x==112 && y==91) begin	plot <= 1'b1;	end
		else if(x==113 && y==91) begin	plot <= 1'b1;	end
		else if(x==118 && y==91) begin	plot <= 1'b1;	end
		else if(x==119 && y==91) begin	plot <= 1'b1;	end
		else if(x==120 && y==91) begin	plot <= 1'b1;	end
		else if(x==121 && y==91) begin	plot <= 1'b1;	end
		else if(x==126 && y==91) begin	plot <= 1'b1;	end
		else if(x==127 && y==91) begin	plot <= 1'b1;	end
		else if(x==128 && y==91) begin	plot <= 1'b1;	end
		else if(x==129 && y==91) begin	plot <= 1'b1;	end
		else if(x==130 && y==91) begin	plot <= 1'b1;	end
		else if(x==133 && y==91) begin	plot <= 1'b1;	end
		else if(x==134 && y==91) begin	plot <= 1'b1;	end
		else if(x==135 && y==91) begin	plot <= 1'b1;	end
		else if(x==136 && y==91) begin	plot <= 1'b1;	end
		else if(x==141 && y==91) begin	plot <= 1'b1;	end
		else if(x==142 && y==91) begin	plot <= 1'b1;	end
		else if(x==143 && y==91) begin	plot <= 1'b1;	end
		else if(x==144 && y==91) begin	plot <= 1'b1;	end
		else if(x==145 && y==91) begin	plot <= 1'b1;	end
		else if(x==163 && y==91) begin	plot <= 1'b1;	end
		else if(x==164 && y==91) begin	plot <= 1'b1;	end
		else if(x==165 && y==91) begin	plot <= 1'b1;	end
		else if(x==166 && y==91) begin	plot <= 1'b1;	end
		else if(x==167 && y==91) begin	plot <= 1'b1;	end
		else if(x==168 && y==91) begin	plot <= 1'b1;	end
		else if(x==169 && y==91) begin	plot <= 1'b1;	end
		else if(x==170 && y==91) begin	plot <= 1'b1;	end
		else if(x==171 && y==91) begin	plot <= 1'b1;	end
		else if(x==172 && y==91) begin	plot <= 1'b1;	end
		else if(x==173 && y==91) begin	plot <= 1'b1;	end
		else if(x==174 && y==91) begin	plot <= 1'b1;	end
		else if(x==175 && y==91) begin	plot <= 1'b1;	end
		else if(x==176 && y==91) begin	plot <= 1'b1;	end
		else if(x==177 && y==91) begin	plot <= 1'b1;	end
		else if(x==184 && y==91) begin	plot <= 1'b1;	end
		else if(x==185 && y==91) begin	plot <= 1'b1;	end
		else if(x==186 && y==91) begin	plot <= 1'b1;	end
		else if(x==187 && y==91) begin	plot <= 1'b1;	end
		else if(x==188 && y==91) begin	plot <= 1'b1;	end
		else if(x==195 && y==91) begin	plot <= 1'b1;	end
		else if(x==196 && y==91) begin	plot <= 1'b1;	end
		else if(x==197 && y==91) begin	plot <= 1'b1;	end
		else if(x==198 && y==91) begin	plot <= 1'b1;	end
		else if(x==201 && y==91) begin	plot <= 1'b1;	end
		else if(x==202 && y==91) begin	plot <= 1'b1;	end
		else if(x==203 && y==91) begin	plot <= 1'b1;	end
		else if(x==204 && y==91) begin	plot <= 1'b1;	end
		else if(x==205 && y==91) begin	plot <= 1'b1;	end
		else if(x==206 && y==91) begin	plot <= 1'b1;	end
		else if(x==207 && y==91) begin	plot <= 1'b1;	end
		else if(x==106 && y==92) begin	plot <= 1'b1;	end
		else if(x==107 && y==92) begin	plot <= 1'b1;	end
		else if(x==108 && y==92) begin	plot <= 1'b1;	end
		else if(x==109 && y==92) begin	plot <= 1'b1;	end
		else if(x==110 && y==92) begin	plot <= 1'b1;	end
		else if(x==111 && y==92) begin	plot <= 1'b1;	end
		else if(x==112 && y==92) begin	plot <= 1'b1;	end
		else if(x==118 && y==92) begin	plot <= 1'b1;	end
		else if(x==119 && y==92) begin	plot <= 1'b1;	end
		else if(x==120 && y==92) begin	plot <= 1'b1;	end
		else if(x==121 && y==92) begin	plot <= 1'b1;	end
		else if(x==126 && y==92) begin	plot <= 1'b1;	end
		else if(x==127 && y==92) begin	plot <= 1'b1;	end
		else if(x==128 && y==92) begin	plot <= 1'b1;	end
		else if(x==129 && y==92) begin	plot <= 1'b1;	end
		else if(x==130 && y==92) begin	plot <= 1'b1;	end
		else if(x==133 && y==92) begin	plot <= 1'b1;	end
		else if(x==134 && y==92) begin	plot <= 1'b1;	end
		else if(x==135 && y==92) begin	plot <= 1'b1;	end
		else if(x==136 && y==92) begin	plot <= 1'b1;	end
		else if(x==141 && y==92) begin	plot <= 1'b1;	end
		else if(x==142 && y==92) begin	plot <= 1'b1;	end
		else if(x==143 && y==92) begin	plot <= 1'b1;	end
		else if(x==144 && y==92) begin	plot <= 1'b1;	end
		else if(x==145 && y==92) begin	plot <= 1'b1;	end
		else if(x==163 && y==92) begin	plot <= 1'b1;	end
		else if(x==164 && y==92) begin	plot <= 1'b1;	end
		else if(x==165 && y==92) begin	plot <= 1'b1;	end
		else if(x==166 && y==92) begin	plot <= 1'b1;	end
		else if(x==167 && y==92) begin	plot <= 1'b1;	end
		else if(x==168 && y==92) begin	plot <= 1'b1;	end
		else if(x==169 && y==92) begin	plot <= 1'b1;	end
		else if(x==170 && y==92) begin	plot <= 1'b1;	end
		else if(x==171 && y==92) begin	plot <= 1'b1;	end
		else if(x==172 && y==92) begin	plot <= 1'b1;	end
		else if(x==173 && y==92) begin	plot <= 1'b1;	end
		else if(x==174 && y==92) begin	plot <= 1'b1;	end
		else if(x==175 && y==92) begin	plot <= 1'b1;	end
		else if(x==176 && y==92) begin	plot <= 1'b1;	end
		else if(x==177 && y==92) begin	plot <= 1'b1;	end
		else if(x==184 && y==92) begin	plot <= 1'b1;	end
		else if(x==185 && y==92) begin	plot <= 1'b1;	end
		else if(x==186 && y==92) begin	plot <= 1'b1;	end
		else if(x==187 && y==92) begin	plot <= 1'b1;	end
		else if(x==188 && y==92) begin	plot <= 1'b1;	end
		else if(x==195 && y==92) begin	plot <= 1'b1;	end
		else if(x==196 && y==92) begin	plot <= 1'b1;	end
		else if(x==197 && y==92) begin	plot <= 1'b1;	end
		else if(x==198 && y==92) begin	plot <= 1'b1;	end
		else if(x==202 && y==92) begin	plot <= 1'b1;	end
		else if(x==203 && y==92) begin	plot <= 1'b1;	end
		else if(x==204 && y==92) begin	plot <= 1'b1;	end
		else if(x==205 && y==92) begin	plot <= 1'b1;	end
		else if(x==206 && y==92) begin	plot <= 1'b1;	end
		else if(x==207 && y==92) begin	plot <= 1'b1;	end
		else if(x==107 && y==93) begin	plot <= 1'b1;	end
		else if(x==108 && y==93) begin	plot <= 1'b1;	end
		else if(x==109 && y==93) begin	plot <= 1'b1;	end
		else if(x==110 && y==93) begin	plot <= 1'b1;	end
		else if(x==118 && y==93) begin	plot <= 1'b1;	end
		else if(x==119 && y==93) begin	plot <= 1'b1;	end
		else if(x==120 && y==93) begin	plot <= 1'b1;	end
		else if(x==121 && y==93) begin	plot <= 1'b1;	end
		else if(x==126 && y==93) begin	plot <= 1'b1;	end
		else if(x==127 && y==93) begin	plot <= 1'b1;	end
		else if(x==128 && y==93) begin	plot <= 1'b1;	end
		else if(x==129 && y==93) begin	plot <= 1'b1;	end
		else if(x==130 && y==93) begin	plot <= 1'b1;	end
		else if(x==133 && y==93) begin	plot <= 1'b1;	end
		else if(x==134 && y==93) begin	plot <= 1'b1;	end
		else if(x==135 && y==93) begin	plot <= 1'b1;	end
		else if(x==136 && y==93) begin	plot <= 1'b1;	end
		else if(x==141 && y==93) begin	plot <= 1'b1;	end
		else if(x==142 && y==93) begin	plot <= 1'b1;	end
		else if(x==143 && y==93) begin	plot <= 1'b1;	end
		else if(x==144 && y==93) begin	plot <= 1'b1;	end
		else if(x==145 && y==93) begin	plot <= 1'b1;	end
		else if(x==163 && y==93) begin	plot <= 1'b1;	end
		else if(x==164 && y==93) begin	plot <= 1'b1;	end
		else if(x==165 && y==93) begin	plot <= 1'b1;	end
		else if(x==166 && y==93) begin	plot <= 1'b1;	end
		else if(x==167 && y==93) begin	plot <= 1'b1;	end
		else if(x==168 && y==93) begin	plot <= 1'b1;	end
		else if(x==169 && y==93) begin	plot <= 1'b1;	end
		else if(x==170 && y==93) begin	plot <= 1'b1;	end
		else if(x==171 && y==93) begin	plot <= 1'b1;	end
		else if(x==172 && y==93) begin	plot <= 1'b1;	end
		else if(x==173 && y==93) begin	plot <= 1'b1;	end
		else if(x==174 && y==93) begin	plot <= 1'b1;	end
		else if(x==175 && y==93) begin	plot <= 1'b1;	end
		else if(x==176 && y==93) begin	plot <= 1'b1;	end
		else if(x==177 && y==93) begin	plot <= 1'b1;	end
		else if(x==184 && y==93) begin	plot <= 1'b1;	end
		else if(x==185 && y==93) begin	plot <= 1'b1;	end
		else if(x==186 && y==93) begin	plot <= 1'b1;	end
		else if(x==187 && y==93) begin	plot <= 1'b1;	end
		else if(x==188 && y==93) begin	plot <= 1'b1;	end
		else if(x==195 && y==93) begin	plot <= 1'b1;	end
		else if(x==196 && y==93) begin	plot <= 1'b1;	end
		else if(x==197 && y==93) begin	plot <= 1'b1;	end
		else if(x==198 && y==93) begin	plot <= 1'b1;	end
		else if(x==204 && y==93) begin	plot <= 1'b1;	end
		else if(x==205 && y==93) begin	plot <= 1'b1;	end
		else if(x==206 && y==93) begin	plot <= 1'b1;	end
		else if(x==207 && y==93) begin	plot <= 1'b1;	end
		else if(x==107 && y==94) begin	plot <= 1'b1;	end
		else if(x==108 && y==94) begin	plot <= 1'b1;	end
		else if(x==109 && y==94) begin	plot <= 1'b1;	end
		else if(x==110 && y==94) begin	plot <= 1'b1;	end
		else if(x==118 && y==94) begin	plot <= 1'b1;	end
		else if(x==119 && y==94) begin	plot <= 1'b1;	end
		else if(x==120 && y==94) begin	plot <= 1'b1;	end
		else if(x==121 && y==94) begin	plot <= 1'b1;	end
		else if(x==122 && y==94) begin	plot <= 1'b1;	end
		else if(x==126 && y==94) begin	plot <= 1'b1;	end
		else if(x==127 && y==94) begin	plot <= 1'b1;	end
		else if(x==128 && y==94) begin	plot <= 1'b1;	end
		else if(x==129 && y==94) begin	plot <= 1'b1;	end
		else if(x==130 && y==94) begin	plot <= 1'b1;	end
		else if(x==133 && y==94) begin	plot <= 1'b1;	end
		else if(x==134 && y==94) begin	plot <= 1'b1;	end
		else if(x==135 && y==94) begin	plot <= 1'b1;	end
		else if(x==136 && y==94) begin	plot <= 1'b1;	end
		else if(x==137 && y==94) begin	plot <= 1'b1;	end
		else if(x==141 && y==94) begin	plot <= 1'b1;	end
		else if(x==142 && y==94) begin	plot <= 1'b1;	end
		else if(x==143 && y==94) begin	plot <= 1'b1;	end
		else if(x==144 && y==94) begin	plot <= 1'b1;	end
		else if(x==145 && y==94) begin	plot <= 1'b1;	end
		else if(x==163 && y==94) begin	plot <= 1'b1;	end
		else if(x==164 && y==94) begin	plot <= 1'b1;	end
		else if(x==165 && y==94) begin	plot <= 1'b1;	end
		else if(x==166 && y==94) begin	plot <= 1'b1;	end
		else if(x==167 && y==94) begin	plot <= 1'b1;	end
		else if(x==168 && y==94) begin	plot <= 1'b1;	end
		else if(x==169 && y==94) begin	plot <= 1'b1;	end
		else if(x==170 && y==94) begin	plot <= 1'b1;	end
		else if(x==171 && y==94) begin	plot <= 1'b1;	end
		else if(x==172 && y==94) begin	plot <= 1'b1;	end
		else if(x==173 && y==94) begin	plot <= 1'b1;	end
		else if(x==174 && y==94) begin	plot <= 1'b1;	end
		else if(x==175 && y==94) begin	plot <= 1'b1;	end
		else if(x==176 && y==94) begin	plot <= 1'b1;	end
		else if(x==177 && y==94) begin	plot <= 1'b1;	end
		else if(x==184 && y==94) begin	plot <= 1'b1;	end
		else if(x==185 && y==94) begin	plot <= 1'b1;	end
		else if(x==186 && y==94) begin	plot <= 1'b1;	end
		else if(x==187 && y==94) begin	plot <= 1'b1;	end
		else if(x==188 && y==94) begin	plot <= 1'b1;	end
		else if(x==195 && y==94) begin	plot <= 1'b1;	end
		else if(x==196 && y==94) begin	plot <= 1'b1;	end
		else if(x==197 && y==94) begin	plot <= 1'b1;	end
		else if(x==198 && y==94) begin	plot <= 1'b1;	end
		else if(x==204 && y==94) begin	plot <= 1'b1;	end
		else if(x==205 && y==94) begin	plot <= 1'b1;	end
		else if(x==206 && y==94) begin	plot <= 1'b1;	end
		else if(x==207 && y==94) begin	plot <= 1'b1;	end
		else if(x==107 && y==95) begin	plot <= 1'b1;	end
		else if(x==108 && y==95) begin	plot <= 1'b1;	end
		else if(x==109 && y==95) begin	plot <= 1'b1;	end
		else if(x==110 && y==95) begin	plot <= 1'b1;	end
		else if(x==118 && y==95) begin	plot <= 1'b1;	end
		else if(x==119 && y==95) begin	plot <= 1'b1;	end
		else if(x==120 && y==95) begin	plot <= 1'b1;	end
		else if(x==121 && y==95) begin	plot <= 1'b1;	end
		else if(x==122 && y==95) begin	plot <= 1'b1;	end
		else if(x==123 && y==95) begin	plot <= 1'b1;	end
		else if(x==124 && y==95) begin	plot <= 1'b1;	end
		else if(x==125 && y==95) begin	plot <= 1'b1;	end
		else if(x==126 && y==95) begin	plot <= 1'b1;	end
		else if(x==127 && y==95) begin	plot <= 1'b1;	end
		else if(x==128 && y==95) begin	plot <= 1'b1;	end
		else if(x==129 && y==95) begin	plot <= 1'b1;	end
		else if(x==130 && y==95) begin	plot <= 1'b1;	end
		else if(x==133 && y==95) begin	plot <= 1'b1;	end
		else if(x==134 && y==95) begin	plot <= 1'b1;	end
		else if(x==135 && y==95) begin	plot <= 1'b1;	end
		else if(x==136 && y==95) begin	plot <= 1'b1;	end
		else if(x==137 && y==95) begin	plot <= 1'b1;	end
		else if(x==138 && y==95) begin	plot <= 1'b1;	end
		else if(x==139 && y==95) begin	plot <= 1'b1;	end
		else if(x==140 && y==95) begin	plot <= 1'b1;	end
		else if(x==141 && y==95) begin	plot <= 1'b1;	end
		else if(x==142 && y==95) begin	plot <= 1'b1;	end
		else if(x==143 && y==95) begin	plot <= 1'b1;	end
		else if(x==144 && y==95) begin	plot <= 1'b1;	end
		else if(x==145 && y==95) begin	plot <= 1'b1;	end
		else if(x==163 && y==95) begin	plot <= 1'b1;	end
		else if(x==164 && y==95) begin	plot <= 1'b1;	end
		else if(x==165 && y==95) begin	plot <= 1'b1;	end
		else if(x==166 && y==95) begin	plot <= 1'b1;	end
		else if(x==167 && y==95) begin	plot <= 1'b1;	end
		else if(x==168 && y==95) begin	plot <= 1'b1;	end
		else if(x==171 && y==95) begin	plot <= 1'b1;	end
		else if(x==172 && y==95) begin	plot <= 1'b1;	end
		else if(x==173 && y==95) begin	plot <= 1'b1;	end
		else if(x==174 && y==95) begin	plot <= 1'b1;	end
		else if(x==175 && y==95) begin	plot <= 1'b1;	end
		else if(x==176 && y==95) begin	plot <= 1'b1;	end
		else if(x==177 && y==95) begin	plot <= 1'b1;	end
		else if(x==180 && y==95) begin	plot <= 1'b1;	end
		else if(x==181 && y==95) begin	plot <= 1'b1;	end
		else if(x==182 && y==95) begin	plot <= 1'b1;	end
		else if(x==183 && y==95) begin	plot <= 1'b1;	end
		else if(x==184 && y==95) begin	plot <= 1'b1;	end
		else if(x==185 && y==95) begin	plot <= 1'b1;	end
		else if(x==186 && y==95) begin	plot <= 1'b1;	end
		else if(x==187 && y==95) begin	plot <= 1'b1;	end
		else if(x==188 && y==95) begin	plot <= 1'b1;	end
		else if(x==189 && y==95) begin	plot <= 1'b1;	end
		else if(x==190 && y==95) begin	plot <= 1'b1;	end
		else if(x==191 && y==95) begin	plot <= 1'b1;	end
		else if(x==192 && y==95) begin	plot <= 1'b1;	end
		else if(x==195 && y==95) begin	plot <= 1'b1;	end
		else if(x==196 && y==95) begin	plot <= 1'b1;	end
		else if(x==197 && y==95) begin	plot <= 1'b1;	end
		else if(x==198 && y==95) begin	plot <= 1'b1;	end
		else if(x==204 && y==95) begin	plot <= 1'b1;	end
		else if(x==205 && y==95) begin	plot <= 1'b1;	end
		else if(x==206 && y==95) begin	plot <= 1'b1;	end
		else if(x==207 && y==95) begin	plot <= 1'b1;	end
		else if(x==107 && y==96) begin	plot <= 1'b1;	end
		else if(x==108 && y==96) begin	plot <= 1'b1;	end
		else if(x==109 && y==96) begin	plot <= 1'b1;	end
		else if(x==110 && y==96) begin	plot <= 1'b1;	end
		else if(x==118 && y==96) begin	plot <= 1'b1;	end
		else if(x==119 && y==96) begin	plot <= 1'b1;	end
		else if(x==120 && y==96) begin	plot <= 1'b1;	end
		else if(x==121 && y==96) begin	plot <= 1'b1;	end
		else if(x==122 && y==96) begin	plot <= 1'b1;	end
		else if(x==123 && y==96) begin	plot <= 1'b1;	end
		else if(x==124 && y==96) begin	plot <= 1'b1;	end
		else if(x==125 && y==96) begin	plot <= 1'b1;	end
		else if(x==126 && y==96) begin	plot <= 1'b1;	end
		else if(x==127 && y==96) begin	plot <= 1'b1;	end
		else if(x==128 && y==96) begin	plot <= 1'b1;	end
		else if(x==129 && y==96) begin	plot <= 1'b1;	end
		else if(x==130 && y==96) begin	plot <= 1'b1;	end
		else if(x==133 && y==96) begin	plot <= 1'b1;	end
		else if(x==134 && y==96) begin	plot <= 1'b1;	end
		else if(x==135 && y==96) begin	plot <= 1'b1;	end
		else if(x==136 && y==96) begin	plot <= 1'b1;	end
		else if(x==137 && y==96) begin	plot <= 1'b1;	end
		else if(x==138 && y==96) begin	plot <= 1'b1;	end
		else if(x==139 && y==96) begin	plot <= 1'b1;	end
		else if(x==140 && y==96) begin	plot <= 1'b1;	end
		else if(x==141 && y==96) begin	plot <= 1'b1;	end
		else if(x==142 && y==96) begin	plot <= 1'b1;	end
		else if(x==143 && y==96) begin	plot <= 1'b1;	end
		else if(x==144 && y==96) begin	plot <= 1'b1;	end
		else if(x==145 && y==96) begin	plot <= 1'b1;	end
		else if(x==163 && y==96) begin	plot <= 1'b1;	end
		else if(x==164 && y==96) begin	plot <= 1'b1;	end
		else if(x==165 && y==96) begin	plot <= 1'b1;	end
		else if(x==166 && y==96) begin	plot <= 1'b1;	end
		else if(x==167 && y==96) begin	plot <= 1'b1;	end
		else if(x==168 && y==96) begin	plot <= 1'b1;	end
		else if(x==172 && y==96) begin	plot <= 1'b1;	end
		else if(x==173 && y==96) begin	plot <= 1'b1;	end
		else if(x==174 && y==96) begin	plot <= 1'b1;	end
		else if(x==175 && y==96) begin	plot <= 1'b1;	end
		else if(x==176 && y==96) begin	plot <= 1'b1;	end
		else if(x==177 && y==96) begin	plot <= 1'b1;	end
		else if(x==180 && y==96) begin	plot <= 1'b1;	end
		else if(x==181 && y==96) begin	plot <= 1'b1;	end
		else if(x==182 && y==96) begin	plot <= 1'b1;	end
		else if(x==183 && y==96) begin	plot <= 1'b1;	end
		else if(x==184 && y==96) begin	plot <= 1'b1;	end
		else if(x==185 && y==96) begin	plot <= 1'b1;	end
		else if(x==186 && y==96) begin	plot <= 1'b1;	end
		else if(x==187 && y==96) begin	plot <= 1'b1;	end
		else if(x==188 && y==96) begin	plot <= 1'b1;	end
		else if(x==189 && y==96) begin	plot <= 1'b1;	end
		else if(x==190 && y==96) begin	plot <= 1'b1;	end
		else if(x==191 && y==96) begin	plot <= 1'b1;	end
		else if(x==192 && y==96) begin	plot <= 1'b1;	end
		else if(x==195 && y==96) begin	plot <= 1'b1;	end
		else if(x==196 && y==96) begin	plot <= 1'b1;	end
		else if(x==197 && y==96) begin	plot <= 1'b1;	end
		else if(x==198 && y==96) begin	plot <= 1'b1;	end
		else if(x==204 && y==96) begin	plot <= 1'b1;	end
		else if(x==205 && y==96) begin	plot <= 1'b1;	end
		else if(x==206 && y==96) begin	plot <= 1'b1;	end
		else if(x==207 && y==96) begin	plot <= 1'b1;	end
		else if(x==107 && y==97) begin	plot <= 1'b1;	end
		else if(x==108 && y==97) begin	plot <= 1'b1;	end
		else if(x==109 && y==97) begin	plot <= 1'b1;	end
		else if(x==110 && y==97) begin	plot <= 1'b1;	end
		else if(x==120 && y==97) begin	plot <= 1'b1;	end
		else if(x==121 && y==97) begin	plot <= 1'b1;	end
		else if(x==122 && y==97) begin	plot <= 1'b1;	end
		else if(x==123 && y==97) begin	plot <= 1'b1;	end
		else if(x==124 && y==97) begin	plot <= 1'b1;	end
		else if(x==125 && y==97) begin	plot <= 1'b1;	end
		else if(x==126 && y==97) begin	plot <= 1'b1;	end
		else if(x==127 && y==97) begin	plot <= 1'b1;	end
		else if(x==128 && y==97) begin	plot <= 1'b1;	end
		else if(x==135 && y==97) begin	plot <= 1'b1;	end
		else if(x==136 && y==97) begin	plot <= 1'b1;	end
		else if(x==137 && y==97) begin	plot <= 1'b1;	end
		else if(x==138 && y==97) begin	plot <= 1'b1;	end
		else if(x==139 && y==97) begin	plot <= 1'b1;	end
		else if(x==140 && y==97) begin	plot <= 1'b1;	end
		else if(x==141 && y==97) begin	plot <= 1'b1;	end
		else if(x==142 && y==97) begin	plot <= 1'b1;	end
		else if(x==143 && y==97) begin	plot <= 1'b1;	end
		else if(x==163 && y==97) begin	plot <= 1'b1;	end
		else if(x==164 && y==97) begin	plot <= 1'b1;	end
		else if(x==165 && y==97) begin	plot <= 1'b1;	end
		else if(x==166 && y==97) begin	plot <= 1'b1;	end
		else if(x==174 && y==97) begin	plot <= 1'b1;	end
		else if(x==175 && y==97) begin	plot <= 1'b1;	end
		else if(x==176 && y==97) begin	plot <= 1'b1;	end
		else if(x==177 && y==97) begin	plot <= 1'b1;	end
		else if(x==180 && y==97) begin	plot <= 1'b1;	end
		else if(x==181 && y==97) begin	plot <= 1'b1;	end
		else if(x==182 && y==97) begin	plot <= 1'b1;	end
		else if(x==183 && y==97) begin	plot <= 1'b1;	end
		else if(x==184 && y==97) begin	plot <= 1'b1;	end
		else if(x==185 && y==97) begin	plot <= 1'b1;	end
		else if(x==186 && y==97) begin	plot <= 1'b1;	end
		else if(x==187 && y==97) begin	plot <= 1'b1;	end
		else if(x==188 && y==97) begin	plot <= 1'b1;	end
		else if(x==189 && y==97) begin	plot <= 1'b1;	end
		else if(x==190 && y==97) begin	plot <= 1'b1;	end
		else if(x==191 && y==97) begin	plot <= 1'b1;	end
		else if(x==192 && y==97) begin	plot <= 1'b1;	end
		else if(x==195 && y==97) begin	plot <= 1'b1;	end
		else if(x==196 && y==97) begin	plot <= 1'b1;	end
		else if(x==197 && y==97) begin	plot <= 1'b1;	end
		else if(x==198 && y==97) begin	plot <= 1'b1;	end
		else if(x==204 && y==97) begin	plot <= 1'b1;	end
		else if(x==205 && y==97) begin	plot <= 1'b1;	end
		else if(x==206 && y==97) begin	plot <= 1'b1;	end
		else if(x==207 && y==97) begin	plot <= 1'b1;	end
		else if(x==107 && y==98) begin	plot <= 1'b1;	end
		else if(x==108 && y==98) begin	plot <= 1'b1;	end
		else if(x==109 && y==98) begin	plot <= 1'b1;	end
		else if(x==110 && y==98) begin	plot <= 1'b1;	end
		else if(x==120 && y==98) begin	plot <= 1'b1;	end
		else if(x==121 && y==98) begin	plot <= 1'b1;	end
		else if(x==122 && y==98) begin	plot <= 1'b1;	end
		else if(x==123 && y==98) begin	plot <= 1'b1;	end
		else if(x==124 && y==98) begin	plot <= 1'b1;	end
		else if(x==125 && y==98) begin	plot <= 1'b1;	end
		else if(x==126 && y==98) begin	plot <= 1'b1;	end
		else if(x==127 && y==98) begin	plot <= 1'b1;	end
		else if(x==135 && y==98) begin	plot <= 1'b1;	end
		else if(x==136 && y==98) begin	plot <= 1'b1;	end
		else if(x==137 && y==98) begin	plot <= 1'b1;	end
		else if(x==138 && y==98) begin	plot <= 1'b1;	end
		else if(x==139 && y==98) begin	plot <= 1'b1;	end
		else if(x==140 && y==98) begin	plot <= 1'b1;	end
		else if(x==141 && y==98) begin	plot <= 1'b1;	end
		else if(x==142 && y==98) begin	plot <= 1'b1;	end
		else if(x==163 && y==98) begin	plot <= 1'b1;	end
		else if(x==164 && y==98) begin	plot <= 1'b1;	end
		else if(x==165 && y==98) begin	plot <= 1'b1;	end
		else if(x==166 && y==98) begin	plot <= 1'b1;	end
		else if(x==174 && y==98) begin	plot <= 1'b1;	end
		else if(x==175 && y==98) begin	plot <= 1'b1;	end
		else if(x==176 && y==98) begin	plot <= 1'b1;	end
		else if(x==177 && y==98) begin	plot <= 1'b1;	end
		else if(x==180 && y==98) begin	plot <= 1'b1;	end
		else if(x==181 && y==98) begin	plot <= 1'b1;	end
		else if(x==182 && y==98) begin	plot <= 1'b1;	end
		else if(x==183 && y==98) begin	plot <= 1'b1;	end
		else if(x==184 && y==98) begin	plot <= 1'b1;	end
		else if(x==185 && y==98) begin	plot <= 1'b1;	end
		else if(x==186 && y==98) begin	plot <= 1'b1;	end
		else if(x==187 && y==98) begin	plot <= 1'b1;	end
		else if(x==188 && y==98) begin	plot <= 1'b1;	end
		else if(x==189 && y==98) begin	plot <= 1'b1;	end
		else if(x==190 && y==98) begin	plot <= 1'b1;	end
		else if(x==191 && y==98) begin	plot <= 1'b1;	end
		else if(x==192 && y==98) begin	plot <= 1'b1;	end
		else if(x==195 && y==98) begin	plot <= 1'b1;	end
		else if(x==196 && y==98) begin	plot <= 1'b1;	end
		else if(x==197 && y==98) begin	plot <= 1'b1;	end
		else if(x==198 && y==98) begin	plot <= 1'b1;	end
		else if(x==204 && y==98) begin	plot <= 1'b1;	end
		else if(x==205 && y==98) begin	plot <= 1'b1;	end
		else if(x==206 && y==98) begin	plot <= 1'b1;	end
		else if(x==207 && y==98) begin	plot <= 1'b1;	end
		else if(x==92 && y==170) begin	plot <= 1'b1;	end
		else if(x==93 && y==170) begin	plot <= 1'b1;	end
		else if(x==94 && y==170) begin	plot <= 1'b1;	end
		else if(x==95 && y==170) begin	plot <= 1'b1;	end
		else if(x==96 && y==170) begin	plot <= 1'b1;	end
		else if(x==97 && y==170) begin	plot <= 1'b1;	end
		else if(x==119 && y==170) begin	plot <= 1'b1;	end
		else if(x==127 && y==170) begin	plot <= 1'b1;	end
		else if(x==128 && y==170) begin	plot <= 1'b1;	end
		else if(x==129 && y==170) begin	plot <= 1'b1;	end
		else if(x==130 && y==170) begin	plot <= 1'b1;	end
		else if(x==131 && y==170) begin	plot <= 1'b1;	end
		else if(x==132 && y==170) begin	plot <= 1'b1;	end
		else if(x==143 && y==170) begin	plot <= 1'b1;	end
		else if(x==144 && y==170) begin	plot <= 1'b1;	end
		else if(x==145 && y==170) begin	plot <= 1'b1;	end
		else if(x==146 && y==170) begin	plot <= 1'b1;	end
		else if(x==147 && y==170) begin	plot <= 1'b1;	end
		else if(x==92 && y==171) begin	plot <= 1'b1;	end
		else if(x==93 && y==171) begin	plot <= 1'b1;	end
		else if(x==94 && y==171) begin	plot <= 1'b1;	end
		else if(x==95 && y==171) begin	plot <= 1'b1;	end
		else if(x==96 && y==171) begin	plot <= 1'b1;	end
		else if(x==97 && y==171) begin	plot <= 1'b1;	end
		else if(x==98 && y==171) begin	plot <= 1'b1;	end
		else if(x==102 && y==171) begin	plot <= 1'b1;	end
		else if(x==103 && y==171) begin	plot <= 1'b1;	end
		else if(x==111 && y==171) begin	plot <= 1'b1;	end
		else if(x==112 && y==171) begin	plot <= 1'b1;	end
		else if(x==118 && y==171) begin	plot <= 1'b1;	end
		else if(x==119 && y==171) begin	plot <= 1'b1;	end
		else if(x==120 && y==171) begin	plot <= 1'b1;	end
		else if(x==126 && y==171) begin	plot <= 1'b1;	end
		else if(x==127 && y==171) begin	plot <= 1'b1;	end
		else if(x==128 && y==171) begin	plot <= 1'b1;	end
		else if(x==129 && y==171) begin	plot <= 1'b1;	end
		else if(x==130 && y==171) begin	plot <= 1'b1;	end
		else if(x==131 && y==171) begin	plot <= 1'b1;	end
		else if(x==132 && y==171) begin	plot <= 1'b1;	end
		else if(x==133 && y==171) begin	plot <= 1'b1;	end
		else if(x==142 && y==171) begin	plot <= 1'b1;	end
		else if(x==143 && y==171) begin	plot <= 1'b1;	end
		else if(x==144 && y==171) begin	plot <= 1'b1;	end
		else if(x==145 && y==171) begin	plot <= 1'b1;	end
		else if(x==146 && y==171) begin	plot <= 1'b1;	end
		else if(x==147 && y==171) begin	plot <= 1'b1;	end
		else if(x==148 && y==171) begin	plot <= 1'b1;	end
		else if(x==153 && y==171) begin	plot <= 1'b1;	end
		else if(x==154 && y==171) begin	plot <= 1'b1;	end
		else if(x==210 && y==171) begin	plot <= 1'b1;	end
		else if(x==211 && y==171) begin	plot <= 1'b1;	end
		else if(x==91 && y==172) begin	plot <= 1'b1;	end
		else if(x==92 && y==172) begin	plot <= 1'b1;	end
		else if(x==93 && y==172) begin	plot <= 1'b1;	end
		else if(x==94 && y==172) begin	plot <= 1'b1;	end
		else if(x==95 && y==172) begin	plot <= 1'b1;	end
		else if(x==96 && y==172) begin	plot <= 1'b1;	end
		else if(x==97 && y==172) begin	plot <= 1'b1;	end
		else if(x==98 && y==172) begin	plot <= 1'b1;	end
		else if(x==99 && y==172) begin	plot <= 1'b1;	end
		else if(x==102 && y==172) begin	plot <= 1'b1;	end
		else if(x==103 && y==172) begin	plot <= 1'b1;	end
		else if(x==111 && y==172) begin	plot <= 1'b1;	end
		else if(x==112 && y==172) begin	plot <= 1'b1;	end
		else if(x==117 && y==172) begin	plot <= 1'b1;	end
		else if(x==118 && y==172) begin	plot <= 1'b1;	end
		else if(x==119 && y==172) begin	plot <= 1'b1;	end
		else if(x==120 && y==172) begin	plot <= 1'b1;	end
		else if(x==126 && y==172) begin	plot <= 1'b1;	end
		else if(x==127 && y==172) begin	plot <= 1'b1;	end
		else if(x==128 && y==172) begin	plot <= 1'b1;	end
		else if(x==129 && y==172) begin	plot <= 1'b1;	end
		else if(x==130 && y==172) begin	plot <= 1'b1;	end
		else if(x==131 && y==172) begin	plot <= 1'b1;	end
		else if(x==132 && y==172) begin	plot <= 1'b1;	end
		else if(x==133 && y==172) begin	plot <= 1'b1;	end
		else if(x==142 && y==172) begin	plot <= 1'b1;	end
		else if(x==143 && y==172) begin	plot <= 1'b1;	end
		else if(x==144 && y==172) begin	plot <= 1'b1;	end
		else if(x==145 && y==172) begin	plot <= 1'b1;	end
		else if(x==146 && y==172) begin	plot <= 1'b1;	end
		else if(x==147 && y==172) begin	plot <= 1'b1;	end
		else if(x==148 && y==172) begin	plot <= 1'b1;	end
		else if(x==149 && y==172) begin	plot <= 1'b1;	end
		else if(x==153 && y==172) begin	plot <= 1'b1;	end
		else if(x==154 && y==172) begin	plot <= 1'b1;	end
		else if(x==210 && y==172) begin	plot <= 1'b1;	end
		else if(x==211 && y==172) begin	plot <= 1'b1;	end
		else if(x==91 && y==173) begin	plot <= 1'b1;	end
		else if(x==92 && y==173) begin	plot <= 1'b1;	end
		else if(x==97 && y==173) begin	plot <= 1'b1;	end
		else if(x==98 && y==173) begin	plot <= 1'b1;	end
		else if(x==99 && y==173) begin	plot <= 1'b1;	end
		else if(x==102 && y==173) begin	plot <= 1'b1;	end
		else if(x==103 && y==173) begin	plot <= 1'b1;	end
		else if(x==111 && y==173) begin	plot <= 1'b1;	end
		else if(x==112 && y==173) begin	plot <= 1'b1;	end
		else if(x==116 && y==173) begin	plot <= 1'b1;	end
		else if(x==117 && y==173) begin	plot <= 1'b1;	end
		else if(x==118 && y==173) begin	plot <= 1'b1;	end
		else if(x==119 && y==173) begin	plot <= 1'b1;	end
		else if(x==120 && y==173) begin	plot <= 1'b1;	end
		else if(x==131 && y==173) begin	plot <= 1'b1;	end
		else if(x==132 && y==173) begin	plot <= 1'b1;	end
		else if(x==133 && y==173) begin	plot <= 1'b1;	end
		else if(x==142 && y==173) begin	plot <= 1'b1;	end
		else if(x==143 && y==173) begin	plot <= 1'b1;	end
		else if(x==144 && y==173) begin	plot <= 1'b1;	end
		else if(x==148 && y==173) begin	plot <= 1'b1;	end
		else if(x==149 && y==173) begin	plot <= 1'b1;	end
		else if(x==153 && y==173) begin	plot <= 1'b1;	end
		else if(x==154 && y==173) begin	plot <= 1'b1;	end
		else if(x==91 && y==174) begin	plot <= 1'b1;	end
		else if(x==92 && y==174) begin	plot <= 1'b1;	end
		else if(x==102 && y==174) begin	plot <= 1'b1;	end
		else if(x==103 && y==174) begin	plot <= 1'b1;	end
		else if(x==107 && y==174) begin	plot <= 1'b1;	end
		else if(x==111 && y==174) begin	plot <= 1'b1;	end
		else if(x==112 && y==174) begin	plot <= 1'b1;	end
		else if(x==117 && y==174) begin	plot <= 1'b1;	end
		else if(x==118 && y==174) begin	plot <= 1'b1;	end
		else if(x==119 && y==174) begin	plot <= 1'b1;	end
		else if(x==120 && y==174) begin	plot <= 1'b1;	end
		else if(x==131 && y==174) begin	plot <= 1'b1;	end
		else if(x==132 && y==174) begin	plot <= 1'b1;	end
		else if(x==133 && y==174) begin	plot <= 1'b1;	end
		else if(x==142 && y==174) begin	plot <= 1'b1;	end
		else if(x==143 && y==174) begin	plot <= 1'b1;	end
		else if(x==144 && y==174) begin	plot <= 1'b1;	end
		else if(x==148 && y==174) begin	plot <= 1'b1;	end
		else if(x==149 && y==174) begin	plot <= 1'b1;	end
		else if(x==153 && y==174) begin	plot <= 1'b1;	end
		else if(x==154 && y==174) begin	plot <= 1'b1;	end
		else if(x==159 && y==174) begin	plot <= 1'b1;	end
		else if(x==160 && y==174) begin	plot <= 1'b1;	end
		else if(x==161 && y==174) begin	plot <= 1'b1;	end
		else if(x==162 && y==174) begin	plot <= 1'b1;	end
		else if(x==167 && y==174) begin	plot <= 1'b1;	end
		else if(x==171 && y==174) begin	plot <= 1'b1;	end
		else if(x==172 && y==174) begin	plot <= 1'b1;	end
		else if(x==183 && y==174) begin	plot <= 1'b1;	end
		else if(x==184 && y==174) begin	plot <= 1'b1;	end
		else if(x==185 && y==174) begin	plot <= 1'b1;	end
		else if(x==186 && y==174) begin	plot <= 1'b1;	end
		else if(x==192 && y==174) begin	plot <= 1'b1;	end
		else if(x==193 && y==174) begin	plot <= 1'b1;	end
		else if(x==194 && y==174) begin	plot <= 1'b1;	end
		else if(x==196 && y==174) begin	plot <= 1'b1;	end
		else if(x==197 && y==174) begin	plot <= 1'b1;	end
		else if(x==202 && y==174) begin	plot <= 1'b1;	end
		else if(x==203 && y==174) begin	plot <= 1'b1;	end
		else if(x==204 && y==174) begin	plot <= 1'b1;	end
		else if(x==205 && y==174) begin	plot <= 1'b1;	end
		else if(x==210 && y==174) begin	plot <= 1'b1;	end
		else if(x==211 && y==174) begin	plot <= 1'b1;	end
		else if(x==215 && y==174) begin	plot <= 1'b1;	end
		else if(x==216 && y==174) begin	plot <= 1'b1;	end
		else if(x==217 && y==174) begin	plot <= 1'b1;	end
		else if(x==218 && y==174) begin	plot <= 1'b1;	end
		else if(x==219 && y==174) begin	plot <= 1'b1;	end
		else if(x==91 && y==175) begin	plot <= 1'b1;	end
		else if(x==92 && y==175) begin	plot <= 1'b1;	end
		else if(x==93 && y==175) begin	plot <= 1'b1;	end
		else if(x==94 && y==175) begin	plot <= 1'b1;	end
		else if(x==95 && y==175) begin	plot <= 1'b1;	end
		else if(x==96 && y==175) begin	plot <= 1'b1;	end
		else if(x==97 && y==175) begin	plot <= 1'b1;	end
		else if(x==98 && y==175) begin	plot <= 1'b1;	end
		else if(x==102 && y==175) begin	plot <= 1'b1;	end
		else if(x==103 && y==175) begin	plot <= 1'b1;	end
		else if(x==106 && y==175) begin	plot <= 1'b1;	end
		else if(x==107 && y==175) begin	plot <= 1'b1;	end
		else if(x==108 && y==175) begin	plot <= 1'b1;	end
		else if(x==111 && y==175) begin	plot <= 1'b1;	end
		else if(x==112 && y==175) begin	plot <= 1'b1;	end
		else if(x==119 && y==175) begin	plot <= 1'b1;	end
		else if(x==120 && y==175) begin	plot <= 1'b1;	end
		else if(x==130 && y==175) begin	plot <= 1'b1;	end
		else if(x==131 && y==175) begin	plot <= 1'b1;	end
		else if(x==132 && y==175) begin	plot <= 1'b1;	end
		else if(x==142 && y==175) begin	plot <= 1'b1;	end
		else if(x==143 && y==175) begin	plot <= 1'b1;	end
		else if(x==144 && y==175) begin	plot <= 1'b1;	end
		else if(x==148 && y==175) begin	plot <= 1'b1;	end
		else if(x==149 && y==175) begin	plot <= 1'b1;	end
		else if(x==153 && y==175) begin	plot <= 1'b1;	end
		else if(x==154 && y==175) begin	plot <= 1'b1;	end
		else if(x==157 && y==175) begin	plot <= 1'b1;	end
		else if(x==158 && y==175) begin	plot <= 1'b1;	end
		else if(x==159 && y==175) begin	plot <= 1'b1;	end
		else if(x==160 && y==175) begin	plot <= 1'b1;	end
		else if(x==161 && y==175) begin	plot <= 1'b1;	end
		else if(x==162 && y==175) begin	plot <= 1'b1;	end
		else if(x==163 && y==175) begin	plot <= 1'b1;	end
		else if(x==166 && y==175) begin	plot <= 1'b1;	end
		else if(x==167 && y==175) begin	plot <= 1'b1;	end
		else if(x==168 && y==175) begin	plot <= 1'b1;	end
		else if(x==171 && y==175) begin	plot <= 1'b1;	end
		else if(x==172 && y==175) begin	plot <= 1'b1;	end
		else if(x==181 && y==175) begin	plot <= 1'b1;	end
		else if(x==182 && y==175) begin	plot <= 1'b1;	end
		else if(x==183 && y==175) begin	plot <= 1'b1;	end
		else if(x==184 && y==175) begin	plot <= 1'b1;	end
		else if(x==185 && y==175) begin	plot <= 1'b1;	end
		else if(x==186 && y==175) begin	plot <= 1'b1;	end
		else if(x==187 && y==175) begin	plot <= 1'b1;	end
		else if(x==190 && y==175) begin	plot <= 1'b1;	end
		else if(x==191 && y==175) begin	plot <= 1'b1;	end
		else if(x==192 && y==175) begin	plot <= 1'b1;	end
		else if(x==193 && y==175) begin	plot <= 1'b1;	end
		else if(x==194 && y==175) begin	plot <= 1'b1;	end
		else if(x==195 && y==175) begin	plot <= 1'b1;	end
		else if(x==196 && y==175) begin	plot <= 1'b1;	end
		else if(x==197 && y==175) begin	plot <= 1'b1;	end
		else if(x==201 && y==175) begin	plot <= 1'b1;	end
		else if(x==202 && y==175) begin	plot <= 1'b1;	end
		else if(x==203 && y==175) begin	plot <= 1'b1;	end
		else if(x==204 && y==175) begin	plot <= 1'b1;	end
		else if(x==205 && y==175) begin	plot <= 1'b1;	end
		else if(x==206 && y==175) begin	plot <= 1'b1;	end
		else if(x==207 && y==175) begin	plot <= 1'b1;	end
		else if(x==210 && y==175) begin	plot <= 1'b1;	end
		else if(x==211 && y==175) begin	plot <= 1'b1;	end
		else if(x==214 && y==175) begin	plot <= 1'b1;	end
		else if(x==215 && y==175) begin	plot <= 1'b1;	end
		else if(x==216 && y==175) begin	plot <= 1'b1;	end
		else if(x==217 && y==175) begin	plot <= 1'b1;	end
		else if(x==218 && y==175) begin	plot <= 1'b1;	end
		else if(x==219 && y==175) begin	plot <= 1'b1;	end
		else if(x==220 && y==175) begin	plot <= 1'b1;	end
		else if(x==92 && y==176) begin	plot <= 1'b1;	end
		else if(x==93 && y==176) begin	plot <= 1'b1;	end
		else if(x==94 && y==176) begin	plot <= 1'b1;	end
		else if(x==95 && y==176) begin	plot <= 1'b1;	end
		else if(x==96 && y==176) begin	plot <= 1'b1;	end
		else if(x==97 && y==176) begin	plot <= 1'b1;	end
		else if(x==98 && y==176) begin	plot <= 1'b1;	end
		else if(x==102 && y==176) begin	plot <= 1'b1;	end
		else if(x==103 && y==176) begin	plot <= 1'b1;	end
		else if(x==106 && y==176) begin	plot <= 1'b1;	end
		else if(x==107 && y==176) begin	plot <= 1'b1;	end
		else if(x==108 && y==176) begin	plot <= 1'b1;	end
		else if(x==111 && y==176) begin	plot <= 1'b1;	end
		else if(x==112 && y==176) begin	plot <= 1'b1;	end
		else if(x==119 && y==176) begin	plot <= 1'b1;	end
		else if(x==120 && y==176) begin	plot <= 1'b1;	end
		else if(x==129 && y==176) begin	plot <= 1'b1;	end
		else if(x==130 && y==176) begin	plot <= 1'b1;	end
		else if(x==131 && y==176) begin	plot <= 1'b1;	end
		else if(x==142 && y==176) begin	plot <= 1'b1;	end
		else if(x==143 && y==176) begin	plot <= 1'b1;	end
		else if(x==144 && y==176) begin	plot <= 1'b1;	end
		else if(x==145 && y==176) begin	plot <= 1'b1;	end
		else if(x==146 && y==176) begin	plot <= 1'b1;	end
		else if(x==147 && y==176) begin	plot <= 1'b1;	end
		else if(x==148 && y==176) begin	plot <= 1'b1;	end
		else if(x==149 && y==176) begin	plot <= 1'b1;	end
		else if(x==153 && y==176) begin	plot <= 1'b1;	end
		else if(x==154 && y==176) begin	plot <= 1'b1;	end
		else if(x==157 && y==176) begin	plot <= 1'b1;	end
		else if(x==158 && y==176) begin	plot <= 1'b1;	end
		else if(x==159 && y==176) begin	plot <= 1'b1;	end
		else if(x==160 && y==176) begin	plot <= 1'b1;	end
		else if(x==161 && y==176) begin	plot <= 1'b1;	end
		else if(x==162 && y==176) begin	plot <= 1'b1;	end
		else if(x==163 && y==176) begin	plot <= 1'b1;	end
		else if(x==166 && y==176) begin	plot <= 1'b1;	end
		else if(x==167 && y==176) begin	plot <= 1'b1;	end
		else if(x==168 && y==176) begin	plot <= 1'b1;	end
		else if(x==171 && y==176) begin	plot <= 1'b1;	end
		else if(x==172 && y==176) begin	plot <= 1'b1;	end
		else if(x==181 && y==176) begin	plot <= 1'b1;	end
		else if(x==182 && y==176) begin	plot <= 1'b1;	end
		else if(x==183 && y==176) begin	plot <= 1'b1;	end
		else if(x==184 && y==176) begin	plot <= 1'b1;	end
		else if(x==185 && y==176) begin	plot <= 1'b1;	end
		else if(x==186 && y==176) begin	plot <= 1'b1;	end
		else if(x==187 && y==176) begin	plot <= 1'b1;	end
		else if(x==190 && y==176) begin	plot <= 1'b1;	end
		else if(x==191 && y==176) begin	plot <= 1'b1;	end
		else if(x==192 && y==176) begin	plot <= 1'b1;	end
		else if(x==193 && y==176) begin	plot <= 1'b1;	end
		else if(x==194 && y==176) begin	plot <= 1'b1;	end
		else if(x==195 && y==176) begin	plot <= 1'b1;	end
		else if(x==196 && y==176) begin	plot <= 1'b1;	end
		else if(x==197 && y==176) begin	plot <= 1'b1;	end
		else if(x==201 && y==176) begin	plot <= 1'b1;	end
		else if(x==202 && y==176) begin	plot <= 1'b1;	end
		else if(x==203 && y==176) begin	plot <= 1'b1;	end
		else if(x==204 && y==176) begin	plot <= 1'b1;	end
		else if(x==205 && y==176) begin	plot <= 1'b1;	end
		else if(x==206 && y==176) begin	plot <= 1'b1;	end
		else if(x==207 && y==176) begin	plot <= 1'b1;	end
		else if(x==210 && y==176) begin	plot <= 1'b1;	end
		else if(x==211 && y==176) begin	plot <= 1'b1;	end
		else if(x==214 && y==176) begin	plot <= 1'b1;	end
		else if(x==215 && y==176) begin	plot <= 1'b1;	end
		else if(x==216 && y==176) begin	plot <= 1'b1;	end
		else if(x==217 && y==176) begin	plot <= 1'b1;	end
		else if(x==218 && y==176) begin	plot <= 1'b1;	end
		else if(x==219 && y==176) begin	plot <= 1'b1;	end
		else if(x==220 && y==176) begin	plot <= 1'b1;	end
		else if(x==97 && y==177) begin	plot <= 1'b1;	end
		else if(x==98 && y==177) begin	plot <= 1'b1;	end
		else if(x==99 && y==177) begin	plot <= 1'b1;	end
		else if(x==102 && y==177) begin	plot <= 1'b1;	end
		else if(x==103 && y==177) begin	plot <= 1'b1;	end
		else if(x==106 && y==177) begin	plot <= 1'b1;	end
		else if(x==107 && y==177) begin	plot <= 1'b1;	end
		else if(x==108 && y==177) begin	plot <= 1'b1;	end
		else if(x==111 && y==177) begin	plot <= 1'b1;	end
		else if(x==112 && y==177) begin	plot <= 1'b1;	end
		else if(x==119 && y==177) begin	plot <= 1'b1;	end
		else if(x==120 && y==177) begin	plot <= 1'b1;	end
		else if(x==128 && y==177) begin	plot <= 1'b1;	end
		else if(x==129 && y==177) begin	plot <= 1'b1;	end
		else if(x==130 && y==177) begin	plot <= 1'b1;	end
		else if(x==142 && y==177) begin	plot <= 1'b1;	end
		else if(x==143 && y==177) begin	plot <= 1'b1;	end
		else if(x==144 && y==177) begin	plot <= 1'b1;	end
		else if(x==145 && y==177) begin	plot <= 1'b1;	end
		else if(x==146 && y==177) begin	plot <= 1'b1;	end
		else if(x==147 && y==177) begin	plot <= 1'b1;	end
		else if(x==148 && y==177) begin	plot <= 1'b1;	end
		else if(x==149 && y==177) begin	plot <= 1'b1;	end
		else if(x==153 && y==177) begin	plot <= 1'b1;	end
		else if(x==154 && y==177) begin	plot <= 1'b1;	end
		else if(x==157 && y==177) begin	plot <= 1'b1;	end
		else if(x==158 && y==177) begin	plot <= 1'b1;	end
		else if(x==159 && y==177) begin	plot <= 1'b1;	end
		else if(x==162 && y==177) begin	plot <= 1'b1;	end
		else if(x==163 && y==177) begin	plot <= 1'b1;	end
		else if(x==166 && y==177) begin	plot <= 1'b1;	end
		else if(x==167 && y==177) begin	plot <= 1'b1;	end
		else if(x==168 && y==177) begin	plot <= 1'b1;	end
		else if(x==171 && y==177) begin	plot <= 1'b1;	end
		else if(x==172 && y==177) begin	plot <= 1'b1;	end
		else if(x==181 && y==177) begin	plot <= 1'b1;	end
		else if(x==182 && y==177) begin	plot <= 1'b1;	end
		else if(x==183 && y==177) begin	plot <= 1'b1;	end
		else if(x==186 && y==177) begin	plot <= 1'b1;	end
		else if(x==187 && y==177) begin	plot <= 1'b1;	end
		else if(x==190 && y==177) begin	plot <= 1'b1;	end
		else if(x==191 && y==177) begin	plot <= 1'b1;	end
		else if(x==192 && y==177) begin	plot <= 1'b1;	end
		else if(x==196 && y==177) begin	plot <= 1'b1;	end
		else if(x==197 && y==177) begin	plot <= 1'b1;	end
		else if(x==201 && y==177) begin	plot <= 1'b1;	end
		else if(x==202 && y==177) begin	plot <= 1'b1;	end
		else if(x==205 && y==177) begin	plot <= 1'b1;	end
		else if(x==206 && y==177) begin	plot <= 1'b1;	end
		else if(x==207 && y==177) begin	plot <= 1'b1;	end
		else if(x==210 && y==177) begin	plot <= 1'b1;	end
		else if(x==211 && y==177) begin	plot <= 1'b1;	end
		else if(x==214 && y==177) begin	plot <= 1'b1;	end
		else if(x==215 && y==177) begin	plot <= 1'b1;	end
		else if(x==216 && y==177) begin	plot <= 1'b1;	end
		else if(x==219 && y==177) begin	plot <= 1'b1;	end
		else if(x==220 && y==177) begin	plot <= 1'b1;	end
		else if(x==97 && y==178) begin	plot <= 1'b1;	end
		else if(x==98 && y==178) begin	plot <= 1'b1;	end
		else if(x==99 && y==178) begin	plot <= 1'b1;	end
		else if(x==102 && y==178) begin	plot <= 1'b1;	end
		else if(x==103 && y==178) begin	plot <= 1'b1;	end
		else if(x==106 && y==178) begin	plot <= 1'b1;	end
		else if(x==107 && y==178) begin	plot <= 1'b1;	end
		else if(x==108 && y==178) begin	plot <= 1'b1;	end
		else if(x==111 && y==178) begin	plot <= 1'b1;	end
		else if(x==112 && y==178) begin	plot <= 1'b1;	end
		else if(x==119 && y==178) begin	plot <= 1'b1;	end
		else if(x==120 && y==178) begin	plot <= 1'b1;	end
		else if(x==128 && y==178) begin	plot <= 1'b1;	end
		else if(x==129 && y==178) begin	plot <= 1'b1;	end
		else if(x==142 && y==178) begin	plot <= 1'b1;	end
		else if(x==143 && y==178) begin	plot <= 1'b1;	end
		else if(x==144 && y==178) begin	plot <= 1'b1;	end
		else if(x==145 && y==178) begin	plot <= 1'b1;	end
		else if(x==146 && y==178) begin	plot <= 1'b1;	end
		else if(x==147 && y==178) begin	plot <= 1'b1;	end
		else if(x==148 && y==178) begin	plot <= 1'b1;	end
		else if(x==153 && y==178) begin	plot <= 1'b1;	end
		else if(x==154 && y==178) begin	plot <= 1'b1;	end
		else if(x==157 && y==178) begin	plot <= 1'b1;	end
		else if(x==158 && y==178) begin	plot <= 1'b1;	end
		else if(x==159 && y==178) begin	plot <= 1'b1;	end
		else if(x==162 && y==178) begin	plot <= 1'b1;	end
		else if(x==163 && y==178) begin	plot <= 1'b1;	end
		else if(x==166 && y==178) begin	plot <= 1'b1;	end
		else if(x==167 && y==178) begin	plot <= 1'b1;	end
		else if(x==168 && y==178) begin	plot <= 1'b1;	end
		else if(x==171 && y==178) begin	plot <= 1'b1;	end
		else if(x==172 && y==178) begin	plot <= 1'b1;	end
		else if(x==181 && y==178) begin	plot <= 1'b1;	end
		else if(x==182 && y==178) begin	plot <= 1'b1;	end
		else if(x==183 && y==178) begin	plot <= 1'b1;	end
		else if(x==186 && y==178) begin	plot <= 1'b1;	end
		else if(x==187 && y==178) begin	plot <= 1'b1;	end
		else if(x==190 && y==178) begin	plot <= 1'b1;	end
		else if(x==191 && y==178) begin	plot <= 1'b1;	end
		else if(x==192 && y==178) begin	plot <= 1'b1;	end
		else if(x==196 && y==178) begin	plot <= 1'b1;	end
		else if(x==197 && y==178) begin	plot <= 1'b1;	end
		else if(x==201 && y==178) begin	plot <= 1'b1;	end
		else if(x==202 && y==178) begin	plot <= 1'b1;	end
		else if(x==205 && y==178) begin	plot <= 1'b1;	end
		else if(x==206 && y==178) begin	plot <= 1'b1;	end
		else if(x==207 && y==178) begin	plot <= 1'b1;	end
		else if(x==210 && y==178) begin	plot <= 1'b1;	end
		else if(x==211 && y==178) begin	plot <= 1'b1;	end
		else if(x==214 && y==178) begin	plot <= 1'b1;	end
		else if(x==215 && y==178) begin	plot <= 1'b1;	end
		else if(x==216 && y==178) begin	plot <= 1'b1;	end
		else if(x==219 && y==178) begin	plot <= 1'b1;	end
		else if(x==220 && y==178) begin	plot <= 1'b1;	end
		else if(x==97 && y==179) begin	plot <= 1'b1;	end
		else if(x==98 && y==179) begin	plot <= 1'b1;	end
		else if(x==99 && y==179) begin	plot <= 1'b1;	end
		else if(x==102 && y==179) begin	plot <= 1'b1;	end
		else if(x==103 && y==179) begin	plot <= 1'b1;	end
		else if(x==106 && y==179) begin	plot <= 1'b1;	end
		else if(x==107 && y==179) begin	plot <= 1'b1;	end
		else if(x==108 && y==179) begin	plot <= 1'b1;	end
		else if(x==111 && y==179) begin	plot <= 1'b1;	end
		else if(x==112 && y==179) begin	plot <= 1'b1;	end
		else if(x==119 && y==179) begin	plot <= 1'b1;	end
		else if(x==120 && y==179) begin	plot <= 1'b1;	end
		else if(x==128 && y==179) begin	plot <= 1'b1;	end
		else if(x==129 && y==179) begin	plot <= 1'b1;	end
		else if(x==142 && y==179) begin	plot <= 1'b1;	end
		else if(x==143 && y==179) begin	plot <= 1'b1;	end
		else if(x==144 && y==179) begin	plot <= 1'b1;	end
		else if(x==153 && y==179) begin	plot <= 1'b1;	end
		else if(x==154 && y==179) begin	plot <= 1'b1;	end
		else if(x==157 && y==179) begin	plot <= 1'b1;	end
		else if(x==158 && y==179) begin	plot <= 1'b1;	end
		else if(x==159 && y==179) begin	plot <= 1'b1;	end
		else if(x==162 && y==179) begin	plot <= 1'b1;	end
		else if(x==163 && y==179) begin	plot <= 1'b1;	end
		else if(x==166 && y==179) begin	plot <= 1'b1;	end
		else if(x==167 && y==179) begin	plot <= 1'b1;	end
		else if(x==168 && y==179) begin	plot <= 1'b1;	end
		else if(x==171 && y==179) begin	plot <= 1'b1;	end
		else if(x==172 && y==179) begin	plot <= 1'b1;	end
		else if(x==181 && y==179) begin	plot <= 1'b1;	end
		else if(x==182 && y==179) begin	plot <= 1'b1;	end
		else if(x==183 && y==179) begin	plot <= 1'b1;	end
		else if(x==186 && y==179) begin	plot <= 1'b1;	end
		else if(x==187 && y==179) begin	plot <= 1'b1;	end
		else if(x==190 && y==179) begin	plot <= 1'b1;	end
		else if(x==191 && y==179) begin	plot <= 1'b1;	end
		else if(x==192 && y==179) begin	plot <= 1'b1;	end
		else if(x==196 && y==179) begin	plot <= 1'b1;	end
		else if(x==197 && y==179) begin	plot <= 1'b1;	end
		else if(x==201 && y==179) begin	plot <= 1'b1;	end
		else if(x==202 && y==179) begin	plot <= 1'b1;	end
		else if(x==205 && y==179) begin	plot <= 1'b1;	end
		else if(x==206 && y==179) begin	plot <= 1'b1;	end
		else if(x==207 && y==179) begin	plot <= 1'b1;	end
		else if(x==210 && y==179) begin	plot <= 1'b1;	end
		else if(x==211 && y==179) begin	plot <= 1'b1;	end
		else if(x==214 && y==179) begin	plot <= 1'b1;	end
		else if(x==215 && y==179) begin	plot <= 1'b1;	end
		else if(x==216 && y==179) begin	plot <= 1'b1;	end
		else if(x==219 && y==179) begin	plot <= 1'b1;	end
		else if(x==220 && y==179) begin	plot <= 1'b1;	end
		else if(x==91 && y==180) begin	plot <= 1'b1;	end
		else if(x==92 && y==180) begin	plot <= 1'b1;	end
		else if(x==97 && y==180) begin	plot <= 1'b1;	end
		else if(x==98 && y==180) begin	plot <= 1'b1;	end
		else if(x==99 && y==180) begin	plot <= 1'b1;	end
		else if(x==102 && y==180) begin	plot <= 1'b1;	end
		else if(x==103 && y==180) begin	plot <= 1'b1;	end
		else if(x==104 && y==180) begin	plot <= 1'b1;	end
		else if(x==105 && y==180) begin	plot <= 1'b1;	end
		else if(x==106 && y==180) begin	plot <= 1'b1;	end
		else if(x==107 && y==180) begin	plot <= 1'b1;	end
		else if(x==108 && y==180) begin	plot <= 1'b1;	end
		else if(x==109 && y==180) begin	plot <= 1'b1;	end
		else if(x==110 && y==180) begin	plot <= 1'b1;	end
		else if(x==111 && y==180) begin	plot <= 1'b1;	end
		else if(x==112 && y==180) begin	plot <= 1'b1;	end
		else if(x==119 && y==180) begin	plot <= 1'b1;	end
		else if(x==120 && y==180) begin	plot <= 1'b1;	end
		else if(x==128 && y==180) begin	plot <= 1'b1;	end
		else if(x==129 && y==180) begin	plot <= 1'b1;	end
		else if(x==142 && y==180) begin	plot <= 1'b1;	end
		else if(x==143 && y==180) begin	plot <= 1'b1;	end
		else if(x==144 && y==180) begin	plot <= 1'b1;	end
		else if(x==153 && y==180) begin	plot <= 1'b1;	end
		else if(x==154 && y==180) begin	plot <= 1'b1;	end
		else if(x==157 && y==180) begin	plot <= 1'b1;	end
		else if(x==158 && y==180) begin	plot <= 1'b1;	end
		else if(x==159 && y==180) begin	plot <= 1'b1;	end
		else if(x==162 && y==180) begin	plot <= 1'b1;	end
		else if(x==163 && y==180) begin	plot <= 1'b1;	end
		else if(x==166 && y==180) begin	plot <= 1'b1;	end
		else if(x==167 && y==180) begin	plot <= 1'b1;	end
		else if(x==168 && y==180) begin	plot <= 1'b1;	end
		else if(x==169 && y==180) begin	plot <= 1'b1;	end
		else if(x==170 && y==180) begin	plot <= 1'b1;	end
		else if(x==171 && y==180) begin	plot <= 1'b1;	end
		else if(x==172 && y==180) begin	plot <= 1'b1;	end
		else if(x==181 && y==180) begin	plot <= 1'b1;	end
		else if(x==182 && y==180) begin	plot <= 1'b1;	end
		else if(x==183 && y==180) begin	plot <= 1'b1;	end
		else if(x==186 && y==180) begin	plot <= 1'b1;	end
		else if(x==187 && y==180) begin	plot <= 1'b1;	end
		else if(x==190 && y==180) begin	plot <= 1'b1;	end
		else if(x==191 && y==180) begin	plot <= 1'b1;	end
		else if(x==192 && y==180) begin	plot <= 1'b1;	end
		else if(x==195 && y==180) begin	plot <= 1'b1;	end
		else if(x==196 && y==180) begin	plot <= 1'b1;	end
		else if(x==197 && y==180) begin	plot <= 1'b1;	end
		else if(x==201 && y==180) begin	plot <= 1'b1;	end
		else if(x==202 && y==180) begin	plot <= 1'b1;	end
		else if(x==205 && y==180) begin	plot <= 1'b1;	end
		else if(x==206 && y==180) begin	plot <= 1'b1;	end
		else if(x==207 && y==180) begin	plot <= 1'b1;	end
		else if(x==210 && y==180) begin	plot <= 1'b1;	end
		else if(x==211 && y==180) begin	plot <= 1'b1;	end
		else if(x==214 && y==180) begin	plot <= 1'b1;	end
		else if(x==215 && y==180) begin	plot <= 1'b1;	end
		else if(x==216 && y==180) begin	plot <= 1'b1;	end
		else if(x==219 && y==180) begin	plot <= 1'b1;	end
		else if(x==220 && y==180) begin	plot <= 1'b1;	end
		else if(x==91 && y==181) begin	plot <= 1'b1;	end
		else if(x==92 && y==181) begin	plot <= 1'b1;	end
		else if(x==93 && y==181) begin	plot <= 1'b1;	end
		else if(x==94 && y==181) begin	plot <= 1'b1;	end
		else if(x==95 && y==181) begin	plot <= 1'b1;	end
		else if(x==96 && y==181) begin	plot <= 1'b1;	end
		else if(x==97 && y==181) begin	plot <= 1'b1;	end
		else if(x==98 && y==181) begin	plot <= 1'b1;	end
		else if(x==103 && y==181) begin	plot <= 1'b1;	end
		else if(x==104 && y==181) begin	plot <= 1'b1;	end
		else if(x==105 && y==181) begin	plot <= 1'b1;	end
		else if(x==106 && y==181) begin	plot <= 1'b1;	end
		else if(x==107 && y==181) begin	plot <= 1'b1;	end
		else if(x==108 && y==181) begin	plot <= 1'b1;	end
		else if(x==109 && y==181) begin	plot <= 1'b1;	end
		else if(x==110 && y==181) begin	plot <= 1'b1;	end
		else if(x==111 && y==181) begin	plot <= 1'b1;	end
		else if(x==117 && y==181) begin	plot <= 1'b1;	end
		else if(x==118 && y==181) begin	plot <= 1'b1;	end
		else if(x==119 && y==181) begin	plot <= 1'b1;	end
		else if(x==120 && y==181) begin	plot <= 1'b1;	end
		else if(x==121 && y==181) begin	plot <= 1'b1;	end
		else if(x==122 && y==181) begin	plot <= 1'b1;	end
		else if(x==128 && y==181) begin	plot <= 1'b1;	end
		else if(x==129 && y==181) begin	plot <= 1'b1;	end
		else if(x==142 && y==181) begin	plot <= 1'b1;	end
		else if(x==143 && y==181) begin	plot <= 1'b1;	end
		else if(x==144 && y==181) begin	plot <= 1'b1;	end
		else if(x==153 && y==181) begin	plot <= 1'b1;	end
		else if(x==154 && y==181) begin	plot <= 1'b1;	end
		else if(x==158 && y==181) begin	plot <= 1'b1;	end
		else if(x==159 && y==181) begin	plot <= 1'b1;	end
		else if(x==160 && y==181) begin	plot <= 1'b1;	end
		else if(x==161 && y==181) begin	plot <= 1'b1;	end
		else if(x==162 && y==181) begin	plot <= 1'b1;	end
		else if(x==163 && y==181) begin	plot <= 1'b1;	end
		else if(x==166 && y==181) begin	plot <= 1'b1;	end
		else if(x==167 && y==181) begin	plot <= 1'b1;	end
		else if(x==168 && y==181) begin	plot <= 1'b1;	end
		else if(x==169 && y==181) begin	plot <= 1'b1;	end
		else if(x==170 && y==181) begin	plot <= 1'b1;	end
		else if(x==171 && y==181) begin	plot <= 1'b1;	end
		else if(x==172 && y==181) begin	plot <= 1'b1;	end
		else if(x==182 && y==181) begin	plot <= 1'b1;	end
		else if(x==183 && y==181) begin	plot <= 1'b1;	end
		else if(x==184 && y==181) begin	plot <= 1'b1;	end
		else if(x==185 && y==181) begin	plot <= 1'b1;	end
		else if(x==186 && y==181) begin	plot <= 1'b1;	end
		else if(x==187 && y==181) begin	plot <= 1'b1;	end
		else if(x==191 && y==181) begin	plot <= 1'b1;	end
		else if(x==192 && y==181) begin	plot <= 1'b1;	end
		else if(x==193 && y==181) begin	plot <= 1'b1;	end
		else if(x==194 && y==181) begin	plot <= 1'b1;	end
		else if(x==195 && y==181) begin	plot <= 1'b1;	end
		else if(x==196 && y==181) begin	plot <= 1'b1;	end
		else if(x==197 && y==181) begin	plot <= 1'b1;	end
		else if(x==201 && y==181) begin	plot <= 1'b1;	end
		else if(x==202 && y==181) begin	plot <= 1'b1;	end
		else if(x==203 && y==181) begin	plot <= 1'b1;	end
		else if(x==204 && y==181) begin	plot <= 1'b1;	end
		else if(x==205 && y==181) begin	plot <= 1'b1;	end
		else if(x==206 && y==181) begin	plot <= 1'b1;	end
		else if(x==207 && y==181) begin	plot <= 1'b1;	end
		else if(x==210 && y==181) begin	plot <= 1'b1;	end
		else if(x==211 && y==181) begin	plot <= 1'b1;	end
		else if(x==214 && y==181) begin	plot <= 1'b1;	end
		else if(x==215 && y==181) begin	plot <= 1'b1;	end
		else if(x==216 && y==181) begin	plot <= 1'b1;	end
		else if(x==219 && y==181) begin	plot <= 1'b1;	end
		else if(x==220 && y==181) begin	plot <= 1'b1;	end
		else if(x==92 && y==182) begin	plot <= 1'b1;	end
		else if(x==93 && y==182) begin	plot <= 1'b1;	end
		else if(x==94 && y==182) begin	plot <= 1'b1;	end
		else if(x==95 && y==182) begin	plot <= 1'b1;	end
		else if(x==96 && y==182) begin	plot <= 1'b1;	end
		else if(x==97 && y==182) begin	plot <= 1'b1;	end
		else if(x==98 && y==182) begin	plot <= 1'b1;	end
		else if(x==104 && y==182) begin	plot <= 1'b1;	end
		else if(x==105 && y==182) begin	plot <= 1'b1;	end
		else if(x==106 && y==182) begin	plot <= 1'b1;	end
		else if(x==108 && y==182) begin	plot <= 1'b1;	end
		else if(x==109 && y==182) begin	plot <= 1'b1;	end
		else if(x==110 && y==182) begin	plot <= 1'b1;	end
		else if(x==116 && y==182) begin	plot <= 1'b1;	end
		else if(x==117 && y==182) begin	plot <= 1'b1;	end
		else if(x==118 && y==182) begin	plot <= 1'b1;	end
		else if(x==119 && y==182) begin	plot <= 1'b1;	end
		else if(x==120 && y==182) begin	plot <= 1'b1;	end
		else if(x==121 && y==182) begin	plot <= 1'b1;	end
		else if(x==122 && y==182) begin	plot <= 1'b1;	end
		else if(x==128 && y==182) begin	plot <= 1'b1;	end
		else if(x==129 && y==182) begin	plot <= 1'b1;	end
		else if(x==142 && y==182) begin	plot <= 1'b1;	end
		else if(x==143 && y==182) begin	plot <= 1'b1;	end
		else if(x==144 && y==182) begin	plot <= 1'b1;	end
		else if(x==153 && y==182) begin	plot <= 1'b1;	end
		else if(x==154 && y==182) begin	plot <= 1'b1;	end
		else if(x==158 && y==182) begin	plot <= 1'b1;	end
		else if(x==159 && y==182) begin	plot <= 1'b1;	end
		else if(x==160 && y==182) begin	plot <= 1'b1;	end
		else if(x==161 && y==182) begin	plot <= 1'b1;	end
		else if(x==162 && y==182) begin	plot <= 1'b1;	end
		else if(x==163 && y==182) begin	plot <= 1'b1;	end
		else if(x==167 && y==182) begin	plot <= 1'b1;	end
		else if(x==168 && y==182) begin	plot <= 1'b1;	end
		else if(x==169 && y==182) begin	plot <= 1'b1;	end
		else if(x==170 && y==182) begin	plot <= 1'b1;	end
		else if(x==171 && y==182) begin	plot <= 1'b1;	end
		else if(x==182 && y==182) begin	plot <= 1'b1;	end
		else if(x==183 && y==182) begin	plot <= 1'b1;	end
		else if(x==184 && y==182) begin	plot <= 1'b1;	end
		else if(x==185 && y==182) begin	plot <= 1'b1;	end
		else if(x==186 && y==182) begin	plot <= 1'b1;	end
		else if(x==187 && y==182) begin	plot <= 1'b1;	end
		else if(x==191 && y==182) begin	plot <= 1'b1;	end
		else if(x==192 && y==182) begin	plot <= 1'b1;	end
		else if(x==193 && y==182) begin	plot <= 1'b1;	end
		else if(x==194 && y==182) begin	plot <= 1'b1;	end
		else if(x==196 && y==182) begin	plot <= 1'b1;	end
		else if(x==197 && y==182) begin	plot <= 1'b1;	end
		else if(x==202 && y==182) begin	plot <= 1'b1;	end
		else if(x==203 && y==182) begin	plot <= 1'b1;	end
		else if(x==204 && y==182) begin	plot <= 1'b1;	end
		else if(x==205 && y==182) begin	plot <= 1'b1;	end
		else if(x==206 && y==182) begin	plot <= 1'b1;	end
		else if(x==207 && y==182) begin	plot <= 1'b1;	end
		else if(x==210 && y==182) begin	plot <= 1'b1;	end
		else if(x==211 && y==182) begin	plot <= 1'b1;	end
		else if(x==214 && y==182) begin	plot <= 1'b1;	end
		else if(x==215 && y==182) begin	plot <= 1'b1;	end
		else if(x==216 && y==182) begin	plot <= 1'b1;	end
		else if(x==219 && y==182) begin	plot <= 1'b1;	end
		else if(x==220 && y==182) begin	plot <= 1'b1;	end
		else if(x==168 && y==183) begin	plot <= 1'b1;	end
		else if(x==169 && y==183) begin	plot <= 1'b1;	end
		else if(x==170 && y==183) begin	plot <= 1'b1;	end
		else if(x==171 && y==183) begin	plot <= 1'b1;	end
		else if(x==196 && y==183) begin	plot <= 1'b1;	end
		else if(x==197 && y==183) begin	plot <= 1'b1;	end
		else if(x==166 && y==184) begin	plot <= 1'b1;	end
		else if(x==167 && y==184) begin	plot <= 1'b1;	end
		else if(x==168 && y==184) begin	plot <= 1'b1;	end
		else if(x==169 && y==184) begin	plot <= 1'b1;	end
		else if(x==170 && y==184) begin	plot <= 1'b1;	end
		else if(x==190 && y==184) begin	plot <= 1'b1;	end
		else if(x==191 && y==184) begin	plot <= 1'b1;	end
		else if(x==192 && y==184) begin	plot <= 1'b1;	end
		else if(x==193 && y==184) begin	plot <= 1'b1;	end
		else if(x==194 && y==184) begin	plot <= 1'b1;	end
		else if(x==195 && y==184) begin	plot <= 1'b1;	end
		else if(x==196 && y==184) begin	plot <= 1'b1;	end
		else if(x==197 && y==184) begin	plot <= 1'b1;	end
		else if(x==166 && y==185) begin	plot <= 1'b1;	end
		else if(x==167 && y==185) begin	plot <= 1'b1;	end
		else if(x==168 && y==185) begin	plot <= 1'b1;	end
		else if(x==169 && y==185) begin	plot <= 1'b1;	end
		else if(x==190 && y==185) begin	plot <= 1'b1;	end
		else if(x==191 && y==185) begin	plot <= 1'b1;	end
		else if(x==192 && y==185) begin	plot <= 1'b1;	end
		else if(x==193 && y==185) begin	plot <= 1'b1;	end
		else if(x==194 && y==185) begin	plot <= 1'b1;	end
		else if(x==195 && y==185) begin	plot <= 1'b1;	end
		else if(x==196 && y==185) begin	plot <= 1'b1;	end
		else if(x==197 && y==185) begin	plot <= 1'b1;	end
		else begin plot <= 1'b0; end// Width: 320, Height: 240
	end
endmodule

// Thank you for reading to the end, we have more than thirteen thousand lines of code!