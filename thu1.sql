-- ==============================================================================
-- KHỞI TẠO CƠ SỞ DỮ LIỆU
-- ==============================================================================
CREATE DATABASE IF NOT EXISTS HackathonDB;
USE HackathonDB;

-- ==============================================================================
-- PHẦN 1: TẠO BẢNG VÀ CHÈN DỮ LIỆU (DDL & DML)
-- ==============================================================================

-- 1. Tạo bảng Creator [cite: 187]
CREATE TABLE Creator (
    creator_id VARCHAR(5) PRIMARY KEY,
    creator_name VARCHAR(100) NOT NULL,
    creator_email VARCHAR(100) UNIQUE NOT NULL,
    creator_phone VARCHAR(15) UNIQUE NOT NULL,
    creator_platform VARCHAR(50) NOT NULL
);

-- 2. Tạo bảng Studio [cite: 189]
CREATE TABLE Studio (
    studio_id VARCHAR(5) PRIMARY KEY,
    studio_name VARCHAR(100) NOT NULL,
    studio_location VARCHAR(100) NOT NULL,
    hourly_price DECIMAL(10,2) NOT NULL,
    studio_status VARCHAR(20) NOT NULL
);

-- 3. Tạo bảng LiveSession [cite: 191]
CREATE TABLE LiveSession (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    creator_id VARCHAR(5) NOT NULL,
    studio_id VARCHAR(5) NOT NULL,
    session_date DATE NOT NULL,
    duration_hours INT NOT NULL,
    FOREIGN KEY (creator_id) REFERENCES Creator(creator_id) ON DELETE CASCADE,
    FOREIGN KEY (studio_id) REFERENCES Studio(studio_id) ON DELETE CASCADE
);

