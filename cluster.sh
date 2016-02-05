#!/bin/bash

set -e

N=${1:-3}
CUR_DIR="$PWD"

MASTER_NAME="master"

docker run -d --name resolvable --hostname resolvable -v /var/run/docker.sock:/tmp/docker.sock -v /etc/resolv.conf:/tmp/resolv.conf mgood/resolvable
docker run -d --name $MASTER_NAME -h $MASTER_NAME -e "SLAVES=$N"  gustavonalle/flink

START=1
for (( c=$START; c<=$N; c++)) 
do
   docker run -d -h slave$c gustavonalle/flink
done

sleep 5

docker exec  $MASTER_NAME /usr/local/flink/bin/start-cluster-wrapper.sh

echo  "Cluster started. Dashboard on http://$MASTER_NAME:8081/#/overview"
