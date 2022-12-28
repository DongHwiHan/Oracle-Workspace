/*
    <PROCEDURE>
    PL/SQL 구문을 "저장"해서 이용하게 하는 객체.
    필요할때마다 내가 작성한 PL/SQL문을 편하게 호출 가능하다.
    
    프로시져 생성방법
    [표현법]
    CREATE [OR REPLACE] PROCEDURE 프로시저명[(매개변수)]
    IS
    BEGIN
        실행부분
    END;
    
    프로시져 실행방법
    EXEC 프로시져명;
*/
-- EMPLOYEE 테이블을 복사한 COPY테이블 만들기
CREATE TABLE PRO_TEST
AS SELECT * FROM EMPLOYEE;

SELECT * FROM PRO_TEST;

-- 프로시져생성
CREATE PROCEDURE DEL_DATE
IS
BEGIN
    DELETE FROM PRO_TEST;
    COMMIT;
END;
/

SELECT * FROM USER_PROCEDURES;

-- 생성된 프로시저 실행
EXEC DEL_DATE;

-- 프로시저에 매개변수를 선언
-- IN : 프로시저 실행시 필요한 값을 받는 변수(자바에서의 매개변수와 동일)
-- OUT : 호출한곳으로 되돌려주는 변수(결과값)
CREATE OR REPLACE PROCEDURE PRO_SELECT_EMP(V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE, 
                                            V_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
                                            V_SALARY OUT EMPLOYEE.SALARY%TYPE,
                                            V_BONUS OUT EMPLOYEE.BONUS%TYPE)
IS
BEGIN
    SELECT EMP_NAME, SALARY, BONUS
    INTO V_EMP_NAME, V_SALARY, V_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
END;
/

-- 매개변수 있는 프로시저 실행하기
VAR EMP_NAME VARCHAR2(20);
VAR SALARY NUMBER;
VAR BONUS NUMBER;

EXEC PRO_SELECT_EMP(200,:EMP_NAME,:SALARY,:BONUS);

PRINT EMP_NAME;
PRINT SALARY;
PRINT BONUS;

/*
    프로시저 장점.
    1. 처리속도가 빠르다.
    2. 대량 자료처리시 유리하다.
    EX) DB에서 대용량의 데이터를 SELECT문으로 받아와서 자바에서 처리하는 경우 VS
    DB에서 "대용량의 데이터"를 SELECT한 후에 자바로 넘기지 않고 직접 처리하는 경우
    DB에서 처리하는게 당연히 성능이 더 좋음.(데이터를 넘길때마다 네트워크자원을 소비하게됨)
    
    프로시저 단점
    1. DB자원을 직접 사용하기 때문에 DB에 부하를 주게됨(남용하면 안된다.)
    2. 관리적 측면에서 자바소스코드, 오라클 코드 동시에 형상관리하기가 어려움.
    
    정리)
    한번에 처리되는 데이터량이 많고 성능을 요구하는 처리는 대체로 자바보다는 DB상에서 처리하는것이
    성능측면에서는 나을것이고 소스관리(유지보수) 즉 형상관리 측면에서는 자바가 더 좋다.
*/

-------------------------------------------------------------------------------------------
/*
    <FUNCTION>
    프로시저와 거의 유사하지만 실행결과를 반환받을수 있음.
    
    FUNCTION 생성방법
    [표현법]
    CREATE OR REPLACE FUNCTION 함수명 [(매개변수)]
    RETURN 자료형
    IS
    BEGIN
        실행부분
    END;
    /
    
    함수실행방법
    펑션이름(인수)
*/
CREATE OR REPLACE FUNCTION MYFUNC(V_STR VARCHAR2)
RETURN VARCHAR2
IS
    RESULT VARCHAR2(1000);
BEGIN
    DBMS_OUTPUT.PUT_LINE(V_STR);
    RESULT := '*' || V_STR || '*';
    
    RETURN RESULT;
END;
/
SELECT MYFUNC('민경민쨩') FROM DUAL;
-- EMP_ID를 전달받아 연봉을 계산해서 출력해주는 함수 만들기.
CREATE OR REPLACE FUNCTION CALC_SALARY(V_EMP_ID EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
    E EMPLOYEE%ROWTYPE;
    RESULT NUMBER;
BEGIN
 SELECT
        *
        
    INTO
        E
      
    FROM
        EMPLOYEE
    WHERE
        EMP_ID = V_EMP_ID;
        
    RESULT := (E.SALARY+E.SALARY*NVL(E.BONUS,0))*12;
    
    RETURN RESULT;

END;
/
SELECT EMP_NAME,CALC_SALARY(EMP_ID) FROM EMPLOYEE;