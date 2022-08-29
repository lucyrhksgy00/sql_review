-- NULL값이 들어있는 행 골라내기
-- IS NULL
SELECT first_name, last_name, manager_id
FROM employees 
WHERE manager_id IS NULL; 

-- NULL값이 들어있지 않는 행 골라내기
-- IS NOT NULL
SELECT first_name, last_name, commission_pct
FROM employees 
WHERE commission_pct IS NOT NULL;

-- 문자타입함수
SELECT first_name,
	LOWER(first_name) AS "LOWER",
	UPPER(first_name) AS "UPPER"
FROM employees;

SELECT first_name
FROM employees 
WHERE upper(first_name) = upper('DaViD');   # 또는 'david' 아니면 'DAVID'

SELECT email,
	INITCAP(email) 
FROM employees;

-- SUBSTR(문자값, 시작숫자, 자를길이)
-- 해당 문자값을 시작숫자부터 길이만큼 잘라낸 문자가 결과로 나온다
SELECT first_name,
	SUBSTR(first_name, 2, 3)
FROM employees;

SELECT REPLACE('apple', 'x', 'd')
FROM dual;

SELECT first_name,
	LENGTH(first_name)
FROM employees;

-- 사원 email과, 사원 이름, 사원 성을 조회하고자 한다
-- 이때, email은 개인정보 보호를 위해 뒤에서 세자리를 ***로 표현하고자 한다
SELECT email,
	LENGTH(email),
	LENGTH(email) - 3,
	SUBSTR(email, 1, LENGTH(email) - 3),
	SUBSTR(email, 1, LENGTH(email) - 3) || '***'
FROM employees; -- REPLACE는 문자열만 받을 수 있어 이 경우에는 사용 불가

SELECT SUBSTR(email, 1, LENGTH(email) - 3) || '***' 이메일,
	first_name 이름, 
	last_name 성
FROM employees;

SELECT first_name, 
	last_name,
	CONCAT(first_name, last_name),
	CONCAT(CONCAT(first_name, ' '), last_name)
FROM employees;

SELECT first_name,
	INSTR(first_name, 'li')
FROM employees;

SELECT INSTR('apple', 'p'),
	INSTR('apaaaaple', 'p', 3) 
FROM dual;

-- first_name과 first_name에서 두번째 n이 등장하는 위치를 조회하되
-- n이 한개 또는 없는 직원은 제외하고 조회하기
SELECT first_name,
	INSTR(first_name, 'n', INSTR(first_name, 'n') + 1)
FROM employees
WHERE INSTR(first_name, 'n', INSTR(first_name, 'n') + 1) > 0;   # 또는 <> 0

SELECT LPAD('apple', 10, 'ab'),
	RPAD('apple', 10, '*'),
	LPAD('apple', 3, '*'),
	RPAD('apple', 3, '*') 
FROM dual;

SELECT LTRIM('     A B C     '), -- 제거할 문자 생략시 띄어쓰기
	LTRIM('aaabbbcccaaa', 'aa'),
	RTRIM('     A B C     '), -- 제거할 문자 생략시 띄어쓰기
	RTRIM('aaabbbcccaaa', 'aa'),
	TRIM('     A B C     '), -- TRIM은 양쪽 띄어쓰기만 제거 가능
	REPLACE('     A B C     ', ' ', '')
FROM dual;

-- 사원이름, 사원성을 띄어쓰기로 연결하여 성함 이라는 이름으로,
-- 사원 이메일은 앞의 두 글자만 떼어내어 출력하되 나머지는 *로 채워서
-- 출력하기
-- ABANDA --> AB****@koreait.com
-- DEFSSSDDD --> DE*******@koreait.com

SELECT first_name || ' ' || last_name AS 성함,
	RPAD(SUBSTR(email, 1, 2), LENGTH(email), '*') || '@koreait.com' AS 이메일
FROM employees;
	
-- 숫자타입함수
-- ROUND(숫자, 표현할자릿수)
SELECT ROUND(13.512, 2),
	ROUND(13.512, 1),
	ROUND(13.512, 0),
	ROUND(13.512), -- 정수로 반올림은 생략
	ROUND(13.512, -1)
FROM dual;

-- TRUNC(숫자, 자릿수) : 해당 숫자를 절삭하여 자릿수까지 표현, 자릿수 생략시 정수
SELECT TRUNC(13.512, 2),
	TRUNC(13.512)
FROM dual;

-- FLOOR(숫자) : 정수로 내림
-- CEIL(숫자) : 정수로 올림
SELECT FLOOR(13.512),
	CEIL(13.512)
FROM dual;

-- SIGN(숫자) : 양수면 1 음수면 -1 0이면 0
SELECT SIGN(-15),
	SIGN(20),
	SIGN(0)
FROM dual;

-- MOD(숫자, 나눌값) : 숫자를 값으로 나눴을 때 나머지
-- POWER(숫자, 거듭제곱할값) : 해당 숫자를 거듭제곱한 결과
-- SQRT(숫자) : 해당 숫자의 제곱근
SELECT MOD(10, 3),
	POWER(10, 3),
	SQRT(25)
FROM dual;

-- 사원번호가 짝수인 직원의 사원번호, 이름 조회하기
SELECT employee_id, first_name
FROM employees 
WHERE MOD(employee_id, 2) = 0
ORDER BY employee_id;

-- 날짜 타입 연산
-- 날짜 - 숫자 : 해당 날짜로부터 숫자일 만큼 이전 날짜
-- 날짜 + 숫자 : 해당 날짜로부터 숫자일 만큼 이후 날짜
-- 날짜 - 날짜 : 날짜 사이의 일수
-- 오늘 날짜를 받아오는 방법 : sysdate
SELECT sysdate 
FROM dual;

SELECT sysdate,
	hire_date,
	sysdate - hire_date
FROM employees;

SELECT sysdate,
	hire_date,
	(sysdate - hire_date) / 365,
	MONTHS_BETWEEN(sysdate, hire_date) / 12
FROM employees;

SELECT hire_date,
	ADD_MONTHS(hire_date, 3)
FROM employees;

-- NEXT_DAY(날짜, 값) : 돌아오는 요일이 결과로 나온다
-- 일 : 1, 월 : 2, 화 : 3, 수 : 4, 목 : 5, 금 : 6, 토 : 7
SELECT sysdate,
	NEXT_DAY(sysdate, 4)
FROM dual;






