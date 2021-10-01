# 파생변수
# 계산에 의해 데이터가 채워진 변수(열)
df_raw <- data.frame(var1=c(1,2,1), var2=c(2,3,4))
df_raw_copy <- df_raw

# 파생변수 만드는 방법1 : 데이터프레임$파생변수
df_raw_copy$var_sum <- df_raw_copy$var1 + df_raw_copy$var2
df_raw_copy$var_mean <- df_raw_copy$var_sum / 2


excel_exam_copy <- excel_exam
# 합계 파생변수 만들기
excel_exam_copy$var_sum <- excel_exam_copy$math2 + excel_exam_copy$english2 + excel_exam_copy$science2
# 평균 파생변수 만들기
excel_exam_copy$var_mean <- excel_exam_copy$var_sum / 3

# subset() : 데이터프레임에서 특정 변수의 데이터를 뽑음
# subset(데이터프레임, select=시작변수명:끝변수명) : 연속적인 열 추출
# subset(데이터프레임, select=c(변수명, 변수명..)) : 비연속적인 열 추출
subset(excel_exam_copy, select = math2:science2)
subset(excel_exam_copy, select = c(math2,science2))
excel_exam_copy[,c('math2','science2')] # 동일한 값 가져옴

# rowSums() : 행의 합계를 계산
# rowMeans() : 행의 평균을 계산
excel_exam_copy$var_sum2 <- rowSums(subset(excel_exam_copy, select=math2:science2))
excel_exam_copy$var_mean2 <- rowMeans(subset(excel_exam_copy, select=math2:science2))

# 파생변수 만드는 방법2 : transform()
# transform(데이터프레임, 파생변수이름=데이터)
excel_exam_copy <- transform(excel_exam_copy, var_sum3=rowSums(subset(excel_exam_copy, select=math2:science2)))

# 파생변수 만드는 방법3 : mutate()  ---중요!
# mutate() : 한번에 여러개의 파생변수를 추가, dplyr 패키지에 포함
library(dplyr)
excel_exam_copy <- excel_exam

# %>%(파이프) 연산자 : dplyr패키지에 있는 대입문으로 왼쪽의 데이터를 오른쪽 함수로 전달. %>% 왼쪽의 데이터 프레임이 %>% 오른쪽 함수로 전달되기 때문에 데이터프레임의 열을 사용해야할 때 [데이터프레임$변수이름]과 같이 사용하지 않고 데이터프레임 이름을 생략하여 변수명만 사용할 수 있음
# 컨트롤 + 시프트 + m

excel_exam_copy <- excel_exam_copy %>% mutate(
  var_sum = rowSums(subset(excel_exam_copy, select=math2:science2)), 
  var_mean = rowMeans(subset(excel_exam_copy, select=math2:science2))
)


# 데이터 전처리
# 데이터 전처리는 데이터 분석 작업에 적합하게 데이터를 가공하는 일

df_excel_exam_copy <- excel_exam

# filter() : 원하는 행단위 데이터를 추출
df_excel_exam_copy %>% filter(df_excel_exam_copy$class2 == 1)
df_excel_exam_copy %>% filter(class2 == 1)
df_excel_exam_copy %>% filter(class2 == 1 | class2 == 5)
df_excel_exam_copy %>% filter(class2 %in% c(1,5)) # 같은 의미

# ggplot2 : 그래프 요소를 작성
# mpg 데이터
install.packages('ggplot2')
library(ggplot2)

mpg

# 제조사(manufacturer)가 audi인 도시주행연비(cty)의 평균을 출력
mpg_audi <- mpg %>% filter(manufacturer == 'audi')
mean(mpg_audi$cty)

# 제조사(manufacturer)가 toyota인 도시주행연비(cty)의 평균을 출력
mpg_toyota <- mpg %>% filter(manufacturer == 'toyota')
mean(mpg_toyota$cty)

# 문제
# 제조사가 chevrolet, ford, honda인 자동차의 고속도로 주행연비(hwy) 전체 평균을 출력
mpg_cfh <- mpg %>% filter(manufacturer %in% c('chevrolet','ford','honda'))
mean(mpg_cfh$hwy)


# table() : 데이터의 항목(빈도수)
table(mpg_cfh$manufacturer)
table(mpg$manufacturer)

# head() : 데이터 개수를 정해서 데이터를 앞부분부터 확인. 개수를 생략하면 기본값으로 6개를 확인
head(mpg, 3)
head(mpg)

# tail() : 데이터 개수를 정해서 데이터를 뒷부분부터 확인. 개수를 생략하면 기본값으로 6개를 확인
tail(mpg, 3)
tail(mpg)

# arrange() : 데이터를 정렬
df_excel_exam_copy %>% arrange(math2) # 오름차순
df_excel_exam_copy %>% arrange(desc(math2)) # 내림차순

# math2 점수로 내림차순 후, math2 점수가 같을 경우 science2 점수로 내림차순 정렬 후 5등까지 출력
df_excel_exam_copy %>% arrange(desc(math2), desc(science2)) %>% head(5)

# summarise() : 그룹별로 통계치를 산출 (열의 데이터)

# mutate() 함수는 mean_math라는 파생변수를 만들고 모든 math2 데이터의 평균을 계산해서 mean_math에 넣어주지만, summarise() 함수는 모든 math2 데이터의 평균만 계산해서 따로 출력
df_excel_exam_copy %>% mutate(mean_math = mean(math2))
df_excel_exam_copy %>% summarise(mean_math = mean(math2))

