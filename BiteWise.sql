CREATE TABLE Users(
	user_ID INT UNIQUE AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    PRIMARY KEY(user_ID)
);

CREATE TABLE ingredients(
	ingredient_ID INT UNIQUE AUTO_INCREMENT,
    ingredient_type VARCHAR(255) NOT NULL,
    brand VARCHAR(255),
    kcal_per_100g INT NOT NULL,
    protein_per_100g INT NOT NULL,
    is_vegan BOOL,
    standard_unit ENUM('Liter', 'Deciliter', 'Gram', 'KG', 'Piece') NOT NULL,
    PRIMARY KEY (ingredient_ID)
);

CREATE TABLE fridge_inventories(
	inventory_ID INT UNIQUE AUTO_INCREMENT,
    user_ID INT,
    ingredient_ID INT,
    amount INT NOT NULL,
    best_before_date DATE NOT NULL,
    FOREIGN KEY (user_ID)
    REFERENCES users(user_ID),
    FOREIGN KEY (ingredient_ID)
    REFERENCES ingredients(ingredient_ID),
    PRIMARY KEY (inventory_ID)
);

CREATE TABLE recipes(
	recipe_ID INT UNIQUE AUTO_INCREMENT,
	title VARCHAR(255) NOT NULL,
    recipe_creator VARCHAR(255),
    came_from VARCHAR(255),
    instructions TEXT NOT NULL,
    prep_time TIME,
    PRIMARY KEY (recipe_ID)
);

CREATE TABLE recipe_ingredients(
	recipe_ID INT,
	ingredient_ID INT,
    required_amount INT,
    FOREIGN KEY (recipe_ID)
    REFERENCES recipes(recipe_ID),
    FOREIGN KEY (ingredient_ID)
    REFERENCES ingredients(ingredient_ID),
    PRIMARY KEY (recipe_ID, ingredient_ID)
);

CREATE TABLE meal_plans(
	meal_plan_ID INT UNIQUE AUTO_INCREMENT,
    user_ID INT,
    target_calories INT,
    target_protein INT,
    FOREIGN KEY (user_ID)
    REFERENCES users(user_ID),
    PRIMARY KEY (meal_plan_ID)
);

CREATE TABLE meal_plan_recipe(
	meal_plan_ID INT,
    recipe_ID INT,
    planned_date DATE NOT NULL,
    FOREIGN KEY(meal_plan_ID)
    REFERENCES meal_plans(meal_plan_ID),
    FOREIGN KEY(recipe_ID)
    REFERENCES recipes(recipe_ID),
    PRIMARY KEY(meal_plan_ID, recipe_ID)
);

SHOW TABLES;