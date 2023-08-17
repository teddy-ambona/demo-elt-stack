-- Ensure each value date is greater than the transaction date

SELECT transaction_id
FROM postgres.staging.transactions
WHERE value_date < transaction_date
