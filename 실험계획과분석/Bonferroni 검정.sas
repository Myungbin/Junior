/* Bonferroni 검정*/
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
 means oil/ bon cldiff lines;   
run;

/* means문에서 bon을 사용하여 결과를 얻을 수 있음
Alpha	0.05
Error Degrees of Freedom	20
Error Mean Square	100.9
Critical Value of t	2.92712
Minimum Significant Difference	16.976

Comparisons significant at the 0.05 level are indicated by ***.
oil
Comparison	Difference
Between
Means	Simultaneous 95% Confidence Limits	 
2 - 3	9.000	-7.976	25.976	 
2 - 1	13.000	-3.976	29.976	 
2 - 4	23.000	6.024	39.976	***
3 - 2	-9.000	-25.976	7.976	 
3 - 1	4.000	-12.976	20.976	 
3 - 4	14.000	-2.976	30.976	 
1 - 2	-13.000	-29.976	3.976	 
1 - 3	-4.000	-20.976	12.976	 
1 - 4	10.000	-6.976	26.976	 
4 - 2	-23.000	-39.976	-6.024	***
4 - 3	-14.000	-30.976	2.976	 
4 - 1	-10.000	-26.976	6.976	 

2번째와 4번째만 차이가 난다고 할 수 있음.
*/