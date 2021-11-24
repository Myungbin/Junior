/* ttest1.sas 독립2표본 */

data score;
 input gender$ score;
 cards;
 M 327
 M 291
 M 323
 M 284
 M 305
 F 308
 F 324
 F 353
 F 344
 F 341
;

proc ttest data=score plots=all;
  class gender;
  var score;
run;