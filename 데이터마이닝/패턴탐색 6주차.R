setwd('C:/Users/kki96/OneDrive/Desktop/명빈 과제/21년 2학기/데이터마이닝')

library(arules)
dat <- read.transactions('trans.txt', sep = ",")
dat

inspect(dat)

# 데이터프레임으로 변환하여 확인
data <- as(dat, 'data.frame')

# 거래의 비율
itemFrequency(dat)
#도수
itemFrequency(dat, type = "absolute")
# 거래의 비율
itemFrequencyPlot(dat)

# 연관규칙 실행
rules <- apriori(dat)
inspect(rules)

rules <- apriori(dat, parameter = list(support = 0.4, confidence = 0.4))
inspect(rules)

# 빵이라는 제품이 궁금하지 않다: 제외
rules <- apriori(dat, parameter = list(supp = 0.4, conf = 0.4),
                 appearance = list(none = "빵"))
inspect(rules)

# 어떤 것을 사는 사람이 콜라를 사는가
rules <- apriori(dat, parameter = list(support = 0.4, confidence = 0.4),
                 appearance = list(rhs = "콜라"))
inspect(rules)

# 버터를 사는 사람들은 무엇을 사는가
rules <- apriori(dat, parameter = list(support = 0.4, confidence = 0.4),
                 appearance = list(lhs = "버터"))
inspect(rules)

# plot 
library(arulesViz)

plot(rules)
plot(rules, method = "grouped")
plot(rules, method = "graph")

# 인터렉티브 시각하
plot(rules, method = "graph", interactive = T)

# 고객예측 의사결정 데이터

dat <- read.csv("REM_고객예측_의사결정_데이터.csv")
str(dat)

# 중복제거
dat <- unique(dat)
str(dat)

dat[dat$고객코드 == 3573, ]

library(dplyr)

names(dat)
r_dat <- dat %>% select("고객코드", "상품분류")
str(r_dat)

r_dat_list <- split(r_dat$상품분류, r_dat$고객코드)
head(r_dat_list)

