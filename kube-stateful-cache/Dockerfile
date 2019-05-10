FROM openjdk:8-jre
ADD target/kube-stateful-cache-1.0-SNAPSHOT.jar kube-stateful-cache.jar
EXPOSE 8080
ENTRYPOINT ["java", \
                "-Djava.net.preferIPv4Stack=true", \
                "-jar", \
                "/kube-stateful-cache.jar", \
                "--server.port=8080"]