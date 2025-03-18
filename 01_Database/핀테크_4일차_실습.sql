-- 실습과제 지문

-- ERD -> school_db생성 -> db 확인
show databases;

-- school_db 사용
use school_db;

-- 바르게 정의된 univ_db 사용
use univ_db;

-- 학과 데이터 생성
-- insert into department values(1,'수학');
-- insert into department values(2,'국문학');
-- insert into department values(3,'정보통신공학');
-- insert into department values(4,'모바일공학');

-- 학과 테이블 확인
select * from department;
desc department;

-- 학생 데이터 생성
-- insert into student values (1, '가길동', 177,1);
-- insert into student values (2, '나길동', 178,1);
-- insert into student values (3, '다길동', 179,1);
-- insert into student values (4, '라길동', 180,2);
-- insert into student values (5, '마길동', 170,2);
-- insert into student values (6, '바길동', 172,3);
-- insert into student values (7, '사길동', 166,4);
-- insert into student values (8, '아길동', 192,4);

-- 학생 테이블 확인
select * from student;


-- 교수 데이터 생성
-- insert into professor values (1, '가교수', 1);
-- insert into professor values (2, '나교수', 2);
-- insert into professor values (3, '다교수', 3);
-- insert into professor values (4, '빌게이츠', 4);
-- insert into professor values (5,'스티브잡스', 3);

-- 교수 테이블 확인
select * from professor;
desc professor;

-- 개설과목 데이터 생성
-- insert into course values (1,'교양영어',1,'2016/09/02','2016/11/30');
-- insert into course values (2,'데이터베이스 입문',3,'2016/08/20','2016/10/30');
-- insert into course values (3,'회로이론',2,'2016/10/20','2016/12/30');
-- insert into course values (4,'공업수학',4,'2016/11/02','2017/01/28');
-- insert into course values (5,'객체지향프로그래밍',3,'2016/11/01','2017/01/30');

-- 개설과목 테이블 확인
select * from course;



-- 수강 데이터 생성
-- insert into student_course values(1,1);
-- insert into student_course values(2,1);
-- insert into student_course values(3,2);
-- insert into student_course values(4,3);
-- insert into student_course values(5,4);
-- insert into student_course values(6,5);
-- insert into student_course values(7,5);

-- 수강 테이블 확인
select * from student_course;


-- 문제1 : 학생번호, 학생명, 학과번호, 학과명 정보 조회
select 
	student_id,
    student_name,
    height,
    s.department_id,
    department_name
from student s -- 기준이 되는 테이블을 왼쪽에 두기(대부분 데이터가 많음)
join department d on s.department_id = d.department_id;


-- 문제2 : 가교수의 교수아이디 조회
select
	professor_id
from professor
where professor_name = '가교수';


-- 문제3 : 학과이름별 교수의 수를 조회
select
	department_name,
    count(professor_id)
from department d
join professor p on d.department_id = p.department_id
group by department_name;

-- 다른 풀이
select 
	department_name,
    count(professor_id)
from professor p 
left join department d on p.department_id = d.department_id
group by department_name;



-- 문제4 : '정보통신공학'과의 학생정보 조회
select 
	student_id,
    student_name,
    height,
    s.department_id,
    department_name
from student s
join department d on s.department_id = d.department_id
where department_name = '정보통신공학';

-- 다른 풀이
select 
	student_id,
    student_name,
    height,
    s.department_id,
    department_name
from student s
left join department d on s.department_id = d.department_id
where department_name = '정보통신공학';


-- 문제5 : '정보통신공학'과의 교수명을 조회
select 
	professor_id,
    professor_name,
    p.department_id,
    department_name
from professor p
join department d on p.department_id = d.department_id
where department_name = '정보통신공학';

-- 다른 풀이
select 
	professor_id,
    professor_name,
    p.department_id
    department_name
from professor p
left join department d on p.department_id = d.department_id
where department_name = '정보통신공학';


-- 문제6 : 학생 중 성이 '아'인 학생이 속한 학과명과 학생명을 조회
select 
	student_name,
    department_name
from student s
join department d on s.department_id = d.department_id
where student_name like '아%';

-- 다른 풀이
select 
	student_name,
    department_name
from student s
left join department d on s.department_id = d.department_id
where student_name like '아%';


-- 문제7 : 키가 180~190 사이에 속하는 학생의 수 조회
select
	count(student_id) -- count(*)
from student
where height between 180 and 190;


-- 문제8 : 학과이름별 키의 최고값, 평균값 조회
select
	department_name,
    max(height),
    round(avg(height))
from department d
join student s on d.department_id = s.department_id
group by department_name;

-- 다른 풀이
select
	department_name,
    max(height),
    round(avg(height))
from department d
left join student s on d.department_id = s.department_id
group by department_name;

-- 문제9 : '다길동' 학생과 같은 학과에 속한 학생의 이름 조회
-- 서브쿼리 활용
select 
	student_name
from student
where department_id in (select department_id from student where student_name='다길동');
-- where department_id = (select department_id from student where student_name='다길동')



-- 문제10 : 2016년 11월에 시작하는 과목을 수강하는 학생의 이름과 수강과목 조회
select 
	student_name,
    course_name
from student s
join professor p on s.department_id = p.department_id
join course c on p.professor_id = c.professor_id
where date_format(start_date, '%Y-%m') = '2016-11';
-- 다르게 나온 이유는 Professor 테이블 활용하여 답이 이상하게 나옴

-- 다른 풀이
select 
	student_name,
    course_name
from student s
left join student_course sc on s.student_id = sc.student_id
left join course c on sc.course_id = c.course_id
where date_format(start_date, '%Y-%m') = '2016-11';


-- 문제11 : '데이터베이스 입문' 과목을 수강신청한 학생의 이름 조회
select 
	student_name
from student s
join professor p on s.department_id = p.department_id
join course c on p.professor_id = c.professor_id
where course_name = '데이터베이스 입문';
-- 답이 이상하게 나온 이유 : student_course 테이블 활용하기 않음

-- 다른 풀이
select 
	student_name
from student s
left join student_course sc on s.student_id = sc.student_id
left join course c on sc.course_id = c.course_id
where course_name = '데이터베이스 입문';



-- 문제12 : '빌게이츠' 교수의 과목을 수강신청한 학생 수 조회
select 
	count(student_id)
from student s
join professor p on s.department_id = p.department_id
join course c on p.professor_id = c.professor_id
where professor_name = '빌게이츠';
-- 답이 이상하게 나온 이유 : student_course 테이블 활용하기 않음

-- 다른 풀이
select 
	count(s.student_id)
from student s
left join student_course sc on s.student_id = sc.student_id
left join course c on sc.course_id = c.course_id
left join professor p on c.professor_id = p.professor_id
where professor_name = '빌게이츠';

-- 서브 쿼리 사용
select 
	count(s.student_id)
from student s
left join student_course sc on s.student_id = sc.student_id
where course_id in (
select 
	course_id
from course c
left join professor p on c.professor_id = p.professor_id
where professor_name = '빌게이츠');








