.PHONY: build-ingestion-image

ENV = test
IMAGE_TAG = data-ingestion:latest
DRUN = docker run --rm -e ENVIRONMENT=${ENV}
DBASH = $(DRUN) -u root -v ${PWD}:/foo -w="/foo" python bash -c 

# Build Docker image that is used to run the Python script
build-data-ingestion-image:
	docker build -f data_ingestion/Dockerfile -t ${IMAGE_TAG} data_ingestion

# Auto-generate requirements.txt based on requirements.in
pip-compile:
	$(DBASH) \
	"pip install -U pip && \
	pip install pip-tools && \
	pip-compile --output-file data_ingestion/requirements.txt data_ingestion/requirements.in"

up:
	docker-compose up postgres-db

down:
	docker-compose down --volumes --rmi all

populate-db:
	$(DRUN) --network host ${IMAGE_TAG}

check-data-raw:
	psql -h localhost -d postgres -W postgres -p 5432 -U postgres -c "SELECT * from raw.transactions"

check-data-staging:
	psql -h localhost -d postgres -W postgres -p 5432 -U postgres -c "SELECT * from staging.transactions"
