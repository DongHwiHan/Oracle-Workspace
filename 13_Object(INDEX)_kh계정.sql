/*
    <INDEX>
    전체적인 DBMS 성능향상을 위한 설정
    
    책에서 '목차'같은녀석
    
    만약에 목차가 없다면, 내가원하는 챕터, 페이지가 어디에 있는지 책을 하나하나 훑어 봐야함.
    
    마찬가지로 테이블에서 JOIN 혹은 서브쿼리로 데이터를 조회할때
    인덱스가 없다면 테이블의 모든 데이터를(FULL-SCAN) 하나하나 뒤져서 내가 원하는 데이터를 가져올것.
    
    따라서 인덱스 설정을 해두면 모든 테이블의 행들을 뒤지지 않고 내가 원하는 조건만 빠르게 가져올수 있다.
    
    인덱스의 특징
    1) 인덱스로 설정한 칼럼의 데이터들을 별도로 "오름차순으로 정렬"하여 특적메모리 공간에 물리적 주소와 함께 저장시킨다.
*/

-- 현재 계정에 생성된 인덱스들 확인.
SELECT
    *
FROM
    USER_INDEXES; -- PK설정시 자동으로 인덱스 생성됨.
-- 현재 계정에서 인덱스와, 인덱스가 적용 된 칼럼을 확인.
SELECT
    *
FROM
    USER_IND_COLUMNS;

-- 실행계획 : DBMS 특정 쿼리문을 실행하는데 있어서 실행할 계획
SELECT
    *
FROM
         EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID -- CARINALITY 10 / 25 
WHERE
    EMP_NAME = '선동일';
-- 우리가 인덱스생성했다고 해서, 그 인덱스를 활용할지 말지 옵티마이저가 판단을 하게됨.

CREATE INDEX IND_EMPLOYEE ON
    EMPLOYEE (
        EMP_NAME
    );

CREATE INDEX IND_EMPLOYEE_DEPT ON
    EMPLOYEE (
        EMP_NAME,
        DEPT_CODE
    );

ALTER TABLE EMPLOYEE ADD FOREIGN KEY ( DEPT_CODE )
    REFERENCES DEPARTMENT;

DROP INDEX IND_EMPLOYEE;

DROP INDEX IND_EMPLOYEE_DEPT;

SELECT
    *
FROM
    EMPLOYEE
WHERE
        EMP_NAME = '박나라'
    AND DEPT_CODE = 'D5';

/*
    인덱스를 효율적으로 쓰기 위한 방법.
    데이터의 분포도가 높고, 조건절에 자주호출되며, 중복값이 적은 칼럼 => PK 칼럼
    
    1) 조건절 에 자주 등장하는 컬럼
    2) 항상 = 으로 비교되는 칼럼
    3) 중복되는 데이터가 최소한인 칼럼 ( == 분포도가 높은)
    4) ORDER BY절에 자주 사용되는 칼럼
    5) JOIN조건으로 자주 사용되는 칼럼
    
    인덱스의 장점
    
    1) WHERE 절에 인덱스의 칼럼을 사용하게되면 훨씬 빠르게 연산할수 있음.
    
    2) ORDER BY 연산을 사용할 필요가 없다(이미 정렬되어있음)
    
    3) MIN , MAX등의 집계할수로 값을 찾을때 연산속도가 매우 빠름.(정렬되어있기때문에)
    
    인덱스의 단점
    1) DML에 취약함.
     INSERT, UPDATE, DELETE등 데이터가 새롭게 추가,삭제가되면 인덱스테이블안에있는값들도 다시 정렬하고,
     ROWID(물리적주소)값도 수정해줘야함.
     
    2) INDEX를 이용한 INDEX-SCAN보다 단순한 FULL-SCAN이 더 유리할때가 있다.
    일반적으로 테이블의 전체데이터중 10~15%의 데이터를 처리해야하는 경우에만 인덱스가 효율적임
    
    3) 인덱스가 많을수록 저장공간을 잡아먹음.
    인덱스를 만들면 만들수록 저장공간이 부족해지게 되므로, 적절한 수준을 유지해야한다.
*/