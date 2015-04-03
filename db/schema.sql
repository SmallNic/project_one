DROP TABLE IF EXISTS flashcards;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id            SERIAL PRIMARY KEY,
  username      TEXT NOT NULL UNIQUE,
  password      TEXT NOT NULL,
  email         TEXT,
  last_login    TIMESTAMP
);

CREATE TABLE categories (
  id            SERIAL PRIMARY KEY,
  name          TEXT NOT NULL UNIQUE,
  score         INTEGER,
  active_test   BOOLEAN,
  user_id       INTEGER REFERENCES users(id)
);

CREATE TABLE flashcards (
  id            SERIAL PRIMARY KEY,
  front         TEXT NOT NULL UNIQUE,
  back          TEXT NOT NULL,
  status        TEXT NOT NULL,
  user_answer   TEXT,
  category_id   INTEGER REFERENCES categories(id)
);
