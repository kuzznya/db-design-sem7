INSERT INTO order_state (name)
VALUES ('COLLECTING'), ('BOOKED'), ('PAID'), ('DELIVERED');

INSERT INTO category (name)
VALUES ('Alcohol'),
       ('Fruits'),
       ('Vegetables'),
       ('Dairy'),
       ('Grocery');

INSERT INTO category_parameter (category_id, name)
VALUES ((SELECT id FROM category WHERE name = 'Alcohol'), 'ABV'),
       ((SELECT id FROM category WHERE name = 'Alcohol'), 'Country'),
       ((SELECT id FROM category WHERE name = 'Fruits'), 'Country'),
       ((SELECT id FROM category WHERE name = 'Vegetables'), 'Country'),
       ((SELECT id FROM category WHERE name = 'Dairy'), 'Fat %'),
       ((SELECT id FROM category WHERE name = 'Dairy'), 'Lactose');

INSERT INTO store (location, name)
VALUES ('St. Petersburg', 'Peter the Great delivery market'),
       ('Moscow', 'Mausoleum market'),
       ('Izmir', 'Waiting for Irish visa market');

INSERT INTO app_user (username, password, name, surname, phone_number, verified)
VALUES ('kuzznya', '***', 'Ilya', 'Kuznetsov', '+79117500058', true),
       ('afterbvrner', '***', 'Maxim', 'Golish', '***', true),
       ('xaghoul', '***', 'Gamzat', 'Gadgimagomedov', '***', true),
       ('whoami', '***', 'John', 'Doe', '***', false);
