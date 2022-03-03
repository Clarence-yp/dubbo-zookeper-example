
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


## Build docker image from Dockerfile

```
 docker build --no-cache -f dubbo-provider-1.Dockerfile -t dubbo-provider-1-image .
```

## Spin up dubbo de.dcnis.dubbo.provider
```
docker run --name my-micro-server -d -p 8080:8080 -p 28880:28880  -e Dubbo_IP_TO_REGISTRY=192.168.2.2 --link zkserver:zkserver dubbo-docker-sample
```

## Zookeeper GUI

```ZK_DEFAULT_NODE``` is the IP-address of the **zookeeper docker container**.

```
docker run -d \
  -p 8086:8080 \
  -e ZK_DEFAULT_NODE=172.17.0.2:2181/ \
  --name zk-web \
  -t tobilg/zookeeper-webui
```

## How to get Docker IP-address

```
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
```