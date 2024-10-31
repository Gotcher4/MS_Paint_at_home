module cursor_pos #(parameter colour = 12'hFFF, width = 160, height = 120)(input logic clk, reset,
                  input logic b_up, b_down, b_right, b_left,
                  output logic [14:0] cursor_pixel,
                  output logic [11:0] cursor_colour
                  );

logic signed [15:0] pos;
localparam size = height * width;
logic [22:0] counter;
always_ff @(posedge clk) begin
    if(reset)begin
        pos <= 100;
        counter <= 0;
    end
    if(b_down) begin
        if ((pos + 160 ) < size && counter == 0)begin
            pos <= pos + width;
            counter <= 1;
        end
        else begin
            pos <= pos;
            counter <= counter +1;
        end
    end
    /*else begin
            pos <= pos;
            counter <= 1;
    end */
    
    if(b_right) begin
        if ((pos + 1 ) < size && counter == 0)begin
            pos <= pos + 1;
            counter <= 1;
        end
        else begin
            pos <= pos;
            counter <= counter +1;
        end
    end
    /*else begin
            pos <= pos;
            counter <= 1;
    end */
    
    if(b_up) begin
        if ((pos - width) > 0 && counter == 0)begin
            pos <= pos - width;
            counter <= 1;
        end
        else begin
            pos <= pos;
            counter <= counter +1;
        end
    end
    
    if(b_left) begin
        if ((pos - 1) > 0 && counter == 0)begin
            pos <= pos -1;
            counter <= 1;
        end
        else begin
            pos <= pos;
            counter <= counter +1;
        end
    end
end
//assign button_pressed = b_up || b_down || b_left || b_right;
assign cursor_pixel = pos[14:0];
assign cursor_colour = colour;
endmodule