/*
    < JOIN >
    
    두개 이상의 테이블에서 데이터를 같이 조회하고자 할 때 사용되는 구문 => SELECT 문 이용
    조회 결과는 하나의 결과물(RESULT SET)으 로 나옴
    
    JOIN을 해야하는 이유 ?
    관계형 데이터베이스에서는 최소한의 데이터로 각각의 테이블에 데이터를 보관하고 있음.
    사원정보는 사원테이블, 직급정보는 직급테이블, ... => 중복을 최소화하기 위함.
    => 즉, JOIN 구문을 이용해서 여러개 테이블간의 관계를 맺어서 같이 조회해야함.
    => 단 무작저 JOIN을 하는것이 아니라 테이블간에 "연결고리(포린키)"에 해당되는 칼럼을 매칭시켜서 조회해야함.
    
    문법상 분류 : JOIN은 크게 오라클 전용구문과 ANSI구문으로 나누어짐.
        
            오라클 전용 구문                 |            ANSI구문(오라클 + 다른 DBMS에서 사용가능)
===============================================================================================
            등가조인(EQUAL JOIN)            |           내부조인(INNER JOIN) -> JOIN USING/ON
-----------------------------------------------------------------------------------------------
            포괄 조인                                   외부조인(OUTER JOIN) -> JOIN USING
            (LEFT OUTER JOIN)                           왼쪽 외부조인(LEFT OUTER JOIN)
            (RIGHT OUTER JOIN)                          오른쪽 외부조인(RIGHT OUTER JOIN)
                                                        전체 외부 조인(FULL OUTER JOIN) :오라클에서 사용 불가.
-----------------------------------------------------------------------------------------------
            카테시안곱                                   교차 조인(CROSS JOIN)
-----------------------------------------------------------------------------------------------
            자체조인(SELF JOIN)
            비등가조인(NON EQUAL JOIN)
*/

-- JOIN 사용하지 않는예
-- 전체 사원들의 사번, 사원명, 부서코드, 부서명까지 알아내고자한다면?
SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    JOB_CODE
FROM
    EMPLOYEE;

SELECT
    *
FROM
    DEPARTMENT;

SELECT
    *
FROM
    JOB;

--> 조인을 통해서 연결고리에 해당되는 칼럼들만 제대로 매칭시키면 마치 하나의 결과물로 조회 가능하다.

/*
    1. 등가조인 (EQUAL JOIN) / 내부조인 (INNER JOIN)
    연결시키고자 하는 칼럼값들이 "일치하는 행들"만 조인해서 조회
    ( == 일치하지 않는 값들을 결과에서 제회)
    => 동등비교연산자 = 일치한다라는 조건을 제시
    
    [표현법]
    등가조인(오라클구문)
    SELECT 조회하고자하는 컬럼명들,
    FROM 조인하고자하는 테이블명등
    WHERE 연결할 칼럼에대한 조건을 제시 (=)
    
    내부조인 (ANSI) : ON 구문
    SELECT 조회할 컬럼명들 나열
    FROM 기준으로 삼을 테이블 1개만 제시
    JOIN 조인할 테이블 1개 제시 ON (연결할 칼럼에 대한 조건을 제시(=))
    
    내부조인 (ANSI) : USING => 연결할 칼럼명이 동일할 경우만 씀
    SELECT 조회하고자하는 칼럼명들
    FROM 기분으로 삼을 테이블면 1개만제시
    JOIN 조인할 테이블명 1개만제시 USING(연결할 컬럼명 1개만 제시)
    
    + 만약에 연결할 칼럼명이 동일하다면 USING구문을 사용,
                            일치하지 않다면, 명시적으로 어느테이블로부터온 칼럼인지 작성해줘야한다.
*/
-- 오라클 전용구문.
-- FROM절에 내가 조회하고자하는 테이블명들 나열 ,로 찍어서
-- WHERE절에 매칭시킬 칼럼명에대한 조건을 제시.

