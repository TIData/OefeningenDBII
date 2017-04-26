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

-- met de naam er bij
SELECT TOP 1 e.EmployeeID, e.FirstName, e.LastName, COUNT(*)
FROM Orders o
JOIN Employee e ON ( o.EmployeeID = e.EmployeeID)
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY COUNT(*) DESC


SELECT TOP 1 o.EmployeeID, COUNT(*)
FROM Orders o
GROUP BY o.EmployeeID
ORDER BY COUNT(*) DESC

-- 6.

SELECT e.FirstName, e.LastName, FORMAT(OrderDate, 'dd/MM/yyy') AS orderdate,
ISNULL(CAST(ROUND(SUM(OrderAmount), 0) AS INT), 0) as som,
ISNULL(CAST(ROUND((SELECT SUM(OrderAmount) FROM Orders WHERE OrderDate <= o.OrderDate AND EmployeeID = e.EmployeeID), 0) AS INT),0) AS Running
FROM Orders o
RIGHT JOIN Employee e ON (o.EmployeeID = e.EmployeeID)
GROUP BY e.EmployeeID, e.FirstName, e.LastName, OrderDate
ORDER BY e.EmployeeID, OrderDate