import datetime as dt

from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator

with DAG(
    dag_id="transactions_elt",
    description='ELT DAG',
    default_args={
        "retries": 1,
     },
    start_date=dt.datetime(2023, 1, 1),
    schedule="@daily",

) as dag:

    task_ingestion = DockerOperator(
        task_id="parse_and_populate_csv",
        image='data-ingestion:latest',
        docker_url="tcp://docker-proxy:2375",
        network_mode="host",
        api_version='auto',
        auto_remove=True,
    )

    task_transformation = DockerOperator(
        task_id="transform_data",
        image='dbt-tocos:latest',
        docker_url="tcp://docker-proxy:2375",
        network_mode="host",
        api_version='auto',
        auto_remove=True,
        command="run"  # dbt run
    )

    task_tests = DockerOperator(
        task_id="test_transformed_data",
        image='dbt-tocos:latest',
        docker_url="tcp://docker-proxy:2375",
        network_mode="host",
        api_version='auto',
        auto_remove=True,
        command="test"  # dbt test
    )

task_ingestion >> task_transformation
task_transformation >> task_tests
