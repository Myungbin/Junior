/*다중비교와 대비*/
data pig;
input diet kg@@;
datalines;
1 27.4 1 33.6
2 17.7 2 25.8
3 17.0 3 20.4
4 21.7 4 23.0
5 12.3 5 13.4
6 17.3 6 20.8
;
proc glm data = pig;
class diet;
model kg = diet;
means diet / dunnett('1');
run;
/*
Comparisons significant at the 0.05 level are indicated by ***.
diet
Comparison	Difference
Between
Means	Simultaneous 95% Confidence Limits	 
4 - 1	-8.150	-19.335	3.035	 
2 - 1	-8.750	-19.935	2.435	 
6 - 1	-11.450	-22.635	-0.265	***
3 - 1	-11.800	-22.985	-0.615	***
5 - 1	-17.650	-28.835	-6.465	****/

/*------------------------*/
data pig;
input diet kg@@;
datalines;
1 27.4 1 33.6
2 17.7 2 25.8
3 17.0 3 20.4
4 21.7 4 23.0
5 12.3 5 13.4
6 17.3 6 20.8
;
proc glm data = pig;
class diet;
model kg = diet;
contrast '123과 456그룹 비교' diet 1 1 1 -1 -1 -1;
contrast '1번과 3번비교' diet 1 0 -1 0 0 0;
contrast '1번과 5번비교' diet 1 0 0 0 -1 0;
contrast '1번과 6번비교' diet 1 0 0 0 0 -1;
run; 
/*
Contrast	DF	Contrast SS	Mean Square	F Value	Pr > F
123과 456그룹 비교	1	92.9633333	92.9633333	8.53	0.0266
1번과 3번비교	1	139.2400000	139.2400000	12.78	0.0117
1번과 5번비교	1	311.5225000	311.5225000	28.59	0.0017
1번과 6번비교	1	131.1025000	131.1025000	12.03	0.0133
*/