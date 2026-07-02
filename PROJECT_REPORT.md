# Loan Default Risk Analytics - Industry Project Report

## 1. Executive Summary

This project analyzes loan default behavior using a full analytics workflow: raw loan data preparation, Python exploratory data analysis, SQL Server querying, and Power BI dashboard development. The final Power BI dashboard connects to **SQL Server**, uses **incremental refresh**, and organizes DAX calculations into **separate measure tables for each report page**.

The portfolio contains **255,347 loans**, **$32.58B** in total loan amount, and an overall default rate of **11.61%**. The analysis identifies high-risk borrower groups, product-level exposure, hidden-risk borrowers, and time-based risk patterns that can support underwriting, portfolio monitoring, and executive reporting.

## 2. Project Objectives

The primary objective is to help a lending business understand default risk and monitor the loan portfolio through business-ready analytics. The project focuses on these objectives:

1. Measure the overall size and risk of the loan portfolio.
2. Identify borrower segments with above-average default risk.
3. Compare default patterns across loan purpose, employment type, income, age, education, and credit score.
4. Track yearly changes in loan exposure and default loans.
5. Use SQL to answer advanced risk questions with window functions and cohort analysis.
6. Build an interactive Power BI dashboard suitable for stakeholders and recruiters.
7. Implement Power BI engineering practices such as SQL Server sourcing, incremental refresh, and organized measure tables.

## 3. Dataset Overview

| Attribute | Details |
|---|---:|
| Records | 255,347 |
| Original Columns | 19 |
| Date Range | 2013 to 2018 |
| Missing Values | 0 |
| Duplicate Loan IDs | 0 |
| Target Variable | Default |
| Total Loan Amount | $32,576,880,572 |
| Defaulted Loans | 29,653 |
| Overall Default Rate | 11.61% |
| Average Loan Amount | $127,578.87 |
| Median Loan Amount | $127,556 |
| Average Income | $82,499.30 |

## 4. Business Questions

| # | Business Question | Why It Matters |
|---:|---|---|
| 1 | What is the overall default rate and exposure of the portfolio? | Helps leadership understand portfolio health. |
| 2 | Which loan purposes generate the highest loan amount and default risk? | Supports product-level risk and pricing decisions. |
| 3 | Which employment types and income brackets are most risky? | Helps underwriting teams evaluate borrower stability. |
| 4 | How do age groups differ in loan amount and default behavior? | Supports demographic segmentation and customer policy design. |
| 5 | Do credit score tiers separate borrower risk effectively? | Validates the use of credit score in underwriting. |
| 6 | Are there borrowers who appear financially strong but still default? | Detects hidden-risk profiles missed by simple income checks. |
| 7 | How are loan amount and default loans changing year over year? | Supports trend monitoring and forecasting. |
| 8 | For high-value loans, do defaulters carry higher DTI than non-defaulters? | Helps refine rules for large-loan approvals. |
| 9 | Which combined customer profiles are riskiest within each income bracket? | Prioritizes monitoring and policy intervention. |

## 5. Methodology

### 5.1 Data Preparation

The raw loan dataset was reviewed for schema, missing values, duplicates, and type consistency. The dataset contains no missing values and no duplicate Loan IDs. The date column was parsed and used to extract year-level trends from 2013 to 2018.

### 5.2 Python Exploratory Data Analysis

The Python notebook was used to validate the dataset and explore risk drivers. The EDA included default distribution, numerical correlations, feature distributions by default status, categorical default-rate comparisons, and boxplots for interest rate and DTI.

### 5.3 SQL Server Analysis

The dataset was loaded into SQL Server as a table named `LoanData`. SQL queries were written around business questions and used advanced analytical patterns:

- CTEs for reusable logic
- `NTILE(4)` to segment credit score risk bands
- `AVG() OVER(PARTITION BY ...)` for cohort-level hidden-risk detection
- Running averages for business loan interest-rate trends
- Conditional aggregation for defaulter vs non-defaulter comparisons
- `DENSE_RANK()` to identify the top risky profiles within each income bracket

### 5.4 Power BI Dashboard Development

Power BI was used to build a three-page dashboard:

1. Loan Default & Overview
2. Applicant Demographics & Financial Profile
3. Financial Risk Metrics

The Power BI project uses SQL Server as the data source. Incremental refresh was implemented using the loan date field, and DAX measures were separated into page-specific measure tables to improve model maintainability.

## 6. Dashboard Pages

### 6.1 Loan Default & Overview

This page gives an executive view of the portfolio, including loan amount by purpose, average income by employment type, default rate by employment type, average loan amount by age group, and default rate by year.

![Loan Default and Overview](assets/dashboard_1_loan_default_overview.png)

### 6.2 Applicant Demographics & Financial Profile

This page focuses on borrower segmentation, including credit score categories, age groups, marital status, mortgage and dependent indicators, and number of loans by employment type.

