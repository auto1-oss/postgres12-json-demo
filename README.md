Demo spring application which is used as a benchmark.

The app compares a performance of JPA based endpoint vs. a JDBC based one which leverages Postgres' Common Table Expressions together with it's JSON processing capabilities.

Required to run the benchmark:
- java
- jmeter
- docker, docker-compose

Just issue `./runme.sh` to run the benchmark.