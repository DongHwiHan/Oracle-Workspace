/*
    <PL/SQL>
    PROCEDURE LANGUAGE EXTENSION TO SQL
    
    오라클 자체에 내장되어있는 절차적 언어.
    SQL문장 내에서 변수의 정의, 조건처리(IF), 반복문처리(LOOP ,FOR, WHILE) ,예외처리등을 지원하여 SQL문 단점을 보완.
    다수의 SQL문을 한번에 실행 가능.
    
    PL/SQL문의 구조
    - [선언부(DECLARE SECTION)] : DECLARE로 시작, 변수나상수를 선언 및 초기화 하는 부분
    - 실행부(EXECUTABLE SECTION) : BEGIN으로 시작, SQL문 또는 제어문 등의 로직을 기술하는 부분
    - [예외처리부(EXCEPTION SECTION)] : EXCEPTION로 시작, 예외발행시 해결하기 위한 구문을 미리 기술하는 부분
*/

-- * 화면에 HEELO ORACLE출력해보기
-- 1) 서버 아웃풋 옵션을 켜줌
SET SERVEROUTPUT  ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/

/*
    1. DECLATE 선언부
    변수 나 상수를 선언 하는공간(선언과동시에 초기화도 가능함.)
    일반타입 변수, 레퍼런스 변수, ROW타입 변수
    
    1_1) 일반타입변수 선언 및 초기화
    [표현식] 변수명 [CONSTANT] 자료형 [:=값];
*/
DECLARE
    EID   NUMBER;
    ENAME VARCHAR2(20);
    PI    CONSTANT NUMBER := 3.14;
BEGIN
--     EID := 800;
    EID := &번호;
--     ENAME := '민경민';
    ENAME := '&이름';
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/ 
-- 이게 있어야 블록의 종결로 간주됨.

-- 1_2) 레퍼런스 타입 변수 선언 및 초기화(어떤테이블의 어떤칼럼의 데이터타입을 참조해서 그타입으로 지정)
-- [표현식] 변수명 테이블명.컬럼명%TYPE;
DECLARE
    EID   EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL   EMPLOYEE.SALARY%TYPE;
BEGIN
    EID := '300';
    ENAME := '경민';
    SAL := 3000000;
    
    -- 사원의사번이 200번인 각 사원의 사번, 사워명, 연보을 대입.
    SELECT
        EMP_ID,
        EMP_NAME,
        SALARY
    INTO
        EID,
        ENAME,
        SAL
    FROM
        EMPLOYEE
    WHERE
        EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
END;
/
-------------------------------- 실습문제----------------------------------------
/*
    레퍼런스 타입 변수로 EID, ENAME, JCODE, SAL ,DTITLE을 선언하고
    각 자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY)
    DEPRATMENT(DEPT_TITLE)을 참조하도록
    
    사용자가 입력한 사번인 사원의 사번 ,사워명 ,직급코드 ,급여, 부서명 조회후
    변수에 담아서
*/
DECLARE
    EID    EMPLOYEE.EMP_ID%TYPE;
    ENAME  EMPLOYEE.EMP_NAME%TYPE;
    JCODE  EMPLOYEE.JOB_CODE%TYPE;
    SAL    EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT
        EMP_ID,
        EMP_NAME,
        JOB_CODE,
        SALARY,
        DEPT_TITLE
    INTO
        EID,
        ENAME,
        JCODE,
        SAL,
        DTITLE
    FROM
             EMPLOYEE
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE
        EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE(EID
                         || ', '
                         || ENAME
                         || ','
                         || JCODE
                         || ','
                         || SAL
                         || ','
                         || DTITLE);

END;
/
--------------------------------------------------------------------------------
-- 1_3) ROW타입 변수선언
--      테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을수 있는 변수
--      [표현식] 변수명 테이블명%ROWTYPE
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT
        *
    INTO E
    FROM
        EMPLOYEE
    WHERE
        EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여   :  ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스 :  '
                         || NVL(E.BONUS, 0)); -- 보너스가 NULL경우 빈값으로 표시됨.
      -- NVL함수를 이용해서 0으로 표시해주기
