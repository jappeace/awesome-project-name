DROP TABLE ausers cascade;
DROP TABLE messages cascade;
CREATE TABLE ausers (
    id serial NOT NULL PRIMARY KEY,
    "name" varchar NOT NULL,
    email varchar NULL
);

CREATE TABLE messages (
    id serial NOT NULL PRIMARY KEY,
    from__id int REFERENCES ausers(id),
    content varchar NULL
);
