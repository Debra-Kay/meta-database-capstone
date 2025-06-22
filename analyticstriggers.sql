-- Top 5 Best-Selling Products

SELECT p.ProductName, SUM(od.Quantity) AS TotalSold
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSold DESC
LIMIT 5;

-- Monthly Sales Summary

SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month, SUM(TotalAmount) AS MonthlyRevenue
FROM Orders
GROUP BY Month
ORDER BY Month;

-- Total Sales by Employee

SELECT e.FirstName, e.LastName, SUM(o.TotalAmount) AS TotalSales
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID
ORDER BY TotalSales DESC;

-- View: Top Customers by Total Purchase

CREATE VIEW TopCustomers AS
SELECT c.CustomerID, c.Name, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC;

-- Stored Procedure: Add New Order

DELIMITER //
CREATE PROCEDURE AddNewOrder (
    IN p_CustomerID INT,
    IN p_EmployeeID INT,
    IN p_ShipperID INT,
    IN p_TotalAmount DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipperID, TotalAmount)
    VALUES (p_CustomerID, p_EmployeeID, CURDATE(), p_ShipperID, p_TotalAmount);
END //
DELIMITER ;

-- Trigger: Decrease inventory after an order detail is added

DELIMITER //
CREATE TRIGGER trg_decrease_inventory
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    UPDATE Inventory
    SET QuantityAvailable = QuantityAvailable - NEW.Quantity
    WHERE ProductID = NEW.ProductID;
END;
//
DELIMITER ;
