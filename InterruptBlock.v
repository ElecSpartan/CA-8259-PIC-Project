module IRR (
  input level_or_edge_flag ,  //from control
  input [7:0] mask, //from control
  input [7:0] clearHighest, //from ISR
  input clear, //from control
  
  input i0,
  input i1,
  input i2,
  input i3,
  input i4,
  input i5,
  input i6,
  input i7,

  output reg[7:0] IRR, //to priority resolver
  output INT //to control
  );
  
reg prev_i0,prev_i1,prev_i2,prev_i3,prev_i4,prev_i5,prev_i6,prev_i7;  

  always @* begin
	if(level_or_edge_flag) begin
    IRR[0] <= i0 & ~mask[0];
    IRR[1] <= i1 & ~mask[1];
    IRR[2] <= i2 & ~mask[2];
    IRR[3] <= i3 & ~mask[3];
    IRR[4] <= i4 & ~mask[4];
    IRR[5] <= i5 & ~mask[5];
    IRR[6] <= i6 & ~mask[6];
    IRR[7] <= i7 & ~mask[7];
  end else begin
 // Edge-sensitive logic for each input
      if (i0 == 1'b1 && prev_i0 == 1'b0) begin
         IRR[0] <= 1'b1; 
      end else begin
         IRR[0] <= 1'b0;
      end
      if (i1 == 1'b1 && prev_i1 == 1'b0) begin
         IRR[1] <= 1'b1; 
      end else begin
         IRR[1] <= 1'b0;
      end
      if (i2 == 1'b1 && prev_i2 == 1'b0) begin
         IRR[2] <= 1'b1; 
      end else begin
         IRR[2] <= 1'b0;
      end
      if (i3 == 1'b1 && prev_i3 == 1'b0) begin
         IRR[3] <= 1'b1; 
      end else begin
         IRR[3] <= 1'b0;
      end	
      if (i4 == 1'b1 && prev_i4 == 1'b0) begin
         IRR[4] <= 1'b1; 
      end else begin
         IRR[4] <= 1'b0;
      end
      if (i5 == 1'b1 && prev_i5 == 1'b0) begin
         IRR[5] <= 1'b1;
      end else begin
         IRR[5] <= 1'b0;
      end
      if (i6 == 1'b1 && prev_i6 == 1'b0) begin
         IRR[6] <= 1'b1;
      end else begin
         IRR[6] <= 1'b0;
      end	 
      if (i7 == 1'b1 && prev_i7 == 1'b0) begin
         IRR[7] <= 1'b1; 
      end else begin
         IRR[7] <= 1'b0;
      end

 
   // Update the previous signals for the next iteration
      prev_i0 <= i0;
      prev_i1 <= i1;
      prev_i2 <= i2;
      prev_i3 <= i3;
      prev_i4 <= i4;
      prev_i5 <= i5;
      prev_i6 <= i6;
      prev_i7 <= i7;
      
   end
   
   if(clear) begin
        IRR = IRR & ~clearHighest;
      end
 end
 //sending to control that there is an interrupt
 
 assign INT =|IRR;
 
endmodule

