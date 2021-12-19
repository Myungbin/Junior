DATA river; /*모두 고정효과*/
input dam$ area score@@;
datalines;
팔당 1 11 팔당 1 12
팔당 2 13 팔당 2 11
팔당 3 10 팔당 3 11
의암 1 17 의암 1 20
의암 2 20 의암 2 21 
의암 3 15 의암 3 14
;
proc glm data = river;
class dam area;
model score = dam area(dam);
run;
/*
Source	DF	Type III SS	Mean Square	F Value	Pr > F
dam	1	126.7500000	126.7500000	89.47	<.0001
area(dam)	4	39.6666667	9.9166667	7.00	0.0191
댐간의 차이도 유의하고 지역간 오염도 차의도 유의하다고 해석가능
*/
DATA river;/*모두 임의효과*/
input dam$ area score@@;
datalines;
팔당 1 11 팔당 1 12
팔당 2 13 팔당 2 11
팔당 3 10 팔당 3 11
의암 1 17 의암 1 20
의암 2 20 의암 2 21 
의암 3 15 의암 3 14
;
proc glm data = river;
class dam area;
model score = dam area(dam);
random dam area(dam) / test;
run;
/*
Source	DF	Type III SS	Mean Square	F Value	Pr > F
dam	1	126.750000	126.750000	12.78	0.0233
Error: MS(area(dam))	4	39.666667	9.916667	 	 

Source	DF	Type III SS	Mean Square	F Value	Pr > F
area(dam)	4	39.666667	9.916667	7.00	0.0191
Error: MS(Error)	6	8.500000	1.416667	 	
*/

DATA river;/*모두 임의효과*/
input dam$ area score@@;
datalines;
팔당 1 11 팔당 1 12
팔당 2 13 팔당 2 11
팔당 3 10 팔당 3 11
의암 1 17 의암 1 20
의암 2 20 의암 2 21 
의암 3 15 의암 3 14
;
proc glm data = river;
class dam area;
model score = dam area(dam);
random dam area(dam) / test;
lsmeans dam area(dam) / adjust = tukey lines;
run;

/*
Least Squares Means for effect area(dam)
Pr > |t| for H0: LSMean(i)=LSMean(j)

Dependent Variable: score
i/j	1	2	3	4	5	6
1	 	0.5852	0.0979	0.0081	0.0117	0.0041
2	0.5852	 	0.0172	0.0022	0.0029	0.0012
3	0.0979	0.0172	 	0.2504	0.3924	0.0979
4	0.0081	0.0022	0.2504	 	0.9974	0.9484
5	0.0117	0.0029	0.3924	0.9974	 	0.7960
6	0.0041	0.0012	0.0979	0.9484	0.7960	
*/