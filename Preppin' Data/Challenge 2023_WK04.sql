-- union all tables
WITH unioned AS (
    SELECT *
        , 'January' AS month_name
    FROM PD2023_WK04_JANUARY
    UNION ALL
    SELECT *
        , 'FEBRUARY' AS month_name
    FROM PD2023_WK04_FEBRUARY
    UNION ALL
    SELECT *
        , 'MARCH' AS month_name
    FROM PD2023_WK04_MARCH
    UNION ALL
    SELECT *
        , 'APRIL' AS month_name
    FROM PD2023_WK04_APRIL
    UNION ALL
    SELECT *
        , 'MAY' AS month_name
    FROM PD2023_WK04_MAY
    UNION ALL
    SELECT *
        , 'JUNE' AS month_name
    FROM PD2023_WK04_JUNE
    UNION ALL
    SELECT *
        , 'JULY' AS month_name
    FROM PD2023_WK04_JULY
    UNION ALL
    SELECT *
        , 'AUGUST' AS month_name
    FROM PD2023_WK04_AUGUST
    UNION ALL
    SELECT *
        , 'SEPTEMBER' AS month_name
    FROM PD2023_WK04_SEPTEMBER
    UNION ALL
    SELECT *
        , 'OCTOBER' AS month_name
    FROM PD2023_WK04_OCTOBER
    UNION ALL
    SELECT *
        , 'NOVEMBER' AS month_name
    FROM PD2023_WK04_NOVEMBER
    UNION ALL
    SELECT *
        , 'DECEMBER' AS month_name
    FROM PD2023_WK04_DECEMBER
) 

-- clean and prepare for pivot
, cleaned AS (
    SELECT ID
        , TO_DATE(
            (CASE 
                WHEN LENGTH(joining_day) = 1 THEN '0' || CAST(joining_day AS VARCHAR)
                ELSE CAST(joining_day AS VARCHAR)
            END)
            || '/' || month_name || '/' || '2023', 'DD/MON/YYYY') as joining_date
        , demographic
        , value
    FROM unioned ) 

-- pivot the data above
, pivoted AS (
    SELECT *
    FROM cleaned
    PIVOT( 
    MAX(value) FOR demographic IN ('Ethnicity', 'Account Type', 'Date of Birth'))
)

-- ranking the data to pick the earliest join date row for duplicate IDs
, ranked AS (
    SELECT *
        , ROW_NUMBER() OVER(PARTITION BY ID ORDER BY joining_date ASC) AS id_ranked
    FROM pivoted
) 

--final query to select the required data
SELECT *
FROM ranked 
WHERE id_ranked != 2