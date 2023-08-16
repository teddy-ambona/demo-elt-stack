# tocos-assignment

# TODO

1/ 
running on host
Python script to quickly populate DB: in Docker OK
Define data model with DBT OK
Add test OK
Define 2 data transformation OK
Running in Airflow
Set up Airflow in docker-compose
Populate csv wth PostgresOperator

## 1 - Prerequisites

- [Docker](https://docs.docker.com/get-docker/)(8.0 GB of memory and 4 CPUs)
- [Docker Compose CLI plugin](https://docs.docker.com/compose/install/compose-plugin/)
- If running on windows: [Docker remote containers on WSL 2](https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers)
- [dbt CLI](https://docs.getdbt.com/docs/core/installation)(version installed for this demo: 1.6.0, postgres plugin: 1.6.0)

## 2 - Quickstart

DBT is a compiler and runner, it doesn't handle raw data loading directly so we use a Python script to load the CSV data. Note that a PostgresOperator in Airflow would do for the data ingestion but I didn't want to ingest the full CSV and PostgresOperator isn't great for custom CSV imports. Another workaround that could be used for the demo is using the DBT "seed" but it is only recommended for static data whilst the withdrawls history is dynamic data.

Orchestration with Airflow, add test task to DAG

## File structure

explain only top directories

```
.
 |-init_db.sql // SQL Query run during initialization of postgresDB
 |-docker-compose.yaml
 |-dbt
  |-profiles.yml
  |-tests
  | |-.gitkeep
  | |-ensure_withdrawal_or_deposit.sql
  | |-value_date_greater_than_transaction_date.sql
  |-models
  | |-staging
  | | |-schema.yml
  | | |-source.yml
  | | |-transactions.sql
  |-macros // custom macro to override the schema name
  |-dbt_project.yml
 |-Makefile  // Makes terminal interactions much faster
 |-README.md
 |-.gitignore
 |-data_ingestion  // Contains the Python script
 | |-requirements.in
 | |-requirements.txt
 | |-Dockerfile
 | |-populate_csv_into_db.py
 | |-data
```

## 3 - ELT

raw, staging schemas

### Extract & Load

Python script that will read the CSV, remove duplicates and drop the last column, we don't want to store data that carries no information.

### Transform

Add DBT Completed DAG

# Tests

- DBT tests are located under [./dbt/tests/](./dbt/tests/)
- The Python script should also have unit/functional tests but they have been omitted to keep the demo simple. You can refer to my other repo [financial-data-api](https://github.com/teddy-ambona/financial-data-api/tree/main/app/tests) if you want more details on python tests.

## Improvements
- Add architecture diagram for ETL and data viz
- The PK `transaction_id` is an auto-incremented id, this means that duplicate transactions are technically allowed in the table

## Resources:
- [Running Airflow in Docker](https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html)
- 

# Useful commands

Check DBT DB connection status

```bash
dbt debug
```

Generate DBT documentation

```bash
dbt docs generate
```

Dry-run DBT
```bash
dbt compile
```

Run DBT tests
```bash
dbt test
```

## Task 2: 

*Please write up no more than 300 words on your opinions of the practical realities of taking a lakehouse approach to building a data stack vs a data mesh approach.*

Source of truth
Central vs decentralized
Data Mesh allows for redunduncies, this is offset by low compute cost and speed/flexibility that we wouldn't have with DWH

In either case we need high quality and reliable data