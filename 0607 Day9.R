# 웹 브라우저 원격 조작에 사용하는 Selemium 사용하기

# 브라우저 드라이버를 설치
# 크롬브라우저 : ...클릭 > 도움말 > 크롬정보
# 버전 91.0.4472.77(공식 빌드) (64비트)
# https://chromedriver.chromium.org/downloads

# 구글드라이브에서 selenium-server-standalone-master.zip을 다운받아 압축을 해제함
# 크롬드라이버 압축을 풀고 chromedriver.exe를 selenium-server-standalone-master/bin 폴더 안에 넣어줌
# selenium-server-standalone-master/bin 폴더에서 shift + 마우스 오른쪽 버튼을 눌러 "여기에서 power shell 창열기"를 실행

.libPaths('E:/jhwannabe/Rlanguage/lib')
install.packages("RSelenium")
library(RSelenium)

rd <- remoteDriver(remoteServerAddr='localhost', port=4445L, browserName='chrome')
rd$open()  # 브라우저 오픈
rd$navigate('https://www.google.com')  # URL 이동
elem <- rd$findElement('css', "[name='q']")  # CSS 선택자를 이용하여 name속성에 q값을 찾음
elem$sendKeysToElement(list("날씨", key="enter"))


# 네이버 웹툰 (신의 탑)
# https://comic.naver.com/webtoon/detail.nhn?titleId=183559&no=491&weekday=mon
# 네이버 웹툰 댓글 크롤링
# iframe 주소 : https://comic.naver.com/comment/comment.nhn?titleId=183559&no=491
rd <- remoteDriver(remoteServerAddr='localhost', port=4445L, browserName='chrome')
rd$open()  # 브라우저 오픈
rd$navigate(' https://comic.naver.com/comment/comment.nhn?titleId=183559&no=491')  # URL 이동

review = NULL
doms <- rd$findElements(using = "css selector", "span.u_cbox_contents")
review <- sapply(doms, function(x){ x$getElementText() })
class(review)
review <- unlist(review)
class(review)

# 댓글 더보기 클릭
btn <- rd$findElement(using = "css selector", "span.u_cbox_in_view_comment")
btn$clickElement()
Sys.sleep(1)
# 전체 댓글 페이지가 몇 페이지인지 모르기 때문에 repeat 명령을 사용해서 무한 루프를 돌리고 끝까지 읽으면 무한 루프를 탈출

repeat {
  for(i in 4:12){
    nextLink <- paste("div.u_cbox_paginate > div > a:nth-child(",i,")", sep="")
    print(nextLink)
    nextPage <- rd$findElements(using = "css selector", nextLink)
    if(length(nextPage) == 0){
      break
    }
    sapply(nextPage, function(x) { x$clickElement() })
    Sys.sleep(1)
    
    doms <- rd$findElements(using = "css selector", "span.u_cbox_contents")
    result <- sapply(doms, function(x){ x$getElementText() })
    result <- unlist(result)
    review <- c(review, result)
  }
  nextLink <- "div.u_cbox_paginate > div > a:nth-child(13)"
  nextPage <- rd$findElements(using = "css selector", nextLink)
  if(length(nextPage) == 0){
    break
  }
  sapply(nextPage, function(x) { x$clickElement() })
  Sys.sleep(1)
  
  doms <- rd$findElements(using = "css selector", "span.u_cbox_contents")
  result <- sapply(doms, function(x){ x$getElementText() })
  result <- unlist(result)
  review <- c(review, result)
}

# webtoonReview.csv로 저장하기
# webtoonReview.csv를 메모리로 읽어옴
# 특수문자, 제어문자 제거
# 명사 추출
# 빈도수 내림차순
# 2자이상 단어를 사용하여 워드 클라우드를 작성

review
write.csv(review, "webtoonReview.csv")
webtoonReview <- read.csv("webtoonReview.csv", stringsAsFactors = F)
class(webtoonReview$x)

txt <- gsub("[[:punct:]]","",webtoonReview)
txt <- gsub("[[:digit:]]","",txt)
txt <- gsub("[[:cntrl:]]","",txt)
txt <- gsub("[[:lower:]]","",txt)
txt <- gsub("[[:upper:]]","",txt)
txt <- gsub('\"',"",txt)
txt <- gsub('\n',"",txt)

# 과제
# http://www.yes24.com/Product/Goods/40936880
# 리뷰 크롤링

library(KoNLP)

nouns <- extractNoun(txt)
nouns <- unlist(nouns)

wordCount <- table(nouns)
class(wordCount)

df_wordCount <- as.data.frame(wordCount)
class(df_wordCount)

library(dplyr)
df_wordCount <- rename(df_wordCount, word=nouns, freq=Freq)

df_wordCount <- df_wordCount %>% filter(nchar(word) >= 2 & nchar(word) <=6 & freq > 3)

df_wordCount <- df_wordCount %>% group_by(word) %>%  summarise(freq = sum(freq))

top200 <- df_wordCount %>% arrange(desc(freq)) %>% head(200)

library(wordcloud)
pal = brewer.pal(8, "Dark2")
wordcloud(words = top200$word,
          freq = top200$freq,
          min.freq = 2,
          max.words = 200,
          rot.per = 0.1,
          random.order = F,
          scale = c(10, 0.2),
          colors = pal)

top20 <- df_wordCount %>% arrange(desc(freq)) %>% head(20)

order_asc <- arrange(top20, freq)$word
order_desc <- arrange(top20, desc(freq))$word

library(ggplot2)
ggplot(top20, aes(word, freq)) + geom_col() + coord_flip() + ylim(0,400) + geom_text(aes(label=freq), hjust = -0.5) + scale_x_discrete(limits =order_asc)


# 공공데이터 포털
# "아파트매매 실거래 상세 자료"로 검색
# 오픈 API에서 "국토교통부_아파트매매 실거래 상세자료"를 선택


