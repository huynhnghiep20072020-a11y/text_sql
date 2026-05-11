CREATE DATABASE DSTEST;
USE DSTEST;
CREATE TABLE Creator(
creator_id VARCHAR(5) PRIMARY KEY NOT NULL,
creator_name VARCHAR(100) NOT NULL,
creator_eamil VARCHAR(100)  UNIQUE NOT NULL,
creator_phone VARCHAR(15) UNIQUE NOT NULL,
creator_platfrom VARCHAR(50) NOT NULL
);
CREATE TABLE Studio(
studio_id VARCHAR(5) PRIMARY KEY NOT NULL,
studio_name VARCHAR(100) NOT NULL,
studio_location VARCHAR(100) NOT NULL,
hourly_price DECIMAL(10,2) NOT NULL,
studio_status VARCHAR(20) NOT NULL
);
CREATE TABLE LiveSession(
session_id INT PRIMARY KEY NOT NULL auto_increment,
creator_id VARCHAR(5) NOT NULL,
studio_id VARCHAR(5) NOT NULL,
session_date DATE NOT NULL,
duration_hours INT NOT NULL,
FOREIGN KEY (creator_id) REFERENCES Creator(creator_id) ON DELETE CASCADE,
FOREIGN KEY (studio_id) REFERENCES Studio(studio_id) ON DELETE CASCADE
);
CREATE TABLE Payment(
payment_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
session_id INT NOT NULL,
payment_method VARCHAR(50) NOT NULL,
payment_amount DECIMAL(10,2) NOT NULL,
payment_date DATE NOT NULL,
FOREIGN KEY (session_id) REFERENCES LiveSession(session_id) ON DELETE CASCADE
);

INSERT INTO Creator (creator_id,creator_name,creator_phone,creator_email,creator_platfrom) value
('CR01','Nguyen Van A','a@live.com', '0901111111','Tiktok'),
('CR02','Nguyen Van A','b@live.com', '0902222222','Youtube'),
('CR03','Nguyen Van A','c@live.com', '0903333333','Facebook'),
('CR04','Nguyen Van A','d@live.com', '0904444444','Tiktok'),
('CR05','Nguyen Van A','e@live.com', '0905555555','Shopee live')
;
INSERT INTO Studio (studio_id,studio_name,studio_location,hourly_price,studio_status)VALUE
('ST01','Studio A','Ha Noi','20.00','Available'),
('ST02','Studio B','HCM','25.00','Available'),
('ST03','Studio C','Da Nang','30.00','Booked'),
('ST04','Studio D','Ha Noi','22.00','Available'),
('ST05','Studio E','Can Tho','18.00','Maintenance')
;
INSERT INTO LiveSession (session_id,creator_id,studio_id,session_date,duration_hours) VALUE 
('1','CR01','ST01','2025-05-01','3'),
('2','CR02','ST02','2025-05-02','4'),
('3','CR03','ST03','2025-05-03','2'),
('4','CR04','ST04','2025-05-04','5'),
('5','CR05','ST05','2025-05-05','1')
;
INSERT INTO Payment (payment_id, session_id, payment_method,payment_amount,payment_date) VALUE
('1','1','Cash','60.00','2025-05-01'),
('2','2','Credit Card','100.00','2025-05-02'),
('3','3','Bank Transfer','60.00','2025-05-03'),
('4','4','Credit Card','110.00','2025-05-04'),
('5','5','Cash','25.00','2025-05-05')
;

UPDATE Creator SET creator_platfrom ='Youtube' WHERE creator_id ='CR03';
UPDATE Studio SET studio_status ='Available',hourly_price =hourly_price *0.9 WHERE studio_id ='ST05';
DELETE FROM Payment WHERE payment_method ='Cash' AND payment_date <2025-05-03;

SELECT * FROM Studio WHERE studio_status = 'Available' AND hourly_price > 20 ;
SELECT creator_name,creator_phone FROM Creator WHERE creator_platfrom ='TikTok';
SELECT studio_id,creator_name,hourly_price FROM Studio ORDER BY hourly_price DESC;
SELECT*FROM Payment WHERE creator_method ='Credit Card' LIMIT 3;
SELECT creator_id,creator_name FROM Creator LIMIT 2 OFFSET 2;