![Applicant Demographics and Financial Profile](assets/dashboard_2_applicant_demographics_financial_profile.png)

### 6.3 Financial Risk Metrics

This page focuses on yearly changes, YTD loan exposure, income bracket exposure, and employment-based exposure.

![Financial Risk Metrics](assets/dashboard_3_financial_risk_metrics.png)

## 7. Key Metrics and Findings

### 7.1 Portfolio Overview

The portfolio contains **255,347 loans** with total loan exposure of **$32.58B**. The overall default rate is **11.61%**, representing **29,653 defaulted loans**.

### 7.2 Loan Purpose Insights

| Loan Purpose | Loans | Total Loan Amount | Default Rate |
|---|---:|---:|---:|
| Home | 51,286 | $6.55B | 10.24% |
| Business | 51,298 | $6.52B | 12.33% |
| Education | 51,005 | $6.51B | 11.84% |
| Auto | 50,844 | $6.50B | 11.88% |
| Other | 50,914 | $6.50B | 11.79% |

**Insight:** Loan amount is almost evenly distributed across purposes, but Business loans have the highest default rate. This suggests business-purpose loans deserve closer pricing and underwriting attention.

### 7.3 Employment Type Insights

| Employment Type | Loans | Average Income | Within-Segment Default Rate |
|---|---:|---:|---:|
| Unemployed | 63,824 | $82,272 | 13.55% |
| Part-time | 64,161 | $82,389 | 11.97% |
| Self-employed | 63,706 | $82,447 | 11.46% |
| Full-time | 63,656 | $82,890 | 9.46% |

**Insight:** Full-time borrowers have the lowest default risk, while unemployed borrowers have the highest. Employment type is a meaningful borrower stability signal.

### 7.4 Age Group Insights

| Age Group | Loans | Average Loan Amount | Default Rate |
|---|---:|---:|---:|
| Teen | 9,847 | $126,674 | 22.14% |
| Adults | 98,267 | $127,901 | 16.69% |
| Middle Age Adults | 98,259 | $127,459 | 8.71% |
| Senior Citizens | 48,974 | $127,355 | 5.13% |

**Insight:** Younger borrowers carry much higher default risk. Teen borrowers have more than four times the default rate of Senior Citizens.

### 7.5 Credit Score Risk Bands

SQL `NTILE(4)` was used to split borrowers into four equal credit score quartiles.

| Credit Score Quartile | Credit Score Range | Total Loans | Default Rate |
|---:|---|---:|---:|
| 1 | 300 to 437 | 63,837 | 13.06% |
| 2 | 437 to 574 | 63,837 | 11.90% |
| 3 | 574 to 712 | 63,837 | 11.30% |
| 4 | 712 to 849 | 63,836 | 10.19% |

**Insight:** Lower credit score tiers have higher default rates. The relationship is not perfectly extreme, but the risk gradient is clear and directionally useful for underwriting.

### 7.6 Income Bracket Insights

The Power BI financial risk page shows exposure by income bracket:

| Income Bracket | Total Loan Amount |
|---|---:|
| High | $21.73B |
| Medium Income | $7.21B |
| Low Income | $3.63B |

Using the inferred income bands from the report logic, borrowers below **$30K** default at **21.96%**. This is the highest income-based risk group.

**Insight:** Low-income borrowers have the highest risk rate, but high-income borrowers represent the largest total exposure. Portfolio monitoring should consider both default probability and exposure amount.

### 7.7 Yearly Trend Insights

| Year | Loans | Total Loan Amount | Defaults | Default Rate | YoY Loan Amount Change | YoY Default Loan Change |
|---:|---:|---:|---:|---:|---:|---:|
| 2013 | 42,785 | $5.46B | 4,973 | 11.62% | 0.00% | 0.00% |
| 2014 | 42,122 | $5.37B | 4,845 | 11.50% | -1.53% | -2.57% |
| 2015 | 42,521 | $5.44B | 4,976 | 11.70% | 1.30% | 2.70% |
| 2016 | 42,705 | $5.44B | 5,017 | 11.75% | -0.01% | 0.82% |
| 2017 | 42,377 | $5.38B | 4,875 | 11.50% | -1.08% | -2.83% |
| 2018 | 42,837 | $5.48B | 4,967 | 11.60% | 1.73% | 1.89% |

**Insight:** The default rate is stable year over year, but loan exposure and default loan counts fluctuate. 2018 produced the strongest YoY loan amount growth, while 2016 had the highest default rate.

### 7.8 Hidden-Risk Borrowers

The SQL cohort query identified borrowers who defaulted even though their income was above the average income of borrowers with the same Education and Employment Type.

| Hidden-Risk Metric | Value |
|---|---:|
| Hidden-risk defaulted borrowers | 11,823 |
| Share of all defaults | 39.87% |

