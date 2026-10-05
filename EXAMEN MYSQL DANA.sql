-- =====================================================
-- CAMPUS PIZZA
-- ESTRUCTURA, DATOS Y CONSULTAS EN MYSQL
-- =====================================================

DROP DATABASE IF EXISTS campus_pizza;

CREATE DATABASE campus_pizza
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE campus_pizza;


-- =====================================================
-- 1. CLIENTES
-- =====================================================

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100) UNIQUE,
    
    PRIMARY KEY (id_cliente)
);


-- =====================================================
-- 2. CATEGORÍAS
-- =====================================================

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    
    PRIMARY KEY (id_categoria)
);


-- =====================================================
-- 3. PRODUCTOS
-- =====================================================

CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10,2) NOT NULL,
    elaborado BOOLEAN NOT NULL DEFAULT TRUE,
    id_categoria INT NOT NULL,
    
    PRIMARY KEY (id_producto),
    
    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria)
);


-- =====================================================
-- 4. INGREDIENTES
-- =====================================================

CREATE TABLE ingrediente (
    id_ingrediente INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    
    PRIMARY KEY (id_ingrediente)
);


-- =====================================================
-- 5. PRODUCTO - INGREDIENTE
-- Relación muchos a muchos
-- =====================================================

CREATE TABLE producto_ingrediente (
    id_producto INT,
    id_ingrediente INT,
    cantidad VARCHAR(50),
    
    PRIMARY KEY (id_producto, id_ingrediente),
    
    CONSTRAINT fk_pi_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto),
        
    CONSTRAINT fk_pi_ingrediente
        FOREIGN KEY (id_ingrediente)
        REFERENCES ingrediente(id_ingrediente)
);


-- =====================================================
-- 6. ADICIONES
-- =====================================================

CREATE TABLE adicion (
    id_adicion INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    precio DECIMAL(10,2) NOT NULL,
    
    PRIMARY KEY (id_adicion)
);


-- =====================================================
-- 7. COMBOS
-- =====================================================

CREATE TABLE combo (
    id_combo INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10,2) NOT NULL,
    
    PRIMARY KEY (id_combo)
);


-- =====================================================
-- 8. PRODUCTOS QUE PERTENECEN A UN COMBO
-- =====================================================

CREATE TABLE combo_producto (
    id_combo INT,
    id_producto INT,
    cantidad INT NOT NULL DEFAULT 1,
    
    PRIMARY KEY (id_combo, id_producto),
    
    CONSTRAINT fk_cp_combo
        FOREIGN KEY (id_combo)
        REFERENCES combo(id_combo),
        
    CONSTRAINT fk_cp_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
);


-- =====================================================
-- 9. PEDIDOS
-- =====================================================

CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_consumo ENUM('RECOGER', 'COMER_EN_LOCAL') NOT NULL,
    estado ENUM('PENDIENTE', 'PREPARANDO', 'LISTO', 'ENTREGADO', 'CANCELADO')
        NOT NULL DEFAULT 'PENDIENTE',
    
    PRIMARY KEY (id_pedido),
    
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);


-- =====================================================
-- 10. DETALLE DEL PEDIDO
-- Aquí se guardan los productos comprados
-- =====================================================

CREATE TABLE detalle_pedido (
    id_detalle INT AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_producto INT,
    id_combo INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    
    PRIMARY KEY (id_detalle),
    
    CONSTRAINT fk_detalle_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido(id_pedido),
        
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto),
        
    CONSTRAINT fk_detalle_combo
        FOREIGN KEY (id_combo)
        REFERENCES combo(id_combo)
);


-- =====================================================
-- 11. ADICIONES UTILIZADAS EN LOS PEDIDOS
-- =====================================================

CREATE TABLE detalle_adicion (
    id_detalle INT,
    id_adicion INT,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    
    PRIMARY KEY (id_detalle, id_adicion),
    
    CONSTRAINT fk_da_detalle
        FOREIGN KEY (id_detalle)
        REFERENCES detalle_pedido(id_detalle),
        
    CONSTRAINT fk_da_adicion
        FOREIGN KEY (id_adicion)
        REFERENCES adicion(id_adicion)
);


-- =====================================================
-- 12. MENÚ
-- =====================================================

CREATE TABLE menu (
    id_menu INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    
    PRIMARY KEY (id_menu)
);


-- =====================================================
-- 13. PRODUCTOS DISPONIBLES EN EL MENÚ
-- =====================================================

CREATE TABLE menu_producto (
    id_menu INT,
    id_producto INT,
    
    PRIMARY KEY (id_menu, id_producto),
    
    CONSTRAINT fk_mp_menu
        FOREIGN KEY (id_menu)
        REFERENCES menu(id_menu),
        
    CONSTRAINT fk_mp_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
);


