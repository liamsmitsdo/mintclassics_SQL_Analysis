SELECT 
    *
FROM
    mintclassics.products;
SELECT 
    *
FROM
    mintclassics.warehouses;

-- Test Joining products to respective warehouses
SELECT 
    p.productName, p.quantityInStock, w.warehouseName
FROM
    mintclassics.products AS p
        LEFT JOIN
    mintclassics.warehouses AS w ON p.warehouseCode = w.warehouseCode;

-- South warehouse has least units in stock
SELECT 
    SUM(p.quantityInStock), w.warehouseName
FROM
    mintclassics.products AS p
        LEFT JOIN
    mintclassics.warehouses AS w ON p.warehouseCode = w.warehouseCode
GROUP BY w.warehouseName;

-- checking which product lines have least stock and potential correlation to warehouse
-- looks like lowest stock quantity per product line are in the South warehouse
SELECT 
    p.productLine,
    SUM(p.quantityInStock) AS stock,
    w.warehouseName
FROM
    mintclassics.products AS p
        LEFT JOIN
    mintclassics.warehouses AS w ON p.warehouseCode = w.warehouseCode
GROUP BY p.productLine , w.warehouseName
ORDER BY stock;

-- 79380 stock held in South warehouse
SELECT 
    SUM(p.quantityInStock) AS stock, w.warehouseName
FROM
    mintclassics.products AS p
        LEFT JOIN
    mintclassics.warehouses AS w ON p.warehouseCode = w.warehouseCode
WHERE
    w.warehouseName = 'South'
GROUP BY w.warehouseName;

-- Calculate total stock held ('555131')
SELECT 
    SUM(p.quantityInStock) AS stock
FROM
    mintclassics.products AS p
        LEFT JOIN
    mintclassics.warehouses AS w ON p.warehouseCode = w.warehouseCode;

-- how much stock is held in South Warehouse
SELECT 79380 / 555131 * 100;-- 14.3%

SELECT 
    productCode, (priceEach * quantityOrdered) AS sales
FROM
    mintclassics.orderdetails;

-- Calculate total sales ('9604190.61')
SELECT 
    SUM(priceEach * quantityOrdered) AS sales
FROM
    mintclassics.orderdetails;

-- Potential sales amount if South Warehouse was to close down
SELECT 
    SUM(priceEach * quantityOrdered) * 0.857 AS sales
FROM
    mintclassics.orderdetails;-- 8230791.35

SELECT 
    p.productLine, SUM(o.priceEach * o.quantityOrdered) AS sales
FROM
    mintclassics.orderdetails AS o
        JOIN
    mintclassics.products AS p ON o.productCode = p.productCode
GROUP BY p.productLine
ORDER BY sales;

-- 10 lowest selling vehicles
SELECT 
    p.productName,
    p.productLine,
    SUM(o.priceEach * o.quantityOrdered) AS sales
FROM
    mintclassics.orderdetails AS o
        JOIN
    mintclassics.products AS p ON o.productCode = p.productCode
GROUP BY p.productCode
ORDER BY sales
LIMIT 10;

-- 10 lowest selling vehicles (stored in south warehouse)
SELECT 
    p.productName,
    p.productLine,
    SUM(o.priceEach * o.quantityOrdered) AS sales
FROM
    mintclassics.orderdetails AS o
        JOIN
    mintclassics.products AS p ON o.productCode = p.productCode
WHERE
    p.productLine IN ('Trains' , 'Ships', 'Trucks and Buses')
GROUP BY p.productCode
ORDER BY sales
LIMIT 10;

-- are there any items stored that don't sell
-- 1985 Toyota Supra has no sales
SELECT 
	p.productCode, p.productName, p.productLine, SUM(o.priceEach * o.quantityOrdered) AS sales
FROM
    mintclassics.orderdetails AS o
        RIGHT JOIN
    mintclassics.products AS p ON o.productCode = p.productCode
GROUP BY p.productCode;