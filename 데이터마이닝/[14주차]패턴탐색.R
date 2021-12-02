setwd('C:/Users/kki96/OneDrive/Desktop/명빈 과제/21년 2학기/데이터마이닝')

KCD <- read.csv('KCD.csv', stringsAsFactors = F)
M20 <- read.csv('M20.csv', stringsAsFactors = F)

dat <- M20[, c('RN_INDI', "MDCARE_STRT_DT", 'SICK_SYM1')]

table(dat$SICK_SYM1)

code_col <- KCD[KCD$분류.기준 == '세',c(3,6)]

nc <- dat$SICK_SYM1[1]
nchar(nc)

dat$SICK_SYM1 <- ifelse(nchar(dat$SICK_SYM1)>3,
                        paste0(substr(dat$SICK_SYM1,1,3),
                               '.',substr(dat$SICK_SYM1,4,6)),
                        dat$SICK_SYM1)

dat$SICK_SYM1 <- substr(dat$SICK_SYM1,1,5)

a <- data.frame(질병분류.코드 = paste0(LETTERS, "_"),
                    한글명칭 = paste0(LETTERS, "민감상병"))

code_col_new <- rbind(code_col, a)

dat2 <- merge(dat, code_col_new,
             by.x = "SICK_SYM1", by.y = '질병분류.코드')


sum(is.na(dat2))

dat3 <- dat2[, -1]
names(dat3) <- c("sequenceID", 'eventID', 'item')

library(arules)
library(arulesViz)

# 연관규칙
dat3_spl <- split(dat3$item, dat3$sequenceID)
class(dat3_spl)

dat3_trans <- as(dat3_spl, "transactions")
summary(dat3_trans)

summary(itemFrequency((dat3_trans)))

sort(itemFrequency(dat3_trans, type = "absolute"),
                   decreasing = T)[1:3]

rules1 <- apriori(dat3_trans, parameter =  list(supp = 0.2, conf = 0.5, minlen = 2))
summary(rules1)

plot(sort(rules1, by ="lift")[1:5], method = "graph", measure = 'confidence')

library(arulesSequences)

dat3$size <- 1

dat4 <- dat3[, c(1,2,4,3)]

dat5 <- dat4[order(dat3$sequenceID, dat3$eventID),]

dup <- duplicated(dat5[,c(1,2)])
which(dup)
length(which(dup))

dat6 <- dat5[-which(dup),]

# write.table(dat6, "seq.txt", row.names = F, sep="\t", col.names = F)

dat_res <- read_baskets(con = "seq.txt", sep = '\t', info = c('sequenceID','eventID'))

head(as(dat_res, "data.frame"), 20)

seque <- cspade(dat_res, parameter = list(supp = 0.4))

inspect(seque)

seque_res <- sort(seque, by = "support")
inspect(seque_res)

seq_df<-as(seque_res, "data.frame")
seq_size <- size(seque_res)

seq_c <- cbind(seq_df, seq_size)

seque_rules <- subset(seq_c, seq_size >= 2)

# 고생하셨습니다 ㅎ_ㅎ 








