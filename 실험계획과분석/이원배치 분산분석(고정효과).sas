data a; /* twoway1.sas */
input machine employee defects @@;
cards;
1 1 20   1 1 18   1 1 14
1 2 19   1 2 20   1 2 20
2 1 14   2 1 18   2 1 14
2 2 12   2 2 12   2 2 9
3 1 13   3 1 16   3 1 13
3 2 9    3 2 4    3 2 4
;
proc glm data=a;
  class machine employee;
  model defects = machine employee machine * employee;
run;

/* 전체 분산분석표
Source	DF	Sum of Squares	Mean Square	F Value	Pr > F
Model	5	369.8333333	73.9666667	15.13	<.0001 
Error	12	58.6666667	4.8888889	 	 
Corrected Total	17	428.5000000	 	 	 

Model 자유도가 5인이유는 MSA,MSB,MSAB다 합쳤기 때문{전체모델이 유의한지(하나라도 유의한게 있는지)}

Source	DF	Type III SS	Mean Square	F Value	Pr > F
machine	2	229.3333333	114.6666667	23.45	<.0001
employee	1	53.3888889	53.3888889	10.92	0.0063
machine*employee	2	87.1111111	43.5555556	8.91	0.0042

각각의 요인에따라 분석을 해놓음
*/

data a; /* twoway2.sas 각 수준별 평균에 관련된것*/
input machine employee defects @@;
cards;
1 1 20   1 1 18   1 1 14
1 2 19   1 2 20   1 2 20
2 1 14   2 1 18   2 1 14
2 2 12   2 2 12   2 2 9
3 1 13   3 1 16   3 1 13
3 2 9    3 2 4    3 2 4
;
proc glm data=a;
  class machine employee;
  model defects = machine employee machine * employee;
  lsmeans machine*employee / slice= machine; 
  lsmeans machine*employee / slice= employee;
run;
/*
주어진 요인에 따른 평균 계산
MEANS와 유사하나 처리수준별 자료수가 같지 않은 것을 보정
SLICE에 의해서 특정 요인의 수준별 분석이 가능

machine*employee Effect Sliced by machine for defects
machine	DF	Sum of Squares	Mean Square	F Value	Pr > F
1	1	8.166667	8.166667	1.67	0.2205
2	1	28.166667	28.166667	5.76	0.0335
3	1	104.166667	104.166667	21.31	0.0006
기계1 일때는 두작업자에 의한 차이가 없고, 2,3일때는 차이가 있다

각 수준별 평균
machine	employee	defects LSMEAN
1	1	17.3333333
1	2	19.6666667
2	1	15.3333333
2	2	11.0000000
3	1	14.0000000
3	2	5.6666667

employee의 각 수준에서 machine에 따른 차이가 있는지 검정
machine*employee Effect Sliced by employee for defects
employee	DF	Sum of Squares	Mean Square	F Value	Pr > F
1	2	16.888889	8.444444	1.73	0.2192
2	2	299.555556	149.777778	30.64	<.0001
작업자1은 기계에 따른 차이가 없고 작업자2는 기계에 따른 차이가 있다.
*/
