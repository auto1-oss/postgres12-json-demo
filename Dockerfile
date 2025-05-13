#
# This file is part of the auto1-oss/postgres12-json-demo.
#
# (c) AUTO1 Group SE https://www.auto1-group.com
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

FROM maven AS build-env

COPY pom.xml pom.xml
RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.1:go-offline && mvn dependency:resolve-plugins

ADD . .
RUN mvn clean package


FROM gcr.io/distroless/java:11
COPY --from=build-env /target/postgres12-0.0.1-SNAPSHOT.jar /app.jar
CMD ["app.jar"]
