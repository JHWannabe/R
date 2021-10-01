# 어떤 직업이 가장 급여를 많이 받을지 알아보자.
welfare$code_job
class(welfare$code_job)  # numeric
table(welfare$code_job)

# 설치 에러가 나는 경우
# 1. 바이러스 차단 프로그램이 프로그램의 설치를 막는 경우
# 2. os계정이 한글, 특수문자, 띄어쓰기가 있는 경우
# 설치 경로 확인
.libPaths()
# E:\jhwannabe\Rlanguage\lib
.libPaths('E:/jhwannabe/Rlanguage/lib')

# 코드북 파일 2번째 시트의 데이터를 읽어옴

library(readxl)
job_list <- read_excel('Koweps_Codebook.xlsx', sheet=2)

welfare_job <- welfare
# left_join() 함수로 welfare_job에 job_list를 결합한다.
welfare_job <- left_join(welfare_job, job_list, by='code_job')
welfare_job$job

table(is.na(welfare_job$code_job))
table(is.na(welfare_job$job))

# 직업 종류가 너무 많기 때문에 평균 급여를 내림차순으로 정렬해서 30개만 뽑아냄(단, 직업 코드나 직업 또는 급여가 NA가 아닌 데이터만 추출)
welfare_job %>% filter(!is.na(code_job) & !is.na(income)) %>% select(code_job, job, income)

job_income_top30 <- welfare_job %>% filter(!is.na(code_job) & !is.na(income)) %>% select(code_job, job, income) %>% group_by(job) %>% summarise(mean_income = mean(income)) %>% arrange(desc(mean_income)) %>% head(30)

ggplot(data=job_income_top30, aes(x=job, y=mean_income)) + geom_col()

ggplot(data=job_income_top30, aes(x=reorder(job, -mean_income), y=mean_income)) + geom_col()

# x축 레이블에 표시되는 직업의 이름이 너무 길어서 겹쳐보이므로 coord_flip() 함수를 사용하여 차트를 회전 시킴
ggplot(data=job_income_top30, aes(x=reorder(job, -mean_income), y=mean_income)) + geom_col() + coord_flip() + ylim(0, 1000) + xlab("직업") + ylab("평균 급여") + ggtitle("직업별 상위 30개의 평균 급여 그래프프")


# 문제
# 직업이 "정보시스템 개발 전문가(0222)"일 경우 나이별 평균 급여는 얼마인가? (막대그래프로 표현)
job1 <- welfare_job %>% filter(code_job == 0222 & !is.na(income)) %>% group_by(age) %>% summarise(mean_income = mean(income))

ggplot(data=job1, aes(x=age, y=mean_income))+ geom_col()


# 문제
# 직업이 "정보시스템 개발 전문가(0222)"일 경우 나이별, 성별별 평균 급여는 얼마인가? (막대그래프로 표현, 색으로 성별을 표현)
job2 <- welfare_job %>% filter(code_job == 222 & !is.na(income)) %>% group_by(age, gender) %>% summarise(mean_income = mean(income))

ggplot(data=job2, aes(x=age, y=mean_income, fill=gender))+ geom_col(position='dodge')

# 성별별로 어떤 직업에 종사하는 사람이 많을지 알아보자.
# 성별별 직업 빈도표
job_gender <- welfare_job %>% filter(!is.na(job)) %>% group_by(job, gender) %>% summarise(n=n()) %>% arrange(desc(n)) %>% head(30)

ggplot(data=job_gender, aes(x=reorder(job, n), y=n, fill=gender)) + geom_col(position='dodge') + coord_flip()

# 남자 직업 빈도표
job_gender_male <- welfare_job %>% filter(!is.na(job) & gender=='male') %>% group_by(job) %>% summarise(n=n()) %>% arrange(desc(n)) %>% head(30)

ggplot(data=job_gender_male, aes(x=reorder(job, n), y=n)) + geom_col() + coord_flip() + xlab("직업") + ylab("인원수")

# 여자 직업 빈도표
job_gender_female <- welfare_job %>% filter(!is.na(job) & gender=='female') %>% group_by(job) %>% summarise(n=n()) %>% arrange(desc(n)) %>% head(30)

ggplot(data=job_gender_female, aes(x=reorder(job, n), y=n)) + geom_col() + coord_flip() + xlab("직업") + ylab("인원수")



# 종교가 있는 사람은 이혼을 덜 할지 알아보자
welfare$religion
table(welfare$religion)

# 모름/무응답 결측치 처리
welfare$religion <- ifelse(welfare$religion==9, NA,welfare$religion)

