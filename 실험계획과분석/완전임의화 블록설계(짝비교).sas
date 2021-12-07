data a;
input x y;
cards;
10.6 10.2
 9.8  9.4
12.3 11.8
 9.7  9.1
 8.8  8.3
;
proc ttest;
 paired x*y;
run;
 
/*
The TTEST Procedure

Difference: x - y

N	Mean	Std Dev	Std Err	Minimum	Maximum
5	0.4800	0.0837	0.0374	0.4000	0.6000

Mean	95% CL Mean	Std Dev	95% CL Std Dev
0.4800	0.3761	0.5839	0.0837	0.0501	0.2404

DF	t Value	Pr > |t|
4	12.83	0.0002

*/

data a /* crbd1.sas */;
 input tire $ car wear @@;
 datalines;
A 1 10.4  A 2 10.9  A 3 10.5  A 4 10.7
B 1 12.4  B 2 12.4  B 3 12.3  B 4 12.0
C 1 13.1  C 2 13.4  C 3 12.9  C 4 13.3
D 1 11.8  D 2 11.8  D 3 11.4  D 4 11.4
;

proc glm data = a;
  class car tire;
  model wear = car tire;
run;

/*
Source	DF	Type III SS	Mean Square	F Value	Pr > F
car	3	0.27187500	0.09062500	2.81	0.1005
tire	3	13.92187500	4.64062500	143.71	<.0001

*/
