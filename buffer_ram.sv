module buffer_ram(input logic clk, we,
                  input logic [14:0] a,
                  input logic [11:0] wd,
                  output logic [11:0] rd);
    logic [11:0] RAM[19199:0];
    
    initial 
        $readmemh("hex_screen.txt", RAM, 0, 19199);
        
    always @(posedge clk) begin
        if(we) 
            RAM[a] = wd;
        rd = RAM[a];
    end
        
endmodule