/*
    TCL (TRANSACTION CONTROL LANGUAGE)
    
    * 트랜잭션(TRANSACTION)
    - 데이터베이스의 논리적인 작업 단위
    - 데이터릐 변경사항(DML)들을 하나의 트랜잭션으로 묶어서 처리
        => COMMIT(확정, 승인)하기 전까지 변경사항들을 모두 묶어서 하나의 트랜잭션으로 담음.
    - 트랜잭션의 대상이되는 SQL : INSERT, UPDATE, DELETE (DML)
    
    * 트랜잭션의 종류
    - COMMIT; : 하나의 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영하겠다는 것을 의미
                실제 DB에 반영시킨 후 트랜잭션은 비워진다. => 확정됨.
    - ROLLBACK; : 하나의 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영하지 않겠다는 것을 의미
                    트랜잭션에 담겨있는 변경사항도 다 삭제한후 마지막 COMMIT시점으로 돌아간다.
                    
    - SAVEPOINT; : 현재시점을 임시저장함.
    
    - ROLLBACK TO 포인트명 : 전체 변경사항을 삭제하는것이 아니라, SAVE포인트로 저장해놓은 시점으로 롤백함.
*/
SELECT
    *
FROM
    EMP_DEPT; -- 8명

-- 사번이 217번인 사원 삭제.
DELETE FROM EMP_DEPT
WHERE
    EMP_ID = '217';

-- 사번이 215번인 사원 삭제.
DELETE FROM EMP_DEPT
WHERE
    EMP_ID = '215';

ROLLBACK;
--------------------------------------------------------------------------
-- 사번이 200번인 사원 삭제.

DELETE FROM EMP_DEPT
WHERE
    EMP_ID = '200';

-- 사번이 800, 이름은 홍길동, 총무부 사원
INSERT INTO EMP_DEPT VALUES (
    800,
    '홍길동',
    '총부무'
);

COMMIT; -- 8명

SELECT
    *
FROM
    EMP_DEPT;

ROLLBACK;

--------------------------------------------------------------------------
DELETE FROM EMP_DEPT
WHERE
    EMP_ID IN ( 201, 202, 204 );

SELECT
    *
FROM
    EMP_DEPT; -- 5명

-- 3개행이 삭제된시점
SAVEPOINT SP1;

-- 사번이 801번, 김말똥, 인사부
INSERT INTO EMP_DEPT VALUES (
    801,
    '김말똥',
    '인사부'
);

DELETE FROM EMP_DEPT
WHERE
    EMP_ID = 205;

ROLLBACK TO SP1;

COMMIT;

-- 사번이 205, 209번인 사원 삭제
DELETE FROM EMP_DEPT
WHERE
    EMP_ID IN ( 205, 209 ); -- 3명

-- DDL : 자동으로 COMMIT
CREATE TABLE TEST (
    TID NUMBER
);

ROLLBACK; -- 205번,  209번 사원 데이터가 복구되지않음.

/*
    주의사항
    DDL구문 (CREATE, ALTER, DROP)등을 실행하는 순간
    기존에 트랜잭션에 있던 모든 변경사항들을 무조건 실제 DB에 반영(COMMIT)시킨후에 DDL이 수행됨.
    => 따라서 DDL 수행 전 변경사항이 있었다면 정확히 픽스를 하고 DDL 실행해야한다.
*/