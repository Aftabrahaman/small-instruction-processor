`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2025 07:54:51 PM
// Design Name: Small instruction Processor
// Module Name: top
// Project Name: Building a small instructon processor 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 

//////////////////////////////////////////////////////////////////////////////////
`define op_type IR[31:27]
`define rdst    IR[26:22]
`define rsrc1   IR[21:17]
`define im_mode IR[16]
`define rsrc2   IR[15:11]
`define imsrc   IR[15:0]

////////////define the  Airthmatic operatio type////////
`define movesgpr  5'b00000
`define move      5'b00001
`define add       5'b00010
`define sub       5'b00011
`define mul       5'b00100

////////////// define the Logical operations //////////////
`define ror       5'b00101
`define rand      5'b00110
`define rxor      5'b00111
`define rxnor     5'b01000
`define rnand     5'b01001
`define rnor      5'b01010
`define rnot      5'b01011

////////////// define load and send from data memory////////////////////////////

`define storereg  5'b01100 //////////////store the data from Register to data memory
`define storedin  5'b01101 //////////////store the data from din bus to data memory
`define sendreg   5'b01110 //////////////send back data from data memory to register
`define senddout  5'b01111 /////////////send data to output bus 

///////////////// define the jump and brunches instruction ////////////////////////
`define jmp       5'b10000  ////jump to an adderress
`define jmp_sign  5'b10001 /////jump if sign bit is 1
`define jmp_nosign  5'b10010
`define jmp_zero    5'b10011 ///jump  if zero bit is 1
`define jmp_nozero  5'b10100
`define jmp_carry   5'b10101 ///jump if carry
`define jmp_nocarry 5'b10110
`define jmp_ov      5'b10111  ////jump if overflow 
`define jmp_nov     5'b11000 

////////////////define halt //////////////////////
`define halt        5'b11001 /////program will halt unless reset is applied 


module top(
input  clk ,sys_rst,
input [15:0] din,
output reg [15:0] dout );

reg [31:0] prog_mem[15:0]; /////programe  memory 
reg [15:0] data_mem [15:0];/////data memory


reg [31:0] IR; ////DIVISION --- IR[31:27],,,IR[26:22],,,IR[21:17],,,IR[16],,,,IR[15:11],,,,IR[10:0]
               /// fields--     op_type ,,,destination ,,,source1,,,mode,,,,,source2,,,,,unused 

reg [15:0] GPR [31:0];////////General Purpose Register
reg [15:0] SGPR;///////////Special General purpose register to store the msb of multiplication
reg [31:0] temp_mul;///////temporary variable to store the result of operation


reg jmp_flag=0;
reg stop=0;

reg zero =0,carry=0,sign=0,overflow=0; //////control flags////////

task debug_inst();
 begin
 
 jmp_flag=0;
 stop=0;
case(`op_type)

`movesgpr : begin
    GPR[`rdst]=SGPR;
    end

`move : begin
    if(`im_mode)
        GPR[`rdst]=`imsrc;
    else
        GPR[`rdst]=`rsrc1;
    end
    
 `add : begin
    if(`im_mode)
        GPR[`rdst]= GPR[`rsrc1] + `imsrc;
    else
        GPR[`rdst]= GPR[`rsrc1] + GPR[`rsrc2];
    end
    
`sub : begin
    if(`im_mode)
        GPR[`rdst]=GPR[`rsrc1] - `imsrc;
    else
        GPR[`rdst]=GPR[`rsrc1] - GPR[`rsrc2];
    end
        
