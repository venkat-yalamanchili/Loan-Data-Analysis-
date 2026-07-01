-- The Business Question: "Can you divide our borrowers into four equal risk tiers based on their 
-- Credit Score and calculate the default rate for each tier?"

WITH RiskBands AS (
    SELECT 
        LoanID,
        Default,
        NTILE(4) OVER (ORDER BY CreditScore) AS CreditScoreQuartile
    FROM LoanData
)
SELECT 
    CreditScoreQuartile,
    COUNT(LoanID) AS TotalLoans,
    SUM(CASE WHEN Default = 'True' THEN 1 ELSE 0 END) AS TotalDefaults,
    ROUND(SUM(CASE WHEN Default = 'True' THEN 1.0 ELSE 0.0 END) / COUNT(LoanID) * 100, 2) AS DefaultRatePercentage
FROM RiskBands
GROUP BY CreditScoreQuartile
ORDER BY CreditScoreQuartile;


-- The Business Question: "Find the 'hidden risks'—borrowers who defaulted on their loans despite having an income higher than 
-- the average income of their specific Education and Employment Type group."

WITH CohortAverages AS (
    SELECT 
        LoanID,
        Education,
        EmploymentType,
        Income,
        Default,
        AVG(Income) OVER (PARTITION BY Education, EmploymentType) AS CohortAvgIncome
    FROM LoanData
)
SELECT 
    LoanID,
    Education,
    EmploymentType,
    Income,
    ROUND(CohortAvgIncome, 2) AS CohortAvgIncome
FROM CohortAverages
WHERE Default = 'True' 
  AND Income > CohortAvgIncome
ORDER BY Income DESC;


-- The Business Question: "Calculate the average interest rate for 'Business' loans year over year, and include a running (cumulative) 
-- average to see if our pricing is trending up or down over time."
WITH YearlyStats AS (
    SELECT 
        Year,
        AVG(InterestRate) AS CurrentYearAvg
    FROM LoanData
    WHERE LoanPurpose = 'Business'
    GROUP BY Year
)
SELECT 
    Year,
    ROUND(CurrentYearAvg, 2) AS CurrentYearAvg,
    ROUND(AVG(CurrentYearAvg) OVER (
        ORDER BY Year 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS CumulativeAvgInterestRate
FROM YearlyStats
ORDER BY Year;


-- The Business Question: "Looking only at loans that are larger than the overall average loan amount, 
-- compare the average Debt-to-Income (DTI) ratio between defaulters and non-defaulters, grouped by Loan Purpose."

WITH OverallAvgLoan AS (
    -- Step 1: Find the global average loan amount
    SELECT AVG(LoanAmount) AS AvgLoan 
    FROM LoanData
),
LargeLoans AS (
    -- Step 2: Filter the dataset using the result from Step 1
    SELECT * FROM LoanData
    WHERE LoanAmount > (SELECT AvgLoan FROM OverallAvgLoan)
)
-- Step 3: Pivot the DTI metrics based on Default status
SELECT 
    LoanPurpose,
    COUNT(LoanID) AS LargeLoanCount,
    ROUND(AVG(CASE WHEN Default = 'True' THEN DTIRatio END), 4) AS AvgDTI_Defaulters,
    ROUND(AVG(CASE WHEN Default = 'False' THEN DTIRatio END), 4) AS AvgDTI_NonDefaulters
FROM LargeLoans
GROUP BY LoanPurpose
ORDER BY LoanPurpose;


-- The Business Question: "For each Income Bracket, rank the specific marital status and employment type combinations by their default rate. 
-- Return only the top 3 riskiest profiles per bracket, ensuring we ignore profiles with fewer than 50 loans to avoid skewed data."

WITH ProfileStats AS (
    SELECT 
        "Income Bracket",
        MaritalStatus,
        EmploymentType,
        COUNT(LoanID) AS TotalLoans,
        SUM(CASE WHEN Default = 'True' THEN 1.0 ELSE 0.0 END) / COUNT(LoanID) AS DefaultRate
    FROM LoanData
    GROUP BY "Income Bracket", MaritalStatus, EmploymentType
    HAVING COUNT(LoanID) > 50  -- Data quality filter
),
RankedProfiles AS (
    SELECT 
        *,
        DENSE_RANK() OVER (PARTITION BY "Income Bracket" ORDER BY DefaultRate DESC) AS RiskRank
    FROM ProfileStats
)
SELECT 
    "Income Bracket",
    MaritalStatus,
    EmploymentType,
    ROUND(DefaultRate * 100, 2) AS DefaultRatePercentage,
    RiskRank
FROM RankedProfiles
WHERE RiskRank <= 3
ORDER BY "Income Bracket", RiskRank;