-- =====================================================
-- 14. COMBOS DISPONIBLES EN EL MENÚ
-- =====================================================

CREATE TABLE menu_combo (
    id_menu INT,
    id_combo INT,
    
    PRIMARY KEY (id_menu, id_combo),
    
    CONSTRAINT fk_mc_menu
        FOREIGN KEY (id_menu)
        REFERENCES menu(id_menu),
        
    CONSTRAINT fk_mc_combo
        FOREIGN KEY (id_combo)
        REFERENCES combo(id_combo)
);


-- =====================================================
-- INSERCIÓN DE DATOS DE PRUEBA (DML)
-- =====================================================

-- Clientes
INSERT INTO cliente (nombre, telefono, correo) VALUES
('Carlos Gómez', '3001234567', 'carlos.gomez@email.com'),
('María Rodríguez', '3109876543', 'maria.rodriguez@email.com'),
('Andrés López', '3155554433', 'andres.lopez@email.com');

-- Categorías
INSERT INTO categoria (nombre) VALUES
('Pizzas Tradicionales'),
('Pizzas Especiales'),
('Bebidas'),
('Entradas');

-- Productos
INSERT INTO producto (nombre, descripcion, precio, elaborado, id_categoria) VALUES
('Pizza Pepperoni', 'Queso mozzarella y abundante pepperoni', 35000.00, TRUE, 1),
('Pizza Hawaiana', 'Queso mozzarella, jamón y piña', 32000.00, TRUE, 1),
('Pizza Campus Suprema', 'Pepperoni, jamón, champiñones y pimentón', 42000.00, TRUE, 2),
('Gaseosa 1.5L', 'Gaseosa familiar fría', 7000.00, FALSE, 3),
('Pan de Ajo', 'Porción de 4 panes con mantequilla de ajo y orégano', 10000.00, TRUE, 4);

-- Ingredientes
INSERT INTO ingrediente (nombre) VALUES
('Queso Mozzarella'),
('Pepperoni'),
('Jamón'),
('Piña'),
('Champiñones'),
('Salsa de Tomate');

-- Producto - Ingrediente
INSERT INTO producto_ingrediente (id_producto, id_ingrediente, cantidad) VALUES
(1, 1, '200g'),
(1, 2, '100g'),
(1, 6, '80g'),
(2, 1, '200g'),
(2, 3, '80g'),
(2, 4, '100g'),
(2, 6, '80g');

-- Adiciones
INSERT INTO adicion (nombre, precio) VALUES
('Extra Mozzarella', 5000.00),
('Salsa de Ajo Extra', 2000.00),
('Borde de Queso', 8000.00);

-- Combos
INSERT INTO combo (nombre, descripcion, precio) VALUES
('Combo Universitario', 'Pizza Pepperoni + Gaseosa 1.5L', 39000.00),
('Combo Pareja', 'Pizza Campus Suprema + Pan de Ajo + Gaseosa 1.5L', 54000.00);

-- Productos del Combo
INSERT INTO combo_producto (id_combo, id_producto, cantidad) VALUES
(1, 1, 1),
(1, 4, 1),
(2, 3, 1),
(2, 4, 1),
(2, 5, 1);

-- Menú
INSERT INTO menu (nombre, fecha_inicio, fecha_fin, activo) VALUES
('Menú Principal 2026', '2026-01-01', NULL, TRUE);

INSERT INTO menu_producto (id_menu, id_producto) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5);

INSERT INTO menu_combo (id_menu, id_combo) VALUES
(1, 1), (1, 2);

-- Pedidos
INSERT INTO pedido (id_cliente, fecha, tipo_consumo, estado) VALUES
(1, '2026-10-01 19:30:00', 'COMER_EN_LOCAL', 'ENTREGADO'),
(2, '2026-10-02 20:15:00', 'RECOGER', 'ENTREGADO'),
(3, '2026-10-05 12:00:00', 'COMER_EN_LOCAL', 'PREPARANDO');

-- Detalle del Pedido
INSERT INTO detalle_pedido (id_pedido, id_producto, id_combo, cantidad, precio_unitario) VALUES
(1, NULL, 1, 1, 39000.00), -- Pedido 1: Combo Universitario
(2, 2, NULL, 1, 32000.00), -- Pedido 2: Pizza Hawaiana
(2, 4, NULL, 1, 7000.00),  -- Pedido 2: Gaseosa
(3, 3, NULL, 1, 42000.00); -- Pedido 3: Pizza Suprema

