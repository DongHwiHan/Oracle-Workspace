--1
INSERT INTO TB_CLASS_TYPE
    (
        SELECT
            '01'   AS "번호",
            '전공필수' AS "유형이름"
        FROM
            DUAL
        UNION
        SELECT
            '02'   AS "번호",
            '전공선택' AS "유형이름"
        FROM
            DUAL
        UNION
        SELECT
            '03'   AS "번호",
            '교양필수' AS "유형이름"
        FROM
            DUAL
        UNION
        SELECT
            '04'   AS "번호",
            '교양선택' AS "유형이름"
        FROM
            DUAL
        UNION
        SELECT
            '05'   AS "번호",
            '논문지도' AS "유형이름"
        FROM
            DUAL
    );

--2
CREATE TABLE TB_학생일반정보
    AS
        SELECT
            STUDENT_NO      AS "학번",
            STUDENT_NAME    AS "학생이름",
            STUDENT_ADDRESS AS "주소"
        FROM
            TB_STUDENT;
     
--3
CREATE TABLE TB_국어국문학과
    AS
        SELECT
            S.STUDENT_NO    AS "학번",
            S.STUDENT_NAME  AS "학생이름",
            TO_CHAR(TO_DATE(SUBSTR(STUDENT_SSN, 1, 6),
        'RRMMDD'),
                    'YYYY') AS "출생연도",
            PROFESSOR_NAME  AS "교수이름"
        FROM
            TB_STUDENT    S,
            TB_PROFESSOR  P,
            TB_DEPARTMENT D
        WHERE
                S.COACH_PROFESSOR_NO = P.PROFESSOR_NO
            AND S.DEPARTMENT_NO = D.DEPARTMENT_NO
            AND DEPARTMENT_NAME = '국어국문학과';

SELECT
    *
FROM
    TB_국어국문학과;

--4
UPDATE TB_DEPARTMENT
SET
    CAPACITY = ROUND(CAPACITY * 1.1);

SELECT
    CAPACITY
FROM
    TB_DEPARTMENT;

--5
UPDATE TB_STUDENT
SET
    STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE
    STUDENT_NO = 'A413042';

SELECT
    STUDENT_ADDRESS
FROM
    TB_STUDENT
WHERE
    STUDENT_NO = 'A413042';
 
--6
UPDATE TB_STUDENT
SET
    STUDENT_SSN = SUBSTR(STUDENT_SSN, 1, 6);

SELECT
    *
FROM
    TB_STUDENT;

--7
UPDATE TB_GRADE
SET
    POINT = 3.5
WHERE
    ( STUDENT_NO, TERM_NO, CLASS_NO ) IN (
        SELECT
            S.STUDENT_NO, TERM_NO, C.CLASS_NO
        FROM
            TB_STUDENT    S,
            TB_CLASS      C, TB_GRADE      G, TB_DEPARTMENT D
        WHERE
                S.STUDENT_NO = G.STUDENT_NO
            AND G.CLASS_NO = C.CLASS_NO
            AND D.DEPARTMENT_NO = S.DEPARTMENT_NO
            AND DEPARTMENT_NAME = '의학과'
            AND STUDENT_NAME = '김명훈'
            AND TERM_NO = 200501
            AND CLASS_NAME = '피부생리학'
    );
                                              
                                              
--8
DELETE FROM TB_GRADE
WHERE
    STUDENT_NO IN (
        SELECT
            STUDENT_NO
        FROM
            TB_STUDENT
        WHERE
            ABSENCE_YN = 'Y'
    );