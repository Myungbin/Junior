# 2021.10.07

# 경로설정
setwd('C:/Users/kki96/OneDrive/Desktop/명빈 과제/21년 2학기/데이터마이닝')

# 식료품데이터
library(arules)

data("Groceries")
dat <- Groceries

summary(dat)
inspect(dat[1:5])

ex <- as(dat, "data.frame")

# itemFrequency
itemFrequency(dat, type = "absolute") # 빈도수
itemFrequencyPlot(dat, topN = 10)  # 상대도수 그래프

# 연관규칙
# 지지도 : 0.1 신뢰도 : 0.8 가 디폴트값
rules <- apriori(dat, parameter = list(supp = 0.005, conf = 0.25, maxlen = 2))
rules
inspect(rules)

# 정렬 sort
rules_sort <- sort(rules, by = "lift")
inspect(rules[1:10]) # 상위 10개
inspect(rules)
# 오름차순
rules_sort <- sort(rules, by = "lift", decreasing = F)
inspect(rules[1:10])

# 양파를 사는 사람들은 어떤 제품을 같이 구매할까
rules <- apriori(dat, parameter = list(supp = 0.005, conf = 0.25, maxlen = 2),
                 appearance = list(lhs = "onions"))
inspect(rules)

# 어떤 제품을 사는 사람들이 other vegetables를 같이 살까

rules <- apriori(dat, parameter = list(supp = 0.005, conf = 0.25),
                 appearance = list(lhs = "other vegetables"))
inspect(rules)

# 양파가 포함된 규칙을 찾고싶다
rules_on <- subset(rules, items %in% "onions")
inspect(rules_on)

# 시각화
library(arulesViz)

a <- rules_sort[1:10]
plot(rules, method= "grouped")
plot(a, method= "graph")

rules <- apriori(dat, parameter = list(supp = 0.005, conf = 0.25, maxlen = 3))

rules_a <- sort(rules, by = "lift", decreasing = T)
b <- rules_a[1:10]
inspect(b)
plot(b, method = "graph")

# interactive 시각화
plot(b, method = "graph", interactive = T)


