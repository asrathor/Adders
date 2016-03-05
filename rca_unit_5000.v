//module dedicated for testing
module testbench();
	wire [15:0] x,y,s;		//Instantiating wires	
	wire cin,cout;			//
	testAdder test(x,y,s,cout,cin);	//Test Module
	sixteenBitAdder adder (x,y,s,cout,cin);	//Circuit to be tested
endmodule

module testAdder(a,b,s,cout,cin);
	input [15:0] s;			//input sum as 16 bit vector
	input cout;			//input carry out
	output [15:0] a,b;		//output a and b 
	output cin;			//output carry in
	reg [15:0] a,b;			//register a,b
	reg cin;			//register cin
	integer i,seed,seed1;		//initializing integers and seed for bits
	initial 
		begin
		$monitor($time,", a=%d, b=%d, cin=%b, s=%d, cout=%b",a,b,cin,s,cout);	
		seed=16;		//represent bits i.e., upto 16 bits to be randomized
		seed1=1;			//upto 1 bit to be randomized
		
		for(i=0;i<5000;i=i+1) begin	//loop to be run 5000 times to create random numbers
		#100 a=$random(seed); b=$random(seed); cin=$random(seed1);	//for after every 100 time input are assigned to a,b,cin
			
		end			//end loop
		end			//end initial begin
endmodule	


module fulladder(a,b,c,s,cout);

	input a,b,c;					//inputs a,b and c
	output s,cout;					//outputs sum and carry out
	
	xor #1 (w1,a,b);				//xor gate whose output is w1 when inputs are a and b
	xor #1 (s,w1,c);				//xor gate whose output is s when inputs are w1 and c
	and #1 (w2,c,b);				//and gate whose output is w2 when inputs are c and b
	and #1 (w3,c,a);				//and gate whose output is w3 when inputs are c and a
	and #1 (w4,a,b);				//and gate whose output is w4 when inputs are a and b
	or #1  (cout,w2,w3,w4);				//or gate whose output is carryout when inputs are w2, w3 and w4

endmodule

module sixteenBitAdder(x,y,s,cout,cin);

	input [15:0] x,y;				//inputs x and y
	output [15:0] s;				//output sum
	input cin;					//input carry in
	output cout;					//output cout
	wire [15:0] c;					//combinational wire c

	//sixteen bit adder made from 16 full adders
	fulladder f0 (x[0],y[0],cin,s[0],c[0]);		
	fulladder f1 (x[1],y[1],c[0],s[1],c[1]);
	fulladder f2 (x[2],y[2],c[1],s[2],c[2]);
	fulladder f3 (x[3],y[3],c[2],s[3],c[3]);
	fulladder f4 (x[4],y[4],c[3],s[4],c[4]);
	fulladder f5 (x[5],y[5],c[4],s[5],c[5]);
	fulladder f6 (x[6],y[6],c[5],s[6],c[6]);
	fulladder f7 (x[7],y[7],c[6],s[7],c[7]);
	fulladder f8 (x[8],y[8],c[7],s[8],c[8]);
	fulladder f9 (x[9],y[9],c[8],s[9],c[9]);
	fulladder f10 (x[10],y[10],c[9],s[10],c[10]);
	fulladder f11 (x[11],y[11],c[10],s[11],c[11]);
	fulladder f12 (x[12],y[12],c[11],s[12],c[12]);
	fulladder f13 (x[13],y[13],c[12],s[13],c[13]);
	fulladder f14 (x[14],y[14],c[13],s[14],c[14]);
	fulladder f15 (x[15],y[15],c[14],s[15],cout);

endmodule



