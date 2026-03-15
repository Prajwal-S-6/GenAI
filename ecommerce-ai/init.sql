-- Tables
CREATE TABLE categories (
                            id   SERIAL PRIMARY KEY,
                            name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
                          id             SERIAL PRIMARY KEY,
                          name           VARCHAR(200) NOT NULL,
                          category_id    INT REFERENCES categories(id),
                          price          DECIMAL(10,2) NOT NULL,
                          cost           DECIMAL(10,2) NOT NULL,
                          stock_quantity INT NOT NULL DEFAULT 0,
                          sku            VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE customers (
                           id         SERIAL PRIMARY KEY,
                           first_name VARCHAR(100) NOT NULL,
                           last_name  VARCHAR(100) NOT NULL,
                           email      VARCHAR(200) UNIQUE NOT NULL,
                           city       VARCHAR(100)
);

CREATE TABLE orders (
                        id           SERIAL PRIMARY KEY,
                        customer_id  INT REFERENCES customers(id),
                        status       VARCHAR(20),
                        total_amount DECIMAL(10,2),
                        created_at   TIMESTAMP DEFAULT NOW()
);

CREATE TABLE order_items (
                             id         SERIAL PRIMARY KEY,
                             order_id   INT REFERENCES orders(id),
                             product_id INT REFERENCES products(id),
                             quantity   INT NOT NULL,
                             unit_price DECIMAL(10,2) NOT NULL
);

-- Categories
INSERT INTO categories (name) VALUES
                                  ('Electronics'), ('Clothing'), ('Books'), ('Sports'), ('Beauty');

-- Products
INSERT INTO products (name, category_id, price, cost, stock_quantity, sku) VALUES
                                                                               ('iPhone 15 Pro',         1, 134900, 90000, 45,  'APPL-IP15P'),
                                                                               ('Samsung Galaxy S24',    1, 79999,  55000, 60,  'SMSNG-GS24'),
                                                                               ('Sony Headphones WH5',   1, 29999,  18000, 80,  'SONY-WH5'),
                                                                               ('MacBook Air M3',        1, 114900, 80000, 20,  'APPL-MBA-M3'),
                                                                               ('USB-C Hub 7in1',        1, 2499,   800,   200, 'MISC-USBHUB'),
                                                                               ('Levi 511 Jeans',        2, 3499,   1200,  150, 'LEV-511'),
                                                                               ('Nike Air Force 1',      2, 7995,   3500,  120, 'NIKE-AF1'),
                                                                               ('Yoga Pants Women',      2, 1799,   600,   180, 'YGA-PNTW'),
                                                                               ('Polo T-Shirt 3pack',    2, 1299,   400,   250, 'POLO-3PK'),
                                                                               ('Atomic Habits',         3, 599,    150,   400, 'BK-ATOM'),
                                                                               ('Pragmatic Programmer',  3, 1299,   300,   180, 'BK-PRAG'),
                                                                               ('System Design Interview',3,1499,   350,   160, 'BK-SYSDES'),
                                                                               ('Zero to One',           3, 499,    120,   220, 'BK-ZERO'),
                                                                               ('Yoga Mat Premium',      4, 1299,   400,   200, 'YGA-MAT'),
                                                                               ('Whey Protein 2kg',      4, 2499,   1100,  140, 'NUTR-WHEY'),
                                                                               ('Resistance Bands Set',  4, 799,    250,   180, 'BAND-SET'),
                                                                               ('Vitamin C Serum',       5, 899,    250,   220, 'BEAU-VCS'),
                                                                               ('Sunscreen SPF50',       5, 499,    150,   350, 'BEAU-SPF'),
                                                                               ('Moisturizer Neutrogena',5, 399,    100,   400, 'NEUT-MST'),
-- Dead stock items
                                                                               ('Fax Machine Legacy',    1, 8999,   5000,  5,   'FAX-LGCY'),
                                                                               ('VHS Player',            1, 3499,   2000,  8,   'VHS-PLYR'),
                                                                               ('Smart Home Hub v1',     1, 14999,  9000,  10,  'SMRT-HUB');

-- Customers
INSERT INTO customers (first_name, last_name, email, city) VALUES
                                                               ('Arjun',    'Sharma',   'arjun.sharma@gmail.com',   'Bengaluru'),
                                                               ('Priya',    'Nair',     'priya.nair@gmail.com',     'Mumbai'),
                                                               ('Rohit',    'Verma',    'rohit.verma@gmail.com',    'Delhi'),
                                                               ('Sneha',    'Patel',    'sneha.patel@gmail.com',    'Ahmedabad'),
                                                               ('Karan',    'Mehta',    'karan.mehta@gmail.com',    'Pune'),
                                                               ('Divya',    'Rao',      'divya.rao@gmail.com',      'Hyderabad'),
                                                               ('Vikram',   'Singh',    'vikram.singh@gmail.com',   'Jaipur'),
                                                               ('Ananya',   'Gupta',    'ananya.gupta@gmail.com',   'Bengaluru'),
                                                               ('Rahul',    'Kapoor',   'rahul.kapoor@gmail.com',   'Noida'),
                                                               ('Meera',    'Iyer',     'meera.iyer@gmail.com',     'Chennai');

-- Orders
INSERT INTO orders (customer_id, status, created_at) VALUES
                                                         (1, 'delivered', NOW() - INTERVAL '120 days'),
                                                         (2, 'delivered', NOW() - INTERVAL '100 days'),
                                                         (3, 'delivered', NOW() - INTERVAL '80 days'),
                                                         (4, 'delivered', NOW() - INTERVAL '60 days'),
                                                         (5, 'delivered', NOW() - INTERVAL '45 days'),
                                                         (6, 'delivered', NOW() - INTERVAL '30 days'),
                                                         (7, 'delivered', NOW() - INTERVAL '20 days'),
                                                         (8, 'delivered', NOW() - INTERVAL '15 days'),
                                                         (9, 'shipped',   NOW() - INTERVAL '5 days'),
                                                         (10,'confirmed', NOW() - INTERVAL '2 days'),
                                                         (1, 'delivered', NOW() - INTERVAL '10 days'),
                                                         (2, 'returned',  NOW() - INTERVAL '25 days'),
                                                         (3, 'delivered', NOW() - INTERVAL '35 days'),
                                                         (4, 'cancelled', NOW() - INTERVAL '50 days'),
                                                         (5, 'delivered', NOW() - INTERVAL '7 days');

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
                                                                         (1, 1, 1, 134900), (1, 5, 1, 2499),
                                                                         (2, 7, 1, 7995),   (2, 6, 1, 3499),
                                                                         (3, 10, 3, 599),   (3, 11, 1, 1299),
                                                                         (4, 17, 2, 899),   (4, 18, 1, 499),
                                                                         (5, 14, 1, 1299),  (5, 15, 1, 2499),
                                                                         (6, 10, 2, 599),   (6, 13, 1, 499),
                                                                         (7, 2, 1, 79999),
                                                                         (8, 17, 1, 899),   (8, 19, 2, 399),
                                                                         (9, 3, 1, 29999),
                                                                         (10, 9, 3, 1299),
                                                                         (11, 1, 1, 134900),(11, 5, 2, 2499),
                                                                         (12, 7, 1, 7995),
                                                                         (13, 10, 5, 599),  (13, 12, 1, 1499),
                                                                         (14, 14, 1, 1299),
                                                                         (15, 16, 2, 799),  (15, 15, 1, 2499);

-- Update totals
UPDATE orders o
SET total_amount = (
    SELECT SUM(quantity * unit_price)
    FROM order_items
    WHERE order_id = o.id
);

-- Handy view
CREATE VIEW product_sales_summary AS
SELECT
    p.id,
    p.name,
    c.name                                         AS category,
    p.price,
    p.cost,
    p.stock_quantity,
    COALESCE(SUM(oi.quantity), 0)                  AS total_units_sold,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0)  AS total_revenue,
    COALESCE(SUM(oi.quantity*(oi.unit_price - p.cost)), 0) AS total_profit
FROM products p
         JOIN categories c ON p.category_id = c.id
         LEFT JOIN order_items oi ON p.id = oi.product_id
         LEFT JOIN orders o ON oi.order_id = o.id
    AND o.status NOT IN ('cancelled', 'returned')
GROUP BY p.id, p.name, c.name, p.price, p.cost, p.stock_quantity;