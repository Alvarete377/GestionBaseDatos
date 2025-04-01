connect PACA/paca@DB

drop table TEQUIERO;

create table TEQUIERO(id_tq number(5));
insert into TEQUIERO(id_tq) values (1);
insert into TEQUIERO(id_tq) values (2);
insert into TEQUIERO(id_tq) values (3);
grant update on TEQUIERO to PACO;

connect PACO/paco@DB

update PACA.TEQUIERO
set id_tq = 4
where id_tq = 1;