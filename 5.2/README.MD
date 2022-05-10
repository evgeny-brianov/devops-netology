1. Основными преимуществами использования IaaC паттернов является:
- быстрая конфигурация инфраструктуры
- стандартизация подходов
- масштабируемость развертываемой инфраструктуры
- одинаковые решения безопасности
- отлично документированная среда
- легкость бэкапа
- экономическая выгода при большем количестве серверов

2. Основным отличием является отсутствие необходимости ставить специализированный клиент на управляемую машину - Ansible работает по стандартному SSH.
Более надежным является метод Pull - каждый сервер забирает конфигурацию из мастер сервера.

3. VirtualBox
```
[almanax@alma8 ~]$ vboxmanage --version
6.1.34r150636
```
   Vagrant
```
[almanax@alma8 ~]$ vagrant --version
Vagrant 2.2.19
```
   Ansible
```
[almanax@alma8 ~]$ ansible --version
ansible 2.9.27
```

4. Создана ВМ с загрузкой из локального репозитария:
```
vagrant box add ubuntu/focal64 /home/almanax/Downloads/focal-server-cloudimg-amd64-vagrant.box
```
ВМ запущена и к ней выполнено подключение через SSH:
```
[almanax@alma8 myv1]$ vagrant up
[almanax@alma8 myv1]$ vagrant ssh
```
Вывод необходимой  команды:
```
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAME
```
