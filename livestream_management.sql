-- ========================================
-- LIVESTREAM MANAGEMENT DATABASE
-- ========================================

-- PHẦN 1: TẠO CSDL VÀ CÁC BẢNG

-- 1. Tạo CSDL
CREATE DATABASE IF NOT EXISTS livestream_management;
USE livestream_management;

-- 2. Tạo bảng Creator
CREATE TABLE Creator (
    creator_id VARCHAR(10) PRIMARY KEY,
    creator_name NVARCHAR(100) NOT NULL,
    creator_email VARCHAR(100),
    creator_phone VARCHAR(15),
    creator_platform NVARCHAR(50)
);

-- 3. Tạo bảng Studio
CREATE TABLE Studio (
    studio_id VARCHAR(10) PRIMARY KEY,
    studio_name NVARCHAR(100) NOT NULL,
    studio_location NVARCHAR(100),
    hourly_price DECIMAL(10, 2),
    studio_status NVARCHAR(50)
);

-- 4. Tạo bảng LiveSession
CREATE TABLE LiveSession (
    session_id INT PRIMARY KEY,
    creator_id VARCHAR(10) NOT NULL,
    studio_id VARCHAR(10) NOT NULL,
    session_date DATE,
    duration_hours INT,
    FOREIGN KEY (creator_id) REFERENCES Creator(creator_id),
    FOREIGN KEY (studio_id) REFERENCES Studio(studio_id)
);

-- 5. Tạo bảng Payment
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    session_id INT NOT NULL,
    payment_method NVARCHAR(50),
    payment_amount DECIMAL(10, 2),
    payment_date DATE,
    FOREIGN KEY (session_id) REFERENCES LiveSession(session_id)
);

-- ========================================
-- PHẦN 1.2: CHÈN DỮ LIỆU VÀO CÁC BẢNG
-- ========================================

-- Chèn dữ liệu vào bảng Creator
INSERT INTO Creator (creator_id, creator_name, creator_email, creator_phone, creator_platform) VALUES
('CR01', 'Nguyen Van A', 'a@live.com', '0901111111', 'Tiktok'),
('CR02', 'Tran Thi B', 'b@live.com', '0902222222', 'Youtube'),
('CR03', 'Le Minh C', 'c@live.com', '0903333333', 'Facebook'),
('CR04', 'Pham Thi D', 'd@live.com', '0904444444', 'Tiktok'),
('CR05', 'Vu Hoang E', 'e@live.com', '0905555555', 'Shopee live');

-- Chèn dữ liệu vào bảng Studio
INSERT INTO Studio (studio_id, studio_name, studio_location, hourly_price, studio_status) VALUES
('ST01', 'Studio A', 'Ha Noi', 20.00, 'Available'),
('ST02', 'Studio B', 'HCM', 25.00, 'Available'),
('ST03', 'Studio C', 'Danang', 30.00, 'Booked'),
('ST04', 'Studio D', 'Ha Noi', 22.00, 'Available'),
('ST05', 'Studio E', 'Can Tho', 18.00, 'Maintenance');

-- Chèn dữ liệu vào bảng LiveSession
INSERT INTO LiveSession (session_id, creator_id, studio_id, session_date, duration_hours) VALUES
(1, 'CR01', 'ST01', '2025-05-01', 3),
(2, 'CR02', 'ST02', '2025-05-02', 4),
(3, 'CR03', 'ST03', '2025-05-03', 2),
(4, 'CR01', 'ST04', '2025-05-04', 5),
(5, 'CR05', 'ST02', '2025-05-05', 1);

-- Chèn dữ liệu vào bảng Payment
INSERT INTO Payment (payment_id, session_id, payment_method, payment_amount, payment_date) VALUES
(1, 1, 'Cash', 60.00, '2025-05-01'),
(2, 2, 'Credit Card', 100.00, '2025-05-02'),
(3, 3, 'Bank Transfer', 60.00, '2025-05-03'),
(4, 4, 'Credit Card', 110.00, '2025-05-04'),
(5, 5, 'Cash', 25.00, '2025-05-05');

-- ========================================
-- PHẦN 1.3: CẬP NHẬT VÀ XÓA DỮ LIỆU
-- ========================================

-- 3. Cập nhật creator_platform của creator CR03 thành "YouTube"
UPDATE Creator 
SET creator_platform = 'YouTube' 
WHERE creator_id = 'CR03';

