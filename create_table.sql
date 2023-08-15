CREATE TABLE IF NOT EXISTS transactions(
    transaction_id SERIAL PRIMARY KEY, -- Auto-incremented id, this means that duplicate transactions are technically allowed
    account_number CHAR(13) NOT NULL,
    transaction_date VARCHAR(50),
    transaction_details VARCHAR(255),
    cheque_number INT,
    value_date VARCHAR(50),
    withdrawal_amount decimal(12,2), -- store the amount with exactly two decimal places
    deposit_amount decimal(12,2),
    balance_amount decimal(12,2)
);
