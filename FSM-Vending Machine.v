//00 means 500 coin
//01 mens 1000 coin
//10 means 2000 coin
//11 means 5000 paper

// product 0: 8'b_0_0_0_0_0_0_0_1
// product 1: 8'b_0_0_0_0_0_0_1_0
// product 2: 8'b_0_0_0_0_0_0_1_1
// product 3: 8'b_0_0_0_0_0_1_0_0
// product 4: 8'b_0_0_0_0_0_1_0_1
// product 5: 8'b_0_0_0_0_0_1_1_0
// product 6: 8'b_0_0_0_0_0_1_1_1
// product 7: 8'b_0_0_0_0_1_0_0_0

module FSM(input reg [2:0] Key,input [1:0] InsertedMoney, input AddProd,output [7:0]WarnSig,reg [7:0]ReleasProd);
reg loadState,CLRState;
wire [7:0] ChosenPrice;
reg [1:0] NextState;
reg clock;
wire [1:0] CurState;
wire [7:0] Prods;
LoadRegister2Bit State(loadState,clock,CLRState,NextState,CurState);
DeterminePrice dp(Key,clock,ChosenPrice,Prods);
//
reg [7:0] TotalMoney;
reg CLRDe,PREDe;
wire [7:0] Count500,Count1000,Count2000,Count5000;
wire Overf500,Overf1000,Overf2000,Overf5000;
reg Hold500,Hold1000,Hold2000,Hold5000;
UpCounter Coin500(Count500,Overf500,clock,CLRDe,Hold500);
UpCounter Coin1000(Count1000,Overf1000,clock,CLRDe,Hold1000) ; 
UpCounter Cion2000(Count2000,Overf2000,clock,CLRDe,Hold2000);
UpCounter Paper5000(Count5000,Overf5000,clock,CLRDe,Hold5000);
//
wire [3:0] ChosenProdCount;
wire ProdCounterOf;
UpCounter_4Bit ChProdCounter(ChosenProdCount,ProdCounterOf,clock,CLRDe,AddProd);
wire More10Prod;
Comparator_4Bit dis(ChosenProdCount,4'b_1_0_1_0,,More10Prod,);
wire [7:0]PayPrice;
Discount90 disc(ChosenPrice,ChosenProdCount, More10Prod,PayPrice);
//
wire [3:0] Mojoodi0,Mojoodi1,Mojoodi2,Mojoodi3,Mojoodi4,Mojoodi5,Mojoodi6,Mojoodi7;
wire HoldP0,HoldP1,HoldP2,HoldP3,HoldP4,HoldP5,HoldP6,HoldP7;

and andH0(HoldP0,AddProd,Prods[0]);
and andH1(HoldP1,AddProd,Prods[1]);
and andH2(HoldP2,AddProd,Prods[2]);
and andH3(HoldP3,AddProd,Prods[3]);
and andH4(HoldP4,AddProd,Prods[4]);
and andH5(HoldP5,AddProd,Prods[5]);
and andH6(HoldP6,AddProd,Prods[6]);
and andH7(HoldP7,AddProd,Prods[7]);

DownCounter_4Bit P0(Mojoodi0,,clock,PREDe,~HoldP0);
DownCounter_4Bit P1(Mojoodi1,,clock,PREDe,~HoldP1);
DownCounter_4Bit P2(Mojoodi2,,clock,PREDe,~HoldP2);
DownCounter_4Bit P3(Mojoodi3,,clock,PREDe,~HoldP3);
DownCounter_4Bit P4(Mojoodi4,,clock,PREDe,~HoldP4);
DownCounter_4Bit P5(Mojoodi5,,clock,PREDe,~HoldP5);
DownCounter_4Bit P6(Mojoodi6,,clock,PREDe,~HoldP6);
DownCounter_4Bit P7(Mojoodi7,,clock,PREDe,~HoldP7);

//wire WarnSig0,WarnSig1,WarnSig2,WarnSig3,WarnSig4,WarnSig5,WarnSig6,WarnSig7;

Comparator_4Bit WarninP0(Mojoodi0,4'b_0_1_0_1,,,WarnSig[0]);
Comparator_4Bit WarninP1(Mojoodi1,4'b_0_1_0_1,,,WarnSig[1]);
Comparator_4Bit WarninP2(Mojoodi2,4'b_0_1_0_1,,,WarnSig[2]);
Comparator_4Bit WarninP3(Mojoodi3,4'b_0_1_0_1,,,WarnSig[3]);
Comparator_4Bit WarninP4(Mojoodi4,4'b_0_1_0_1,,,WarnSig[4]);
Comparator_4Bit WarninP5(Mojoodi5,4'b_0_1_0_1,,,WarnSig[5]);
Comparator_4Bit WarninP6(Mojoodi6,4'b_0_1_0_1,,,WarnSig[6]);
Comparator_4Bit WarninP7(Mojoodi7,4'b_0_1_0_1,,,WarnSig[7]);
//
initial begin
    CLRState=1;
    #50;
    CLRState=0;

end
//----clock-----
initial begin
    clock=0; 
    forever begin
        #100;
        clock=~clock;
    end
end
//-------------
always @(*)
begin
    case(CurState)
    2'b_0_0 : //-----------IDLE---------------
    begin
        //@(Key[0] or Key[1] or Key[2])
        //begin
            CLRDe = 1;
            PREDe = 1;
            #50;
            CLRDe = 0;
            PREDe = 0;
            Hold500=1;
            Hold1000=1;
            Hold2000=1;
            Hold5000=1;

            NextState = 2'b_0_1;
            loadState = 1;
            #150;
            loadState = 0;



        //end



    end
    2'b_0_1 : //-------SELECT-----------
    begin
        //initial()
        @(PayPrice[0] or PayPrice[1] or PayPrice[2] or PayPrice[3] or PayPrice[4] or PayPrice[5] or PayPrice[6] or PayPrice[7])
        begin
            $display("Productu you selected totaly costs: %d ",PayPrice*500);
            NextState=2'b_1_0;
            loadState = 1;
            //PREDe = 1;
            #250;
            loadState = 0;
            //PREDe = 0; 
        end



    end
    2'b_1_0 ://------------inserting money
    begin 
        case(InsertedMoney)
        2'b_0_0 :
        begin
            Hold500 = 0;
            #100;
            Hold500 = 1;
            TotalMoney = TotalMoney+'d1;
            $display("You have payed: %d ",TotalMoney*'d500);
        end
        2'b_0_1 :
        begin
            Hold1000 = 0;
            #100;
            Hold1000 = 1;
            TotalMoney = TotalMoney+'d2;
            $display("You have payed: %d ",TotalMoney*'d500);
        end
        2'b_1_0 :
        begin
            Hold2000 = 0;
            #100;
            Hold2000 = 1;
            TotalMoney = TotalMoney+'d4;
            $display("You have payed: %d ",TotalMoney*'d500);
        end
        2'b_1_1 :
        begin
            Hold5000 = 0;
            #100;
            Hold5000 = 1;
            TotalMoney = TotalMoney+'d10;
            $display("You have payed: %d ",TotalMoney*'d500);
        end
        default :
        begin 
            $display("Inserted money is not supported");
        end
        endcase
        if(TotalMoney == ChosenPrice)
        begin
            $display("Pyment is done");
            NextState=2'b_1_1;
            loadState = 1;
            #100;
            loadState = 0;
        end
    end
    2'b_1_1://----DISPENSE------------
    begin
        
        $display(" Your product will be released soon ");
        ReleasProd = Prods;
        $display(" done ");
        CLRState = 1;
        #100;
        CLRState = 0;
    end
    endcase
end
endmodule
//--------------------------------------------------------------
module FSM_Testbench();
reg [2:0] Key;
reg [1:0] InsertedMoney;
reg AddProd;
wire [7:0] WarnSig,ReleasProd;
FSM machine(Key,InsertedMoney,AddProd,WarnSig,ReleasProd);
initial begin
    #250;
    Key=3'b_1_1_0;
    AddProd=0;
    #400;
    AddProd=1;
    #100;
    AddProd=0;
    InsertedMoney=2'b_0_1;
    #400;





end
endmodule