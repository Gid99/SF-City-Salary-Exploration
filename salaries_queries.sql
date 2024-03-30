USE Project_Portfolio;

-- SQL Queries

-- 1. List all unique job titles from the dataset.
SELECT DISTINCT JobTitle 
FROM salaries;

-- 2. Job Title Analysis:
-- Determine the job title with the highest average total pay benefits across all years.
SELECT JobTitle, ROUND(AVG(TotalPayBenefits), 2) AS Avg_TotalPayBenefits
FROM salaries
GROUP BY JobTitle
ORDER BY Avg_TotalPayBenefits DESC
LIMIT 1;

-- 3. Top Earners:
-- Identify the top 10 employees with the highest total pay benefits for the latest year available in the dataset.
SELECT EmployeeName, TotalPayBenefits, Year 
FROM salaries
WHERE Year = (
	SELECT MAX(Year) FROM salaries
)
ORDER BY TotalPayBenefits DESC
LIMIT 10;

-- 4. Managerial Jobs:
-- Show all employees who have the word "Manager" in their job title.
SELECT *
FROM salaries
WHERE JobTitle LIKE '%Manager%';

-- 5. Aggregate and Analyze Compensation:
-- Find the average base pay, overtime pay, other pay, and total compensation for all employees for each year included in the dataset.
SELECT Year,
		ROUND(AVG(BasePay), 2) AS Avg_BasePay, 
		ROUND(AVG(OvertimePay), 2) AS Avg_OvertimePay, 
        ROUND(AVG(OtherPay), 2) AS Avg_OtherPay, 
        ROUND(AVG(TotalPayBenefits), 2) AS Avg_TotalPayBenefits
FROM salaries
GROUP BY YEAR; 

-- 6. Overtime Analysis:
-- Find out which job titles have, on average, the highest overtime pay as a percentage of base pay.
SELECT JobTitle, 
		ROUND((AVG(OvertimePay / BasePay) * 100), 2) AS Avg_OvertimePay_Percentage
FROM salaries
WHERE BasePay > 0 -- Exclude records where BasePay is 0 to avoid division by zero
GROUP BY JobTitle
ORDER BY Avg_OvertimePay_Percentage DESC;

-- 7. Show all job titles with an average base pay of 
-- at least 100,000 and order them by the average base pay in descending order.
SELECT JobTitle, ROUND(AVG(BasePay), 2) AS Avg_BasePay
FROM salaries
GROUP BY JobTitle
HAVING Avg_BasePay >= 100000
ORDER BY Avg_BasePay DESC;

-- 8. Calculate the total pay with benefits for each job title and list them in descending order.
SELECT JobTitle, ROUND(SUM(TotalPayBenefits), 2) AS TotalPayBenefits_for_each_job
FROM salaries
GROUP BY JobTitle
ORDER BY TotalPayBenefits_for_each_job DESC;

-- 9. Difference in Average total pay including benefits between 2011 and 2014
-- What is the difference in the average benefits received by employees between 2011 and 2014?
SELECT
	ROUND ((
		AVG(CASE WHEN Year = 2014 THEN TotalPayBenefits ELSE NULL END) -
        AVG(CASE WHEN Year = 2011 THEN TotalPayBenefits ELSE NULL END)
    ), 2) AS Diff_Avg_Benefits
FROM
  salaries
WHERE
  Year IN (2011, 2014);

-- 10. Pay Range Distribution:
-- Create pay range categories (e.g., 0-50k, 50k-100k, etc.) and count how many employees fall into each category for the latest year available.
SELECT 
	CASE 
		WHEN TotalPay < 50000 THEN 'Under 50k'
		WHEN TotalPay BETWEEN 50000 AND 100000 THEN '50k to 100k'
		ELSE 'Over 100k'
	END AS TotalPayCategory,
    COUNT(*) AS TotalEmployee
FROM salaries
WHERE Year = (
	SELECT MAX(Year) FROM salaries
)
GROUP BY TotalPayCategory; 


