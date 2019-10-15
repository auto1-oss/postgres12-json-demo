#!/usr/bin/env sh

# configure JMeter
export HEAP="-Xms3g -Xmx3g"

# configure benchmark
export WARMUP_REQUESTS_COUNT=100
export BENCHMARK_REQUESTS_COUNT=20000
export ORDER_IDS_LOCATION="$PWD/jmeter/orderIds.csv"

docker-compose --compatibility down && docker-compose --compatibility build --build-arg POSTGRES_VERSION=12
rm -rf jmeter_run && mkdir jmeter_run && cd jmeter_run || exit

# run the benchmarks
echo "$(date "+%Y-%m-%d %H:%M:%S") ############# Welcome!"
echo
echo

for iteration in 1 2 3
do
  export ENDPOINT_VERSION="v${iteration}"
  echo "$(date "+%Y-%m-%d %H:%M:%S") #### About to run JMeter $ENDPOINT_VERSION endpoint"

  echo "$(date "+%Y-%m-%d %H:%M:%S") ## Preparing environment"
  docker-compose --compatibility up -d && sleep 20
  echo

  echo "$(date "+%Y-%m-%d %H:%M:%S") #### About to run JMeter with 'get_orders_benchmark_${ENDPOINT_VERSION}.jmx'"

  echo "$(date "+%Y-%m-%d %H:%M:%S") ## Prewarming environment"
  sed -e "s/WARMUP_REQUESTS_COUNT/$WARMUP_REQUESTS_COUNT/g" \
       -e "s+ORDER_IDS_LOCATION+$ORDER_IDS_LOCATION+g" \
       -e "s/ENDPOINT_VERSION/$ENDPOINT_VERSION/g" \
       ../jmeter/get_orders_warmup_template.jmx > get_orders_warmup_${ENDPOINT_VERSION}.jmx
  jmeter -n -t get_orders_warmup_${ENDPOINT_VERSION}.jmx -l warmup_results_${ENDPOINT_VERSION}.csv
  echo

  echo "$(date "+%Y-%m-%d %H:%M:%S") ## Running benchmark"
  sed -e "s/BENCHMARK_REQUESTS_COUNT/$BENCHMARK_REQUESTS_COUNT/g" \
       -e "s+ORDER_IDS_LOCATION+$ORDER_IDS_LOCATION+g" \
       -e "s/ENDPOINT_VERSION/$ENDPOINT_VERSION/g" \
       ../jmeter/get_orders_benchmark_template.jmx > get_orders_benchmark_${ENDPOINT_VERSION}.jmx
  jmeter -n -t get_orders_benchmark_${ENDPOINT_VERSION}.jmx -l results.csv
  echo

  echo "$(date "+%Y-%m-%d %H:%M:%S") ## JMeter finished - checking memory consumption"
  docker stats --no-stream --format "table {{.Name}}\t{{.MemUsage}}\t{{.MemPerc}}"

  docker-compose --compatibility down
  echo
  echo
done

# prepare report
echo "$(date "+%Y-%m-%d %H:%M:%S") ############# Finished the benchamrk - generating report"

jmeter -g results.csv -o report
echo "Report generated in $PWD/report/index.html"
open file://$PWD/report/index.html || true