END;
/
--------------------------------------------------------
-- 2. BEGIN 실행부
/*
    <조건문>
    
    1) IF 조건식 THEN 실행내용
    
    사번 입력받은후 해당사원의 사번, 이름, 급여, 보너스율(%)를 출력
    단, 보너스를 받지 않는사원은 보너스율 출력전 '보너스를 지급받지 않는 사원입니다'를 출력
*/
DECLARE
    EID    EMPLOYEE.EMP_ID%TYPE;
    ENAME  EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS  EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT
        EMP_ID,
        EMP_NAME,
        SALARY,
        NVL(BONUS, 0)
    INTO
        EID,
        ENAME,
        SALARY,
        BONUS
    FROM
        EMPLOYEE
    WHERE
        EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    IF BONUS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('보너스율 : '
                         || BONUS * 100
                         || '%');
END;
/

-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 ENF IF; (IF - ELSE)
DECLARE
    EID    EMPLOYEE.EMP_ID%TYPE;
    ENAME  EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS  EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT
        EMP_ID,
        EMP_NAME,
        SALARY,
        NVL(BONUS, 0)
    INTO
        EID,
        ENAME,
        SALARY,
        BONUS
    FROM
        EMPLOYEE
    WHERE
        EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    IF BONUS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('보너스율 : '
                             || BONUS * 100
                             || '%');
    END IF;

END;
/
---------------------------실습문제 ---------------------------------------------
-- 레퍼런스타입변수 (EID, ENAME, DTITLE, NCODE) , 일반타입변수 TEAM VARHCAR2(10)
--     참조할 컬럼 (EMP_ID, EMP_NAME, DEPT_TITLE, NCATIONAL_CODE)
DECLARE
    EID    EMPLOYEE.EMP_ID%TYPE;
    ENAME  EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE  KH.NATIONAL.NATIONAL_CODE%TYPE;
    TEAM   VARCHAR2(10);
BEGIN 
    -- 사용자가 입력한 사원의 사번, 이름, 부서명, 근무국가코드 조회후 , 각 변수에 대입.
    SELECT
        EMP_ID,
        EMP_NAME,
        DEPT_TITLE,
        NATIONAL_CODE
    INTO
        EID,
        ENAME,
        DTITLE,
        NCODE
    FROM
             EMPLOYEE
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
        JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
        JOIN NATIONAL USING ( NATIONAL_CODE )
    WHERE
        EMP_ID = &사번;
    -- NCODE의 값이 KO일경우 TEAM에 한국팀대입, 그게아닐경우 해외팀 대입
    IF NCODE = 'KO' THEN
        TEAM := '한국팀';
    ELSE
        TEAM := '해외팀';
    END IF;
    -- 사번, 이름 ,부서 ,소속(TEAM) 출력
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('부서 : ' || DTITLE);
    DBMS_OUTPUT.PUT_LINE('소속 : ' || TEAM);
END;
/

-- 3) IF 조건식 1 THEN 실행내용1 ELSIF 조건식 2 THEN 실행내용2 ... [ELSE] ENF IF;
-- 급여가 500만원 이상이면 고급
-- 급여가 300만원 이상이면 중급
-- 그외는 초급
-- 출력문 : 해당사원의 급여등급은 XX입니다.
DECLARE
    SAL   EMPLOYEE.SALARY%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT
        SALARY,
        EMP_NAME
    INTO
        SAL,
        ENAME
    FROM
        EMPLOYEE
    WHERE
        EMP_ID = &사번;

    IF SAL >= 5000000 THEN
        GRADE := '고급';
    ELSIF SAL >= 3000000 THEN
        GRADE := '중급';
    ELSE
        GRADE := '초급';
    END IF;

    DBMS_OUTPUT.PUT_LINE(ENAME
                         || '사원의 급여등급은 '
                         || GRADE
                         || '입니다.');
END;
/