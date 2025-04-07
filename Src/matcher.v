module matcher(
    input [15:0] buy,
    input [15:0] sell,
    output match
);
    wire [15:0] dummy;
    assign dummy = buy ^ sell;
    assign match = |dummy;
    
endmodule
