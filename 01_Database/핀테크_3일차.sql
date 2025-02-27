use db_model_pratice;

select
	*
from buy_table;

-- world 백업 후 수행
drop database world;

-- Adiminstration -> data import/restore -> world 다시 불러와서 import 
-- 한국 환율과 주식 데이터셋 -> import 수행 -> DB 확인
show databases;

-- 주식 DB 확인
use korea_stock_info;
show tables;

-- 테이블 확인
select * from stock_company_info;
select * from stock_2024_all;
select * from 2024_08_stock_price_info;

use korea_exchange_rate;
select count(*) from exchange_rate;

-- 2020년 1월부터 12월까지 유로 조회
select 
	* 
from exchange_rate 
where date between '2020-01-01' and '2020-12-31'
and 통화 = '유로 EUR';

-- 2020년 1월 1일부터 12월 31일까지 데이터에서 통화별 현찰_살때_환율의 최소, 최대, 평균가 조회
select 
	통화,
    min(현찰_살때_환율) as 최소환율,
    max(현찰_살때_환율) as 최대환율,
    round(avg(현찰_살때_환율),2) as 평균환율 -- ROUND(값, 소수점 몇자리까지)
from exchange_rate 
where date between '2020-01-01' and '2020-12-31'
group by 통화
order by 통화;


use korea_stock_info;
show tables;

-- 7, 8,9월 나눠져 있는 데이터를 1개의 테이블로 모아서 생성
-- JOIN은 사용할 수 없음(중복되는 값이 너무 많음)
-- UNION을 사용하여 1개의 테이블로 모음

create table stock_2024_all as (
	select * from 2024_07_stock_price_info
	union all
	select * from 2024_08_stock_price_info
	union all
	select * from 2024_09_stock_price_info
);
-- CSV로 바로 저장

-- 생성된 테이블 데이터 확인
select
	*
from stock_2024_all;

###############################################################

-- SQL 함수
-- SELECT 함수(값) 

-- 절대값 : ABS()
select abs(-34), abs(1), abs(-256);

-- 문자열 길이 측정 : LENGTH(문자열)
-- 공백도 문자 1개로 취급
select length('my sql');

-- 반올림 함수 : ROUND(값, 소수점 자리)
select round(3.14567, 2);

-- 올림 함수 : CEIL()
select ceil(4.1);

-- 내림 함수 : FLOOR()
select floor(4.999);

-- 연산자를 통한 계산 : /, *, +, -, %
-- % : 나머지, div : 몫, mod : 나머지

select 7/2;
select 7*2;
select 7+2;
select 7-2;
select 7%2;
select 7 div 2;
select 7 mod 2;

-- 제곱, 루트, 음수/양수 확인
select power(4, 3);
select sqrt(3);
select sign(5), sign(-78);

-- truncate(값, 자릿수) : 버림
select round(2.2345, 3), truncate(2.2345, 3);
select round(1153.2345, -2), truncate(1153.2345, -2);

-- 문자열 함수 : char_length()
-- 문자의 길이를 알아보는 함수
-- 한글은 한글자가 3개의 memory 차지 -> 홍길동(9)
select char_length('my sql'), length('my sql');
select char_length('홍길동'), length('홍길동');


-- 문자를 연결하는 함수 : concat(), concat_ws()
-- 문장을 합치는 가운데 단어 앞뒤로 공백을 넣으면 공백이 표시
select concat('this',' is ','mysql') as concat1;
select concat('this',' is ','mysql') as concat1;
select concat('this', null, 'mysql') as concat1;
select concat_ws(':', 'this', 'is', 'mysql') as concat2;
select concat('this',' is ','mysql') as concat1, concat_ws(' ', 'this', 'is', 'mysql') as concat2;
select concat_ws(':', 'this', 'is', 'mysql') as concat2;


-- 대문자를 소문자로 lower()
-- 소문자를 대문자로 upper()
select lower('ABCD');
select upper('efgh');

-- 문자열 자릿수를 일정하게 하고 빈 공간을 지정한 문자로 채우는 함수
-- lpad(값, 자릿수, 채울문자), rpad(값, 자릿수, 채울문자)
select lpad('sql', 7, '#');
select lpad('sql', 7, ' ');
select lpad('sql', 7, '=');
select rpad('sql', 7, '#');
select rpad('sql', 7, ' ');
select rpad('sql', 7, '=');

-- 공백을 없애는 함수 : ltrim(문자열), rtrim(문자열)
select ltrim('    sql    ');
select rtrim('    sql    ');

-- trim() : 문자열의 공백을 앞뒤로 삭제
select trim('    sql    ');
select trim('    my sql    '); -- 문자 안에 있는 공백은 그대로 있음
select trim('    my sql study    ');

-- 문자열을 잘래내는 함수 left(문자열, 길이), right(문자열, 길이)
select left('this is my sql', 5), right('this is my sql', 5);
select left('이것이 mysql이다.', 4), right('이것이 mysql이다.', 4);

