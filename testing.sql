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
SELECT i.ingredient_type,
    (ri.required_amount - COALESCE(fi.amount, 0)) AS amount_to_buy,
    i.standard_unit
FROM recipe_ingredients ri
    INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
    LEFT JOIN fridge_inventories fi ON ri.ingredient_ID = fi.ingredient_ID
    AND fi.user_ID = 1
WHERE ri.recipe_ID = 5
    AND (
        fi.amount IS NULL
        OR fi.amount < ri.required_amount
    );
-- recipes users can make that match what they have in their fridge inventory
SELECT r.recipe_ID,
    r.title,
    r.prep_time
FROM Recipes r
WHERE NOT EXISTS(
        SELECT *
        FROM recipe_ingredients ri
            LEFT JOIN fridge_inventories fi ON ri.ingredient_ID = fi.ingredient_ID
            AND fi.user_ID = 1
        WHERE ri.recipe_ID = r.recipe_ID
            AND (
                fi.amount IS NULL
                OR fi.amount < ri.required_amount
            )
    );
-- daily check for makro goal
SELECT mpr.planned_date,
    mp.target_calories,
    SUM(i.kcal_per_100g * ri.required_amount / 100) AS planned_calories,
    mp.target_protein,
    SUM(i.protein_per_100g * ri.required_amount / 100) AS planned_proteins
FROM meal_plan_recipe mpr
    INNER JOIN meal_plans mp ON mpr.meal_plan_ID = mp.meal_plan_ID
    INNER JOIN recipes r ON mpr.recipe_ID = r.recipe_ID
    INNER JOIN recipe_ingredients ri ON r.recipe_ID = ri.recipe_ID
    INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
WHERE mp.user_ID = 1
    AND MPR.planned_date = '2026-05-01'
GROUP BY mpr.planned_date,
    mp.target_calories,
    mp.target_protein;
-- filter vegan recipes
SELECT r.recipe_ID,
    r.title
FROM recipes r
WHERE NOT EXISTS(
        SELECT *
        FROM recipe_ingredients ri
            INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
        WHERE ri.recipe_ID = r.recipe_ID
            AND i.is_vegan = FALSE
    );
-- Trigger --
delimiter // CREATE TRIGGER check_best_before_date BEFORE
INSERT ON fridge_inventories FOR EACH ROW BEGIN IF NEW.best_before_date < CURDATE() THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = "Varans bäst före-datum har redan varit!";
END IF;
END;
CREATE PROCEDURE add_recipe_to_meal_plan (
    IN recipe_ID INT,
    IN i_meal_plan_ID INT,
    IN planned_date DATE
) BEGIN -- Check if meal_plan exists
IF NOT EXISTS (
    SELECT 1
    FROM meal_plan mp
    WHERE mp.meal_plan_ID = i_meal_plan_ID
) THEN RETURN "FALSE" -- Check if recipe exists
-- Add recipe to meal_plan
END;
CREATE PROCEDURE add_recipe_to_meal_plan (
    IN recipe_ID INT,
    IN meal_plan_ID INT AS inmp,
    IN planned_date DATE
) BEGIN -- Check if meal_plan exists
IF NOT EXISTS (
    SELECT 1
    FROM meal_plan mp
    WHERE mp.meal_plan_ID = inmp.meal_plan_ID
) THEN RETURN "FALSE" -- Check if recipe exists
-- Add recipe to meal_plan
END;
IF NOT EXISTS (
    SELECT 1
    FROM meal_plans mp
    WHERE mp.meal_plan_ID = 1
) THEN
SET MESSAGE_TEXT = 'Meal plan does not exist!';
END IF;
delimiter;
INSERT INTO fridge_inventories (user_ID, ingredient_ID, amount, best_before_date)
VALUES (1, 1, 1, '2026-05-01');
-- Function --
SELECT r.title,
    r.recipe_creator,
    r.prep_time,
    r.instructions,
    GROUP_CONCAT(ai.standard_unit) AS unit,
    GROUP_CONCAT(ai.required_amount) AS amount,
    GROUP_CONCAT(ai.ingredient_type) AS ingredients
FROM recipes r
    JOIN (
        SELECT i.ingredient_type,
            ri.recipe_ID,
            ri.required_amount,
            i.standard_unit
        FROM ingredients i
            INNER JOIN recipe_ingredients ri ON ri.ingredient_ID = i.ingredient_ID
        WHERE i.ingredient_ID = ri.ingredient_ID
    ) ai ON ai.recipe_ID = 5
WHERE r.recipe_ID = 5;
SELECT i.ingredient_type,
    i.standard_unit,
    fi.amount,
    fi.best_before_date
FROM fridge_inventories fi
    INNER JOIN ingredients i ON fi.ingredient_ID = i.ingredient_ID
WHERE fi.user_ID = 5;
SELECT i.ingredient_type,
    i.standard_unit,
    fi.amount,
    fi.best_before_date
FROM fridge_inventories fi
    INNER JOIN ingredients i ON fi.ingredient_ID = i.ingredient_ID
WHERE fi.user_ID = 7;
SELECT *
FROM users;