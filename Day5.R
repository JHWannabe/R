# 데이터 정제
# 데이터 정제란 빠진 데이터 또는 잘못된 데이터를 제거하는 작업
# 빠진 데이터, 측정이 안된 데이터, 없는 데이터 -> 결측치(NA)
# 문자열 결측지 <NA>, 문자열을 제외한 나머지 자료형의 결측지 NA 표시

df_na <- data.frame(gender=c('M','F',NA,'F','M'), score=c(5,3,4,2,NA))

# is.na() : 데이터에 결측치가 포함되어 있는지 여부를 확인
# 결측치는 TRUE, 결측치가 아니면 FALSE 표시
is.na(df_na)

# is.na(), table() 이용하여 결측치의 빈도수를 파악
table(df_na$gender)
table(is.na(df_na$gender))
table(is.na(df_na$score))

# 결측치가 포함된 데이터를 함수에 적용시키면 정상적으로 연산되지 않고, NA가 출력
# 정상적인 연산을 하려면 결측치를 제외
sum(df_na$score)
mean(df_na$score)
install.packages('dplyr')
library(dplyr)

# 결측치 처리방법
# 1. dplyr 패키지의 filter()를 사용해서 결측치를 제외한 데이터만 추출
df_no_na <- df_na %>% filter(!is.na(score))
sum(df_no_na$score)
mean(df_no_na$score)
df_no_na <- df_na %>% filter(!is.na(score) & !is.na(gender))
sum(df_no_na$score)
mean(df_no_na$score)
# 2. na.omit() 함수를 사용해서 결측치가 있는 모든 행을 한꺼번에 제거
df_no_na <- na.omit(df_na)
# 3. 함수를 실행할 때 na,rm = T 속성을 지정하면 결측치를 제외하고 함수를 실행
sum(df_na$score, na.rm = T)
mean(df_na$score, na.rm = T)

df_excel_exam_na <- excel_exam
df_excel_exam_na[c(3,8,15),'math2'] <- NA
df_excel_exam_na[20, 'science2'] <- NA

df_excel_exam_na %>% group_by(class2) %>% summarise(
  math_sum = sum(math2, na.rm = T), math_mean = mean(math2, na.rm = T), math_n = n()
)
# 개수(n())는 NA가 포함되어 출력

# filter() 함수를 사용하여 결측치 제거
df_excel_exam_na %>% group_by(class2) %>% filter(!is.na(math2)) %>% summarise(math_sum = sum(math2), math_mean = mean(math2),math_n=n())

# na. omit() 함수를 사용하여 결측치 제거
na.omit(df_excel_exam_na) %>% group_by(class2)%>% summarise(math_sum = sum(math2), math_mean = mean(math2),math_n=n())

# 4. ifelse()를 사용해서 결측치를 결측치가 아닌 데이터의 평균값으로 대체
# 데이터의 평균이나 중위수처럼 특정 데이터 집단을 대표할 수 있는 값으로 대체시켜 사용
# NA를 제외한 math와 science의 평균을 계산
mean(df_excel_exam_na$math2, na.rm = T) # 55.23529
mean(df_excel_exam_na$science2, na.rm = T) # 59.52632

# math의 3,8,15 데이터를 NA에서 NA를 제외한 math의 평균으로 대체
# science 20 데이터를 NA에서 NA를 제외한 science의 평균으로 대체
df_excel_exam_na$math2 <- ifelse(is.na(df_excel_exam_na$math2), mean(df_excel_exam_na$math2, na.rm = T), df_excel_exam_na$math2)

df_excel_exam_na$science2 <- ifelse(is.na(df_excel_exam_na$science2), mean(df_excel_exam_na$science2, na.rm = T), df_excel_exam_na$science2)


# 극단치(이상점, outlier)
# outlier은 존재할 수 없는 값이 데이터에 포함되어 있음을 의미함
# 발견된 outlier는 결측치로 변환한 후, 제거하거나 다른값으로 대체
# outlier -> NA -> 처리(제거, 다른값으로 대체..)

# gender 0~9까지의 데이터만 가질 수 있고, score는 1~10까지만 가질 수 있음
outlier <- data.frame(gender=c(1,2,4,2,11,7,5,9,6,2),score=c(5,10,3,2,7,9,10,5,11,9))

