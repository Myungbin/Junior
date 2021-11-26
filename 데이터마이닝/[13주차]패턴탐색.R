# 계층적군집분석
library(flexclust)

data("nutrient")

dat <- nutrient
str(dat)

# 표준화
dat_scaled <- scale(dat)

d <- dist(dat_scaled)

?hclust

dat_hc <- hclust(d, method = "average")

plot(dat_hc, hang = -1, xlab = "food")

# 최적의 군집개수 찾기
library(NbClust)
set.seed(123)

datnb <- NbClust(dat_scaled, distance = "euclidean", method = "average", min.nc = 3,
                 max.nc = 15)

table(datnb$Best.nc[1,])

# cutree()
dat_cut <- cutree(dat_hc, k = 5)
table(dat_cut)

par(mfrow = c(1,1))
plot(dat_hc, hang = -1)
rect.hclust(dat_hc, k=5) # 군집을 상자로 표현(나누기)

# aggregate : 특정 열을 기준으로 통계량을 구해주는 함수

a <- aggregate(dat_scaled, by = list(clusters = dat_cut), mean)

v <- as.vector(table(dat_cut))

cbind(a,v)

# 미리군집이 정해지면 바뀌지 않음, 대용량데이터 적용하기 어려움

# k-means 군집분석

dat <- read.csv('bike_station_locations (1).csv')

str(dat)

plot(dat$longitude, dat$latitude)

nbc <- NbClust(dat, distance = 'euclidean', min.nc = 2, max.nc = 10,
               method = "kmeans")

table(nbc$Best.nc[1,]) # 2개가 가장많음

library(factoextra)

set.seed(123)
# 군집정하기(최적의 군집찾기)
fviz_nbclust(dat, kmeans, method = "silhouette")  # 2
fviz_nbclust(dat, kmeans, method = "wss")  # 2
fviz_nbclust(dat, kmeans, method = "gap_stat", nboot = 500) # 1

library(cluster)

clusGap(dat, kmeans, nstart = 25, K.max = 10,B = 500)

two_model <- kmeans(dat,2)
two_model$centers # 중심값
two_model$cluster

###############################################################################

data("USArrests")

dat <- USArrests

str(dat)

# scale 
dat_scaled <- scale(dat)
class(dat_scaled)
dat_scaled <- as.data.frame(dat_scaled)

set.seed(123)
si <- clusGap(dat_scaled, kmeans, nstart = 25, K.max = 10, B=500)

# k-means

set.seed(1004)

kmeans_4 <- kmeans(dat_scaled, centers = 4)
kmeans_4$centers

dat$cluster <- kmeans_4$cluster

library(dplyr)

dat %>% summarise(means_murde = mean(Murder))

dat %>% group_by(cluster) %>%summarise(murder = mean(Murder),
                                       assault = mean(Assault),
                                       UrbanPop = mean(UrbanPop),
                                       rape = mean(Rape),
                                       n = n())

# 평행좌표 시각화

library(GGally)

str(dat)

dat$cluster <- as.factor(dat$cluster)

ggparcoord(data = dat, columns = c(1:4),
           groupColumn = "cluster",
           scale = "std") + 
  labs(x = "미국 주별 강력 범죄율",
       y = "표준화된 value",
       title = "군집별 평행좌표")


# 차원 축소를 이용한 군집별 산점도

fviz_cluster(kmeans_4, dat_scaled, ellipse.type = "norm") 
  
library(ggplot2)

library(repr)

cluster_num <- as.factor(kmeans_4$cluster)

cityname <- rownames(dat_scaled)
  
# annotate () : 주석을 달아주는 함수

ggplot(data = dat_scaled,
       aes(x = Murder, y = UrbanPop, colour = cluster_num)) +
  geom_point(shape = 19, size = 4) +
  theme(plot.title = element_text(size = 20, face = 'bold')) +
  annotate('text', x = dat_scaled$Murder, y = dat_scaled$UrbanPop + 0.1,
           label = cityname, size = 5, color = 'gray') +
  annotate('point', x = kmeans_4$centers[1, 1], y = kmeans_4$centers[1, 3], size = 6, color = 'black') +
  annotate('point', x = kmeans_4$centers[2, 1], y = kmeans_4$centers[2, 3], size = 6, color = 'black') +
  annotate('point', x = kmeans_4$centers[3, 1], y = kmeans_4$centers[3, 3], size = 6, color = 'black') +
  annotate('point', x = kmeans_4$centers[4, 1], y = kmeans_4$centers[4, 3], size = 6, color = 'black') +
  annotate('text', x = kmeans_4$centers[1, 1], y = kmeans_4$centers[1, 3]+ 0.2, size = 8, label = 'cluster1') +
  annotate('text', x = kmeans_4$centers[2, 1], y = kmeans_4$centers[2, 3]+ 0.2, size = 8, label = 'cluster2') +
  annotate('text', x = kmeans_4$centers[3, 1], y = kmeans_4$centers[3, 3]+ 0.2, size = 8, label = 'cluster3') +
  annotate('text', x = kmeans_4$centers[4, 1], y = kmeans_4$centers[4, 3]+ 0.2, size = 8, label = 'cluster4')

