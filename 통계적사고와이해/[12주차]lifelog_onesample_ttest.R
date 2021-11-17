##### -------------------------- #####
##### [week12] Life Log Data - 2 #####
##### -------------------------- #####
#### 단일 표본 평균 차이 검정을 위한 신뢰 구간(Confidence Interval)의 계산: 체지방률 데이터 이용
## author: hwang9u

# 데이터 설명

# [샘플데이터]
# - 00군 65세 이상 2019~2020년 2년치 데이터
# - 일자기준 : 걸음수 데이터가 있는날
# 
# [대상자 일자별 데이터 기초자료]
# - 걸음수 : 일일 달성 걸음수
# - 식이전송 : 일일 전송건수
# - 혈압 : 일일 측정 평균값
# - 혈당 : 일일 측정 평균값
# - 금주여부 : 일일 기록
# - 인바디 : 최근 측정값


### csv 데이터 불러오기(file path에 유의!!)
library(readxl)
library(dplyr)
## Data Load
lifelog <- as.data.frame(read_excel('라이프로그_from2019to2020_PHR.xlsx'))

### Structure
str(lifelog) 

numeric_var_names <- c("키", "몸무게", "체지방률", "기초대사량")
logical_var_names <- c("금주여부", "흡연여부")

for( var in numeric_var_names){
  lifelog[,var] = as.numeric(lifelog[,var])
}
for( var in logical_var_names){
  lifelog[,var] = as.logical(lifelog[,var])
}
lifelog[,'date'] = as.Date(lifelog$일자, format = "%Y%m%d")


### 전처리가 완료된 데이터를 저장해보자!
save(lifelog,
     file = 'lifelog_clnd_1st.RData') ## R object가 저장될 위치
 
## 데이터 불러오기
load('lifelog_clnd_1st.RData')
str(lifelog)

##### --------------------------------- #####
##### 체지방률 데이터의 전체 살펴보기   #####
##### --------------------------------- #####

## 체지방률 데이터만 벡터로 뽑아오기
bfp <- lifelog$체지방률

## 체지방률의 결측치 수는?
sum(is.na(bfp))

## 체지방률 데이터 탐색

### (0) 사람마다 데이터의 수가 일정하게 존재하나?
(bfp_len_by_user_id <- tapply(lifelog$체지방률, lifelog$user_id, length))
par(mfrow = c(1,1))
hist(bfp_len_by_user_id) ## --> 다소 왜도가 있으며 
mean(bfp_len_by_user_id) ## --> 평균적으로는 3.5건 정도가 있는 것 같음
summary(bfp_len_by_user_id)

### (1) 기술통계량(descriptive statistics)
summary(bfp)

### (2) histogram
hist(bfp)

### (3) boxplot
boxp <- boxplot(bfp, main = '체지방률')



#### --- outlier를 확인해보자
boxp$out # ???????

### (4) --- 정말 제대로 계산된 게 맞을까? outlier의 행 뽑아오기
bfp_outlier_idx <- which(lifelog$체지방률 %in% boxp$out) ## 행 인덱스 추출
lifelog[bfp_outlier_idx, c('키', '몸무게', '체지방률')]


### (5) outlier를 제외하고 다시 한 번 분포를 확인해보자
bfp_wo_out <- bfp[-bfp_outlier_idx]
hist(bfp_wo_out)
boxplot(bfp_wo_out)


#### --------------------------------------------------------------------------- ####
#### 체지방률의 자조적 정의: 반복 측정이 있는 경우 가장 마지막 값(최근값)을 이용 #### 
#### --------------------------------------------------------------------------- ####
get_last_bfp = function(user_id){
  bfp_by_user= lifelog[lifelog$user_id == user_id,'체지방률']
  return(tail(bfp_by_user, n = 1))
}
unq_user_id <- unique(lifelog$user_id)
bfp_last <- sapply(unq_user_id,get_last_bfp)

head(lifelog[,c('user_id','체지방률' )], n=20)


hist(bfp_last)
boxp <- boxplot(bfp_last)

###########################################################################################################

#### ------------------------------------------ #####
#### t-distribution vs z-distribution plotting  #####
#### ------------------------------------------ #####
N = 3
x = seq(-4,4, by = 6/1000)
par(mfrow = c(1,1))
plot(dnorm(x, mean = 0, sd = 1), type = "l", col = 1, lwd = 3) ## normal dist pdf
lines(dt(x, df = N-1), type = "l",
       lty = 3,
       col = 2,
       lwd = 3, ylim = c(0,0.5)) ## t dist pdf
