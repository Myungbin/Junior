file_dir <- 'C:/Users/kki96/OneDrive/Desktop/명빈 과제/21년 2학기/통계적사고와이해/dat/'
file <- list.files(paste0(file_dir, "승하차인원정보"))

file

subway <- data.frame()

for (i in 1:length(file)) {
  print(file[i])
  dat <- read.csv(paste(paste0(file_dir, "승하차인원정보"), "/", file[i], sep = ""),
                  sep=",", header = T, stringsAsFactors = F)
  subway <- rbind(subway, dat)
  
  rm(dat) 
}

subway <- subway[substr(subway$사용일자, 1, 4) == '2017', ]
subway2 <- subway[, c("역명", "승차총승객수", "하차총승객수")]
sort(unique(subway2$역명))

stat_add <- read.csv(paste0(file_dir, "서울교통공사_역주소.csv"),
                     sep = ",", header = T, fileEncoding = "CP949")

str(stat_add)
stat_add$역주소 <- as.character(stat_add$역주소)

stat_add_seoul <- subset(stat_add, substr(stat_add$역주소, 1, 2) == "서울")
length(unique(stat_add_seoul$역명))


str_spl <- c()

for (i in 1:nrow(stat_add_seoul)) {
  str_spl[i] <- strsplit(stat_add_seoul$역주소, split = " ")[[i]][2]
  print(str_spl)
}

stat_add_seoul$행정구 <- str_spl
stat_add_seoul2 <- stat_add_seoul[, c("역명", "행정구")]

sub_seoul <- merge(subway2, stat_add_seoul2, by = "역명", )
colSums(is.na(sub_seoul))

sub_seoul2 <- aggregate(cbind(승차총승객수, 하차총승객수) ~ 행정구, data = sub_seoul, sum)


pop <- read.csv(paste0(file_dir, "인구밀도.csv"), sep= ",", header = F, fileEncoding = "CP949")
cri <- read.csv(paste0(file_dir, "5대범죄.csv"), sep= ",", header = F, fileEncoding = "CP949")

names(pop) <- c("기간", "지역", "인구", "면적", "면적밀도")
pop <- pop[-c(1:3), ]

pop2 <- pop[pop$기간 == 2017, ]
pop2 <- pop[-1, -1]
rownames(pop2) <- NULL

names(cri) <- c("기간", "자치구", "합계발생", "합계검거", "살인발생", "살인검거",
                "강도발생", "강도검거", "강간강제추행발생", "강간강제추행검거",
                "절도발생", "절도검거", "폭력발생", "폭력검거")


cri <- cri[-c(1:3), ]
cri2 <- cri[cri$기간 == 2017, ]
cri2 <- cri2[-1, c(2, 9)]
rownames(cri2) <- NULL


seoul_tot <- merge(x = sub_seoul2 , y = pop2 , by.x = "행정구", by.y = "지역")
seoul_tot <- merge(x = seoul_tot, y= cri2, by.x = "행정구", by.y = "자치구")
