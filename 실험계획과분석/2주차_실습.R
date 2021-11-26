# 데이터 불러오기 
dat <- read.csv("C:/Users/cwh/Desktop/REM_고객예측_의사결정_데이터.csv")

# 데이터 살펴보기 
head(dat)
str(dat)
is.na(dat)
sum(is.na(dat))



# 데이터 전처리 
# install.packages("dplyr")
library(dplyr)


colnames(dat)
## 필요한 column 뽑아오기 
df <- dat %>%  select("구입시간","구입갯수","가격","성별","지역1")
View(df)

df_2 <- data.frame(구입시간 = dat$구입시간,구입갯수 = dat$구입갯수,
                       가격 = dat$가격,성별 = dat$성별,지역1 = dat$지역1)
View(df_2)





## 지출비용 칼럼 만들기
data <- data.frame(df,지출비용 = df$가격*df$구입갯수)
view(data)




# 성별 지출비용 
## 성별 비율 
mat <- table(data$성별)
b_chart <- barplot(mat)
text(x = b_chart,y= median(mat)+200,labels = mat)



# 성별 지출비용
male_cost <- data[data$성별 == "남성","지출비용"]
female_cost <- data[data$성별 == "여성","지출비용"]
plot(male_cost)
plot(female_cost)


# 극단값이 많이 있어 그 값들이 평균에 영향을 줄 때에는 mean보다 median을 쓴다. 
mean(male_cost);mean(female_cost)
# 분산 : 각 값들이 평균에서 멀리 떨어져 있다. 
var(male_cost);var(female_cost)
quantile(male_cost)
quantile(male_cost, probs=c(0.05, 0.1, 0.9, 0.95))


aggregate(지출비용~성별,data,median)
aggregate(지출비용~성별,data,var)

summary(male_cost)
summary(female_cost)


# install.packages("doBy")
library(doBy)



summaryBy(지출비용~성별, data, FUN=c(mean,median,var,sd))
# IQR : 제3사분위수 - 제1사분위수 = 데이터의 중간 50%





## 히스토그램 
## 히스토그램은 표로 되어 있는 도수 분포를 정보 그림으로 나타낸 것이다. 즉, 도수분포표를 그래프로 나타낸 것  
## 히스토그램은 데이터의 분포를 보기 위해 그려본다. 
hist(male_cost)
hist(female_cost)

hist_male <- hist(male_cost, plot = FALSE)
hist_female <- hist(female_cost, plot = FALSE)
plot(hist_male, col = adjustcolor("blue",alpha = 0.5),main= "성별 지출비용",xlab = "지출비용")
plot(hist_female, col = adjustcolor("red",alpha = 0.5),add = TRUE)




## boxplot 
# 이상점 : 자료와는 극단적으로 다른값들 
# 데이터의 분포를 보여주는 그림으로 가운데 상자는 제 1사분위수, 중앙값, 제 3 사분위수를 보여준다. 
# 그래프 밖으로 빠져 나간것을 이상치라고 한다. 즉 이상치 또한 확인이 가능하다. 
boxplot(male_cost)
boxplot(female_cost)





## 이상치 제거
boxplot(male_cost)$stats
# [1] 아래 극단치 경계
# [2] 1사분위수 
# [3] 중앙값
# [4] 3사분위수 
# [5] 위 극단치 경계

male <- ifelse(male_cost<10 | male_cost>145000,NA, male_cost)
boxplot(male)
boxplot(female_cost)$stats
female <- ifelse(female_cost<200 | female_cost>75000,NA, female_cost)
boxplot(female)
boxplot(male, female, names = c("남성","여성"))

boxplot(지출비용~성별,data,main = "성별 지출비용",xlab="지출비용")



## 시간대병 지출비용
data$group_time <- ifelse(data$구입시간 <=600,"새벽",
                          ifelse(data$구입시간 <=1200,"아침",
                                 ifelse(data$구입시간<=1800,"오후","저녁")))
View(data)

summary(data[data$group_time == '새벽',])
summary(data[data$group_time == '아침',])
summary(data[data$group_time == '오후',])
summary(data[data$group_time == '저녁',])



# 시간대 비율 
mat <- table(data$group_time)
b_chart <- barplot(mat)
text(x = b_chart, median(mat)+150,labels = mat)




# 시간대별 나누기 
dawn_cost <- data[data$group_time == "새벽","지출비용"]
morning_cost <- data[data$group_time == "아침","지출비용"]
afternoon_cost <- data[data$group_time == "오후","지출비용"]
evening_cost <- data[data$group_time == "저녁","지출비용"]



# 시간대별 평균, 분산 등 
aggregate(지출비용 ~ group_time ,data, mean)

summaryBy(지출비용~group_time, data, FUN = c(mean,median,var,IQR))



# 히스토그램 
par(mfrow = c(2,2))
hist(data[data$group_time == "새벽","지출비용"], main = "새벽",xlab = "지출비용")
hist(data[data$group_time == "아침","지출비용"], main = "아침",xlab = "지출비용")
hist(afternoon_cost,main = "오후",xlab = '지출비용')
hist(evening_cost,main = "저녁",xlab = '지출비용')



# boxplot 
par(mfrow = c(1,1))
boxplot(지출비용 ~ group_time, data, "시간대별 지출비용",xlab = "",ylab= "지출비용")




# 0~20000원 사이에 데이터가 몰려있으므로 몰려있는 한번 그려보자 
new_dat = data[data$지출비용<20000,]
boxplot(지출비용 ~ group_time, new_dat, "시간대별 지출비용",xlab = "",ylab= "지출비용")





# 지역별 비율은 각자 한 번 진행 
mat <- table(data$지역1)
barplot(mat)





# 지역별 비율 
mat <- table(data$지역1)
b_chart <- barplot(mat)
table(data$지역1)

# 지역별 나누기  
a <- data[data$지역1=="강원" | data$지역1 == "강원도","지출비용"]
b <- data[data$지역1 == "경기"| data$지역1=="경기도","지출비용"]
c <- data[data$지역1 == "서울시" | data$지역1=="서울특별시","지출비용"]
d <- data[data$지역1 == "전라남도"|data$지역1=="전남","지출비용"]
e <- data[data$지역1 == "경남"|data$지역1=="경상남도","지출비용"]
f <- data[data$지역1 == "충남"|data$지역1=="충청남도","지출비용"]

# 지역별 
par(mfrow = c(2,3))
hist(a,main="강원도",xlab="지출비용")
hist(b,main="경기도",xlab="지출비용")
hist(c,main = "서울시",xlab = "지출비용")
hist(d,main = "전라남도",xlab = "지출비용")
hist(e,main = "경상남도",xlab = "지출비용")
hist(e,main = "충청남도",xlab = "지출비용")

# boxplot 
par(mfrow = c(2,3))
boxplot(a)
points(mean(a),col = "red",pch = 15,position = "right")

box = function(value){
  boxplot(value)
  points(mean(value),col = "red",pch = 15,position = "right")
  
}
box(b)
box(c)
box(d)
box(e)
box(f)


