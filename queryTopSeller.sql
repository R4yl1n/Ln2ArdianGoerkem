SELECT 
    soh.SalesPersonID AS VerkäuferID,
    SUM(sod.OrderQty * sod.UnitPrice) AS GesamtUmsatz
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY soh.SalesPersonID
ORDER BY GesamtUmsatz DESC;
