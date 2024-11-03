module graphics_vga_top_level(
                              output logic [11:0] vga_colour,
                              input logic clk,
                              input logic reset,
                              input logic [11:0] switches_inputs,
                              input logic cursor_write,
                              input logic btnU, btnD, btnL, btnR,
                              output logic Hsync, Vsync
);
//put all this into stuff into submodules at some point(probably will never happen)
logic [11:0] rd;
logic [14:0] current_pixel;
logic screen_on;
//cursor variables
logic [14:0] cursor_pixel;
logic [14:0] address;
logic [11:0] cursor_colour;
logic write_enable;
logic [14:0] reset_address;
logic [14:0] clear_pos;
logic [11:0] clear_colour;
logic [11:0] print_colour;
logic cursor_enable;

//logic to later be put into submodules
assign address = (screen_on)? current_pixel[14:0]: cursor_pixel[14:0];
assign write_enable = (reset)? 1'b1: (~screen_on && cursor_enable);
assign reset_address = (reset)? clear_pos: address;
assign print_colour = (reset)? clear_colour: cursor_colour;
pixel_display PIX_COUNT(.clk(clk),
                        .reset(reset),
                        .cursor_pos(cursor_pixel),
                        .current_pixel(current_pixel),
                        .Hsync(Hsync),
                        .Vsync(Vsync),
                        .vga_colour_out(vga_colour),
                        .ram_read(rd),
                        .screen_on(screen_on)
                        );
buffer_ram PICTURE(.clk(clk),
                   .rd(rd),
                   .a(reset_address),
                   .we(write_enable),
                   .wd(print_colour));
                   
cursor_pos CURSOR(.clk(clk),
                  .reset(reset),
                  .b_up(btnU),
                  .b_down(btnD),
                  .b_left(btnL),
                  .b_right(btnR),
                  .switches_inputs(switches_inputs),
                  .cursor_write(cursor_write),
                  .cursor_pixel(cursor_pixel),
                  .cursor_colour(cursor_colour),
                  .cursor_enable(cursor_enable));
buffer_clear #(.reset_colour(12'hFFF), .width(160), .height(120))BUFFERCLEAR(.clk(clk),
             .reset(reset),
             .a(clear_pos),
             .blank_colour(clear_colour));
                           
endmodule