#!/bin/bash -eu

#############
## PARAMETERs
ENV=`env | grep benchmark_env | cut -d= -f 2`
BUCKET=`env | grep benchmark_bucket | cut -d= -f 2`
PAGESIZE=10000000 ## one million objects

## VAR
HOME_DIR=/root/benchmark_batch
DATE_YMDHMS=`date +%Y%m%d_%H%M%S`
DATE_YMD=`date +%Y%m%d`

ALL_LOG="$HOME_DIR/$ENV.test_result_$DATE_YMD.log"

echo "start empty_bucket operation" >> "$ALL_LOG"

GOBENCH=${GO:-hoge}

if [ "$ENV" == "##{ENV}##" ]; then
  PROFILE=##{PROFILE}##
  ENDPOINT=http://##{ENDPOINT}##
fi


## MAIN
TEST_COMMAND="aws s3 --profile $PROFILE --endpoint-url $ENDPOINT rm s3://$BUCKET --recursive --only-show-errors --page-size $PAGESIZE"
COUNT_COMMAND="aws s3 --profile $PROFILE --endpoint-url $ENDPOINT ls s3://$BUCKET --recursive --human --sum"

if [ "$GOBENCH" = "YES" ] ; then
  echo "---- $DATE_YMDHMS -------" >> "$ALL_LOG"
  echo $TEST_COMMAND >> "$ALL_LOG"
  echo $COUNT_COMMAND >> "$ALL_LOG"
  $TEST_COMMAND 2>&1 >> "$ALL_LOG"
  $COUNT_COMMAND 2>&1 >> "$ALL_LOG"
else
  echo "## DRYRUN ---- $DATE_YMDHMS -------" >> "$ALL_LOG"
  echo $TEST_COMMAND >> "$ALL_LOG"
  echo $COUNT_COMMAND >> "$ALL_LOG"
  echo "## DRYRUN END -----------" >> "$ALL_LOG"
fi

echo "end empty bucket operation" >> "$ALL_LOG"
