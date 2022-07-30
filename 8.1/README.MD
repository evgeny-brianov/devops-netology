**Подготовка к выполнению**
```
[almanax@alma8 8.1]$ sudo dnf update
[almanax@alma8 8.1]$ sudo dnf install epel-release -y
[almanax@alma8 8.1]$ sudo dnf install -y ansible
[almanax@alma8 8.1]$ ansible --version
```

**Основная Часть**

**1.** Запускаем playbook и фиксируем значение:
![1](https://user-images.githubusercontent.com/95703090/181871216-eabc89f7-1e03-4678-8c23-e48651bdeaae.JPG)

**2.** Редактируем фаил group_vars/all/examp.yml
```
cat group_vars/all/examp.yml
---
  some_fact: all default fact
```
**3.** Подготавливаем docker-compose.yml
```
version: '3.9'
services:
  centos7:
    image: pycontribs/centos:7
    container_name: centos7
    restart: unless-stopped
    entrypoint: "sleep infinity"

  ubuntu:
    image: pycontribs/ubuntu
    container_name: ubuntu
    restart: unless-stopped
    entrypoint: "sleep infinity"
```
**4.** Запускаем плейбук из окружения prod и фиксируем значение:
![4](https://user-images.githubusercontent.com/95703090/181871406-3a512d06-f21c-4aa4-9719-41fdf2e9bca2.JPG)

**5.** Меняем значение в файлах групп хостов на ‘deb default fact' и  'el default fact'
![5](https://user-images.githubusercontent.com/95703090/181871453-71148c3a-4d8a-4515-93df-68cd3ae4fa27.JPG)

**6.** Повторяем запуск окружения prod и видим изменения:
![6-1](https://user-images.githubusercontent.com/95703090/181871480-f4bcdda1-1555-4769-b152-211e5c0dd03f.JPG)

**7.** Шифруем факты с паролем netology:
![7](https://user-images.githubusercontent.com/95703090/181871506-5d562f21-e5a5-4255-a206-e2f2633ec4db.JPG)

**8.** Запуск окружения prod с паролем (используем  --ask-vault-pass ):
![8](https://user-images.githubusercontent.com/95703090/181871520-7bc0ed93-6f3c-4aae-a416-c68a9dd3723d.JPG)

**9.** Ищем необходимый плагин:
```
ansible-doc -t connection -l
```
И опираясь на [документацию](https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html#control-node)
делаем вывод, что это плагин **local**

**10.** Добавляем новую группу хостов в prod.yml:
```
---
  el:
    hosts:
      centos7:
	ansible_connection: docker
  deb:
    hosts:
      ubuntu:
	ansible_connection: docker
  local:
    hosts:
      localhost:
	ansible_connection: local
```

**11.** Запуск с тремя группами хостов:
![9](https://user-images.githubusercontent.com/95703090/181871654-ca9dd70a-3ede-41d8-84d0-cbd45ddce5b1.JPG)

**12.** [Ссылка на измененный playbook:](https://github.com/evgeny-brianov/devops-netology/tree/main/8.1/08-ansible-01-base/playbook)


