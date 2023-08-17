FROM apache/airflow:2.6.3

# Switch to the airflow user
USER airflow

# Install Docker provider in Airflow
RUN pip install --no-cache-dir apache-airflow-providers-docker

# Switch to the root user
# IMPORTANT: Not suitable for production use!
USER root
