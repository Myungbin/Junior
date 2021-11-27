data a; /* twoway3.sas */
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


data a; /* twoway4.sas */
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
  random employee machine*employee;
  test h=machine e=machine*employee;
  test h=employee e=machine*employee;
run;


data a; /* twoway5.sas */
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
  lsmeans machine*employee / adjust=tukey lines;
run;