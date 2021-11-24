DATA corn;
INPUT 비료 수확량 @@;
CARDS;
1 14 1 16 1 21 1 13 1 14
2 19 2 20 2 18 2 19 2 23
3 21 3 17 3 19 3 20 3 23
;


PROC glm DATA=corn;
CLASS 비료;
MODEL 수확량 = 비료 / solution clparm;
ESTIMATE '1' INTERCEPT 1 비료 1 0 0 ;
ESTIMATE '2' INTERCEPT 1 비료 0 1 0 ;
ESTIMATE '1-2' 비료 1 -1 0;
RUN;