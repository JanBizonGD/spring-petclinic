FROM eclipse-temurin:latest
RUN mkdir -p /opt/petclinic && cd /opt/petclinic
COPY build/libs/* /opt/petclinic/
COPY src/* ./src
WORKDIR /opt/petclinic/
EXPOSE 8080
ENTRYPOINT [ "java", "org.springframework.boot.loader.loader.JarLauncher" ]
#ENTRYPOINT [ "java", "-jar", "target/app.jar" ]
