1. действия по созданию форка nginx:
``` 
docker pull nginx
mkdir vnginx
cd vnginx
nano dockerfile
```
делаем dockerfile с таким содержимым:
```
FROM nginx:latest
COPY ./index.html /usr/share/nginx/html/index.html
```
модифицируем index.html данными из задания и собираем наш форк:
```
nano index.html
docker build -t madrockgod/nginx_clone:0.1 .
docker login -u madrockgod
docker push madrockgod/nginx_clone:0.1
```
https://hub.docker.com/repository/docker/madrockgod/nginx_clone - ссылка на получившийся форк

2. Сценарии использования:
- Высоконагруженное монолитное java веб-приложение - необходимо использовать физический сервер, т.к. высокая нагрузка, нужен доступ к ресурсам без использования прослоек гипервизора.
- Nodejs веб-приложение - среда серверных приложений основанных на JavaScript отлично работает как Docker контейнер.
- Мобильное приложение с версиями для Android и iOS - тут лучше всего подойдет виртуальная машина эмулирующая указанную среду или нативное устройство.
- Шина данных на базе Apache Kafka - для данной задачи лучше использовать отдельную виртуальную среду.
- Elasticsearch кластер и ноды logstash и kibana - виртуальная машина, так как требуется отказоустойчивая и непрерывная работа.
- Мониторинг-стек на базе Prometheus и Grafana - задачи решаемые этими средствами вписываются в использование контейнеризации Docker.
- MongoDB - целесообразно использовать виртуальный сервер, использование физического видится избыточным.
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry- я думаю, в условиях параноидального подхода к  безопасности приходится использовать физический сервер, в остальных случаях допустимо использовать виртуальный хост.

3. Демонстрация взаимодействия контейнеров:
```
cd 5.3
mkdir data
docker pull centos 
docker run -d   -it   --name 5.3centos   --mount  type=bind,source=/home/almanax/5.3/data,target=/data   centos:latest
docker pull debian
docker run -d   -it   --name 5.3debian   --mount type=bind,source=/home/almanax/5.3/data,target=/data   debian:latest
docker exec -it 5.3centos touch /data/textfile
cd ~/5.3/data
touch textfile2.txt
ls
textfile  textfile2.txt
docker exec -it 5.3debian ls /data
textfile  textfile2.txt
```

4. Повторение технического демо:
```
mkdir ansible2
cd ansible2
docker build -t madrockgod/ansible:2.10.0 .
…
Step 3/5 : RUN mkdir /ansible &&     mkdir -p /etc/ansible &&     echo 'localhost' > /etc/ansible/hosts
 ---> Running in 34c2ee24768c
Removing intermediate container 34c2ee24768c
 ---> d058984abfaf
Step 4/5 : WORKDIR /ansible
 ---> Running in b50e13451f93
Removing intermediate container b50e13451f93
 ---> 0de6af211720
Step 5/5 : CMD [ "ansible-playbook", "--version" ]
 ---> Running in 002444e05ac6
Removing intermediate container 002444e05ac6
 ---> f62c90d870f0
Successfully built f62c90d870f0
Successfully tagged madrockgod/ansible:2.10.0
docker login -u madrockgod
Password: 
Login Succeeded
docker push madrockgod/ansible:2.10.0
The push refers to repository [docker.io/madrockgod/ansible]
5d6b091683f1: Pushed 
32c458a2e5ea: Pushed 
b541d28bf3b4: Mounted from library/alpine 
2.10.0: digest: sha256:fde83979fc18fa7d8a8028c2fa4939af6494570d0e1e8f8db42e99ff167e90a7 size: 947
```
https://hub.docker.com/repository/docker/madrockgod/ansible - ссылка на результат
