/*module DLatch(input D,clock,CLR,PRE,output  Q,notQ );
wire w1,w2,notD,notPRE,notCLR;
not not1(notD,D),not2(notPRE,PRE),not3(notCLR,CLR);
nand nand1(w1,D,clock),nand2(w2,clock,notD),
    nand3(Q,notPRE,w1,notQ), nand4(notQ,notCLR,Q,w2);

endmodule*/
//-----------------------------
module D_FlipFlop(output reg  Q,notQ,input D,input clock,input CLR,PRE);
/*wire Qm,notClock,notQm,slaveQ,slaveNotQ;
not not1(notClock,clock);
DLatch master(D,notClock,CLR,PRE,Qm,notQm),slave(Qm,clock,1'b0,1'b0,Q,notQ);
*///and and1(Q,slaveQ,notC)
always @(posedge clock or posedge CLR or posedge PRE)
begin
    if(CLR)Q <= 0;
    else if(PRE)Q <= 1;
    else Q <= D;
end

/*
wire w1,w2,w3,w4,notCLR,notPRE;
not not1(notCLR,CLR);
not not2(notPRE,PRE);
nand nand1(w1,notPRE,w4,w2);
nand nand2(w2,clock,notCLR,w1);
nand nand3(w3,w2,w4,clock);
nand nand4(w4,D,w3,notCLR);
nand nand5(Q,w2,notPRE,notQ);
nand nand6(notQ,w3,notCLR,Q);
*/

endmodule
//----------------------------------------
module D_FlipFlop_Testench();
reg clk,D,CLR,PRE;
wire Q,notQ;
D_FlipFlop d(Q,notQ,D,clk,CLR,PRE);

initial begin 
    clk=0;
    forever begin
        #100;
        clk=~clk;
    end


end
initial begin
    #50;
    CLR=0;
    PRE=1;
    #100;
    PRE=0;
    #100;
    D=0;
    #100;
    D=1;
    #100;
    D=0;




end

endmodule


//----------------------------------------
/*module JK_FlipFlop(input J,K,clock,CLR,PRE,output  Q,notQ);
/*wire w1,w2,w3,w5,w4;
not not1(w1,Q);
not not2(w2,K);
and  and1(w3,w2,Q);
and and2(w4,w1,J);
or or1(w5,w3,w4);
D_FlipFlop ff(Q,notQ,w5,clock,CLR,PRE);*/

/*wire w1,w2,w3,w4,w5,w6;//,notClock;

and and1(w1,w6,notQ),
    and2(w2,notQ,clock),
    and3(w3,Q,~CLR,w5),
    and4(w4,Q,~CLR,clock);
nor nor1(Q,w1,w2),
    nor2(notQ,w3,w4);
nand nand1(w5,K,Q,clock),
    nand2(w6,J,notQ,clock,~CLR);
//not not1(notClock,clock);



endmodule*/
//----------------------------------
module JK_FlipFlop(j,k,clk,CLR,PRE,q,notq);
input clk,CLR,PRE,j,k;
output reg q,notq;

always @ (posedge clk or posedge CLR or posedge PRE)
begin
    if(CLR)
        q <= 0;
    else if(PRE)
         q<= 1;
    else begin
        case({j,k}) 
            2'b00:
                q <= q;
            2'b01:
                q <= 0;
            2'b10:
                q <= 1;
            2'b11:
                q <= ~q;
            //default:
            //    q <= q;
        endcase
    end
    assign notq=~q;
end
                
endmodule
//-------------------------------------------------------------
module JK_FlipFlop_Testench();
reg clk,J,K,CLR,PRE;
wire Q,notQ;
JK_FlipFlop jk(J,K,clk,CLR,PRE,Q,notQ);

initial begin 
    //CLR=0;
    //PRE=0;
    clk=0;
    forever begin
        #100;
        clk=~clk;
    end
end
initial begin
    CLR=1;
    PRE=0;
    #20;
    CLR=0;
    //#400;
    //PRE=0;
    //#50;
    J=0;
    K=0;
    #100;
    J=1;
    K=0;
    #200;
    J=0;
    K=1;
    #200
    PRE=1;
    #400;
    PRE=0;
    J=1;
    K=1;
    #200;
    J=0;
    K=0;
    #200;
end

