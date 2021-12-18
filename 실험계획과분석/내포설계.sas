data a;
input school class score@@;
cards;
1 1 20   1 1 18   1 1 14
1 2 19   1 2 20   1 2 20
2 1 14   2 1 18   2 1 14
2 2 12   2 2 12   2 2 9
3 1 13   3 1 16   3 1 13
3 2 9    3 2 4    3 2 4
;
proc glm data = a;
class school class; 
model score = school class(school); /* y= a+b(a) 내포설계*/
random school class(school)/test; /* 임의효과 기대값 random문 */
run;

/* 수정된 분산분석표(임의효과)
Source	DF	Type III SS	Mean Square	F Value	Pr > F
Error: MS(class(school))
school	2	229.333333	114.666667	2.45	0.2342
Error	3	140.500000	46.833333	

Source	DF	Type III SS	Mean Square	F Value	Pr > F
class(school)	3	140.500000	46.833333	9.58	0.0017
Error: MS(Error)	12	58.666667	4.888889	
유의한 결과를 얻게됨
*/



data a; /* nested2.sas */
input school class score@@;
cards;
1 1 20   1 1 18   1 1 14
1 2 19   1 2 20   1 2 20
2 1 14   2 1 18   2 1 14
2 2 12   2 2 12   2 2 9
3 1 13   3 1 16   3 1 13
3 2 9    3 2 4    3 2 4
;
proc glm data=a;
 class school class;
 model score = school class(school);
 test H = school E= class(school); 
run;
/*
Tests of Hypotheses Using the Type III MS for class(school) as an Error Term
Source	DF	Type III SS	Mean Square	F Value	Pr > F
school	2	229.3333333	114.6666667	2.45	0.2342
*/

data a; /* nested3.sas */
input school class score@@;
cards;
1 1 20   1 1 18   1 1 14
1 2 19   1 2 20   1 2 20
2 1 14   2 1 18   2 1 14
2 2 12   2 2 12   2 2 9
3 1 13   3 1 16   3 1 13
3 2 9    3 2 4    3 2 4
;

proc glm data=a;
  class school class;
  model score = school class(school);
  random school class(school)/test;
  lsmeans class(school) / adjust=tukey lines; /* class in school에 따라서 차이 있는 지확인
  검정통계랑 tukey*/
run;

/*
Least Squares Means for effect class(school)
Pr > |t| for H0: LSMean(i)=LSMean(j)

Dependent Variable: score
i/j	1	2	3	4	5	6
1	 	0.7838	0.8691	0.0389	0.4748	0.0003
2	0.7838	 	0.2299	0.0045	0.0721	<.0001
3	0.8691	0.2299	 	0.2299	0.9728	0.0018
4	0.0389	0.0045	0.2299	 	0.5780	0.0975
5	0.4748	0.0721	0.9728	0.5780	 	0.0061
6	0.0003	<.0001	0.0018	0.0975	0.0061	
*/