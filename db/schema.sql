DROP TABLE IF EXISTS flashcards;
DROP TABLE IF EXISTS categories;


CREATE TABLE categories (
  id        SERIAL PRIMARY KEY,
  name      TEXT NOT NULL UNIQUE,
  score     INTEGER
);

CREATE TABLE flashcards (
  id            SERIAL PRIMARY KEY,
  front         TEXT NOT NULL UNIQUE,
  back          TEXT NOT NULL,
  status        TEXT,
  user_answer   TEXT,
  category_id   INTEGER REFERENCES categories(id)
);