# 종교가 있는 사람은 "yes", 없는 사람은 "no"로 데이터 처리
welfare$religion <- ifelse(welfare$religion == 1, "yes", "no")

table(welfare$religion)

# 혼인상태 전처리
welfare_marriage <- welfare
welfare_marriage$marriage
# 혼인 유지중(1, 4) : marriage
# 이혼(3) : divorce
# 나머지 : NA
table(welfare_marriage$marriage)

welfare_marriage$group_marriage <- ifelse(welfare_marriage$marriage %in% c(1,4), "marriage", ifelse(welfare_marriage$marriage == 3, "divorce", NA))

# 종교 유무에 따른 이혼률 표를 만듬
religion_marriage <- welfare_marriage %>% filter(!is.na(group_marriage)) %>% group_by(religion, group_marriage) %>% summarise(n=n()) %>% mutate(pct = round(n/sum(n)*100,1))

# round() : 반올림을 계산
# round(반올림할 숫자 데[이터, 반올림 후 화면에 표시할 자리수])
  
ggplot(data=religion_marriage, aes(x=group_marriage, y=pct, fill=religion)) + geom_col(position = 'dodge')  
  
# 연령대별 이혼율 표를 만듬
age_group_marriage <- welfare_marriage %>% filter(!is.na(group_marriage)) %>% group_by(age_group, group_marriage) %>% summarise(n=n()) %>% mutate(pct=round(n/sum(n)*100, 1))

ggplot(data=age_group_marriage, aes(x=age_group, y=n, fill=group_marriage)) + geom_col(position = 'dodge') + scale_x_discrete(limit=c('young','middle','old'))

ggplot(data=age_group_marriage, aes(x=group_marriage, y=n, fill=age_group)) + geom_col(position = 'dodge')


# 어떤 지역에 어떤 연령대가 많이 사는지 알아보자.
# 1.서울 2.수도권(인천/경기) 3.부산/경남/울산 4. 대구/경북 5.대전/충남 6.강원/충북 7.광주/전남/전북/제주도

welfare$code_region
welfare_region <- welfare

table(welfare_region$code_region)
welfare_region$code_region <- ifelse(welfare_region$code_region<1 | welfare_region$code_region>7, NA, welfare_region$code_region)

# 7개의 지역을 저장하는 데이터프레임을 만듬
list_region <- data.frame(code_region=c(1:7), region=c("서울","수도권(인천/경기)","부산/경남/울산","대구/경북","대전/충남","강원/충북","광주/전남/전북/제주도"))

welfare_region <- left_join(welfare_region, list_region, by = 'code_region')
table(welfare_region$region)

region_age_group <- welfare_region %>% filter(!is.na(region)) %>% group_by(region, age_group) %>% summarise(n=n()) %>% mutate(pct=round(n/sum(n)*100, 1))

ggplot(data=region_age_group, aes(x=region, y=pct, fill=age_group)) +geom_col(position = 'dodge') + coord_flip()


# 연령대가 young인 사람들이 많이 사는 지역은 어디인지 알아보자.
region_age_group_young <- region_age_group %>% filter(age_group == 'young')
ggplot(data=region_age_group_young, aes(reorder(region,pct), pct)) +geom_col(position = 'dodge') + coord_flip()

region_age_group_young <- region_age_group %>% filter(age_group == 'young') %>% arrange(pct)

# x축 레이블 출력 순서를 별도로 저장
order_young_list <- region_age_group_young$region

ggplot(region_age_group_young, aes(reorder(region,-pct), pct)) +geom_col(position = 'dodge') + coord_flip() + scale_x_discrete(limit=order_young_list)

library(ggplot2)

# 범례 순서 변경하기
# aes() 함수의 fill 속성에 지정할 변수를 factor() 함수를 실행해서 vector 타입을 factor 타입으로 변경할 때 levels 속성으로 출력할 범례 순서를 지정

class(region_age_group$age_group)
levels(region_age_group$age_group)

# factor() 함수를 사용해서 age_group을 factor로 변환하고 levels 속성으로 범례 순서를 변경
region_age_group$age_group <- factor(region_age_group$age_group)
levels(region_age_group$age_group)

ggplot(region_age_group, aes(region, pct, fill=age_group)) + geom_col(position='dodge') + coord_flip() + scale_x_discrete(limit=order_young_list)

region_age_group$age_group <- factor(region_age_group$age_group, levels=c('young','middle','old'))

ggplot(region_age_group, aes(region, pct, fill=age_group)) + geom_col(position='dodge') + coord_flip() + scale_x_discrete(limit=order_young_list)