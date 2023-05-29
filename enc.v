module LED_Decoder(
    input wire clk,
    input wire reset,
    input wire [4:0] encoded_data,
    output wire blue_led
);

reg [4:0] encoded_data_reg;
reg [3:0] count;
reg [3:0] led_duration;
reg blue_led_reg;

parameter BLUE = 1'b1;

// Yanma sürelerini tutan tablo
reg [25:0] duration_table [25:0];

initial begin
    duration_table[0] = 1;   // a için 1 saniye
    duration_table[1] = 2;   // b için 2 saniye
    duration_table[2] = 3;   // c için 3 saniye
    duration_table[3] = 4;   // d için 4 saniye
    duration_table[4] = 5;   // e için 5 saniye
    duration_table[5] = 6;   // f için 6 saniye
    // ...
    duration_table[24] = 25; // y için 25 saniye
    duration_table[25] = 26; // z için 26 saniye
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        encoded_data_reg <= 5'b00000;
        count <= 4'b0000;
        led_duration <= 4'b0000;
        blue_led_reg <= 1'b0;
    end else begin
        encoded_data_reg <= encoded_data;
        
        if (count < 11) begin  // 'üvnseritsinede' kelimesinin uzunluğu 11
            blue_led_reg <= 1'b1;
            led_duration <= duration_table[encoded_data_reg[count]];
            count <= count + 1;
        end else begin
            blue_led_reg <= 1'b0;
        end
    end
end

assign blue_led = (led_duration > 0) ? BLUE : ~BLUE;

endmodule
