SET SERVEROUTPUT  ON;
-- 1.
-- 사원의 연봉을 구하는 PL/SQL 블럭작성, 보너스가 있는 사원은 보너스도 포함하여 계산
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
    DBMS_OUTPUT.PUT_LINE('연봉   :  ' || (E.SALARY+E.SALARY*NVL(E.BONUS, 0))*12);
END;
/

-- 2. 구구단 짝수 출력
-- 2-1) FOR LOOP



-- 2-2) WHILE LOOP