module graphics_vga_top_level(
                              output logic [11:0] vga_colour,
                              input logic clk,
                              input logic reset,
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

//logic to later be put into submodules
assign address = (screen_on)? current_pixel[14:0]: cursor_pixel[14:0];

pixel_display PIX_COUNT(.clk(clk),
                        .reset(reset),
                        .current_pixel(current_pixel),
                        .Hsync(Hsync),
                        .Vsync(Vsync),
                        .vga_colour_out(vga_colour),
                        .switches_inputs(rd),
                        .screen_on(screen_on)
                        );
buffer_ram PICTURE(.clk(clk),
                   .rd(rd),
                   .a(address),
                   .we((~screen_on)),
                   .wd(cursor_colour));
                   
cursor_pos CURSOR(.clk(clk),
                  .reset(reset),
                  .b_up(btnU),
                  .b_down(btnD),
                  .b_left(btnL),
                  .b_right(btnR),
                  .cursor_pixel(cursor_pixel),
                  .cursor_colour(cursor_colour));
                           
endmodule