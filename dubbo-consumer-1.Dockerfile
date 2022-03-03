FROM maven:3.8.3-jdk-11
ENV HOME=/home/usr/app
RUN mkdir -p $HOME
WORKDIR $HOME

# copy parent-pom
COPY ./pom.xml $HOME
RUN ["/usr/local/bin/mvn-entrypoint.sh", "mvn", "verify", "clean", "--fail-never"]

# copy pom.xmls
COPY ./dubbo-api/pom.xml $HOME/dubbo-api/
COPY ./dubbo-consumer-1/pom.xml $HOME/dubbo-consumer-1/

# copy module sources
COPY ./dubbo-api/src $HOME/dubbo-api/src
COPY ./dubbo-consumer-1/src $HOME/dubbo-consumer-1/src

RUN ["mvn", "package", "-Pdubbo-consumer-1"]

EXPOSE 8080

CMD ["java", "-jar", "./dubbo-consumer-1/target/dubbo-consumer-1-0.0.1-SNAPSHOT.jar"]