`mul : begin
    if(`im_mode)
        temp_mul =GPR[`rsrc1] * `imsrc;
    else
       temp_mul =GPR[`rsrc1] * GPR[`rsrc2];
        
     GPR[`rdst]= temp_mul[15:0];
     SGPR      = temp_mul[31:16];
    
    end
    
 `ror : begin 
    if(`im_mode)
        GPR[`rdst]=GPR[`rsrc1] | `imsrc;
    else
        GPR[`rdst]=GPR[`rsrc1] | GPR[`rsrc2];
    end
    
  `rand : begin 
    if(`im_mode)
        GPR[`rdst]=GPR[`rsrc1] & `imsrc;
    else
        GPR[`rdst]=GPR[`rsrc1] & GPR[`rsrc2];
    end
    
`rxor : begin 
    if(`im_mode)
        GPR[`rdst]=GPR[`rsrc1] ^ `imsrc;
    else
        GPR[`rdst]=GPR[`rsrc1] ^ GPR[`rsrc2];
    end
    
 `rxnor : begin 
    if(`im_mode)
        GPR[`rdst]=GPR[`rsrc1] ~^ `imsrc;
    else
        GPR[`rdst]=GPR[`rsrc1] ~^ GPR[`rsrc2];
    end
    
`rnand : begin 
    if(`im_mode)
        GPR[`rdst]= ~(GPR[`rsrc1] & `imsrc);
    else
        GPR[`rdst]= ~(GPR[`rsrc1] & GPR[`rsrc2]);
    end
    
`rnor : begin 
    if(`im_mode)
        GPR[`rdst]= ~(GPR[`rsrc1] | `imsrc);
    else
        GPR[`rdst]= ~(GPR[`rsrc1] | GPR[`rsrc2]);
    end
 
`rnot : begin 
    if(`im_mode)
        GPR[`rdst]= ~(`imsrc);
    else
        GPR[`rdst]= ~(GPR[`rsrc1]);
    end
    
 `storereg : begin
    data_mem[`imsrc]=GPR[`rsrc1];
    end 
    
 `storedin  : begin
    data_mem[`imsrc]= din;
    end 
    
 `senddout   : begin
    dout=data_mem[`imsrc];
    end 
    
 `sendreg : begin
    GPR[`rdst]=data_mem[`imsrc];
    end 
    
    
 `jmp  : begin
    jmp_flag=1'b1;
    end 
    
 `jmp_sign : begin
    if(sign==1'b1)begin
        jmp_flag=1'b1;
        end
    else 
        jmp_flag=1'b0;
   end 
   
  `jmp_nosign : begin
    if(sign==1'b0)begin
        jmp_flag=1'b1;
        end
    else 
        jmp_flag=1'b0;
   end 
   
  `jmp_zero : begin
    if(zero==1'b1)begin
        jmp_flag=1'b1;
        end
    else 
        jmp_flag=1'b0;
   end 
   
  `jmp_nozero : begin
    if(zero==1'b0)begin
        jmp_flag=1'b1;
        end
    else 
        jmp_flag=1'b0;
   end 
   
   `jmp_carry : begin
    if(carry==1'b1)begin
        jmp_flag=1'b1;
        end
    else 
        jmp_flag=1'b0;
   end 
   
   `jmp_nocarry : begin
    if(carry==1'b0)begin
        jmp_flag=1'b1;
        end
    else 
        jmp_flag=1'b0;
   end 
   
   `jmp_ov : begin
    if(overflow==1'b1)begin
        jmp_flag=1'b1;
        end
    else 
        jmp_flag=1'b0;
   end
   
  `jmp_nov : begin
    if(overflow==1'b0)begin
        jmp_flag=1'b1;
        end
    else 
        jmp_flag=1'b0;
   end 
   
  `halt : begin
    stop=1'b1;
    end 
   
   endcase
   end
   endtask 
   
////////////////logic  for condition flag////////////////
reg [16:0] temp_add;

task debug_conditional_flag();
begin
///////zero bit ////////////////
if(`op_type==`mul)
    zero=~((|SGPR[15])|(|GPR[`rdst]));
else 
    zero=~(|GPR[`rdst]);

//////carry bit ///////////

if(`op_type==`add)begin
    if(`im_mode)begin
        temp_add=GPR[`rsrc1] + `imsrc;
        carry=temp_add[16];
        end 
    else begin
        temp_add= GPR[`rsrc1] + GPR[`rsrc2];
        carry=temp_add[16];
        end 
       end 
else 
    carry=1'b0;
    
//////////////sign bit ///////////////////

if(`op_type==`mul)
    sign=SGPR[15];
else 
    sign = GPR[`rdst][15];
    
////////overflow bit /////////////////////

if (`op_type==`add)begin
    if(`im_mode)begin
    overflow= (~GPR[`rsrc1][15]&~IR[15]&GPR[`rdst][15]) | (GPR[`rsrc1][15]& IR[15] & ~GPR[`rdst]);
    end 
    else
    overflow=(~GPR[`rsrc1][15]&~GPR[`rsrc2][15]&GPR[`rdst][15]) | (GPR[`rsrc1][15]& GPR[`rsrc2][15] & ~GPR[`rdst]);
  end 
    
 else if(`op_type == `sub)
    begin
       if(`im_mode)
         overflow = ( (~GPR[`rsrc1][15] & IR[15] & GPR[`rdst][15] ) | (GPR[`rsrc1][15] & ~IR[15] & ~GPR[`rdst][15]) );
       else
         overflow = ( (~GPR[`rsrc1][15] & GPR[`rsrc2][15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & ~GPR[`rsrc2][15] & ~GPR[`rdst][15]));
    end 
    
 else
  overflow =1'b0;

end 
endtask

//////////////////////reading the program///////////////////////////////

initial begin
$readmemb("data.mem",prog_mem);
end 


reg [2:0] count=0;
integer pc=0;

always@(posedge clk)begin
if (sys_rst==1'b1)begin
    count<=0;
    pc<=0;
    end 
 else begin
    if(count<4)begin
        count<=count+1;
        end 
    else begin
        count<=0;
        pc<=pc+1;
        end  
   end 
 end 
 
 always@(*)begin
 if(sys_rst==1'b1)begin
   IR=0;
   end
 else begin
    IR=prog_mem[pc];
     debug_inst();
     debug_conditional_flag();
     end 
  end
  
//////////////////FSM state ///////////////////////////
parameter idle=0,fetch_inst=1,decode_inst=2,delay_inst=3,next_inst=4,sense_halt=5;
//////idle : check reset state
///// fetch_inst : load instrcution from Program memory
///// decode_inst : execute instruction + update condition flag
///// next_inst : next instruction to be fetched
////delay_inst  : delay between instruction
///// sense_halt : if yes stop the programe if not fetch new instruction

reg [2:0] state,next_state;

////////condition for next state /////////////////////////

always@(posedge clk)begin
    if(sys_rst==1'b1)begin
        state<=idle;
     end 
    else begin
        state<=next_state;
     end 
  end 
///////////////// next_state & output/////////////////////

always@(*)begin
case(state)

idle : begin
    IR=32'b0;
    pc=0;
    next_state=fetch_inst;
   end

fetch_inst : begin
    IR=prog_mem[pc];
    next_state=decode_inst;
    end
    
decode_inst : begin
    debug_inst();
    debug_conditional_flag();
    next_state=delay_inst;
   end
   
delay_inst : begin
    if(count<4)
        next_state=delay_inst;
    else 
        next_state=next_inst;
   end 
  
next_inst : begin
   next_state = sense_halt;
   if (jmp_flag==1'b1)
    pc=`imsrc;
   else 
   pc=pc+1;
   end 

sense_halt : begin
    if(stop==1'b0)
        next_state=fetch_inst;
    else if (sys_rst==1'b1)
        next_state=idle;
    else 
        next_state=sense_halt;
     end 

default : next_state=idle;

    endcase 
  end 
  
////////////////////////////////// count update 

always@(posedge clk)
begin
case(state)
 
 idle : begin
    count <= 0;
 end
 
 fetch_inst: begin
   count <= 0;
 end
 
 decode_inst : begin
   count <= 0;    
 end  

 delay_inst: begin
   count  <= count + 1;
 end

  next_inst : begin
    count <= 0;
 end
 
  sense_halt : begin
    count <= 0;
 end
 
 default : count <= 0;
 
  
endcase
end

          
        
endmodule
