FROM openjdk:8-jre
ADD target/kube-stateless-1.0-SNAPSHOT.jar kube-stateless.jar
EXPOSE 8080
ENTRYPOINT ["java", \
                "-Djava.net.preferIPv4Stack=true", \
                "-jar", \
                "/kube-stateless.jar", \
                "--server.port=8080"]