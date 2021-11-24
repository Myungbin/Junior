/*test01.sas*/
data a;
input x @@;  
cards;*
1 1 1 2 2 2 2 3 3 3 3 3 4 4 4 4 4 4 4
;
proc means data=a;
 var x;
run;
