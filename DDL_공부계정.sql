-- DML : 데이터 조작, SELECT(DQL), INSERT, UPDATA, DELETE
-- DDL : 데이터 정의, CREATE, ALETER, DROP
-- TCL : 트랜잭션 제어, COMMIT, ROLLBACK
-- DCL : 권한부여, GRANT, REVOKE

/*

    <SELECT>
    데이터를 조회하거나 검색할 때 사용하는 명령어
    - RESULT SET : SELECT 구문을 통해 조회된 데이터의 결과물을 의미
                    즉, 조회된 행들의 집합
                    
    [표현법]
    SELECT 조회하고자 하는 컬럼명, 컬럼명2, 컬럼명3, ...
    FROM 테이블명;

*/
-- EMPLOYEE 테이블의 전체 사원들의 사번, 이름, 급여 칼럼만을 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

-- EMPLYOEE 테이블에서 전체 사원들의 모든 칼럼을 조회.
SELECT *
FROM EMPLOYEE;

--EMPLOYEE 테이블의 전체 사원들의 이름, 이메일, 휴대폰번호를 조회
SELECT  EMP_NAME,
        EMAIL,
        PHONE
FROM EMPLOYEE;

----------------------- 실습문제 -----------------------
-- 1번 . JOB 테이블의 모든칼럼 조회
SELECT *
FROM JOB;
-- 2번. JOB 테이블의 직급명만 조회
SELECT JOB_NAME
FROM JOB;
-- 3번. DEPARTMENT 테이블의 모든칼럼 조회
SELECT *
FROM DEPARTMENT;
-- 4번 EMPLOYEE 테이블의 직원명, 이메일, 전화번호, 입사일 칼럼만 조회
SELECT  EMP_NAME,
        EMAIL,
        PHONE,
        HIRE_DATE
FROM EMPLOYEE;
-- 5번 EMPLOYEE 테이블의 입사일, 직원명, 급여칼럼만 조회
SELECT  HIRE_DATE,
        EMP_NAME,
        SALARY
FROM EMPLOYEE;

/*
    <컬럼값을 통한 산술연산>
    조회하고자 하는 칼럼들을 나열하는 SELECT절에서 산술연산(+-/*)를 기술해서 결과를 조회할수 있다.
*/

--EMPLOYEE 테이블로부터 직원명과, 월급, 연봉
SELECT  EMP_NAME,
        SALARY,
        SALARY * 12
FROM EMPLOYEE;

--EMPLOYEE 테이블로부터 직원명과 월급 보너스, 보너스가 포함됨 연봉.(SALARY + SALARY*BONUS) * 12
SELECT  EMP_NAME,
        SALARY,
        BONUS,
        (SALARY + SALARY*BONUS) * 12
FROM EMPLOYEE;
--> 산술연산 과정에서 NULL값이 존재할 경우 산술연산 결과마저도 NULL이 된다.

-- EMPLOYEE 테이블로부터 직원명, 입사일, 근무일수(오늘날짜 - 입사일) 조회
-- DATE타입끼리도 연산이가능( DATE => 년,월,일,시,분,초)
-- 오늘날짜 : SYSDATE
SELECT  EMP_NAME,
        HIRE_DATE,
        SYSDATE-HIRE_DATE        
FROM EMPLOYEE;
-- 결과값이 지저분한 이유 : DATE타입 안에 포함된 시,분,초 에대한 연산까지 수행하기때문.
-- 결과값은 일수 단위로 출력.

/*
    <컬럼명에 별칭 부여하기>
    [표현법]
    컬럼명 AS 별칭, 컬럼명 AS  "별칭", 컬럼명 별칭, 컬럼명 "별칭"
    
    AS를 키워드를 붙이든 안붙이든 간에
    별칭에 특수문자나 띄어쓰기가 포함될 경우 ""를 묶어서 표기해줘야함.
*/

--EMPLOYEE 테이블로부터 직원명과, 월급, 연봉
SELECT  EMP_NAME,
        SALARY AS "급여(월)",
        SALARY * 12 AS "연봉(보너스 미포함)"
FROM EMPLOYEE;

-- EMPLOYEE 테이블로부터 직원명, 입사일, 근무일수(오늘날짜 - 입사일) 조회
-- DATE타입끼리도 연산이가능( DATE => 년,월,일,시,분,초)
-- 오늘날짜 : SYSDATE
SELECT  EMP_NAME AS "사원명",
        HIRE_DATE AS "입사일",
        SYSDATE-HIRE_DATE AS "근무일수"        
FROM EMPLOYEE;

/*
    < 리터럴 >
    임의로 지정한 문자열('')을 SELECT절에 기술하면
    실제 그 테이블에 존재하는 데이터처럼 조회가 가능하다.
*/

-- EMPLOYEE 테이블로부터 사번, 사원명, 급여, 단위('원') 조회하기.
SELECT  EMP_ID,
        EMP_NAME,
        SALARY,
        '원' AS 단위
FROM EMPLOYEE;    

/*
    <DISTINCT>
    조회하고자 하는 칼럼에 중복된 값을 딱 한번만 조회하고자 할 때 사용
    해당 칼럼명 앞에 기술
    
    [표현법]
    DISTINCT 컬럼명
    (단, SELECT 절에 DISTINCT 구문은 단 한개만 가능하다.)
*/
-- EMPLOYEE 테이블에서 부서코드들만 조회.
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- DEPT_CODE와 JOB_CODE 값을 세트로 묶어서 중복판별.
SELECT DISTINCT DEPT_CODE,
                JOB_CODE
FROM EMPLOYEE;

------------------------------------------------------
/*
    <WHERE 절>
    조회하고자 하는 테이블에 특정 조건을 제시해서
    그 조건에 만족하는 데이터들만을 조회하고자 할 때 기술하는 구문
    
    [표현법]
    SELECT 조회하고자하는 컬럼명, ....
    FROM 테이블명
    WHERE 조건식; => 조건에 해당하는 행들을 뽑아내겠다.
    
    실행순서
    FROM, WHERE, SELECT
    
    - 조건식에 다양한 연산자들 사용 가능
    
    <비교연산자>
    >, <, >=, <=
    = (일치하는지 여부. 자바에서는 == 였음)
    !=, ^=, <> 일치하지 않는가.
*/