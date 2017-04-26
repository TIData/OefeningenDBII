
-- Oef 89.
--CREATE procedure productclasses
--AS
--SELECT ProductClassID, ProductClassName
--FROM ProductClass
--ORDER BY ProductClassName

-- Oef 90.
--CREATE procedure ordersByCourier
--	@courier int
--AS
--SELECT *
--FROM Orders
--WHERE CourierID = @courier
-- doe het toch door tabellen te joinen

-- select distinct o.* from product p join ordersdetail od on p.productid = od.productid join orders o on o.orderid = od.orderid

--execute ordersByCourier 1

-- Oef 91
--CREATE procedure addProductClass
--	@classname varchar(50),
--	@id int out
--AS
--	INSERT INTO ProductClass(ProductClassName)
--	VALUES (@classname)
--	SET @id = @@IDENTITY



-- of
--CREATE procedure addProductClass
--	@classname varchar(50)
--AS
--	INSERT INTO ProductClass(ProductClassName)
--	VALUES (@classname)
--	RETURN @@IDENTITY

--- exec @nr = exec  'Test'...


-- Oef 92
--CREATE procedure removeProduct
--	@pid int
--AS 
--	IF NOT EXISTS (SELECT * FROM Product WHERE ProductID = @pid)
--	BEGIN
--		RAISERROR ('Product bestaat niet', 14, 1)
--		RETURN
--	END
--	IF EXISTS (SELECT * FROM OrdersDetail WHERE ProductID = @pid)
--	BEGIN
--		RAISERROR ('Er mag nog geen bestelling geplaatst zijn', 14, 1)
--		RETURN
--	END
--	IF EXISTS (SELECT * FROM Purchases WHERE ProductID = @pid)
--	BEGIN
--		RAISERROR ('Er mag nog geen aankoop voor dit product zijn', 14, 1)
--		RETURN
--	END
--	DELETE FROM Product WHERE ProductID = @pid



-- Oef 93
CREATE PROCEDURE insertOrdersDetail
	@orderid int,
	@productid int,
	@unitprice decimal(8,2) = NULL,
	@quantity int
AS
IF NOT EXISTS (SELECT * FROM Orders WHERE OrderID = @orderid)
BEGIN
	RAISERROR ('Order bestaat niet', 14, 1)
	RETURN
END
IF NOT EXISTS (SELECT * FROM Product WHERE ProductID = @productid)
BEGIN
	RAISERROR ('Product bestaat niet', 14, 1)
	RETURN
END
IF @unitprice IS NULL
BEGIN
	SET @unitprice = (SELECT Price FROM Product WHERE ProductID = @productid)
END
IF (SELECT Shipped FROM Orders WHERE OrderID = @orderid) = 1
BEGIN
	RAISERROR ('De order mag nog niet verstuurd zijn', 14, 1)
END
INSERT INTO OrdersDetail VALUES (@orderid, @productid, @unitprice, @quantity)
IF (SELECT UnitsInStock FROM Product WHERE ProductID = @productid) > 0
	RETURN 1
ELSE
	RETURN 0