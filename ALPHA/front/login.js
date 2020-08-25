function do_login() {
    var username = document.getElementById("username").value;
    var password = document.getElementById("password").value;
    var jsonObject = { "username": username, "password": password };

    var ajax = new XMLHttpRequest();
    var method = "POST";
    var url = "login.php";

    ajax.open(method, url, true);

    ajax.onreadystatechange = function () {
        if (ajax.readyState == 4) {
            document.getElementById("info").innerHTML = ajax.responseText;
        }
    };

    ajax.send(JSON.stringify(jsonObject));


}