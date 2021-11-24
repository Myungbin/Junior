/* outputtest3.sas. */
Data A;
DO X = 1 TO 3;
INPUT Y@@;
OUTPUT;
END;
CARDS;
2 3 3 3 5 4
4 6 5 6 7 6
;
PROC PROC PRINT; CAR X Y; RUN;
