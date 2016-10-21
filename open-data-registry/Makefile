#!/bin/sh
export PROJECT_NAME=opendataregistry

export SOLR_CONTAINER=${PROJECT_NAME}_solr_1
export POSTGRES_CONTAINER=${PROJECT_NAME}_postgres_1

export PROJECT_ROOT=../..
export CONFIG = ${PROJECT_ROOT}/${PROJECT_NAME}.ini
export VENV_PATH = ${PROJECT_ROOT}/.venv-${PROJECT_NAME}

default: up

init: build init-postgres set-permissions-postgress load-orgs

build: build-postgres build-solr

rebuild: down up

up:
	docker-compose up -d

stop:
	docker-compose stop

down:
	docker-compose down

# Postgres config
build-postgres: up-postgres

rebuild-postgres: down-postgres build-postgres

init-postgres:
	. ${VENV_PATH}/bin/activate && \
		paster --plugin=ckan db init -c ${CONFIG}

set-permissions-postgress:
	. ${VENV_PATH}/bin/activate && \
		paster --plugin=ckan datastore set-permissions -c ${CONFIG} | cat | \
		docker exec -i --user=postgres ${POSTGRES_CONTAINER} psql

up-postgres:
	docker-compose up -d postgres

stop-postgres:
	docker-compose stop postgres

down-postgres:
	docker-compose down postgres
# Solr Config
build-solr: up-solr
	#docker exec -it --user=solr ${SOLR_CONTAINER} \
	#	/docker-entrypoint-initsolr.d/create-core.sh
	docker exec -it ${SOLR_CONTAINER} \
		/docker-entrypoint-initsolr.d/create-core-old.sh
	while ! docker logs ${SOLR_CONTAINER} | grep "Started"; \
			do sleep 0.1; \
		done

rebuild-solr: down-solr build-solr

up-solr:
	docker-compose up -d solr

stop-solr:
	docker-compose stop solr

down-solr:
	docker-compose down solr

# Others
load-orgs:
	. ${VENV_PATH}/bin/activate && \
		ckanapi load organizations \
			-I ${PROJECT_ROOT}/ckanext-canada/transitional_orgs.jsonl \
			-c ${CONFIG}

build-venv:
	virtualenv --no-site-packages ${VENV_PATH}
	. ${VENV_PATH}/bin/activate && \
		cd ${PROJECT_ROOT}/ckan/ && \
			pip install -r requirements.txt && \
			pip install -r dev-requirements.txt && \
			python setup.py develop && \
		cd ../ckanapi/ && \
			python setup.py develop && \
		cd ../ckanext-canada/ && \
			pip install -r requirements.txt && \
			python setup.py develop && \
		cd ../ckanext-fluent/ && \
			python setup.py develop && \
		cd ../ckanext-googleanalytics/ && \
			python setup.py develop && \
		cd ../ckanext-recombinant/ && \
			pip install -r requirements.txt && \
			python setup.py develop && \
		cd ../ckanext-scheming/ && \
			pip install -r requirements.txt && \
			python setup.py develop && \
		cd ../ckanext-wet-boew/ && \
			pip install -r requirements.txt && \
			python setup.py develop && \
		find . -name "*.pyc" -exec rm -rf {} \;

down-venv:
	rm -R ${VENV_PATH}

rebuild-venv: down-venv build-venv
