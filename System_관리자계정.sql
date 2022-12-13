-- DDL 공부할 새로운 계정 만들기
CREATE USER DDL iDENTIFIED BY DDL;
CREATE USER KH IDENTIFIED BY KH;

/*
계정 생성하는 구문. 일반사용자 계정은 오직 관리자 계정에서 만들수 있음.
생성방법[표현법]
CREATE USER 계정명 IDENTIFIED BY 비밀번호;
*/

-- 작업을하기위한 최소한의 권한
-- 부여한 권한 : 접속, 데이터 관리
-- [표현법] GRANT 권한1, 권한2, 권한3, TO 계쩡명;
GRANT CONNECT, RESOURCE TO DDL;
GRANT CONNECT, RESOURCE TO KH;

/*  
    관리자 계쩡 : DB의 생성과 관리를 담당하는 계정이며, 모든권한과 책임을 가지는계정
    사용자 계정 : DB의 대해서 질의, 갱신, 보고서 작성등의 작업을 수행할 수 있는 계정, 업무에 필요한 최소한의 권한만 가지는것을 원칙으로함.
    
    ROLE : 권한
    CONNECT : 사용자가 데이터베이스에 접속 가능하도록 하기 위한 CREATE SESSION권한이 있는 ROLE
    RESOURCE : CREATE 구문을 통해 객체를 생성할 수 있는 권한과, INSERT, UPDATE, DELETE 구문을 사용할 수 있는 권한을 모아놓은 ROLE
*/