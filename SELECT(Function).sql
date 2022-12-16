--1.
-- 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른 순으로 표시
-- (헤더 "학번", "이름", "입학년도")
SELECT
    STUDENT_NO                           AS "학번",
    STUDENT_NAME                         AS "이름",
    TO_CHAR(ENTRANCE_DATE, 'YYYY-MM-DD') AS 입학년도
FROM
    TB_STUDENT
WHERE
    DEPARTMENT_NO = 002
ORDER BY
    ENTRANCE_DATE; 

--2.
-- 교수 중 이름이 세 글자가 아닌 교수의 이름과 주민번호 화면에 출력
SELECT
    PROFESSOR_NAME,
    PROFESSOR_SSN
FROM
    TB_PROFESSOR
WHERE
    LENGTH(PROFESSOR_NAME) != 3
ORDER BY
    PROFESSOR_NAME;

--3.
-- 남자 교수들의 이름과 나이 출력 단, 나이가 적은 사람에서 많은 사람 순서로
-- ( 2000년 이후 출생자 없으며 헤더 "교수이름", "나이" / 나이는 '만'으로 계산
SELECT
    PROFESSOR_NAME                                                    AS "교수이름",
    TO_CHAR(SYSDATE, 'YYYY') - ( SUBSTR(PROFESSOR_SSN, 1, 2) + 1900 ) AS "나이"
FROM
    TB_PROFESSOR
WHERE
    SUBSTR(PROFESSOR_SSN, 8, 1) = 1
ORDER BY
    PROFESSOR_SSN DESC;

--4.
-- 교수 이름 중 성을 제외한 이름만 출력 (출력 헤더 "이름"/ 성이 2자인 교수 없음)
SELECT
    SUBSTR(PROFESSOR_NAME, 2, 2) AS "이름"
FROM
    TB_PROFESSOR;

--5.
-- 재수생 입학자 구하려고함 이때, 19살에 입학하면 재수를 하지 않은 것으로 간주
SELECT
    STUDENT_NO,
    STUDENT_NAME
FROM
    TB_STUDENT
WHERE
    TO_CHAR(ENTRANCE_DATE, 'YYYY') - TO_CHAR(TO_DATE(SUBSTR(STUDENT_SSN, 1, 6),
        'RRMMDD'), 'RRRR') > 19;
                                            

--6.
-- 2020년 크리스마스는 무슨 요일인가?
SELECT
    NEXT_DAY('20201220', '금')
FROM
    DUAL;

--7.
-- 각 구문들은 각각 몇 년 몇 월 몇 일을 의미할까?
SELECT
    TO_DATE('99/10/11', 'YY/MM/DD'), -- 2099/10/11
    TO_DATE('49/10/11', 'YY/MM/DD'), -- 2049/10/11
    TO_DATE('99/10/11', 'RR/MM/DD'), -- 1999/10/11
    TO_DATE('49/10/11', 'RR/MM/DD') -- 2049/10/11
FROM
    DUAL;

--8.
-- 2000년도 이후 입학자들은 학번이 A로 시작. 그 이전 학번을 받은 학생들의
-- 학번과 이름을 출력
SELECT
    STUDENT_NO,
    STUDENT_NAME
FROM
    TB_STUDENT
WHERE
    SUBSTR(STUDENT_NO, 1, 1) != 'A'
ORDER BY
    STUDENT_NO;

--9.
-- 학번 A517178 인 학생의 학점 총 평점 헤더는 "평점" 점수는 반올림 후 소수점 한자리
SELECT
    ROUND(SUM(POINT) / 8,
          1) AS "평점"
FROM
    TB_GRADE
WHERE
    STUDENT_NO = 'A517178';

--10.
-- 학과별 학생수 출력 헤더 "학과번호", "학생수(명)"
SELECT
    DEPARTMENT_NO        AS "학과번호",
    COUNT(DEPARTMENT_NO) AS "학생수(명)"
FROM
    TB_STUDENT
GROUP BY
    DEPARTMENT_NO
ORDER BY
    DEPARTMENT_NO;

--11.
-- 지도교수 배정 못 받은 학생의 수 몇 명 정도 되는지 출력
SELECT
    COUNT(*)
FROM
    TB_STUDENT
WHERE
    COACH_PROFESSOR_NO IS NULL;

--12.
-- 학번 A112113인 학생의 년도 별 평점 출력 헤더 "년도", "년도 별 평점" 점수 반올림 후 소수점 한 자리
SELECT
    SUBSTR(TERM_NO, 1, 4) AS "년도",
    ROUND(AVG(POINT),
          1)              AS "년도 별 평점"
FROM
    TB_GRADE
WHERE
    STUDENT_NO = 'A112113'
GROUP BY
    SUBSTR(TERM_NO, 1, 4)
ORDER BY
    SUBSTR(TERM_NO, 1, 4);

--13.
-- 학과 별 휴학생 수를 파악하고자함 한과 번호와 휴학생 수를 출력
SELECT
    DEPARTMENT_NO     AS "학과코드명",
    COUNT(ABSENCE_YN) AS "휴학생 수"
FROM
    TB_STUDENT
GROUP BY
    DEPARTMENT_NO,
    ABSENCE_YN
HAVING
    ABSENCE_YN = 'Y'
ORDER BY
    DEPARTMENT_NO;

--14.
-- 동명이인 학생들의 이름 출력
SELECT
    STUDENT_NAME        AS "동일이름",
    COUNT(STUDENT_NAME) AS "동명인 수"
FROM
    TB_STUDENT
GROUP BY
    STUDENT_NAME
HAVING
    COUNT(STUDENT_NAME) > 1
ORDER BY
    STUDENT_NAME;

--15.
-- 학번 A112113 학생의 년도, 학기 별 평점과 년도 별 누적 평점, 총 평점 출력
-- (평점 반올림 후 소수점 한 자리)
SELECT
    SUBSTR(TERM_NO, 1, 4) AS "년도",
    SUBSTR(TERM_NO, 5, 2) AS "학기",
    ROUND(AVG(POINT),
          1)              AS "평점"
FROM
    TB_GRADE
WHERE
    STUDENT_NO = 'A112113'
GROUP BY
    ROLLUP(SUBSTR(TERM_NO, 1, 4),
           SUBSTR(TERM_NO, 5, 2))
ORDER BY
    1,
    2;