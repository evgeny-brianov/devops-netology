**1.** Управляющие команды:

список БД:  \l

подключения к БД: \c n-db

список таблиц: \dt

содержимое таблиц: \d имя_таблицы

выход: \q

**2.** находим столбец с наибольшим средним значением:
```
test_database=# SELECT attname, avg_width FROM pg_stats WHERE tablename='orders';
 attname | avg_width 
---------+-----------
 id      |         4
 title   |        16
 price   |         4
(3 rows)
```
**3.** разбиение таблицы, согласно указанным требованиям:
```
CREATE TABLE orders_more_500 (CHECK (price > 499)) INHERITS (orders);
INSERT INTO orders_more_500 SELECT * FROM orders WHERE price > 499;
CREATE TABLE orders_less_500 (CHECK (price <= 499)) INHERITS (orders);
INSERT INTO orders_less_500 SELECT * FROM orders WHERE price <= 499;
```
путем предварительного анализа заказов можно было предусмотреть нагрузку на БД:
```
CREATE RULE more_than_500 AS ON INSERT TO public.orders
WHERE (price > 499)
DO INSTEAD INSERT INTO orders_more_500 VALUES (NEW.*);
CREATE RULE less_than_500 AS ON INSERT TO orders
WHERE (price <= 499) 
DO INSTEAD INSERT INTO orders_less_500 VALUES (NEW.*);
```
**4.** запускаем утилиту pg_dump, указывая куда сохранить бекап БД:
```
[almanax@alma8 ~]$ pg_dump -h 127.0.0.1 -p 5432 -U postgres -d test_database > ~/6.4/dump1.sql
```
уникальность столбца title можно достичь путем добавления индекса:
```
CREATE INDEX ON orders ((lower(title)));
```
или добавлением ограничения UNIQUE:
```
ALTER TABLE orders ADD UNIQUE (title);
```
