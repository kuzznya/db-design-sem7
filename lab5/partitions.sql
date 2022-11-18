CREATE TABLE user_order_2015 (
    CONSTRAINT partition_check CHECK ( EXTRACT(YEAR FROM created) = 2015 )
) INHERITS (user_order);

CREATE TABLE user_order_2016 (
    CONSTRAINT partition_check CHECK ( EXTRACT(YEAR FROM created) = 2016 )
) INHERITS (user_order);

CREATE TABLE user_order_2017 (
    CONSTRAINT partition_check CHECK ( EXTRACT(YEAR FROM created) = 2017 )
) INHERITS (user_order);

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

CREATE OR REPLACE TRIGGER order_partition
BEFORE INSERT ON user_order
FOR EACH ROW EXECUTE PROCEDURE insert_into_order_partition();

INSERT INTO user_order SELECT * FROM ONLY user_order;

TRUNCATE ONLY user_order CASCADE;