module Priority_Resolver (input [7:0] IRR /*from IRR*/,input clear,input set,input reset/*from control */,
 output reg [7:0] chosen_interrupt /*to ISR*/ );
  
	reg [2:0] priority_status [0:7];  // Array for priority status
	reg [2:0] chosen ;
	reg [2:0] iterator0 ;
	reg [2:0] iterator1 ;
	reg [2:0] iterator2 ;
	reg [2:0] iterator3 ;
	reg [2:0] iterator4 ;
	reg [2:0] iterator5 ;
	reg [2:0] iterator6 ;
	reg [2:0] iterator7 ;
	
	reg prevset =0;
	reg prevreset =1;
	  
		
  always @* begin
    // Initialize priority status
    if((prevset == 0 && set == 1) || (prevreset == 1 && reset == 0))begin
      
      priority_status[0] = 0;
	    priority_status[1] = 1;
	    priority_status[2] = 2;
	    priority_status[3] = 3;
	    priority_status[4] = 4;
	    priority_status[5] = 5;
	    priority_status[6] = 6;
	    priority_status[7] = 7;
	    
	    prevset = set;
	    prevreset = reset;
	    
    end
	  if(set || !reset ) begin
	    ////////Automatic Rotation mode
		 //highest priority
		    iterator0 = (priority_status[0] == 0) ? 0 :
                 (priority_status[1] == 0) ? 1 :
                 (priority_status[2] == 0) ? 2 :
                 (priority_status[3] == 0) ? 3 :
                 (priority_status[4] == 0) ? 4 :
                 (priority_status[5] == 0) ? 5 :
		             (priority_status[6] == 0) ? 6 : 7;
    //2nd
		  iterator1 =(priority_status[0] == 1) ? 0 :
			  (priority_status[1] == 1) ? 1 :
			  (priority_status[2] == 1) ? 2 :
			  (priority_status[3] == 1) ? 3 :
			  (priority_status[4] == 1) ? 4 :
			  (priority_status[5] == 1) ? 5 :
			  (priority_status[6] == 1) ? 6 : 7;
		 //3rd
		  iterator2 = (priority_status[0] == 2) ? 0 :
			  (priority_status[1] == 2) ? 1 :
			  (priority_status[2] == 2) ? 2 :
			  (priority_status[3] == 2) ? 3 :
			  (priority_status[4] == 2) ? 4 :
			  (priority_status[5] == 2) ? 5 :
			  (priority_status[6] == 2) ? 6 : 7;
		 //4th 
		  iterator3 = (priority_status[0] == 3) ? 0 :
			  (priority_status[1] == 3) ? 1 :
			  (priority_status[2] == 3) ? 2 :
			  (priority_status[3] == 3) ? 3 :
			  (priority_status[4] == 3) ? 4 :
			  (priority_status[5] == 3) ? 5 :
			  (priority_status[6] == 3) ? 6 : 7;
      //5th
		   iterator4 = (priority_status[0] == 4) ? 0 :
			  (priority_status[1] == 4) ? 1 :
			  (priority_status[2] == 4) ? 2 :
			  (priority_status[3] == 4) ? 3 :
			  (priority_status[4] == 4) ? 4 :
			  (priority_status[5] == 4) ? 5 :
			  (priority_status[6] == 4) ? 6 : 7;
    //6th
		  iterator5 = (priority_status[0] == 5) ? 0 :
			  (priority_status[1] == 5) ? 1 :
			  (priority_status[2] == 5) ? 2 :
			  (priority_status[3] == 5) ? 3 :
			  (priority_status[4] == 5) ? 4 :
			  (priority_status[5] == 5) ? 5 :
			  (priority_status[6] == 5) ? 6 : 7;
    //7th
		  iterator6 = (priority_status[0] == 6) ? 0 :
			  (priority_status[1] == 6) ? 1 :
			  (priority_status[2] == 6) ? 2 :
			  (priority_status[3] == 6) ? 3 :
			  (priority_status[4] == 6) ? 4 :
			  (priority_status[5] == 6) ? 5 :
			  (priority_status[6] == 6) ? 6 : 7;
		  //least priority
		    iterator7 = (priority_status[0] == 7) ? 0 :
			  (priority_status[1] == 7) ? 1 :
			  (priority_status[2] == 7) ? 2 :
			  (priority_status[3] == 7) ? 3 :
			  (priority_status[4] == 7) ? 4 :
			  (priority_status[5] == 7) ? 5 :
			  (priority_status[6] == 7) ? 6 : 7;
			  
		   if(IRR[iterator0] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0000;
			  chosen_interrupt [iterator0] =1; 
			  chosen = iterator0;
		  end else if(IRR[iterator1]== 1'b1) begin
			  chosen_interrupt = 8'b0000_0000;
			  chosen_interrupt [iterator1] =1; 
			  chosen = iterator1;
		  end else if(IRR[iterator2] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0000;
			  chosen_interrupt [iterator2] =1; 
			  chosen = iterator2;
		  end else if(IRR[iterator3]== 1'b1) begin
			  chosen_interrupt = 8'b0000_0000;
			  chosen_interrupt [iterator3] =1; 
			  chosen = iterator3;
		  end else if(IRR[iterator4] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0000;
			  chosen_interrupt [iterator4] =1; 
			  chosen = iterator4;
		  end else if(IRR[iterator5] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0000;
			  chosen_interrupt [iterator5] =1; 
			  chosen = iterator5;
		  end else if(IRR[iterator6] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0000;
			  chosen_interrupt [iterator6] =1; 
			  chosen = iterator6;
		  end else if(IRR[iterator7] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0000;
			  chosen_interrupt [iterator7] =1;
			  chosen = iterator7; 
		  end
		

		 
		  //rotation
		priority_status[chosen] = 7;
		chosen = (chosen) > 0 ? (chosen-1):7;
		priority_status[chosen] = 6;
		chosen = (chosen) > 0 ? (chosen-1):7;
		priority_status[chosen] = 5;
		chosen = (chosen) > 0 ? (chosen-1):7;
		priority_status[chosen] = 4;
		chosen = (chosen) > 0 ? (chosen-1):7;
		priority_status[chosen] = 3;
		chosen = (chosen) > 0 ? (chosen-1):7;
		priority_status[chosen] = 2;
		chosen = (chosen) > 0 ? (chosen-1):7;
		priority_status[chosen] = 1;
		chosen = (chosen) > 0 ? (chosen-1):7;
		priority_status[chosen] = 0;
		  
		
	  end else begin
		  //fully nested mode
		  if(IRR[0] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0001;
		  end else if(IRR[1] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0010;
		  end else if(IRR[2] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0100;
		  end else if(IRR[3] == 1'b1) begin
			  chosen_interrupt = 8'b0000_1000;
		  end else if(IRR[4] == 1'b1) begin
			  chosen_interrupt = 8'b0001_0000;
		  end else if(IRR[5] == 1'b1) begin
			  chosen_interrupt = 8'b0010_0000;
		  end else if(IRR[6] == 1'b1) begin
			  chosen_interrupt = 8'b0100_0000;
		  end else if(IRR[7] == 1'b1) begin
			  chosen_interrupt = 8'b1000_0000;
		  end else begin 
			  //default no interrupt
		    chosen_interrupt = 8'b0000_0000;
		  end
	  end
	  if(clear)begin
	    chosen_interrupt = 8'b0000_0000;
	    end
	 end
endmodule

module ISR ( input [7:0] chosen_interrupt/*from priority resolver*/,input clear /*from control*/,output clearHighest ,output reg [7:0] ISR);

always @* begin
  ISR = chosen_interrupt;
  if(clear) begin
    ISR = 8'b0000_0000;
  end
end  
assign  clearHighest = chosen_interrupt;
endmodule

module InterruptBlock (
  //from control
  input level_or_edge_flag ,  
  input [7:0] mask,
  
  input clear,
  
  input set,
  input reset,
  
  //from peripherals
  input i0,
  input i1,
  input i2,
  input i3,
  input i4,
  input i5,
  input i6,
  input i7,

  //Outputs
output INTtocontrol,
output reg [7:0] ISRtocontrol
  );
  
  IRR(.level_or_edge_flag(level_or_edge_flag),.mask(mask),.clearHighest(OutclearHighest),.clear(clear),.i0(i0),.i1(i1),.i2(i2),.i3(i3),.i4(i5),
  .i6(i6),.i7(i7),.IRR(OutputIRR),.INT(INTtocontrol));
  
  Priority_Resolver (.IRR(OutputIRR),.clear(clear),.set(set),.reset(reset),
 .chosen_interrupt(Outputchosen_interrupt));
 
 ISR (.chosen_interrupt(Outputchosen_interrupt), .clear(clear),.clearHighest(OutclearHighest) ,.ISR(ISRtocontrol));  
  
  
endmodule
