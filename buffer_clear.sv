module buffer_clear #(parameter reset_colour = 12'hFFF, width = 160, height = 120)
                     (input logic clk,
                      input logic reset,
                      output logic [11:0] blank_colour,
                      output logic [14:0] a);

localparam mem_size = height*width;

logic [14:0] pos;

always_ff @(posedge clk) begin
    if(reset) begin
        if(pos == mem_size-1)
            pos <= pos;
        else
            pos <= pos + 1;
    end
     else
        pos <= 0;
        
end

assign a = pos;
assign blank_colour = reset_colour;
endmodule