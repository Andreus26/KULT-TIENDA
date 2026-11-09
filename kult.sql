-- DDL: Creación del esquema y tablas
DROP DATABASE IF EXISTS kult;
CREATE DATABASE kult;
USE kult;

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE SET NULL
);

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    clave_hash VARCHAR(255) NOT NULL
);

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    total DECIMAL(12,2) NOT NULL,
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE detalle_pedido (
    id_pedido INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE
);

-- DML: Datos de prueba
INSERT INTO categorias (nombre) VALUES ('Camisetas'), ('Buzos');

INSERT INTO productos (nombre, precio, stock, id_categoria) VALUES 
('Camiseta Cyberpunk', 65000.00, 20, 1),
('Buzo Oversize Kult', 120000.00, 15, 2);

INSERT INTO usuarios (nombre, correo, clave_hash) VALUES 
('Andrés Beltrán', 'andres@example.com', 'hash_password_123');

INSERT INTO pedidos (estado, total, id_usuario) VALUES 
('Pagado', 185000.00, 1);

INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES 
(1, 1, 1, 65000.00),
(1, 2, 1, 120000.00);

-- Consulta DML con JOIN de prueba
SELECT 
    p.id_pedido,
    u.nombre AS cliente,
    pr.nombre AS producto,
    dp.cantidad,
    dp.precio_unitario,
    p.total AS total_pedido
FROM pedidos p
JOIN usuarios u ON p.id_usuario = u.id_usuario
JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido
JOIN productos pr ON dp.id_producto = pr.id_producto;
