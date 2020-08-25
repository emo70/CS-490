// -----------------  common functions -------------

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
	fetch('http://localhost/FRONT/front_end.php', {
		method: 'POST',
		body: JSON.stringify(data)
	})
		.then((response) => {
			return response.json();
		})
		.then((json) => {
			console.log(json);
			if (json.result == 'success') {
				resultCallback(json);
			} else if (json.result == 'loginFailed') {
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
	values.forEach(function (value) {
		var cell = document.createElement("td");
		var newText = document.createTextNode(value);
		cell.appendChild(newText);
		row.appendChild(cell);
	});
	var tbody = table.getElementsByTagName('tbody')[0];
	tbody.appendChild(row);
	return row;
}

// removed rows from a given table, a table inside section with id=listName
function clearList(listName) {
	var rows = document.querySelectorAll("#" + listName + " .row");
	rows.forEach(function (item) {
		item.remove();
	});
}

// hide all secitons
function hideEverything() {
	document.querySelectorAll(".section").forEach(function (section) {
		section.style.display = "none";
	});
}

// hide given section such as a list of a form
function hide(section) {
	document.querySelector("#" + section).style.display = "none";
}

// show given section.  
function show(section) {
	document.querySelector("#" + section).style.display = "block";
}
function logout() {
	location.replace("login.html");
}
function getUrlVars() {
	var vars = {};
	var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function (m, key, value) {
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
