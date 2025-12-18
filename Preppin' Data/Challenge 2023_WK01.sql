
--cleans and prepares data to be aggregated at different levels
WITH cleaned AS (
SELECT SPLIT_PART(transaction_code, '-', 1) AS bank
    , value
    , customer_code
    , CASE online_or_in_person
        WHEN 2 THEN 'In-Person'
        WHEN 1 THEN 'Online'
        END AS online_or_in_person
    , transaction_date
    , DAYNAME(TO_DATE(LEFT(transaction_date, 10), 'DD/MM/YYYY')) AS day_of_week
FROM PD2023_WK01 )
; 

-- Aggregation 1
SELECT bank
    , SUM(value) AS value
FROM cleaned
GROUP BY bank
; 

-- Aggregation 2
SELECT bank
    , online_or_in_person 
    , day_of_week AS transaction_date
    , SUM(value) AS value
FROM cleaned 
GROUP BY bank
    , online_or_in_person 
    , day_of_week
;

-- Aggregation 3
SELECT bank
    , customer_code
    , SUM(value) AS value
FROM cleaned 
GROUP BY bank
    , customer_code
;