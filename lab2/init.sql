CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE category (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL
);

CREATE TABLE product (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL UNIQUE,
    description text,
    price int NOT NULL,
    category_id uuid REFERENCES category(id) NOT NULL
);

CREATE TABLE category_parameter (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id uuid REFERENCES category(id) NOT NULL,
    name text NOT NULL
);

CREATE TABLE product_parameter (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id uuid REFERENCES product(id) NOT NULL,
    category_param_id uuid REFERENCES category_parameter(id) NOT NULL,
    value text NOT NULL
);

CREATE TABLE store (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    location text NOT NULL,
    name text NOT NULL
);

CREATE TABLE store_product (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id uuid REFERENCES product(id) NOT NULL,
    store_id uuid REFERENCES store(id) NOT NULL,
    amount int NOT NULL,
    UNIQUE (product_id, store_id)
);

CREATE TABLE app_user (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    username text NOT NULL UNIQUE,
    password text NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    phone_number text NOT NULL,
    verified boolean NOT NULL DEFAULT false
);

CREATE TABLE order_state (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL
);

CREATE TABLE user_order (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid REFERENCES app_user(id) NOT NULL,
    store_id uuid REFERENCES store(id) NOT NULL,
    state_id uuid REFERENCES order_state(id) NOT NULL
);

CREATE TABLE order_item (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id uuid REFERENCES user_order(id) NOT NULL,
    store_product_id uuid REFERENCES store_product(id) NOT NULL,
    amount int NOT NULL DEFAULT 1
);