-- 사번, 사원명, 부서코드, 부서명(DEPARTMENT)을 조회.
SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    DEPT_TITLE
FROM
    EMPLOYEE,
    DEPARTMENT
WHERE
    DEPT_CODE = DEPT_ID; -- EMPLOYEE 테이블에 DEPT_CODE값과 DEPARTMENT테이블의 DEPT_ID이 일치하는경우에만 조회.
--> 일치하지 않는 값은 조회되지 않는다. (부서코드가 NULL인 사원)
--> 두개 이상의 테이블을 조인할때 일치하는값이 없는행은 결과에서 제외됨.

-- 전체 사원들의 사번, 사원명, 직급코드, 직급명을 알아내고자한다면 ?
-- 연결할 칼럼명이 일치(EMPLOYEE - JOB_CODE / JOB - JOB_CODE)
SELECT
    EMP_ID,
    EMP_NAME,
    JOB_CODE,
    JOB_NAME
FROM
    EMPLOYEE,
    JOB
WHERE
    JOB_CODE = JOB_CODE; -- 에러발생 : column ambiguously defined : 컬럼명이 애매모호 하다. -> 확실히 어디테이블의
-- 칼럼인지를 제시해줘야함.

-- 방법 1) 테이블명을 이용하는 방법 => 테이블명.컬럼명
SELECT
    EMP_ID,
    EMP_NAME,
    EMPLOYEE.JOB_CODE,
    JOB_NAME
FROM
    EMPLOYEE,
    JOB
WHERE
    EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 방법 2) 테이블에 별칭을 붙여서 사용하는 방법(각 테이블마다 별칭부여 가능) => 별칭.컬럼명
SELECT
    EMP_ID,
    EMP_NAME,
    E.JOB_CODE,
    JOB_NAME
FROM
    EMPLOYEE E,
    JOB      J
WHERE
    J.JOB_CODE = E.JOB_CODE;

--> ANSI 구문
-- FROM절에 기준 테이블을 "하나만" 기술함.
-- 그 뒤에 JOIN절에서 같이 조회하고자 하는 테이블 기술. 또한 매칭시킬 컬럼에 대한 조건도 같이 기술.
-- USING / ON 구문

--전체 사원들의 사번, 사원명, 부서코드, 부서명을 알아내고자 할때
-- 1) 연결할 컬럼명 이 다른경우 ( EMPLOYEE - DEPT_CODE / DEPARTMENT - DEPT_ID)
--  => 무조건 ON구문만 가능.
SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    DEPT_TITLE
FROM
         EMPLOYEE
/*INNER*/
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID; -- INNER 생략가능

-- 전체 사원들의 사번, 사원명, 직급코드, 직급명
-- 2) 연결할 칼럼명이 동일한 경우(JOB_CODE)
-- => ON, USING 구문 둘다 사용가능함.
-- 2-1) ON구문 : ambihuously가 발생할수 있기때문에 칼럼명을 명확하게 기술해줘야함.
SELECT
    EMP_ID,
    EMP_NAME,
    E.JOB_CODE,
    JOB_NAME
FROM
         EMPLOYEE E
    JOIN JOB J ON ( E.JOB_CODE = J.JOB_CODE );

-- 2-2) USING구문 : 컬럼명이 동일한 경우에만 사용 가능.
--                    동일한 컬럼명 하나만써주면 알아서 매칭시켜줌.
SELECT
    EMP_ID,
    EMP_NAME,
    JOB_CODE,
    JOB_NAME
FROM
         EMPLOYEE
    JOIN JOB USING ( JOB_CODE );

-- [참고] 자연조인(NATURAL JOIN) : 등가조인 방법중 하나
-- => 동일한 타입과 이름을 가진 칼럼을 조인조건으로 이용하는 방법.
SELECT
    EMP_ID,
    EMP_NAME,
    JOB_CODE,
    JOB_NAME
