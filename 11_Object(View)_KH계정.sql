/*
    VIEW : 가상의 테이블(RESULTSET) SELECT문을 이용해서 실제 테이블에서 데이터를 가져와서 사용
    VIEW ORALCE OBJECT로 DDL구문을 이용해서 생성, 수정, 삭제
    
    INLINE-VIEW : FROM절에 서브쿼리를 사용한 개념(다중열, 다중행 서브쿼리)
    STORED VIEW : 영구적으로 저장하고 사용하는 VIEW(서브쿼리를 저장시켜놓음)
*/
-- CREATE VIEW VIEW명칭 AS SELECT(서브쿼리)
CREATE VIEW V_EMPLOYEEALL AS
    SELECT
        *
    FROM
             EMPLOYEE
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
        JOIN JOB USING ( JOB_CODE );

-- VIEW를 생성하기 위해서는 권한을 부여해야함(RESOURCE안에 포함되지 않음)
-- 접속계정 변경(SYSTEM 관리자)

GRANT
    CREATE VIEW
TO KH;

-- VIEW FROM에서 테이블인것처럼 사용 가능.
SELECT
    *
FROM
    V_EMPLOYEEALL;

-- 데이터 딕셔너리를 통해 VIEW 확인
SELECT
    *
FROM
    USER_VIEWS;

SELECT
    *
FROM
    USER_TABLES;

CREATE OR REPLACE VIEW V_EMPLOYEE AS
    SELECT
        EMP_ID,
        EMP_NAME,
        DEPT_TITLE,
        SALARY,
        NATIONAL_NAME,
        JOB_NAME,
        BONUS
    FROM
        EMPLOYEE   E,
        DEPARTMENT D,
        LOCATION   L,
        NATIONAL   N,
        JOB        J
    WHERE
            E.DEPT_CODE = D.DEPT_ID
        AND D.LOCATION_ID = L.LOCAL_CODE
        AND L.NATIONAL_CODE = N.NATIONAL_CODE
        AND E.JOB_CODE = J.JOB_CODE;

SELECT
    *
FROM
    V_EMPLOYEE
WHERE
    NATIONAL_NAME = '한국';

-- VIEW 삭제
DROP VIEW V_EMPLOYEEALL;

SELECT
    *
FROM
    V_EMPLOYEEALL;

-- 뷰 특징
-- 1. 컬럼에대해 산술연산 및 함수의 실행결과를 포함할수 있다. 단, 반드시 별칭을 부여해야함.
CREATE VIEW V_EMP_SALARY AS
    SELECT
        EMP_NAME,
        ( SALARY + SALARY * NVL(BONUS, 0) ) * 12 연봉
    FROM
        EMPLOYEE;

SELECT
    *
FROM
    V_EMP_SALARY;

-- DECODE 함수를 이용해서 사원의 이름, 사번, 직업명, 남자인지 여자인지 성별정보, 근속년수를 VIEW로 저장
CREATE OR REPLACE VIEW V_EMP_JOB AS
    SELECT
        EMP_ID,
        EMP_NAME,
        JOB_NAME,
        DECODE(SUBSTR(EMP_NO, 8, 1),
               '1',
               '남자',
               '2',
               '여자')                                              AS 성별,
        EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS 근속년수
    FROM
             EMPLOYEE
        JOIN JOB USING ( JOB_CODE );

SELECT
    *
FROM
    V_EMP_JOB
WHERE
    근속년수 >= 20;
/*
    INSERT, UPDATE, DELETE 수행할때 -> 가능하긴한데 실제 테이블에 담겨있는 값이 변경됨.
    IF 내가 업데이트 하고자하는 칼럼이 가상칼럼이라면 DML이 불가능함.
*/

CREATE VIEW V_JOB AS
    SELECT
        *
    FROM
        JOB;

SELECT
    *
FROM
    V_JOB;

SELECT
    *
FROM
    JOB;

INSERT INTO V_JOB VALUES (
    'J8',
    '인턴'
);

UPDATE V_JOB
SET
    JOB_NAME = '신입'
WHERE
    JOB_CODE = 'J8';

/*
    DML문으로 조작이 불가능한경우
    1. 뷰에서 정의하고 있지 않은 칼럼을 조작하는 경우
    2. 뷰에 포함되지 않은 컬럼중 베이스가되는칼럼에 NOT NULL 제약조건이 설정되어 있을때
    3. 산순연산으로 구성된 칼럼(가상칼럼)
    4. 그룹합수, GROUP BY 절이 포함된 VIEW
    5. DISTINCT를 포함하고 있는경우
    6. JOIN을 통해 여러테이블을 연결하고 있는 경우
*/

-- VIEW 옵션들
-- 1. OR REPLACE 옵션. -> VIEW가 이미 존재한다면 현재 실행된 서브쿼리로 뷰를 바꿔주는 역할.

-- 2. FORCE/NOFORCE 옵션 : 실제테이블이 없어도 VIEW를 먼저 생성할수 있게 해주는 옵션.
CREATE FORCE VIEW V_FORCETEST AS
    SELECT
        *
    FROM
        TEST2;

SELECT
    *
FROM
    V_FORCETEST;

CREATE TABLE TEST2 (
    TEST NUMBER PRIMARY KEY
);

-- 3 WITH CHECK OPTION
-- SELECT문의 WHERE절에서 사용한 칼럼을 "수정하지 못하게" 하는 옵션.

CREATE OR REPLACE VIEW V_CHECKOPTION AS
    SELECT
        EMP_ID,
        EMP_NAME,
        SALARY,
        DEPT_CODE
    FROM
        EMPLOYEE
    WHERE
        DEPT_CODE = 'D5'
WITH CHECK OPTION;

SELECT
    *
FROM
    V_CHECKOPTION;

UPDATE V_CHECKOPTION
SET
    SALARY = 6000000
WHERE
    EMP_ID = 207; -- 업데이트 성공
UPDATE V_CHECKOPTION
SET
    DEPT_CODE = 'D7'
WHERE
    EMP_ID = 207; -- 업데이트 실패

ROLLBACK;

-- 4. WITH READ ONLY
-- VIEW 자체를 수정하지 못하게 차단하는 옵션.
CREATE OR REPLACE VIEW V_READONLY AS
    SELECT
        *
    FROM
        EMPLOYEE
WITH READ ONLY;

SELECT
    *
FROM
    V_READONLY;

UPDATE V_READONLY
SET
    EMP_NAME = '민경민';