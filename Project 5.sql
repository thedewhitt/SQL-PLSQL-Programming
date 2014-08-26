<!-- Erik Gonzalez-DeWhitt -->
<!-- CSCI-N311 -->
<!-- Project 5 -->

<!-- STEP ONE -->
create table PHONE_USERS (
	TELEPHONE_NUMBER		VARCHAR2(80) NOT NULL,
	FIRST_NAME				VARCHAR2(80),
	LAST_NAME				VARCHAR2(80),
	KEYMAP_LASTNAME		CHAR(4),
	PASSWORD				VARCHAR2(80),
	constraint PHONE_USERS_PK PRIMARY KEY(TELEPHONE_NUMBER),
	constraint PHONE_USERS_UQ UNIQUE(LAST_NAME)
);

<!-- STEP TWO -->
create or replace function KEYMAP (lname in VARCHAR2)
	return VARCHAR2
	is
	trans_lname VARCHAR2(4);
begin
	select translate( RPAD(LAST_NAME, 4, '0'), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', '22233344455566677778889999') into trans_lname
		from PHONE_USERS
		where LAST_NAME = lname;
	return(trans_lname); 
end;
/


<!-- STEP THREE -->
create table BBT_USERS_TEMP as
select * from LINGLU.BBT_USERS_TEMP;
 

create or replace procedure BBTtoPHONEU (n in NUMBER) 
is
  num NUMBER := n;
begin
  execute immediate 'truncate table PHONE_USERS';
  while num > 0
  loop
    insert into PHONE_USERS (TELEPHONE_NUMBER, FIRST_NAME, LAST_NAME, KEYMAP_LASTNAME, PASSWORD)
      select '(' + substr(TELEPHONE_NUMBER, 0, 3) + ') -' + substr(TELEPHONE_NUMBER, 3, 3) + '-' + substr(TELEPHONE_NUMBER, -1 , 3),
      FIRST_NAME, LAST_NAME + '000' + TO_CHAR(num),  KEYMAP(LAST_NAME), PASSWORD
      from BBT_USERS_TEMP;
    num := num - 1;
  end loop;
end;
/

<!--STEP FOUR -->
create or replace package PROJECT5
as 
  function KEYMAP (lname in VARCHAR2) return VARCHAR2;
  procedure BBTtoPHONEU (n in NUMBER);
end PROJECT5;
/