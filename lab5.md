<h2 style="text-align: center;">МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ<br/>РОССИЙСКОЙ ФЕДЕРАЦИИ<br/>
ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ ОБРАЗОВАТЕЛЬНОЕ
УЧРЕЖДЕНИЕ ВЫСШЕГО ОБРАЗОВАНИЯ
</h2>

<p style="text-align: center;">«Национальный исследовательский университет ИТМО»</p>

<p style="text-align: center; margin-bottom: 200px">Факультет информационных технологий и программирования</p>

<h3 style="text-align: center;">Лабораторная работа №4</h3>

<p style="text-align: center; margin-bottom: 150px">по предмету “Проектирование баз данных”<br/>Вариант 1</p>

<p style="margin-left: 400px">Выполнил студент группы M34051<br/>
Кузнецов Илья</p>

<p style="margin-left: 400px; margin-bottom: 250px">Преподаватель Демина Л.С.</p>

<p style="text-align: center; margin-bottom: 50px">Санкт-Петербург<br/>2022</p>

Вариант 1. Заказ продуктов, товаров в магазине

1. Создание партиций

```sql
CREATE TABLE user_order_2015 (
    CONSTRAINT partition_check CHECK ( EXTRACT(YEAR FROM created) = 2015 )
) INHERITS (user_order);

CREATE TABLE user_order_2016 (
    CONSTRAINT partition_check CHECK ( EXTRACT(YEAR FROM created) = 2016 )
) INHERITS (user_order);

CREATE TABLE user_order_2017 (
    CONSTRAINT partition_check CHECK ( EXTRACT(YEAR FROM created) = 2017 )
) INHERITS (user_order);
```

2. Создание функции партиционирования

```sql
CREATE OR REPLACE FUNCTION insert_into_order_partition() RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    partition text;
    year int;
BEGIN
    year := EXTRACT(YEAR FROM new.created);
    partition := format('user_order_%s', year);
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || partition || ' (
    CONSTRAINT partition_check CHECK ( EXTRACT(YEAR FROM created) = ' || year::text || ')
    ) INHERITS (user_order)';
    EXECUTE 'INSERT INTO ' || partition || ' VALUES ( ($1).* )' USING new;
    RETURN NULL;
END;
$$;
```

3. Создание триггера для мастер-таблицы

```sql
CREATE OR REPLACE TRIGGER order_partition
BEFORE INSERT ON user_order
FOR EACH ROW EXECUTE PROCEDURE insert_into_order_partition();
```

4. Перенос данных

```sql
INSERT INTO user_order SELECT * FROM ONLY user_order;

TRUNCATE ONLY user_order CASCADE;
```

Результаты:

```sql
SELECT count(*) FROM ONLY user_order;
```

${USER_ORDER_COUNT}

```sql
SELECT * FROM user_order_2015 LIMIT 10;
```

${USER_ORDER_2015}

```sql
SELECT * FROM user_order_2020 LIMIT 10;
```

${USER_ORDER_2020}

```sql
SELECT * FROM user_order_2022 LIMIT 10;
```

${USER_ORDER_2022}

Партиции user_order_2018 - user_order_2022 были созданы автоматически.
