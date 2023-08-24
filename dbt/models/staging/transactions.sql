-- "src_postgres" is defined in source.yml
with source_data as (
    select * from {{ source("src_postgres", "transactions") }}
)

select 
    ROW_NUMBER() over() AS transaction_id, -- Add unique identifier for each transaction
    RTRIM("Account No", '''') AS account_number, -- Remove trailing quote
    TO_DATE("DATE", 'Mon DD, YY') AS transaction_date, -- Convert transaction date to a date format
    "TRANSACTION DETAILS" AS transaction_details,
    CAST("CHQ.NO." AS INT) AS cheque_number, -- Convert data type into INT
    TO_DATE("VALUE DATE", 'Mon DD, YY') AS value_date, -- Convert value date to a date format
    CAST(REPLACE(BTRIM(" WITHDRAWAL AMT "), ',', '') AS DECIMAL(12,2)) AS withdrawal_amount,  -- Trim spaces from the amounts and convert to decimal
    CAST(REPLACE(BTRIM(" DEPOSIT AMT "), ',', '') AS DECIMAL(12,2)) AS deposit_amount,  -- Trim spaces from the amounts and convert to decimal
    CAST(REPLACE(BTRIM("BALANCE AMT"), ',', '') AS DECIMAL(12,2)) AS balance_amount  -- Trim spaces from the amounts and convert to decimal
from source_data
