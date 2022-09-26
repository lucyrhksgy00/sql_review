CREATE TABLE 무한상사(
	사원명 varchar2(100),
	직급 varchar2(100),
	상사 varchar2(100),
	CONSTRAINT 무한상사pk PRIMARY KEY (사원명),
	CONSTRAINT 무한상사fk FOREIGN KEY (상사) REFERENCES 무한상사 (사원명)
);

DROP TABLE 무한상사;

INSERT INTO 무한상사 
VALUES ('김철수', '사장', NULL);

INSERT INTO 무한상사 
VALUES ('유재석', '부장', '김철수');

INSERT INTO 무한상사 
VALUES ('박명수', '과장', '유재석');

INSERT INTO 무한상사 
VALUES ('정준하', '과장', '유재석');

INSERT INTO 무한상사 
VALUES ('정형돈', '대리', '박명수');

INSERT INTO 무한상사 
VALUES ('노홍철', '사원', '정형돈');

INSERT INTO 무한상사 
VALUES ('하하', '사원', '정형돈');

INSERT INTO 무한상사 
VALUES ('길', '인턴', '하하');

SELECT * FROM 무한상사;

-- 계층형 쿼리
-- 부모 -> 자식 방향으로 (순방향)
SELECT * 
FROM 무한상사 
START WITH 사원명 = '박명수'
CONNECT BY PRIOR 사원명 = 상사;
		-- prior 부모 = 자식;

-- 자식 -> 부모 방향으로 (역방향)
SELECT * 
FROM 무한상사 
START WITH 사원명 = '박명수'
CONNECT BY PRIOR 상사 = 사원명;
	    -- prior 자식 = 부모;

-- 가장 위쪽 데이터부터 순방향 계층형 질의
SELECT *
FROM 무한상사 
WHERE 직급 IN ('사원', '과장')
START WITH 상사 IS NULL 
CONNECT BY PRIOR 사원명 = 상사
ORDER SIBLINGS BY 사원명 DESC;

SELECT 사원명, 
	SYS_CONNECT_BY_PATH(사원명, '->'),
	CONNECT_BY_ROOT(직급),
	LEVEL,
	CONNECT_BY_ISLEAF
FROM 무한상사
WHERE LEVEL <= 2 AND CONNECT_BY_ISLEAF = 1
START WITH 사원명 = '유재석' 
CONNECT BY PRIOR 사원명 = 상사;

INSERT INTO 무한상사
VALUES ('홍길동', '회장', '길');

UPDATE 무한상사 
SET 상사 = '홍길동'
WHERE 사원명 = '김철수';

SELECT 사원명,
	CONNECT_BY_ISCYCLE -- nocycle 키워드 반드시 필요
FROM 무한상사 
START WITH 사원명 = '정형돈'
CONNECT BY nocycle PRIOR 사원명 = 상사;

-- PROCEDURE 만들기
-- 무한상사 테이블에서 사원정보 삭제하기
UPDATE 무한상사 
SET 상사 = NULL 
WHERE 상사 = '김철수';

DELETE FROM 무한상사 
WHERE 사원명 = '김철수';

SELECT * FROM 무한상사;
ROLLBACK;

-- 사원을 삭제하는 프로시져 만들기
CREATE PROCEDURE delete_emp(v_name IN varchar2)
IS 
BEGIN 
	UPDATE 무한상사 
	SET 상사 = NULL 
	WHERE 상사 = v_name;
	DELETE FROM 무한상사 
	WHERE 사원명 = v_name;
END;

DROP PROCEDURE delete_emp;

SELECT * FROM 무한상사;

BEGIN 
	delete_emp('박명수');
END;

ROLLBACK;

-- employees 테이블에 직원을 추가하는 프로시져
CREATE PROCEDURE ins_emp(first_name IN varchar2)
IS 
	v_emp_id number(3)
BEGIN 
	SELECT max(employee_id) + 1
	INTO v_emp_id
	FROM employees;
	INSERT INTO employees 
	VALUES (v_emp_id, first_name, 'last', 'email', NULL, sysdate, 'SA_REP', NULL, NULL, NULL, NULL);
END;

BEGIN 
	ins_emp('배상엽');
END;

-- FUNCTION : 사용 결과가 값인 프로시져
SELECT upper('apple')
FROM dual;

CREATE FUNCTION get_salary(v_emp_id IN NUMBER)
IS 
	v_salary number(12)
BEGIN
	SELECT salary 
	INTO v_salary
	FROM employees
	WHERE employee_id = v_emp_id;
RETURN v_salary;
END;

DROP FUNCTION get_salary;

SELECT get_salary(101)
FROM dual;

CREATE FUNCTION test_f 
IS 
	v_test varchar2(100);
BEGIN 
	v_test := 'hello';
RETURN v_test;
END;

SELECT test_f()
FROM dual;





