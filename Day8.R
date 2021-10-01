# 크롤링(정적 웹 스크레이핑)
# HTML, CSS, JavaScript
# HTML : 웹 사이트의 틀을 생성
# CSS : HTML을 보완, 디자인 요소를 설정
# JavaScript : 동적인 화면을 설정

# 네이버 영화 평점
# https://movie.naver.com/movie/point/af/list.nhn

# 웹 스크레이핑에 사용할 패키지를 설치
install.packages("rvest")
library(rvest)

url <-  "https://movie.naver.com/movie/point/af/list.nhn"
content <- read_html(url, encoding = "UTF8")

# rvest 패키지의 read_html로 읽어온 HTML문서에서 필요한 데이터를 읽어옴
# class -> . , id -> #
nodes <- html_nodes(content, ".movie")

# html_text() : 텍스트만 반환, trim=T : 공백을 제거
movie <- html_text(nodes, trim=T)

nodes <- html_nodes(content, "div.list_netizen_score > em")
point <- html_text(nodes, trim=T)

nodes <- html_nodes(content, 'td.title')
temp <- html_text(nodes, trim=T)

# 제어문자를 제거
temp <- gsub("[[:cntrl:]]","",temp)


# strsplit() : 특정 포멧을 기준으로 문자열을 분리해서 list 타입으로 저장
# strsplit(문자열, "기준이 되는 포멧")
str <- "가, 나, 다, 라, 마, 바, 사"
str_list <- strsplit(str, ",")

# 정규 표현식
# https://www.nextree.co.kr/p4327/

# 제목 ~~~ - 총 10점 중x ~~~
temp <- strsplit(temp, "중[0-9]{1,2}")
class(temp)
temp <- unlist(temp)
class(temp)

# substr() : 원하는 문자를 추출
# substr(문자, 시작, 종료)
# nchar() : 문자수 반환
temp <- substr(temp, 0, nchar(temp)-3)


##########################################

# 반복문(for)
# for(변수명 in 반복횟수){
#     반복할 문장
#     ...
# }

# 변수 i가 1부터 5까지 1씩 증가하면서 반복
for(i in 1:5){
  print(i)
}

# 변수 i가 5부터 1까지 1씩 감소하면서 반복
for(i in 5:1){
  print(i)
}

# 변수 i가 1 3 5 7 9로 변경되면서 반복
for(i in c(1,3,5,7,9)){
  print(i)
}

# 변수 i가 1부터 10까지 3씩 증가하면서 반복
for(i in seq(1, 10, by=3)){
  print(i)
}

# 변수 i가 10부터 110까지 3씩 감소하면서 반복
for(i in seq(10, 1, by=-3)){
  print(i)
}

#########################################

review <- NULL

for(i in seq(2, 20, by=2)){
  review = c(review, temp[i])
}

movie # 제목
point # 별점점
review # 리뷰

# cbind() 함수를 사용해서 제목, 평점, 리뷰를 합침
page <- cbind(movie, point)
page <- cbind(page, review)
class(page)

write.csv(page, "movie_review.csv")

# 페이징 처리
# https://movie.naver.com/movie/point/af/list.nhn?&page=1
# https://movie.naver.com/movie/point/af/list.nhn?&page=2
# https://movie.naver.com/movie/point/af/list.nhn?&page=3
# https://movie.naver.com/movie/point/af/list.nhn?&page=n

# paste() 함수로 변경되지 않는 주소부분과 페이지 숫자를 붙여서 읽어올 페이지 주소를 만듬
site <- "https://movie.naver.com/movie/point/af/list.nhn?&page="

for(i in seq(1,10)){
  url <- paste(site, i, sep="")
  print(url)
  Sys.sleep(1)  # 1초 딜레이
}


movie_review = NULL

for (i in seq(1, 500)) {
  url <- paste(site, i, sep="")
  print(url)
  content <- read_html(url, encoding = "UTF8")
  Sys.sleep(1)
  
  nodes <- html_nodes(content, ".movie")
  movie <- html_text(nodes, trim=T)
  
  nodes <- html_nodes(content, "div.list_netizen_score > em")
  point <- html_text(nodes, trim=T)
  
  nodes <- html_nodes(content, 'td.title')
  temp <- html_text(nodes, trim=T)
  temp <- gsub("[[:cntrl:]]","",temp)
  temp <- strsplit(temp, "중[0-9]{1,2}")
  temp <- unlist(temp)
  temp <- substr(temp, 0, nchar(temp)-3)
  
  review <- NULL
  
  for(i in seq(2, 20, by=2)){
    review = c(review, temp[i])
  }
  
  page <- cbind(movie, point)
  page <- cbind(page, review)
  movie_review <- rbind(movie_review, page)
  
}

write.csv(movie_review, "movie_review.csv")

#################################################
movie_review <- read.csv("movie_review.csv", stringsAsFactors = F)

library(dplyr)

movie_review_mean <- movie_review %>% group_by(movie) %>% summarise(
  count = n(),
  mean = round(mean(point), 2)
) %>% filter(count > 10) %>% arrange(desc(mean)) %>% head(10)

library(ggplot2)

ggplot(movie_review_mean, aes(reorder(movie, mean), mean)) + geom_col() + coord_flip() + ggtitle("네이버 영화 평점 순위") + xlab("영화제목") + ylab("평점") + geom_text(aes(label=mean), hjust=0.5) + geom_text(aes(label=count), hjust=4, color="white", size=8)



# 웹 브라우저 원격 조작에 사용하는 Selemium 사용하기

# 브라우저 드라이버를 설치
# 크롬브라우저 : ...클릭 > 도움말 > 크롬정보
# 버전 91.0.4472.77(공식 빌드) (64비트)
# https://chromedriver.chromium.org/downloads

# 구글드라이브에서 selenium-server-standalone-master.zip을 다운받아 압축을 해제함
# 크롬드라이버 압축을 풀고 chromedriver.exe를 selenium-server-standalone-master/bin 폴더 안에 넣어줌
# selenium-server-standalone-master/bin 폴더에서 shift + 마우스 오른쪽 버튼을 눌러 "여기에서 power shell 창열기"를 실행

install.packages("RSelenium")
library(RSelenium)

rd <- remoteDriver(remoteServerAddr='localhost', port=4445L, browserName='chrome')
rd$open()
rd$navigate('https://www.google.com')
elem <- rd$findElement('css', "[name='q']")
elem$sendKeysToElement(list("날씨", key="enter"))