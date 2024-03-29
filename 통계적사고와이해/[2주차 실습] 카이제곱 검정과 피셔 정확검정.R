

#--- 1) 2015년도 학력별 흉악 범죄자 구성비 ------------------------------------# 
## 1. Kosis 데이터 불러오기 : 2015년 학력별 흉악 범죄자 
## 1-1. 절대 경로 지정
getwd()
setwd('C:/Users/kogeu/Desktop/[2021-2학기] 통계적 사고와 이해 실습/2주차 실습')

## 1-2. 
dir <- 'C:/Users/kki96/OneDrive/Desktop/명빈 과제/21년 2학기/통계적사고와이해'
dat <- read.csv(file = paste0(dir, '/Criminals Education Level_2015.csv'), 
                header = FALSE, stringsAsFactors = F)


## 2. 데이터 핸들링 
dat2 <- dat

colmns <- dat2[c(2:3), ]
colmns <- paste(colmns["2",], colmns["3",], sep = ' ')
colmns[1] <- '죄종별(1)'
colmns[2] <- '죄종별(2)'

criminal <- dat2[-c(1:3), ]
names(criminal) <- colmns
criminal

library(reshape2)
re_criminal <- melt(criminal, id.vars = c('죄종별(1)', '죄종별(2)'),
                    variable.name = "교육수준", value.name = "도수")

str(re_criminal)
re_criminal$도수 <- as.numeric(re_criminal$도수)

## 2-1. 핸들링한 데이터 저장
write.csv(re_criminal, 're_Criminals Education Level_2015.csv',
          row.names = F)


## 3. 자료의 요약
tapply(re_criminal$도수, re_criminal$교육수준, sum)
tapply(re_criminal$도수, re_criminal$`죄종별(2)`, sum)

with(re_criminal, tapply(도수, list(교육수준, `죄종별(2)`), sum))

## 3-1. 파생변수 생성 후, 교차테이블 확인
`살인` <- grep('살인', unique(re_criminal$`죄종별(2)`), value = T)
`성폭력` <- grep('강간|강제추행', unique(re_criminal$`죄종별(2)`), value = T)
re_criminal$`죄명` <- ifelse(re_criminal$`죄종별(2)` %in% `살인`, '살인',
                           ifelse(re_criminal$`죄종별(2)` %in% `성폭력`, '성폭력', re_criminal$`죄종별(2)`))


`초등학교 이하` <- grep('불취학|초등학교', unique(re_criminal$`교육수준`), value = T)
`중학교` <- grep('중학교', unique(re_criminal$`교육수준`), value = T)
`고등학교` <- grep('고등학교', unique(re_criminal$`교육수준`), value = T)
`대학교 이상` <- grep('대학', unique(re_criminal$`교육수준`), value = T)

re_criminal$`교육정도` <- ifelse(re_criminal$`교육수준` %in% `초등학교 이하`, '초등학교 이하',
                           ifelse(re_criminal$`교육수준` %in% `중학교`, '중학교', 
                                  ifelse(re_criminal$`교육수준` %in% `고등학교`, '고등학교',
                                         ifelse(re_criminal$`교육수준` %in% `대학교 이상`, '대학교 이상', re_criminal$`교육수준`))))


#with(re_criminal, tapply(도수, list(교육정도, 죄명), sum, na.rm = T))
str(re_criminal)
re_criminal$`죄명` <- factor(re_criminal$`죄명`, levels = c('살인', '강도', '방화', '성폭력'),
                            labels = c('살인', '강도', '방화', '성폭력'))
re_criminal$`교육정도` <- factor(re_criminal$`교육정도`, 
                             levels = c('초등학교 이하', '중학교', '고등학교', '대학교 이상'),
                             labels = c('초등학교 이하', '중학교', '고등학교', '대학교 이상'))

crim_edu_lv <- with(re_criminal, tapply(도수, list(교육정도, 죄명), sum, na.rm = T))
#crim_edu_lv <- addmargins(crim_edu_lv, 2)
addmargins(prop.table(addmargins(crim_edu_lv, 2), 1), 1)



#--- 2) 신약효과에 따른 통계적 연구의 사례 ------------------------------------#
## 1. 메트릭스 생성
RCT <- matrix(c(600, 200, 400, 800), ncol = 2)
RCT

dimnames(RCT) <- list(감기약투여여부 = c('감기약 투여', '감기약 투여하지 않음'),
                             감기완치 = c('완치됨', '완치되지 않음'))
RCT
addmargins(RCT)

addmargins(RCT, 2)
addmargins(prop.table(addmargins(RCT, 2), 1), 1)


## 2. 카이제곱 검정
chi_res <- chisq.test(RCT)
chi_res$expected

## 3. 피셔의 정확검정
fisher.test(RCT)

