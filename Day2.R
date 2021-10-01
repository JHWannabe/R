# 3. 문자형(Character)\
# 따옴표, 쌍따옴표로 저장
char1 <- 'R'
char2 <- 'programming'
char3 <- '10'
char4 <- "5"

class(char1)
class(char3)

# str() : 자료형 및 구성요소를 확인
str(char1)
str(char2)

result1 <- num1 + num2
# result2 <- char3 + num2 # 문자형과 숫자형의 산술연산은 불가능

# 4. 팩터형(factor)
# 통계학에서 명목형/순서형과 닮은 자료형
# 수치로서 어떤 의미를 갖는 것이 아닌, 범주를 나누기 위한 형태

# c() : 데이터나 객체들을 하나로 결합하여 저장하는 함수
cate <- c("대한민국","영국","프랑스","미국","대한민국"," 중국","미국","인도","영국")
class(cate)

# as.factor() : 단순 문자열을 factor형 변수로 변환
fac1 <- as.factor(cate)
class(fac1)


# 데이터 저장 방식(자료구조)
# 단일값 (Scalar)
num <- 10

# 벡터(Vector)
# 두 개 이상의 값을 가지고 있는 변수
# 값이 나열되어 있는 형태. 한 가지의 자료형만 저장할 수 있음
vec1 <- c(1, 2, 3, 4, 5)
class(vec1)
vec2 <- c('a','b','c','d','e')
class(vec2)
vec3 <- c(TRUE, FALSE, T, F)
class(vec3)
# 연속되는 값을 넣을 경우 ":"을 사용하여 시작값:종료값 형식으로 1씩 증가하느 연속된 값을 저장
vec4 <- c(1:5)
class(vec4) # integer

# 벡터 요소의 자료형이 다를 경우 자료형의 우선순위에 따라 값이 변경
# 논리형 < 숫자형 < 문자형
vec5 <- c(100, T, 10.5)
class(vec5)

vec6 <- c(100, F, "문자형")
class(vec6)

# seq() : 변수에 여러개의 값을 저장함
# seq(시작값, 종료값, [by=증가값]) : 증가값이 없으면 1로 설정
vec7 <- seq(1,10)
class(vec7)
vec8 <- c(1,2,3,4,5,6,7,8,9,10)
class(vec8)
vec9 <- seq(1,10,by=2)

# 벡터의 연산
vec10 <- vec8 + 5
vec11 <- vec7 + vec8

# 만약 지정된 값의 갯수가 다를 경우
vec12 <- vec8 + vec9
# vec8 : 1 2 3 4 5 6 7 8 9 10
# vec9 : 1 3 5 7 9 1 3 5 7 9

# 벡터 요소 접근
vec1
vec1[1] # 벡터의 첫번째 요소

vec13 <- c(50, 90, 70, 60, 45, 35, 15, 100, 80, 85)
vec13[3] # 벡터의 세번째 요소
vec13[1:5] # 벡터의 첫번째 요소부터 다섯번째 요소까지
vec13[-8] # 여덟번째 요소만 제외
vec13[-1:-3] # 첫번째 요소부터 세번째 요소까지 제외한 나머지 요소
vec13[3:1] # 세번째 요소부터 첫번째 요소까지 역순

# rep() : 특정 요소를 반복해서 선택
# rep(값, 반복횟수)
rep(1,5)
rep(vec1, 3)
rep(1:3, each=2)

# max() : 최대값을 선택
max(vec13)
# min() : 최소값을 선택
min(vec13)
# mean() : 평균을 계산
mean(vec13)
# sum() : 합계를 계산
sum(vec13)


# 문제1
# 1부터 10까지의 벡터를 만들어 v1이라는 변수에 저장합니다.
v1 <- c(1:10)
# 각 원소 값들에 2를 곱한 결과로 벡터 v2를 만듭니다.
v2 <- v1*2
# v2에서 최대값을 뽑아 max_v에 저장합니다.
max_v <- max(v2)
# v2에서 최소값을 뽑아 min_v에 저장합니다.
min_v <- min(v2)
# v2에서 평균값을 뽑아 avg_v에 저장합니다.
avg_v <- mean(v2)
# v2에서 합을 뽑아 sum_v에 저장합니다.
sum_v <- sum(v2)
# v2에서 5번째 요소를 제외하고 v3라는 변수에 저장합니다.
v3 <- v2[-5]

# 문제 2
# seq() 또는 rep() 함수를 이용하여 아래 결과가 나오도록 출력합니다.
# 1, 3, 5, 7, 9
seq(1,9,2)
# 1, 1, 1, 1, 1, 1
rep(1,6)
# 1, 2, 3, 1, 2, 3, 1, 2, 3
rep(1:3,3)
# 1, 1, 2, 2, 3, 3, 4, 4
rep(1:4, each=2)

