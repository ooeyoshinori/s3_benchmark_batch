#!/bin/bash -eu

## CAUTION : Please put "GO=YES" when executing the command. Without it, it will be "DRYRUN"
## MEMO
## ENV : iaas or baremetal
## OPERATION : get or put
## CONCURRENCY : num of parallel
## REQUESTS : num of request
## DURATION : num of seconds
## SIZE : file size
## ./ceph_benchmark_test.sh [ENV] [OPERATION] [CONCURRENCY] [REQUESTS] [DURATION] [SIZE]

ENV=`env | grep benchmark_env | cut -d= -f 2`
BUCKET=`env | grep benchmark_bucket | cut -d= -f 2`
OPERATION=`env | grep benchmark_operation | cut -d= -f 2`
CONCURRENCY=`env | grep benchmark_concurrency | cut -d= -f 2`
REQUESTS=`env | grep benchmark_request | cut -d= -f 2`
DURATION=`env | grep benchmark_duration | cut -d= -f 2`
SIZE=`env | grep benchmark_size | cut -d= -f 2`

## Benchmark servers array
array=(##{BENCHMARK_SERVERS_HOSTNAME}##)
GOBENCH=${GO:-hoge}
for node in "${array[@]}"
do
  ## Modify HERE !!
  ## ./ceph_benchmark_test.sh [ENV] [BUCKET] [OPERATION] [CONCURRENCY] [REQUESTS] [DURATION] [SIZE]
  ssh root@$node "cd ~/s3_benchmark_batch; GO=$GOBENCH ./ceph_benchmark_test.sh $ENV $BUCKET $OPERATION $CONCURRENCY $REQUESTS 2 $SIZE" &
  ## ssh root@$node "cd ~/benchmark_batch; GO=$GOBENCH ./ceph_benchmark_test.sh $ENV $BUCKET get $CONCURRENCY $REQUESTS 3 $SIZE" &
done
