-- 1
-- 학생이름과 주소지를 표시 헤더 "학생 이름", "주소지" 이름으로 오름차순
SELECT
    STUDENT_NAME    "학생 이름",
    STUDENT_ADDRESS 주소지
FROM
    TB_STUDENT
ORDER BY
    1 ASC;

-- 2
-- 휴학중인 학생들의 이름과 주민번호 나이가 적은순서로 출력
SELECT
    STUDENT_NAME,
    STUDENT_SSN
FROM
    TB_STUDENT
WHERE
    ABSENCE_YN = 'Y'
ORDER BY
    2 DESC;

-- 3
-- 주소지가 경기도, 강원도인 학생들중 1900년대 학번을 가진 학생들 이름 학번 주소 이름의 오름차순으로 출력
-- 출력 헤더 "학생이름", "학번", "거주지 주소"
SELECT
    STUDENT_NAME    학생이름,
    STUDENT_NO      학번,
    STUDENT_ADDRESS "거주지 주소"
FROM
    TB_STUDENT
WHERE
    ( STUDENT_ADDRESS LIKE '경기%'
      OR STUDENT_ADDRESS LIKE '강원%' )
    AND SUBSTR(STUDENT_NO, 1, 1) != 'A'
ORDER BY
    1;

-- 4
-- 법학과 교수 중 가장 나이가 많은 사람부터 출력 법학과의 '학과코드' 학과 테이블을 조회
SELECT
    PROFESSOR_NAME,
    PROFESSOR_SSN
FROM
    TB_PROFESSOR
WHERE
    DEPARTMENT_NO = '005'
ORDER BY
    2;

-- 5
-- 2004년 2학기에 'C3118100' 과목 수강한 학생들 학점 조회 학점이 높은 학생부터 표시하고 
-- 학점이 같으면 학번이 낮은 학생부터 표시
SELECT
    STUDENT_NO,
    POINT
FROM
    TB_GRADE
WHERE
        CLASS_NO = 'C3118100'
    AND TERM_NO = '200402'
ORDER BY
    2 DESC,
    STUDENT_NO;

-- 6
-- 학생 번호, 이름, 학과 이름을 학생 이름으로 오름차순 정렬
SELECT
    STUDENT_NO,
    STUDENT_NAME,
    DEPARTMENT_NAME
FROM
         TB_STUDENT
    JOIN TB_DEPARTMENT USING ( DEPARTMENT_NO )
ORDER BY
    2 ;

-- 7
-- 과목 이름과 과목의 학과 이름을 출력
SELECT
    CLASS_NAME,
    DEPARTMENT_NAME
FROM
         TB_CLASS
    JOIN TB_DEPARTMENT USING ( DEPARTMENT_NO );

-- 8
-- 과목병 교수 이름을 찾는다. 과목 이름과 교수 이름을 출력
SELECT
    C.CLASS_NAME,
    PROFESSOR_NAME
FROM
         TB_PROFESSOR A
    JOIN TB_CLASS_PROFESSOR B ON A.PROFESSOR_NO = B.PROFESSOR_NO
    JOIN TB_CLASS           C ON B.CLASS_NO = C.CLASS_NO
ORDER BY
    TB_CLASS.DEPARTMENT_NO ASC, 2 ASC;               

-- 9
-- 8번의 결과 중 '인문사회' 계열에 속한 과목의 교수 이름을 찾는다. 이에 해당하는 과목 이름과 교수 이름 출력
SELECT
    C.CLASS_NAME,
    PROFESSOR_NAME
FROM
         TB_PROFESSOR A
    JOIN TB_CLASS_PROFESSOR B ON A.PROFESSOR_NO = B.PROFESSOR_NO
    JOIN TB_CLASS           C ON B.CLASS_NO = C.CLASS_NO
    JOIN TB_DEPARTMENT      D ON C.DEPARTMENT_NO = D.DEPARTMENT_NO
WHERE
    D.CATEGORY = '인문사회'
ORDER BY
    2;

-- 10
-- '음악학과' 학생들의 평점 구하려 한다. 음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력
-- 평점은 소수점 1자리까지만 반올림하여 표시

-- 11
-- 학번이 A313047 인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한 학과 이름, 학생이름과 지도 교수
-- 이름이 필요하다. 출력헤더 "학과이름", "학생이름", "지도교수이름"

-- 12
-- 2007 년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생 리므과 수강학기 표시

-- 13
-- 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 그 과목 이름과 학과 이름 출력

-- 14
-- 서반아어학과 학생들의 지도교수를 게시하려한다. 학생이름과 지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우
-- "지도교수 미지정"으로 표시하도록 한다. 출력헤더 "학생이름", "지도교수"로 표시하며 고학번 학생이 먼저 표시되도록 한다.

-- 15
-- 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과이름, 평점을 출력

-- 16
-- 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 구문

-- 17
-- 재학중인 최경희 학생과 같은 과 학생들의 이름과 주소를 출력

-- 18
-- 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시
SELECT STUDENT_NO, STUDENT_NAME FROM(
SELECT STUDENT_NO, STUDENT_NAME, AVG(POINT) AS POINT
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO 
                        FROM TB_DEPARTMENT
                        WHERE DEPARTMENT_NAME = '국어국문학과'
                        )
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY POINT DESC
)
WHERE ROWNUM = 1;
-------------------------------------------------------------
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO 
                        FROM TB_DEPARTMENT
                        WHERE DEPARTMENT_NAME = '국어국문학과'
                        )
GROUP BY STUDENT_NO, STUDENT_NAME
HAVING AVG(POINT) = ( 
                        SELECT MAX(AVG(POINT))
                        FROM TB_STUDENT
                        JOIN TB_GRADE USING(STUDENT_NO)
                        WHERE DEPARTMENT_NO = '001'
                        GROUP BY STUDENT_NO                    
                    );


-- 19
-- "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을 파악하기 위한 적절한 구문 찾아내기
-- 출력헤더 "계열 학과명", "정공평점"으로 표시, 평점은 소수점 한 자리까지만 반올림하여 표시.