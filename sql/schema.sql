-- fivedeen DB Version 1.0
CREATE TABLE symbols (id SERIAL PRIMARY KEY UNIQUE, data JSON);
-- 03.05.2013: updated table now includes columns: name, description  
CREATE TABLE symbols (id SERIAL PRIMARY KEY UNIQUE, name varchar(255), description text, data JSON);

CREATE TABLE sequence (id SERIAL PRIMARY KEY, userid INTEGER, data JSON);

-- reset auto increment (example)
alter sequence symbols_id_seq restart with 1;

-- alter table owner
alter table symbols owner to fivedeen;
