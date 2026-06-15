-- В качестве СУБД была выбрана PostgreSQL

CREATE TABLE category (
	     category_id INTEGER PRIMARY KEY,
	     category_name CHARACTER VARYING (30) NOT NULL
);

CREATE TABLE product (
	     product_id CHARACTER VARYING (7) PRIMARY KEY,
	     product_name CHARACTER VARYING (100) NOT NULL,
	     price INTEGER NOT NULL CHECK (price >= 0),
             description TEXT,
             category_id INTEGER NOT NULL,
	     FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE client (
	     client_id INTEGER PRIMARY KEY,
	     client_name CHARACTER VARYING (60) NOT NULL,
	     city CHARACTER VARYING (30) NOT NULL,
	     birth_date DATE NOT NULL
);

CREATE TABLE purchase (
	     purchase_id INTEGER PRIMARY KEY,
	     purchase_date DATE NOT NULL,
	     client_id INTEGER NOT NULL,
             FOREIGN KEY (client_id) REFERENCES client(client_id)
);

CREATE TABLE purchase_details (
	     purchase_id INTEGER,
	     product_id CHARACTER VARYING (7),
	     amount INTEGER NOT NULL CHECK (amount > 0),
	     PRIMARY KEY (purchase_id, product_id),
	     FOREIGN KEY (purchase_id) REFERENCES purchase(purchase_id),
	     FOREIGN KEY (product_id) REFERENCES product(product_id)
); 