# outlier가 존재할 경우 ifelse() 함수로 outlier를 결측치로 변환
outlier$gender <- ifelse(outlier$gender>9,NA,ifelse(outlier$gender<0,NA, outlier$gender))
outlier$score <- ifelse(outlier$score>10,NA,ifelse(outlier$score<1,NA, outlier$score))

# ggplot2의 간단한 그래프 그리기
# ggplot2 그래프 작성법은 레이어 구조
# 배경을 먼저 그리고, 그 위에 그래프를 그리고, 그 위에 축, 색, 표식 등 추가해서 완성

library(ggplot2)

# 1. 그래프가 출력될 배경을 만듬
# ggplot(data=데이터프레임, aes(x=가로축, y=세로축))
ggplot(data=mpg, aes(x=hwy, y=cty))

# 2. 배경에 geom_그래프이름()를 +로 연결하여 그래프를 그림
ggplot(data=mpg, aes(x=hwy, y=cty)) + geom_point()

# 3. 그래프 위에 +로 연결하여 추가 옵션을 주고 완성
ggplot(data=mpg, aes(x=hwy, y=cty)) + geom_point() + xlim(10,60) + ylim(5,50)

# 구동방식별(drv) 고속도로 연비 평균을 막대 그래프(geom_col())로 표현
mpg_drv <- mpg %>% group_by(drv) %>% summarise(mean_hwy=mean(hwy))
ggplot(data=mpg_drv, aes(x=drv, y=mean_hwy)) + geom_col()

# 문제
# 차종(class)별 도시 연비(cty) 평균을 막대 그래프로 표현
mpg_class <- mpg %>% group_by(class) %>% summarise(mean_cty=mean(cty))
ggplot(data=mpg_class, aes(x=class, y=mean_cty)) + geom_col()

# reorder() : x축 항목의 정렬 순서를 변경
# reorder(정렬할 데이터가 저장된 변수, 정렬 기준으로 사용할 변수)
# reorder(class, mean_cty) # class를 mean_cty의 오름차순으로 정렬
# reorder(class, -mean_cty) # class를 mean_cty의 내림차순으로 정렬
ggplot(data=mpg_class, aes(x=reorder(class, mean_cty), y=mean_cty)) + geom_col()
ggplot(data=mpg_class, aes(x=reorder(class, -mean_cty), y=mean_cty)) + geom_col()

# 문제
# 어떤 회사에서 생산한 suv 자동차가 연비가 높은지 알아보기 위해 suv차종(class)을 대상으로 도시연비(cty)평균이 가장 높은 5개의 회사를 나타내는 막대 그래프를 연비가 높은 순서로 정렬하여 표현합니다.
mpg_suv <- mpg %>% filter(class=='suv') %>% group_by(manufacturer) %>% summarise(mean_cty=mean(cty)) %>% arrange(desc(mean_cty)) %>% head(5)
ggplot(data=mpg_suv, aes(x=reorder(manufacturer, -mean_cty), y=mean_cty)) + geom_col()


# 한국 복지 패널 데이터 분석
# 통계 소프트웨어 SPSS, SAS, STATA 프로그램 데이터 형태로 제공되는 경우 foreign 패키지를 이용하여 R에서 데이터 변환
install.packages('foreign')
library(foreign)

# foreign 패키지의 read.spss() 함수를 사용해 SPSS 타입의 데이터를 list 타입으로 읽어옴 -> 데이터 프레임 형태로 변환
raw_welfare <- read.spss('Koweps_hpc10_2015_beta1.sav', to.data.frame = T)
class(raw_welfare)

welfare <- raw_welfare

str(welfare)
summary(welfare)
head(welfare)
tail(welfare)
dim(welfare)
View(welfare)

# Koweps_Codebook.xlsx(코드북) 파일을 참조해서 rename() 함수로 변수의 이름을 변경

welfare <- rename(welfare, gender=h10_g3) # 성별
welfare <- rename(welfare, birth=h10_g4) # 태어난 연도
welfare <- rename(welfare, marriage=h10_g10) # 혼인 상태
welfare <- rename(welfare, religion=h10_g11) # 종교
welfare <- rename(welfare, code_job=h10_eco9) # 직종코드
welfare <- rename(welfare, income=p1002_8aq1) # 평균 임금
welfare <- rename(welfare, code_region=h10_reg7) # 지역코드


