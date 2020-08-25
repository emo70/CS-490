<?php
	// Emeka Okonkwo
	
	// CS490 project backend
	// Alpha 
	require 'db.php';
	$decode = file_get_contents('php://input');
	$data = json_decode($decode, true);


	$username = mysqli_real_escape_string($conn, $data['username']);
	$password = mysqli_real_escape_string($conn, $data['password']);


	$password = MD5($password);

	$sql = "SELECT * FROM users WHERE username='$username'";
	$result = mysqli_query($conn, $sql) or die("BAD SQL");

	// Check to see if a result was found from the query
	if(mysqli_num_rows($result) > 0){
		// Assign the results to a variable (associative array) to be used by php code
		$row = mysqli_fetch_assoc($result);

		// Database info
		$DbID = $row['ID'];
		$DbUser = $row['username'];
		$DbPass = $row['password'];
		$dbarray = array("ID" => $DbID, "User" => $DbUser);

		// Check to see if the data we retrieved matches the data in the database
		if($DbPass == $password){
			echo json_encode($dbarray,true);
			exit();
		}else if ($DbPass !== $password){
			echo json_encode("Wrong Password");
			exit();
		}
	}else{
		echo json_encode("No user Found");
		exit();
	}
	mysqli_close($conn);

?>