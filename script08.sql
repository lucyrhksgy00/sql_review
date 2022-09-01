CREATE TABLE alter_test(
	a number(3),
	CONSTRAINT alter_test_pk PRIMARY KEY (a)
);

-- 컬럼 추가
ALTER TABLE alter_test 
ADD b varchar2(30) DEFAULT 'normal' NOT NULL;

-- 제약조건 추가
ALTER TABLE alter_test 
ADD CONSTRAINT alter_test_ck CHECK (b IN ('normal', 'vip'));

-- 컬럼 수정
ALTER TABLE alter_test 
MODIFY a varchar2(30);

-- 기존 제약조건은 유지가 된다
--ALTER TABLE alter_test 
--MODIFY b number(3); -- NOT NULL과 CHECK 제약조건이 걸려있기 때문에 데이터 타입 변경 불가

-- 컬럼삭제
-- 컬럼과 관련된 제약조건들도 모두 삭제
ALTER TABLE alter_test 
DROP COLUMN b;

-- 제약조건 삭제
ALTER TABLE alter_test 
DROP CONSTRAINT alter_test_pk;

-- 컬럼명 수정
ALTER TABLE alter_test 
RENAME COLUMN a TO id;

-- 테이블명 수정
ALTER TABLE alter_test 
RENAME TO alter_test_modified;

-- 제약조건 이름 변경 (잘 사용하지 않음)
ALTER TABLE alter_test_modified 
ADD CONSTRAINT atm_pk PRIMARY KEY (id);

ALTER TABLE alter_test_modified 
RENAME CONSTRAINT atm_pk TO atm_pk2;

-- USER_CONSTRAINTS : 만들어 놓은 제약조건을 담아놓은 뷰(가상테이블)
SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = 'ALTER_TEST_MODIFIED';

-- 제약조건 비활성화
ALTER TABLE alter_test_modified 
disable CONSTRAINT atm_pk2;

-- 제약조건 활성화
ALTER TABLE alter_test_modified 
enable CONSTRAINT atm_pk2;

INSERT INTO alter_test_modified 
VALUES ('test03');

SELECT * FROM alter_test_modified;

-- 데이터만 모두 삭제
TRUNCATE TABLE alter_test_modified;

-- 테이블 삭제
DROP TABLE alter_test_modified;

-- 테이블 생성 시 외래키를 제공하는 부모를 먼저 생성
-- 학과 테이블
CREATE TABLE 학과(
	학과명 varchar2(30),
	등록금 number(30),
	CONSTRAINT 학과_pk PRIMARY KEY (학과명)
);

-- 외래키를 제공받는 자식을 생성
-- 학생 정보 테이블
CREATE TABLE 학생정보(
	학번 number(7),
	이름 varchar2(30) NOT NULL,
	학과 varchar2(30),
	CONSTRAINT 학생정보_pk PRIMARY KEY (학번),
	CONSTRAINT 학생정보_fk FOREIGN KEY (학과) REFERENCES 학과 (학과명)
);

-- 삭제
--DROP TABLE 학과;
-- 자식인 학생정보 테이블에서 '학과' 컬럼을 사용 중이니 부모 테이블인 학과 테이블 삭제 불가
-- 자식 테이블을 먼저 삭제한 후 부모 테이블 삭제
-- 1. 자식 테이블 삭제
DROP TABLE 학생정보;
-- 2. 부모 테이블 삭제
DROP TABLE 학과;

-- Oracle에서만 사용 가능한 기능
-- 학과를 삭제하긴 할건데, 학과테이블을 참조하고 있는(외래키로 제공 받는) 테이블의 
-- foreign key 제약조건도 함계 삭제 
DROP TABLE 학과 CASCADE CONSTRAINT;


-- hr 계정에서 guest 계정에 권한 부여
GRANT SELECT ON employees TO guest;
-- 여러 개의 권한도 ,로 이어서 부여 가능
GRANT DELETE, INSERT ON employees TO guest;

-- 권한을 부여한(만든) 사용자 입장에서 확인하기
SELECT * FROM user_tab_privs_made;

-- 권한 회수
REVOKE SELECT, DELETE, INSERT ON employees FROM guest;