-- Detalle Adiciones
INSERT INTO detalle_adicion (id_detalle, id_adicion, cantidad, precio_unitario) VALUES
(2, 3, 1, 8000.00); -- Borde de queso para la Hawaiana del Pedido 2


-- =====================================================
-- CONSULTAS Y REPORTES EN MYSQL (SELECT)
-- =====================================================

-- Consulta 1: Verificar que todas las tablas se hayan creado en la base de datos
SHOW TABLES;


-- Consulta 2: Menú general de productos con su respectiva categoría
SELECT 
    p.id_producto,
    p.nombre AS producto,
    p.descripcion,
    p.precio,
    c.nombre AS categoria,
    IF(p.elaborado, 'Sí', 'No') AS requiere_elaboracion
FROM producto p
INNER JOIN categoria c ON p.id_categoria = c.id_categoria
ORDER BY c.nombre, p.nombre;


-- Consulta 3: Consultar los ingredientes de cada producto
SELECT 
    p.nombre AS producto,
    i.nombre AS ingrediente,
    pi.cantidad
FROM producto_ingrediente pi
INNER JOIN producto p ON pi.id_producto = p.id_producto
INNER JOIN ingrediente i ON pi.id_ingrediente = i.id_ingrediente
ORDER BY p.nombre;


-- Consulta 4: Ver el detalle de qué contiene cada combo y su precio
SELECT 
    c.nombre AS combo,
    p.nombre AS producto_incluido,
    cp.cantidad,
    c.precio AS precio_combo
FROM combo_producto cp
INNER JOIN combo c ON cp.id_combo = c.id_combo
INNER JOIN producto p ON cp.id_producto = p.id_producto
ORDER BY c.nombre;


-- Consulta 5: Historial detallado de pedidos con sus ítems comprados y subtotales
SELECT 
    p.id_pedido,
    cl.nombre AS cliente,
    p.fecha,
    p.tipo_consumo,
    p.estado,
    COALESCE(prod.nombre, comb.nombre) AS item_comprado,
    IF(prod.id_producto IS NOT NULL, 'Producto', 'Combo') AS tipo_item,
    dp.cantidad,
    dp.precio_unitario,
    (dp.cantidad * dp.precio_unitario) AS subtotal
FROM pedido p
INNER JOIN cliente cl ON p.id_cliente = cl.id_cliente
INNER JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido
LEFT JOIN producto prod ON dp.id_producto = prod.id_producto
LEFT JOIN combo comb ON dp.id_combo = comb.id_combo
ORDER BY p.fecha DESC;


-- Consulta 6: Adiciones agregadas en los pedidos y su costo adicional
SELECT 
    p.id_pedido,
    cl.nombre AS cliente,
    a.nombre AS adicion,
    da.cantidad,
    da.precio_unitario,
    (da.cantidad * da.precio_unitario) AS subtotal_adicion
FROM detalle_adicion da
INNER JOIN detalle_pedido dp ON da.id_detalle = dp.id_detalle
INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
INNER JOIN cliente cl ON p.id_cliente = cl.id_cliente
INNER JOIN adicion a ON da.id_adicion = a.id_adicion;


-- Consulta 7: Reporte total de ventas acumuladas por cliente (Incluye adiciones)
SELECT 
    cl.id_cliente,
    cl.nombre,
    cl.correo,
    COUNT(DISTINCT p.id_pedido) AS total_pedidos,
    COALESCE(SUM(dp.cantidad * dp.precio_unitario), 0) + 
    COALESCE(SUM(da.cantidad * da.precio_unitario), 0) AS total_gastado
FROM cliente cl
LEFT JOIN pedido p ON cl.id_cliente = p.id_cliente AND p.estado != 'CANCELADO'
LEFT JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido
LEFT JOIN detalle_adicion da ON dp.id_detalle = da.id_detalle
GROUP BY cl.id_cliente, cl.nombre, cl.correo
ORDER BY total_gastado DESC;


-- Consulta 8: Productos en el menú actualmente activo
SELECT 
    m.nombre AS menu,
    'Producto' AS tipo,
    p.nombre AS item
FROM menu m
INNER JOIN menu_producto mp ON m.id_menu = mp.id_menu
INNER JOIN producto p ON mp.id_producto = p.id_producto
WHERE m.activo = TRUE 

UNION ALL

SELECT 
    m.nombre AS menu,
    'Combo' AS tipo,
    c.nombre AS item
FROM menu m
INNER JOIN menu_combo mc ON m.id_menu = mc.id_menu
INNER JOIN combo c ON mc.id_combo = c.id_combo
WHERE m.activo = TRUE;