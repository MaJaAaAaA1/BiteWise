// Fetch data
// Create boxes
const grid = document.getElementById("recipeGrid");

// Fetch recipes
fetch("/getRecipes")
  .then((respone) => respone.json())
  .then((data) => {
    data.forEach((e) => {
      createRecipeBox(grid, e[0], e[1], e[2], e[3]);
    });
  });

// Create boxes
function createRecipeBox(grid, title, creator, preptime, recipeID) {
  const recipeBox = document.createElement("a");
  recipeBox.href = "/recipes/recipe?recipeid=" + recipeID;
  recipeBox.classList.add("recipe-box");

  const recipeImage = document.createElement("img");
  recipeImage.src =
    "https://static.vecteezy.com/ti/gratis-vektor/p1/24235960-mat-leverans-ikon-vektor-hamtmat-mat-illustration-tecken-snabb-mat-symbol-eller-logotyp-vector.jpg";
  recipeImage.classList.add("recipe-image");

  const recipeDivInfo = document.createElement("div");
  recipeDivInfo.classList.add("recipe-info");

  const recipeTitle = document.createElement("h3");
  recipeTitle.classList.add("recipe-title");

  const recipeCreator = document.createElement("p");
  recipeCreator.classList.add("recipe-creator");

  const recipePreptime = document.createElement("p");
  recipePreptime.classList.add("recipe-preptime");

  recipeTitle.innerHTML = title;
  recipeCreator.innerHTML = "Creator: " + creator;
  recipePreptime.innerHTML = "Time: " + preptime + " Min";

  recipeDivInfo.appendChild(recipeTitle);
  recipeDivInfo.appendChild(recipeCreator);
  recipeDivInfo.appendChild(recipePreptime);

  recipeBox.appendChild(recipeImage);
  recipeBox.appendChild(recipeDivInfo);

  grid.appendChild(recipeBox);
}

const updateRecipeList = () => {
  const selection = document.getElementById("filter");
  const selectedOption = selection.value;
  var url = "";

  if (selectedOption === "all") {
    url = "/getRecipes";
  } else if (selectedOption === "doable") {
    url = "/getRecipesDoable";
  } else if (selectedOption === "vegan") {
    url = "/getRecipesVegan";
  }

  fetch(url)
    .then((response) => response.json())
    .then((data) => {
      // Delete all existing children
      grid.replaceChildren();

      data.forEach((e) => {
        createRecipeBox(grid, e[0], e[1], e[2], e[3]);
      });
    });
};
