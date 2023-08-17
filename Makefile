.PHONY: build-data-ingestion-image build-docker-airflow build-dbt-image \
 build-all-images pip-compile up down \
 populate-db check-data-raw check-data-staging

PYTHON_IMAGE_TAG = data-ingestion:latest
AIRFLOW_IMAGE_TAG = docker.io/library/docker-airflow:latest
DBT_IMAGE_TAG = dbt-tocos:latest
SUPERSET_IMAGE_TAG = superset-tocos:latest
DRUN = docker run --rm
DBASH = $(DRUN) -u root -v ${PWD}:/foo -w="/foo" python bash -c 

# Build Docker image that is used to run the Python script
build-data-ingestion-image:
	docker build -f data_ingestion/Dockerfile -t ${PYTHON_IMAGE_TAG} data_ingestion

# Build Docker image that is used for Airflow
build-docker-airflow:
	docker build -f airflow/Dockerfile -t ${AIRFLOW_IMAGE_TAG} airflow

# Build Docker image that is used for Airflow
build-dbt-image:
	docker build -f dbt/Dockerfile -t ${DBT_IMAGE_TAG} dbt

# Build Docker image that is used for the data vizualization
build-superset-image:
	docker build -f superset/Dockerfile -t ${SUPERSET_IMAGE_TAG} superset

# Build all images needed for this demo
build-all-images:
	make build-data-ingestion-image build-docker-airflow build-dbt-image build-superset-image

# Auto-generate requirements.txt based on requirements.in
pip-compile:
	$(DBASH) \
	"pip install -U pip && \
	pip install pip-tools && \
	pip-compile --output-file data_ingestion/requirements.txt data_ingestion/requirements.in"

# Spin up PostgresDB datawarehouse and Airflow components
up:
	# Quick-start needs to know your host user id and needs to have group id set to 0
	# cf https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html#setting-the-right-airflow-user
	echo "AIRFLOW_UID=$$(id -u)\nAIRFLOW_IMAGE_NAME=${AIRFLOW_IMAGE_TAG}" > .env

	# Run database migrations and create the first user account
	docker compose up airflow-init
	docker compose up

# Clean-up
down:
	docker compose down --volumes --remove-orphans

# For quick debugging
populate-db:
	$(DRUN) --network host ${PYTHON_IMAGE_TAG}

# For quick debugging
check-data-raw:
	psql -h localhost -d postgres -W postgres -p 5431 -U postgres -c "SELECT * from raw.transactions"

# For quick debugging
check-data-staging:
	psql -h localhost -d postgres -W postgres -p 5431 -U postgres -c "SELECT * from staging.transactions"
