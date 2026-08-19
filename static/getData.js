const paramsString = window.location.search
const searchParams = new URLSearchParams(paramsString)

// Fetch recipes
const url = "/getFrigdeInventory?userid=" + searchParams.get("userid")

const getData = async () => {
  await fetch(url)
    .then((respone) => respone.json())
    .then((data) => {
      data.forEach((e) => {
        createFrigdeBoxes(fridge, e[0], e[1], e[2], e[3])
      })
    })

  await fetch("/getAllIngredients")
    .then((response) => response.json())
    .then((data) => {
      data.forEach((e) => {
        createIngredientsRadio(radioDiv, e[0], e[1])
      })
    })

  await fetch("/getMealPlans")
    .then((response) => response.json())
    .then((data) => {
      data.forEach((e) => {
        createMealPlansBoxes(e[0], e[1])
      })
    })

  await fetch("/getRecipes")
    .then((response) => response.json())
    .then((data) => {
      data.forEach((e) => {
        createRecipeList(e[0])
      })
    })
}

const fridge = document.getElementById("fridgeItems")
const radioDiv = document.getElementById("radioTypes")

// Set userid hidden value
const addToFrigdeForm = document.getElementById("frigdeForm")
const hiddenValue = document.createElement("input")
hiddenValue.name = "userid"
hiddenValue.type = "hidden"
hiddenValue.value = searchParams.get("userid")
addToFrigdeForm.appendChild(hiddenValue)

const createFrigdeBoxes = (frigde, title, unit, amount, bbd) => {
  const frigdeItem = document.createElement("div")
  frigdeItem.classList.add("fridge-item")

  const frigdeTitle = document.createElement("p")
  frigdeTitle.classList.add("fridge-item-title")

  const frigdeAmount = document.createElement("p")
  frigdeAmount.classList.add("fridge-item-amount")
  frigdeAmount.classList.add("push")

  const frigdeBBD = document.createElement("p")
  frigdeBBD.classList.add("fridge-item-bbd")
  frigdeBBD.classList.add("hidden")

  frigdeTitle.innerHTML = title
  frigdeAmount.innerHTML = amount + " " + unit
  frigdeBBD.innerHTML = bbd

  frigdeItem.addEventListener("click", () => {
    frigdeBBD.classList.toggle("hidden")
    frigdeItem.classList.toggle("expand")
  })

  frigdeItem.appendChild(frigdeTitle)
  frigdeItem.appendChild(frigdeAmount)
  frigdeItem.appendChild(frigdeBBD)

  frigde.appendChild(frigdeItem)
}

const createIngredientsRadio = (radioDiv, ingredientId, ingredientType) => {
  const radioInput = document.createElement("input")
  radioInput.type = "radio"
  radioInput.name = "ingredientId"
  radioInput.id = ingredientId
  radioInput.value = ingredientId

  const lableInput = document.createElement("label")
  lableInput.htmlFor = ingredientId
  lableInput.innerHTML = ingredientType

  radioDiv.appendChild(radioInput)
  radioDiv.appendChild(lableInput)
  radioDiv.appendChild(document.createElement("br"))
}

const createMealPlansBoxes = (mealPlanCalories, mealPlanProteins) => {
  const mealBox = document.getElementById("mealPlanList")
  const mealPlanOption = document.getElementById("mealPlanSelect")

  const mealItem = document.createElement("button")
  mealItem.classList.add("meal-plan-btn")
  mealItem.innerHTML = mealPlanCalories + " : " + mealPlanProteins
  mealItem.addEventListener("click", () => {
    updateScheduleBox()
  })

  const mealOption = document.createElement("option")
  mealOption.value = mealPlanCalories + " : " + mealPlanProteins
  mealOption.innerHTML = mealPlanCalories + " : " + mealPlanProteins

  mealBox.appendChild(mealItem)
  mealPlanOption.appendChild(mealOption)
}

const createRecipeList = (recipeName) => {
  const recipeOption = document.getElementById("recipeSelect")

  const option = document.createElement("option")
  option.value = recipeName
  option.innerHTML = recipeName

  recipeOption.appendChild(option)
}

const updateScheduleBox = () => {}

document.getElementById("addMeal").addEventListener("click", () => {
  var mealPlan = document.getElementById("mealPlanSelect")
  mealPlan = mealPlan.options[mealPlan.selectedIndex].text
  var recipe = document.getElementById("recipeSelect")
  recipe = recipe.options[recipe.selectedIndex].text
  var date = document.getElementById("mealDate").value

  fetch("/addMeal", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ mealPlan: mealPlan, recipe: recipe, date: date }),
  })
})

getData()
