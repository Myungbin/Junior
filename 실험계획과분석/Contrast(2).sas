/* 대비 */
data a;
input temp response @@;
cards;
 30 5 30 9 30 10
 60 8 60 12
 90 19 90 25
;
 
proc glm data = a;
 class temp;
 model response = temp;
 contrast '직선관계' temp -1 0 1;
 contrast '곡선관계(2차)' temp 1 -2 1; 
run;

proc sgplot data = a;
  scatter x=temp y=response;
run;