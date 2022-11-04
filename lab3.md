<h2 style="text-align: center;">МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ<br/>РОССИЙСКОЙ ФЕДЕРАЦИИ<br/>
ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ ОБРАЗОВАТЕЛЬНОЕ
УЧРЕЖДЕНИЕ ВЫСШЕГО ОБРАЗОВАНИЯ
</h2>

<p style="text-align: center;">«Национальный исследовательский университет ИТМО»</p>

<p style="text-align: center; margin-bottom: 200px">Факультет информационных технологий и программирования</p>

<h3 style="text-align: center;">Лабораторная работа №3</h3>

<p style="text-align: center; margin-bottom: 150px">по предмету “Проектирование баз данных”<br/>Вариант 1</p>

<p style="margin-left: 400px">Выполнил студент группы M34051<br/>
Кузнецов Илья</p>

<p style="margin-left: 400px; margin-bottom: 250px">Преподаватель Демина Л.С.</p>

<p style="text-align: center; margin-bottom: 50px">Санкт-Петербург<br/>2022</p>

Вариант 1. Заказ продуктов, товаров в магазине

### Создание представления

Создание представления store_product_param на основе данных таблиц store_product, product_parameter и category_parameter:

```sql
CREATE OR REPLACE VIEW store_product_param AS
SELECT sp.id, sp.product_id, sp.store_id, sp.amount, cp.name AS parameter_name, pp.value AS parameter_value
FROM store_product sp
LEFT JOIN product_parameter pp ON pp.product_id = sp.product_id
LEFT JOIN category_parameter cp ON cp.id = pp.category_param_id;
```

```sql
SELECT * FROM store_product_param;
```

${STORE_PRODUCT_PARAM}

Данное представление позволяет получать параметры продукта конкретного магазина на основе параметров товара в каталоге,
что позволяет упростить отображение информации о товаре.

### Создание индексов

Создание индекса для таблицы product, позволяющего искать товары в определенной категории (по префиксу названия):

```sql
CREATE INDEX IF NOT EXISTS product_category_name_idx ON product (category_id, name COLLATE "C");
```

Выполнение запроса:

```sql
EXPLAIN ANALYZE
SELECT * FROM product 
WHERE category_id = (SELECT id FROM category c WHERE c.name = 'Alcohol') 
  AND name LIKE 'Pin%'
```

${PRODUCT_SEARCH}

Создание индекса для таблицы app_user, позволяющего искать пользователя по префиксу имени или фамилии:

```sql
CREATE INDEX IF NOT EXISTS app_user_name_surname_idx ON app_user (name COLLATE "C", surname COLLATE "C");
```

Выполнение запроса:

```sql
EXPLAIN ANALYZE
SELECT * FROM app_user 
WHERE name LIKE 'Ily%' OR surname LIKE 'Ily%'
```

${USER_SEARCH}