-- 4. Studio ST05 hoạt động trở lại: cập nhật status = 'Available' và giảm price 10%
UPDATE Studio 
SET studio_status = 'Available', hourly_price = hourly_price * 0.9 
WHERE studio_id = 'ST05';

-- 5. Xóa payment có payment_method = 'Cash' và payment_date trước 2025-05-03
DELETE FROM Payment 
WHERE payment_method = 'Cash' AND payment_date < '2025-05-03';

-- ========================================
-- PHẦN 2: TRUY VẤN DỮ LIỆU CƠ BẢN
-- ========================================

-- 6. Liệt kê studio có studio_status = 'Available' và hourly_price > 20
SELECT * FROM Studio 
WHERE studio_status = 'Available' AND hourly_price > 20;

-- 7. Lấy thông tin creator (creator_name, creator_phone) có nền tảng là TikTok
SELECT creator_name, creator_phone 
FROM Creator 
WHERE creator_platform = 'Tiktok';

-- 8. Hiển thị danh sách studio gồm studio_id, studio_name, hourly_price sắp xếp theo giá thuê giảm dần
SELECT studio_id, studio_name, hourly_price 
FROM Studio 
ORDER BY hourly_price DESC;

-- 9. Lấy 3 payment đầu tiên có payment_method = 'Credit Card'
SELECT * FROM Payment 
WHERE payment_method = 'Credit Card' 
LIMIT 3;

-- 10. Hiển thị danh sách creator gồm creator_id, creator_name bỏ qua 2 bản ghi đầu và lấy 2 bản ghi tiếp theo
SELECT creator_id, creator_name 
FROM Creator 
LIMIT 2 OFFSET 2;

-- ========================================
-- PHẦN 3: TRUY VẤN DỮ LIỆU NÂNG CAO
-- ========================================

-- 1. Hiển thị danh sách livestream gồm: session_id, creator_name, studio_name, duration_hours, payment_amount
SELECT 
    ls.session_id, 
    c.creator_name, 
    s.studio_name, 
    ls.duration_hours, 
    p.payment_amount
FROM LiveSession ls
JOIN Creator c ON ls.creator_id = c.creator_id
JOIN Studio s ON ls.studio_id = s.studio_id
JOIN Payment p ON ls.session_id = p.session_id;

-- 2. Liệt kê tất cả studio và số lần được sử dụng (kể cả studio chưa từng được thuê)
SELECT 
    s.studio_id, 
    s.studio_name, 
    COUNT(ls.session_id) AS usage_count
FROM Studio s
LEFT JOIN LiveSession ls ON s.studio_id = ls.studio_id
GROUP BY s.studio_id, s.studio_name;

-- 3. Tính tổng doanh thu theo từng payment_method
SELECT 
    payment_method, 
    SUM(payment_amount) AS total_revenue
FROM Payment
GROUP BY payment_method;

-- 4. Thống kê số session của mỗi creator chỉ hiển thị creator có từ 2 session trở lên
SELECT 
    c.creator_id, 
    c.creator_name, 
    COUNT(ls.session_id) AS session_count
FROM Creator c
JOIN LiveSession ls ON c.creator_id = ls.creator_id
GROUP BY c.creator_id, c.creator_name
HAVING COUNT(ls.session_id) >= 2;

-- 5. Lấy studio có hourly_price cao hơn mức trung bình của tất cả studio
SELECT * FROM Studio 
WHERE hourly_price > (SELECT AVG(hourly_price) FROM Studio);

-- 6. Hiển thị creator_name, creator_email của những creator đã từng livestream tại Studio B
SELECT DISTINCT 
    c.creator_name, 
    c.creator_email
FROM Creator c
JOIN LiveSession ls ON c.creator_id = ls.creator_id
JOIN Studio s ON ls.studio_id = s.studio_id
WHERE s.studio_name = 'Studio B';

-- 7. Hiển thị báo cáo tổng hợp gồm: session_id, creator_name, studio_name, payment_method, payment_amount
SELECT 
    ls.session_id, 
    c.creator_name, 
    s.studio_name, 
    p.payment_method, 
    p.payment_amount
FROM LiveSession ls
JOIN Creator c ON ls.creator_id = c.creator_id
JOIN Studio s ON ls.studio_id = s.studio_id
JOIN Payment p ON ls.session_id = p.session_id
ORDER BY ls.session_id;
