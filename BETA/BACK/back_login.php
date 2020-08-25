<?php

// back_login.php
require 'db.php';  

// Takes raw data from the request
$json = file_get_contents('php://input');

// Converts it into a PHP object
$data = json_decode($json, true);
if (isset($data["md5"])) {
  $md5 = $data["md5"];
} else {
  $md5 = MD5($data["password"]);
}


$sql = "SELECT * FROM users WHERE username=? AND md5=?;";
$stmt = mysqli_stmt_init($conn);
if(!mysqli_stmt_prepare($stmt, $sql)){
	echo '{"result":"error","error":"failed to prep statement"}';
}
else{
	mysqli_stmt_bind_param($stmt, "ss", $data["username"], $md5);
	mysqli_stmt_execute($stmt);
	mysqli_stmt_store_result($stmt);	
	// Check for results, assign it to a variable (associative array) to be used by php code 
	if($row = fetchAssocStatement($stmt)){
		$row["result"]="success"; // UI is expecting json property 'result'='success'
		echo json_encode($row);
	} else {
		echo '{"result":"loginFailed"}';
	}
}
mysqli_close($conn);
?>