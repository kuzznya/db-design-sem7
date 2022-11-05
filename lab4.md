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

Скрипт анонимизации данных:

```sql
ALTER DATABASE postgres SET session_preload_libraries = 'anon';
ALTER DATABASE postgres SET anon.sourceschema = 'public';
CREATE EXTENSION IF NOT EXISTS anon with schema public CASCADE;

SELECT anon.start_dynamic_masking();

CREATE ROLE skynet LOGIN;
SECURITY LABEL FOR anon ON ROLE skynet IS 'MASKED';

SECURITY LABEL FOR anon ON COLUMN public.app_user.username
    IS 'MASKED WITH FUNCTION anon.random_string(5)';
SECURITY LABEL FOR anon ON COLUMN public.app_user.password
    IS 'MASKED WITH FUNCTION anon.random_string(5)';
SECURITY LABEL FOR anon ON COLUMN public.app_user.name
    IS 'MASKED WITH FUNCTION anon.fake_first_name()';
SECURITY LABEL FOR anon ON COLUMN public.app_user.surname
    IS 'MASKED WITH FUNCTION anon.fake_last_name()';
SECURITY LABEL FOR anon ON COLUMN public.app_user.phone_number
    IS 'MASKED WITH FUNCTION anon.random_phone()';

CREATE MATERIALIZED VIEW store_anon AS
SELECT gen_random_uuid() AS id,
       anon.pseudo_company(name) AS name,
       anon.pseudo_city(location) AS location
FROM store;

CREATE MATERIALIZED VIEW store_product_anon AS
SELECT gen_random_uuid() AS id,
       anon.random_in(array(SELECT id FROM product LIMIT 100)) AS product_id,
       anon.random_in(array(SELECT id FROM store LIMIT 100)) AS store_id,
       anon.random_int_between(0, 1000) as amount
FROM store_product;
```

Выполнение запросов:

```sql
SELECT * FROM app_user LIMIT 20;
```

${APP_USER_DATA}

```sql
SELECT * FROM store_anon LIMIT 20;
```

${STORE_ANON_DATA}

```sql
SELECT * FROM store_product_anon LIMIT 20;
```

${STORE_PRODUCT_ANON_DATA}
