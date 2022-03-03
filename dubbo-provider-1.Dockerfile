FROM maven:3.8.3-jdk-11
ENV HOME=/home/usr/app
RUN mkdir -p $HOME
WORKDIR $HOME
COPY ./pom.xml $HOME
RUN ["/usr/local/bin/mvn-entrypoint.sh", "mvn", "verify", "clean", "--fail-never"]
COPY ./dubbo-provider-1/src $HOME/dubbo-provider-1/src
COPY ./dubbo-provider-1/pom.xml $HOME/dubbo-provider-1/
RUN ["mvn", "package"]
EXPOSE 8085
CMD ["java", "-jar", "./dubbo-provider-1/target/dubbo-provider-1-0.0.1-SNAPSHOT.jar"]
