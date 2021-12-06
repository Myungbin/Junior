data a;
input school class score@@;
cards;
1 1 20   1 1 18   1 1 14
1 2 19   1 2 20   1 2 20
2 1 14   2 1 18   2 1 14
2 2 12   2 2 12   2 2 9
3 1 13   3 1 16   3 1 13
3 2 9    3 2 4    3 2 4
;
proc glm data = a;
class school class; 
model score = school class(school); /* y= a+b(a) 내포설계*/
random school class(school)/test; /* 임의효과 기대값 random문 */
run;

data a; /* nested2.sas */
input school class score@@;
cards;
1 1 20   1 1 18   1 1 14
1 2 19   1 2 20   1 2 20
2 1 14   2 1 18   2 1 14
2 2 12   2 2 12   2 2 9
3 1 13   3 1 16   3 1 13
3 2 9    3 2 4    3 2 4
;

proc glm data=a;
  class school class;
  model score = school class(school);
  test H = school E= class(school) /* h/e 분자 / 분ㅁ모*/
run;


data a; /* nested3.sas */
input school class score@@;
cards;
1 1 20   1 1 18   1 1 14
1 2 19   1 2 20   1 2 20
2 1 14   2 1 18   2 1 14
2 2 12   2 2 12   2 2 9
3 1 13   3 1 16   3 1 13
3 2 9    3 2 4    3 2 4
;

proc glm data=a;
  class school class;
  model score = school class(school);
  random school class(school)/test;
  lsmeans class(school) / adjust=tukey lines; /* class in school에 따라서 차이 있는 지확인
  검정통계랑 tukey*/
run;