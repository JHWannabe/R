# DataFrame(데이터 프레임) : 2차원
# 데이터 프레임은 분석에서 가장 많이 사용되는 자료형
# 행렬과 달리 다양한 자료형을 동시에 사용할 수 있음
# data.frame() : 데이터 프레임을 생성
vec1 <- c(1,2,3,4,1,2)
vec2 <- c('a','b','c','d','e','f')
vec3 <- c(1,'a','b','c',1,'a')
class(vec1)
class(vec2)
class(vec3)
df1 <- data.frame(vec1, vec2, vec3)
class(df1)

# 데이터 프레임의 요소 접근

# 데이터 프레임의 특정 열의 값을 선택하는 방법
# 1. 데이터프레임명[열번호] : 데이터프레임의 형태
df1[1]
class(df1[1])
df1[1:2]
class(df1[1:2])
# 2. 데이터프레임명$열이름 : 벡터 데이터의 형태
df1$vec1
class(df1$vec1)

# csv 외부 데이터를 읽어오는 방법
# read.csv() : csv파일을 읽어 데이터 프레임으로 저장
# 파일을 읽는 경로1 : 절대경로
# E:\jhwannabe\Rlanguage
csv_exam <- read.csv("E:/jhwannabe/Rlanguage/csv_exam.csv")
# 파일을 읽는 경로2 : 상대경로
csv_exam <- read.csv("csv_exam.csv")


csv_exam[1,] # 1행만 선택
class(csv_exam[1,])

csv_exam[,1]
class(csv_exam[,1])

# 3. 데이터프레임명['열이름'] : data.frame
csv_exam['math']
class(csv_exam['math'])

# 4. 데이터프레임명[,열번호] : integer
csv_exam[,1]
class(csv_exam[,1])

# 5. 데이터프레임명[,'열이름'] : integer
csv_exam[,'math']
class(csv_exam[,'math'])

# 조건에 만족하는 데이터프레임의 데이터를 선택하는 방법
# 1. 데이터 프레임의 class열에 저장된 값이 1인 행만 선택
csv_exam[csv_exam$class == 1,]
# 2. 데이터 프레임의 math열에 저장된 데이터가 80이상인 행만 선택
csv_exam[csv_exam$math >= 80,]
# 3. 데이터 프레임의 class열에 저장된 값이 1이고, english열에 데이터가 90이상인 행만 선택
csv_exam[csv_exam$class==1 & csv_exam$english >=90,]


# csv의 헤더가 없는 데이터 읽기
csv_exam_noheader <- read.csv("csv_exam_noheader.csv")
# 읽어올 csv파일의 첫번째 행이 열 이름이 아닌 경우 데이터 손실이 일어남
# header=F 옵션을 사용해 데이터 손실을 막음
csv_exam_noheader <- read.csv("csv_exam_noheader.csv",header=F)
colnames(csv_exam_noheader) <- NULL
colnames(csv_exam_noheader) <- c('id','class','math','english','science')


# 외부 패키지를 사용하는 방법
# install.packages("패키지이름")
install.packages('dplyr')

# 사용
# library(패키지이름)
library(dplyr)

# 설치 에러가 나는 경우
# 1. 바이러스 차단 프로그램이 프로그램의 설치를 막는 경우
# 2. os계정이 한글, 특수문자, 띄어쓰기가 있는 경우
# 설치 경로 확인
.libPaths()
# E:\jhwannabe\Rlanguage\lib
.libPaths('E:/jhwannabe/Rlanguage/lib')


# rename() : 데이터 프레임의 열 이름을 변경
# rename(데이터프레임,  새이름=기존이름, 새이름=기존이름..)
csv_exam_noheader <- read.csv("csv_exam_noheader.csv", header=F)
csv_exam_copy <- csv_exam_noheader # 복사
csv_exam_copy <- rename(csv_exam_copy, id=V1, class=V2, math=V3, english=V4, science=V5)

# 엑셀파일 읽어오기(readxl)
install.packages('readxl')
library(readxl)
# read_excel() : 엑셀파일을 읽어 tibble 형태로 저장
excel_exam <- read_excel('excel_exam.xlsx')

