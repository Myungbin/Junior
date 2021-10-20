df <- read.csv('품목데이터.csv')
df

# 종사자수, 판매수익
plot(df$종사자수, df$판매수익, xlab = "종사자수", 
     ylab = "판매수익")

cor(df$종사자수, df$판매수익)

plot(df$재고비율, df$판매수익, xlab = "재고비율", 
     ylab = "판매수익")

cor(df$재고비율, df$판매수익)

plot(df$인건비, df$판매수익, xlab = "인건비", 
     ylab = "판매수익")

str(df)

df['수익성'] = df$판매수익*(1-df$재고비율)

df['1명당수익'] = df$판매수익/df$종사자수

barplot(df$`1명당수익`~df$상품종류, xlab = "상품종류", ylab = "1명당수익")

df['수익성2'] = df$`1명당수익`*(1-df$재고비율)

barplot(df$수익성2~df$상품종류, xlab = "상품종류", ylab = "수익성")


sort(df$`1명당수익`)

mean(df$판매수익)
summary(df)

sort(df, df$실제수익)

barplot(df$실제수익~df$상품종류, xlab = "상품종류", ylab = "실제수익")


#---------------------------------------------------

dat <- read.transactions('trans1.txt', sep = ",")

inspect(dat)

tr <- read.csv('trans.csv')

tr_m <- read.csv('trans_m.csv')

tr_f <- read.csv('trans_f.csv')


inspect(tr)
