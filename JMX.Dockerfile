FROM eclipse-temurin:latest AS deps

WORKDIR /build

COPY ./src src/
COPY ./mvnw ./mvnw
COPY ./.mvn ./.mvn
RUN --mount=type=bind,source=pom.xml,target=pom.xml \
    --mount=type=cache,target=/root/.m2 \
    ./mvnw package -DskipTests && \
    mv target/$(./mvnw help:evaluate -Dexpression=project.artifactId -q -DforceStdout)-$(./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout).jar target/app.jar
RUN java -Djarmode=layertools -jar target/app.jar extract --destination target/extracted


################################################################################

FROM eclipse-temurin:21-jre-alpine AS final

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser
USER appuser

COPY --from=deps build/target/extracted/dependencies/ ./
COPY --from=deps build/target/extracted/spring-boot-loader/ ./
COPY --from=deps build/target/extracted/snapshot-dependencies/ ./
COPY --from=deps build/target/extracted/application/ ./

EXPOSE 8080
EXPOSE 9020

ENTRYPOINT [ "java",\
 "-Dcom.sun.management.jmxremote=true",\
"-Dcom.sun.management.jmxremote.port=9020",\
"-Dcom.sun.management.jmxremote.rmi.port=9020",\
"-Dcom.sun.management.jmxremote.local.only=false",\
"-Dcom.sun.management.jmxremote.authenticate=false",\
"-Dcom.sun.management.jmxremote.ssl=false",\
"-Djava.rmi.server.hostname=172.17.0.4",\
"org.springframework.boot.loader.launch.JarLauncher" ]
