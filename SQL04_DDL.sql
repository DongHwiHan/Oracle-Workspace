-- 1
-- 계열 정보를 저장할 카테고리 테이블 작성
CREATE TABLE tb_category (
    name   VARCHAR2(10),
    use_yn CHAR(1) DEFAULT 'Y'
);
-- 2
-- 과목 구분을 저장할 테이블 작성
CREATE TABLE tb_class_type (
    no   VARCHAR2(5) PRIMARY KEY,
    name VARCHAR2(10)
);
-- 3
-- TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY를 생성
ALTER TABLE tb_category ADD CONSTRAINT name_pk PRIMARY KEY ( name );
-- 4
-- TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경
ALTER TABLE tb_class_type MODIFY
    name
        CONSTRAINT name_nn NOT NULL;
-- 5
-- 두 테이블에서 컬럼 명이 NO 인 것은 기존 타입을 유지하면서 크기는 10, 컬럼명이
-- NAME인 것은 마찬가지로 기존 타입을 유지하면서 크기 20으로 변경
ALTER TABLE tb_category MODIFY
    name VARCHAR2(20);

ALTER TABLE tb_class_type MODIFY
    no VARCHAR2(10);

ALTER TABLE tb_class_type MODIFY
    name VARCHAR2(20);
-- 6
-- 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB_를 제외한 테이블 이름이 앞에 붙은
-- 형태로 변경 EX) CATEGORY_NAME
ALTER TABLE tb_category RENAME COLUMN name TO category_name;

ALTER TABLE tb_class_type RENAME COLUMN name TO class_type_name;

ALTER TABLE tb_class_type RENAME COLUMN no TO class_type_no;
-- 7
-- TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이 변경
-- PRIMARY KEY의 이름은 "PK_ + 컬럼이름" 으로 지정 EX) PK_CATEGORY_NAME
ALTER TABLE tb_category RENAME CONSTRAINT name_pk TO pk_category_name;
-- 8
-- 다음과 같은 INSERT 문을 수행한다.
INSERT INTO tb_category
    (
        SELECT
            '공학',
            'Y'
        FROM
            dual
        UNION
        SELECT
            '자연과학',
            'Y'
        FROM
            dual
        UNION
        SELECT
            '의학',
            'Y'
        FROM
            dual
        UNION
        SELECT
            '예체능',
            'Y'
        FROM
            dual
        UNION
        SELECT
            '인문사회',
            'Y'
        FROM
            dual
    );

COMMIT;
-- 9 
-- TB_DEPARTMENT 의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모
-- 값으로 참조하도록 FOREIGN KEY지정 KEY 이름은 FK_테이블이름_컬럼이름
-- EX( FK_DEPARTMENT_CATEGORY)
ALTER TABLE tb_department
    ADD CONSTRAINT fk_department_category FOREIGN KEY ( category )
        REFERENCES tb_category ( category_name );

-- 10
-- 학생들의 정보만이 포함되어 있는 학생 일반정보 VIEW를 만들고자한다.
GRANT
    CREATE VIEW
TO workbook;

CREATE VIEW vw_학생일반정보 AS
    SELECT
        student_no,
        student_name,
        student_address
    FROM
        tb_student;

-- 11
--
CREATE VIEW vw_지도면담 AS
    SELECT
        student_name,
        department_name,
        coach_professor_no
    FROM
             tb_student
        JOIN tb_department USING ( department_no )
        JOIN tb_professor ON professor_no = coach_professor_no;

-- 12
-- 모든 학과의 학과별 학생 수를 확인할 수 있도록 만들기
CREATE VIEW vw_학과별학생수 AS
    SELECT
        department_name,
        COUNT(*) AS student_count
    FROM
             tb_student
        JOIN tb_department USING ( department_no )
    GROUP BY
        department_name;

-- 13
-- 위에서 생성한 학생일반정보 VIEW를 통해서 학번이 A213046인 학생의 이름을 본인이름으로 변경
UPDATE vw_학생일반정보
SET
    student_name = '한동휘'
WHERE
    student_no = 'A213046';
-- 14
-- 13번에서와 같이 VIEW를 통해 데이터가 변결되 수 있는 상황을 막으려면 VIEW를 어떻게 해야하는지
CREATE VIEW vw_학생일반정보 AS
    SELECT
        student_no,
        student_name,
        student_address
    FROM
        tb_student
    WHERE
        student_no = 'A213046'
WITH CHECK OPTION;
-- 15
-- 매년 수강신청 기가만 되면 특정 인기 과목들에 수강 신청이 몰려 문제가 되고 있다. 최근 3년을
-- 기준으로 수강인원이 가장 많았던 3 과목을 찾는 구문을 작성
SELECT
    class_no   AS 과목번호,
    class_name AS 과목이름,
    "누적수강생수(명)"
FROM
    (
        SELECT
            class_no,
            class_name,
            COUNT(*) "누적수강생수(명)"
        FROM
                 tb_class
            JOIN tb_grade USING ( class_no )
        WHERE
            term_no >= '2007/03'
        GROUP BY
            class_name,
            class_no
        ORDER BY
            3 DESC
    )
WHERE
    ROWNUM <= 3;