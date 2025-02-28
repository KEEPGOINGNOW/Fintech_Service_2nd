-- VIEW 뷰 
-- select로 조회한 내용을 테이블을 만드는 것처럼  저장하는 것
-- 읽기 전용 -> Views에서 확인 가능
-- CREATE VIEW 뷰이름 AS SELECT문
-- DEOP VIEW 뷰이름

use korea_exchange_rate;

select 
	*
from exchange_rate;

-- 1997년 1월 1일부터 2001년 12월 31까지 환율변동 조회
select 
	*
from exchange_rate
where date between '1997-01-01' and '2001-12-31';
 
 -- MIN() 살때최저환율, MAX() 살때최고환율, AVG() 살때평균환율
 -- MAX() - MIN() : 살때환율변동량
 -- MIN() 팔때최저환율, MAX() 팔때최고환율, AVG() 팔때평균환율
 -- MAX() - MIN() : 팔때환율변동량
 
select 
	통화,
    min(현찰_살때_환율) 살때최저환율,
    max(현찰_살때_환율) 살때최고환율,
    round(avg(현찰_살때_환율),2) 살때평균환율,
    round(min(현찰_살때_환율) - max(현찰_살때_환율),2) 살때환율변동량,
    min(현찰_팔때_환율) 팔때최저환율,
    max(현찰_팔때_환율) 팔때최고환율,
    round(avg(현찰_팔때_환율),2) 팔때평균환율,
    round(min(현찰_팔때_환율) - max(현찰_팔때_환율),2) 팔때환율변동량
from exchange_rate
where date between '1997-01-01' and '2001-12-31'
group by 통화;


-- 뷰 생성
create view exchange_rate_1997_2001 as (
	select 
		통화,
		min(현찰_살때_환율) 살때최저환율,
		max(현찰_살때_환율) 살때최고환율,
		round(avg(현찰_살때_환율),2) 살때평균환율,
		round(min(현찰_살때_환율) - max(현찰_살때_환율),2) 살때환율변동량,
		min(현찰_팔때_환율) 팔때최저환율,
		max(현찰_팔때_환율) 팔때최고환율,
		round(avg(현찰_팔때_환율),2) 팔때평균환율,
		round(min(현찰_팔때_환율) - max(현찰_팔때_환율),2) 팔때환율변동량
	from exchange_rate
	where date between '1997-01-01' and '2001-12-31'
	group by 통화
);

-- 생성된 뷰 확인

select * from exchange_rate_1997_2001
where 통화 = '미국 USD';

-- VIEW에서는 UPDATE 수행이 되지 않음
update exchange_rate_1997_2001 set 통화 = '미국' where 살떄최조환율 = 855.3;

























