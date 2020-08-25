<?php
// back_questions.php

require 'db.php';  
require 'back_include.php';

// process request
if ($data["requestType"]=="questions") {
	$sql = "SELECT * FROM questions";
	$stmt = mysqli_stmt_init($conn);
	if(!mysqli_stmt_prepare($stmt, $sql)){
		echo '{"result":"error","error":"failed to prep statement"}';
		mysqli_close($conn);
		exit();
	}
	else{
		mysqli_stmt_execute($stmt);
		$rows = array();
		mysqli_stmt_store_result($stmt);		
		while($row = fetchStatement($stmt)){
			$rows[] = $row;
		} 
	}
	$response = array(
		"questions"=>$rows,
		"result"=>"success",
		"debug"=>$json
	);
	echo json_encode($response);
}
elseif ($data["requestType"]=="addQuestion") {
	$sql = "INSERT INTO questions".
	"(category,description,difficulty,functionName,testCaseValues,testCaseResults, constr) ".
	"values(?, ?, ?, ?, ?, ?, ?)";
	$stmt = mysqli_stmt_init($conn);
	if(!mysqli_stmt_prepare($stmt, $sql)){
		echo '{"result":"error","error":"failed to prep statement"}';
		mysqli_close($conn);
		exit();
	}
	else{
		$formData = $data["formData"];
		mysqli_stmt_bind_param(
			$stmt, "sssssss", 
			$formData["category"], 
			$formData["description"], 
			$formData["difficulty"], 
			$formData["functionName"], 
			$formData["testCaseValues"], 
			$formData["testCaseResults"],
			$formData["constr"]
      );
		mysqli_stmt_execute($stmt);
	}
	$response = array(
		"result"=>"success",
		"debug"=>$json
	);
	echo json_encode($response);
}
elseif ($data["requestType"]=="deleteQuestion") {
	$sql = "DELETE FROM questions".
	" WHERE id=?";
	$stmt = mysqli_stmt_init($conn);
	if(!mysqli_stmt_prepare($stmt, $sql)){
		echo '{"result":"error","error":"failed to prep statement"}';
		mysqli_close($conn);
		exit();
	}
	else{
		$formData = $data["formData"];
	
		mysqli_stmt_bind_param($stmt, "i", $formData["question_id"]);
		mysqli_stmt_execute($stmt);
	}
	$response = array(
		"result"=>"success",
		"debug"=>$json
	);
  echo json_encode($response);
} 
else {
	echo '{"error":"unknown Request type"}'; 
}

mysqli_close($conn);

?>