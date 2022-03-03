
# Dubbo Zookeeper Example Project

This is a quick start for Alibaba's dubbo RPC Framework using Zookeeper as Registry Server.
We are building multiple dubbo providers, each having multiple instances in our distributed system in order to insure high availability.
We are also having multiple consumers which are communicating with the providers.

You can imagine we are building a distributed system with lots of services (dubbo providers) 
and millions of clients (dubbo consumers) which are using our system.

In our example we are having 3 providers. For each of them we are spinning up multiple instances later on.
- dubbo-de.dcnis.dubbo.provider-1
- dubbo-de.dcnis.dubbo.provider-2
- dubbo-de.dcnis.dubbo.provider-3

We are also having multiple consumers.
- dubbo-consumer-1
- dubbo-consumer-2
- dubbo-consumer-3


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