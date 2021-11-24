/* outputtest1.sas */
DATA A;
 DO X = 1 TO 10;
   IF X ^> 5 THEN Y = 0;
   ELSE Y = 1;
   OUTPUT;
 END;

PROC FREQ DATA =A;
 TABLES X Y;
RUN;