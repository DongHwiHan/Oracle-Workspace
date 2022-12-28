/*
    <트리거>
    내가 지정한 테이블에 INSERT, DELETE등의 DML문에 의해 변경사항이 발생하였을때
    자동으로 매번 실행할 내용을 미리 정의해둘수 있는 객체.
    
    EX)
    회원 탈퇴시 기존의 회원테이블에 데이터 DELETE후 곧바로 탈퇴된 회원들만 따로 보관하는 테이블에 자동으로 INSERT처리해야한다.
    신고횟수가 일정 수를 넘었을때 묵시적으로 해당 회원을 블랙리스트 처리되게끔.    
    입출고에 대한 데이터가 기록될때마다(INSERT될때마다) 해당상품에 대한 재고수량을 매번 수정 (UPDATE)해야 될때 등.
    
    * 트리거 종류
    SQL문의 시행시기데 따른 분류
    > BEFORE TRIGGER : 내가 지정한 테이블에 이벤트(INSERT, UPDATE, DELETE)가 발생되기전에 트리거실행
    > AFTER TRIGGER : 내가 지정한 테이블에 이벤트가 발생된 후에 트리거 실행.
    
    SQL문의 의해 영향을 받는 각 행에 따른 분류
    > STATEMENT TRIGGER(ANSWKDXMFLRJ) : 이벤트가 발생한 SQL문에 대해 딱 한번만 트리거 실행
    > ROW TRIGGER(행트리거) : 해당 SQL문이 실행될때마다 매번 트리거 실행(FOR EACH ROW옵션 기술해야됨)
                > : OLD - BEFORE UPDATE(수정전 자료), BEFORE DELETE(삭제전 자료)
                > : NEW - AFTER INSERT(추가된 자료), AFTER UPDATE(수정후 자료)
                
    * 트리거 생성구문
    [표현법]
    CREATE OR REPLACE TRIGGER 트리거명
    BEFORE|AFTER INSERT|DELETE|UPDATE ON 테이블명
    [FOR EACH ROW]
    DECLARE
        변수선언;
    BEGIN
        실행내용(해당 위에 지정한 이벤트 발생시 자동으로 실행할구문)
    EXCEPTION
    END;
    /
*/
-- 상품 입고 및 출고 관련 예시
-- 필요한 테이블 및 시퀀스 생성.

-- 1. 상품에 대한 데이터를 보관할 테이블(TB_PRODUCT)
CREATE TABLE TB_PRODUCT (
    PCODE NUMBER PRIMARY KEY, -- 상품번호
    PNAME VARCHAR2(30) NOT NULL, -- 상품명
    BRAND VARCHAR2(30) NOT NULL, -- 브랜드명
    PRICE NUMBER, -- 가격
    STOCK NUMBER DEFAULT 0 -- 수량
);

-- 상품번호 중복 안되게끔 매번 새로운 번호를 발새시키는 시퀀스
CREATE SEQUENCE SEQ_PCODE START WITH 200 INCREMENT BY 5 NOCACHE;

INSERT INTO TB_PRODUCT VALUES (
    SEQ_PCODE.NEXTVAL,
    '갤럭시Z플립4',
    '삼성',
    99000, DEFAULT
);

INSERT INTO TB_PRODUCT VALUES (
    SEQ_PCODE.NEXTVAL,
    '갤럭시S23',
    '삼성',
    1500000,
    10
);

INSERT INTO TB_PRODUCT VALUES (
    SEQ_PCODE.NEXTVAL,
    '아이폰14',
    '애플',
    1400000, DEFAULT
);

SELECT
    *
FROM
    TB_PRODUCT;

COMMIT;

-- 2. 상품 입출고 상세 이력 테이블(TB_PRODETAIL)
--      어떤 상품이 어떤날짜에 몇개가 입고, 출고가 되었는지 정보를 기록
CREATE TABLE TB_PRODETAIL (
    DCODE  NUMBER PRIMARY KEY, -- 이력번호
    PCODE  NUMBER
        REFERENCES TB_PRODUCT,
    PDATE  DATE NOT NULL, -- 상품 입출고일 날짜
    AMOUNT NUMBER NOT NULL, -- 입출고한 상품의 수량
    STATUS CHAR(6) CHECK ( STATUS IN ( '입고', '출고' ) ) -- 상태
);

