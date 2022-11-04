CREATE INDEX IF NOT EXISTS product_category_name_idx ON product (category_id, name COLLATE "C");

CREATE INDEX IF NOT EXISTS app_user_name_surname_idx ON app_user (name COLLATE "C", surname COLLATE "C");
