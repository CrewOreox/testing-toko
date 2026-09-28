CREATE DATABASE IF NOT EXISTS toko_online;
USE toko_online;

-- ==========================================
-- 1. STRUKTUR TABEL
-- ==========================================

-- Tabel Users (Customer & Admin)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Products
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    image_url VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Cart (Keranjang Belanja Persisten)
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY user_product_unique (user_id, product_id)
);

-- Tabel Orders
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_price DECIMAL(12, 2) NOT NULL,
    tax DECIMAL(12, 2) NOT NULL,
    grand_total DECIMAL(12, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status ENUM('Menunggu Pembayaran', 'Diproses', 'Dikirim', 'Selesai', 'Dibatalkan') DEFAULT 'Diproses',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tabel Order Items
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- ==========================================
-- 2. DATA DUMMY AWAL
-- ==========================================

-- Insert Users
INSERT INTO users (name, email, password, role) VALUES 
('Admin Toko', 'admin@toko.com', 'admin123', 'admin'),
('Rizki Setiawan', 'user@toko.com', 'user123', 'user');

-- Insert Products
INSERT INTO products (name, price, image_url, description) VALUES
('Sepatu Sneakers Trendy', 250000, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff', 'Sepatu kasual nyaman digunakan sehari-hari.'),
('Kemeja Polos Casual', 150000, 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c', 'Kemeja bahan katun premium adem.'),
('Jam Tangan Elegan', 450000, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30', 'Jam tangan analog tahan air.'),
('Tas Ransel Modern', 200000, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62', 'Tas laptop multifungsi.'),
('Topi Snapback', 750000, 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b', 'Topi kasual gaya kekinian.'),
('Kacamata Hitam UV', 120000, 'https://images.unsplash.com/photo-1511499767150-a48a237f0083', 'Pelindung dari sinar UV.');

-- Insert Contoh Isi Keranjang (Milik User ID: 2)
INSERT INTO cart (user_id, product_id, quantity) VALUES 
(2, 1, 1),
(2, 3, 2);