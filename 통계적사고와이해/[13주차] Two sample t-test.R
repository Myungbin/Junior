

# ----------------------- [13주차] Two sample t-test ------------------------- #
# 1. 12주차 교안의 사례 R로 확인해보기
# 사례 2 : 질산칼륨의 과다 섭취는 성장을 저해한다고 할 수 있겠는가 ?
gain_treat <- c(15.2, 12.5, 11.7, 14.3, 15.1, 13.5, 16.2, 12.8)
gain_control <- c(10.8, 18.5, 35.8, 18.2, 16.9, 11.4, 28.4, 25.3)

ex1 <- data.frame('group' = rep(c('treatment', 'control'), each = 8),
                  'gain' = c(gain_treat, gain_control))
ex1$group <- factor(ex1$group, levels = c("treatment", "control"))


# H1 : 질산칼륨을 섭취한 그룹은 질산칼륨을 섭취하지 않은 그룹에 비해 체중증가량이 적을 것이다.
# t.test(gain ~ group, data = ex1,
#       mu = 0, conf.level = 0.95, alternative = "less", var.equal = TRUE)


# T 검정 실시 결과, 그대로 해석해도 괜찮을까 ?
# 1) 정규성 검정 
# H1 : 질산칼륨을 섭취한 그룹과 질산칼륨을 섭취하지 않은 그룹의 체중증가량은 정규성을 만족하지 않는다.
hist(gain_treat, freq = F)
lines(density(gain_treat), col = "red")

hist(gain_control, freq = F)
lines(density(gain_control), col = "red")

shapiro.test(gain_treat)
shapiro.test(gain_control)

# 두 그룹(처리, 통제)모두 정규성을 만족해야 t-test를 할 수 있다.

# Q-Q plot (정규분포 분위수 대조도)
qqnorm(gain_treat) ; qqline(gain_treat, col = "red")
c(1:length(gain_treat))/length(gain_treat)
qnorm(c(1:length(gain_treat))/length(gain_treat),0,1)

QQplot <- function(x) {
  N <- length(x)
  Quantile <- (c(1:N)-3/8) / (N+1/4)  # 표준정규분포의 분위수 보정 (c(1:N)/N)
  z <- qnorm(Quantile, 0, 1)
  x <- sort(x)
  
  return(plot(z, x, main="QQplot"))
}


QQline <- function(x) {
  x_bound <- quantile(x, probs = c(0.25, 0.75), names = FALSE)
  z_bound <- qnorm(c(0.25, 0.75))
  
  slope <- diff(x_bound)/diff(z_bound)
  int <- x_bound[1L] - slope * z_bound[1L]
  
  abline(int, slope, col = "red")
}

par(mfrow = c(1,2))
qqnorm(gain_control) ; qqline(gain_control, col = "red")
QQplot(gain_control) ; QQline(gain_control)


# 2) 등분산성 검정
# H1 : 질산칼륨을 섭취한 그룹과 질산칼륨을 섭취하지 않은 그룹의 모분산이 동일하지 않다. (이분산)
boxplot(gain ~ group, data = ex1)

library(lawstat)
var(gain_treat)/var(gain_control)
var.test(gain ~ group, data = ex1, conf.level = 0.95)

t.test(gain ~ group, data = ex1, 
       mu = 0, conf.level = 0.95, alternative = "less", var.equal = FALSE)


# 자유도 계산
cal_df <- function(x1, x2, alpha) {
  N1 <- length(x1)
  N2 <- length(x2)
  
  if ( alpha < var.test(x1, x2, conf.level = 1 - alpha)$p.value ) {
    return( N1+N2-2 )
  }
  
  else {
    return( ((var(x1)/N1 + var(x2)/N2)^2) / ( ((var(x1)/N1)^2 / (N1-1)) + ((var(x2)/N2)^2 / (N2-1)) )  )
  }
}

cal_df(gain_treat, gain_control, alpha = 0.05)


