-- 1.
SELECT p.ProductID, p.ProductName
FROM Product p 
LEFT JOIN Purchases pu ON (p.ProductID = pu.ProductID)
WHERE pu.ProductID IS NULL;

-- OF 
SELECT p.ProductID, p.ProductName
FROM Product p 
WHERE p.ProductID NOT IN (SELECT ProductID FROM Purchases)

-- 2.
SELECT s.SupplierName
FROM Supplier s
JOIN Product p ON (s.SupplierID = p.SupplierID)
LEFT JOIN OrdersDetail od ON (p.ProductID = od.ProductID)
WHERE od.ProductID IS NULL

-- Met subqueries

SELECT s.SupplierName
FROM Supplier s
JOIN Product p
ON s.SupplierID = p.SupplierID
WHERE p.ProductID NOT IN (SELECT ProductID FROM OrdersDetail);

-- 3.
SELECT *
FROM Product p
WHERE p.Price >
(SELECT AVG(Price) 
FROM Product pr JOIN ProductClass pc ON (pr.ProductClassID = pc.ProductClassID)
WHERE pc.ProductClassName = 'Bicycle')
ORDER BY p.Price DESC

-- 4.
SELECT o.OrderID
FROM Orders o
WHERE o.OrderAmount <>
(SELECT SUM(d.UnitPrice * d.Quantity) FROM OrdersDetail d WHERE d.OrderID = o.OrderID)

-- 5.

