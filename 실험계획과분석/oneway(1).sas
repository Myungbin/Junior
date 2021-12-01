data a;
input program sales@@;
cards;
1 74 1 67 1 83 1 77 1 71 
2 94 2 82 2 69 2 78 2 68 
3 62 3 75 3 59 3 79 3 68 
4 80 4 82 4 75 4 90 4 72
;

proc anova data = a;
class program; /*처리그룹을 표현하는데 사용된 변수 설정 */
model sales = program; /*반응변수 = 처리변수형태로 반응변수와 설명변수를 설정*/
means program /*주어진 설명변수의 값에 따른 처리수준별 평균, 표준편차 계산 및 다중비교*/
run; 


data a;
input program sales@@;
cards;
1 74 1 67 1 83 1 77 1 71 
2 94 2 82 2 69 2 78 2 68 
3 62 3 75 3 59 3 79 3 68 
4 80 4 82 4 75 4 90 4 72
;
proc glm data = a;
class program;
model sales = program / solution clparm;
means program;
run;
