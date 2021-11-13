CREATE TABLE pictures (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    image BLOB
);
CREATE TABLE recipes (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    category TEXT,
    servings INTEGER,
    picture_id INTEGER,
    FOREIGN KEY (picture_id) REFERENCES pictures (_id)
);

CREATE TABLE ingredients (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    category TEXT,
    quantity REAL,
    measuring TEXT,
    size TEXT,
    method TEXT,
    recipe_id INTEGER,
    FOREIGN KEY (recipe_id) REFERENCES recipes (_id)
);

CREATE TABLE steps (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    step_order INTEGER,
    to_do TEXT,
    recipe_id INTEGER,
    FOREIGN KEY (recipe_id) REFERENCES recipes (_id)
);