-- 문자열을 중간에서 잘라내는 함수 substr(문자열, 시작위치, 길이)
select substr('this is my sql', 6, 5);
select substr('this is my sql', 6);

-- 문자열 공백을 앞뒤로 삭제하고 문자열 앞뒤에 포함된 특정 문자도 삭제하는 함수
-- trim(leading '삭제할 문자' from, 전체 문자열) : 문자열 중 앞부분에 삭제할 문자 제거
-- tirm(trailing '삭제할 문자' from 전체 문자열) : 문자열 중 뒷부분에 삭제할 문자 제거
-- tirm(both '삭제할 문자' from 전체 문자열) : 문자열 전부에서 삭제할 문자 제거

select trim('    my sql    ');
select trim(leading '*' from '****my sql****');
select trim(trailing '*' from '****my sql****');
select trim(both '*' from '****my sql****');

-- 날짜형 함수
select curdate(), curtime(); -- 햔재 년월일 / 현재 시간
select now(); -- 현재 년월일 + 현재 시간
select current_timestamp(); -- 현재 년월일 + 현재 시간

-- 영문 요일 표시 함수 dayname(날짜)
select dayname(now());
select dayname('2025-01-01');

-- 요일을 번호로 표시
-- dayofweek(날짜) : 일(1), 월(2), 화(3), 수(4), 목(5), 금(6), 토(7)
select dayofweek(now());
select dayofweek('2025-05-05');

-- 1년 중 몇 번째 날인지 dayofyear()
select dayofyear(now());
select dayofyear('2025-05-08');

-- 날짜를 세분화 하여 보는 함수들
-- 현재 달의 마지막 날이 몇 일까지 있는지 출력
select last_day(now());
select last_day('2025-05-08');

-- 입력한 날자에서 연도, 월, 일만 출력
select year(now());
select year('2025-10-01');

select month(now());
select month('2025-10-01');
select monthname('2025-10-01'); -- 영문으로 월을 표시

select day(now());
select day('2025-10-01');

-- 몇 분기인지 출력
select quarter(now());
select quarter('2025-12-13');

-- 몇 주차인지 출력
select weekofyear(now());
select weekofyear('2025-12-13');

-- 날짜와 시간이 같이 있는 데이터에서 날짜와 시간을 구분해주는 함수
select now();
select date(now());
select time(now());

-- 날짜를 지정한 날 수 만큼 더하는 date_add(날짜, interval 더할 날 수 day)
select date_add(now() , interval 5 day);
select adddate(now() , 5);
select date_add(now() , interval 5 day);

-- 날짜를 지정한 날 수만큼 빼는 함수
-- subdate(날짜, interval 뺄 날 수 day)
select subdate(now(), interval 5 day);
select subdate(now(), 5);

-- 날짜와 시간을 년월, 날 시간, 분초 단위로 추출하는 함수
-- extract(옵션, from 날짜시간)
select extract(year_month from now());
select extract(day_hour from now());
select extract(minute_second from now());

-- 날짜 1에서 날짜 2를 뺀 일수 계산
-- datediff(날짜1, 날짜2)
select datediff(now(), '2024-12-25');
select datediff(now(), '2025-12-25');

-- 날짜 포멧 함수 -> 지정한 형식에 맞춰 출력해주는 함수
-- %Y : 4자리 연도, %y : 2자리 연도
-- %M : 월의 영문표기, %m : 2자리 월 표시, %b : 월의 축약 영문표기
-- %d : 2자리 일 표시, %e : 1자리 일 표시

select date_format(now(), '%Y-%m-%d');
select date_format(now(), '%d-%M-%y');
select date_format('2025-01-01', '%e-%M-%Y');
select date_format('2025-01-01', '%d-%m-%y');
select date_format('2025-01-01', '%d-%m-%Y');

-- 시간 표시
-- %H : 24시간, %h : 12시간, %p : AM, PM 표시
-- %i : 2자리 분 표시
-- %S : 2자리 초 표시
-- %T : 24시간 표기법 시:분:초
-- %r : 12시간 표기법 시:분:초 AM/PM
-- %W : 요일의 영문표기, %w : 숫자로 요일 표시
-- 일(1), 월(2), 화(3), 수(4), 목(5), 금(6), 토(7)

select date_format(now(), '%H-%i-%S');
select date_format(now(), '%p %h : %i : %S');
select date_format(now(), '%T');
select date_format(now(), '%r');
select date_format(now(), '%W %r');
select date_format('2025-02-25 14:23:54', '%w %r');


-- 위 연산들을 활용해 공부 
-- 실습 문제 풀이

use korea_stock_info;
show tables;

select * from stock_2024_all;


select
	date_format(수집일, '%d-%m-%y') as '2024_07',
    회사명,
    현재가,
    abs(변동금액) as '절대값_변동금액',
    거래량,
    거래대금
from stock_2024_all
where 수집일 = '2024-07-30'
and 현재가 <= 10000
order by abs(변동금액) desc, 거래량 desc, 거래대금 desc;






