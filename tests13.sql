CREATE DATABASE cntt5_session13;

USE cntt5_session13;

CREATE TABLE users (
	id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    total_paid DECIMAL(10, 0) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 0) DEFAULT 0,
    stock INT DEFAULT 0,

    CONSTRAINT ck_price CHECK (price >= 0),
    CONSTRAINT ck_stock CHECK (stock >= 0)
);

CREATE TABLE orders (
	id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    total_payment DECIMAL(10, 0) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_detail (
	id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,

    CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 10 dữ liệu cho bảng users
INSERT INTO users (fullname, email, total_paid) VALUES
('Nguyen Van An', 'an.nguyen@gmail.com', 1500000),
('Tran Thi Bich', 'bich.tran@gmail.com', 3200000),
('Le Hoang Nam', 'nam.le@gmail.com', 2750000),
('Pham Minh Khoa', 'khoa.pham@gmail.com', 4100000),
('Vo Thanh Tung', 'tung.vo@gmail.com', 980000),
('Do Thi Lan', 'lan.do@gmail.com', 5200000),
('Huynh Gia Bao', 'bao.huynh@gmail.com', 1850000),
('Nguyen Quoc Viet', 'viet.nguyen@gmail.com', 2300000),
('Tran Minh Duc', 'duc.tran@gmail.com', 3600000),
('Pham Thu Hang', 'hang.pham@gmail.com', 1250000);

-- 10 dữ liệu cho bảng products
INSERT INTO products (name, price, stock) VALUES
('iPhone 15 Pro Max', 34990000, 12),
('Samsung Galaxy S24', 24990000, 20),
('MacBook Air M3', 31990000, 8),
('Dell XPS 13', 28990000, 6),
('Tai nghe AirPods Pro', 6490000, 25),
('Chuột Logitech MX Master 3S', 2490000, 18),
('Bàn phím Keychron K6', 2190000, 14),
('Màn hình LG UltraWide 29 inch', 5990000, 9),
('Ổ cứng SSD Samsung 1TB', 2890000, 30),
('Loa JBL Charge 5', 3990000, 11);


DELIMITER $$
CREATE TRIGGER calculate_total_payment
AFTER INSERT ON order_detail
FOR EACH ROW
BEGIN

	DECLARE product_price DECIMAL(10, 0);

	SELECT price INTO product_price 
    FROM products WHERE id = NEW.product_id;

    UPDATE orders SET total_payment = total_payment + product_price
    WHERE id = NEW.order_id;

END $$

DELIMITER ;

INSERT INTO order_detail (order_id, product_id) VALUES (1, 3);

DELIMITER //
CREATE TRIGGER UpdateOrderTotal_AfterProductPriceChange
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.price <> OLD.price THEN
        UPDATE orders o SET o.total_payment = o.total_payment + (NEW.price - OLD.price) * (SELECT COUNT(*)FROM order_detail od WHERE od.order_id = o.id AND od.product_id = NEW.id)
        WHERE o.id IN (SELECT DISTINCT order_id FROM order_detail WHERE product_id = NEW.id);
    END IF;
END //

DELIMITER ;

ALTER TABLE orders ADD COLUMN status VARCHAR(20) DEFAULT 'pending';
DELIMITER //

CREATE TRIGGER HandleSuccessfulPayment
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF NEW.status = 'success' AND OLD.status = 'pending' THEN

        UPDATE users SET total_paid = total_paid + NEW.total_payment WHERE id = NEW.user_id;
        UPDATE products p SET p.stock = p.stock - (SELECT COUNT(*) FROM order_detail od WHERE od.product_id = p.id AND od.order_id = NEW.id)
        WHERE p.id IN (SELECT product_id FROM order_detail WHERE order_id = NEW.id);

    END IF;
END //
DELIMITER ;