# 연산자
# 산술 연산자
# +, -, *, /,**(거듭제곱), %%(나머지)

# 대입 연산자
# <- , ->, =

# 비교 연산자(결과는 무조건!! Logical)
# >, <,>=, <=, ==(같다), !=(다르다)
10==3
10==10
10>=5
10<=5

# 논리 연산자
# &(벡터), &&(스칼라)
# A       B     결과(&)
# TRUE   TRUE   TRUE
# TRUE   FALSE  FALSE
# FALSE  TRUE   FALSE
# FALSE  FALSE  FALSE

# |(벡터), ||(스칼라)
# A       B     결과(|)
# TRUE   TRUE   TRUE
# TRUE   FALSE  TRUE
# FALSE  TRUE   TRUE
# FALSE  FALSE  FALSE

# !
# A      결과(!)
# TRUE   FALSE
# FALSE  TRUE


# 행렬(matrix) : 2차원 데이터를 저장
# 같은 자료형만 저장
# matrix() : 행렬 데이터를 만듦
mat1 <- matrix(c(1:12), ncol = 4)
mat2 <- matrix(c(1:12), nrow = 4)
# 행방향으로 데이터가 채워짐
mat3 <- matrix(c(1:12), nrow = 4, byrow = T)

# alt + (=) : 글자 간격이 벌어짐
# 다시 한번 alt +(=)를 사용해서 해제

vec1 <- c(1,2,3,4,5)
vec2 <- c(2,4,6,8,10)
vec3 <- c(3,6,9,12,15)

# cbind() : 열 중심으로 벡터값을 행렬로 만듬
# rbind() : 행 중심으로 벡터값을 행렬로 마듬

mat5 <- cbind(vec1, vec2, vec3)
mat6 <- rbind(vec1, vec2, vec3)

# names() : 벡터값에 제목(열이름)을 설정
vec4 <- c(1:3)
names(vec4) <- c("1열","2열","3열")
vec5 <- c(1:4)
names(vec5) <- LETTERS[1:4]

# colnames() : 행렬에서 열의 이름을 설정
colnames(mat6) <- c("1열", "2열", "3열", "4열", "5행")

# rownames() : 행렬에서 행의 이름을 붙여줌
rownames(mat6) <- c("1행", "2행", "3행")

# 행, 열의 이름을 삭제하는 방법
colnames(mat6) <- NULL
rownames(mat6) <- NULL

# 행렬의 요소 접근
mat6[10] # 열 우선 방식 4
mat6[1,] # 1행 전체를 선택
mat6[,1] # 1열 전체를 선택
mat6[3,1] # 3행 1열을 선택
mat6[1:2,] # 1행~2행 전체를 선택(연속된 행)
mat6[c(1, 3),] # 1행, 3행 전체를 선택(연속되지 않은 행)
mat6[-1,] # 1행을 제외한 값을 선택
mat6[,-c(1,3)] # 1열, 3열을 제외한 값값

# 과제

# 1. 1부터 10까지 출력하는데 3씩 증가 되는 형태로(1, 4, 7, 10) 저장되는 벡터를 정의하여 v3 변수에 저장합니다. (단, 각각 값마다 "A", "B", "C", "D"라는 이름을 부여합니다.)
v3 <- seq(1, 10, 3)
names(v3) <- LETTERS[1:4]

# 2. 아래와 같이 값이 구성되는 메트릭스를 정의하여 m1에 저장합니다. 1, 2, 3의 벡터 n1, 4, 5, 6의 벡터 n2, 7, 8, 9의 벡터 n3을 이용하여 matrix를 구성합니다.

#     ,1  ,2  ,3
# 1,   1   4   7
# 2,   2   5   8
# 3,   3   6   9

n1 <- c(1,2,3)
n2 <- c(4,5,6)
n3 <- c(7,8,9)

m1 <- cbind(n1, n2, n3)
colnames(m1) <- NULL

# 문제3-1. 아래와 같이 구성되는 2행 3열 매트릭스 alpha를 생성합니다.
#
#       [,1] [,2] [,3]
#   [1,] "a"  "c"  "e"
#   [2,] "b"  "d"  "f"
alpha <- matrix(letters[1:6], ncol=3)

# 문제3-2. 'x', 'y', 'z'라는 행을 추가합니다.
alpha <- rbind(alpha, c('x','y','z'))

# 문제3-3. 's', 'p' 라는 열을 추가합니다.
alpha <- cbind(alpha, c('s','p'))