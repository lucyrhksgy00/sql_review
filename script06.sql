-- departments 테이블에 새로운 행(레코드) 추가하기
INSERT INTO departments (department_id, department_name)
VALUES (300, '새로운부서');

-- 컬럼명을 생략하여 INSERT
INSERT INTO departments 
VALUES (310, '새로운부서2', NULL, NULL);

-- INSERT INTO departments 
-- VALUES (310, '새로운부서3', NULL, NULL);

-- UPDATE 
UPDATE departments 
SET location_id = 1700
WHERE department_name LIKE '새%';

SELECT * FROM departments;

UPDATE departments 
SET manager_id = 200, location_id = NULL 
WHERE department_name LIKE '새%';

-- DELETE 
DELETE FROM departments 
WHERE department_name LIKE '새%';

SELECT * FROM departments;
-----------------------------------------------------------------
-- 암시적 트랜잭션(마지막으로 commit된 이후부터 트랜잭션 시작)
INSERT INTO departments (department_id, department_name)
VALUES (310, 'test01');

INSERT INTO departments (department_id, department_name)
VALUES (320, 'test02');

SELECT * FROM departments;

COMMIT; -- 데이터베이스에 영구적으로 반영

ROLLBACK;

SELECT * FROM departments;

-- SAVEPOINT
INSERT INTO departments (department_id, department_name)
VALUES (330, 'test03');

SAVEPOINT s1;

INSERT INTO departments (department_id, department_name)
VALUES (340, 'test04');

SAVEPOINT s2;

INSERT INTO departments (department_id, department_name)
VALUES (350, 'test05');

SELECT * FROM departments;

ROLLBACK TO s1;
ROLLBACK; -- SAVEPOINT s1, s2도 사라짐


-- 두개의 테이블 생성
CREATE TABLE TBL_USER(
   user_id varchar2(30) NOT NULL PRIMARY KEY,
   user_pw varchar2(30) NOT NULL,
   user_gender char(1) NOT NULL,
   user_age number(3) NOT NULL,
   user_address varchar2(30),
   join_date DATE,
   grade varchar2(10) DEFAULT 'normal' NOT NULL
);
CREATE TABLE USER_ACCESS_DATE(
   user_id varchar2(30) PRIMARY KEY,
   last_access_date DATE DEFAULT sysdate NOT NULL,
   CONSTRAINT access_date_fk FOREIGN KEY(user_id)
   REFERENCES TBL_USER(user_id)
);

-- 회원정보
-- id : abc123
-- pw : 1234
-- 성별 : 'F'
-- 나이 : 20
-- 주소 : 서울시 역삼동
-- 회원가입일자 : 현재시각
-- grade : 'normal'
INSERT INTO tbl_user (user_id, user_pw, user_gender, user_age, user_address, join_date)
VALUES ('abc123', '1234', 'F', 20, '서울시 역삼동', sysdate);
SELECT * FROM tbl_user;
COMMIT;
-- 최근접속일 : 현재시각
INSERT INTO user_access_date (user_id)
VALUES ('abc123');
SELECT * FROM user_access_date uad;
COMMIT;

-- 회원정보
-- id : def123
-- pw: 5555
-- 성별 : 'M'
-- 나이 : 25
-- 회원가입일자 : 2020/5/15
-- grade : 'normal'
INSERT INTO TBL_USER
(USER_ID, USER_PW, USER_GENDER, USER_AGE, USER_ADDRESS, JOIN_DATE, GRADE)
VALUES('def123', '5555', 'M', 25, NULL, to_date('20200515', 'yyyymmdd'), 'normal');
SELECT * FROM tbl_user;
COMMIT;
-- 최근접속일 : 2020/6/1
INSERT INTO USER_ACCESS_DATE (USER_ID, LAST_ACCESS_DATE)
VALUES('def123', to_date('2020/06/01', 'yyyy/mm/dd'));
SELECT * FROM USER_ACCESS_DATE uad;
COMMIT;

-- 회원정보
-- id : aaa
-- pw : 0000
-- 성별 : 'F'
-- 나이 : 15
-- 주소지 미입력
-- 회원가입일자 : 2020/2/1
-- grade : 'normal'
INSERT INTO tbl_user (user_id, user_pw, user_gender, user_age, join_date)
VALUES ('aaa', '0000', 'F', 15, to_date('2020/02/01', 'yyyy/mm/dd'));
SELECT * FROM tbl_user;
COMMIT;
-- 최근접속일 : 2021/6/1
INSERT INTO USER_ACCESS_DATE (USER_ID, LAST_ACCESS_DATE)
VALUES('aaa', to_date('2021/06/01', 'yyyy/mm/dd'));
SELECT * FROM USER_ACCESS_DATE uad;
COMMIT;

-- 20년도에 회원가입한 회원등급을 vip로 승격하고자 한다
-- 테이블을 알맞게 갱신하여라
-- 정답 1
UPDATE tbl_user 
SET grade = 'vip'
WHERE to_char(join_date) LIKE '20%';
SELECT * FROM tbl_user;
ROLLBACK;

SELECT join_date 
FROM tbl_user
WHERE to_char(join_date) LIKE '20%';

SELECT join_date 
FROM tbl_user
WHERE to_char(join_date, 'yyyymmdd') LIKE '2020%';

-- 정답 2
UPDATE tbl_user 
SET grade = 'vip'
WHERE join_date >= to_date('20200101', 'yyyymmdd')
AND join_date < to_date('20210101', 'yyyymmdd');
SELECT * FROM tbl_user;
COMMIT;

-- 최근 접속일로부터 현재까지 12개월 이상 접속을 하지 않은 회원 정보를 삭제하라
-- 자식인 user_access_date부터 삭제
SELECT * 
FROM user_access_date 
WHERE MONTHS_BETWEEN(sysdate, last_access_date) >= 12;

DELETE user_access_date
WHERE MONTHS_BETWEEN(sysdate, last_access_date) >= 12;
SELECT * FROM user_access_date;

-- user_id가 user_access_date에 없는 행 삭제
DELETE tbl_user 
WHERE user_id NOT IN (
	SELECT user_id 
	FROM user_access_date
);
SELECT * FROM tbl_user;
COMMIT;


SELECT user_id 
FROM user_access_date;







