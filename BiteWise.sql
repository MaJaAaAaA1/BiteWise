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
    planned_date DATE NOT NULL,
    FOREIGN KEY(meal_plan_ID) REFERENCES meal_plans(meal_plan_ID),
    FOREIGN KEY(recipe_ID) REFERENCES recipes(recipe_ID),
    PRIMARY KEY(meal_plan_ID, recipe_ID)
);
INSERT INTO Users (email, first_name, last_name)
VALUES ('anna.persson@example.com', 'Anna', 'Persson'),
    (
        'erik.johansson@example.com',
        'Erik',
        'Johansson'
    ),
    ('karin.nilsson@example.com', 'Karin', 'Nilsson'),
    ('lars.larsson@example.com', 'Lars', 'Larsson'),
    ('mikael.berg@example.com', 'Mikael', 'Berg'),
    ('sara.holm@example.com', 'Sara', 'Holm'),
    ('oscar.lind@example.com', 'Oscar', 'Lind'),
    ('emma.ek@example.com', 'Emma', 'Ek'),
    (
        'filip.viktorsson@example.com',
        'Filip',
        'Viktorsson'
    ),
    (
        'linnea.sjoberg@example.com',
        'Linnea',
        'Sjöberg'
    );

INSERT INTO ingredients (
        ingredient_type,
        brand,
        kcal_per_100g,
        protein_per_100g,
        is_vegan,
        standard_unit
    )

