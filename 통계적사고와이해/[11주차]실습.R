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

names(pop) <- c("기간", "지역", "인구", "면적", "인구밀도")
pop <- pop[-c(1:3), ]

pop2 <- pop[pop$기간 == 2017, ]
pop2 <- pop2[-1, -1]
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

str(seoul_tot)
seoul_tot$인구 <- as.numeric(gsub(",", "", as.character(seoul_tot$인구)))
seoul_tot$인구밀도 <- as.numeric(gsub(",", "", as.character(seoul_tot$인구밀도)))
seoul_tot$면적 <- as.numeric(seoul_tot$면적)
seoul_tot$강간강제추행발생 <- as.numeric(seoul_tot$강간강제추행발생)
## 2-3. '승하차평균' 변수 생성 및 지하철 이용자수 대비 성범죄 발생빈도로 비율 계산
seoul_tot$승하차평균 <- (seoul_tot$승차총승객수 + seoul_tot$하차총승객수)/2 
seoul_tot$지역인구대비강제추행발생 <- (seoul_tot$강간강제추행발생/seoul_tot$인구밀도) * 100
seoul_tot2 <- seoul_tot[c("행정구", "승하차평균", "강간강제추행발생", "지역인구대비강제추행발생")]

#----------------- [통계적사고와이해] 9주차 실습 - 2 : 단계구분도(지도시각화) -----------------#
help(sp)


## 3. 지도 시각화
## 3-1. 지도 시각화에 필요한 패키지 로드
library(rgdal) # 지리 공간 데이터 추상화 라이브러리에 대한 바인딩
library(raster) # 지리 데이터 분석 및 모델링
library(sp) # 공간데이터 불러오는 패키지
library(ggplot2)
## 3-2. shapefile 불러와 좌표계 변환
seoul <- rgdal::readOGR(paste0(file_dir, "shapefile/TL_SCCO_SIG.shp"))
seoul <- spTransform(seoul, CRS("+proj=longlat")) # spTransform 위도와 경도로 변환을 할때 필요한거 
                                                  # CRS 위도 경도설정
# seoul@data # seoul의 하위목록을 살펴보고 싶을때 @ 사용
seoul_map <- fortify(seoul)
unique(seoul_map$id)



## 3-3. 지도시각화를 위한 데이터 핸들링
seoul_tot2$id <- 0:24
n_seoul <- data.frame(행정구=NA, 승하차평균=NA, 강간강제추행발생=NA, 지역인구대비강제추행발생=NA, id=25:249)
seoul_tot3 <- rbind(seoul_tot2, n_seoul)
seoul_tot.m <- merge(seoul_tot3, seoul_map, by = "id")
center <- read.csv(paste0(file_dir, "center_seoul.csv"), header = TRUE, fileEncoding = "cp949")
center.m <- merge(seoul_tot2, center, by.x = "행정구", by.y = "구")
label <- paste0(center.m$행정구,
                "\n",
                floor(center.m$승하차평균/1000))
label2 <- paste0(center.m$행정구, "\n", center.m$강간강제추행발생)
label3 <- paste0(center.m$행정구, "\n", round(center.m$지역인구대비강제추행발생,3), "%")
## 3-4. 지도시각화
# 승하차평균인원수
ggplot() +
  geom_polygon(data = seoul_tot.m,
               aes(x=long, y=lat, group=group, fill=floor(승하차평균/1000)),
               col="white") +
  theme_void() +
  coord_cartesian(xlim=c(126.7, 127.3),
                  ylim=c(37.4, 37.8)) +
  scale_fill_gradient(low="lightsalmon", high="indianred3", na.value = "white",
                      name = '승하차평균인원 (단위 : 천 명)') +
  geom_text(data=center.m,
            mapping = aes(x=경도, y=위도, label=label), size=3) +
  ggtitle("2017년 서울특별시 자치구별 승하차평균인원수 (단위 : 천 명)") +
  theme(plot.title = element_text(hjust=0.5, size=15))
# 강간강제추행발생건수
ggplot() +
  geom_polygon(data = seoul_tot.m,
               aes(x=long, y=lat, group=group, fill=강간강제추행발생),
               col="white") +
  theme_void() +
  coord_cartesian(xlim=c(126.7, 127.3),
                  ylim=c(37.4, 37.8)) +
  scale_fill_gradient(low="darkseagreen1", high="darkseagreen4", na.value = "white",
                      name = '성범죄발생건수') +
  geom_text(data=center.m,
            mapping = aes(x=경도, y=위도, label=label2), size=3) +
  ggtitle("2017년 서울특별시 자치구별 성범죄발생건수") +
  theme(plot.title = element_text(hjust=0.5, size=15))
seoul_tot.m
ggplot() +
  geom_polygon(data = seoul_tot.m,
               aes(x=long, y=lat, group=group, fill=강간강제추행발생),
               col="white") +
  theme_void() +
  coord_cartesian(xlim=c(126.7, 127.3),
                  ylim=c(37.4, 37.8)) +
  scale_fill_gradient(low="darkseagreen1", high="darkseagreen4", na.value = "white",
                      name = '성범죄발생건수') +
  geom_text(data=center.m,
            mapping = aes(x=경도, y=위도, label=label2), size=3) +
  ggtitle("2017년 서울특별시 자치구별 성범죄발생건수") +
  theme(plot.title = element_text(hjust=0.5, size=15))
View(seoul_tot.m)
seoul_tot.m[seoul_tot.m$행정구 == '종로구', ]



ggplot() +
  geom_polygon(data = seoul_tot.m,
               aes(x=long, y=lat, group=Fs, fill=강간강제추행발생),
               col="white") +
  theme_void() +
  coord_cartesian(xlim=c(126.7, 127.3),
                  ylim=c(37.4, 37.8)) +
  scale_fill_gradient(low="darkseagreen1", high="darkseagreen4", na.value = "white",
                      name = '성범죄발생건수') +
  geom_text(data=center.m,
            mapping = aes(x=경도, y=위도, label=label2), size=3) +
  ggtitle("2017년 서울특별시 자치구별 성범죄발생건수") +
  theme(plot.title = element_text(hjust=0.5, size=15))

