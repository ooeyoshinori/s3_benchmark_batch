#!/bin/bash -eu

###########
## Usage

if [ "$1" == "--help" -o "$1" == "-h" ]; then
  echo "Usage: $0 [ENV] [BUCKET] [OPERATION] [CONCURRENCY] [REQUESTS] [DURATION] [SIZE]"
  echo "Parameter : "
  echo "  ENV : iaas or baremetal"
  echo "  BUCKET : targeted bucket name"
  echo "  OPERATION : get or put"
  echo "  CONCURRENCY : num of parallel"
  echo "  REQUESTS : num of request"
  echo "  DURATION : num of seconds"
  echo "  SIZE : file size"
  exit 0
fi

if [ $# -ne 7 ]; then
  echo "You put $# parameter. Need to put 7 parameters for working on."
  echo "Type \"$0 -h\" for showing option menu"
  exit 1
fi

## VAR
HOME_DIR=`pwd`
HOST_NUM=`hostname -s`

echo "start $HOST_NUM operation"

#############
## PARAMETERs
ENV=$1
BUCKET=$2
OPERATION=$3
CONCURRENCY=$4
REQUESTS=$5
DURATION=$6
SIZE=$7

GOBENCH=${GO:-hoge}

if [ "$ENV" == "##{ENV}##" ]; then
  export AWS_ACCESS_KEY=##{AWS_ACCESS_KEY}##
  export AWS_SECRET_ACCESS_KEY=##{AWS_SECRET_ACCESS_KEY}##
  ENDPOINT=http://##{ENDPOINT_PUBLIC_HOSTNAME}##
fi

DATE_YMDHMS=`date +%Y%m%d_%H%M%S`
DATE_YMD=`date +%Y%m%d`

## MAIN
if [ "$OPERATION" == "get" ]; then
  TEST_COMMAND="$HOME_DIR/s3tester.2.1.1 -concurrency=$CONCURRENCY -operation=get -requests=$REQUESTS -retries=3 -retrysleep=1000 -endpoint="$ENDPOINT" -bucket=$BUCKET -prefix=con$CONCURRENCY-$HOST_NUM-s$SIZE -json"
elif [ "$OPERATION" == "putget9010" ]; then
  TEST_COMMAND="$HOME_DIR/s3tester.2.1.1.ex2 -concurrency=$CONCURRENCY -size=$SIZE -requests=$REQUESTS -endpoint="$ENDPOINT" -bucket=$BUCKET -prefix=con$CONCURRENCY-putget-$HOST_NUM-s$SIZE -json -workload="/root/s3_benchmark_batch/putget_ratio_json/s3tester_workload9010_$REQUESTS.json""
elif [ "$OPERATION" == "putget1090" ]; then
  TEST_COMMAND="$HOME_DIR/s3tester.2.1.1.ex2 -concurrency=$CONCURRENCY -size=$SIZE -requests=$REQUESTS -endpoint="$ENDPOINT" -bucket=$BUCKET -prefix=con$CONCURRENCY-putget-$HOST_NUM-s$SIZE -json -workload="/root/s3_benchmark_batch/putget_ratio_json/s3tester_workload1090_$REQUESTS.json""
else
  TEST_COMMAND="$HOME_DIR/s3tester.2.1.1 -concurrency=$CONCURRENCY -size=$SIZE -operation=$OPERATION -requests=$REQUESTS -endpoint="$ENDPOINT" -bucket=$BUCKET -prefix=con$CONCURRENCY-$HOST_NUM-s$SIZE -json"
fi

ALL_LOG="$HOME_DIR/$ENV.test_result_$DATE_YMD.log"
BENCHMARK_LOG="$HOME_DIR/$ENV.test_result_throughput_$DATE_YMD.log"

if [ "$GOBENCH" = "YES" ] ; then
  echo "---- $DATE_YMDHMS -------" | tee -a "$ALL_LOG" > $BENCHMARK_LOG
  echo $TEST_COMMAND | tee -a "$ALL_LOG" >> $BENCHMARK_LOG
  $TEST_COMMAND 2>&1 | tee -a "$ALL_LOG" >> $BENCHMARK_LOG
else
  echo "## DRYRUN ---- $DATE_YMDHMS -------" | tee -a "$ALL_LOG" > $BENCHMARK_LOG
  echo $TEST_COMMAND  | tee -a "$ALL_LOG" >> $BENCHMARK_LOG
  echo "## DRYRUN END -----------"  | tee -a "$ALL_LOG" >> $BENCHMARK_LOG
fi

echo "end $HOST_NUM operation : `cat $BENCHMARK_LOG`"
