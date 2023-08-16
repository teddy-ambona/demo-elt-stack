-- "src_postgres" is defined in source.yml
with source_data as (
    select * from {{ source("src_postgres", "transactions") }}
)

select 
    ROW_NUMBER() over() AS transaction_id, -- Add unique identifier for each transaction
    RTRIM("Account No", '''') AS account_number, -- Remove trailing quote
    "DATE" AS transaction_date,
    "TRANSACTION DETAILS" AS transaction_details,
    CAST("CHQ.NO." AS INT) AS cheque_number, -- Convert data type into INT
    "VALUE DATE" AS value_date,
    BTRIM(" WITHDRAWAL AMT ") AS withdrawal_amount,  -- Trim spaces from the amounts
    BTRIM(" DEPOSIT AMT ") AS deposit_amount,  -- Trim spaces from the amounts
    BTRIM("BALANCE AMT") AS balance_amount  -- Trim spaces from the amounts
from source_data