-- 이력번호로 매번 새로운번호를 발생시켜 들어갈수 있게 도와주는 시퀀스
CREATE SEQUENCE SEQ_DCODE NOCACHE;

-- 200번 상품이 오늘 날짜로 10개 입고
INSERT INTO TB_PRODETAIL VALUES (
    SEQ_DCODE.NEXTVAL,
    205,
    SYSDATE,
    10,
    '입고'
);

SELECT
    *
FROM
    TB_PRODETAIL;

-- TB_PRODUCT 테이블에서 200번 상품 10개를 증가시키는 UPDATE문 실행
UPDATE TB_PRODUCT
SET
    STOCK = STOCK + 10
WHERE
    PCODE = 205;

COMMIT;

-- 205번 상품이 오늘날짜로 20개 입고

INSERT INTO TB_PRODETAIL VALUES (
    SEQ_DCODE.NEXTVAL,
    210,
    SYSDATE,
    20,
    '입고'
);

UPDATE TB_PRODUCT
SET
    STOCK = STOCK + 20
WHERE
    PCODE = 215;

SELECT
    *
FROM
    TB_PRODUCT;

/* 
    TB_PRODETAIL 테이블에 INSERT이벤트 발생시
    TB_PRODUCT테이블에 재고수량이 자동으로 UPDATE되게끔 트리거 만들기.
    
    - 상품이 입고된경우 -> 해당 상품을 찾아서 재고수량을 증가 UPDATE +
    
    - 상품이 출고된경우 -> 해당 상품을 찾아서 재고수량을 감소 UPDATE - 
*/
CREATE OR REPLACE TRIGGER TRG_01 AFTER
    INSERT ON TB_PRODETAIL
    FOR EACH ROW
BEGIN
    -- 상품이 입고된 경우 -> 재고수량을 증가시켜줘야함
    IF ( :NEW.STATUS = '입고' ) THEN
        UPDATE TB_PRODUCT
        SET
            STOCK = STOCK + :NEW.AMOUNT -- NEW키워드 활용해서 TB_PRODETAIL에 인서트된 값을 활용할수 있다.
        WHERE
            PCODE = :NEW.PCODE;

    ELSE
         -- 상품이 출고된 경우 -> 재고수량을 감소시켜줘야함.
        UPDATE TB_PRODUCT
        SET
            STOCK = STOCK - :NEW.AMOUNT
        WHERE
            PCODE = :NEW.PCODE;

    END IF;
END;
/

-- 210번 상품이 오늘날짜로 7개를 출고
INSERT INTO TB_PRODETAIL VALUES (
    SEQ_DCODE.NEXTVAL,
    210,
    SYSDATE,
    7,
    '출고'
);

SELECT
    *
FROM
    TB_PRODUCT;

-- 205번 상품이 오늘날짜로 100개를 입고
INSERT INTO TB_PRODETAIL VALUES (
    SEQ_DCODE.NEXTVAL,
    205,
    SYSDATE,
    100,
    '입고'
);

-- 205번 상품이 오늘날짜로 90개를 출고
INSERT INTO TB_PRODETAIL VALUES (
    SEQ_DCODE.NEXTVAL,
    205,
    SYSDATE,
    90,
    '출고'
);

SELECT
    *
FROM
    TB_PRODUCT;

/*
    트리거 장점
    1. 데이터 추가, 수정, 삭제시 자동으로 데이터관리를 해줌으로써 무결성보장
    2. 데이터 베이스 관리의 자동화
    
    트리거 단점
    1.빈번한 추가, 수정, 삭제시 ROW의 삽입, 추가, 삭제가 함께실행되므로 성능상 좋지 못함.
    2. 관리적 측면에서 형상관리가 "불가능"하기 때문에 관리가 불편하다.
    3. 트리거를 남용하게되면 예상치 못한 사태가 발생할수 있으며 유지보수가 힘들다.
*/