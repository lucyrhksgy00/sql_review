-- LAST_DAY(날짜타입) 월의 마지막 일을 계산
SELECT LAST_DAY(sysdate)
FROM dual;

-- ROUND(날짜, 'MONTH')
-- TRUNC(날짜, 'MONTH')
SELECT sysdate, 
	ROUND(sysdate),
	ROUND(sysdate, 'YEAR'),
	ROUND(sysdate, 'MONTH'),
	ROUND(sysdate, 'DAY'), -- 'DAY'는 요일
	ROUND(sysdate, 'DD') -- 'DD'는 일을 의미
FROM dual;

SELECT sysdate,
	TRUNC(sysdate),
	TRUNC(sysdate, 'YEAR'),
	TRUNC(sysdate, 'MONTH'),
	TRUNC(sysdate, 'DAY'),
	TRUNC(sysdate, 'DD')
FROM dual;

-- 모든 직원들은 입사한 후 월요일에 직원 교육을 받는다
-- 직원 이름, 교육일자, 입사한 후 며칠만에 교육을 받는지 조회하기
SELECT first_name 이름,
	hire_date 입사일,
	NEXT_DAY(hire_date, 2) 교육일자, 
	NEXT_DAY(hire_date, 2) - hire_date 비고
FROM employees;

-- 입사한 직원들의 이름과 올해 몇년차인지 연차를 조회하기
SELECT hire_date,
	sysdate,
	MONTHS_BETWEEN(sysdate, hire_date) 
FROM employees;

SELECT TRUNC(sysdate, 'YEAR'),
	TRUNC(hire_date, 'YEAR'),
	MONTHS_BETWEEN(TRUNC(sysdate, 'YEAR'), TRUNC(hire_date, 'YEAR')) / 12 + 1
FROM employees;

-- 변수 := 값
SELECT first_name 이름,
	MONTHS_BETWEEN(TRUNC(sysdate, 'YEAR'), TRUNC(hire_date, 'YEAR')) / 12 + 1 연차
FROM employees;

-- 문자 --> 숫자
SELECT TO_NUMBER('1500')
FROM dual;

-- 숫자형식의 문자만 숫자로 변경 가능하다
-- SELECT TO_NUMBER('안녕')
-- FROM dual;

-- 숫자 --> 문자
-- TO_CHAR(숫자)
SELECT TO_CHAR(salary)
FROM employees;

SELECT first_name, salary
FROM employees 
WHERE TO_CHAR(salary) LIKE '1%';

-- 타입이 다르더라도 연산이 가능하긴 하지만
-- 이는 자동으로 어느 한쪽의 타입을 바꾸고 있기 때문이다
-- 이를 자동 형변환 이라한다
-- 하지만 자동형변환은 내가 예상하지 못한 방향으로 이루어질 수 있고, 
-- 연산 속도에 영향을 미치기에 왠만하면 지양한다
SELECT salary
FROM employees 
WHERE salary > '10000';

SELECT '10' + '20'
FROM dual;

-- 숫자를 문자로 바꿀 때 형식 지정하기
-- 9 : 자릿수
-- 0 : 빈 공간을 0으로 채울지 여부
-- $ : $ 기호
-- L : 지역화폐
-- . : 소숫점위치
-- , : , 위치
SELECT TO_CHAR(123456789.55555, '$09,999,999,999.99')
FROM dual;

-- 사원 이름과, 사원의 봉급을 $12,000 형식으로 조회하기
SELECT first_name 이름,
	TRIM(TO_CHAR(salary, '$99,999')) 봉급
FROM employees;

-- 문자 --> 날짜
-- TO_DATE(문자값, 형식)
-- Y : 연도
-- M : 월
-- D : 일
-- DAY : 요일
-- HH : 시간(1~12)
-- HH24 : 시간(0~23)
-- MI : 분
-- SS : 초
-- AM or PM : 오전오후
SELECT TO_DATE('030102', 'YYMMDD'),
	TO_DATE('03-01/03', 'YY-MM/DD'),
	TO_DATE('030103', 'MMYYDD'),
	TO_DATE('1933 11 20 15:23', 'YYYY MM DD HH24:MI') 
FROM dual;

-- 날짜 --> 문자
SELECT TO_CHAR(sysdate, 'YY"년" MM"월" DD"일" DAY AM HH"시":MI"분":SS"초"')
FROM dual;
-------------------------------------------------------------------------
SELECT NVL(10, 2),
	NVL(NULL, 2)
FROM dual;

-- 직원의 봉급을 조회하되
-- commission을 받는 직원들은 커미션이 포함된 봉급을 조회하라
SELECT commission_pct,
	NVL(commission_pct, 0)
FROM employees;

SELECT first_name,
	salary + salary * NVL(commission_pct, 0)
FROM employees;

-- 10번 부서를 제외한 나머지 부서는 봉급을 10% 인상
SELECT department_id,
	salary,
	DECODE(department_id, 10, salary, salary * 1.1)
