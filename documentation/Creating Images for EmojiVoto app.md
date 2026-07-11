[Work in Progress, in need of tiding up]
* Install brew packages `protobuf`, `proto-gen-go`, `protoc-gen-go-grpc`
* Pull https://github.com/BuoyantIO/emojivoto/tree/main
* Update docker-compose.yaml to set prometheus ports a
```
  emoji-svc:
    image: buoyantio/emojivoto-emoji-svc:v11
    environment:
      - GRPC_PORT=8080
      - PROM_PORT=8801
    ports:
      - "8081:8080"
      - "8082:8080"

  voting-svc:
    image: buoyantio/emojivoto-voting-svc:v11
    environment:
      - GRPC_PORT=8080
      - PROM_PORT=8801
    ports:
      - "8083:8080"
      - "8804:8801"
```
* Once images create, push up to github


```
docker tag buoyantio/emojivoto-web:v11 ghcr.io/jresmith/emojivoto-web:v1
docker push ghcr.io/jresmith/emojivoto-web:v1
```