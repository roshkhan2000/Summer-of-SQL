-- clean and transform data to prepare to aggregate
WITH cleaned AS (
SELECT transaction_code
    , value
    , customer_code
    , CASE online_or_in_person
        WHEN 1 THEN 'Online'
        WHEN 2 THEN 'In-Person'
        ELSE 'Flag'
        END AS online_or_in_person
    , QUARTER(TO_DATE(LEFT(transaction_date, 10), 'DD/MM/YYYY')) as which_quarter
FROM PD2023_Wk01 
WHERE LEFT(transaction_code, 3) LIKE 'DSB'
),

-- aggregated to per quarter and online or in person
aggregated AS (
SELECT which_quarter 
    , online_or_in_person
    , SUM(value) AS value
FROM cleaned 
GROUP BY which_quarter 
    , online_or_in_person
), 

-- targets has been unpivoted
targets AS (
    SELECT *
    FROM PD2023_WK03_TARGETS
    UNPIVOT ( 
        target FOR quarter IN (Q1, Q2, Q3, Q4)
    ) AS unpivoted 
)

-- brining targets and 'aggregated to per quarter and online or in person' together to calculate difference
SELECT a.online_or_in_person
    , a.which_quarter AS quarter
    , t.target AS quarterly_targets
    , a.value - t.target AS variance_to_target
FROM aggregated AS a
LEFT JOIN targets AS t
ON a.online_or_in_person = t.online_or_in_person
    AND a.which_quarter = CAST(RIGHT(t.quarter, 1) AS INTEGER) 