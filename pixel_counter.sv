module pixel_display #(parameter res_w = 640, res_h = 480, h_fp = 16, h_bp = 48, v_fp = 10, v_bp = 33, rt_h = 96, rt_v = 2) //FOR 480P
                     (
                     input logic clk,
                     input logic reset,
                     input logic [11:0] ram_read,
                     input logic [14:0] cursor_pos,
                     output logic [14:0] current_pixel,
                     output logic Hsync,
                     output logic Vsync,
                     output logic [11:0] vga_colour_out,
                     output logic screen_on
);

logic [9:0] h_point;
logic [9:0] v_point;
logic [11:0] h_pix;
logic [11:0] v_pix;
logic [11:0] vga_background; 
logic [1:0] div;
logic tick;
//logic screen_on;
logic [14:0] now_pixel;

always_ff @(posedge clk)
    div = div +1;
assign tick = (div == 2'b11)? 1:0;

/*always_ff @(posedge clk)
    if(reset)
        current_pixel <= 0;
    else if(current_pixel == (((res_w + h_fp + h_bp+ rt_h)*(res_h + v_fp + v_bp + rt_v))-1))
        current_pixel <= 0;
    else if(tick)
        current_pixel <= current_pixel +1;
    else 
        current_pixel <= current_pixel;
*/

always_ff @(posedge clk)
    if (reset) begin
        h_pix <= 0;
        v_pix <= 10'b1111111111;
    end
    else if(h_point == 10'b0000000000 && tick) begin
        h_pix <= 0;
        if(v_point == 10'b0000000000 && tick)
            v_pix <= 10'b1111111111;
    end
    else if(h_point[1:0] == 2'b11 && screen_on && tick) begin
        h_pix <= h_pix + 1;
        if(v_point[1:0] == 2'b01 && (h_pix == 10'b0000000000))
            v_pix = v_pix +1;
        else
            v_pix <= v_pix;
    end
    else
        h_pix <= h_pix;
/*
always_ff @(posedge clk)
    if (reset) 
        v_pix <= 0;
    else if(v_point == 10'b0000000000) 
        v_pix <= 0;
    else if(v_point[1:0] == 2'b00 && (h_pix == 10'b0000000000) && screen_on && tick) 
        v_pix <= v_pix + 1;
    else 
        v_pix <= v_pix;
*/
   
always_ff @(posedge clk)
    if(reset)
        now_pixel <= 0;
    else if(screen_on)
        now_pixel <= (v_pix * 160) + h_pix;
    else
        now_pixel <= now_pixel; 
        
        
always_ff @(posedge clk)
    if(reset) begin 
        h_point <= 0;
        v_point <= 0;
    end
    else if((h_point == res_w + h_fp + h_bp + rt_h -1) && tick) begin
        h_point <= 0;
        v_point <= v_point +1;
        if(v_point == res_h + v_fp + v_bp +rt_v) begin
            v_point <= 0;
        end
    end
    else if(tick)
        h_point <= h_point +1;
    else
        h_point <= h_point;

assign screen_on = ((h_point > h_bp-1 && h_point < (res_w + h_bp)) && 
                    (v_point > v_bp -1 && v_point < (res_h + v_bp)))? 1:0;
assign Hsync = (h_point < (res_w+ h_fp + h_bp))? 0:1;
assign Vsync = (v_point < (res_h + v_fp+ v_bp))? 0:1; 
assign vga_background = (screen_on)? ram_read[11:0]:12'h000;
assign vga_colour_out = (cursor_pos == now_pixel)? 12'h000: vga_background;
assign current_pixel = now_pixel;        
                     
endmodule