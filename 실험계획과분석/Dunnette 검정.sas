/* Dunnette 검정*/
data fatdata;
input oil transfat@@;
cards;
 1 164 1 172 1 168 1 177 1 156 1 195
 2 178 2 191 2 197 2 182 2 185 2 177
 3 175 3 193 3 178 3 171 3 163 3 176
 4 155 4 166 4 149 4 164 4 170 4 168
;
 
proc glm data = fatdata;
 class oil;
 model transfat = oil;
 means oil/ dunnett('2');  /*대조군이 2*/
/* means oil/ dunnett; */
run;
/*lsd와 bon과 달리 lines적용 x 
기준범주 설정안할경우 1로 계산*/

/*
Alpha	0.05
Error Degrees of Freedom	20
Error Mean Square	100.9
Critical Value of Dunnett's t	2.54035
Minimum Significant Difference	14.733
*/


/*
Comparisons significant at the 0.05 level are indicated by ***.
oil
Comparison	Difference
Between
Means	Simultaneous 95% Confidence Limits	 
3 - 2	-9.000	-23.733	5.733	 
1 - 2	-13.000	-27.733	1.733	 
4 - 2	-23.000	-37.733	-8.267	***
신뢰구간안에 0이 들어가니까 차이가 없다고 할 수 있음
4 - 2 는 신뢰구간안에 0이 안들어가니까 차이가 난다고 할 수 있음
*/