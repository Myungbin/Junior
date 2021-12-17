/* SAS를 이용한 LSD 검정*/
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
 means oil / lsd cldiff lines;
 run;
 
 /* means문에서 lsd지정
 cldiff를 사용하면 모든 가능한 비교(수치계산
 lines를 사용하면 선을 그려줌
 alpha에 다른 값을 설정하면 5%가 아닌 유의수준에 대한결과 얻음
 
 
Alpha	0.05
Error Degrees of Freedom	20 -> df(MSE)
Error Mean Square	100.9   ---> MSE
Critical Value of t	2.08596 ---> t20,0.025
Least Significant Difference	12.097 --> LSD(i,j)

Comparisons significant at the 0.05 level are indicated by ***.
oil
Comparison	Difference
Between
Means	95% Confidence Limits	 
2 - 3	9.000	-3.097	21.097	 
2 - 1	13.000	0.903	25.097	***
2 - 4	23.000	10.903	35.097	***
3 - 2	-9.000	-21.097	3.097	 
3 - 1	4.000	-8.097	16.097	 
3 - 4	14.000	1.903	26.097	***
1 - 2	-13.000	-25.097	-0.903	***
1 - 3	-4.000	-16.097	8.097	 
1 - 4	10.000	-2.097	22.097	 
4 - 2	-23.000	-35.097	-10.903	***
4 - 3	-14.000	-26.097	-1.903	***
4 - 1	-10.000	-22.097	2.097	 
 */