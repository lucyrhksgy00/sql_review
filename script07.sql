-- 테이블 생성
CREATE TABLE test01(
	a number(3, 2),
	b varchar2(1000),
	c char(100),
	d date
);

-- 컬럼 수준에서 제약조건 추가 
CREATE TABLE test02(
	student_id number(3) PRIMARY KEY,
	student_name varchar2(30) NOT NULL,
	student_gender char(1) CHECK (student_gender IN('F', 'M')) NOT NULL,
	student_age number(2) CHECK (student_age > 0),
	student_email varchar2(30) UNIQUE 
);

-- 테이블 수준에서 제약조건 추가
CREATE TABLE test03(
	student_id number(3),
	student_name varchar2(30) NOT NULL,
	student_gender char(1),
	student_age number(2),
	student_email varchar2(30),
	CONSTRAINT test03_pk PRIMARY KEY (student_id),
	-- CONSTRAINT test03_name_notnull NOT NULL (student_name) 
	-- NOT NULL은 테이블수준에서 추가 불가능 (또는 check 제약조건으로 IS NOT NULL 가능) 
	CONSTRAINT gender_check CHECK (student_gender IN ('F', 'M')),
	CONSTRAINT gender_notnull CHECK (student_gender IS NOT NULL),
	CONSTRAINT age_check CHECK (student_age > 0),
	CONSTRAINT email_unique UNIQUE (student_email)
);

-- 외래키 제약조건
CREATE TABLE test04(
	a number(3) PRIMARY KEY,
	b number(3) REFERENCES test03(student_id),
	c number(3),
	CONSTRAINT fk FOREIGN KEY (c) REFERENCES test03(student_id)
);

-- primary key, unique
CREATE TABLE test05(
	student_name varchar2(30),
	join_date DATE,
	contents varchar2(20),
	CONSTRAINT pk PRIMARY KEY (student_name, join_date),
	CONSTRAINT uni UNIQUE (contents, age)
);
-- 각각의 컬럼에 제약조건을 다는 것이 아니라
-- 두 개의 컬럼을 복합적으로 생각하여 제약조건을 다는 것

CREATE TABLE test06(
	a number(3) PRIMARY KEY, 
	b number(3) DEFAULT 10 NOT NULL UNIQUE 
	-- 제약조건들끼리 순서는 상관없는데 DEFAULT는 항상 맨 앞에 위치해야함
);

INSERT INTO test06 (a)
values (1);

SELECT * FROM test06;

-- SELECT문으로 테이블 만들기
CREATE TABLE emp_dup AS SELECT * FROM employees;

