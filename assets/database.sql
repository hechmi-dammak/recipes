CREATE TABLE recipes (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    category TEXT
);

CREATE TABLE ingredients (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    category TEXT,
    quantity REAL measuring TEXT,
    size TEXT,
    method TEXT,
    steps TEXT,
    recipeId INTEGER,
    FOREIGN KEY (recipe_id) REFERENCES recipes (_id)
)