
// these lists defined once and used in several places: new question form and in filters
function initLists() {
	const questionTopics = ['Flow Control', 'Math Operations', 'Arrays', 'Strings', 'Recursion', 'Bit Manipulation'];
	const questionDifficulties = ['Easy', 'Medium', 'Hard'];

	const populateSelect = function(select, options) {
		for(var i = 0; i < options.length; i++) {
			var opt = options[i];
			var el = document.createElement("option");
			el.textContent = opt;
			el.value = opt;
			select.appendChild(el);
		}
	}
	// populate select elements in new question form	
	populateSelect(document.querySelector("#category"), questionTopics);
	populateSelect(document.querySelector("#difficulty"), questionDifficulties);

	// populate select elements in filters 
	populateSelect(document.querySelector("#questions [name='category']"), questionTopics);
	populateSelect(document.querySelector("#questions [name='difficulty']"), questionDifficulties);

	populateSelect(document.querySelector("#allQuestions [name='category']"), questionTopics);
	populateSelect(document.querySelector("#allQuestions [name='difficulty']"), questionDifficulties);
}

// will execute func when there were no more calls to it after a given delay
const debounce = (func, delay) => {
	let inDebounce
	return function() {
		const context = this
		const args = arguments
		clearTimeout(inDebounce)
		inDebounce = setTimeout(() => func.apply(context, args), delay)
	}
}

// assigns event handlers to filters
function initFilters() {	
	function initFilter(containerId, filterFunc) {
		// delay filtering so that it happens when user stops typing and not after each key press
		const delayedFilter = debounce(filterFunc, 300);
		
		// add change handler for all 3 inputs
		let inputs = document.querySelectorAll(`#${containerId} .filter-input`);
		for (input of inputs) {
			input.addEventListener('change', filterFunc);
		}
		// add keyboard event for text input
		document.querySelector(`#${containerId} [name='description']`)
			.addEventListener('keydown', delayedFilter);

		// add handler for clear filter button
		document.querySelector(`#${containerId} [name='clear-filter']`)
			.addEventListener('click', (e) => {
				let inputs = document.querySelectorAll(`#${containerId} .filter-input`);
				for (input of inputs) {
					input.value="";
				}
				filterFunc();
			});
	}

	initFilter('questions', renderFilteredQuestions);
	initFilter('allQuestions', renderFilteredExamQuestions);
}

// filters given array of questions according to filter input values
//  specified within given container
function filterQuestions(questions, containerId) {
	const category = document.querySelector(`#${containerId} [name='category']`).value;
	const description = document.querySelector(`#${containerId} [name='description']`).
		value.toLowerCase().trim();
	const difficulty = document.querySelector(`#${containerId} [name='difficulty']`).value;
	//let newArray = arr.filter(callback(element[, index, [array]])[, thisArg])
	return questions.filter((question) => {
		return (!category || question.category == category) &&
			(!description || question.description.toLowerCase().indexOf(description) != -1) &&
			(!difficulty || question.difficulty == difficulty)

	});
}

