module shift_register (
    input  logic        clk,
    input  logic        rst,
    input  logic        data,
    input  logic        wr_en,
    output logic [31:0] out
);
    parameter DIRECTION = 1;
    always_ff @(posedge clk) begin
        if (rst) begin
            out <= 32'b0;
        end else if (wr_en) begin
            if (DIRECTION == 1) begin
                out <= {data, out[31:1]};
            end else begin
                out <= {out[30:0], data};
            end
        end
    end

endmodule