FROM
         EMPLOYEE
    NATURAL JOIN JOB;
-- 운좋게도 두개의테이블에 일치하는 칼럼명이 "딱 한개"만 존재(JOB_CODE) -> 자연조건으로 사용시 알아서 JOB_CODE.가 매칭됨.

-- 조인시 추가적인 조건 제시방법
-- 직급이 대리인 사원들의 정보를 조회(사번 사원명, 월급, 직급(직급코드가 아닌 직급명)

--> 오라클 전용구문.
SELECT
    EMP_ID,
    EMP_NAME,
    SALARY,
    JOB_NAME
FROM
    EMPLOYEE E,
    JOB      J
WHERE
        E.JOB_CODE = J.JOB_CODE
    AND JOB_NAME = '대리';

--> ANSI구문
SELECT
    EMP_ID,
    EMP_NAME,
    SALARY,
    JOB_NAME
FROM
         EMPLOYEE E
    JOIN JOB J ON ( E.JOB_CODE = J.JOB_CODE )
WHERE
    JOB_NAME = '대리';

--------------------------------실습문제-----------------------------------
-- 1. 부서가 '인사관리부'인 사원들의 사번, 사원명, 보너스를 조회
-- 오라클 전용구문, ANSI 구문 2가지로 표현

--> 오라클 전용구문.
SELECT
    EMP_ID,
    EMP_NAME,
    BONUS
FROM
    EMPLOYEE,
    DEPARTMENT
WHERE
        DEPT_CODE = DEPT_ID
    AND DEPT_TITLE = '인사관리부';

--> ANSI구문
SELECT
    EMP_ID,
    EMP_NAME,
    BONUS
FROM
         EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE
    DEPT_TITLE = '인사관리부';

-- 2. 부서가 '총무부'가 아닌 사원들의 사원명, 급여, 입사일 조회
-- 오라클전용구문, ANSI구문 2가지로 표현

--> 오라클 전용구문.
SELECT
    EMP_NAME,
    SALARY,
    HIRE_DATE
FROM
    EMPLOYEE,
    DEPARTMENT
WHERE
        DEPT_CODE = DEPT_ID
    AND DEPT_TITLE != '총무부';

--> ANSI구문
SELECT
    EMP_NAME,
    SALARY,
    HIRE_DATE
FROM
         EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE
    DEPT_TITLE != '총무부';

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
-- 오라클전용구문, ANSI구문 2가지로 표현

--> 오라클 전용구문.
SELECT
    EMP_ID,
    EMP_NAME,
    BONUS,
    DEPT_TITLE
FROM
    EMPLOYEE,
    DEPARTMENT
WHERE
        DEPT_CODE = DEPT_ID
    AND BONUS IS NOT NULL;

--> ANSI구문
SELECT
    EMP_ID,
    EMP_NAME,
    BONUS,
    DEPT_TITLE
FROM
         EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE
    BONUS IS NOT NULL;

-- 4. 아래의 두 테이블을 참고해서 부서코드, 부서명, 지역코드, 지역명 조회
-- 오라클전용구문, ANSI구문 2가지로 표현
SELECT
    *
FROM
    DEPARTMENT; -- LOCATION_ID
SELECT
    *
FROM
    LOCATION; -- LOCAL_CODE

--> 오라클 전용구문.
SELECT
    DEPT_ID,
    DEPT_TITLE,
    LOCAL_CODE,
    LOCAL_NAME
FROM
    DEPARTMENT,
    LOCATION
WHERE
    LOCATION_ID = LOCAL_CODE;
 

--> ANSI구문
SELECT
    DEPT_ID,
    DEPT_TITLE,
    LOCAL_CODE,
    LOCAL_NAME
FROM
         DEPARTMENT
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;

--------------------------------------------------------------------------------
-- "전체" 사원들의 사원명, 급여, 부서명
SELECT
    EMP_NAME,
    SALARY,
    DEPT_TITLE
FROM
         EMPLOYEE
    JOIN DEPARTMENT ON ( DEPT_CODE = DEPT_ID );
-- DEPT_CODE가 NULL인사원 두며은 조회되지 않음. 즉, "모든" 사원들의 정보가 출력되는게 아님.

/*
    2. 포괄조인, 외부조인 ( OUTER JOIN )
    테이블간의 JOIN시에 "일치하지 않는 행도" 포함시켜서 조회가능
    단, 반드시 LEFT / RIGHT를 지정해야함. -> 기준이 되는 테이블을 지정해야한다.
    
    일치하는행 + 기준이 되는 테이블을 기준으로는 일치하지 않는행도 포함시켜서 조회.
*/
-- "전체" 사원들의 사원명, 급여, 부서명
-- 1) LEFT OUTER JOIN : 두 테이블 중 왼쪽에 있는 테이블을 기준테이블로 삼음.
--                      즉, 뭐가 되었든 왼편에 기술된 테이블의 데이터는 무조건 조회되게끔 한다.
--                      (조인하는 테이블과일치하는 값이 없더라도)

