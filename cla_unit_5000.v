module testbench();
	//wire [3:0] a,b,sum,cout;
	wire [15:0] a,b,sum,cout;				//initializing wires for every output and input
	wire cin,gp,gg,xx4;
		testAdder test(a,b,sum,gp,gg,xx4,cin);		//test adder for testing the 16bit adder
		//cla adder(gp,gg,sum,cout,a,b,cin);
		cla16 adderr(sum,cout,gp,gg,xx4,a,b,cin);	//16bit carry lookaheah adder
endmodule

module testAdder(a,b,sum,gp,gg,xx4,cin);

	//input [3:0] cout,sum;
	input [15:0] sum;					//initializing sum as input
	input gp,gg,xx4;					//initializing gp(group propogate),gg(group generate) and xx4 here is the cout from 16 adder
	//output [3:0] a,b;
	output [15:0] a,b;					//initailizing a and b as outputs
	output cin;						//initializing cin as output
	//reg [3:0] a,b;	
	reg [15:0] a,b;						//reg a,b and cin
	reg cin;
	integer i,seed,seed1;					//declaring i, seed and seed1 as integers
	initial begin
	$monitor($time,", a=%d,b=%d,cin=%b,sum=%d,cout=%d",a,b,cin,sum,xx4);
	seed1=1;						//seed1 represents 1 bit number to be randomized,i.e., 0 or 1
	seed=16;						//seed represents 16 bit number to be randomized
	for(i=0;i<5000;i=i+1) begin				//loop creating 5000 random numbers
		#100 a=$random(seed);b=$random(seed);cin=$random(seed1);	//for every 100 time, random numbers are assigned to a,b,cin
	end							//end loop
	end							//end initial begin
endmodule

module cla(							//4 bit carry look ahead adder
	output gp,gg,						//outputs are group propogate(gp),group generate(gg),sum and cout
	output[3:0] sum,cout,					//inputs are a,b and cin
	input [3:0] a,b,
	input cin);
	
	//output [3:0] cout;	
	wire [3:0] p,g;						//wire to hold value of pg and gg at every bit

	xor #1 (p[0],a[0],b[0]);				//xor,and gates to get p and g for every bit 
	and #1 (g[0],a[0],b[0]);				//
		
	xor #1 (p[1],a[1],b[1]);				//
	and #1 (g[1],a[1],b[1]);				//
	
	xor #1 (p[2],a[2],b[2]);				//
	and #1 (g[2],a[2],b[2]);				//
	
	xor #1 (p[3],a[3],b[3]);				//
	and #1 (g[3],a[3],b[3]);				//
	
	and #1 (gp,p[0],p[1],p[2],p[3]);			//and gate for the equation group propogate gp=p0.p1.p2.p3
	wire w32,w321,w3210,w32100;				//wires used to represent result of the gates

	and #1 (w32,p[3],g[2]);					//equation: w32=p3.g2
	and #1 (w321,p[3],p[2],g[1]);				//equation: w321=p3.p2.p1
	and #1 (w3210,p[3],p[2],p[1],g[0]);			//equation: w3210=p3.p2.p1.g0
	
	and #1 (w32100,p[3],p[2],p[1],p[0],cin);		//equation: w32100=p3.p2.p1.p0.cin

	or  #1 (gg,g[3],w32,w321,w3210);			//equation: gg=g3+p3.g2+p3.p2.p1+p3.p2.p1.g0
	
	wire w21,w210,w2100,w10,w100,w00;			//wires used to represent result of the gates

	and #1 (w21,p[2],g[1]);					//equation: w21=p2.g1
	and #1 (w210,p[2],p[1],g[0]);				//equation: w210=p2.p1.g0
	and #1 (w2100,p[2],p[1],p[0],cin);			//equation: w2100=p2.p1.p0.cin
	and #1 (w10,p[1],g[0]);					//equation: w10=p1.g0
	and #1 (w100,p[1],p[0],cin);				//equation: w100=p1.p0.cin
	and #1 (w00,p[0],cin);					//equation: w00=p0.cin

	or  #1 (cout[0],g[0],w00);				//equation: cout[0]=g0+p0.cin
	or  #1 (cout[1],g[1],w10,w100);				//equation: cout[1]=g1+p1.g0+p1.p0.cin

	or  #1 (cout[2],g[2],w21,w210,w2100);			//equation: cout[2]=g2+p2.g1+p2.p1.g0+p2.p1.p0.cin

	or  #1 (cout[3],g[3],w32,w321,w3210,w32100);		//equation: cout[3]=g3+p3.g2+p3.p2.p1+p3.p2.p1.g0+p3.p2.p1.p0.cin

	xor #1 (sum[0],p[0],cin);				//equation: sum[0]=p0^cin
	xor #1 (sum[1],p[1],cout[0]);				//equation: sum[1]=p1^cout[0]
	xor #1 (sum[2],p[2],cout[1]);				//equation: sum[2]=p2^cout[1]
	xor #1 (sum[3],p[3],cout[2]);				//equationL sum[3]=p3^cout[2]

endmodule

module cla16(							//module for 16 bit carry lookahead adder
	output [15:0] sum,cout,					//sum,cout,gp,gg,xx4(final cout) are initialized as outputs
	output gp,gg,xx4,			
	input [15:0] a,b,					//a,b and cin are initialized as inputs
	input cin 
	);
	
	wire x1,x2,x3,x4,xx1,xx2,xx3;				//wires are declared to take in result of the gates
	wire [15:0] p,g; 					//wires for gp and gg to assign output of desired bit
	cla cla1(gp,gg,sum[3:0],cout[3:0],a[3:0],b[3:0],cin);	//cla with carry in as cin and for first 4 bits
	and #1 (x1, gp,cin);					//equation: x1=gp.cin
	or #1 (xx1,gg,x1);					//equation: xx1=gg+gp.cin (for 2 levels of carry)
	cla cla2(p[4],g[4],sum[7:4],cout[7:4],a[7:4],b[7:4],xx1);//cla with carry in as xx1 for the next 4 bits
	and #1 (x2,p[4],xx1);					//equation: x2=p4.(gg+gp.cin)
	or #1 (xx2,g[4],x2);					//equation: xx2=g4+p4.(gg+gp.cin)
	cla cla3(p[8],g[8],sum[11:8],cout[11:8],a[11:8],b[11:8],xx2);//cla with carry in as xx2 for the next 4 bits
	and #1 (x3,p[8],xx2);					//equation: x3=p8.(p4.(gg+gp.cin))
	or #1 (xx3,g[8],x3);					//equation: xx3=g8+p8.(p4.(gg+gp.cin))
	cla cla4(p[12],g[12],sum[15:12],cout[15:12],a[15:12],b[15:12],xx3);//cla with carry in as xx3 for the last 4 bits
	and #1 (x4, p[12],xx3);					//equation: x4=p12.(g8+p8.(gg+gp.cin))
	or #1 (xx4,g[12],x4);					//equation: xx4(final cout)=g12+p12.(g8+p8.(gg+gp.cin))
endmodule

