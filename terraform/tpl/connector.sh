#!/bin/bash

###########################################
############# HTTP Connector ##############
###########################################

CONNECTOR_NAME=$(curl -X GET ${kafkaConnectUrl}/connectors/myfunction | jq '.name')

if [ -n "$CONNECTOR_NAME" ]; then
   curl -X DELETE ${kafkaConnectUrl}/connectors/myfunction
fi

curl -s -X POST -H 'Content-Type: application/json' --data @connector.json ${kafkaConnectUrl}/connectors
