SELECT transaction_id
    , 'GB' || s.check_digits || s.swift_code || REPLACE(sort_code, '-', '') || account_number AS iban
FROM PD2023_WK02_TRANSACTIONS AS t
LEFT JOIN PD2023_WK02_SWIFT_CODES AS s
ON s.bank = t.bank 