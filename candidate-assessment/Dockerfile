# syntax=docker/dockerfile:1.7
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /workspace

COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 mvn -B -ntp dependency:go-offline

COPY src ./src
RUN --mount=type=cache,target=/root/.m2 \
    mvn -B -ntp package \
    && mkdir -p /app \
    && cp target/*.jar /app/application.jar

FROM gcr.io/distroless/java17-debian12:nonroot
WORKDIR /app
COPY --from=build --chown=65532:65532 /app/application.jar /app/application.jar
EXPOSE 8080
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0", "-XX:+ExitOnOutOfMemoryError", "-jar", "/app/application.jar"]
