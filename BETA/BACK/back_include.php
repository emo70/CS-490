<?php
//back_include.php

function fetchStatement($stmt)
{
    if($stmt->num_rows>0)
    {
        $result = array();
        $md = $stmt->result_metadata();
        $params = array();
        while($field = $md->fetch_field()) {
            $params[] = &$result[$field->name];
        }
        call_user_func_array(array($stmt, 'bind_result'), $params);
        if($stmt->fetch())
            return $result;
    }

    return null;
}
// Takes raw data from the request
$json = file_get_contents('php://input');

// Converts it into a PHP object
$data = json_decode($json, true);
if (isset($data["md5"])) {
  $md5 = $data["md5"];
} else {
  $md5 = MD5($data["password"]);
}

// authenticate request
$sql = "SELECT * FROM users WHERE username=? AND md5=?;";
$stmt = mysqli_stmt_init($conn);
if(!mysqli_stmt_prepare($stmt, $sql)){
	echo '{"result":"error","error":"failed to prep statement"}';
	mysqli_close($conn);
	exit();
}
else{
	mysqli_stmt_bind_param($stmt, "ss", $data["username"], $md5);
	mysqli_stmt_execute($stmt);
	mysqli_stmt_store_result($stmt);	
	if($row = fetchStatement($stmt)){
		// request authenticated, process it
	} else {
		echo '{"result":"loginFailed"}';
		mysqli_close($conn);
		exit();
	}
	mysqli_stmt_close($stmt);
}
?>