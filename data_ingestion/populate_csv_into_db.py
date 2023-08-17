import logging

import pandas as pd
from sqlalchemy import create_engine

# Initialize variables
# Note that this is not suitable for production-use, the credentials should be store in a key-vault and injected as secrets
FPATH = 'data/transactions_data.csv'
DB_USERNAME='postgres'
DB_PASSWORD='postgres'
DB_HOST='localhost'
DB_PORT=5431
DB_NAME='postgres'

# Format logs
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s | %(name)s | %(levelname)s | %(message)s'
)

# Read the data from CSV
logging.info('Reading CSV file.')
df_raw = pd.read_csv(FPATH, delimiter=',')

# Drop useless columns and duplicates
df_raw.drop(columns=['.'], inplace=True)

duplicates = df_raw.duplicated(keep=False).sum()
if duplicates > 0:
    logging.info(f'Removing {duplicates} duplicates.')
    df_raw.drop_duplicates(inplace=True)
logging.info('Raw data formatted.')

# Insert data into DB
# Initialize connexion
conn_string = f'postgresql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
db = create_engine(conn_string)
conn = db.connect()
logging.info('Connected to DB.')

# Write into DB
df_raw.to_sql('transactions', schema='raw', con=conn, if_exists='append', index=False)
logging.info('Raw data saved into DB.')
