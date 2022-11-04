CREATE OR REPLACE VIEW store_product_param AS
SELECT sp.id, sp.product_id, sp.store_id, sp.amount, cp.name AS parameter_name, pp.value AS parameter_value
FROM store_product sp
LEFT JOIN product_parameter pp ON pp.product_id = sp.product_id
LEFT JOIN category_parameter cp ON cp.id = pp.category_param_id;