-- 4. Tạo bảng Payment [cite: 193]
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    session_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (session_id) REFERENCES LiveSession(session_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------------------------
-- CHÈN DỮ LIỆU VÀO CÁC BẢNG [cite: 197]
-- ------------------------------------------------------------------------------

-- Chèn dữ liệu bảng Creator [cite: 198]
INSERT INTO Creator (creator_id, creator_name, creator_email, creator_phone, creator_platform) VALUES
('CR01', 'Nguyen Van A', 'a@live.com', '0901111111', 'Tiktok'),
('CR02', 'Tran Thi B', 'b@live.com', '0902222222', 'Youtube'),
('CR03', 'Le Minh C', 'c@live.com', '0903333333', 'Facebook'),
('CR04', 'Pham Thi D', 'd@live.com', '0904444444', 'Tiktok'),
('CR05', 'Vu Hoang E', 'e@live.com', '0905555555', 'Shopee live');

-- Chèn dữ liệu bảng Studio [cite: 199]
INSERT INTO Studio (studio_id, studio_name, studio_location, hourly_price, studio_status) VALUES
('ST01', 'Studio A', 'Ha Noi', 20.00, 'Available'),
('ST02', 'Studio B', 'HCM', 25.00, 'Available'),
('ST03', 'Studio C', 'Danang', 30.00, 'Booked'),
('ST04', 'Studio D', 'Ha Noi', 22.00, 'Available'),
('ST05', 'Studio E', 'Can Tho', 18.00, 'Maintenance');

-- Chèn dữ liệu bảng LiveSession [cite: 200]
INSERT INTO LiveSession (session_id, creator_id, studio_id, session_date, duration_hours) VALUES
(1, 'CR01', 'ST01', '2025-05-01', 3),
(2, 'CR02', 'ST02', '2025-05-02', 4),
(3, 'CR03', 'ST03', '2025-05-03', 2),
(4, 'CR01', 'ST04', '2025-05-04', 5),
(5, 'CR05', 'ST02', '2025-05-05', 1);

-- Chèn dữ liệu bảng Payment [cite: 201]
INSERT INTO Payment (payment_id, session_id, payment_method, payment_amount, payment_date) VALUES
(1, 1, 'Cash', 60.00, '2025-05-01'),
(2, 2, 'Credit Card', 100.00, '2025-05-02'),
(3, 3, 'Bank Transfer', 60.00, '2025-05-03'),
(4, 4, 'Credit Card', 110.00, '2025-05-04'),
(5, 5, 'Cash', 25.00, '2025-05-05');

-- ------------------------------------------------------------------------------
-- CẬP NHẬT VÀ XÓA DỮ LIỆU
-- ------------------------------------------------------------------------------

-- 1. Cập nhật creator_platform của CR03 thành "YouTube" [cite: 202]
UPDATE Creator 
SET creator_platform = 'YouTube' 
WHERE creator_id = 'CR03';

-- 2. Cập nhật trạng thái và giảm 10% giá thuê của ST05 [cite: 203]
UPDATE Studio 
SET studio_status = 'Available', hourly_price = hourly_price * 0.9 
WHERE studio_id = 'ST05';

-- 3. Xóa các payment thanh toán bằng Cash trước ngày 2025-05-03 
DELETE FROM Payment 
WHERE payment_method = 'Cash' AND payment_date < '2025-05-03';


-- ==============================================================================
-- PHẦN 2: TRUY VẤN DỮ LIỆU CƠ BẢN [cite: 206]
-- ==============================================================================

-- 1. Liệt kê studio có trạng thái Available và giá > 20 [cite: 207]
SELECT * FROM Studio 
WHERE studio_status = 'Available' AND hourly_price > 20;

-- 2. Lấy thông tin creator có nền tảng là Tiktok [cite: 208]
SELECT creator_name, creator_phone 
FROM Creator 
WHERE creator_platform = 'Tiktok';

-- 3. Hiển thị danh sách studio sắp xếp theo giá thuê giảm dần [cite: 209]
SELECT studio_id, studio_name, hourly_price 
FROM Studio 
ORDER BY hourly_price DESC;

-- 4. Lấy 3 payment đầu tiên thanh toán bằng Credit Card [cite: 210]
SELECT * FROM Payment 
WHERE payment_method = 'Credit Card' 
LIMIT 3;

-- 5. Bỏ qua 2 bản ghi đầu và lấy 2 bản ghi tiếp theo (LIMIT OFFSET) [cite: 211]
SELECT creator_id, creator_name 
FROM Creator 
LIMIT 2 OFFSET 2;


-- ==============================================================================
-- PHẦN 3: TRUY VẤN DỮ LIỆU NÂNG CAO [cite: 212]
-- ==============================================================================

-- 1. Danh sách livestream chi tiết (dùng LEFT JOIN với Payment để không bị mất phiên live nếu bị xóa thanh toán) [cite: 213]
SELECT ls.session_id, c.creator_name, s.studio_name, ls.duration_hours, p.payment_amount
FROM LiveSession ls
JOIN Creator c ON ls.creator_id = c.creator_id
JOIN Studio s ON ls.studio_id = s.studio_id
LEFT JOIN Payment p ON ls.session_id = p.session_id;

-- 2. Liệt kê tất cả studio và số lần sử dụng (kể cả chưa thuê) -> Anti-Join / LEFT JOIN [cite: 215]
SELECT s.studio_id, s.studio_name, COUNT(ls.session_id) AS usage_count
FROM Studio s
LEFT JOIN LiveSession ls ON s.studio_id = ls.studio_id
GROUP BY s.studio_id, s.studio_name;

-- 3. Tính tổng doanh thu theo từng phương thức thanh toán [cite: 217]
SELECT payment_method, SUM(payment_amount) AS total_revenue
FROM Payment
GROUP BY payment_method;

-- 4. Thống kê số session của mỗi creator, chỉ lấy ai có từ 2 session trở lên [cite: 218]
SELECT c.creator_id, c.creator_name, COUNT(ls.session_id) AS total_sessions
FROM Creator c
JOIN LiveSession ls ON c.creator_id = ls.creator_id
GROUP BY c.creator_id, c.creator_name
HAVING COUNT(ls.session_id) >= 2;

-- 5. Studio có giá cao hơn mức trung bình (Scalar Subquery) [cite: 219]
SELECT * FROM Studio
WHERE hourly_price > (
    SELECT AVG(hourly_price) FROM Studio
);

-- 6. Thông tin creator từng livestream tại Studio B [cite: 220]
SELECT DISTINCT c.creator_name, c.creator_email
FROM Creator c
JOIN LiveSession ls ON c.creator_id = ls.creator_id
JOIN Studio s ON ls.studio_id = s.studio_id
WHERE s.studio_name = 'Studio B';

-- 7. Báo cáo tổng hợp [cite: 221]
SELECT ls.session_id, c.creator_name, s.studio_name, p.payment_method, p.payment_amount
FROM LiveSession ls
JOIN Creator c ON ls.creator_id = c.creator_id
JOIN Studio s ON ls.studio_id = s.studio_id
LEFT JOIN Payment p ON ls.session_id = p.session_id;