# group_by() : 데이터의 그룹을 맺을 수 있음
df_excel_exam_copy %>% group_by(class2) %>% summarise(mean_math = mean(math2))

df_excel_exam_copy %>% group_by(class2) %>% summarise(
  합계 = sum(math2), 
  평균 = mean(math2), 
  최대값 = max(math2), 
  최소값 = min(math2), 
  표준편차 = sd(math2), 
  개수 = n()
)

# 문제 // 다시 풀어보기!
# mpg 데이터에서 자동차회사별로 차종(class)이 'suv'인 자동차의 cty와 hwy의 평균을 계산해서 내림차순으로 정렬하고 상위 5개를 출력
mpg %>% group_by(manufacturer) %>% filter(class == 'suv') %>% mutate(avg=(cty+hwy)/2) %>% summarise(avg_mean=mean(avg)) %>% arrange(desc(avg_mean)) %>% head(5)

# 차종별(class)로 도시연비(cty)평균을 계산해서 평균이 높은 순서대로 출력
mpg %>% group_by(class) %>% summarise(cty_mean=mean(cty)) %>% arrange(desc(cty_mean))

# 고속도로 연비(hwy)의 평균이 가장 높은 회사 3곳을 출력
mpg %>% group_by(manufacturer) %>% summarise(hwy_mean=mean(hwy)) %>% arrange(desc(hwy_mean)) %>% head(3)

# 각 회사별 경차(compact)의 차종(class) 수를 내림차순으로 정렬해 출력
mpg %>% group_by(manufacturer) %>% filter(class=='compact') %>% summarise(count = n()) %>% arrange(desc(count))




# left_join() : 가로로 데이터를 합침
# left_join(데이터프레임1, 데이터프레임2, 데이터프레임3.. by='기준변수명')
# by 옵션에는 합칠 때 기준이 되는 변수의 이름을 입력해야 하며, 합쳐질 두개의 데이터프레임에 반드시 같은 이름의 변수가 있어야 함
test1 <- data.frame(id=c(1,2,3,4,5), middle1=c(60,70,100,90,50))
test2 <- data.frame(id=c(1,2,3,4,5), middle2=c(70,90,80,100,60))
left_join(test1, test2, by='id')

df_excel_join <- excel_exam
df_teacher_name <- data.frame(class2=c(1,2,3,4,5), teacher=c('김사과','이메론','반하나','오렌지','류정원'))

# left_join()으로 합치기를 실행할 때 두 개의 데이터프레임에 행(데이터)의 개수가 반드시 같아야 할 필요는 없음
left_join(df_excel_join, df_teacher_name, by='class2')

# bind_rows() : 세로로 데이터를 합침
group1 <- data.frame(id=c(1,2,3,4,5), test=c(60,70,90,100,20))
group2 <- data.frame(id=c(6,7,8,9,10), test=c(70,85,100,90,30))
bind_rows(group1, group2)


# 과제1
# 다음 세 벡터를 이용하여 데이터프레임을 생성하고, gender 변수의 값을 반대 성별로 변경합니다. 그리고 name 변수는 문자, gender 변수는 팩터, math 변수는 숫자 데이터의 유형이라는 것을 확인합니다.
name <- c("류정원", "김사과", "오렌지", "반하나", "이멜론")
gender <- factor(c("M", "F", "M", "F", "M"))
math <- c(85, 76, 99, 88, 40)
df_group <- data.frame(name, gender, math, stringsAsFactors = F)
df_group$gender <- factor(ifelse(df_group$gender == 'F', 'M', 'F'))

class(df_group$name) # character
class(df_group$gender) # factor
class(df_group$math) #numeric

# 위에서 만든 데이터프레임에 대해 아래 작업을 수행합니다.
# stat변수를 추가합니다. stat <- c(76,73,95,82,35)
df_group$stat <- c(76,73,95,82,35)

# math변수와 stat변수의 합을 구하여 score변수에 저장합니다.
df_group$score <- df_group$math + df_group$stat

# 논리 연산 인덱싱을 이용하여 score가 150이상이면 A, 100이상 150미만이면 B, 70이상 100미만이면 C등급을 부여하고 grade 변수에 저장합니다.
df_group$grade <- ifelse(df_group$score>=150,'A',ifelse(df_group$score>=100,'B',ifelse(df_group$score>=70,'C',NA)))

# 과제2-1
# excel_exam_copy 데이터 프레임에서 평균 점수(var_mean)가 60점이상이면 'pass', 그렇지 않으면 'fail'을 가지는 파생변수 result를 추가합니다.
excel_exam_copy$result <- ifelse(excel_exam_copy$var_mean>=60,"pass","fail")

# 과제2-2
# 평균 점수가 90점이상이면 'A', 80점이상이면 'B', 70점이상이면 'C', 60점 이상이면 'D', 나머지는 'F'인 학점을 나타내는 grade 파생변수를 추가합니다.
excel_exam_copy$grade <- ifelse(excel_exam_copy$var_mean>=90,'A',ifelse(excel_exam_copy$var_mean>=80,'B',ifelse(excel_exam_copy$var_mean>=70,'C',ifelse(excel_exam_copy$var_mean>=60,'D','F'))))
