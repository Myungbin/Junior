# 순차패턴분석 => 시간에 따라 사건이 발생 지지도만 활용
library(arulesSequences)

data("zaki")
dat <- zaki

summary(dat)
inspect(dat)

# cspade
## support 지지도
## maxsize 시퀀스 사이즈의 최대 항목수
## maxlen 시퀀스의 최대 길이
rules <- cspade(dat, parameter = list(supp = 0.3))
summary(rules)

inspect(rules)

# element size가 2개이상인 규칙
seq_df <- as(rules, "data.frame")

# size 개수
seq_size <- size(rules)

# combine
seq_rule_df <- cbind(seq_df, seq_size)

# 규칙이 2개 이상인 것들을 뽑아오기
seq_rules2 <- subset(seq_rule_df, seq_size >= 2)

######################################################## 
setwd('C:/Users/kki96/OneDrive/Desktop/명빈 과제/21년 2학기/데이터마이닝')
dat <- read.csv('REM_고객예측_의사결정_데이터_10주차.csv')

# 결측치 확인
sum(is.na(dat))

# 중복행 제거
duplicated(dat)
which(duplicated(dat)) # 위치
dat[duplicated(dat),] 

dat <- unique(dat)
nrow(dat)

# 데이터 살펴보기
head(dat)
str(dat)
summary(dat)

# 데이터 전처리
library(dplyr)

# 필요한 컬럼
names((dat))
data <- dat %>% select("고객코드", "구입날짜", "상품분류")

class(data$구입날짜)

# gsub함수
h <- gsub("-", "", data$구입날짜)
data$구입날짜 <- as.numeric(h)
names(data) <- c("sequenceID", "eventID", "item")

data_or <- data[c(order(data$sequenceID, data$eventID)),]
head(data_or)

# 반복문

#for (i in unique(data$sequenceID)) {
#  step_1<- data_or[data_or$sequenceID == i,]
#  print(step_1)
#}


f <- unique(data_or)

## 반복문

res <- data.frame()

for (i in unique(f$sequenceID)) {
  # step_1 에다가 고객들의 행을 넣어준다
  step_1 <- f[f$sequenceID == i,]
  for (j in unique(step_1$eventID)) {
    # step_1 에서 뽑아온 행들에서 eventID
    step_2 <- step_1[step_1$eventID == j,]
    # c에다가 event가 몇개 있는지 (item 개수)
    c <- nrow(step_2)
    if (nrow(step_2)>1) {
      step_3 <- paste0(step_2$item, collapse = ", ")
     } else {
        step_3 <- step_2$item
     }
    df <- data.frame(sequenceID = i, eventID = j, item = step_3, size = c)
    res <- rbind(res, df)
    }
  }
  
dat3 <- res[, c(1,2,4,3)]
# write.table(dat3, "res.txt", sep = "\t", row.names = F, col.names = F)

dat4 <- read_baskets('res.txt', sep = "\t", info = c("sequenceID","eventID", "size"))
inspect(dat4)

seque <- cspade(dat4, parameter = list(supp = 0.01))

inspect(seque)

seque_res <- sort(seque, by = "support")
inspect(seque_res)

seq_df<-as(seque_res, "data.frame")
seq_size <- size(seque_res)

seq_c <- cbind(seq_df, seq_size)

seque_rules <- subset(seq_c, seq_size >= 2)







