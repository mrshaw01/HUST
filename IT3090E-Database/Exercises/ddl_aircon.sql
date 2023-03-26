-- drop table if exists customers, invoices, products, technicians, interventions cascade;


create table customers (
cust_no integer not null check ( cust_no > 100 ),
name char(30) not null , 
surname char(30),
address char(50) not null,
primary key(cust_no)
);

create table invoices(
 inv_no integer not null ,
 date date not null ,
 state char(1) not null default 'C' check ( state in ('R','C')),
 customer integer references customers(cust_no) on delete cascade on update cascade,
 primary key(inv_no)
);

create table products (
 reference char(5) not null  check ( reference like 'DT%'),
 designation char(50) not null,
 unit_price numeric (9,2) not null,
 stock_quantity integer,
 min_quantity integer,
 primary key(reference) );

create table technicians(
	tech_no smallint not null,
	name text,
	hour_rate float not null,
	primary key (tech_no) );


create table interventions ( 
	interv_no integer not null ,
	date date not null,
	technician integer not null references technicians (tech_no) on update cascade on delete cascade ,
	duration float not null check ( duration >0 AND  duration <=8),
	invoice integer not null ,
	primary key( interv_no),
	foreign key (invoice) references invoices(inv_no) on delete cascade on update cascade
	 
);

create table replacements (
	product char(5) not null check ( product like 'DT%'),
	intervention integer not null  ,
	qtity smallint,
	primary key (product, intervention),
	foreign key (product) references products(reference) on update cascade on delete cascade,
	foreign key(intervention) references interventions(interv_no) on update cascade on delete cascade );


insert into technicians values (1, 'Saultier',20.15 ),(2, 'Bonnaz',24.35 ),
(3, 'Mauras',30.12 ),(4, 'Crespin',35.13 ),(5,'Foucher',19.67);


insert into customers VALUES  ( 105,'Dallalon','Jean','5 Rue Jean Moulin');
insert into customers VALUES  ( 101,'Rivoire',null,'18 rue ronde');
insert into customers VALUES  ( 102,'Favero','André','43 rue Beaujolais');
insert into customers VALUES  ( 103,'Provent','Catherine','38 rue du stade');
insert into customers VALUES  ( 104,'Labric',null,'35 rue des fleurs');
insert into customers VALUES  ( 110,'Drouillon',null,'64 rue des Abricotiers');

insert into invoices values ( 1000,'01/01/2003','R', 101);
insert into invoices values ( 1001,'12/02/2003','R',101);
insert into invoices values ( 1002,'17/03/2003','R',102);
insert into invoices values ( 1003,'24/04/2003','R',102);
insert into invoices values ( 1004,'16/05/2003','R',102);
insert into invoices values ( 1005,'08/07/2003','R',103);
insert into invoices values ( 1006,'08/07/2003','R',101);
insert into invoices values ( 1007,'15/07/2003','R',105);
insert into invoices values ( 1008,'15/07/2003','R',104);
insert into invoices values ( 1009,'22/07/2003','C',103);
insert into invoices values ( 1010,'22/07/2003','C',102);
insert into invoices values ( 1011,'29/07/2003','C',104);
insert into invoices values ( 1012,'30/08/2003','R',103);
insert into invoices values ( 1013,'19/10/2003','R',101);


insert into products values ( 'DT010','Disjoncteur 10A',7.21);
insert into products values ( 'DT180','Bloc Huger',6.12);
insert into products values ( 'DT802','Boite controle',68.35);
insert into products values ( 'DT711','cellule',25.36);
insert into products values ( 'DT125','Bloc Soc',6.89);
insert into products values ( 'DT015','Disjoncteur 15A',14.94);
insert into products values ( 'DT205','Bruleur Huger',153.37);
insert into products values ( 'DT310','bruleur soc',200.20);
insert into products values ( 'DT120','Connecteur',20.35);
insert into products values ( 'DT568','Routeur',199.00);



insert into  interventions values ( 1039,'03/07/2003',1,1,1001);
insert into  interventions values ( 1040,'03/07/2003',1,1,1002);
insert into  interventions values ( 1041,'03/07/2003',1,2,1002);
insert into  interventions values ( 1042,'03/07/2003',1,1,1003);
insert into  interventions values ( 1043,'03/07/2003',1,2,1005);
insert into  interventions values ( 1044,'04/07/2003',2,0.5,1006);
insert into  interventions values ( 1045,'08/07/2003',2,1.5,1007);
insert into  interventions values ( 1046,'10/07/2003',3,1,1007);
insert into  interventions values ( 1047,'11/07/2003',3,2,1008);
insert into  interventions values ( 1048,'15/07/2003',4,1,1009);
insert into  interventions values ( 1049,'18/07/2003',4,1.5,1010);
insert into  interventions values ( 1050,'22/07/2003',5,0.5,1011);
insert into  interventions values ( 1051,'23/07/2003',5,2.5,1011);
insert into  interventions values ( 1052,'29/07/2003',5,1.5,1011);

insert into replacements values ('DT802',1043,1);
insert into replacements values ('DT711',1043,2);
insert into replacements values ('DT180',1043,1);
insert into replacements values ('DT205',1044,1);
insert into replacements values ('DT125',1045,2);
insert into replacements values ('DT010',1045,1);
insert into replacements values ('DT310',1046,1);
insert into replacements values ('DT711',1047,3);
insert into replacements values ('DT120',1047,2);
insert into replacements values ('DT015',1048,1);
insert into replacements values ('DT180',1049,4);
insert into replacements values ('DT711',1049,2);
insert into replacements values ('DT205',1050,1);
insert into replacements values ('DT711',1051,2);
insert into replacements values ('DT120',1051,1);
insert into replacements values ('DT120',1052,3);
