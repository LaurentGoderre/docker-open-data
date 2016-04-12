#!/bin/sh
export PROJECT_NAME=opendataportal

export SOLR_COMPOSE=docker-compose.solr.yml
export SOLR_CONTAINER=${PROJECT_NAME}_solr_1
export POSTGRES_COMPOSE=docker-compose.postgres.yml
export POSTGRES_CONTAINER=${PROJECT_NAME}_postgres_1

export PROJECT_ROOT=../..
export CONFIG = ${PROJECT_ROOT}/${PROJECT_NAME}.ini
export VENV_PATH = ${PROJECT_ROOT}/.venv-${PROJECT_NAME}

default: up

init: build init-postgres set-permissions-postgress load-orgs

build: build-postgres build-solr

rebuild: rebuild-postgres rebuild-solr

up: up-postgres up-solr

stop: stop-postgres stop-solr

down: down-postgres down-solr

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
	docker-compose -f ${POSTGRES_COMPOSE} -p ${PROJECT_NAME} up -d

stop-postgres:
	docker-compose -f ${POSTGRES_COMPOSE} -p ${PROJECT_NAME} stop

down-postgres:
	docker-compose -f ${POSTGRES_COMPOSE} -p ${PROJECT_NAME} down
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
	docker-compose -f ${SOLR_COMPOSE} -p ${PROJECT_NAME}  up -d

stop-solr:
	docker-compose -f ${SOLR_COMPOSE} -p ${PROJECT_NAME} stop

down-solr:
	docker-compose -f ${SOLR_COMPOSE} -p ${PROJECT_NAME} down

# Others
load-orgs:
	. ${VENV_PATH}/bin/activate && \
		ckanapi load organizations \
			-I ${PROJECT_ROOT}/ckanext-canada/transitional_orgs.jsonl \
			-c ${CONFIG}
