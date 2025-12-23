SELECT 
    * 
FROM PD2023_WK07_TRANSACTION_PATH AS tp
LEFT JOIN PD2023_WK07_TRANSACTION_DETAIL AS td
ON  tp.transaction_id = td.transaction_id
LEFT JOIN 
    (SELECT *
    FROM PD2023_WK07_ACCOUNT_INFORMATION,
    LATERAL SPLIT_TO_TABLE(account_holder_id, ',') AS sp)  AS ai
ON tp.account_from = ai.account_number
LEFT JOIN
    (SELECT 
        account_holder_id
        , name
        , date_of_birth
        , '0' || CAST(contact_number AS STRING) As contract_number
        , first_line_of_address
    FROM PD2023_WK07_ACCOUNT_HOLDERS) AS ah
ON ai.value = ah.account_holder_id
WHERE
    cancelled_ = 'N'
    AND 
    td.value > 1000
    AND
    account_type != 'Platinum'
