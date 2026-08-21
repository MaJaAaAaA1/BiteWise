const createScheduelBoxes = (day, name, calorieAmount, ProteinAmount) => {
  // Get parent div
  const mealDays = document.getElementById("mealDays")

  // Create elements
  const dayCard = document.createElement("div")
  const dayTitle = document.createElement("div")
  const recipeList = document.createElement("div")
  const recipeItem = document.createElement("div")
  const recipeName = document.createElement("div")
  const recipeNutrition = document.createElement("div")
  const recipeNutritionKcal = document.createElement("span")
  const recipeNutritionProtein = document.createElement("span")

  // Add class
  dayCard.classList.add("day-card")
  dayTitle.classList.add("day-title")
  recipeList.classList.add("recipe-list")
  recipeItem.classList.add("recipe-item")
  recipeName.classList.add("recipe-name")
  recipeNutrition.classList.add("recipe-nutrition")

  // Add data
  dayTitle.innerHTML = day
  recipeName.innerHTML = name
  recipeNutritionKcal.innerHTML = calorieAmount + " kcal"
  recipeNutritionProtein.innerHTML = ProteinAmount + "g protein"

  // Add children
  recipeNutrition.appendChild(recipeNutritionKcal)
  recipeNutrition.appendChild(recipeNutritionProtein)

  recipeItem.appendChild(recipeName)
  recipeItem.appendChild(recipeNutrition)

  recipeList.appendChild(recipeItem)

  dayCard.appendChild(dayTitle)
  dayCard.appendChild(recipeList)

  mealDays.append(dayCard)
}

const updateTotalCaloriesProteinValue = (
  totalCaloriesAmount,
  totalProteinAmount,
  totalMealPlanCaloriesAmount,
  totalMealPlanProteinAmount,
) => {
  const totalCalories = document.getElementById("totalCalories")
  const totalProtein = document.getElementById("totalProtein")

  totalCalories.innerHTML =
    totalCaloriesAmount + " / " + totalMealPlanCaloriesAmount + " kcal"
  totalProtein.innerHTML =
    totalProteinAmount + " / " + totalMealPlanProteinAmount + " g"
}
