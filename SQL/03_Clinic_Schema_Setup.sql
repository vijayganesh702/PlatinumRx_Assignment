create table clinics(cid varchar(50) primary key,clinic_name varchar(100),city varchar(50),state varchar(50),country varchar(50));

create table customer(uid varchar(50) primary key,name varchar(30), mobile varchar(20));

create table clinic_sales(oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount DECIMAL(10,2),
    datetime DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid));
    
 CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description VARCHAR(255),
    amount DECIMAL(10,2),
    datetime DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);


insert into clinics(cid ,clinic_name ,city ,state ,country) values('cnc-0100001', 'XYZ clinic', 'lorem', 'ipsum' ,'dolor');

insert into customer(uid ,name , mobile) values('bk-09f3e-95hj ', 'Jon Doe','97XXXXXXXX');

insert into clinic_sales(oid ,uid,cid ,amount,datetime ,sales_channel) 
values('ord-00100-00100' ,'bk-09f3e-95hj' ,'cnc-0100001', 24999,
'2021-09-23 12:03:22',
'sodat');
    
insert into expenses (eid ,cid ,description ,amount , datetime) 
values('exp-0100-00100' ,'cnc-0100001','first-aid supplies' ,557,
'2021-09-23 7:36:48');
