
DROP TABLE IF EXISTS zepto;


CREATE TABLE zepto
(
 sku_id SERIAL PRIMARY KEY,
 Category VARCHAR(150),	
 name VARCHAR(150) NOT NULL,
 mrp NUMERIC(8,2), 	
 discountPercent NUMERIC(5,2),	
 availableQuantity INTEGER,	
 discountedSellingPrice	NUMERIC(8,2),
 weightInGms INTEGER,  	
 outOfStock	BOOLEAN,
 quantity INTEGER
);



SELECT * FROM zepto;

--================== Data Exploration =================--

--Count of rows--
SELECT COUNT(*) FROM zepto;


--Sample Data--
SELECT * FROM zepto
LIMIT 10; 


--Check NUll Values--
SELECT *
FROM zepto
WHERE  Category	IS NULL
       OR
       name IS NULL
	   OR
	   mrp IS NULL
	   OR
	   discountPercent IS NULL
	   OR
	   availableQuantity IS NULL
	   OR
	   discountedSellingPrice IS NULL
	   OR
	   weightInGms IS NULL
	   OR
	   outOfStock IS NULL
	   OR
	   quantity IS NULL;


--Unique Product Category--
SELECT DISTINCT category FROM zepto
ORDER BY category ASC;


--Products in Stock vs Out of Stock--
SELECT outofstock,COUNT(sku_id)
FROM zepto
GROUP BY outofstock;


--Product names present multiple times--
SELECT name,COUNT(sku_id)
FROM zepto
GROUP BY name
HAVING COUNT(sku_id)>1
ORDER BY COUNT(sku_id) DESC;



SELECT * FROM zepto;

--================== Data Cleaning =================--

SELECT * FROM zepto 
WHERE mrp=0  OR discountedSellingPrice=0;


DELETE FROM zepto
WHERE mrp=0  OR discountedSellingPrice=0;


-- Convert Paisa To Rupee --
UPDATE zepto
SET mrp=mrp/100.0,
    discountedSellingPrice=discountedSellingPrice/100.0;




SELECT * FROM zepto;

--================== Business Insight Queries =================--


-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name,mrp,discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;


--Q2.What are the Products with High MRP but Out of Stock
SELECT name,outofstock,MAX(mrp)
FROM zepto
WHERE outofstock='True'
GROUP BY name,outofstock
ORDER BY MAX(mrp) DESC
LIMIT 10;


--Q3.Calculate Estimated Revenue for each category
SELECT category,SUM(discountedsellingprice*availablequantity) AS Total_Revenue
FROM zepto
GROUP BY category
ORDER BY Total_Revenue ASC;


-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name,mrp,discountpercent
FROM zepto
WHERE mrp>=500 AND discountpercent<=10
ORDER BY mrp DESC,discountpercent DESC; 


-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category, AVG(discountpercent) AS Average_Discount
FROM zepto
GROUP BY category
ORDER BY Average_Discount DESC
LIMIT 5;


-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name,weightingms,discountedsellingprice,
                     ROUND(discountedsellingprice/weightingms,2) AS Price_Per_Gram
FROM zepto
WHERE weightingms>=100
ORDER BY Price_Per_Gram ASC;



--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name,weightingms,
       CASE
	       WHEN weightingms<1000 THEN 'Low'
		   WHEN weightingms<5000 THEN 'Medium'
		   ELSE 'Bulk'
	   END AS weight_category
FROM zepto;



--Q8.What is the Total Inventory Weight Per Category 
SELECT category,SUM(weightingms * availablequantity) AS Total_Inventory_Weight
FROM zepto
GROUP BY category
ORDER BY Total_Inventory_Weight ASC;






