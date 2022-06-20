**1.** создадим Dockerfile:
```
FROM elasticsearch:7.17.4

MAINTAINER n

# copy the configuration file into the container
COPY elasticsearch.yml /usr/share/elasticsearch/config
RUN mkdir -m 777 /var/lib/elasticsearch && \
    mkdir -m 777 /var/lib/elasticsearch/data && \
    mkdir -m 777 /var/lib/elasticsearch/logs

# expose the default Elasticsearch port
EXPOSE 9200
```
Cсылка на получившийся образ:
https://hub.docker.com/repository/docker/madrockgod/elasticsearch/

ответ на запрос "/":
```
{
  "name" : "netology_test",
  "cluster_name" : "netology-elastic",
  "cluster_uuid" : "--czWKwYRk6mLv2kf3oMKg",
  "version" : {
    "number" : "7.17.4",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "79878662c54c886ae89206c685d9f1051a9d6411",
    "build_date" : "2022-05-18T18:04:20.964345128Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```
**2.** Работа с индексами:

![2](https://user-images.githubusercontent.com/95703090/174651784-0d1693b2-4990-495c-a8ec-9dde18210d73.JPG)
список индексов и их статусов:

![1](https://user-images.githubusercontent.com/95703090/174652027-30d7ff67-851e-4bb9-84f9-6b8618a4e213.JPG)

состояние кластера запросом API:

![3](https://user-images.githubusercontent.com/95703090/174652130-29d41224-dc16-4c78-8855-bb946e24487f.JPG)

Состояние “yellow” говорит нам о том, что у индексов указано число реплик, но им некуда реплицироваться, так как у нас один сервер.

удаление индексов:
```
[almanax@alma8 ~]$ curl -X DELETE "localhost:9200/_all"
```

**3.** Вызов API для создания репозитария:
![31](https://user-images.githubusercontent.com/95703090/174653116-7a7b8836-43fd-4f1e-9bcd-4365279b11d9.JPG)
создание интекса test и список индексов:
![32](https://user-images.githubusercontent.com/95703090/174653268-c9b1f8a9-b17f-46fe-9cd9-2781bd0d751a.JPG)

список файлов в директории snapshots:

![34](https://user-images.githubusercontent.com/95703090/174653489-3d4574ff-a91d-4105-9e98-2d03c8c58576.JPG)

список индексов после удаления первого и создания второго:

![35](https://user-images.githubusercontent.com/95703090/174653627-f4436c41-f7f7-464c-b645-217a6e2f58fd.JPG)

запрос восстановления и итоговый список:

![36](https://user-images.githubusercontent.com/95703090/174653759-9bf1514c-3ba3-424f-8168-1325f6735c07.JPG)


