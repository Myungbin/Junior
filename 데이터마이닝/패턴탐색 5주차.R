# 예제) 어느 안과병원의 월별 환자수 데이터

a <- c(245,356,489,452,552,980,1204,4201,2141,820,422,401)
length(a)

# 평균
mean(a)
# 중앙값
median(a)
# 분산
var(a)
# 표준편차
sd(a)
sqrt(var(a))

# 범위 (range) = max -min
max(a) - min(a)

# summary
summary(a)


# 예제 2) 학력상태

dat <- read.table('grade_year_data.txt', encoding = "UTF-8", header = T)

# 행과 열
name <- dat[, 1]

Y1970 <- dat[, 2]

Y2010 <- dat[, 3]

# pie chart
pie(Y1970, labels = name, clockwise = T, col = rainbow(5), main = "1970년 학력상태")

label_a <- paste(name, Y1970, '%')

pie(Y1970, labels = label_a, clockwise = T, col = rainbow(5), main = "1970년 학력상태")

mtext(outer = F, "a", side = 3, line = 0)

par(mfrow = c(1,2))

label_b <- paste(name, Y2010, "%")
pie(Y2010, labels = label_a, clockwise = T, col = rainbow(5), main = "2010년 학력상태")

par(mfrow = c(1,1))

pie(Y2010, labels = paste(name, "\n",'(', Y2010,'%',')'),col = rainbow(5), main = "2010년 학력상태")
legend("topleft", name, fill = rainbow(Y2010))


## ggplot pie chart
library(ggplot2)
ggplot(dat, aes(x= "", y= Y1970, fill = Grade))+
  geom_bar(stat = "identity")+coord_polar("y")+
  geom_text(aes(label = paste(Y1970, "%")), 
            position = position_stack(vjust = 0.5))

## 그룹별
library(reshape2)

data <- melt(dat)
ggplot(data, aes(x = "", y = value, fill = Grade))+
  geom_bar(stat = "identity")+coord_polar("y")+
  coord_polar("y") + facet_grid(.~variable)+
  geom_text(aes(label = paste(value, "%")), position = position_stack(vjust = 0.5))


# 예제 3) country data
dat <- read.table('country_data.txt', encoding = "UTF-8", header = T)
dat

str(dat)
boxplot(dat$birth, dat$death, names(c("birth", 'death')))

# 결측치 확인
boxplot(dat$birth, dat$death, names(c("birth", 'death')))$out

summary(dat)


# iqdata 

dat <- read.table('iqdata.txt')

names(dat) <- c("state", "IQ", "BP")

plot(dat$IQ, dat$BP, xlab = "IQ score", ylab = "BP score")
abline(lsfit(dat$IQ, dat$BP))
cor(dat$IQ, dat$BP)

# 이상치 제거후 실행

data <- dat[-12, ]

plot(data$IQ, data$BP,xlab = "IQ score", ylab = "BP score")
abline(lsfit(data$IQ, data$BP))
cor(data$IQ, data$BP)


# mcycle 데이터

library(MASS)

data("mcycle")
head(mcycle)
str(mcycle)

# attach(mcycle)
# detach(mcycle)

# 산점도 
plot(mcycle$times, mcycle$accel, main = "linear")
abline(lsfit(mcycle$times, mcycle$accel))
cor(mcycle$times, mcycle$accel)

plot(mcycle$times, mcycle$accel, main = "LOWESS")
lines(lowess(mcycle$times, mcycle$accel))
lines(lowess(mcycle$times, mcycle$accel, f= 0.2), lty = 3)
legend(30, -80, c("default", "window = 0.2"), lty = c(1,3))
