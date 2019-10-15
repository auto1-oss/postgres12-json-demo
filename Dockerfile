FROM maven AS build-env

COPY pom.xml pom.xml
RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.1:go-offline && mvn dependency:resolve-plugins

ADD . .
RUN mvn clean package


FROM gcr.io/distroless/java:11
COPY --from=build-env /target/postgres12-0.0.1-SNAPSHOT.jar /app.jar
CMD ["app.jar"]
