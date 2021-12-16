data a;
input machine employee defects @@;
cards;
1 1 20   1 1 18   1 1 14
1 2 19   1 2 20   1 2 20
2 1 14   2 1 18   2 1 14
2 2 12   2 2 12   2 2 9
3 1 13   3 1 16   3 1 13
3 2 9    3 2 4    3 2 4
;
proc glm data = a;
class machine employee;
model defects = machine employee machine*employee;
random employee machine*employee /test;
run;

/*

Source	Type III Expected Mean Square
machine	Var(Error) + 3 Var(machine*employee) + Q(machine)
employee	Var(Error) + 3 Var(machine*employee) + 9 Var(employee)
machine*employee	Var(Error) + 3 Var(machine*employee)


Source	DF	Type III SS	Mean Square	F Value	Pr > F
Error: MS(machine*employee)
machine	2	229.333333	114.666667	2.63	0.2753
employee	1	53.388889	53.388889	1.23	0.3836
Error	2	87.111111	43.555556	
 	 
Source	DF	Type III SS	Mean Square	F Value	Pr > F
machine*employee	2	87.111111	43.555556	8.91	0.0042
Error: MS(Error)	12	58.666667	4.888889	 	 

상호작용일때 귀무가설을 기각

*/