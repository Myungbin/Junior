# ex1) sum
x <- 1:5
sum(x)

## ex2) mean
mean( c(x, NA), na.rm = T)

## ex3) sd
sd(x)
?sd

## get source code
getAnywhere(sd)
getAnywhere(lm)

## custom function
#function_name <-function(input){
#  (...)
#  return(output)
#}

## ex1) 평균, 중앙값
print_ct <- function(x) {
 mean_value <- mean(x)
 median_value <- median(x)
 cat('mean:', mean_value, 'median_value: ', median_value)
}

head(iris, n = 10)

print_ct(iris$Sepal.Length)

# return
cal_ct <- function(x) {
  mean_value <- mean(x)
  median_value <- median(x)
  return(list('mean_value' = mean_value,
              'median_value' = median_value))
}

cal_ct(iris$Sepal.Length)


# for Loop 

# for(i in range){
#   (...)
# }

sum_value = 0
for(i in 1:100){
  sum_value = sum_value+i
}

sum_value

##  Fatalities data
dat <- read.csv('Fatalities.csv', row.names = 'X')
str(dat)

var_names <- colnames(dat)

#pop가 포함된 변수명만 뽑아오기(뒤에 숫자가 포함된)

pop_var_names <- grep(pattern = 'pop[0-9]', var_names, value = T)

## 반목문 사용 x
mean(dat[, pop_var_names[1]])
mean(dat[, pop_var_names[2]])
mean(dat[, pop_var_names[3]])

## pop[0-9]의 평균을 반복문을 이용해서 구해보자  

## step 1 print
for(i in pop_var_names){
  print(mean(dat[, i]))
}

## step return(결과를 result_vector에 저장)
result_vec = c()
for(i in pop_var_names){
  result_vec[i] <- mean(dat[, i])
}

result_vec

## step 3) 일반화
## 변수명 벡터 자체를 input으로 받아서 변수명 벡터에 해당하는 데이터들의 평균을 
## 각각 구해주는 함수



mean_by_var <- function(var_names, dat) {
  result_vec = c()
  for(v_idx in var_names){
    result_vec[v_idx] <- mean(dat[, v_idx])
}
  return(result_vec)  
}

mean_by_var(var_names = c('income', 'dry'), dat = dat)

mean_by_var(var_names = c('Sepal.Length', 'Sepal.Width'), dat = iris)

mean_by_var(var_names = grep('fatal', var_names, value = T), dat = dat)


## Step 4) 계산을 해주는 함수도 인수로 받아보자

func_by_var <- function(var_names, dat, func) {
  result_vec = c()
  for(v_idx in var_names){
    result_vec[v_idx] <- func(dat[, v_idx])
  }
  return(result_vec)  
}


func_by_var(var_names = c('income', 'dry'), dat = dat, func = mean)

func_by_var(var_names = c('income', 'dry'), dat = dat, func = sum)

func_by_var(var_names = c('income', 'dry'), dat = dat, func = min)

func_by_var(var_names = c('income', 'dry'), dat = dat, func = function(x) sum(is.na(x)))

## +) apply 
? apply

apply(dat[, c('income', 'dry')], MARGIN = 2, FUN = mean)






