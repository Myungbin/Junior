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
 */