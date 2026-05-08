const fridge = document.getElementById("fridgeItems");
const radioDiv = document.getElementById("radioTypes");

const paramsString = window.location.search;
const searchParams = new URLSearchParams(paramsString);

// Set userid hidden value
const addToFrigdeForm = document.getElementById("frigdeForm");
const hiddenValue = document.createElement("input");
hiddenValue.name = "userid";
hiddenValue.type = "hidden";
hiddenValue.value = searchParams.get("userid");
addToFrigdeForm.appendChild(hiddenValue);

// Fetch recipes
const url = "/getFrigdeInventory?userid=" + searchParams.get("userid");

const getData = async () => {
  await fetch(url)
    .then((respone) => respone.json())
    .then((data) => {
      data.forEach((e) => {
        createFrigdeBoxes(fridge, e[0], e[1], e[2], e[3]);
      });
    });

  await fetch("/getAllIngredients")
    .then((response) => response.json())
    .then((data) => {
      data.forEach((e) => {
        createIngredientsRadio(radioDiv, e[0], e[1]);
      });
    });
};

const createFrigdeBoxes = (frigde, title, unit, amount, bbd) => {
  const frigdeItem = document.createElement("div");
  frigdeItem.classList.add("fridge-item");

  const frigdeTitle = document.createElement("p");
  frigdeTitle.classList.add("fridge-item-title");

  const frigdeAmount = document.createElement("p");
  frigdeAmount.classList.add("fridge-item-amount");
  frigdeAmount.classList.add("push");

  const frigdeBBD = document.createElement("p");
  frigdeBBD.classList.add("fridge-item-bbd");
  frigdeBBD.classList.add("hidden");

  frigdeTitle.innerHTML = title;
  frigdeAmount.innerHTML = amount + " " + unit;
  frigdeBBD.innerHTML = bbd;

  frigdeItem.addEventListener("click", () => {
    frigdeBBD.classList.toggle("hidden");
    frigdeItem.classList.toggle("expand");
  });

  frigdeItem.appendChild(frigdeTitle);
  frigdeItem.appendChild(frigdeAmount);
  frigdeItem.appendChild(frigdeBBD);

  frigde.appendChild(frigdeItem);
};

const createIngredientsRadio = (radioDiv, ingredientId, ingredientType) => {
  const radioInput = document.createElement("input");
  radioInput.type = "radio";
  radioInput.name = "ingredientId";
  radioInput.id = ingredientId;
  radioInput.value = ingredientId;

  const lableInput = document.createElement("label");
  lableInput.htmlFor = ingredientId;
  lableInput.innerHTML = ingredientType;

  radioDiv.appendChild(radioInput);
  radioDiv.appendChild(lableInput);
  radioDiv.appendChild(document.createElement("br"));
};

getData();