VALUES ('Mellanmjölk', 'Arla', 45, 3, FALSE, 'Liter'),
    ('Havregryn', 'AXA', 370, 13, TRUE, 'Gram'),
    ('Ägg', 'Kronägg', 140, 12, FALSE, 'Piece'),
    ('Tofu', 'Yipin', 120, 12, TRUE, 'Gram'),
    ('Pasta Penne', 'Barilla', 350, 12, TRUE, 'Gram'),
    (
        'Kycklingfilé',
        'Guldfågeln',
        110,
        23,
        FALSE,
        'Gram'
    ),
    ('Krossade tomater', 'Mutti', 20, 1, TRUE, 'Gram'),
    ('Olivolja', 'Zeta', 880, 0, TRUE, 'Liter'),
    ('Lök', 'ICA', 40, 1, TRUE, 'Piece'),
    ('Röda linser', 'GoGreen', 350, 24, TRUE, 'Gram');

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
        'Klassisk Havregröt',
        'Erik J',
        'Mormors recept',
        'Koka gryn med vatten och salt.',
        '00:05:00'
    ),
    (
        'Pasta Pomodoro',
        'Anna P',
        'Italiensk kokbok',
        'Koka pasta och blanda med tomatsås.',
        '00:20:00'
    ),
    (
        'Stekt Tofu',
        'Sara H',
        'Veganbloggen',
        'Pressa tofu och stek krispig.',
        '00:15:00'
    ),
    (
        'Stekt Ägg',
        'Lars L',
        'Hemkunskapen',
        'Stek i panna med smör.',
        '00:03:00'
    ),
    (
        'Linsgryta',
        'Linnea S',
        'Mat.se',
        'Koka linser med krossade tomater.',
        '00:30:00'
    ),
    (
        'Stekt Kyckling',
        'Oscar L',
        'Träningsguiden',
        'Stek kyckling med olivolja.',
        '00:25:00'
    ),
    (
        'Pasta med kyckling',
        'Emma E',
        'Vardagsmat',
        'Blanda stekt kyckling med pasta.',
        '00:35:00'
    ),
    (
        'Omelett',
        'Mikael B',
        'Frukost.nu',
        'Vispa ägg och stek på låg värme.',
        '00:10:00'
    ),
    (
        'Löksoppa',
        'Filip V',
        'Franska köket',
        'Fräs lök och koka upp med buljong.',
        '00:45:00'
    ),
    (
        'Enkel Tomatsås',
        'Karin N',
        'Familjerecept',
        'Sjud krossade tomater med lök.',
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
    (7, 6, 150);
-- Pasta/kyckling behöver kyckling
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
INSERT INTO meal_plan_recipe (meal_plan_ID, recipe_ID, planned_date)
VALUES (1, 1, '2026-05-01'),
    (1, 2, '2026-05-01'),
    (2, 6, '2026-05-02'),
    (3, 3, '2026-05-02'),
    (4, 7, '2026-05-03'),
    (5, 5, '2026-05-03'),
    (6, 10, '2026-05-04'),
    (7, 8, '2026-05-04'),
    (8, 9, '2026-05-05'),
    (9, 6, '2026-05-05');

-- Recipes user can't make.
SELECT DISTINCT *
FROM recipe_ingredients ri
    LEFT JOIN fridge_inventories fi ON ri.ingredient_ID = fi.ingredient_ID
WHERE fi.ingredient_ID IS NULL
    AND fi.user_ID = 1;

-- Calculate nutrients
SELECT ri.recipe_ID,
    SUM(i.kcal_per_100g / 100 * ri.required_amount),
    SUM(i.protein_per_100g / 100 * ri.required_amount)
FROM recipe_ingredients ri
    INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
GROUP BY ri.recipe_ID;

-- Get recipes for products that will go bad soon.
SELECT DISTINCT ri.recipe_ID,
    r.title
FROM fridge_inventories fi
    INNER JOIN recipe_ingredients ri ON ri.ingredient_ID = fi.ingredient_ID
    INNER JOIN recipes r ON r.recipe_ID = ri.recipe_ID
WHERE fi.best_before_date BETWEEN CURRENT_DATE() AND CURRENT_DATE() + 2
    AND fi.user_ID = 4;

-- Compare fridgeinventory with recipe to make shoppinglist --
SELECT i.ingredient_type, (ri.required_amount - COALESCE(fi.amount, 0)) AS amount_to_buy, i.standard_unit 
FROM recipe_ingredients ri
INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
LEFT JOIN fridge_inventories fi 
ON ri.ingredient_ID = fi.ingredient_ID 
AND fi.user_ID = 1
WHERE ri.recipe_ID = 5
AND (fi.amount IS NULL OR fi.amount < ri.required_amount);

-- recipes users can make that match what they have in their fridge inventory
SELECT r.recipe_ID, r.title, r.prep_time FROM Recipes r
WHERE NOT EXISTS(SELECT * FROM recipe_ingredients ri LEFT JOIN fridge_inventories fi
ON ri.ingredient_ID = fi.ingredient_ID AND fi.user_ID = 1
WHERE ri.recipe_ID = r.recipe_ID
AND (fi.amount IS NULL OR fi.amount < ri.required_amount));

-- daily check for makro goal
SELECT mpr.planned_date, mp.target_calories,
SUM(i.kcal_per_100g * ri.required_amount / 100) AS planned_calories, mp.target_protein,
SUM(i.protein_per_100g * ri.required_amount / 100) AS planned_proteins
FROM meal_plan_recipe mpr
INNER JOIN meal_plans mp ON mpr.meal_plan_ID = mp.meal_plan_ID
INNER JOIN recipes r ON mpr.recipe_ID = r.recipe_ID
INNER JOIN recipe_ingredients ri ON r.recipe_ID = ri.recipe_ID
INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
WHERE mp.user_ID = 1 AND MPR.planned_date = '2026-05-01'
GROUP BY mpr.planned_date, mp.target_calories, mp.target_protein;

-- filter vegan recipes
SELECT r.recipe_ID, r.title
FROM recipes r
WHERE NOT EXISTS(SELECT* FROM recipe_ingredients ri
INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
WHERE ri.recipe_ID = r.recipe_ID AND i.is_vegan = FALSE);

-- Trigger --
delimiter //
CREATE TRIGGER check_best_before_date BEFORE
INSERT ON fridge_inventories FOR EACH ROW BEGIN IF NEW.best_before_date < CURDATE() THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = "Varans bäst före-datum har redan varit!";
END IF;
END;
delimiter;
INSERT INTO fridge_inventories (user_ID, ingredient_ID, amount, best_before_date)
VALUES (1, 1, 1, '2026-05-01');

-- Function --
