module ckt();
				//FOR DELAY 1
	wire s,cout,w,x,y,z;	//wires represent the output coming from each gate
	reg a,b,c;		//reg a,b,c represents the inputs
	xor #1 g1(w,a,b);		//w is output of xor gate whose input are a and b
	xor #1 g2(s,w,c);		//s is sum that is output of xor gate whose input are w and c
	and #1 g3(x,a,c);		//x is output of and gate whose input are a and c 
	and #1 g4(y,b,c);		//y is output of and gate whose input are b and c
	and #1 g5(z,a,b);		//z is output of and gate whose input are a and b
	or #1 g6(cout,x,y,z);	//cout is carryout that is the output of or gate

	//exhaustive display for all the posiible outputs
	initial begin
	$monitor($time," a=%b,b=%b,c=%b,s=%b,cout=%b",a,b,c,s,cout);
	//$display($time," a=%b,b=%b,c=%b,s=%b,cout=%b",a,b,c,s,cout);
	#0 a=0; b=0; c=0;
	#10 a=0; b=0; c=1;
	#10 a=0; b=1; c=0;
	#10 a=0; b=1; c=1;
	#10 a=1; b=0; c=0;
	#10 a=1; b=0; c=1;
	#10 a=1; b=1; c=0;
	#10 a=1; b=1; c=1;
	end
endmodule