--> ANSI구문
SELECT
    EMP_NAME,
    SALARY,
    DEPT_TITLE
FROM
    EMPLOYEE
    LEFT OUTER JOIN DEPARTMENT ON ( DEPT_CODE = DEPT_ID );
-- EMPLOYEE 테이블을 기준으로 조회해기 때문에 EMPLOYEE에 존재하는 데이터는 뭐가 되었든 다 조회가능하게끔 해줌.

--> 오라클전용구문.
SELECT
    EMP_NAME,
    SALARY,
    DEPT_TITLE
FROM
    EMPLOYEE,
    DEPARTMENT
WHERE
    DEPT_CODE = DEPT_ID (+);
--> 내가 기준으로 삼을 테이블의 반대 컬럼명에 (+)를 붙여준다.

-- 2) RIGHT OUTER JOIN : 두 테이블중 오른편에 기술된 테이블을 기준으로 JOIN
--                       즉, 뭐가 되었든 간에 오른편에 기술된 테이블의 데이터는 무조건 조회되게 한다.
--                       (일치하는 것을 찾지 못하더라고 조회하겠다.)

--> ANSI구문
SELECT
    EMP_NAME,
    SALARY,
    DEPT_TITLE
FROM
         EMPLOYEE RIGHT /*OUTER*/
    JOIN DEPARTMENT ON ( DEPT_CODE = DEPT_ID );

--> 오라클전용구문.
SELECT
    EMP_NAME,
    SALARY,
    DEPT_TITLE
FROM
    EMPLOYEE,
    DEPARTMENT
WHERE
    DEPT_CODE (+) = DEPT_ID;

-- 3) FULL OUTER JOIN : 두 테이블이 가진 모든 행을 조회.
-- 일치하는 행들 + LEFT OUTER JOIN 기준 새롭게 추가된 행들 +RIGHT OUTER JOIN

--> ANSI구문
SELECT
    EMP_NAME,
    SALARY,
    DEPT_TITLE
FROM
         EMPLOYEE FULL
    JOIN DEPARTMENT ON ( DEPT_CODE = DEPT_ID );

--> 오라클전용구문. (사용불가)
SELECT
    EMP_NAME,
    SALARY,
    DEPT_TITLE
FROM
    EMPLOYEE,
    DEPARTMENT
WHERE
    DEPT_CODE (+) = DEPT_ID (+);

/*
    3. 카테시안 곱 / 교차조인(CROSS JOIN)
    
    모든 테이블의 각 행들이 서롯로 매핑된 데이터가 조회됨(곱집합)
    두 테이블의 행들이 모두 "곱해진" 행들의 조합 출력됨.
    
    각각 N개, M개의 행을 가진 테이블이 있다면 출력결과가 되는 행의 갯수는 N * M행
    모든 경우의 수를 다 따져서 조회하겠다.
    방대한 데이터를 출력(과부하 위험이 있음)
*/
-- 사원명, 부서명
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM
    EMPLOYEE,
    DEPARTMENT
