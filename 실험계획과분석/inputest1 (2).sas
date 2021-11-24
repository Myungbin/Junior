/* inputest1.sas */
DATA A; 
MISSING A V; /* A,V는 결측치야 */
INPUT X Y @@; /* X와 Y를 읽을거야 @@ = 줄 바뀔때 까지 계속 읽을거야 */
CARDS; /* 카드는 데이터 ;까지 */
1 2   2 A   3 V   4 5   5 7 . 6
;
PROC FREQ; /* FREQ(도수분포표)라는 PROC를 불러줘 */
 TABLE X Y; /* 테이블 X와 Y의 도수분포표 */
RUN; 


/* @2 한줄에 여러케이스의 자료가 있는경우 */

/* INPUT var format; 자료가 빈칸이 없이 특정한 열에 줄을 맞춰 코딩되어 있으면 */




