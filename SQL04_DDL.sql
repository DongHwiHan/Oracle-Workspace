-- 1
-- 계열 정보를 저장할 카테고리 테이블 작성
CREATE TABLE TB_CATEGORY (
    NAME   VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
);
-- 2
-- 과목 구분을 저장할 테이블 작성
CREATE TABLE TB_CLASS_TYPE (
    NO   VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10)
);
-- 3
-- TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY를 생성
ALTER TABLE TB_CATEGORY ADD CONSTRAINT NAME_PK PRIMARY KEY ( NAME );
-- 4
-- TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경
ALTER TABLE TB_CLASS_TYPE MODIFY
    NAME
        CONSTRAINT NAME_NN NOT NULL;
-- 5
-- 두 테이블에서 컬럼 명이 NO 인 것은 기존 타입을 유지하면서 크기는 10, 컬럼명이
-- NAME인 것은 마찬가지로 기존 타입을 유지하면서 크기 20으로 변경
ALTER TABLE TB_CATEGORY MODIFY
    NAME VARCHAR2(20);

ALTER TABLE TB_CLASS_TYPE MODIFY
    NO VARCHAR2(10);

ALTER TABLE TB_CLASS_TYPE MODIFY
    NAME VARCHAR2(20);
-- 6
-- 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB_를 제외한 테이블 이름이 앞에 붙은
-- 형태로 변경 EX) CATEGORY_NAME
ALTER TABLE TB_CATEGORY RENAME COLUMN NAME TO CATEGORY_NAME;

ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NAME TO CLASS_TYPE_NAME;

ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;
-- 7
-- TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이 변경
-- PRIMARY KEY의 이름은 "PK_ + 컬럼이름" 으로 지정 EX) PK_CATEGORY_NAME
ALTER TABLE TB_CATEGORY RENAME CONSTRAINT NAME_PK TO PK_CATEGORY_NAME;
-- 8
-- 다음과 같은 INSERT 문을 수행한다.
INSERT INTO TB_CATEGORY
    (
        SELECT
            '공학',
            'Y'
        FROM
            DUAL
        UNION
        SELECT
            '자연과학',
            'Y'
        FROM
            DUAL
        UNION
        SELECT
            '의학',
            'Y'
        FROM
            DUAL
        UNION
        SELECT
            '예체능',
            'Y'
        FROM
            DUAL
        UNION
        SELECT
            '인문사회',
            'Y'
        FROM
            DUAL
    );

COMMIT;
-- 9 
-- TB_DEPARTMENT 의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모
-- 값으로 참조하도록 FOREIGN KEY지정 KEY 이름은 FK_테이블이름_컬럼이름
-- EX( FK_DEPARTMENT_CATEGORY)
ALTER TABLE TB_DEPARTMENT
    ADD CONSTRAINT FK_DEPARTMENT_CATEGORY FOREIGN KEY ( CATEGORY )
        REFERENCES TB_CATEGORY ( CATEGORY_NAME );

-- 10
-- 학생들의 정보만이 포함되어 있는 학생 일반정보 VIEW를 만들고자한다.
GRANT
    CREATE VIEW
TO WORKBOOK;

CREATE VIEW VW_학생일반정보 AS
    SELECT
        STUDENT_NO,
        STUDENT_NAME,
        STUDENT_ADDRESS
    FROM
        TB_STUDENT;

-- 11
--
CREATE VIEW VW_지도면담 AS
    SELECT
        STUDENT_NAME,
        DEPARTMENT_NAME,
        COACH_PROFESSOR_NO
    FROM
             TB_STUDENT
        JOIN TB_DEPARTMENT USING ( DEPARTMENT_NO )
        JOIN TB_PROFESSOR ON PROFESSOR_NO = COACH_PROFESSOR_NO;

-- 12
-- 모든 학과의 학과별 학생 수를 확인할 수 있도록 만들기
CREATE VIEW VW_학과별학생수 AS
    SELECT
        DEPARTMENT_NAME,
        COUNT(*) AS STUDENT_COUNT
    FROM
             TB_STUDENT
        JOIN TB_DEPARTMENT USING ( DEPARTMENT_NO )
    GROUP BY
        DEPARTMENT_NAME;

-- 13
-- 위에서 생성한 학생일반정보 VIEW를 통해서 학번이 A213046인 학생의 이름을 본인이름으로 변경
UPDATE VW_학생일반정보
SET
    STUDENT_NAME = '한동휘'
WHERE
    STUDENT_NO = 'A213046';
-- 14
-- 13번에서와 같이 VIEW를 통해 데이터가 변결되 수 있는 상황을 막으려면 VIEW를 어떻게 해야하는지
CREATE VIEW VW_학생일반정보 AS
    SELECT
        STUDENT_NO,
        STUDENT_NAME,
        STUDENT_ADDRESS
    FROM
        TB_STUDENT
    WHERE
        STUDENT_NO = 'A213046'
WITH CHECK OPTION;
-- 15
-- 매년 수강신청 기가만 되면 특정 인기 과목들에 수강 신청이 몰려 문제가 되고 있다. 최근 3년을
-- 기준으로 수강인원이 가장 많았던 3 과목을 찾는 구문을 작성
SELECT
    CLASS_NO   AS 과목번호,
    CLASS_NAME AS 과목이름,
    "누적수강생수(명)"
FROM
    (
        SELECT
            CLASS_NO,
            CLASS_NAME,
            COUNT(*) "누적수강생수(명)"
        FROM
                 TB_GRADE
            JOIN TB_CLASS USING ( CLASS_NO )
        WHERE
            TERM_NO >= '2007/03'
        GROUP BY
            CLASS_NO,
            CLASS_NAME
        ORDER BY
            3 DESC
    )
WHERE
    ROWNUM <= 3;