endmodule
//----------------------------------------
/*module UpDownCounter(output  [7:0] num,
                    output  DownOverf,UpOverf,
                    input UpDown,clock,CLR,PRE,Hold
                    );//8 bits
wire UpDownNot,newClock,notHold;
not not1(UpDownNot,UpDown);
wire JK1,JK2,JK3,JK4,JK5,JK6,JK7;
wire notQ0,notQ1,notQ2,notQ3,notQ4,notQ5,notQ6,notQ7;
wire D0,U0,D1,U1,D2,U2,D3,U3,D4,U4,D5,U5,D6,U6;

not not2(notHold,Hold);
and  andclock(newClock,clock,notHold);

and andD0(D0,notQ0,UpDownNot);
and andU0(U0,num[0],UpDown);

and andD1(D1,notQ1,D0);
and andU1(U1,num[1],U0);

and andD2(D2,notQ2,D1);
and andU2(U2,num[2],U1);

and andD3(D3,notQ3,D2);
and andU3(U3,num[3],U2);

and andD4(D4,notQ4,D3);
and andU4(U4,num[4],U3);

and andD5(D5,notQ5,D4);
and andU5(U5,num[5],U4);

and andD6(D6,notQ6,D5);
and andU6(U6,num[6],U5);

and andD7(DownOverf,notQ7,D6);
and andU7(UpOverf,num[7],U6);

or or1(JK1,U0,D0);
or or2(JK2,U1,D1);
or or3(JK3,U2,D2);
or or4(JK4,U3,D3);
or or5(JK5,U4,D4);
or or6(JK6,U5,D5);
or or7(JK7,U6,D6);

JK_FlipFlop f0(1'b1,1'b1,newClock,CLR,PRE,num[0],notQ0);
JK_FlipFlop f1(JK1,JK1,newClock,CLR,PRE,num[1],notQ1);
JK_FlipFlop f2(JK2,JK2,newClock,CLR,PRE,num[2],notQ2);
JK_FlipFlop f3(JK3,JK3,newClock,CLR,PRE,num[3],notQ3);
JK_FlipFlop f4(JK4,JK4,newClock,CLR,PRE,num[4],notQ4);
JK_FlipFlop f5(JK5,JK5,newClock,CLR,PRE,num[5],notQ5);
JK_FlipFlop f6(JK6,JK6,newClock,CLR,PRE,num[6],notQ6);
JK_FlipFlop f7(JK7,JK7,newClock,CLR,PRE,num[7],notQ7);
endmodule*/
//----------------------------------------
/*module UpDownCounter_Testbench();
reg Hold,PRE,CLR,clk,UpDown;
wire DownOverf,UpOverf;
wire [7:0] num;
//assign num=8'b0_0_0_0_0_0_0_0;
UpDownCounter counter(num,DownOverf,UpOverf,UpDown,clk,CLR,PRE,Hold);
/*initial begin 
    //CLR=0;
    //PRE=0;
    clk=0;
    forever begin
        #100;
        clk=~clk;
    end
end*/
/*initial begin
     //#200;
    clk=0;   
    Hold=0;
    PRE=0;
    UpDown=1;
    CLR=1;
    #100;
    
    CLR=0;
    forever begin
        #200;
        clk=~clk;
    end


end

endmodule*/
//------------------------------------------------------------------
module UpCounter(output  [7:0] num,
                    output Overflow,
                    input clock,CLR/*,PRE*/,Hold
                    );//8 bits
wire newClock,notHold;
wire JK2,JK3,JK4,JK5,JK6,JK7;
wire notQ0,notQ1,notQ2,notQ3,notQ4,notQ5,notQ6,notQ7;

not not2(notHold,Hold);
and  andclock(newClock,clock,notHold);

and and2(JK2,num[1],num[0]);
and and3(JK3,num[2],JK2);
and and4(JK4,num[3],JK3);
and and5(JK5,num[4],JK4);
and and6(JK6,num[5],JK5);
and and7(JK7,num[6],JK6);
and and8(Overflow,num[7],JK7);


