create table users(user_id varchar(60) primary key,name varchar(100),phone_number varchar(15), 
                   mail_id varchar(50),billing_address text null); 
                   
create table bookings(booking_id varchar(60) primary key,booking_date datetime,room_no varchar(30), 
                   user_id varchar(60),foreign key(user_id) references users(user_id)); 
                  
create table booking_commercials (id varchar(50) primary key,booking_id varchar(60),bill_id varchar(50),bill_date datetime, 
                   item_id varchar(60),item_quantity integer,foreign key (booking_id) references booking(booking_id)); 
                   
create table items(item_id varchar(60) primary key, item_name varchar(100),item_rate decimal(5,2));
INSERT INTO users (user_id, name, phone_number, mail_id, billing_address)
VALUES ('21wrcxuy-67erfn', 'John Doe', '97XXXXXXXX', 'john.doe@example.co', NULL);

INSERT INTO bookings (booking_id, booking_date, room_no, user_id)
VALUES ('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn');

INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity)
VALUES ('q34r-3q4o8-q34u', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu', 3);

INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity)
VALUES ('q3o4-ahf32-o2u4', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1);

INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity)
VALUES ('134lr-oyfo8-3qk4', 'bk-q034-q4o', 'bl-34qhd-r7h8', '2021-09-23 12:05:37', 'itm-w978-23u4', 0.5);

INSERT INTO items (item_id, item_name, item_rate)
VALUES ('itm-a9e8-q8fu', 'Tawa Paratha', 18);

INSERT INTO items (item_id, item_name, item_rate)
VALUES ('itm-a07vh-aer8', 'Mix Veg', 89);
