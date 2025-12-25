WITH unioned AS (
    SELECT *
        , 'January' AS file_date
    FROM PD2023_WK08_01
    UNION ALL
    SELECT *
        , 'February' AS file_date
    FROM PD2023_WK08_02
    UNION ALL
    SELECT *
        , 'March' AS file_date
    FROM PD2023_WK08_03
    UNION ALL
    SELECT *
        , 'April' AS file_date
    FROM PD2023_WK08_04
    UNION ALL
    SELECT *
        , 'May' AS file_date
    FROM PD2023_WK08_05
    UNION ALL
    SELECT *
        , 'June' AS file_date
    FROM PD2023_WK08_06
    UNION ALL
    SELECT *
        , 'July' AS file_date
    FROM PD2023_WK08_07
    UNION ALL
    SELECT *
        , 'August' AS file_date
    FROM PD2023_WK08_08
    UNION ALL
    SELECT *
        , 'September' AS file_date
    FROM PD2023_WK08_09
    UNION ALL
    SELECT *
        , 'October' AS file_date
    FROM PD2023_WK08_10
    UNION ALL
    SELECT *
        , 'November' AS file_date
    FROM PD2023_WK08_11
    UNION ALL
    SELECT *
        , 'December' AS file_date
    FROM PD2023_WK08_12
)

, cleaned AS ( 
    SELECT id
        , first_name
        , last_name
        , ticker
        , sector
        , market
        , stock_name
        , CASE
            WHEN market_cap = 'n/a' THEN NULL
            WHEN RIGHT(market_cap, 1) = 'M' THEN CAST(REPLACE(REPLACE(market_cap, '$', ''), 'M', '') AS NUMERIC) * 1000000
            WHEN RIGHT(market_cap, 1) = 'B' THEN CAST(REPLACE(REPLACE(market_cap, '$', ''), 'B', '') AS NUMERIC) * 1000000000
            ELSE CAST(REPLACE(market_cap, '$', '') AS NUMERIC)
        END AS market_cap
        , purchase_price
        , CASE 
            WHEN CAST(REPLACE(purchase_price, '$', '') AS NUMERIC) < 24999.99 THEN 'Low'
            WHEN CAST(REPLACE(purchase_price, '$', '') AS NUMERIC) < 50000 THEN 'Medium'
            WHEN CAST(REPLACE(purchase_price, '$', '') AS NUMERIC) < 75000 THEN 'High'
            WHEN CAST(REPLACE(purchase_price, '$', '') AS NUMERIC) < 100000 THEN 'Very High'
        END AS purchase_price_category
        , file_date
    FROM unioned
    WHERE market_cap IS NOT NULL 
) 

, ranked AS (
    SELECT id
            , first_name
            , last_name
            , ticker
            , sector
            , market
            , stock_name
            , market_cap
            , CASE
                  WHEN market_cap < 100000000 THEN 'Small'
                  WHEN market_cap < 1000000000 THEN 'Medium'
                  WHEN market_cap < 100000000000 THEN 'Large'
                  ELSE 'Huge'
            END AS market_cap_category
            , CAST(REPLACE(purchase_price, '$', '') AS NUMERIC) AS purchase_price
            , purchase_price_category
            , file_date
    FROM cleaned
) 

, ranked_two AS (
    SELECT * 
        , RANK() OVER(PARTITION BY file_date, purchase_price_category, market_cap_category ORDER BY CAST(REPLACE(purchase_price, '$', '') AS NUMERIC) DESC) as rank
    FROM ranked 
)

SELECT * 
FROM ranked_two
WHERE 
    rank <= 5 
    AND 
    market_cap IS NOT NULL
;