FROM employees
ORDER BY department_id;

SELECT department_id, salary,
	DECODE(department_id, 50, salary * 0.9, decode(department_id, 60, salary * 1.1, salary)) 월급인상조건
FROM employees
ORDER BY department_id;

SELECT department_id,
	employee_id,
	DECODE(department_id, 50, '확인', DECODE(employee_id, 120, '확인2', '확인3'))
FROM employees
ORDER BY department_id, employee_id;

SELECT department_id, salary,
	CASE department_id
		WHEN 50 THEN salary * 0.9
		WHEN 60 THEN salary * 1.1
		ELSE salary
	END 조정급여
FROM employees
ORDER BY department_id;

-- employee_id가 110 혹은 120 혹은 130인 직원은 0.9배
-- employee_id가 150이상 160이하는 1.1배
-- 나머지는 그대로

SELECT employee_id,
	salary,
	CASE 
		WHEN employee_id IN (110, 120, 130) THEN salary * 0.9
		WHEN employee_id BETWEEN 150 AND 160 THEN salary * 1.1
		ELSE salary
	END 조정급여
FROM employees 
ORDER BY employee_id;

-- 봉급을 기준으로 상위 중위 하위를 판단하고자 한다
-- 직원의 봉급이 10000이상이라면 상위
-- 3000 이상, 10000미만이라면 중위
-- 나머지는 하위로 표현하고자 한다
-- first_name, salary, 비고 컬럼을
-- salary 오름차순으로 조회하기
-- (비고 컬럼에는 상위 중위 하위 정보가 들어있다)
SELECT first_name 이름,
	salary 봉급,
	CASE 
		WHEN salary >= 10000 THEN '상위'
		WHEN salary >= 3000 AND salary < 10000 THEN '중위'
		ELSE '하위'
	END 비고
FROM employees 
ORDER BY salary;

SELECT first_name 이름,
	salary 봉급,
	CASE 
		WHEN salary >= 10000 THEN '상위'
		WHEN salary >= 3000 THEN '중위' -- 첫번째 조건이 거짓일 때 검사하기 때문에
		ELSE '하위'
	END 비고
FROM employees 
ORDER BY salary;

-- employee_id가 150 초과인 인원은 A팀
-- 140 초과 150 이하인 인원 B팀
-- 130 초과 140 이하인 인원 C팀
-- 나머지 : D팀
-- 단 이름이 대문자 D로 시작하는 인원은 employee_id와 관계없이 특별팀
-- 사원의 employee_id, first_name, 팀종류를 조회하시오
SELECT employee_id 사원번호,
	first_name 이름,
	CASE 
		WHEN first_name LIKE 'D%' THEN '특별팀'
		WHEN employee_id > 150 THEN 'A팀'
		WHEN employee_id > 140 THEN 'B팀'
		WHEN employee_id > 130 THEN 'C팀'
		ELSE 'D팀'
	END 팀종류
FROM employees 
ORDER BY employee_id;

-- 집계함수
-- 행의 갯수가 일치할 때만 사용 가능하다
SELECT SUM(salary),
	AVG(salary),
	COUNT(salary),
	MAX(salary),
	MIN(salary),
	STDDEV(salary) 
FROM employees;
	
-- NULL값
-- NULL값은 제외하고 적용된다
SELECT COUNT(commission_pct),
	SUM(commission_pct) 
FROM employees;

SELECT COUNT(first_name)
FROM employees;

-- 해당 테이블의 행(데이터, 레코드, 인스턴스, 튜플) 갯수
SELECT COUNT(*)
FROM employees;

-- 그룹화 하여 산출
-- GROUP_BY 절과 GROUP 함수
SELECT DISTINCT department_id
FROM employees;

SELECT department_id, hire_date, AVG(salary)	-- 4. department_id 컬럼, hire_date 컬럼, 평균 salary
FROM employees									-- 1. employees 테이블에서
WHERE employee_id > 150							-- 2. employee_id > 150 행을 골라내고
GROUP BY department_id, hire_date				-- 3. hire_date가 같은 순으로, 그 중에서도 department_id 별로 그룹화하여
ORDER BY department_id;							-- 5. department_id 오름차순으로 정렬하여 조회하겠다

SELECT department_id, hire_date,
	SUM(salary)
FROM employees 
WHERE employee_id > 150 AND department_id IS NOT NULL 
GROUP BY ROLLUP(department_id, hire_date)
ORDER BY department_id;

SELECT hire_date, department_id, SUM(salary)
FROM employees 
WHERE employee_id > 150 AND department_id IS NOT NULL 
GROUP BY ROLLUP(hire_date, department_id)
ORDER BY hire_date;

SELECT hire_date, department_id, SUM(salary)
FROM employees 
WHERE employee_id > 150 AND department_id IS NOT NULL 
GROUP BY CUBE(hire_date, department_id);