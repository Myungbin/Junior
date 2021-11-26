data a; /* twoway1.sas */
input machine employee defects @@;
cards;
1 1 20   1 1 18   1 1 14
1 2 19   1 2 20   1 2 20
2 1 14   2 1 18   2 1 14
2 2 12   2 2 12   2 2 9
3 1 13   3 1 16   3 1 13
3 2 9    3 2 4    3 2 4
;

proc glm data=a;
  class machine employee;
  model defects = machine employee machine * employee;
run;


data a; /* twoway2.sas */
input machine employee defects @@;
cards;
1 1 20   1 1 18   1 1 14
1 2 19   1 2 20   1 2 20
2 1 14   2 1 18   2 1 14
2 2 12   2 2 12   2 2 9
3 1 13   3 1 16   3 1 13
3 2 9    3 2 4    3 2 4
;

proc glm data=a;
  class machine employee;
  model defects = machine employee machine * employee;
  lsmeans machine*employee / slice= machine;
  lsmeans machine*employee / slice= employee;
run;