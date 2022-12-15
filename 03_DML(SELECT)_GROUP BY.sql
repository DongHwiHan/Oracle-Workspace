/*
    < GROUP BY 절 >
    
    그룹을 묶어줄 기준을 제시할수 있는 구문 => 그룹함수와 같이쓰임.
    해당 제시된 기준별로 그룹을 묶을수 있다.
    여러개의 값들을 하나의 구릅으로 묶어서 처리할 목적으로 사용.
    
    [표현법]
    GROUP BY 묶어줄 기준이될 칼럼
*/
-- 각 부서별로 총 급여의 합계
SELECT
    DEPT_CODE,
    SUM(SALARY)
FROM
    EMPLOYEE
GROUP BY
    DEPT_CODE; -- 부서별로 그룹을 짓겠다.

-- 각 부서별 사원수
SELECT
    DEPT_CODE,
    COUNT(*) AS "사원수"
FROM
    EMPLOYEE
GROUP BY
    DEPT_CODE;

-- 각 부서별로 총 급여 합을 부서별 오름차순으로 정렬해서 조회.
SELECT
    DEPT_CODE,
    SUM(SALARY)
FROM
    EMPLOYEE
GROUP BY
    DEPT_CODE
ORDER BY
    DEPT_CODE;

-- 각 부서별 총급여 합을 급여별 내림차순으로 정렬해서 조회.
SELECT
    DEPT_CODE,
    SUM(SALARY) AS 총급여 -- 4.SELECT절 실행
FROM
    EMPLOYEE -- 1. FROM절 먼저 실행
WHERE
    1 = 1 -- 2. WHERE절 두번째로 실행
GROUP BY
    DEPT_CODE -- 3. GROUP BY절 실행
ORDER BY
    총급여 DESC; -- 5. ORDER BY절 실

-- 각 직급별 직급코드, 총 급여의 합, 사원수, 보너스를 받는 사원수, 평균급여, 최고급여, 최소급여
SELECT
    JOB_CODE           AS 직급코드,
    SUM(SALARY)        AS "총 급여의 합",
    COUNT(*)           AS 사원수,
    COUNT(BONUS)       AS "보너스를 받는 사원수",
    ROUND(AVG(SALARY)) AS 평균급여,
    MAX(SALARY)        AS 최고급여,
    MIN(SALARY)        AS 최소급여
FROM
    EMPLOYEE
GROUP BY
    JOB_CODE
ORDER BY
    JOB_CODE;

-- 성별 별 사원수
-- 성별 : SUBSTR(EMP_NO,8,1)
SELECT
    DECODE(SUBSTR(EMP_NO, 8, 1),
           '1',
           '남',
           '2',
           '여') 성별,
    COUNT(*)    사원수
FROM
    EMPLOYEE
GROUP BY
    SUBSTR(EMP_NO, 8, 1)
ORDER BY
    SUBSTR(EMP_NO, 8, 1) DESC;

-- 각 부서별로 평균 급여가 300만원 이상인 부서만 조회
SELECT
    DEPT_CODE,
    ROUND(AVG(SALARY))
FROM
    EMPLOYEE
GROUP BY
    DEPT_CODE
HAVING
    ROUND(AVG(SALARY)) >= 3000000
ORDER BY
    DEPT_CODE;

/*
    < HAVING 절 >
    
    그룹에 대한 조건을 제시하고자할때 사용되는 구문.
    (주로 그룹함수를 가지고 제시) => GROUP BY 절과 함께 쓰인다.
*/
-- 각 부서별로 평균 급여가 300만원 이상인 부서만 조회
SELECT
    DEPT_CODE,
    ROUND(AVG(SALARY))
FROM
    EMPLOYEE
GROUP BY
    DEPT_CODE
HAVING
    ROUND(AVG(SALARY)) >= 3000000
ORDER BY
    DEPT_CODE;

-- 각 직급별로 총 급여합이 1000만원 이상인 직급코드, 급여 합을 조회
SELECT
    JOB_CODE    직급코드,
    SUM(SALARY) 총급여합
FROM
    EMPLOYEE
GROUP BY
    JOB_CODE
HAVING
    SUM(SALARY) >= 10000000;
-- 각 집급별로 급여 평균이 300만원 이상인 직급코드, 평균급여, 사원수, 최고급여, 최소급여
SELECT
    JOB_CODE           직급코드,
    ROUND(AVG(SALARY)) 평균급여,
    COUNT(*)           사원수,
    MAX(SALARY)        최고급여,
    MIN(SALARY)        최소급여
FROM
    EMPLOYEE
GROUP BY
    JOB_CODE
HAVING
    ROUND(AVG(SALARY)) >= 3000000;
-- 각 부서 별 보너스를 받는 사원이 없는 부서만 조회
SELECT
    DEPT_CODE
FROM
    EMPLOYEE
GROUP BY
    DEPT_CODE
HAVING
    COUNT(BONUS) <= 0;
-- 각 부서별 평균 급여가 350만원 이하인 부서만 조회.
SELECT
    DEPT_CODE 부서코드
FROM
    EMPLOYEE
GROUP BY
    DEPT_CODE
HAVING
    ROUND(AVG(SALARY)) <= 3500000;

---------------------------------------------------------------------------------
/*
    < SELSECT 문 구조 및 실행순서 >
    5. SELECT 조회하고자 하는 칼럼명 나열 / * / 리터럴 / 산술연산식 / 함수 / 별칭부여
    1. FROM 조회하고자하는 테이블명 / 인라인쿼리 / 가상테이블(DUAL) 
    2. WHERE 조건식 (그룹 함수를 사용할수 없음)
    3. GROUP BY 그룹 기준에 해당하는 칼럼명 / 함수식 
    4. HAVING 그룹함수식에 대한 조건식
    6. ORDER BY [정렬기준에 해당하는 칼럼명 / 별칭 / 컬럼의순번] [ASC / DESC] (생략가능) [NULLS FIRST / NULLS LAST] (생략가능)
*/