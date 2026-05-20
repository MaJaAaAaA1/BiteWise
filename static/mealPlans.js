const createMealPlansBoxes = (mealPlanCalories, mealPlanProteins) => {
  const mealBox = document.getElementById("mealPlanList")
  const mealplanOptions = document.getElementById("mealPlanSelect")
  

  const mealItem = document.createElement("button")
  mealItem.classList.add("meal-plan-btn")
  mealItem.innerHTML = mealPlanCalories + " : " + mealPlanProteins
  mealItem.addEventListener("click", () => {
    updateScheduleBox()
  })

  const planOption = document.createElement("option")
  planOption.value = mealPlanCalories + " : " + mealPlanProteins
  planOption.innerHTML = mealPlanCalories + " : " + mealPlanProteins

  mealBox.appendChild(mealItem)
  mealplanOptions.appendChild(planOption)
}

const createMealPlansRecipeOptions = (recipeName) => {
  const recipeOptions = document.getElementById("recipeSelect")

  const recipeOption = document.createElement("option")
  recipeOption.value = recipeName
  recipeOption.innerHTML = recipeName

  recipeOptions.appendChild(recipeOption)
}


const updateScheduleBox = () => {}
