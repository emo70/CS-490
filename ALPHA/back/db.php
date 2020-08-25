<?php
// Emeka Okonkwo
// Back end

	include 'secret.php';
	
	$conn = mysqli_connect($host, $user, $password, $dbName);
	if(!$conn){
		die('ERROR Could not connnect. ' .mysqli_connect_error());
		exit();
	}
	
	//$con->close();
	

  ?>