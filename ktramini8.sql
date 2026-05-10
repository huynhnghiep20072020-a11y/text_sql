
CREATE DATABASE IF NOT EXISTS BookStoreDB;
USE BookStoreDB;

CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE Book (
    book_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    title VARCHAR(150) NOT NULL,
    status INT DEFAULT 1,
    publish_date DATE,
    price DECIMAL(15,2),
    category_id INT,
    author_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE BookOrder (
    order_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    customer_name VARCHAR(200) NOT NULL,
    book_id INT,
    order_date DATE DEFAULT (CURRENT_DATE),
    delivery_date DATE,
    CONSTRAINT fk_bookorder_book FOREIGN KEY (book_id) REFERENCES Book(book_id) ON DELETE CASCADE,
    CONSTRAINT chk_delivery_date CHECK (delivery_date IS NULL OR delivery_date >= order_date)
);

-- Bài 2: Thay đổi cấu trúc bảng (DDL)
-- Lưu ý: author_name đã được thêm ở định nghĩa bảng Book phía trên
ALTER TABLE BookOrder
    MODIFY customer_name VARCHAR(200) NOT NULL;

ALTER TABLE BookOrder
    ADD CONSTRAINT chk_delivery_date_order CHECK (delivery_date IS NULL OR delivery_date >= order_date);

-- Bài 3: Thao tác dữ liệu (DML)
INSERT INTO Category (category_name, description) VALUES
('IT & Tech', 'Sách lập trình'),
('Business', 'Sách kinh doanh'),
('Novel', 'Tiểu thuyết');

INSERT INTO Book (title, status, publish_date, price, category_id, author_name) VALUES
('Clean Code', 1, '2020-05-10', 500000, 1, 'Robert C. Martin'),
('Đắc Nhân Tâm', 0, '2018-08-20', 150000, 2, 'Dale Carnegie'),
('JavaScript Nâng cao', 1, '2023-01-15', 350000, 1, 'Kyle Simpson'),
('Nhà Giả Kim', 0, '2015-11-25', 120000, 3, 'Paulo Coelho');

INSERT INTO BookOrder (customer_name, book_id, order_date, delivery_date) VALUES
('Nguyen Hai Nam', 1, '2025-01-10', '2025-01-15'),
('Tran Bao Ngoc', 3, '2025-02-05', '2025-02-10'),
('Le Hoang Yen', 4, '2025-03-12', NULL);

UPDATE Book
SET price = price + 50000
WHERE category_id = 1;

UPDATE BookOrder
SET delivery_date = '2025-12-31'
WHERE delivery_date IS NULL;

DELETE FROM BookOrder
WHERE order_date < '2025-02-01';

-- Bài 4: Truy vấn dữ liệu nâng cao
-- 4.1 CASE & AS
SELECT title,
       author_name,
       CASE WHEN status = 1 THEN 'Còn hàng' WHEN status = 0 THEN 'Hết hàng' ELSE 'Không xác định' END AS status_name
FROM Book;

-- 4.2 Hàm hệ thống: viết hoa title + số năm xuất bản
SELECT UPPER(title) AS title_upper,
       author_name,
       TIMESTAMPDIFF(YEAR, publish_date, CURRENT_DATE) AS years_since_publish
FROM Book;

-- 4.3 INNER JOIN
SELECT b.title,
       b.price,
       c.category_name
FROM Book b
INNER JOIN Category c ON b.category_id = c.category_id;

-- 4.4 ORDER BY & LIMIT
SELECT title,
       price
FROM Book
ORDER BY price DESC
LIMIT 2;

-- 4.5 GROUP BY & HAVING
SELECT c.category_name,
       COUNT(b.book_id) AS book_count
FROM Book b
INNER JOIN Category c ON b.category_id = c.category_id
GROUP BY c.category_name
HAVING COUNT(b.book_id) >= 2;

-- 4.6 Scalar Subquery
SELECT title,
       price
FROM Book
WHERE price > (SELECT AVG(price) FROM Book);

-- 4.7 IN Operator Subquery
SELECT DISTINCT b.book_id,
                b.title,
                b.price,
                b.author_name
FROM Book b
WHERE b.book_id IN (SELECT book_id FROM BookOrder);

-- 4.8 Correlated Subquery
SELECT b.title,
       b.price,
       b.category_id
FROM Book b
WHERE b.price = (
    SELECT MAX(b2.price)
    FROM Book b2
    WHERE b2.category_id = b.category_id
);
