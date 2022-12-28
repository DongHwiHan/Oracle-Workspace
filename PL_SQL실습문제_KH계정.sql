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
    DBMS_OUTPUT.PUT_LINE('연봉   : '
                         ||(E.SALARY + E.SALARY * NVL(E.BONUS, 0)) * 12);

END;
/

-- 2. 구구단 짝수 출력
-- 2-1) FOR LOOP
DECLARE
    RESULT NUMBER;
BEGIN
    FOR DAN IN 2..9 LOOP
        IF MOD(DAN, 2) = 0 -- 2로 나눴을때 나머지가 0인경우
         THEN
            FOR SU IN 1..9 LOOP
                RESULT := DAN * SU;
                DBMS_OUTPUT.PUT_LINE(DAN
                                     || ' * '
                                     || SU
                                     || ' = '
                                     || RESULT);

            END LOOP;

            DBMS_OUTPUT.PUT_LINE(' ');
        END IF;
    END LOOP;
END;
/
-- 2-2) WHILE LOOP
DECLARE
    RESULT NUMBER;
    DAN    NUMBER := 2;
    SU     NUMBER;
BEGIN
    WHILE DAN <= 9 LOOP
        SU := 1;
        IF MOD(DAN, 2) = 0 THEN
            WHILE SU <= 9 LOOP
                RESULT := DAN * SU;
                DBMS_OUTPUT.PUT_LINE(DAN
                                     || ' * '
                                     || SU
                                     || ' = '
                                     || RESULT);

                SU := SU + 1;
            END LOOP;

            DBMS_OUTPUT.PUT_LINE(' ');
        END IF;

        DAN := DAN + 2;
    END LOOP;
END;
/