#!/bin/bash

IP=$(ip addr list eth0 |grep "inet " |cut -d' ' -f6|cut -d/ -f1)
truncate -s 0 /usr/local/flink/conf/slaves
sed -i s/localhost/$IP/g /usr/local/flink/conf/flink-conf.yaml
START=1
for (( c=$START; c<=$SLAVES; c++))
do
   ssh slave$c "sed -i s/localhost/$IP/g /usr/local/flink/conf/flink-conf.yaml"
   echo slave$c >> /usr/local/flink/conf/slaves
done

/usr/local/flink/bin/start-cluster.sh

