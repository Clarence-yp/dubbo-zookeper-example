

## Spin up dubbo provider
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