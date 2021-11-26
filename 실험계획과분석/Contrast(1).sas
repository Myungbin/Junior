/*대비*/
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
 contrast '동물성과 식물성 비교' oil 1 1 -1 -1;
 contrast '1번과 3번 비교' oil 1 0 -1 0; 
run;

/*F-value가 0.48로 귀무가설을 기각 X*/

