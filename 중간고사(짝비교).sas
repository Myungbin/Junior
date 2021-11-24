/* t-test.sas 독립2표본 */

data corn;
 input group1 group2 group3;
 cards;
14 19 21
16 20 17
21 18 19
13 19 20
14 23 23
;

proc ttest data=corn plots=all;
  paired group1*group2 group1*group3 group2*group3;
run;