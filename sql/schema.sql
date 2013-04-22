-- fivedeen DB Version 1.0
CREATE TABLE symbols (id SERIAL PRIMARY KEY, data JSON);
CREATE TABLE sequence (id SERIAL PRIMARY KEY, user INTEGER, data JSON);
