FROM maven:3.8.3-jdk-11
ENV HOME=/home/usr/app
RUN mkdir -p $HOME
WORKDIR $HOME
COPY pom.xml $HOME
RUN ["/usr/local/bin/mvn-entrypoint.sh", "mvn", "verify", "clean", "--fail-never"]
COPY ./src $HOME/src
RUN ["mvn", "package"]
EXPOSE 8085
CMD ["java", "-jar", "./target/dubbo-demo-provider-0.0.1-SNAPSHOT.jar"]
