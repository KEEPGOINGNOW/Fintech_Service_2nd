-- 데이터베이스, 테이블 생성

-- 데이터베이스 생성
create database sampleDB;

-- 데이터베이스 제거
drop database sampleDB;

-- 데이터베이스 조회
show databases;

-- 테이블 생성
-- 각 데이터 타입 확인

use sampleDB;

-- 제약 조건 없이 테이블 생성
create table customers (
	id int,
    name varchar(100),
    sex varchar(20),
    phone varchar(20),
    address varchar(255)
);

-- 테이블 조회
select * from customers;

-- 테이블 삭제
drop table customers;

-- market_db 생성
create database market_db;
use market_db;

-- hongonh1 테이블 생성
-- toy_id(int), toy_name(char(4)), age(int)
create table hongong1 (
	toy_id int,
    toy_name char(4),
    age int
);

-- 테이블 생성 확인
show tables;

-- 테이블 조회
-- 원하는 형식으로 만들어졌는지 확인
desc hongong1;

-- 생성한 테이블에 데이터 입력
-- insert into 테이블명(컬럼1, 컬럼2, ...) values (컬럼1의 값, 컬럼2의 값,...)
insert into hongong1 values(1, '우디', 25);

-- 입력되지 않은 컬럼의 값은 NULL 입력됨
insert into hongong1(toy_id, toy_name) values(2, '버즈');

-- 컬럼에 맞춰 데이터를 입력한다면 정확히 값이 입력됨
insert into hongong1(toy_name, age, toy_id) values('제시', 20, 3);

-- 그대로 입력
insert into hongong1 values(4, '포테이토', 40);

-- 테이블의 데이터 조회
select * from hongong1;

-- PK, auto increment 기능을 추가한 테이블 생성
create table hongong2 (
	toy_id int auto_increment primary key,
    toy_name char(4),
    age int
);

desc hongong2;

-- AUTO INCREMENT가 지정된 테이블에 데이터 입력
insert into hongong2 values(null, '보핍', 25);
insert into hongong2 values(null, '슬링키', 22);
insert into hongong2 values(null, '렉스', 21);

-- 데이터 조회
select * from hongong2;

-- ALTER : 테이블 수정하기

-- 컬럼 추가
-- ALTER TABLE 테이블명 ADD COLUMN 컬럼명, 자료형, 속성(NOT NULL, UNIQUE) 
-- hongong2 테이블에 country 컬럼 추가 -> 전에 입력된 값들은 NULL값이 들어감
alter table hongong2 add column country varchar(100);

-- 기존 테이블에 있는 자료 UPDATE + where과 함께 사용 
-- UPDATE 테이블명 SET 컬럼명 = 업데이트할 값 WHERE toy_id = 1;
update hongong2 set country = '미국' where toy_id = 1;
update hongong2 set age = 30 where toy_id = 1;
 
-- 데이터 조회
select * from hongong2;

-- TRUNCATE : 테이블의 내용은 전부 지우고 테이블의 구조는 남기고 싶은 경우 
truncate table hongong2;

-- 테이블의 데이터 삭제
-- DELETE FROM 테이블명 WHERE 조건
-- PK가 따로 지정되어 있지 않기 때문에 오류 발생
delete from hongong1 where toy_id = 2;

-- idx 컬럼추가 primary key로 지정 auto_increment
alter table hongong1 add column idx int auto_increment Primary key;
select * from hongong1;

-- 데이터 삭제 수행
delete from hongong1 where idx = 2;

-- 데이터 추가
insert into hongong1 values(7, '렉스', 30, null);
delete from hongong1 where idx = 4;

-- CREATE, INSERT INTO, UPDATE, DELETE => CRUD

-- member 테이블 생성
drop table if exists member;
create table member (
	id int auto_increment primary key,
    member_id varchar(5) not null,
    name varchar(20) not null,
    address varchar(225)
);

-- member 테이블 데이터 입력 및 확인
desc member;

-- insert into member values(null,'tess','나훈아','경기 부천시 중동');
-- insert into member values(null,'hero','임영웅','서울 은평구 증산동');
-- insert into member values(null,'iyou','아이유','인천 남구 주안동');
-- insert into member values(null,'jyp','박진영','경기 고양시 장항동');

select * from member;

-- product 테이블 생성
drop table if exists product;
create table product (
	prod_name varchar(20) not null,
	price int,
    date_of_prod date not null,
    manuf varchar(50),
    balance int
);

-- product 테이블 확인
desc product;

-- insert into product values('바나나',1500,'2024-07-01','델몬트',17);
-- insert into product values('카스',2500,'2023-12-12','OB',3);
-- insert into product values('삼각김밥',1000,'2025-02-26','CJ',22);

-- product 테이블에 prod_id 컬럼 추가 + auto_increment, primary key 적용
alter table product add column prod_id int auto_increment primary key;

-- product 테이블 확인
select * from product;

-- name이 NULL 허용으로 변환
insert into member values(null, 'akmu', '악동뮤지션', null);
select * from member;

-- 트랜젝션과 rollback
-- 데이터베이스 생성
create database mywork;
use mywork;

-- 테이블 생성
drop table if exists emp_test;
create table emp_test (
	emp_no int not null,
    emp_name varchar(30) not null,
    hire_date date null,
    salary int null,
    primary key(emp_no)
);

-- emp_test 테이블 확인
desc emp_test;

-- 데이터 입력
-- insert into emp_test(emp_no, emp_name, hire_date, salary) 
-- values (1005, '쿼리', '2021-03-01',4000),
-- (1006, '호킹', '2021-03-05',5000), 
-- (1007, '페러데이', '2021-04-01',2200), 
-- (1008, '맥스웰', '2021-04-04',3300),
-- (1009, '플랑크', '2021-04-05',4400);

select * from emp_test;

--  UPDATE 연습
-- 호킹의 SALARY를 10000으로 변경
-- update emp_test set salary = 10000 where emp_name = '호킹';
update emp_test set salary = 10000 where emp_no = 1006;

-- 페러데이의 hire_date를 2023-07-11로 변경
update emp_test set hire_date = '2023-07-11' where emp_no = 1007;

-- 플랑크가 있는 데이터 제거
delete from emp_test where emp_no = 1009;
delete from emp_test where emp_no = 1013;

-- 오토커밋 옵션 활성화 확인
-- edit -> Perfences -> SQL editor -> SQL Execution -> Auto commit
select @@autocommit; -- 결과가 1인 경우 오토커밋 활성화
set autocommit = 1; -- 0으로 설정 가능
select @@autocommit;

create table emp_tran1 as select * from emp_test;
select * from emp_tran1;
desc emp_tran1; -- Primart Key 설정이 되어있지 않음
desc emp_test;

alter table emp_tran1 add constraint primary key(emp_no);
desc emp_tran1; -- Primary Key 설정됨

-- 데이터 입력
insert into emp_tran1 values (1011, '플랑크4', '2024-04-05', 5000);
select * from emp_tran1;

rollback; -- Rollback 되지 않음 : 다시 공부해보기 -> AUTO_COMMIT = 1 이어서 그런 거 같음



















