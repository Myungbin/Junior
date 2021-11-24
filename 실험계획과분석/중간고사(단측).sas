/* t-test.sas 독립2표본 */

data mouse;
 input group$ mouse1;
 cards;
control 0.7
control -1.6
control -0.2
control -1.2
control -0.1
control 3.4
control 3.7
control 0.8
control 0.0
control 2.0
experimental 1.9
experimental 0.8
experimental 1.1
experimental 0.1
experimental -0.1
experimental 4.4
experimental 5.5
experimental 1.6
experimental 4.6
experimental 3.4
;

proc ttest data=mouse sides=u plots=all;
  class group;
  var mouse1;
run;