// creates table that displays and allows to edit feedback sub items for 1 answer
function createFeedbackTable(id, json, updateGrade) {
	function createTextTh(text, width) {
	  let cell = document.createElement("th");
	  if (width) {
		  cell.style.width= width;
	  }
	  let newText  = document.createTextNode(text);
	  cell.appendChild(newText);
	  return cell;
	}
	function createTd(input) {
	  let cell = document.createElement("td");
	  cell.appendChild(input);
	  return cell;
	}
	function createTableHeader() {
	  let row = document.createElement("tr");
	  row.appendChild(createTextTh("Feedback item", "30%"));
	  row.appendChild(createTextTh("Comment", "60%"));
	  row.appendChild(createTextTh("Score", "10%"));
	  return row;
	}
	let data = JSON.parse(json);
	let table = document.createElement("table");
	table.id = id;
	table.style.width = "100%";
	table.style.marginBottom = "30px";
	let tbody = document.createElement("tbody");
	table.appendChild(tbody);
	tbody.appendChild(createTableHeader());
	for (rowData of data) {
	  let row = document.createElement("tr");
	  row.className = "feedback-data-row";

	  let div = document.createElement("div");
	  div.innerHTML = rowData.item;
	  div.className = "feedback-item-desc";
	  row.appendChild(createTd(div));

	  let input = document.createElement("input");
	  input.value = rowData.outcome;
	  input.style.width = "100%";
	  input.className = "feedback-item-outcome";
	  if (!updateGrade) {
		input.setAttribute("disabled", "true");
	  } else {
		  input.addEventListener('change', updateGrade);
		  input.addEventListener('keyup', updateGrade);
	  }
	  row.appendChild(createTd(input));

	  input = document.createElement("input");
	  input.value = rowData.score;
	  input.style.width = "100%"
	  input.setAttribute("type", "number");
	  input.className = "feedback-item-score";
	  if (!updateGrade) {
		input.setAttribute("disabled", "true");
	  } else {
		input.addEventListener('change', updateGrade);
		input.addEventListener('keyup', updateGrade);
	  }
	  row.appendChild(createTd(input));
	  tbody.appendChild(row);
	}
	return table;
  }

  // gets data from above feedback form
  function getFeedbackData(answerId) {
	const selector = `#comment_${answerId}`;
	const table = document.querySelector(selector);
	const rows = table.querySelectorAll(".feedback-data-row");
	let items = [];
	for (let row of rows) {
		const item = {
			item: row.querySelector(".feedback-item-desc").innerHTML,
			outcome: row.querySelector(".feedback-item-outcome").value,
			score: +(row.querySelector(".feedback-item-score").value) /* '+' converts to number */
		}
		items.push(item);
	}
	return items;
  }

  function calcGrade(answers) {
	let score = 0;
	let maxScore = 0;
	for (const answer of answers) {
	  maxScore += answer.maxPoints;
	  const feedbackData = JSON.parse(answer.autograderComment);
	  for (subitem of feedbackData) {
		if (subitem.score) {
		  score += subitem.score; 
		}
	  }
	}
	return Math.round(score * 100 / maxScore);
  }

// fetches data from the server and processes it by calling resultCallback
// requestType used by middle end to select which back end scripts to call
// formData is optional. If request is to load data its empty. If saving data, then it contains whatever need to be saved
function sendRequest(requestType, resultCallback, formData) {
	const username = getUrlVars()["user"];
	const md5 = getUrlVars()["md5"];
	var data = {
		"username": username,
		"md5": md5,
		"requestType": requestType,
		"formData": formData
	};	  
	fetch('https://web.njit.edu/~emo26/front_end.php', {
		method: 'POST',
		body: JSON.stringify(data)
	})
	.then((response) => {
		return response.json();
	})
	.then((json) => {
		console.log(json);
		if (json.result=='success') {
			resultCallback(json);
		} else if (json.result=='loginFailed') {
			show('loginError');
		} else {
			show('systemError');
		}
	})
	.catch((error) => {
		//console.error('Error:', error);
		show('systemError');
	});
}
	
// appends row to html table. Creates TD for each of values passed
function appendRow(table, values) {
  var row = document.createElement("tr");
  row.className = "row";
  values.forEach(function(value) {
	var cell = document.createElement("td");
	var newText  = document.createTextNode(value);
	cell.appendChild(newText);
	row.appendChild(cell);
  });
  var tbody = table.getElementsByTagName('tbody')[0];
  tbody.appendChild(row);
  return row;
}

// removed rows from a given table, a table inside section with id=listName
function clearList(listName) {
  var rows = document.querySelectorAll("#"+listName + " .row");
  rows.forEach(function(item) {
	item.remove();
  });
}

// hide all secitons
function hideEverything() {
  document.querySelectorAll(".section").forEach(function(section) {
	section.style.display = "none";
  });
}

// hide given section such as a list of a form
function hide(section) {
  document.querySelector("#"+section).style.display="none";
}

// show given section.  
function show(section) {
  document.querySelector("#"+section).style.display="block";
}
function logout() {
  location.replace("login.html");
}
function getUrlVars() {
	var vars = {};
	var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
		vars[key] = value;
	});
	return vars;
}
function displayCurrentUser() {
  const user = getUrlVars()["user"];
  if (!user) {
	logout();
  }
  document.querySelector("#username").innerHTML = user;
}
  