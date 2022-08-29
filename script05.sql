-- 부서 이름과 관리자 이름
SELECT d.department_name, e.first_name 
FROM departments d, employees e 
WHERE d.manager_id = e.employee_id;

-- 부서 id가 30보다 큰 행들만 골라내서...
SELECT d.department_name, e.first_name 
FROM departments d, employees e 
WHERE d.manager_id = e.employee_id
AND d.department_id > 30;

-- ANSI 문법 (WHERE절 사용시 가독성을 생각하여 ANSI 문법 추천!)
SELECT d.department_name, e.first_name 
FROM departments d INNER JOIN employees e 
ON d.manager_id = e.employee_id;

SELECT d.department_name, e.first_name 
FROM departments d INNER JOIN employees e 
ON d.manager_id = e.employee_id
WHERE d.department_id > 30;
---------------------------------------------------------
-- 부서 이름과 관리자 이름
SELECT d.department_name, e.first_name 
FROM departments d, employees e 
WHERE d.manager_id = e.employee_id(+);

SELECT d.department_name, e.first_name 
FROM departments d, employees e 
WHERE d.manager_id(+) = e.employee_id;
---------------------------------------------------------
-- ANSI 외부조인
SELECT d.department_name, e.first_name 
FROM departments d LEFT OUTER JOIN employees e 
ON d.manager_id = e.employee_id;

SELECT d.department_name, e.first_name 
FROM departments d RIGHT OUTER JOIN employees e 
ON d.manager_id = e.employee_id; -- join의 전체 결과를 알고 싶다면 SELECT *

-- 사원 이름(employees), 부서명(departments), 부서의 city(locations)
SELECT e.first_name, d.department_name, l.city 
FROM employees e, departments d, locations l 
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id;

SELECT e.first_name, d.department_name, l.city 
FROM employees e 
INNER JOIN departments d
ON e.department_id = d.department_id 
INNER JOIN locations l 
ON d.location_id = l.location_id;

-- 자기 자신을 조인하는 경우 : 자체조인(self join)
-- 직원 이름과 직원을 관리하는 상사 이름
SELECT a.first_name, b.first_name 
FROM employees a, employees b 
WHERE a.manager_id = b.employee_id;
---------------------------------------------------------
-- 서브쿼리
-- 단일 행 서브쿼리
-- Joshua가 받는 봉급 이상을 받는 직원의 이름과 봉급 조회하기
SELECT salary
FROM employees 
WHERE first_name = 'Joshua';

SELECT first_name, salary 
FROM employees
WHERE salary >= (
	SELECT salary
	FROM employees 
	WHERE first_name = 'Joshua'
);

-- 다중 행 서브쿼리
-- David가 받는 봉급과 동일한 봉급을 받는 직원의 이름과 봉급 조회하기
SELECT first_name, salary 
FROM employees 
WHERE salary IN (
	SELECT salary 
	FROM employees 
	WHERE first_name = 'David'
);

-- 전체 직원 평균 봉급보다 많은 봉급을 받는 직원의 이름, 봉급을 조회하기
SELECT first_name, salary 
FROM employees 
WHERE salary > (
	SELECT AVG(salary)
	FROM employees 
)
ORDER BY salary;

-- IN (값, 값, 값, ...)
-- 관계연산자 ANY (값, 값, 값, ...)
-- ANY : 어느 하나라도 만족하는 행
SELECT first_name, salary 
FROM employees 
WHERE salary > ANY (
	SELECT salary 
	FROM employees 
	WHERE first_name = 'David'
)
ORDER BY salary;

-- ALL : 모든 조건을 만족하는 행
SELECT first_name, salary 
FROM employees 
WHERE salary > ALL (
	SELECT salary 
	FROM employees 
	WHERE first_name = 'David'
)
ORDER BY salary;

-- 다중 열 서브쿼리 (Oracle에서만 지원)
-- 부서 별 최소 봉급을 받는 이름과 봉급을 조회하기
SELECT first_name, salary 
FROM employees 
WHERE (department_id, salary) IN (
	SELECT department_id, MIN(salary)
	FROM employees 
	GROUP BY department_id
);

SELECT department_id, MIN(salary)
FROM employees 
GROUP BY department_id;

-- 집합연산자
-- UNION
SELECT department_id -- NULL, 10, 20, 30, ..., 110
FROM employees
UNION -- 중복 제외, 내부적으로 정렬
SELECT department_id -- 10, 20, 30, ..., 110, 120, 130, ..., 270
FROM departments;

-- UNION ALL 
SELECT department_id -- NULL, 10, 20, 30, ..., 110
FROM employees
UNION ALL -- 중복을 제외하지 않는다
SELECT department_id -- 10, 20, 30, ..., 110, 120, 130, ..., 270
FROM departments;

-- INTERSECT 
SELECT manager_id 
FROM departments
INTERSECT 
SELECT employee_id 
FROM employees;

-- MINUS : 차집합
SELECT manager_id 
FROM departments 
MINUS 
SELECT employee_id 
FROM employees;

SELECT employee_id 
FROM employees
MINUS
SELECT manager_id 
FROM departments;












