const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// Konfigurasi Koneksi MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'toko_online'
});

db.connect((err) => {
  if (err) throw err;
  console.log('Database MySQL Terhubung!');
});

// Endpoint: Ambil Semua Produk
app.get('/api/products', (req, res) => {
  db.query('SELECT * FROM products', (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
});

// Endpoint: Buat Pesanan Baru (Checkout)
app.post('/api/orders', (req, res) => {
  const { user_id, total_price, tax, grand_total, payment_method, items } = req.body;

  const orderQuery = 'INSERT INTO orders (user_id, total_price, tax, grand_total, payment_method) VALUES (?, ?, ?, ?, ?)';
  db.query(orderQuery, [user_id, total_price, tax, grand_total, payment_method], (err, result) => {
    if (err) return res.status(500).json(err);

    const orderId = result.insertId;
    const itemValues = items.map(item => [orderId, item.id, item.qty, item.price]);
    const itemsQuery = 'INSERT INTO order_items (order_id, product_id, quantity, price) VALUES ?';

    db.query(itemsQuery, [itemValues], (err2) => {
      if (err2) return res.status(500).json(err2);
      res.json({ message: 'Pesanan berhasil dibuat', orderId });
    });
  });
});

// Endpoint Admin: Ambil Semua Pesanan & Total Penjualan
app.get('/api/admin/orders', (req, res) => {
  const query = `
    SELECT orders.*, users.name as user_name 
    FROM orders 
    JOIN users ON orders.user_id = users.id 
    ORDER BY orders.created_at DESC
  `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
});

// Endpoint Admin: Ubah Status Pesanan
app.put('/api/admin/orders/:id/status', (req, res) => {
  const { status } = req.body;
  db.query('UPDATE orders SET status = ? WHERE id = ?', [status, req.params.id], (err, result) => {
    if (err) return res.status(500).json(err);
    res.json({ message: 'Status pesanan diperbarui' });
  });
});

// Endpoint Admin: Hapus Pesanan
app.delete('/api/admin/orders/:id', (req, res) => {
  db.query('DELETE FROM orders WHERE id = ?', [req.params.id], (err, result) => {
    if (err) return res.status(500).json(err);
    res.json({ message: 'Pesanan berhasil dihapus' });
  });
});

app.listen(3000, () => {
  console.log('Server berjalan pada port 3000');
});