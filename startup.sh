#!/bin/bash

mongo="${MONGO:-mongo}"
mongoport="${MONGOPORT:-27017}"
elasticsearch="${ELASTICSEARCH:-elasticsearch}"
elasticport="${ELASTICPORT:-9200}"


function _mongo() {
    mongo --quiet --host ${mongo} --port ${mongoport} <<EOF
    $@
EOF
}

#is_master_result="false"
is_master_result=$(_mongo "rs.isMaster().ismaster")
expected_result="true"

while true;
do
  echo "is_master_result: ${is_master_result}"
  if [ "${is_master_result}" != "${expected_result}" ] ; then
    echo "Initiate Mongod node to become primary node..."
    _mongo "rs.initiate()"
    is_master_result=$(_mongo "rs.isMaster().ismaster")
    echo "Waiting for Mongod node to assume primary status..."
    sleep 3
  else
    echo "Mongod node is now primary"
    break;
  fi
done

sleep 1

echo "Starting mongo-connector"
mongo-connector --auto-commit-interval=0 --oplog-ts=/data/oplog.ts -m ${mongo}:${mongoport} -t ${elasticsearch}:${elasticport} -d elastic2_doc_manager
