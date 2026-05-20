const createMealPlansBoxes = (mealPlanCalories, mealPlanProteins) => {
  const mealBox = document.getElementById("mealPlanList")

  const mealItem = document.createElement("button")
  mealItem.classList.add("meal-plan-btn")
  mealItem.innerHTML = mealPlanCalories + " : " + mealPlanProteins
  mealItem.addEventListener("click", () => {
    updateScheduleBox()
  })

  mealBox.appendChild(mealItem)
}

const updateScheduleBox = () => {}