# 검정통계량 T0 계산
cal_t_stat <- function(x1, x2, diff_mu, alpha) {
  N1 <- length(x1) ; N2 <- length(x2)
  mean1 <- mean(x1) ; mean2 <- mean(x2)
  var1 <- var(x1) ; var2 <- var(x2)
  sp_2 <- ((N1-1)*var1 + (N2-1)*var2) / (N1+N2-2)
  
  if ( alpha < var.test(x1, x2, conf.level = 1 - alpha)$p.value ) {
    T0 <- ( ((mean1 - mean2) - diff_mu) / (sqrt(sp_2) * sqrt((1/N1) + (1/N2))) )
    return(T0)
  }
  
  else {
    T0 <- ( ((mean1 - mean2) - diff_mu) / sqrt((var1/N1) + (var2/N2)) )
    return(T0)
  }
}

cal_t_stat(gain_treat, gain_control, diff_mu = 0, alpha = 0.05)
       

# 사례 3 : 토론학습법은 토론이 부진한 아동들에게 효과가 있다고 할 수 있는가 ?
ex2 <- data.frame("pre" = c(56, 45, 59, 35, 61, 53, 26, 49, 42, 54),
                  "post" = c(67, 58, 61, 52, 63, 57, 33, 46, 51, 56))

ex2$diff <- ex2$pre - ex2$post
head(ex2)


# 정규성 검정 후 평균차이 검정 실시
par(mfrow = c(1,1))
qqnorm(ex2$diff) ; qqline(ex2$diff, col = "red")

shapiro.test(ex2$diff)

t.test(ex2$diff, mu = 0, conf.level = 0.95, alternative = "two.sided")   
t.test(ex2$pre, ex2$post, mu = 0, conf.level = 0.95, alternative = "two.sided", paired = TRUE)



# 2. 라이프로그 데이터 
# 만약 금주여부에 따라 체지방률의 차이가 있다면 어떤 분석 기법을 적용하는 것이 타당한가?
library(readxl)
setwd("C:/Users/kki96/OneDrive/Desktop/명빈 과제/21년 2학기/통계적사고와이해/")

load('./lifelog_clnd_1st.RData')
str(lifelog)

# 결측확인
colSums(is.na(lifelog))
unq_user_id <- unique(lifelog$user_id)

bfp_last <- c()

for (i in 1:length(unq_user_id)) {
  bfp_by_user <- tail(lifelog[lifelog$user_id == unq_user_id[i], c('체지방률', '금주여부')], n = 1)
  bfp_last <- rbind(bfp_last, bfp_by_user)
  
  rm(bfp_by_user)
}

row.names(bfp_last) <- NULL
bfp_last_ix <- sample(1:length(unq_user_id), length(unq_user_id) * 0.5, replace = FALSE)
bfp_last$금주여부2 <- ifelse(as.numeric(row.names(bfp_last)) %in% bfp_last_ix, FALSE, TRUE) 

bfp_last$금주여부2 <- factor(bfp_last$금주여부2, levels = c(TRUE, FALSE), labels = c("금주", "음주"))

# 분포 살펴보기
hist(bfp_last$체지방률, freq = F, main = '전체의 체지방률의 분포')

summary(bfp_last$체지방률)
x_ax = seq(10, 55, by = 5)

hist1 = hist(bfp_last[bfp_last$금주여부2 == "금주", "체지방률"], breaks=x_ax, plot = FALSE)
hist2 = hist(bfp_last[bfp_last$금주여부2 == "음주", "체지방률"], breaks=x_ax, plot = FALSE)

plot(hist1, col=adjustcolor("red", alpha=0.5), freq = F, ann = F )
plot(hist2, col=adjustcolor("blue", alpha=0.5), freq = F, add = TRUE)

title(main="금주여부에 따른 체지방률의 분포")
legend("topright",legend=c("금주","음주"), fill=c("red","blue"))

