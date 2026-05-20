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

  await fetch("/getRecipeNames")
    .then((response) => response.json())
    .then((data) => {
      data.forEach((e) => {
        console.log(e)
        //createMealPlansRecipeOptions(e[0])
      })
    })
    
}

document.addEventListener("DOMContentLoaded", function(){
  getData()
});