JK_FlipFlop f0(1'b1,1'b1,newClock,CLR,1'b_0,num[0],notQ0);
JK_FlipFlop f1(num[0],num[0],newClock,CLR,1'b_0,num[1],notQ1);
JK_FlipFlop f2(JK2,JK2,newClock,CLR,1'b_0,num[2],notQ2);
JK_FlipFlop f3(JK3,JK3,newClock,CLR,1'b_0,num[3],notQ3);
JK_FlipFlop f4(JK4,JK4,newClock,CLR,1'b_0,num[4],notQ4);
JK_FlipFlop f5(JK5,JK5,newClock,CLR,1'b_0,num[5],notQ5);
JK_FlipFlop f6(JK6,JK6,newClock,CLR,1'b_0,num[6],notQ6);
JK_FlipFlop f7(JK7,JK7,newClock,CLR,1'b_0,num[7],notQ7);
endmodule
//----------------------------------------
module UpCounter_Testbench();
reg Hold,PRE,CLR,clk;
wire Overf;
wire [7:0] num;
UpCounter counter(num,Overf,clk,CLR,Hold);
initial begin
    clk=0; 
    forever begin
        #200;
        clk=~clk;
    end
end
initial begin  
    #200;    
    Hold=0;
    PRE=0;
    CLR=1;
    #100;
    CLR=0;
    #600;
    Hold=1;
    
end

endmodule
//-------------------------------------------------------
/*module GetMoney(input reg money,
                clock,price,CLR,
                 Hold500, Hold1000, Hold2000, Hold5000,
                output moneySum);
wire num500,num1000,num2000,num5000;
wire Overf500,Overf1000,Overf2000,Overf5000;
///reg Hold500,Hold1000,Hold2000,Hold5000;


    UpCounter Coin500(num500,Overf500,clock,CLR,Hold500);
    UpCounter Coin1000(num1000,Overf1000,clock,CLR,Hold1000) ; 
    UpCounter Cion2000(num2000,Overf2000,clock,CLR,Hold2000);
    UpCounter Paper5000(num5000,Overf5000,clock,CLR,Hold5000);
    always @(posedge money)begin
        case(money)
        'd500:begin
            Hold500=0;
            #100;
            Hold500=1;




        end

        'd1000:begin


        end
        'd5000:begin


        end
        'd2000:begin


        end
        default begin


        end
        endcase
    end


endmodule*/
//-----------------------------------------------
/*module GetMoney_Testbench();
reg clk,price,CLR,Hold500,Hold1000,Hold2000,Hold5000;
wire moneySum;
initial begin
    clk=0; 
    forever begin
        #100;
        clk=~clk;
    end
end
initial begin
    Hold500=0;
    Hold1000=0;
    Hold2000=0;
    Hold5000=0;
    CLR=1;
    #100;
    Hold500=1;
    Hold1000=1;
    Hold2000=1;
    Hold5000=1;
    CLR=0; 
    price='d500;




end
GetMoney get(money,
                clk,price,CLR,
                Hold500,Hold1000,Hold2000,Hold5000,
                moneySum);


endmodule*/
//---------------------------------------------
module Decoder3to8(input A,B,C,output m0,m1,m2,m3,m4,m5,m6,m7);
and and0(m0,~A,~B,~C);
and and1(m1,~A,~B,C);
and and2(m2,~A,B,~C);
and and3(m3,~A,B,C);
and and4(m4,A,~B,~C);
and and5(m5,A,~B,C);
and and6(m6,A,B,~C);
and and7(m7,A,B,C);
endmodule
//---------------------------------
module Decoder3to8_Testbench();
reg A,B,C;
wire [7:0] m;
Decoder3to8 dec(A,B,C,m[0],m[1],m[2],m[3],m[4],m[5],m[6],m[7]);
initial
begin
    A=0;
    B=0;
    C=0;
    #100;
    A=0;
    B=0;
    C=1;
    #100;
    A=0;
    B=1;
    C=0;
    #100;
    A=0;
    B=1;
    C=1;
    #100;
    A=1;
    B=0;
    C=0;
    #100;
    A=1;
    B=0;
    C=1;
    #100;
    A=1;
    B=1;
    C=0;
    #100;
    A=1;
    B=1;
    C=1;
    #100;

end
endmodule
//-------------------------
module Comparator_4Bit(input [3:0] A,B,output AeB,AbB,AsB);
wire notA3,notA2,notA1,notA0;
wire notB3,notB2,notB1,notB0;
not Na3(notA3,A[3]),Na2(notA2,A[2]),Na1(notA1,A[1]),Na0(notA0,A[0]);
not Nb3(notB3,B[3]),Nb2(notB2,B[2]),Nb1(notB1,B[1]),Nb0(notB0,B[0]);
wire w31,w32,w22,w21,w12,w11,w02,w01;
and and32(w32,notA3,B[3]),
and31(w31,notB3,A[3]),
and22(w22,notA2,B[2]),
and21(w21,notB2,A[2]),
and12(w12,notA1,B[1]),
and11(w11,notB1,A[1]),
and02(w02,notA0,B[0]),
and01(w01,notB0,A[0]);
nor nor3(y3,w31,w32),
nor2(y2,w21,w22),
nor1(y1,w12,w11),
nor0(y0,w01,w02);
wire w1,w2,w3,w4,w5,w6;
and and1(w1,y3,w22),
and2(w2,y3,w21),
and3(w3,y3,y2,w12),
and4(w4,y3,y2,w11),
and5(w5,y3,y2,y1,w02),
and6(w6,y3,y2,y1,w01),
and7(AeB,y3,y2,y1,y0);
or or1(AsB,w32,w1,w3,w5),
or2(AbB,w6,w4,w2,w31);


endmodule
//-----------------------------------------------
module Comparator_4Bit_Testbench();
reg [3:0]A,B;
wire e,b,s;
Comparator_4Bit com(A,B,e,b,s);
initial begin
    A=4'b_0_0_0_0;
    B=4'b_0_0_0_0;
    #100;
    A=4'b_1_0_0_0;
    B=4'b_0_0_0_0;
    #100;
    A=4'b_1_0_0_0;
    B=4'b_1_0_0_0;
    #100;
    A=4'b_0_1_0_0;
    B=4'b_1_0_0_1;
    #100;
    A=4'b_1_1_0_0;
    B=4'b_1_0_1_0;
    #100;
end
endmodule
//-----------------------------------------------------
module LoadRegister2Bit(input load,clk,clr,[1:0]I,output [1:0]A);
wire notload;
wire w1,w2,w3,w4,w5,w6,nQ0,nQ1;

not not1(notload,load);
and and1(w1,A[0],notload);
and and2(w2,I[0],load);
and and3(w3,A[1],notload);
and and4(w4,I[1],load);
or or1(w5,w1,w2);
or or2(w6,w3,w4);
D_FlipFlop d1(A[0],nQ0,w5,clk,clr,1'b_0);
D_FlipFlop d2(A[1],nQ1,w6,clk,clr,1'b_0);
endmodule
//----------------------------------------------------------
module LoadRegister2Bit_Testbench();
reg load,CLR;
reg [1:0] I;
reg clk;
wire [1:0] A;
LoadRegister2Bit lr(load,clk,CLR,I,A);
initial begin
    clk=1; 
    forever begin
        #100;
        clk=~clk;
    end
end
initial begin
    CLR=1;
    #50;
    CLR=0;
    load=1;
    I=2'b_0_1;
    #100;
    load=0;
    #200;
    load=1;
    I=2'b_1_0;
    #100;
    load=0;
    I=2'b_1_1;
end

endmodule
//--------------------------------------------------
module LoadRegister8Bit(input load,clk,clr,[7:0]I,output [7:0]A);
wire D0,D1,D2,D3,D4,D5,D6,D7;
wire w01,w02,w11,w12,w21,w22,w31,w32,w41,w42,w51,w52,w61,w62,w71,w72;
wire notload;
not not1(notload,load);
//0
and and01(w01,A[0],notload);
and and02(w02,I[0],load);
or or0(D0,w01,w02);
D_FlipFlop d0(A[0],,D0,clk,clr,1'b0);
//1
and and11(w11,A[1],notload);
and and12(w12,I[1],load);
or or1(D1,w11,w12);
D_FlipFlop d1(A[1],,D1,clk,clr,1'b0);
//2
and and21(w21,A[2],notload);
and and22(w22,I[2],load);
or or2(D2,w21,w22);
D_FlipFlop d2(A[2],,D2,clk,clr,1'b0);
//3
and and31(w31,A[3],notload);
and and32(w32,I[3],load);
or or3(D3,w31,w32);
D_FlipFlop d3(A[3],,D3,clk,clr,1'b0);
//4
and and41(w41,A[4],notload);
and and42(w42,I[4],load);
or or4(D4,w41,w42);
D_FlipFlop d4(A[4],,D4,clk,clr,1'b0);
//5
and and51(w51,A[5],notload);
and and52(w52,I[5],load);
or or5(D5,w51,w52);
D_FlipFlop d5(A[5],,D5,clk,clr,1'b0);
//6
and and61(w61,A[6],notload);
and and62(w62,I[6],load);
or or6(D6,w61,w62);
D_FlipFlop d6(A[6],,D6,clk,clr,1'b0);
//7
and and71(w71,A[7],notload);
and and72(w72,I[7],load);
or or7(D7,w71,w72);
D_FlipFlop d7(A[7],,D7,clk,clr,1'b0);
//


endmodule
//-------------------------------------------------
module LoadRegister8Bit_Testbench();
reg load,CLR;
reg [7:0] I;
reg clk;
wire [7:0] A;
LoadRegister8Bit lr(load,clk,CLR,I,A);
initial begin
    clk=1; 
    forever begin
        #100;
        clk=~clk;
    end
end
initial begin
    CLR=1;
    #50;
    CLR=0;
    load=1;
    I=8'b_0_1_0_0_0_0_0_1;
    #100;
    load=0;
    #200;
    load=1;
    I=8'b_1_0_1_0_1_0_1_0;
    #100;
    load=0;
    I=8'b_0_0_0_0_0_0_0_0;
    #200;
    load=1;
    I=8'b_0_1_0_1_0_1_0_1;

end

endmodule
//--------------------------------------------------
module DeterminePrice(input [2:0] Key,input clk,output reg [7:0] ChosenPrice ,output [7:0] Prod);

reg load,clr;
Decoder3to8 dec(Key[2],Key[1],Key[0],Prod[0],Prod[1],Prod[2],Prod[3],Prod[4],Prod[5],Prod[6],Prod[7]);
wire [7:0] Prc0;
wire [7:0] Prc1;
wire [7:0] Prc2;
wire [7:0] Prc3;
wire [7:0] Prc4;
wire [7:0] Prc5;
wire [7:0] Prc6;
wire [7:0] Prc7;
LoadRegister8Bit p0(load,clk,clr,8'b_0_0_0_0_0_0_0_1,Prc0);
LoadRegister8Bit p1(load,clk,clr,8'b_0_0_0_0_0_0_1_0,Prc1);
LoadRegister8Bit p2(load,clk,clr,8'b_0_0_0_0_0_0_1_1,Prc2);
LoadRegister8Bit p3(load,clk,clr,8'b_0_0_0_0_0_1_0_0,Prc3);
LoadRegister8Bit p4(load,clk,clr,8'b_0_0_0_0_0_1_0_1,Prc4);
LoadRegister8Bit p5(load,clk,clr,8'b_0_0_0_0_0_1_1_0,Prc5);
LoadRegister8Bit p6(load,clk,clr,8'b_0_0_0_0_0_1_1_1,Prc6);
LoadRegister8Bit p7(load,clk,clr,8'b_0_0_0_0_1_0_0_0,Prc7);

initial begin
    //#100;
    clr=0;
    load=1;
    #200;
    load=0;
end

always @(Key[0] or Key[1] or Key[2])begin
    if(Prod[0])ChosenPrice<=Prc0;
    else if(Prod[1])ChosenPrice<=Prc1;
    else if(Prod[2])ChosenPrice<=Prc2;
    else if(Prod[3])ChosenPrice<=Prc3;
    else if(Prod[4])ChosenPrice<=Prc4;
    else if(Prod[5])ChosenPrice<=Prc5;
    else if(Prod[6])ChosenPrice<=Prc6;
    else if(Prod[7])ChosenPrice<=Prc7;
end
endmodule
//--------------------------------
module DeterminePrice_Testbench();

reg clk;
reg [2:0]Key;
wire [7:0]ChosenPrice;
DeterminePrice dp(Key,clk,ChosenPrice );
initial begin
    clk=0; 
    forever begin
        #100;
        clk=~clk;
    end
end
initial begin
    Key=3'b0_0_0;//0
    #100;
    Key=3'b0_1_0;//2
    #100;
    Key=3'b1_0_0;//4
    #100;
    Key=3'b0_0_1;//1
    #100;
    Key=3'b1_0_1;//5
    #100;
    Key=3'b0_1_1;//3
    #100;
    Key=3'b1_1_1;//7
    #100;
    Key=3'b1_1_0;//6
    #100;



end


endmodule
//------------------------------------------------------------------
module UpCounter_4Bit(output  [3:0] num,
                    output Overflow,
                    input clock,CLR,Hold
                    );//4 bits
wire newClock,notHold;
wire JK2,JK3;
wire notQ0,notQ1,notQ2,notQ3;

not not2(notHold,Hold);
and  andclock(newClock,clock,notHold);

and and2(JK2,num[1],num[0]);
and and3(JK3,num[2],JK2);
and and4(Overflow,num[3],JK3);

JK_FlipFlop f0(1'b1,1'b1,newClock,CLR,1'b0,num[0],notQ0);
JK_FlipFlop f1(num[0],num[0],newClock,CLR,1'b0,num[1],notQ1);
JK_FlipFlop f2(JK2,JK2,newClock,CLR,1'b0,num[2],notQ2);
JK_FlipFlop f3(JK3,JK3,newClock,CLR,1'b0,num[3],notQ3);
endmodule
//----------------------------------------
module UpCounter_4Bit_Testbench();
reg Hold,PRE,CLR,clk;
wire Overf;
wire [3:0] num;
UpCounter_4Bit counter(num,Overf,clk,CLR,Hold);
initial begin
    clk=0; 
    forever begin
        #200;
        clk=~clk;
    end
end
initial begin  
    #200;    
    Hold=0;
    PRE=0;
    CLR=1;
    #100;
    CLR=0;
    #600;
    Hold=1;
    #400;
    Hold=0;
    
end

endmodule
//----------------------------------------
module DownCounter_4Bit(output  [3:0] num,
                    output Overflow,
                    input clock,PRE,Hold
                    );//4 bits
wire newClock,notHold;
wire JK2,JK3;
wire notQ0,notQ1,notQ2,notQ3;

not not2(notHold,Hold);
and  andclock(newClock,clock,notHold);

and and2(JK2,notQ1,notQ0);
and and3(JK3,notQ2,JK2);
and and4(Overflow,notQ3,JK3);

JK_FlipFlop f0(1'b1,1'b1,newClock,1'b_0,PRE,num[0],notQ0);
JK_FlipFlop f1(notQ0,notQ0,newClock,1'b_0,PRE,num[1],notQ1);
JK_FlipFlop f2(JK2,JK2,newClock,1'b_0,PRE,num[2],notQ2);
JK_FlipFlop f3(JK3,JK3,newClock,1'b_0,PRE,num[3],notQ3);
endmodule
//------------------------------------------------------
module DownCounter_4Bit_Testbench();
reg Hold,PRE,clk;
wire Overf;
wire [3:0] num;
DownCounter_4Bit counter(num,Overf,clk,PRE,Hold);
initial begin
    clk=0; 
    forever begin
        #100;
        clk=~clk;
    end
end
initial begin  
    #50;    
    Hold=0;
    PRE=1;
    
    #100;
    PRE=0;
    #600;
    Hold=1;
    #400;
    Hold=0;
    
end

endmodule
//----------------------------------------
module Discount90(input [7:0] ChosenPrice,input [3:0] ChosenProdCount ,input More10Prod ,output reg [7:0] PayPrice);

always @(*) 
begin
    if(More10Prod)PayPrice <= 0.9*ChosenPrice*ChosenProdCount;
    else PayPrice <= ChosenPrice*ChosenProdCount;
end

endmodule
//------------------------------------------------
module Discount90_Testbench();
reg [7:0] ChosenPrice;
reg More10Prod;
wire [7:0]PayPrice;
Discount90 dis( ChosenPrice, More10Prod,PayPrice);
initial begin
    More10Prod=1;
    ChosenPrice = 8'b_0_0_0_0_0_0_0_0;
    #100;
    ChosenPrice = 8'b_0_0_0_0_1_1_0_0;
    #100;
    ChosenPrice = 8'b_0_0_0_1_0_1_0_0;
    #100;
    ChosenPrice = 8'b_0_0_0_1_1_1_0_0;
    #100;
    ChosenPrice = 8'b_0_0_0_0_0_1_0_0;
    #100;
    ChosenPrice = 8'b_0_0_0_1_0_0_0_1;
    #100;
    ChosenPrice = 8'b_0_0_1_0_1_0_0_0;
    #100;



end
endmodule