-- department_id 별 소계, hire_date 별 소계
SELECT department_id, hire_date, SUM(salary)
FROM employees
GROUP BY GROUPING SETS(department_id, hire_date);

-- GROUPING SETS() 함수는 괄화로 묶어서 새로운 집합으로 생각할 수 있다
-- department_id별, job_id가 같은 사람들끼리의 소계 혹은 hire_date별 소계
SELECT department_id, job_id, hire_date, SUM(salary)
FROM employees 
GROUP BY GROUPING SETS((department_id, job_id), hire_date);

SELECT department_id, 
	job_id, 
	SUM(salary), 
	GROUPING(department_id),
	DECODE(GROUPING(department_id), 1, '모든부서', department_id),
	GROUPING(job_id),
	DECODE(GROUPING(job_id), 1, '모든직책', job_id)
FROM employees 
GROUP BY ROLLUP(department_id, job_id);

SELECT DECODE(GROUPING(department_id), 1, '모든부서', department_id),
	DECODE(GROUPING(job_id), 1, '모든직책', job_id),
	SUM(salary) 
FROM employees 
GROUP BY ROLLUP(department_id, job_id);
-----------------------------------------------------------------------
-- WHERE 절 자리에는 그룹함수를 사용할 수 없다
-- HAVING 절을 사용하여 그룹함수 조건을 적용시킬 수 있다
SELECT department_id, SUM(salary)	--> 5
FROM employees						--> 1
WHERE employee_id > 150				--> 2
GROUP BY department_id				--> 3
HAVING SUM(salary) > 30000 			--> 4
ORDER BY department_id;				--> 6

-- 윈도우 함수
-- 전체 직원의 이름과 월급, 월급 순위
-- 순위함수에는 ORDER BY는 꼭 있어야 한다
SELECT first_name 이름,
	salary 월급,
	RANK() OVER (ORDER BY salary DESC), -- 중복된 순위 이후 건너뜀
	DENSE_RANK() OVER (ORDER BY salary DESC), -- 중복된 순위 이후 건너뛰지 않음
	ROW_NUMBER() OVER (ORDER BY salary DESC) -- 순위자체가 중복되지 않음
FROM employees;

SELECT first_name, salary,
	ROW_NUMBER() OVER (ORDER BY salary DESC, first_name ASC)
FROM employees;

-- 부서별 봉급 많이 받는 순위
SELECT first_name, department_id, salary,
	RANK() OVER (PARTITION BY department_id ORDER BY salary DESC)
FROM employees;

SELECT SUM(salary)
FROM employees;

SELECT first_name, salary,
	SUM(salary) OVER ()
FROM employees;

SELECT first_name, department_id, salary,
	SUM(salary) OVER (PARTITION BY department_id),
	salary / SUM(salary) OVER (PARTITION BY department_id) * 100
FROM employees;

SELECT first_name, department_id, salary,
	FIRST_VALUE(first_name) OVER (PARTITION BY department_id ORDER BY salary) "first_value",
	LAST_VALUE(first_name) OVER (PARTITION BY department_id 
								ORDER BY salary
								RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
								"last_value",
	LAG(first_name) OVER (PARTITION BY department_id ORDER BY salary) "lag",
	LEAD(first_name) OVER (PARTITION BY department_id ORDER BY salary) "lead"
FROM employees;

SELECT first_name, department_id, salary,
	TO_CHAR(ROUND(RATIO_TO_REPORT(salary) OVER (PARTITION BY department_id), 3) * 100) || '%'
FROM employees;

SELECT first_name,
	RANK() OVER (ORDER BY salary) "rank",
	CUME_DIST() OVER (ORDER BY salary) "cume_dist",
	PERCENT_RANK() OVER (ORDER BY salary) "percent_rank"
FROM employees;

SELECT first_name, salary, 
	NTILE(3) OVER (ORDER BY salary)	
FROM employees;

SELECT first_name, department_id, salary,
	NTILE(3) OVER (PARTITION BY department_id ORDER BY salary)
FROM employees;
-----------------------------------------------------------------------
-- 사원의 이름과 해당사원이 근무하는 부서의 이름
SELECT *
FROM employees a, departments b 
WHERE a.department_id = b.department_id;

SELECT *
FROM departments a, employees b
WHERE a.department_id = b.department_id;

SELECT *
FROM departments a, employees b
WHERE b.department_id = a.department_id;

SELECT a.first_name, b.department_name
FROM employees a, departments b 
WHERE a.department_id = b.department_id;

-- 중심이 되는 테이블을 앞쪽에 기술
SELECT e.first_name, e.department_id, d.department_name
FROM EMPLOYEES e, DEPARTMENTS d 
WHERE e.department_id = d.department_id;








