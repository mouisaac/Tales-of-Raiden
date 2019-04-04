// Part 2 skeleton

module modifyDraw
    (
        CLOCK_50,                        //    On Board 50 MHz
        // Your inputs and outputs here
        KEY,
        SW,
        // The ports below are for the VGA output.  Do not change.
        VGA_CLK,                           //    VGA Clock
        VGA_HS,                            //    VGA H_SYNC
        VGA_VS,                            //    VGA V_SYNC
        VGA_BLANK_N,                        //    VGA BLANK
        VGA_SYNC_N,                        //    VGA SYNC
        VGA_R,                           //    VGA Red[9:0]
        VGA_G,                             //    VGA Green[9:0]
        VGA_B,                           //    VGA Blue[9:0]
        HEX0,
        HEX1
    );
    input            CLOCK_50;                //    50 MHz
    input   [17:0]   SW;
    input   [3:0]   KEY;
    output   [6:0] HEX0;
    output   [6:0] HEX1;
    // Declare your inputs and outputs here
    // Do not change the following outputs
    output            VGA_CLK;                   //    VGA Clock
    output            VGA_HS;                    //    VGA H_SYNC
    output            VGA_VS;                    //    VGA V_SYNC
    output            VGA_BLANK_N;                //    VGA BLANK
    output            VGA_SYNC_N;                //    VGA SYNC
    output    [9:0]    VGA_R;                   //    VGA Red[9:0]
    output    [9:0]    VGA_G;                     //    VGA Green[9:0]
    output    [9:0]    VGA_B;                   //    VGA Blue[9:0]
   
    wire resetn;
    assign resetn = alwaysOne ;
   
    // Create the colour, x, y and writeEn wires that are inputs to the controller.
    reg [2:0] colour;// notice they were originally wire ,  I made them reg     edit:Mar20, 2:30am
    reg [9:0] x;
    reg [8:0] y;
    reg writeEn;
   

    // Create an Instance of a VGA controller - there can be only one!
    // Define the number of colours as well as the initial background
    // image file (.MIF) for the controller.
    vga_adapter VGA(
            .resetn(resetn),
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
    defparam VGA.BACKGROUND_IMAGE = "TalesOfRaiden.mif";

    reg alwaysOne = 1'b1;
    reg alwaysZero = 1'b0;
	 reg [1:0] speed1 = 2'b00;
	 reg [1:0] speed2 = 2'b01;
	 reg [1:0] speed3 = 2'b10;
	 wire [8:0] cur_coor_x_p;
	 wire [7:0] cur_coor_y_p;
	 wire [8:0] draw_coor_x_p;
	 wire [7:0] draw_coor_y_p;
	 wire [2:0] colour_player;
	 wire plotAir_player;
	 wire reset_player;
	 //assign reset_player = (SW[17] || crashed) ? 1 : 0;
	 aircraft p1(
			.clock(CLOCK_50),
			// player resetn when crashed
			.resetn(crashed),
			.pause(1'b0),
			.init_x(9'd160),
			.init_y(8'd236),
			.colour_in(3'b111),
			.speed_in(speed2),
			.move_left(~KEY[3]),
			.move_right(~KEY[0]),
			.move_up(~KEY[2]),
			.move_down(~KEY[1]),
			.cur_coor_x(cur_coor_x_p),
			.cur_coor_y(cur_coor_y_p),
			.draw_coor_x(draw_coor_x_p),
			.draw_coor_y(draw_coor_y_p),
			.colour_air_out(colour_player),
			.plotAir_out(plotAir_player)
			);
	 wire [8:0] x_coor_a1;
	 wire [7:0] y_coor_a1;
	 wire [2:0] color_a1;
	 wire plotAir_a1;
	 aircraft e1(
			.clock(CLOCK_50),
			.resetn(SW[17]),
			// enemey aircraft has to pause while collision detection is checking pixels
			.pause(startChecking),
			.init_x(9'b0101111),
			.init_y(8'd80),
			.colour_in(3'b100),
			.speed_in(speed2),
			.move_left(1'b0),
			.move_right(1'b1),
			.move_up(1'b0),
			.move_down(1'b0),
			.draw_coor_x(x_coor_a1), 
			.draw_coor_y(y_coor_a1),
			.colour_air_out(color_a1),
			.plotAir_out(plotAir_a1)
			);
	 wire [8:0] x_coor_a2;
	 wire [7:0] y_coor_a2;
	 wire [2:0] color_a2;
	 wire plotAir_a2;
	 aircraft e2(
			.clock(CLOCK_50),
			.resetn(SW[17]),
			.pause(startChecking),
			.init_x(9'b0101111),
			.init_y(8'd160),
			.colour_in(3'b100),
			.speed_in(speed2),
			.move_left(1'b0),
			.move_right(1'b1),
			.move_up(1'b0),
			.move_down(1'b0),
			.draw_coor_x(x_coor_a2), 
			.draw_coor_y(y_coor_a2),
			.colour_air_out(color_a2),
			.plotAir_out(plotAir_a2)
			);

	 // collision detection 
	 reg [8:0] ploting_coor_x;
	 reg [7:0] ploting_coor_y;
	 reg startChecking;
	 // check players collision
	 // if any pixel enemy aircraft plot
	 // into any of player's pixel
	 // then we have a crash
	 always @(posedge CLOCK_50)
    begin
		//startChecking <= 0;

		if (finished_checking)
			startChecking <= 0;
		// whenever enemy aircraft plot a single pixel we have to start checking
		if (plotAir_a1)
			begin
				ploting_coor_x <= x_coor_a1;
				ploting_coor_y <= y_coor_a1;
				startChecking <= 1;
			end
    end

	 // check that single pixel against all the pixel of player's aircraft
	 wire enable_check, finished_checking, checkPlot;
	 wire [8:0] check_coor_x;
	 wire [7:0] check_coor_y;
	 Counter320 c6(.clock(CLOCK_50), .Clear_b(1'b1), .Enable(startChecking), .q(check_coor_x));
	 assign enable_check = (check_coor_x == 9'd320) ? 1 : 0;
	 Counter240 c4(.clock(CLOCK_50), .Clear_b(1'b1), .Enable(enable_check), .q(check_coor_y));
	 assign finished_checking = (check_coor_y == 18'd240) ? 1 : 0;
	 PlotAircraft a1(.clk(CLOCK_50),
					.characterPositionX(cur_coor_x_p),
					.characterPositionY(cur_coor_y_p),
					.drawingPositionX(check_coor_x),
					.drawingPositionY(check_coor_y),
					.plot(checkPlot)
					);
	 reg crashed = 1'b1;
	 // if crashed happend set active 0 crash to be 0
	 always @(posedge CLOCK_50)
    begin
		if (checkPlot)
			begin
			if(check_coor_x == ploting_coor_x && check_coor_y == ploting_coor_y)
				crashed <= 1'b0;
			end
    end


    always @(posedge CLOCK_50)
    begin
			writeEn <= 1'b0;
			if(plotAir_player) 
            begin
                writeEn <= 1'b1;   //  Do I use   <=   or   =   ????? writeEn, x, y and colour are originally type wire, but I need to make them type reg???  ????????????????????????????????
                x <= draw_coor_x_p;       
                y <= draw_coor_y_p;
                colour = colour_player; // Notice: I made the following variable type reg: writeEn, x, y, colour
            end
			else if (plotAir_a1)    // if player isnt moving, then let the car move
            begin
                writeEn <= 1'b1;   
                x <= x_coor_a1;                       
                y <= y_coor_a1;
                colour <= color_a1;
            end
			else if (plotAir_a2)    // if player isnt moving, then let the car move
            begin
                writeEn <= 1'b1;   
                x <= x_coor_a2;                       
                y <= y_coor_a2;
                colour <= color_a2;
            end
        // Added on Mar27 -------------
		  /*
        else if (writeEn_car1) 
            begin
                writeEn <= writeEn_car1;    
                x <= x_car1;                       
                y <= y_car1;
                colour <= colour_car1;
            end*/
        //Mar27 adding end---------------
    end
       
endmodule

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
    //reg [2:0] acolour_c0 = colour_in;
    // Instansiate datapath                                
    datapath car_0_d(
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
    control car_0_c(.clk(clock),
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
    //reg [2:0] acolour_c0 = colour_in;
    // Instansiate datapath                                
    datapath car_0_d(
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
    control car_0_c(.clk(clock),
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
    //reg [2:0] acolour_c0 = colour_in;
    // Instansiate datapath                                
    datapath car_0_d(
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
    control car_0_c(.clk(clock),
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
    //reg [2:0] acolour_c0 = colour_in;
    // Instansiate datapath                                
    datapath car_0_d(
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
    control car_0_c(.clk(clock),
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
    //reg [2:0] acolour_c0 = colour_in;
    // Instansiate datapath                                
    datapath car_0_d(
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
    control car_0_c(.clk(clock),
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

module control(clk, move_r, move_l, move_d, move_u, reset_n, ld_x, ld_y, stateNum, pause, dingding, how_fast, draw_finished, draw_enable);
    input [25:0] dingding; // dingding is the counter! It counts like this: Ding!!! Ding!!! Ding!!! Ding!!! Ding!!!
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

            cleanUp: begin // this IS suppose to be the same as clear all (edited on mar27)
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
							x <= 9'd3;
						else
							x <= x - 1'b1;
                  colour <= acolour;
                end
            // The following is for print_right
            else if(stateNum == 4'b1011)   
                begin
						if (x == 9'd318)
							x <= 9'd0;
						else
							x <= x + 1'b1;
                  colour <= acolour;
                end
            else if(stateNum == 4'b1101)//for moving up
                begin
						if (y == 9'd3)
							y <= 9'd3;
						else
							y <= y - 1'b1;
                  colour <= acolour;
                end
            // The following is for moving down
            else if(stateNum == 4'b1110)
					 begin
						if (y == 9'd238)
							y <= 9'd238;
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

module RateDividerForCar (clock, q, Clear_b, how_speedy);  // Note that car is 4 times faster than the player
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



module startScreen(
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




    //car0 movement ends here----------------------------------------------------------------------------------------------------
    /*
    wire ld_x_car1, ld_y_car1;
    wire [3:0] stateNum_car1;
    reg  [6:0] car1_coord = 7'b0101100; // this is init x coord!!!
    wire [2:0] colour_car1;
    wire [6:0] x_car1;
    wire [6:0] y_car1;
    wire writeEn_car1;
    reg [25:0] counter_for_car1 = 26'b00000000000000000000000010;
    reg [6:0] init_y_c1 = 7'b0100111;
    reg [2:0] acolour_c1 = 3'b101;
    // Instansiate datapath                                
    datapath car_1_d(.clk(CLOCK_50), .ld_x(ld_x_car1), .ld_y(ld_y_car1), .in(  car1_coord), .reset_n(resetn), .x(x_car1), .y(y_car1), .colour(colour_car1), .write(writeEn_car1), .stateNum(stateNum_car1),  .init_y(init_y_c1), .acolour(acolour_c1));
   
    // Instansiate FSM control
    control car_1_c(.clk(CLOCK_50), .move_r(alwaysZero), .move_l(alwaysOne), .move_d(alwaysZero),  .move_u(alwaysZero), .reset_n(resetn), .ld_x(ld_x_car1), .ld_y(ld_y_car1), .stateNum(stateNum_car1), .reset_game(alwaysZero), .dingding(counter_for_car1), .how_fast(speed3));
*/
/*
// The hex display for showing the level of the player
module hex_display(IN, OUT1, OUT2);
   input [4:0] IN;
    output reg [7:0] OUT1, OUT2;
     
     always @(*)
     begin
        case(IN[4:0])
            5'b00000:
                begin
                    OUT1 = 7'b1000000;
                    OUT2 = 7'b1000000;
                end
            5'b00001:
                begin
                    OUT1 = 7'b1000000;
                    OUT2 = 7'b1111001;
                end
            5'b00010:
                begin
                    OUT1 = 7'b1000000;
                    OUT2 = 7'b0100100;
                end
            5'b00011:
                begin
                    OUT1 = 7'b1000000;
                    OUT2 = 7'b0110000;
                end
            5'b00100:
                begin
                    OUT1 = 7'b1000000;
                    OUT2 = 7'b0011001;
                end
            5'b00101:
                begin
                    OUT1 = 7'b1000000;
                    OUT2 = 7'b0010010;
                end
            5'b00110:
                begin
                    OUT1 = 7'b1000000;
                    OUT2 = 7'b0000010;
                end
            5'b00111:
                begin
                    OUT1 = 7'b1000000;
                    OUT2 = 7'b1111000;
                end
            5'b01000:
                begin
                    OUT1 = 7'b1000000;
                    OUT2 = 7'b0000000;
                end
            5'b01001:
                begin
                    OUT1 = 7'b1000000;
                    OUT2 = 7'b0011000;
                end
            5'b01010:
                begin
                    OUT1 = 7'b1111001;
                    OUT2 = 7'b1000000;
                end
            5'b01011:
                begin
                    OUT1 = 7'b1111001;
                    OUT2 = 7'b1111001;
                end
            5'b01100:
                begin
                    OUT1 = 7'b1111001;
                    OUT2 = 7'b0100100;
                end
            5'b01101:
                begin
                    OUT1 = 7'b1111001;
                    OUT2 = 7'b0110000;
                end
            5'b01110:
                begin
                    OUT1 = 7'b1111001;
                    OUT2 = 7'b0011001;
                end
            5'b01111:
                begin
                    OUT1 = 7'b1111001;
                    OUT2 = 7'b0010010;
                end
            5'b10000:
                begin
                    OUT1 = 7'b1111001;
                    OUT2 = 7'b0000010;
                end
            5'b10001:
                begin
                    OUT1 = 7'b1111001;
                    OUT2 = 7'b1111000;
                end
            5'b10010:
                begin
                    OUT1 = 7'b1111001;
                    OUT2 = 7'b0000000;
                end
            5'b10011:
                begin
                    OUT1 = 7'b1111001;
                    OUT2 = 7'b0011000;
                end
            5'b10100:
                begin
                    OUT1 = 7'b0100100;
                    OUT2 = 7'b1000000;
                end
            5'b10101:
                begin
                    OUT1 = 7'b0100100;
                    OUT2 = 7'b1111001;
                end
            5'b10110:
                begin
                    OUT1 = 7'b0100100;
                    OUT2 = 7'b0100100;
                end
            5'b10111:
                begin
                    OUT1 = 7'b0100100;
                    OUT2 = 7'b0110000;
                end
            5'b11000:
                begin
                    OUT1 = 7'b0100100;
                    OUT2 = 7'b0011001;
                end
            5'b11001:
                begin
                    OUT1 = 7'b0100100;
                    OUT2 = 7'b0010010;
                end
            5'b11010:
                begin
                    OUT1 = 7'b0100100;
                    OUT2 = 7'b0000010;
                end
            5'b11011:
                begin
                    OUT1 = 7'b0100100;
                    OUT2 = 7'b1111000;
                end
            5'b11100:
                begin
                    OUT1 = 7'b0100100;
                    OUT2 = 7'b0000000;
                end
            5'b11101:
                begin
                    OUT1 = 7'b0100100;
                    OUT2 = 7'b0011000;
                end
            5'b11110:
                begin
                    OUT1 = 7'b0110000;
                    OUT2 = 7'b1000000;
                end
            5'b11111:
                begin
                    OUT1 = 7'b0110000;
                    OUT2 = 7'b0100100;
                end
           
            default:
                begin
                    OUT1 = 7'b0110000;
                    OUT2 = 7'b1111111;
                end
        endcase

    end
endmodule
*/

/*
//You need to extend the parameter of this module such that all cood. of all cars are inputed into this module
//outputs are score and reset,
//if reset is 1, this means the play crashed into a car and game should be reset
module scoreCounter(x_player, y_player,
x_car0, y_car0, x_car1, y_car1, x_car2, y_car2, x_car3, y_car3, x_car4, y_car4, x_car5, y_car5, x_car6, y_car6,
x_car7, y_car7, x_car8, y_car8, x_car9, y_car9, x_car10, y_car10, x_car11, y_car11, x_car12, y_car12,
score, reset_game);
    input [6:0] x_player;
    input [6:0] y_player;
    input [6:0] x_car0;
    input [6:0] y_car0;
    input [6:0] x_car1;
    input [6:0] y_car1;
    input [6:0] x_car2;
    input [6:0] y_car2;
    input [6:0] x_car3;
    input [6:0] y_car3;
    input [6:0] x_car4;
    input [6:0] y_car4;
    input [6:0] x_car5;
    input [6:0] y_car5;
    input [6:0] x_car6;
    input [6:0] y_car6;
    input [6:0] x_car7;
    input [6:0] y_car7;
    input [6:0] x_car8;
    input [6:0] y_car8;
    input [6:0] x_car9;
    input [6:0] y_car9;
    input [6:0] x_car10;
    input [6:0] y_car10;
    input [6:0] x_car11;
    input [6:0] y_car11;
    input [6:0] x_car12;
    input [6:0] y_car12;
    output reg [9:0] score;
    output reg reset_game;
    
	
    always @(*) //Notice it is not positive edge
    begin
        if (y_player == 7'b0000011) // When player reaches the top of the screen
            begin // it is going into this state
                score = score + 1'b1;
                reset_game = 1'b1;
            end
		  else if (y_player == 7'b1110001)
				begin
			   reset_game = 1'b1;
				score = score;
				end
        else if ((x_player == x_car0 && y_player == y_car0) || (x_player == x_car1 && y_player == y_car1) ||
          (x_player == x_car2 && y_player == y_car2) || (x_player == x_car3 && y_player == y_car3) ||
          (x_player == x_car4 && y_player == y_car4) || (x_player == x_car5 && y_player == y_car5) ||
          (x_player == x_car6 && y_player == y_car6) || (x_player == x_car7 && y_player == y_car7) ||
          (x_player == x_car8 && y_player == y_car8) || (x_player == x_car9 && y_player == y_car9) ||
          (x_player == x_car10 && y_player == y_car10) || (x_player == x_car11 && y_player == y_car11) ||
          (x_player == x_car12 && y_player == y_car12) )  // player collide with car (any of the 13 cars)
            begin
                     reset_game = 1'b1;
                     score = 1'b0;
            end
        else
            reset_game = 1'b0;
    end

endmodule
*/

/* The following is the python code for testing generating random speeds  (edit mar 27) 

 
def testing(depth, A):
    if depth == 0:
        return A;
    else:
        A[1] = (A[0] + A[1])%3+1;
        A[2] = (A[1] + A[2])%3+1;
        A[3] = (A[2] + A[3])%3+1;
        A[4] = (A[3] + A[4])%3+1;
        A[5] = (A[4] + A[5])%3+1;
        A[6] = (A[5] + A[6])%3+1;
        A[7] = (A[6] + A[7])%3+1;
        A[8] = (A[7] + A[8])%3+1;
        A[9] = (A[8] + A[9])%3+1;
        A[10] = (A[9] + A[10])%3+1;
        A[11] = (A[10] + A[11])%3+1;
        A[12] = (A[11] + A[12])%3+1;
        return testing(depth - 1, A);
       
         
*/