legend('topright', lty = c(1,3), lwd = c(3,3), col = c(1,2), legend = c('t-dist', 'normal_dist') )


## loop로 한 번에 확인해보기
alpha = 0.05
plot(x,dnorm(x, mean = 0, sd = 1),
     type = "l", col = 1, lwd = 3,
     main = "comparing distribution and critical value: t(N-1) vs N(0,1)") ## normal dist pdf
abline(v= qnorm(0.975, mean = 0, sd = 1), lwd = 2)

## 자유도 벡터 만들기
df_ <- c(3,5,10,30,50,length(bfp_last))
for(i in 1:length(df_)){
  lines( x,dt(x, df = df_[i]), type = "l",
         lty = i+1,
         col = i+1,
         lwd = 2, ylim = c(0,0.5)) ## t dist pdf
  abline(v = qt(1-0.05/2,df_[i]), col = i+1)
}

legend('topright', lty = 1:length(df_) +1,
       lwd = rep(2, length(df_)),
       col = 1:length(df_) +1,
       legend = paste0('N=', df_) )




#### -------------------- ####
#### Z-표준화를 하는 이유 #### p 4
#### -------------------- ####
rsamples <- rnorm(1000, mean = 3, sd = 2); mean(rsamples); sd(rsamples)
par(mfrow = c(1,2))
plot(density(rsamples))
normalized_rsamples <- (rsamples - mean(rsamples))/sd(rsamples); mean(normalized_rsamples); sd(normalized_rsamples)
plot(density(normalized_rsamples))
## Q. 표준화 전후 어떤 차이가 있나요?
## Q. 이것이 Z-statistic



##########################################################################################################

#####------------------------------####
#####         가설검정             #### p9 ~p10
#####------------------------------####


### (0) 정규성(Normality) 가정 확인
shapiro.test(bfp_last) ## 결과 해석??

### (1) 검정 통계량(Test Statistic)


cal_z_stat <- function(x, mu, sigma = NULL){
  N <-  length(x)
  sample_mean <-  mean(x)
  se <- sigma/sqrt(N) ## standard error
  z_stat <- (sample_mean - mu)/se
  return(z_stat)
}

## 연습) cal_t_stat을 만들어보자!
cal_t_stat(bfp_last, 30)




### (2) 신뢰구간 (Confidence Interval)  ## p7~8
N = length(bfp_last)
s = sd(bfp_last)
SE = s/sqrt(N)
alpha = 0.05

### (3) Normal distribution 가정
# z_alpha/2 구하기
# z-score table: https://www.sjsu.edu/faculty/gerstman/EpiInfo/z-table.htm
# t-score table: https://www.sjsu.edu/faculty/gerstman/StatPrimer/t-table.pdf
z_a <- qnorm(p = 1-alpha/2, mean = 0, sd = 1)

# CI 공식에 대입
mean(bfp_last) - z_a * SE ## lower 
mean(bfp_last) + z_a * SE ## upper

# 위의 과정 함수로 만들기
compute_CI_Z<- function(x,alpha){
  N = length(x)
  s <- sd(x)
  se <- s/sqrt(N)
  z_a <- qnorm(p = 1-alpha/2, mean = 0, sd = 1)
  return( c(mean(x) - z_a * se , mean(x) + z_a * se))
}
compute_CI_Z(bfp_last,0.05)

# (연습) T-분포 가정 CI 구하기
# qt() 함수 이용 (parameter가 df임!!)

compute_CI_T<- function(x,alpha){
  N = length(x)
  s <- sd(x)
  se <- s/sqrt(N)
  t_a <- qt(p = 1-alpha/2, df = N-1)
  return( c(mean(x) - t_a * se , mean(x) + t_a * se))
}

compute_CI_T(bfp_last,alpha = 0.05) ## alpha를 바꾸어가며 실험해보기


# R 내장 코드의 결과와 비교해보기
(ttest_res <- t.test(bfp_last, mu = 30))

ttest_res$conf.int == compute_CI_T(bfp_last,alpha = 0.05,df = N-1)


# alpha를 변화시켜가며 신뢰구간의 길이를 구해보자. 어떻게 변하는가?
abs(diff(compute_CI_T(bfp_last, alpha = 1e-2*5, df = N-1))) 

### Q. 신뢰구간의 영향을 주는 요인은 어떤 것이 있을까?
### Q. 만약 성별에 따라 체지방률의 차이가 있다면 어떤 분석 기법을 적용하는 것이 타당한가?


