use titanic;
show tables; -- titanic 내의 테이블 확인

-- 데이터 조회 명령어
-- SELECT * FROM 테이블명;
-- 전체 열을 조회
select 
	*
from p_info;

-- 테이블에서 1개 컬럼만 조회
-- SELECT 컬럼명 FROM 테이블명;

select 
	Name
from p_info;

-- 여러 컬럼을 조회
-- SELECT 컬럼명1, 컬럼명2 FROM 테이블명;

select 
	Name,
    Age
from p_info;

-- 테이블의 구조 확인

desc p_info;

-- 데이터를 10개만 조회하고 싶은 경우

select
	*
from p_info 
limit 10;

-- 조건에 맞는 데이터 조회
-- where + 비교연산자, 논리연산자
select 
	*
from p_info 
where Sex = 'male';

select 
	*
from p_info
where Sex != 'male'; -- Sex = 'female'

-- 나이가 40세 이상인 사람만 조회

select
	*
from p_info
where Age >= 40;

-- 성별이 남성이고 나이가 10세 미만인 경우

select
	*
from p_info
where Sex = 'male'
and Age < 10;

-- 성별이 남성이거나 나이가 10세 미만인 경우

select 
	*
from p_info
where Sex = 'male'
or Age < 10;



-- 실습 문제 풀이
-- 20세 이상 50세 미만 여성 조회
select 
	*
from p_info 
where Age >= 20  -- Age between 20 and 49
and Age < 50
and Sex = 'female';

-- SibSp와 Parch가 1 이상인 사람을 조회

select 
	*
from p_info
where SibSp >= 1
and Parch >= 1;

-- SibSp이 1 이상이거나 Parch가 1 이상인 사람을 조회

select 
	*
from p_info
where SibSp >= 1
 or Parch >= 1;

-- Pclass가 1인 승객

select 
	*
from t_info
where Pclass = 1;

-- Pclass가 2 또는 Fare가 50초과인 승객 조회

select 
	*
from t_info
where Pclass = 2
or Fare > 50;

-- survived가 1인 승객 조회

select
	*
from survived
where survived = 1;

-- IN, LIKE, BETWEEN, IS NULL, IS NOT NULL

-- p_info 테이블에서 Sibsp 컬럼의 값이 1,2,3인 경우 조회

select 
	*
from p_info
where Sibsp in (1,2,3);

-- p_info 테이블에서 Sibsp 컬럼의 값이 0,1,2,3인 아닌 경우 조회

select
	*
from p_info
where Sibsp not in (0,1,2,3);

-- LIKE : 문자열 안에서 특정 단어를 포함한 행을 찾는 경우 사용

select
	*
from p_info
where Name like 'Rice%';

select
	*
from p_info
where Name like '%Eric';

select
	*
from p_info
where Name like '%Oscar%';


-- BETWEEN a and b : a 이상 b 이하인 경우 조회

select
	*
from p_info 
where Age between 20 and 40; -- where Age >=20 and Age <= 40

-- NULL, NOT NULL
-- p_info 테이블에서 age의 null 값 확인
select
	*
from p_info
where Age is null;

select
	*
from p_info
where Age is not null;

-- Fare가 100 이상 1000 이하이ㄴ 승객 조회
select
	*
from t_info
where Fare between 100 and 1000;

-- ticket이  PC로 시작하고 Embarked가 C 혹은 S인 승객 조회

select
	*
from t_info
where Ticket like 'PC%'
and Embarked in ('C','S');

-- Pclass가 1혹은 2인 승객 조회

select 
	*
from t_info
where Pclass in (1,2);

-- Cabin에 숫자 59 포함되는 경우 조회

select
	*
from t_info
where Cabin like '%59%';

-- Age가 NULL이 아니면서 이름에 James가 포함된 40세 이상의 남성을 조회

select
	*
from p_info
where Age is not null
and Name like '%James%'
and Age >= 40;

-- 데이터 순서 정렬
-- ORDER BY ~ ASC, DESC
-- SELECT * FROM 테이블명 WHERE 컬럼명 + 조건 ORDER BY 기준컬럼 ASC(오름차순) / DESC(내림차순)

-- Age가 NULL이 아니면서 이름에 Miss가 포함된 40세 이하의 여성을 나이 기준으로 내림차순 정렬
select 
	*
from p_info
where Age is not null
and Name like '%Miss%'
and Age <= 40 
and Sex = 'female'
order by Age desc;

desc p_info;

-- GROUP BY : 특정 컬럼을 기준으로 그룹 연산 수행 (평균, 최소값, 최대값, 행 갯수 등 집계 연산)
-- SELECT 기준 컬럼명, 그룹 연산 함수 FROM 테이블면 WHERE 컬럼명 GROUP BY 기준컬럼

-- p_info 테이블에서 나이가 NULL이 아닌 행의 성별별 나이 평균을 조회

select 
	Sex,
    avg(Age)
from p_info
where Age is not null
group by Sex;

-- HAVING : 그룹 연산 후의 결과에서 특정 조건을 충족하는 행을 찾는 경우
--  t_info 테이블에서 Pclass별 Fare 가격 평균을 구하고 그 중에서 가격 평균이 50 초과하는 결과만 조회

select 
	Pclass,
    avg(Fare) as avg_fare
from t_info
group by Pclass
having avg_fare < 50;
-- order by Pclass

-- JOIN : 여러 곳에 분산된 데이터 모아서 가져오기
--  INNER JOIN(교집합) : 왼쪽, 오른쪽에 있는 테이블에서 기준 컬럼의 값이 일치하는 것만 합침

select
	 *
from passenger
limit 3;

select
	*
from ticket
limit 3; 

-- SELECT * FROM 테이블명 INNER JOIN 테이블명2 on 테이블명.기준컬럼명 = 테이블명2.기준컬럼명;

select
	*
from passenger as p
join ticket as t on p.PassengerId = t.PassengerId; -- INNER JOIN은 INNER 생략 가능


-- LEFT JOIN
select
	*
from passenger as p
left join ticket as t on p.PassengerId = t.PassengerId;

-- RIGHT JOIN
select
	*
from passenger as p
right join ticket as t on p.PassengerId = t.PassengerId;

-- 두 개의 테이블을 조인하면서 Name, Age, Pclass, Fare 만 조회하는 경우
-- 컬럼명이 모호한 경우는 명확하게 변환

select
	p.PassengerId,
	Name, 
    Age,
    Pclass,
    Fare
from passenger as p
join ticket as t on p.PassengerId = t.PassengerId
order by p.PassengerId;

-- as ~ : 별칭 

select
	p.PassengerId,
	Name, 
    Age,
    Pclass,
    Fare
from passenger p
join ticket t on p.PassengerId = t.PassengerId
order by p.PassengerId;

-- 3개의 테이블을 하나로 합치기
-- 테이블1 + 테이블2 = 테이블12 + 테이블3 = 테이블123]
-- 데이터를 어떻게 합칠 것인지 사전에 명확한 기준에 따라 조회

select 
	*
from passenger p
join ticket t on p.PassengerId = t.PassengerId
join survived s on p.PassengerId = s.PassengerId;




