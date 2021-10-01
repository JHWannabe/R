# 텍스트 마이닝
# 문자로 된 데이터에서 가치있는 정보를 얻어내어 분석하는 기법

.libPaths('E:/jhwannabe/Rlanguage/lib')

install.packages("KoNLP")
library(KoNLP)

# multilinguer 설치
install.packages("multilinguer")
# 의존성 패키지 설치
install.packages(c("stringr","hash","tau","Sejong","RSQLite","devtools"), type="binary")

# github 버전 설치
install.packages("remotes")
remotes::install_github('haven-jeon/KoNLP', upgrade="never", INSTALL_opts=c("--no-multiarch"), force=TRUE)

library("KoNLP")

# 설치에 문제가 생긴 경우
# 1. 사용자 계정 문제
# .libPaths('E:/jhwannabe/Rlanguage/lib')
# 2. https://www.oracle.com/java/technologies/javase-downloads.html
# Java SE 11(LTS)를 운영체제에 맞게 다운로드

useSejongDic()

# EUC-KR(ANSI)
word_data <- readLines("애국가.txt")
# UTF-8
word_data <- readLines("애국가.txt", encoding="UTF-8")

class(word_data)

# sapply() : 행렬구조의 데이터에서 모든 행에 함수를 적용할 때 사용하는 함수
# sapply(데이터, 함수)
# extractNoun() : 명사를 추출하는 함수
noun <- sapply(word_data, extractNoun)

# 사전에 단어를 등록
add_words <- c("백두산","하느님","남산","철갑","가을")

# buildDictionary() : 사전에 단어를 등록하는 함수
# ncn : 추가할 단어 명령어, KAIST 품사 태그 기준 비서술성 명사로 설정
buildDictionary(user_dic = data.frame(add_words, rep("ncn", length(add_words))), replace_usr_dic = T)

noun <- sapply(word_data, extractNoun)
class(noun)

noun <- unlist(noun)
class(noun)
wordCount <- table(noun)

# 내림차순으로 정렬
sort(wordCount, decreasing = T)

# 데이터프레임 형태로 변환
df_word_table <- as.data.frame(wordCount)

# 변수의 이름을 변경
library(dplyr)
df_word_table <- rename(df_word_table, word=noun, freq=Freq)

# 내림차순으로 정렬하여 저장
top_word <- df_word_table %>% arrange(desc(freq))

# 워드 클라우드
install.packages("wordcloud")
library(wordcloud)
# RColorBrewer : 글자 색상을 표현
# http://www.datamarket.kr/xe/index.php?mid=board_AGDR50&document_srl=203&listStyle=viewer
pal <- brewer.pal(8, "Dark2")

wordcloud(
  words = top_word$word,  # 표시할 단어 목록
  freq = top_word$freq,  # 단어의 출현 빈도수
  min.freq = 1,  # 단어의 최소 개수
  max.words = 10,  # 단어의 최대 개수
  rot.per = 0.1,  # 단어의 회전 비율
  random.order = F,  # 출현 빈도가 높은 단어를 중앙에 배치
  scale = c(5,0.5),  # 워드 클라우드에 표시되는 단어의 크기 범위
  colors = pal  # 단어에 표시할 색상 목록에 저장된 팔레트
)

install.packages("wordcloud2")
library(wordcloud2)

wordcloud2(top_word, fontFamily = "맑은 고딕", size=0.8, color="random-light", backgroundColor="black", shape="star")

# data : 데이터프레임
# size : font-size, default=1
# fontFamily : 설치되어 있는 fount로 글자모양을 변격ㅇ
# color: random-dark, random-light를 사용할  수 있고, 특정색을 지정할 수 있음
# backgroundColor : 배경 색상을 변경
# minSize : 자막 문자열의 크기를 설정
# shape : 워드클라우드의 모양 설정(circle, diamound, pentagon, star ..)


# hiphop1.txt
txt <- readLines('hiphop1.txt', encoding="UTF-8")

useNIADic()

class(txt)
noun <- extractNoun(txt)
noun <- unlist(noun)
class(noun)

# 단어별 빈도표
wordCount <- table(noun)
df_wordCount <- as.data.frame(wordCount)
df_wordCount <- rename(df_wordCount, word=noun, freq=Freq)

# 특정 문자 / 특수 문자 변경 및 제거
data <- "abcdefg123456!@#$%^"

# gsub() : 특정 문자를 다른 문자로 변경

# 특정 문자를 변경
result <- gsub("a", "z",data)

# 특정 문자를 제거
result <- gsub("g","", data)

# 특정 특수문자를 제거
result <- gsub("[\\$]","",data)

# 모든 특수문자를 제거
result <- gsub("[[:punct:]]","",data)

txt <- readLines('hiphop1.txt', encoding="UTF-8")
txt <- gsub("[[:punct:]]","",txt)  # 특수문자
txt <- gsub("[[:digit:]]","",txt)  # 숫자
txt <- gsub("[[:cntrl:]]","",txt)  # 제어문자
txt <- gsub("[[:lower:]]","",txt)  # 소문자
txt <- gsub("[[:upper:]]","",txt)  # 대문자

noun <- extractNoun(txt)
noun <- unlist(noun)
wordCount <- table(noun)
df_wordCount <- as.data.frame(wordCount)
df_wordCount <- rename(df_wordCount, word=noun, freq=Freq)

# 데이터프레임에서 데이터를 정제
df_wordCount$word <- gsub(" ","",df_wordCount$word)

# 워드클라우드로 구성할 단어를 추출
# nchar() : 단어의 수를 리턴
df_wordCount <- df_wordCount %>% filter(nchar(word)>= 2)

top200 <- df_wordCount %>% arrange(desc(freq)) %>% head(200)

wordcloud(
  words = top200$word,  # 표시할 단어 목록
  freq = top200$freq,  # 단어의 출현 빈도수
  min.freq = 2,  # 단어의 최소 개수
  max.words = 100,  # 단어의 최대 개수
  rot.per = 0.1,  # 단어의 회전 비율
  random.order = F,  # 출현 빈도가 높은 단어를 중앙에 배치
  scale = c(5,0.5),  # 워드 클라우드에 표시되는 단어의 크기 범위
  colors = pal  # 단어에 표시할 색상 목록에 저장된 팔레트
)

wordcloud2(top200, fontFamily = "맑은 고딕", size=0.8, color="random-light", backgroundColor="black", shape="circle")
