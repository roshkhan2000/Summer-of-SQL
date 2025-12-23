-- Challenge: https://preppindata.blogspot.com/2023/02/2023-week-5-dsb-ranking.html

WITH agg_CTE AS (
    SELECT SPLIT_PART(transaction_code, '-', 1) AS bank
        , MONTH(TO_DATE(LEFT(transaction_date, 10), 'DD/MM/YYYY')) AS transaction_date
        , SUM(value) AS value
    FROM PD2023_WK01
    GROUP BY 
        SPLIT_PART(transaction_code, '-', 1)
        , MONTH(TO_DATE(LEFT(transaction_date, 10), 'DD/MM/YYYY'))
)

, agg_rank_CTE AS (
    SELECT transaction_date
        , bank
        , value
        , ROW_NUMBER() OVER(PARTITION BY transaction_date ORDER BY value DESC) AS bank_rank_per_month
    FROM agg_CTE
) 

SELECT *
    , AVG(value) OVER(PARTITION BY bank_rank_per_month) AS avg_transaction_value_per_rank 
    , AVG(bank_rank_per_month) OVER(PARTITION BY bank) AS avg_rank_per_bank
FROM agg_rank_CTE
