INSERT INTO user_order (user_id, store_id, state_id, created)
SELECT
    (SELECT id FROM app_user ORDER BY random() LIMIT 1) AS user_id,
    (SELECT id FROM store WHERE name = 'Peter the Great delivery market') AS store_id,
    (SELECT id FROM order_state WHERE name = 'DELIVERED') AS state_id,
    timestamp '2015-01-01 00:00:00' +
    random() * (timestamp '2022-11-18 23:00:00' - timestamp '2015-01-01 00:00:00') AS created
FROM generate_series(0, 10000);

SELECT * FROM user_order LIMIT 100;
