**1.** В текущей ситуации получилось сделать ДЗ только через YC

Создаем папку проекта и инициализируем YandexCloud:
```
[almanax@alma8 7.2]$ mkdir cloud-terraform
[almanax@alma8 cloud-terraform]$ yc init
[almanax@alma8 cloud-terraform]$ yc config list
token: ********************************************
cloud-id: b1gecqsa22e178i9vkau
folder-id: b1g26nbtjlu2mabkioml
```
Создаем фаил main.tf описывающий первичную конфигурацию:
```
provider "yandex" {
  token     = ********************************************
  cloud_id  = "b1gecqsa22e178i9vkau"
  folder_id = "b1g26nbtjlu2mabkioml"
  zone      = "ru-central1-a"
}
```
Для того, чтобы не указывать токен авторизации необходимо экспортировать его:
```
[almanax@alma8 cloud-terraform]$ export TF_VAR_yc_token="******************************************"
```
 и модифицировать **main.tf**:
 ```
provider "yandex" {
  token     = var.yc_token
  cloud_id  = "b1gecqsa22e178i9vkau"
  folder_id = "b1g26nbtjlu2mabkioml"
  zone      = "ru-central1-a"
}
```

**2.** Создаем инстанс YC через терраформ

Для примера развернем ubuntu 1804. Посмотреть версии готовых образов можно при помощи команды:
```
[almanax@alma8 cloud-terraform]$ yc compute image list --folder-id standard-images
```
Воспользовавшись документацией, подготавливаем файлы [main.tf](https://github.com/evgeny-brianov/devops-netology/blob/main/7.2/main.tf), 
[versions.tf](https://github.com/evgeny-brianov/devops-netology/blob/main/7.2/versions.tf) и [output.tf](https://github.com/evgeny-brianov/devops-netology/blob/main/7.2/output.tf).

Иницализируем терраформ:
```
[almanax@alma8 cloud-terraform]$ terraform init
```
![11](https://user-images.githubusercontent.com/95703090/178199348-45e74e41-1def-47a1-a1c2-bfc6adbd5b6e.JPG)

и запускаем сборку:
```
[almanax@alma8 cloud-terraform]$ terraform apply -auto-approve
```
Результатом будет развернутый инстанс в YC:
![2](https://user-images.githubusercontent.com/95703090/178197126-6cc5a804-d886-46ca-9913-da064690ffc3.JPG)
