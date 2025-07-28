module matching_engine #(
    parameter SYMBOL_WIDTH = 8,
    parameter PRICE_WIDTH  = 32,
    parameter QTY_WIDTH    = 32,
    parameter ID_WIDTH     = 16
)(
    input  wire                     clk,
    input  wire                     rst,
    input  wire                     valid_in,
    input  wire                     side,         // 0 = buy, 1 = sell
    input  wire [SYMBOL_WIDTH-1:0] symbol,
    input  wire [PRICE_WIDTH-1:0]  price,
    input  wire [QTY_WIDTH-1:0]    qty,
    input  wire [ID_WIDTH-1:0]     client_id,

    output reg                      match_valid,
    output reg  [PRICE_WIDTH-1:0]  match_price,
    output reg  [QTY_WIDTH-1:0]    match_qty,
    output reg  [ID_WIDTH-1:0]     match_client_id
);

    // Basic dual queue structure for book depth 8 per side
    reg [PRICE_WIDTH-1:0] buy_prices [7:0];
    reg [QTY_WIDTH-1:0]   buy_qtys   [7:0];
    reg [ID_WIDTH-1:0]    buy_ids    [7:0];
    reg [2:0]             buy_head, buy_tail;

    reg [PRICE_WIDTH-1:0] sell_prices [7:0];
    reg [QTY_WIDTH-1:0]   sell_qtys   [7:0];
    reg [ID_WIDTH-1:0]    sell_ids    [7:0];
    reg [2:0]             sell_head, sell_tail;

    integer i;

    // Reset logic
    always @(posedge clk) begin
        if (rst) begin
            buy_head <= 0; buy_tail <= 0;
            sell_head <= 0; sell_tail <= 0;
            match_valid <= 0;
        end
    end

    // Simple synchronous match/insert logic
    always @(posedge clk) begin
        match_valid <= 0;

        if (valid_in) begin
            if (side == 0) begin
                // Incoming buy order
                if ((sell_head != sell_tail) && price >= sell_prices[sell_head]) begin
                    // Match buy with best sell
                    match_valid       <= 1;
                    match_price       <= sell_prices[sell_head];
                    match_qty         <= (qty < sell_qtys[sell_head]) ? qty : sell_qtys[sell_head];
                    match_client_id   <= sell_ids[sell_head];

                    // Reduce quantity or pop sell
                    if (qty >= sell_qtys[sell_head])
                        sell_head <= sell_head + 1;
                    else
                        sell_qtys[sell_head] <= sell_qtys[sell_head] - qty;
                end else begin
                    // Insert into buy book
                    buy_prices[buy_tail] <= price;
                    buy_qtys[buy_tail]   <= qty;
                    buy_ids[buy_tail]    <= client_id;
                    buy_tail <= buy_tail + 1;
                end
            end else begin
                // Incoming sell order
                if ((buy_head != buy_tail) && price <= buy_prices[buy_head]) begin
                    // Match sell with best buy
                    match_valid       <= 1;
                    match_price       <= buy_prices[buy_head];
                    match_qty         <= (qty < buy_qtys[buy_head]) ? qty : buy_qtys[buy_head];
                    match_client_id   <= buy_ids[buy_head];

                    if (qty >= buy_qtys[buy_head])
                        buy_head <= buy_head + 1;
                    else
                        buy_qtys[buy_head] <= buy_qtys[buy_head] - qty;
                end else begin
                    // Insert into sell book
                    sell_prices[sell_tail] <= price;
                    sell_qtys[sell_tail]   <= qty;
                    sell_ids[sell_tail]    <= client_id;
                    sell_tail <= sell_tail + 1;
                end
            end
        end
    end

endmodule
