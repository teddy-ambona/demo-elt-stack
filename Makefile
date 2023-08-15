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

create-table:
	psql -h localhost -d postgres -W postgres -p 5432 -U postgres -f create_table.sql

populate-db:

# populate-db:
# 	psql -h localhost -d postgres -W postgres -p 5432 -U postgres -c "\copy transactions (account_number, transaction_date, transaction_details, cheque_number, value_date, withdrawal_amount, deposit_amount, balance_amount) FROM 'data/transactions_data.csv' DELIMITER ',' csv header;"