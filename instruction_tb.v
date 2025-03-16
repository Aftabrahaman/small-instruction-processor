`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2025 11:38:13 PM
// Design Name: 
// Module Name: instruction_tb
// Project Name: 
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


module instruction_tb();

integer i=0;
reg clk=0,sys_rst=0;
reg [15:0] din=0;
wire [15:0] dout;

top dut(clk,sys_rst,din,dout);

always #5 clk=~clk;

initial begin
sys_rst=1'b1;
repeat(5)@(posedge clk);
sys_rst=1'b0;
#800;
$stop;
end 

//initial begin
//for (i=0;i<32;i=i+1)begin
//dut.GPR[i]=3;
//end
//end

//initial begin 
//$display("---------------------------------------------------");
//dut.IR=0;
//dut.`op_type=2;
//dut.`im_mode=1;
//dut.`rdst=0;
//dut.`rsrc1=2;
//dut.`imsrc=5;
//#10;
//$display("OP : ADD rsrc1 :%0d   rsrc2 : %0d  rdst : %0d ",dut.GPR[2],dut.`imsrc,dut.GPR[0]);
//end

///////////////////////////// zero flag
//initial begin
//dut.IR  = 0;
//dut.GPR[0] = 0;
//dut.GPR[1] = 0; 
//dut.GPR[2]=0;
//dut.`im_mode = 0;
//dut.`rsrc1 = 0;//gpr[0]
//dut.`rsrc2 = 1;//gpr[1]
//dut.`op_type = 2;
//dut.`rdst = 2;//gpr[2]
//#10;
//$display("OP:Zero Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[0], dut.GPR[1], dut.GPR[2] );
//$display("-----------------------------------------------------------------");

////////////////////////////sign flag
//dut.IR = 0;
//dut.GPR[0] = 16'h8000; /////1000_0000_0000_0000
//dut.GPR[1] = 0; 
//dut.GPR[2]=0;
//dut.`im_mode = 0;
//dut.`rsrc1 = 0;//gpr[0]
//dut.`rsrc2 = 1;//gpr[1]
//dut.`op_type = 2;
//dut.`rdst = 2;//gpr[2]
//#10;
//$display("OP:Sign Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[0], dut.GPR[1], dut.GPR[2] );
//$display("-----------------------------------------------------------------");

//////////////////////////carry flag
//dut.IR = 0;
//dut.GPR[0] = 16'h8000; /////1000_0000_0000_0000   <0
//dut.GPR[1] = 16'h8002; /////1000_0000_0000_0010   <0
//dut.GPR[2]=0;
//dut.`im_mode = 0;
//dut.`rsrc1 = 0;//gpr[0]
//dut.`rsrc2 = 1;//gpr[1]
//dut.`op_type = 2;
//dut.`rdst = 2;    //////// 0000_0000_0000_0010  >0
//#10;

//$display("OP:Carry & Overflow Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[0], dut.GPR[1], dut.GPR[2] );
//$display("-----------------------------------------------------------------");

//#20;
//$finish;
//end
endmodule
