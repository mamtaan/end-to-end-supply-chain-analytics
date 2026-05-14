CREATE DATABASE Supply ;

USE Supply;

SELECT * FROM supply ;

-- 1. Which shipping mode has the highest delay percentage?
SELECT 
    `Shipping Mode`,
    COUNT(*) AS Total_Orders,
    SUM(Is_delayed) AS Delayed_Orders,
    ROUND((SUM(Is_delayed) * 100.0 / COUNT(*)), 2) AS Delay_Percentage
FROM Supply
GROUP BY `Shipping Mode`
ORDER BY Delay_Percentage DESC;

-- 2.Find the top 5 regions generating the highest profit.
SELECT 
    `Order Region`,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit
FROM Supply
GROUP BY `Order Region`
ORDER BY Total_Profit DESC
LIMIT 5;

-- 3. Which departments are least profitable?
SELECT 
    `Order Region`,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit
FROM Supply
GROUP BY `Order Region`
ORDER BY Total_Profit ASC
LIMIT 5;

-- 4. Identify regions with both high sales and high delays.
SELECT 
    `Order Region`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    SUM(Is_delayed) AS Total_Delays
FROM Supply
GROUP BY `Order Region`
ORDER BY Total_Sales DESC, Total_Delays DESC
LIMIT 5;

-- 5. Find the top 5 products causing the most delivery delays.
SELECT 
    `Product Name`,
    COUNT(*) AS Total_Orders,
    SUM(Is_delayed) AS Delayed_Orders
FROM Supply
GROUP BY `Product Name`
ORDER BY Delayed_Orders DESC
LIMIT 5;

-- 6. Which categories have the highest late delivery risk?
SELECT 
    `Category Name`,
    COUNT(*) AS Total_Orders,
    SUM(Is_delayed) AS Delayed_Orders,
    ROUND((SUM(Is_delayed) * 100.0 / COUNT(*)), 2) AS Delay_Percentage,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit
FROM Supply
GROUP BY `Category Name`
HAVING Delay_Percentage > (
    SELECT 
        ROUND((SUM(Is_delayed) * 100.0 / COUNT(*)), 2)
    FROM Supply
)
ORDER BY Total_Profit DESC, Delay_Percentage DESC
LIMIT 5 ;

-- 7. Compare scheduled shipping days vs actual shipping days for each shipping mode.
SELECT 
    `Shipping Mode`,
    ROUND(AVG(`Days for shipment (scheduled)`), 1) AS Avg_Scheduled_Days,
    ROUND(AVG(`Days for shipping (real)`), 1) AS Avg_Actual_Days,
    ROUND(
        AVG(`Days for shipping (real)`) - 
        AVG(`Days for shipment (scheduled)`), 1
    ) AS Avg_Delay_Difference
FROM Supply
GROUP BY `Shipping Mode`
ORDER BY Avg_Delay_Difference DESC;

-- 8. Find the relationship between shipping delay and profit.
SELECT 
    Delay,
    ROUND(AVG(`Order Profit Per Order`), 2) AS Avg_Profit,
    COUNT(*) AS Total_Orders
FROM Supply
GROUP BY Delay
ORDER BY Delay;