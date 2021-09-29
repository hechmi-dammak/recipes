CREATE TABLE recipes (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    category TEXT,
    steps TEXT
);



CREATE TABLE ingredients (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    category TEXT,
    quantity REAL ,measuring TEXT,
    size TEXT,
    method TEXT,
    recipe_id INTEGER,
    FOREIGN KEY (recipe_id) REFERENCES recipes (_id)
)