# 성별에 따른 급여 차이가 존재하는지 알아보자!

# 성별 데이터 전처리
welfare$gender
class(welfare$gender)
table(welfare$gender)

welfare$gender <- ifelse(welfare$gender == 9, NA, welfare$gender)
table(is.na(welfare$gender))

# gender가 1일 때 'male', 2일 때 'female'
welfare$gender <- ifelse(welfare$gender == 1, 'male', 'female')

# 급여 데이터 전처리
welfare$income
class(welfare$income)
table(welfare$income)

# 급여는 1만원~9998만원 사이의 값을 가지므로 급여의 범위를 벗어나는 경우 outlier로 보고 결측치로 처리
welfare$income <- ifelse(welfare$incom < 1 | welfare$income > 9998, NA, welfare$income)
table(is.na(welfare$income))

# 성별에 따른 평균 급여표를 만듬
gender_income <- welfare %>% filter(!is.na(income))
table(is.na(gender_income$income))

gender_income <- welfare %>% filter(!is.na(income)) %>% group_by(gender) %>% summarise(mean_income = mean(income))
ggplot(data=gender_income, aes(x=gender, y=mean_income)) + geom_col()

# 몇 살때 급여를 가장 많이 받을 지 알아보자.
welfare$birth
class(welfare$birth)
table(welfare$birth)

# 생년이 1900년 미만, 2014년 초과인 데이터는 결측치로 처리함
welfare$birth <- ifelse(welfare$birth < 1900 | welfare$birth > 2014, NA, welfare$birth)
# 모름/무응답 결측치로 처리함
welfare$birth <- ifelse(welfare$birth == 9999, NA, welfare$birth)

# 나이를 저장할 age 파생변수 만들기
welfare$age <- 2015 - welfare$birth
table(welfare$age)

# 나이에 따른 급여 평균표 만듬
age_income <- welfare %>% filter(!is.na(income)) %>% group_by(age) %>% summarise(mean_income = mean(income))

ggplot(data=age_income, aes(x=age, y=mean_income)) + geom_col()
# 선 그래프로 표현
ggplot(data=age_income, aes(x=age, y=mean_income)) + geom_line()


# 연령대(young: 1~29살, middle: 30~59살, old: 60살~)
# 어떤 연령대의 급여가 가장 많은지 알아보자.
welfare <- welfare %>% mutate(
  age_group = ifelse(age<30, 'young', ifelse(age<60, 'middle', 'old'))
  )
class(welfare$age_group)
table(welfare$age_group)

# 연령대별 평균 급여표
agegroup_income <- welfare %>% filter(!is.na(income)) %>% group_by(age_group) %>% summarise(mean_income = mean(income))

ggplot(data=agegroup_income, aes(x=age_group, y=mean_income)) + geom_col()

# scale_x_discrete() : x축 레이블의 오름차순으로 정렬되어 작성되는 그래프 x축의 출력 순서를 변경
# scale_x_discrete() 함수의 limit 속성에 c()함수를 사용하여 순서를 지정
ggplot(data=agegroup_income, aes(x=age_group, y=mean_income)) + geom_col() + scale_x_discrete(limit=c('young','middle','old'))

# 성별에 따른 급여 차이는 어떤 연령대에서 가장 클지 알아보자
agegroup_gender_income <- welfare %>% filter(!is.na(income)) %>% group_by(age_group, gender) %>% summarise(mean_income = mean(income))

# fill 속성을 통해 색상으로 구별
ggplot(data=agegroup_gender_income, aes(x=age_group, y=mean_income,fill=gender)) + geom_col() + scale_x_discrete(limit=c('young','middle','old'))

# geom_col() 함수에 position='dodge' 옵션을 지정하면 그래프를 쌓아서 표현하지 않고 그룹별로 그래프를 표현
ggplot(data=agegroup_gender_income, aes(x=age_group, y=mean_income,fill=gender)) + geom_col(position='dodge') + scale_x_discrete(limit=c('young','middle','old'))