**Insight:** A large share of defaulters cannot be detected using income alone. Cohort-relative analysis is more effective than a simple income threshold.

### 7.9 DTI and Interest Rate Insights

| Metric | Non-Defaulters | Defaulters |
|---|---:|---:|
| Average Income | $83,899 | $71,845 |
| Average Loan Amount | $125,354 | $144,515 |
| Average Credit Score | 576.23 | 559.29 |
| Average Interest Rate | 13.18% | 15.90% |
| Average DTI Ratio | 0.50 | 0.51 |
| Average Months Employed | 60.76 | 50.24 |
| Average Age | 44.41 | 36.56 |

**Insight:** Defaulters have lower income, larger loans, higher interest rates, lower credit scores, shorter employment history, and younger age profiles.

## 8. SQL Business Questions and Insights

| SQL Query | Business Question | Main Result |
|---|---|---|
| Credit Score NTILE | Can borrowers be divided into four equal credit risk tiers? | Lowest quartile default rate is 13.06%; highest quartile is 10.19%. |
| Cohort Hidden Risk | Which borrowers default despite earning above their cohort average? | 11,823 hidden-risk defaulters were found. |
| Business Loan Interest Trend | Is business loan pricing trending up or down? | Business loan average interest rate is stable around 13.48%. |
| Large Loan DTI Comparison | Do defaulters have higher DTI on large loans? | Defaulters have higher DTI than non-defaulters across every purpose. |
| Risk Profile Ranking | Which income-bracket profiles are riskiest? | Low-income Single/Unemployed and Divorced/Unemployed are among the riskiest profiles. |

## 9. Power BI Implementation Details

### 9.1 SQL Server Data Source

The dashboard connects to SQL Server instead of directly using the CSV file. This improves realism and makes the project more aligned with industry BI workflows.

### 9.2 Incremental Refresh

Incremental refresh was implemented using the loan date field. This is useful when datasets become large because Power BI can refresh only new or updated partitions instead of reloading all historical data.

### 9.3 Measure Tables

DAX measures were separated into different measure tables for each dashboard page. This improves readability, maintainability, and collaboration.

| Page | Measure Table Purpose |
|---|---|
| Loan Default & Overview | Core KPIs, loan amount, default rate, average income, age-group measures |
| Applicant Demographics & Financial Profile | Credit score, marital status, mortgage/dependents, employment counts |
| Financial Risk Metrics | YoY, YTD, income bracket, and exposure measures |

### 9.4 Suggested Core Measures

```DAX
Total Loans = COUNTROWS(LoanData)
Total Loan Amount = SUM(LoanData[LoanAmount])
Default Loans = CALCULATE(COUNTROWS(LoanData), LoanData[Default] = 1)
Default Rate % = DIVIDE([Default Loans], [Total Loans])
Average Loan Amount = AVERAGE(LoanData[LoanAmount])
Average Income = AVERAGE(LoanData[Income])
```

## 10. Business Recommendations

1. **Strengthen underwriting checks for high-risk segments.** Low-income, unemployed, young, and no co-signer borrowers require more robust review.
2. **Monitor Business loans carefully.** They have the highest default rate by loan purpose.
3. **Use cohort-based risk rules.** Hidden-risk borrowers show that income alone is not enough for credit decisions.
4. **Separate exposure and probability.** High-income borrowers have lower risk rates but represent the largest loan exposure.
5. **Track yearly risk with automated Power BI refresh.** Incremental refresh supports scalable monitoring as new loan records arrive.
6. **Improve metric governance.** Clearly distinguish within-segment default rate from contribution to total portfolio default rate.
7. **Move toward predictive analytics.** Use the EDA and SQL findings to build a future default prediction model.

## 11. Assumptions and Limitations

- The analysis is descriptive and does not prove causation.
- The dataset is assumed to be anonymized and suitable for portfolio-level analysis.
- Date values were parsed based on the available data format and validated against the year-level dashboard output.
- Power BI measures should be consistently named so stakeholders can distinguish default rate, default count, and default contribution.
- Predictive modeling was not included in the current version but is a natural future enhancement.

## 12. Future Enhancements

- Add a machine learning model to estimate borrower default probability.
- Build drillthrough pages for borrower-level investigation.
- Add row-level security for business users.
- Create SQL views or stored procedures for repeatable business logic.
- Deploy the dashboard to Power BI Service with scheduled refresh monitoring.
- Add data quality alerts for missing values, duplicate IDs, invalid dates, and schema drift.

## 13. Conclusion

This project demonstrates a complete analytics workflow from raw loan data to business insights. It combines Python, SQL Server, Power BI, DAX, incremental refresh, and professional documentation. The analysis provides actionable risk insights for underwriting and portfolio monitoring while also demonstrating skills that are valuable for data analyst, business intelligence analyst, and analytics engineering roles.
