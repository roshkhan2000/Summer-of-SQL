 WITH pivoted AS (
    SELECT customer_id
        , split_part(category,'___', 2) AS category
        , split_part(category,'___', 1) AS platform
        , value
    FROM PD2023_WK06_DSB_CUSTOMER_SURVEY
    UNPIVOT(
    value FOR category IN (MOBILE_APP___EASE_OF_USE, MOBILE_APP___EASE_OF_ACCESS, MOBILE_APP___NAVIGATION, MOBILE_APP___LIKELIHOOD_TO_RECOMMEND, MOBILE_APP___OVERALL_RATING, ONLINE_INTERFACE___EASE_OF_USE, ONLINE_INTERFACE___EASE_OF_ACCESS, ONLINE_INTERFACE___NAVIGATION, ONLINE_INTERFACE___LIKELIHOOD_TO_RECOMMEND, ONLINE_INTERFACE___OVERALL_RATING)
    ) AS u
)

, fan_category AS (
    SELECT customer_id
        , AVG("'MOBILE_APP'") AS avg_mobile_app
        , AVG("'ONLINE_INTERFACE'") AS avg_online_interface
        , AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") AS avg_difference
        , CASE 
            WHEN AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") >= 2 THEN 'Mobile App Superfans'
            WHEN AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") >= 1 THEN 'Mobile App Fans'
            WHEN AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") <= -2 THEN 'Online Interface Superfans'
            WHEN AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") <= -1 THEN 'Online Interface Fans'
            ELSE 'Neutral'
        END AS fan_category
    FROM pivoted
    PIVOT (SUM(value) FOR platform IN ('MOBILE_APP', 'ONLINE_INTERFACE')) as p
    WHERE category != 'OVERALL_RATING'
    GROUP BY customer_ID
) 

SELECT fan_category
    , ROUND((COUNT(fan_category) / (SELECT COUNT(DISTINCT customer_id) FROM PD2023_WK06_DSB_CUSTOMER_SURVEY)) *100, 1) AS percent_of_customers
FROM fan_category
GROUP BY 1
