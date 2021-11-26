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
