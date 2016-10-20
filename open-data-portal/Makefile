#!/bin/sh
export PROJECT_NAME=opendataportal

export SOLR_CONTAINER=${PROJECT_NAME}_solr_1
export POSTGRES_CONTAINER=${PROJECT_NAME}_postgres_1

export PROJECT_ROOT=../..
export CONFIG = ${PROJECT_ROOT}/${PROJECT_NAME}.ini
export VENV_PATH = ${PROJECT_ROOT}/.venv-${PROJECT_NAME}

default: up

init: build init-postgres set-permissions-postgress load-orgs

build: build-postgres build-solr

rebuild: down up

up: docker-compose up -d

stop: docker-compose stop -d

down: docker-compose down -d

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
