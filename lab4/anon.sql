ALTER DATABASE postgres SET session_preload_libraries = 'anon';
ALTER DATABASE postgres SET anon.sourceschema = 'public';
CREATE EXTENSION IF NOT EXISTS anon with schema public CASCADE;

SELECT anon.start_dynamic_masking();

CREATE ROLE skynet WITH PASSWORD 'password' LOGIN;
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
