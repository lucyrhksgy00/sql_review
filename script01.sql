SeLeCT FiRSt_nAME FROM EMPLOYEES;

SELECT first_name FROM employees;

SELECT first_name, 
	last_name, 
	salary
FROM employees;

-- 주석, 해석하지 않는다
-- *은 모든(all)으로 해석한다
SELECT *
FROM employees;

-- 사원의 이름, 성, 봉급을 조회하되
-- 봉급 오름차순(낮은 사원들부터)으로 조회하기
SELECT first_name, last_name, salary
FROM employees 
ORDER BY salary ASC; -- ASC : 오름차순

SELECT first_name, last_name, salary
FROM employees 
ORDER BY salary DESC; -- DESC : 내림차순

SELECT first_name, last_name, salary
FROM employees 
ORDER BY salary; -- 생략시 오름차순

-- 조회하지 않더라도 정렬 가능
SELECT first_name
FROM employees 
ORDER BY salary;

-- 여러개의 컬럼으로 정렬하는 경우
-- 앞에부터 순서대로 적용
SELECT first_name, last_name, hire_date, salary
FROM employees 
ORDER BY hire_date ASC, salary DESC;

-- 컬럼 명 앞에 DISTINCT를 사용하면 중복값은 제외하여 조회
SELECT DISTINCT job_id
FROM employees;

-- 여러개의 컬럼을 복합적으로 생각하여 중복 제외한 후 가져옴
SELECT DISTINCT job_id, salary
FROM employees;

-- 별칭
SELECT first_name AS "이름",
	last_name "성", -- AS 생략가능
	salary AS 봉급, -- "" 생략가능
	employee_id 사원번호, -- 둘 다 생략
	email AS "AS" -- 별칭이 예약어이거나 띄어쓰기가 있다면 쌍따옴표 생략 불가
FROM employees;

-- 연결연산자
-- dual : 결과를 눈으로 확인할 때 사용할 수 있는 연습용 테이블
SELECT '안녕' || '반가워'
FROM dual;

SELECT first_name || '반가워'
FROM employees;

SELECT first_name || ' ',
	first_name || ' ' || last_name AS 성함
FROM employees;

-- 산술연산자(문자타입 값(문자타입 값이 있는 컬럼)은 산술연산 불가)
-- SELECT '안녕' + 10
-- FROM dual;

-- 날짜타입의 값은 덧셈 뺄셈만 가능, 기준 : 일 수
SELECT hire_date,
	hire_date + 10,
	hire_date - 10,
	hire_date + 30/24/60/60 -- 시간 분 초는 일로 환산
FROM employees;

SELECT salary,
	salary * 10
FROM employees;

-- 0으로 나눗셈 불가능
-- SELECT 10 / 0
-- FROM dual;

-- 행 골라내기
-- salary가 7000 이상인 행 골라내기
SELECT first_name, last_name, salary
FROM employees
WHERE salary >= 7000
ORDER BY salary;

-- 문자는 아스키코드에 해당하는 숫자 값으로 환산하여 적용된다
SELECT first_name
FROM employees 
WHERE first_name > 'E';

-- first_name이 David인 조건
SELECT first_name, last_name, salary
FROM employees 
WHERE first_name = 'David';

-- first_name이 David 이면서, salary >= 7000인 조건을 모두 만족하는 행
SELECT first_name, last_name, salary
FROM employees 
WHERE first_name = 'David' AND salary >= 7000;

SELECT first_name, last_name, salary
FROM employees 
WHERE first_name = 'David' OR salary >= 7000
ORDER BY salary;

-- SQL 연산자
SELECT first_name, last_name, salary
FROM employees 
WHERE first_name IN ('David', 'John', 'Danielle');

SELECT first_name, last_name, salary
FROM employees 
WHERE first_name = 'David'
OR first_name = 'John'
OR first_name = 'Danielle';

-- salary가 5000이상, 10000이하인 행들 골라내기
SELECT first_name, last_name, salary
FROM employees 
WHERE salary BETWEEN 5000 AND 10000;

SELECT first_name, last_name, salary
FROM employees 
WHERE salary >= 5000 AND salary <= 10000;

-- % : 문자가 없어도 되고, 몇개가 와도 상관없다
-- _ : 어떤 문자가 와도 되는데 한 자리만
SELECT first_name
FROM employees 
WHERE first_name LIKE '%h__';

SELECT salary
FROM employees 
WHERE salary LIKE '1%'; -- salary가 자동으로 문자타입으로 바껴서 '1%'와 비교

