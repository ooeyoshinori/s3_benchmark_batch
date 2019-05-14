## Procedure to deploy benchmark env.
```bash
ssh root@##{BENCHMARK_SERVERS}##

#########################
## On all servers
yum install git -y
git clone https://github.com/ooeyoshinori/s3_benchmark_batch.git

cd s3_benchmark_batch/
## Add access_key, secret_key, and endpoint
vi ceph_benchmark_test.sh
## ---- sample output ----
if [ "$ENV" == "XXXXXXXX" ]; then
  export AWS_ACCESS_KEY=XXXXXXXX
  export AWS_SECRET_ACCESS_KEY=XXXXXXXX
  ENDPOINT=http://XXXXXXXX
fi
## ---- sample output ----

#########################
## On one of the benchmark servers
ssh root@##{MAIN_BENCHMARK_SERVER}##
ssh-keygen
cat ~/.ssh/id_rsa.pub
## ---- sample output ----
ssh-rsa AAAAB3NzaC1y(..snip..)iku+9ex root@##{MAIN_BENCHMARK_SERVER}##
## ---- sample output ----

#########################
## On all servers
vi ~/.ssh/authorized_keys
## ---- sample output (Add) ----
ssh-rsa AAAAB3NzaC1y(..snip..)iku+9ex root@##{MAIN_BENCHMARK_SERVER}##
## ---- sample output ----

#########################
## On one of the benchmark servers
ssh root@##{MAIN_BENCHMARK_SERVER}##
cp /root/s3_benchmark_batch/six_node_bench_object.sh{,.org}
vi /root/s3_benchmark_batch/six_node_bench_object.sh
diff /root/s3_benchmark_batch/six_node_bench_object.sh{,.org}
## ---- sample output ----
22c22
< array=(##{BENCHMARK_SERVER_HOSTNAME_A}## ##{BENCHMARK_SERVER_HOSTNAME_B}##)
---
> array=(##{BENCHMARK_SERVERS_HOSTNAME}##)
## ---- sample output ----
```

## How to benchmark
```bash
#########################
## On one of the benchmark servers
ssh root@##{MAIN_BENCHMARK_SERVER}##
## for preventing login confirmation
ssh root@##{MAIN_BENCHMARK_SERVER}##
ssh root@##{ANOTHER_BENCHMARK_SERVER}##

export benchmark_env=##{BENCHMARK_ENV}##
export benchmark_bucket=##{BENCHMARK_BUCKET}##
export benchmark_operation=##{BENCHMARK_OPERATION}## ## put get putget9010 putget1090
export benchmark_concurrency=##{BENCHMARK_CONCURRENCY}##
export benchmark_request=##{BENCHMARK_REQUEST}##
export benchmark_size=##{BENCHMARK_SIZE}##

## Exexute benchmark batch (MAIN)
/root/s3_benchmark_batch/six_node_bench_object.sh ## DRY_RUN
GO=YES /root/s3_benchmark_batch/six_node_bench_object.sh

tail -f /root/s3_benchmark_batch/xxxxxxxx.log
```

### How to delete all objects on targeted bucket
```bash
## need to install aws cli
yum install epel-release
yum install python-pip -y
pip install awscli --upgrade --user
cp /root/.local/bin/aws /usr/local/bin/

cd /root/s3_benchmark_batch
vi ./empty_bucket.sh
## ---- sample output ----
if [ "$ENV" == "XXXXXXXX" ]; then
  export AWS_ACCESS_KEY=XXXXXXXX
  export AWS_SECRET_ACCESS_KEY=XXXXXXXX
  ENDPOINT=http://XXXXXXXX
fi
## ---- sample output ----


## need to add access-key and secret-key pair on ~/.aws/credentials file
chmod a+x ./empty_bucket.sh
export benchmark_env=##{BENCHMARK_ENV}##
export benchmark_bucket=##{BENCHMARK_BUCKET}##
/root/s3_benchmark_batch/empty_bucket.sh ## For dry-run
GO=YES /root/s3_benchmark_batch/empty_bucket.sh
```

### How to calculate output (sample)
```bash
ssh root@##{MAIN_BENCHMARK_SERVER}##
python /root/s3_benchmark_batch/aggregate_benchmark.py ##{TARGETED_FILE}##
```
