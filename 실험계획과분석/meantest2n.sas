/* meantest2n.sas*/
data a;
infile '/home/u59365068/데이터/bmi.txt';
input height weight year religion$ gender$ marriage$; 
/* input -> 안에 6개의 변수를 추가 하겠다 $표시는 문자*/
age = 2000 - year;
bmi = weight/(height/100)**2;

proc means;
var height weight age bmi;
run;

proc freq data=a;
 tables gender marriage religion * gender;
run;