module matcher(
    input [15:0] buy,
    input [15:0] sell,
    output match
);
    assign match = (buy >= sell);
endmodule