# tocos-assignment

# TODO

1/ 
running on host
Python script to quickly populate DB: in Docker
Define data model with DBT
Add test
Define 2 data transformation
Running in Airflow
Set up Airflow in docker-compose
Populate csv wth PostgresOperator

## 1 - Prerequisites

- [Docker](https://docs.docker.com/get-docker/)(8.0 GB of memory and 4 CPUs)
- [Docker Compose CLI plugin](https://docs.docker.com/compose/install/compose-plugin/)
- If running on windows: [Docker remote containers on WSL 2](https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers)
- [dbt CLI](https://docs.getdbt.com/docs/core/installation)(version installed for this demo: 1.6.0, postgres plugin: 1.6.0)

## 2 - Quickstart

DBT is a compiler and runner, it doesn't handle raw data loading directly so we use PostgresOperator in Airflow for the data ingestion (a workaround that could be used for the demo is using "seed" but it is only recommended for static data whilst the withdrawls history is dynamic data). Python can be used for more complex data ingestion scripts.

Try running the following commands:
- dbt run
- dbt test

Orchestration with Airflow, add test task to DAG

## 3 - ELT

### Extract

Python script that will read the CSV and drop the last column, we don't want to store data that carries no information.


## Improvements
- Add architecture diagram for ETL and data viz
- The PK `transaction_id` is an auto-incremented id, this means that duplicate transactions are technically allowed in the table

## Resources:
- [Running Airflow in Docker](https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html)
- 

## Task 2: 

*Please write up no more than 300 words on your opinions of the practical realities of taking a lakehouse approach to building a data stack vs a data mesh approach.*

Source of truth
Central vs decentralized
Data Mesh allows for redunduncies, this is offset by low compute cost and speed/flexibility that we wouldn't have with DWH

In either case we need high quality and reliable data