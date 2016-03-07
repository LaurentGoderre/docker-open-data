#!/bin/sh
cp -R /opt/solr/server/solr/configsets/data_driven_schema_configs/ /opt/solr/server/solr/configsets/$CKAN_SOLR_CORE
cp -R /media/solr_conf/schema.xml /opt/solr/server/solr/configsets/$CKAN_SOLR_CORE/conf/
rm /opt/solr/server/solr/configsets/$CKAN_SOLR_CORE/conf/managed-schema
bin/solr create -c $CKAN_SOLR_CORE -d /opt/solr/server/solr/configsets/$CKAN_SOLR_CORE/conf
