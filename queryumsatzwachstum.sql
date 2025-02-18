WITH AktuellerUmsatz AS (
    SELECT 
        p.ProductID,
        p.Name AS Produktname,
        SUM(sod.OrderQty * sod.UnitPrice) AS UmsatzAktuell
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    WHERE YEAR(soh.OrderDate) = 2014 -- nur für das Jahr 2014
    GROUP BY p.ProductID, p.Name
),
VorjahresUmsatz AS (
    SELECT 
        p.ProductID,
        SUM(sod.OrderQty * sod.UnitPrice) AS UmsatzVorjahr
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    WHERE YEAR(soh.OrderDate) = 2013 -- nur für das Jahr 2013
    GROUP BY p.ProductID
)
SELECT 
    a.Produktname,
    a.UmsatzAktuell,
    v.UmsatzVorjahr,
    (a.UmsatzAktuell - COALESCE(v.UmsatzVorjahr, 0)) AS UmsatzDifferenz
FROM AktuellerUmsatz a
LEFT JOIN VorjahresUmsatz v ON a.ProductID = v.ProductID
ORDER BY UmsatzDifferenz DESC;
