
# Dubbo + Zookeeper Example Project

This is a quick start for Apache <a href="https://dubbo.apache.org/en/">Dubbo</a> RPC Framework using <a href="https://zookeeper.apache.org/">Zookeeper</a> as Service Registry Center.
We are building a Dubbo provider, which has multiple instances.
We are also building a Dubbo consumers which communicates with the Dubbo provider instances.

We use Zookeeper in our Distributed System to insure high availability and performance.

<table>
<tr><td>
<b>Important</b>: This tutorial focus on <b>Dubbo with Zookeeper</b>.
If you just want to learn setting up <b>Dubbo with Spring Boot</b> without Zookeeper and Docker then
check out my other repository: <a href="https://github.com/dcnis/dubbo-spring-boot-example">https://github.com/dcnis/dubbo-spring-boot-example</a>
</td></tr>
</table>


## Run application with a single command
```
docker compose up
```
This will spin up
- zookeeper
- dubbo-admin
- dubbo-provider-1 (3x instances)
- dubbo-consumer-1 (1x instance)

## Usage
Use a browser to connect to the dubbo consumer via ```http://localhost:8090/hello```
and we will get a response from one of our three ```dubbo-provider-1``` instances.

## Documentation

### docker-compose-yml

```
version: "3.8"
services:
  zookeeper:
    container_name: zookeeper
    image: zookeeper:3.4.9
    ports:
      - "2181:2181"
    restart: always
    networks:
      - dubbo-net

  dubbo-provider-1-0:
    container_name: dubbo-provider-1-0
    depends_on:
      - zookeeper
    image: dubbo-provider-1-image
    #restart: always
    ports:
      - "8080:8080"
      - "28880:28880"
    networks:
      - dubbo-net
    environment:
      - dubbo.registry.address=zookeeper://zookeeper:2181

  dubbo-provider-1-1:
    container_name: dubbo-provider-1-1
    depends_on:
      - zookeeper
    image: dubbo-provider-1-image
    #restart: always
    ports:
      - "8081:8080"
      - "28881:28880"
    networks:
      - dubbo-net
    environment:
      - dubbo.registry.address=zookeeper://zookeeper:2181

  dubbo-provider-1-2:
    container_name: dubbo-provider-1-2
    depends_on:
      - zookeeper
    image: dubbo-provider-1-image
    #restart: always
    ports:
      - "8082:8080"
      - "28882:28880"
    networks:
      - dubbo-net
    environment:
      - dubbo.registry.address=zookeeper://zookeeper:2181

  dubbo-consumer-1-0:
    container_name: dubbo-consumer-1-0
    depends_on:
      - zookeeper
      - dubbo-provider-1-0
    image: dubbo-consumer-1-image
    #restart: always
    ports:
      - "8090:8080"
      - "28883:28880"
    networks:
      - dubbo-net

  dubbo-admin:
    image: apache/dubbo-admin
    container_name: dubbo-admin
    ports:
      - "8091:8080"
    networks:
      - dubbo-net
    environment:
      - admin.registry.address=zookeeper://zookeeper:2181
      - admin.config-center=zookeeper://zookeeper:2181
      - admin.metadata-report.address=zookeeper://zookeeper:2181
      - dubbo.admin.root.password=root
    depends_on:
      - zookeeper

networks:
  dubbo-net:
    name: dubbo-net
    driver: bridge
```

### application.properties of dubbo provider
Following configuration will connect the dubbo provider with the zookeeper registry center.
```
dubbo.application.name=dubbo-provider-1

# in docker-compose.yml our zookeeper docker container is called 'zookeeper'
zookeeper.docker.container.name=zookeeper

dubbo.registry.address=zookeeper://${zookeeper.docker.container.name}:2181

dubbo.registry.client=curator
dubbo.protocol.name=dubbo
dubbo.protocol.port=20880
dubbo.scan.base-packages=de.dcnis.dubbo
```

### application.properties of dubbo consumer

Following configuration will connect the dubbo consumer with the zookeeper registry center.

```
zookeeper.docker.container.name=zookeeper
dubbo.application.name=dubbo-consumer-1
dubbo.registry.address=zookeeper://${zookeeper.docker.container.name}:2181
dubbo.consumer.timeout=3000
```

## Additional manual instructions

Following commands will help to build docker images, run docker instances from those images and spin up zookeeper gui without docker compose.

## Build docker image from Dockerfile for dubbo provider

```
docker build --no-cache -f dubbo-provider-1.Dockerfile -t dubbo-provider-1-image .
```

## Build docker image from Dockerfile for dubbo consumer

```
docker build --no-cache -f dubbo-consumer-1.Dockerfile -t dubbo-consumer-1-image .
```

## Spin up dubbo provider instance

Here we spin up an instance of ```dubbo-provider-1```
```
docker run --name dubbo-provider-1-0 -d -p 8080:8080 -p 28880:28880 --link zkserver:zkserver dubbo-provider-1-image
```

## Spin up dubbo consumer instance

Here we spin up an instance of ```dubbo-consumer-1```
```
docker run --name dubbo-consumer-1-0 -d -p 8090:8080 -p 28880:28880 --link zkserver:zkserver dubbo-consumer-1-image
```

## Spin up zookeeper as Service Registry Center
```
docker run --name zookeeper --restart always -d zookeeper:3.4.9
```

## Zookeeper GUI

```ZK_DEFAULT_NODE``` is the IP-address of the **zookeeper docker container**.
How to get the IP-address of a docker container, will be explained below.

```
docker run -d \
  -p 8086:8080 \
  -e ZK_DEFAULT_NODE=172.17.0.2:2181/ \
  --name zookeeper-gui \
  -t tobilg/zookeeper-webui
```

## How to get IP-address of docker container

```
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
```


## Setting up Load-Balancing with Dubbo Admin

Connect to Dubbo-Admin
```
http://localhost:8091/
```

Go to ```Service Governance -> Load Balance ```. Here you can create a new Load Balancing rule e.q. Round Robin, Randon or Least Active.