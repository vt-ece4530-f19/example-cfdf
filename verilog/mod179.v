module mod179(
	      input wire 	clk,
	      input wire 	reset,
	      input wire [15:0] x,
	      input wire 	start,
	      output reg 	done,
	      output reg [7:0] 	z);
   
   localparam [2:0] load     = 3'b000,
     compute1 = 3'b001,
     inner    = 3'b010,
     compute2 = 3'b011,
     outer    = 3'b100,
     adj      = 3'b101;
   
   reg [15:0] 			q_reg, q_next;
   reg [15:0] 			r_reg, r_next;
   reg [ 2:0] 			state_reg, state_next;
   
   wire [15:0] 			mul;
   
   always @(posedge clk, posedge reset)
     begin
	q_reg     <= reset ? 16'b0 : q_next;
	r_reg     <= reset ? 16'b0 : r_next;
	state_reg <= reset ? load  : state_next;
     end
   
   assign mul = q_reg[7:0] * 8'd77;
   
   always @*
     begin
	q_next     = q_reg;
	r_next     = r_reg;
	state_next = state_reg;
	done       = 1'd0;
	z          = 8'd0;
	case (state_reg)
	  
	  load:
	    if (start) begin
	       q_next     = x[15:8];
	       r_next     = x[7:0];
	       state_next = compute1;
            end
	  
	  compute1: 
	    begin
	       r_next     = r_reg + mul[7:0];
	       q_next     = mul[15:8];
	       state_next = inner;
	    end
	  
	  inner:
	    if (q_reg != 16'd0)
	      state_next = compute1;
	    else
	      state_next = compute2;
	  
	  compute2:
	    begin
	       q_next     = r_reg[15:8];
	       r_next     = r_reg[7:0];
	       state_next = outer;
	    end
	  
	  outer:
	    if (q_reg != 16'd0)
	      state_next = compute1;
	    else
	      state_next = adj;
	  
	  adj:
	    begin
	       done = 1'd1;
	       z = (r_reg >= 8'd179) ? (r_reg - 8'd179) : r_reg;
	       state_next = load;
	    end
	  
	  default:
	    state_next = load;
	  
	endcase
     end
   
endmodule