ORDER BY
    EMP_NAME ASC;-- 23 인원 * 9개의 부서 -> 207행 조회

SELECT
    EMP_NAME,
    DEPT_TITLE
FROM
         EMPLOYEE
    CROSS JOIN DEPARTMENT
ORDER BY
    EMP_NAME ASC;

-- 카테시안의 곱의 경우 : WHERE 조건절에 기술하는 조인문이 잘못되었거나 아예 없을때 발생.

/*
    4. 비등가 조인(NON EQUAL JOIN)
    '=' 를 사용하지 않는 조인문 => 다른 비교 연산자를 써서 조인함.(>, <, >=, <=, BETWEEN A AND B)
    => 지정한 칼럼값들이 일치하는 경우가 아니라 "범위"에[ 포함되는 경우 매칭해서 조회하겠다.
    
    등가조인 => '=' 으로 '일치'하는 경우만 조회
    비등가조인 => '=' 가 아닌 다른 비교연산자로 "범위"에 포함되는 경우를 조회.
*/

-- 사원명, 급여, 급여등급(SAL_LEVEL)
-- 오라클 구문
SELECT
    EMP_NAME,
    SALARY,
    SAL_GRADE.SAL_LEVEL
FROM
    EMPLOYEE,
    SAL_GRADE
--WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
WHERE
    SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- ANSI구문
SELECT
    EMP_NAME,
    SALARY,
    SAL_GRADE.SAL_LEVEL
FROM
         EMPLOYEE
    JOIN SAL_GRADE ON SALARY BETWEEN MIN_SAL AND MAX_SAL;

/*
    5. 자체조인 (SELE JOIN)
    
    같은 테이블끼리 조인하는 경우
    즉, 자기 자신의 테이블과 다시 조인을 맺겠다.
    => 자체 조인의 경우 테이블에 반드시 별칭을 붙여줘야 한다.(별칭을 붙이면 서로 다른 테이블인 것처럼 사용가능)
*/

-- 사원의 사번(EMP_ID), 사원명(EMP_NAME), 사수의 사번(MANAGER_ID), 사수명(EMP_NAME)
SELECT
    E.EMP_ID,
    E.EMP_NAME,
    E.MANAGER_ID,
    M.EMP_NAME
FROM
    EMPLOYEE E,
    EMPLOYEE M
WHERE
    E.MANAGER_ID = M.EMP_ID (+);

-- ANSI 구문
SELECT
    E.EMP_ID,
    E.EMP_NAME,
    E.MANAGER_ID,
    M.EMP_NAME
FROM
    EMPLOYEE E
    LEFT JOIN EMPLOYEE M ON ( E.MANAGER_ID = M.EMP_ID );

/*
    < 다중 JOIN >
    
    3개 이상의 테이블을 조인해서 조회하겠다.
    => 조인 순서가 중요하다.
*/
-- 사번(EMPLOYEE - EMP_ID), 사원명(EMPLOYEE - EMP_NAME), 부서명(DEPARTMENT - DEPT_TITLE), 직급명(JOB - JOB_NAME)

-- 오라클 전용 구문
SELECT
    EMP_ID     사번,
    EMP_NAME   사원명,
    DEPT_TITLE 부서명,
    JOB_NAME   직급명
FROM
    EMPLOYEE   E,
    DEPARTMENT D,
    JOB        J
WHERE
        E.DEPT_CODE = D.DEPT_ID (+)
    AND E.JOB_CODE = J.JOB_CODE;

-- ANSI 구문
SELECT
    EMP_ID     사번,
    EMP_NAME   사원명,
    DEPT_TITLE 부서명,
    JOB_NAME   직급명
FROM
    EMPLOYEE   E
    LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    LEFT JOIN JOB        J ON E.JOB_CODE = J.JOB_CODE;