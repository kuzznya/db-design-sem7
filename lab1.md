<h2 style="text-align: center;">МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ<br/>РОССИЙСКОЙ ФЕДЕРАЦИИ<br/>
ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ ОБРАЗОВАТЕЛЬНОЕ
УЧРЕЖДЕНИЕ ВЫСШЕГО ОБРАЗОВАНИЯ
</h2>

<p style="text-align: center;">«Национальный исследовательский университет ИТМО»</p>

<p style="text-align: center; margin-bottom: 200px">Факультет информационных технологий и программирования</p>

<h3 style="text-align: center;">Лабораторная работа №1</h3>

<p style="text-align: center; margin-bottom: 150px">по предмету “Проектирование баз данных”<br/>Вариант 1</p>

<p style="margin-left: 400px">Выполнил студент группы M34051<br/>
Кузнецов Илья</p>

<p style="margin-left: 400px; margin-bottom: 250px">Преподаватель Демина Л.С.</p>

<p style="text-align: center; margin-bottom: 50px">Санкт-Петербург<br/>2022</p>

Вариант 1. Заказ продуктов, товаров в магазине

### Краткое описание предметной области и портала, в том числе пояснение, охватывает ли моделирование все данные или только те, которые относятся к некоторым бизнес-процессам (указать к каким)

Система должна позволять пользователю выполнить заказ 
из выбранного (или ближайшего) магазина / склада.
Наличие продуктов в разных магазинах может отличаться.
Характеристики продуктов разных категорий различны 
(так, молочные продукты обладают характеристиками "% жирности" и "объем", а колбаса обладает характеристиками "масса" и "вид мяса"). 
Корзина пользователя рассматривается как заказ в начальном состоянии.

### Модель данных, построенная с учетом заданных требований

![ER diagram](img/lab1.svg)

```plantuml:lab1
@startuml
' hide the spot
hide circle

' avoid problems with angled crows feet
skinparam linetype ortho

entity product {
    id uuid <<generated>>
    --
    name text
    description text
    price int
    category_id uuid <<FK category(id)>>
}

entity category {
    id uuid <<generated>>
    --
    name text
}

entity category_parameter {
    id uuid <<generated>>
    --
    category_id uuid <<FK category(id)>>
    name text
}

entity product_parameter {
    id uuid <<generated>>
    --
    product_id uuid <<FK product(id)>>
    category_param_id uuid <<FK category_parameter(id)>>
    value text
}

entity store {
    id uuid <<generated>>
    --
    location text
    name text
}

entity store_product {
    id uuid <<generated>>
    --
    product_id uuid <<FK product(id)>>
    store_id uuid <<FK store(id)>>
    amount int
}

entity user {
    id uuid <<generated>>
    --
    username text
    password text
    name text
    surname text
    phone_number text
    verified boolean
    address text
}

entity order {
    id uuid <<generated>>
    --
    user_id uuid <<FK user(id)>>
    store_id uuid <<FK store(id)>>
    state_id uuid <<FK order_state(id)>>
}

entity order_item {
    id uuid <<generated>>
    --
    order_id uuid <<FK order(id)>>
    store_product_id <<FK store_product(id)>>
    amount int
}

entity order_state {
    id uuid <<generated>>
    --
    name text
}
note left of order_state::name
  COLLECTING | BOOKED | PAID | DELIVERED
end note

product }o--|| category
category ||--o{ category_parameter
category_parameter ||--o{ product_parameter
product_parameter }o--o{ product
store ||--o{ store_product
store_product }o-left-|| product
order }o--|| store
order }o-up-|| user
order_item }|-up-|| order
order_item }o--|| store_product
order }o--|| order_state
@enduml
```

### Обоснование нахождения модели данных в 3НФ

1НФ: Каждый кортеж отношения содержит только одно значение для каждого из атрибутов.

2НФ: Все атрибуты зависят от потенциального ключа (в модели данных отсутствуют атрибуты, которые не зависят от первичного ключа)

3НФ: Отсутствуют транзитивные функциональные зависимости от потенциального ключа

НФБК: Не существует функциональных зависимостей, в которых левая часть не является потенциальным ключом
