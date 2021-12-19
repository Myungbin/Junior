data Heart;
input rpm blood@@;
datalines;
50 1.158 50 1.128 50 1.140 50 1.122 50 1.128
75 1.686 75 1.740 75 1.740
100 2.328 100 2.340 100 2.298 100 2.328 100 2.340
125 2.982 125 2.868 
150 3.540 150 3.480 150 3.504 150 3.612
;
proc glm data = Heart;
class rpm;
model blood = rpm;
contrast '관계식1차' rpm -2 -1 0 1 2;
contrast '관계식2차' rpm 2 -1 -2 -1 2;
contrast '관계식3차' rpm -1 2 0 -2 1;
contrast '관계식4차' rpm 1 -4 6 -4 1;
run;
proc sgplot data = Heart;
  scatter x=rpm y=blood;
run;

/*

Contrast	DF	Contrast SS	Mean Square	F Value	Pr > F
관계식1차	1	13.67362039	13.67362039	9393.25	<.0001
관계식2차	1	0.00041617	0.00041617	0.29	0.6013
관계식3차	1	0.00001370	0.00001370	0.01	0.9241
관계식4차	1	0.00008407	0.00008407	0.06	0.8136
회전속도에 따라 혈액의 양이 유의하다고 가정할 때, 회전속도가 혈액에 
미치는 관계는 1차식이다.
*/
