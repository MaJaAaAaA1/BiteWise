CREATE DATABASE BiteWise;
USE BiteWise;
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
    FOREIGN KEY (user_ID) REFERENCES users(user_ID),
    FOREIGN KEY (ingredient_ID) REFERENCES ingredients(ingredient_ID),
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
    FOREIGN KEY (recipe_ID) REFERENCES recipes(recipe_ID),
    FOREIGN KEY (ingredient_ID) REFERENCES ingredients(ingredient_ID),
    PRIMARY KEY (recipe_ID, ingredient_ID)
);
CREATE TABLE meal_plans(
    meal_plan_ID INT UNIQUE AUTO_INCREMENT,
    user_ID INT,
    target_calories INT,
    target_protein INT,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID),
    PRIMARY KEY (meal_plan_ID)
);

CREATE TABLE meal_plan_recipe(
    meal_plan_ID INT,
    recipe_ID INT,
    weekDay VARCHAR(255) NOT NULL,
    FOREIGN KEY(meal_plan_ID) REFERENCES meal_plans(meal_plan_ID),
    FOREIGN KEY(recipe_ID) REFERENCES recipes(recipe_ID),
    PRIMARY KEY(meal_plan_ID, recipe_ID, weekDay)

);
INSERT INTO Users (email, first_name, last_name)
VALUES ('anna.perkins@example.com', 'Anna', 'Perkins'),
    (
        'eric.johnson@example.com',
        'Eric',
        'Johnson'
    ),
    ('karen.nelson@example.com', 'Karen', 'Nelson'),
    (
        'lawrence.lawson@example.com',
        'Lawrence',
        'Lawson'
    ),
    ('michael.hill@example.com', 'Michael', 'Hill'),
    ('sarah.holmes@example.com', 'Sarah', 'Holmes'),
    ('oscar.lindt@example.com', 'Oscar', 'Lindt'),
    ('emma.oakes@example.com', 'Emma', 'Oakes'),
    (
        'philip.victors@example.com',
        'Philip',
        'Victors'
    ),
    (
        'linda.woods@example.com',
        'Linda',
        'Woods'
    );
INSERT INTO ingredients (
        ingredient_type,
        brand,
        kcal_per_100g,
        protein_per_100g,
        is_vegan,
        standard_unit
    )
VALUES ('Whole Milk', 'Arla', 45, 3, FALSE, 'Liter'),
    ('Oats', 'AXA', 370, 13, TRUE, 'Gram'),
    ('Eggs', 'Kronegg', 140, 12, FALSE, 'Piece'),
    ('Tofu', 'Yipin', 120, 12, TRUE, 'Gram'),
    ('Pasta Penne', 'Barilla', 350, 12, TRUE, 'Gram'),
    (
        'Chicken Fillet',
        'Goldbird',
        110,
        23,
        FALSE,
        'Gram'
    ),
    ('Crushed Tomatoes', 'Mutti', 20, 1, TRUE, 'Gram'),
    ('Olive Oil', 'Zeta', 880, 0, TRUE, 'Liter'),
    ('Onion', 'Fresco', 40, 1, TRUE, 'Piece'),
    ('Red Lentils', 'GoGreen', 350, 24, TRUE, 'Gram');
INSERT INTO fridge_inventories (user_ID, ingredient_ID, amount, best_before_date)
VALUES (1, 1, 1, '2026-05-10'),
    (1, 3, 6, '2026-05-15'),
    (2, 2, 1000, '2027-01-01'),
    (3, 4, 400, '2026-05-20'),
    (4, 6, 800, '2026-05-05'),
    (5, 5, 500, '2027-12-31'),
    (6, 7, 400, '2028-06-01'),
    (7, 8, 1, '2027-03-15'),
    (8, 9, 5, '2026-05-25'),
    (9, 10, 1000, '2027-08-12');
INSERT INTO recipes (
        title,
        recipe_creator,
        came_from,
        instructions,
        prep_time
    )
VALUES (
        'Classic Oatmeal',
        'Eric J',
        'Grandma''s recipe',
        'Boil oats with water and salt.',
        '00:05:00'
    ),
    (
        'Pasta Pomodoro',
        'Anna P',
        'Italian cookbook',
        'Boil pasta and mix with tomato sauce.',
        '00:20:00'
    ),
    (
        'Fried Tofu',
        'Sarah H',
        'The Vegan Blog',
        'Press tofu and fry until crispy.',
        '00:15:00'
    ),
    (
        'Fried Egg',
        'Lawrence L',
        'Home Economics',
        'Fry in a pan with butter.',
        '00:03:00'
    ),
    (
        'Lentil Stew',
        'Linda S',
        'Food.com',
        'Boil lentils with crushed tomatoes.',
        '00:30:00'
    ),
    (
        'Fried Chicken',
        'Oscar L',
        'The Training Guide',
        'Fry chicken with olive oil.',
        '00:25:00'
    ),
    (
        'Pasta with Chicken',
        'Emma O',
        'Everyday Meals',
        'Mix fried chicken with pasta.',
        '00:35:00'
    ),
    (
        'Omelette',
        'Michael H',
        'Breakfast.now',
        'Whisk eggs and fry on low heat.',
        '00:10:00'
    ),
    (
        'Onion Soup',
        'Philip V',
        'The French Kitchen',
        'Sauté onion and simmer with stock.',
        '00:45:00'
    ),
    (
        'Simple Tomato Sauce',
        'Karen N',
        'Family Recipe',
        'Simmer crushed tomatoes with onion.',
        '00:15:00'
    );
INSERT INTO recipe_ingredients (recipe_ID, ingredient_ID, required_amount)
VALUES (1, 2, 50),
    -- Havregröt behöver havregryn
    (2, 5, 100),
    -- Pasta Pomodoro behöver pasta
    (2, 7, 200),
    -- Pasta Pomodoro behöver tomater
    (3, 4, 200),
    -- Stekt tofu behöver tofu
    (4, 3, 2),
    -- Stekt ägg behöver ägg
    (5, 10, 100),
    -- Linsgryta behöver linser
    (5, 7, 400),
    -- Linsgryta behöver tomater
    (6, 6, 200),
    -- Kyckling behöver kyckling
    (7, 5, 100),
    -- Pasta/kyckling behöver pasta
    (7, 6, 150),
    -- Pasta/kyckling behöver kyckling
    (8, 3, 4),
    -- Omelette behöver ägg
    (9, 9, 5),
    -- Lök soppa behöver lök
    (10, 7, 4);
-- Tomat soppa behöver tomater
INSERT INTO meal_plans (user_ID, target_calories, target_protein)
VALUES (1, 2000, 120),
    (2, 2500, 150),
    (3, 1800, 80),
    (4, 3000, 180),
    (5, 2200, 100),
    (6, 1600, 70),
    (7, 2400, 140),
    (8, 2100, 110),
    (9, 2800, 160),
    (10, 1900, 90);
INSERT INTO meal_plan_recipe (meal_plan_ID, recipe_ID, weekDay)
VALUES (1, 1, 'Monday'),
    (1, 2, 'Tuesday'),
    (2, 6, 'Wednesday'),
    (3, 3, 'Thursday'),
    (4, 7, 'Friday'),
    (5, 5, 'Saturday'),
    (6, 10, 'Sunday'),
    (7, 8, 'Monday'),
    (8, 9, 'Tuesday'),
    (9, 6, 'Wednesday');





