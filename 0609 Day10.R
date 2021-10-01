# 오픈 API로 데이터 수집하기

#               API인증키발급, 데이터 제공
#                  <-------
# API서비스 사용자 -------> API서비스 제공자
#               API인증키신청, 서비스 요청

.libPaths('E:/jhwannabe/Rlanguage/lib')
install.packages('usethis')
library(usethis)

# 환경변수
usethis::edit_r_environ()
DATAGOKR_TOKEN
myKey = Sys.getenv('DATAGOKR_TOKEN')
# myKey = "키값"

install.packages('tidyverse')
library(tidyverse)
library(httr)
library(rvest)
library(jsonlite)
library(dplyr)

# 요청 URL 저장
URL <- 'http://openapi.molit.go.kr/OpenAPI_ToolInstallPackage/service/rest/RTMSOBJSvc/getRTMSDataSvcAptTradeDev'


# http 요청을 실행
# 웹 서버로 문자열을 보낼 때 %를 보내면 %25로 변경됨
# 따라서 이중으로 바뀌지 않도록 그대로 처리하기 위한 함수

res <- GET(url=URL,
           query = list(LAWD_CD = '11110',
                        DEAL_YMD = '201512',
                        serviceKey = myKey %>% I()))

print(x=res)

res %>% content(as = 'text', encoding = 'UTF-8') %>% 
  fromJSON() -> json

str(json)

# 전처리
df <- json$response$body$items$item
print(df)

months <- c('201901','201902','201903','201904','201905','201906')

as.Date(x= '2019-01-01')
as.Date(x= '20190101', format = '%Y%m%d')
as.Date(x= '2019/01/01', format = '%Y/%m/%d')

seq(from = as.Date(x='2015-01-01'),
    to = as.Date(x='2018-12-01'),
    by = '1 month') -> months

# 201501 ~ 201812
format(x=months, format='%Y%m') -> months

# 전체 데이터 저장 객체를 빈 데이터프레임으로 생성
result = data.frame()

for(month in months){
  cat('현재',month,'기간 거래된 데이터 수집!\n')
  
  res <- GET(url=URL,
             query = list(LAWD_CD = '11680',
                          DEAL_YMD = month,
                          serviceKey = myKey %>% I()))

  res %>% content(as = 'text', encoding = 'UTF-8') %>% 
    fromJSON() -> json
  
  df <- json$response$body$items$item
  result <- rbind(result, df)
  Sys.sleep(time = 1) #1초 쉼
}

str(object = result)

# 거래금액을 숫자 벡터로 변환
result$거래금액 %>% str_remove(pattern = ',') %>% as.numeric() -> result$거래금액

# 법정도, 아파트, 지역코드등 문자 벡터를 범주형으로 변환
head(x=result$법정동)
as.factor(x=result$법정동) %>% head()

# 여러개의 컬럼을 한 번에 범주형 벡터로 변환
map_df(.x = result[, c(4,5,6)],
       .f = as.factor) -> result[, c(4,5,6)]

# 거래금액의 평균
mean(result$거래금액)

# 거래금액의 중위수
median(x = result$거래금액)

# 건축년도의 최빈값
# 벡터의 원소 중 가장 빈도수가 높은 원소가 무엇인지 확인할 때 사용
result$건축년도 %>% table() %>% sort(decreasing = TRUE)

# 거래금액의 최소값 및 최대값
min(x = result$거래금액)
max(x = result$거래금액)

# 거래금액의 범위(최소값과 최대값의 간격)
range(x = result$거래금액)

# 거래금액의 최소값과 최대값의 간격을 계산
range(x = result$거래금액) %>% diff()

# 사분위수 : 숫자 벡터를 4등분할 때 각각의 분리점에 위치한 숫자를 의미
# 사분위수를 계산
quantile(x = result$거래금액)

# 백분위수 : 숫자 벡터의 원소들을 오름차순으로 정렬했을 때 백분율로 표현되는 특정 위치에 해당하는 값을 의미
quantile(x = result$거래금액, probs=c(0.95, 0.99))

# 사분범위 : 사분위수 중 1사분위수와 3사분위수의 간격을 의미
IQR(x=result$거래금액)

# 분산, 표준편차
var(x=result$거래금액)
sd(x=result$거래금액)


# 시각화
# 히스토그램 : 일정한 간격의 계급을 정하고 계급에 속한 도수를 계산해 막대 그래프와 유사한 모양

# 기본
hist(x=result$거래금액, main='거래금액 히스토그램램')

hist(x=result$거래금액,
     breaks = seq(from=0, to=300000, by=25000),
     freq = FALSE,
     col='gray50',
     border='gray30',
     main='거래금액 히스토그램')

# 확률밀도곡선 추가
lines(x=density(x=result$거래금액), lwd=3, col='red')

# 상자수염그림
# 거래금액의 상자수염그림
boxplot(x=result$거래금액, main='거래금액 상자수염그림')

# 중위수 : 가운데 굵은 선
# 수평선 : 아래에 위치한 수평선은 하한선, 위에 위치한 수평선은 상한선

boxplot(formula = 거래금액 ~ 법정동,
        data= result,
        las=2,
        main='법정동별 거래금액 상자수염그림')

# 산점도
# 숫자 벡터 간 관계를 표현
plot(x=result$전용면적,
     y=result$거래금액,
     pch=19,
     col='gray50',
     main='전용면적과 거래금액 간 산점도')

# 선형회귀선
abline(reg=lm(formula= 거래금액 ~ 전용면적 , data=result), lwd=3, col='red')
