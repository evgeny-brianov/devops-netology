# 1. манифест docker-compose.yml
```
version: '3.9'
services:
     db:
         container_name: n-postgre
         image: postgres:12
         environment:
             POSTGRES_DB: "n-db"
             POSTGRES_USER: "n-user"
             POSTGRES_PASSWORD: "n-pass"
             PGDATA: /opt/pgsql/data/test
             
         ports:
             - 5432:5432
         volumes:
             - .:/opt/pgsql/data
             - /6.2/backup:/var/lib/docker/volumes
         privileged: true
```
# 2. список БД:
 
![1](https://user-images.githubusercontent.com/95703090/172207140-227721ab-e724-45ad-ae85-9de8c8f2b921.JPG)

описание таблиц:

![3](https://user-images.githubusercontent.com/95703090/172207270-d504b125-3a69-4cd5-9bf8-7d467832ea63.JPG)
запрос выдачи списка пользователей с правами:
```
test_db=# select * from information_schema.table_privileges where grantee in ('test-admin-user', 'test-simple-user') and table_schema = 'public';
```
![4](https://user-images.githubusercontent.com/95703090/172207413-c33f1869-523a-46d9-86f8-ce92bb54b028.JPG)
# 3. заполняем таблицы значениями:
```
INSERT INTO clients (surname , country)
VALUES ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
INSERT 0 5
INSERT INTO orders (name, price)
VALUES ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);
INSERT 0 5
```
вычисляем кол-во записей:

![21](https://user-images.githubusercontent.com/95703090/172208320-d8a6226a-069d-4c31-8dca-d5592b509055.JPG)

# 4. связи при помощи foreign keys:
```
UPDATE clients SET order_id = 3 WHERE id = 7;
UPDATE clients SET order_id = 4 WHERE id = 8;
UPDATE clients SET order_id = 5 WHERE id = 9;
SELECT * FROM  clients WHERE order_id is NOT NULL;
```
![41](https://user-images.githubusercontent.com/95703090/172208555-a30e5f35-fbc2-4ff3-9121-9dfd0a5de157.JPG)

# 5.  Директива EXPLAIN показывает какой план запроса  был выбран для данного запроса в БД.
Числа в скобках означают стоимость запуска и запроса, измеряемую в машинном времени, а также ожидаемое число строк и их средний размер, измеряемый в байтах.

 Seq Scan on clients  (cost=0.00..11.80 rows=179 width=404)
   Filter: (order_id IS NOT NULL)
(2 rows)

# 6. Резервное копирование и восстановление БД:

создаем копию БД с указанием места хранения и останавливаем контейнер:

pg_dump test_db -h 127.0.0.1 -U test-admin-user > ~/6.2/backup/test.dump

собираем новый контейнер  с образом postgres и восстановим там бд из .dump файла:

psql -h 127.0.0.1 -U test-admin-user -d test_db < ~/6.2/backup/test.dump