# tibble
# 데이터 프레임을 현대적으로 재구성한 타입으로 Simple Data Frame이라고도 부름
# data.frame을 만들 때 사용하고, 데이터를 간략하게 표현하고 대용량 데이터를 다룰 수 있게 함

# 읽어올 excel 파일의 첫번째 줄이 열 이름이 아닌 경우 col_names=F 옵션을 지정
excel_exam_noheader <- read_excel('excel_exam_noheader.xlsx', col_names = F)
excel_exam_noheader_copy <- excel_exam_noheader
excel_exam_noheader_copy <- rename(excel_exam_noheader_copy, id='...1', class='...2', math='...3', english='...4',science='...5')

# tibble은 사용하는 패키지에 따라 사용할 수 없는 함수들이 많으므로 데이터 프레임으로 변환시켜 사용하는 것이 일반적
# as.data.frame() : 자료구조를 데이터 프레임 형태로 변환
df_excel_exam <- as.data.frame(excel_exam_noheader_copy)
class(df_excel_exam)

# 엑셀 파일에 sheet가 여러개 있는 경우 sheet=n(n은 읽어올 sheet의 위치) 또는 sheet='시트이름' 옵션을 지정해서 읽어옴
excel_exam <- read_excel('excel_exam.xlsx', sheet=2)
excel_exam <- read_excel('excel_exam.xlsx', sheet='Sheet2')
excel_exam <- as.data.frame(excel_exam)
class(excel_exam)

# write.csv() : 데이터 프레임 자료를 csv파일로 내보내기
# write.csv(데이터 프레임, file='파일명', row.names=F)
write.csv(excel_exam, file='df_excel_exam.csv', row.names=F)


# array(배열) : 다차원, matrix로 구성되어 있음, matrix가 여러개 있는 구조
# array() : 배열을 생성. dim 속성을 이용하여 행, 열, 면의 순서로 array 구조를 설정
# array(데이터 dim=c(2,3,4)) : 데이터로 2행, 3열, 4면
arr1 <- array(c(1:24), dim=c(2,3,4))

# 배열의 요소 접근
# arr1[행, 열, 면]

# 1번째 면의 데이터를 선택
arr1[,,1]
# 1번째 면의 첫번째 행을 선택
arr1[1,,1]
# 2번째 면의 두번째 열을 선택
arr1[,2,2]
# 모든 면의 1번째 행을 선택
arr1[1,,]
# 모든 면의 1행 2열 데이터를 선택
arr1[1,2,]

# list(리스트) : 다차원, 데이터 프레임으로 구성
# list() : 리스트를 생성
vec <- 1
mat <- matrix(c(1:12), ncol=6)
df <- data.frame(x1=c(1,2,3), x2=c('a','b','c'))
arr <- array(c(1:20), dim=c(2,5,2))
li <- list(list1=vec, list2=mat, list3=arr, list4=df)

# 문제1. 아래와 같이 값이 구성되는 데이터프레임을 정의하여 df1에 저장합니다.
#   x   y
#1  1   2
#2  2   4
#3  3   6
#4  4   8
#5  5  10
df1 = data.frame(x=c(1:5), y=seq(2, 10, by=2))

# 문제2. 아래와 같이 값이 구성되는 데이터프레임을 정의하여 df2에 저장합니다.
#   col1  col2 col3
#1  1       a    6 
#2  2       b    7
#3  3       c    8
#4  4       d    9
#5  5       e   10
df2 = data.frame(col1=1:5, col2=letters[1:5], col3=6:10)


# 문제3-1. data.frame()과 c()를 조합해서 표의 내용을 데이터 프레임으로 만들어 출력합니다.
#   제품        가격        판매량
#   사과        1800        24
#   딸기        1500        38
#   수박        3000        13
df_fruit <- data.frame(제품=c('사과', '딸기', '수박'), 가격=c(1800,1500,3000), 판매량=c(24, 38, 13))


# 문제3-2. 앞에서 만든 데이터 프레임을 이용하여 과일 가격 평균, 판매량 평균을 구합니다.
mean(df_fruit[,2])

mean(df_fruit[,3])