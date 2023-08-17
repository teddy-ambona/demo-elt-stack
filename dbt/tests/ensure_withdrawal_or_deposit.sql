-- Ensure each transaction is either a withdrawal or a deposit

SELECT transaction_id
FROM postgres.staging.transactions
WHERE (withdrawal_amount IS NOT NULL) AND (deposit_amount IS NOT NULL)
