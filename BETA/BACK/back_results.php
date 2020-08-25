<?php
require 'db.php';  
require 'back_include.php';

// process request
if ($data["requestType"]=="autograder") {
	$sql = "INSERT INTO results".
		"(username,exam_id,takenOn,autoGrade,released) ".
		"values(?, ?, ?, ?, ?)";
	$stmt = mysqli_stmt_init($conn);
	$sql2 = "INSERT INTO answers".
		"(question_id, result_id, answer, passed, autograderComment) ".
		"values(?, ?, ?, ?, ?)";
	$stmt2 = mysqli_stmt_init($conn);
	if(!mysqli_stmt_prepare($stmt, $sql) || !mysqli_stmt_prepare($stmt2, $sql2)){
		echo '{"result":"error","error":"failed to prep statement"}';
		mysqli_close($conn);
		exit();
	}
	else{
		$formData = $data["formData"];
		$released = 0;
		mysqli_stmt_bind_param(
      $stmt, "sissi", 
			$data["username"], 
			$formData["exam_id"], 
			$formData["takenOn"], 
			$formData["autoGrade"], 
			$released
      );
		mysqli_stmt_execute($stmt);
		
		$result_id = mysqli_insert_id($conn);
		$answers = $formData["answers"];
		
		foreach ($answers as $answer) {
			$passed = intval($answer["passed"]);//convert boolean to 0/1
			mysqli_stmt_bind_param(
        $stmt2, "iisis", 
				$answer["question_id"], 
				$result_id, 
				$answer["answer"], 
				$passed, 
				$answer["autograderComment"]
				);
			mysqli_stmt_execute($stmt2);
		}
	}
	$response = array(
		"result"=>"success",
		"debug"=>$json
	);
	echo json_encode($response);
  
}
elseif ($data["requestType"]=="pendingResults" || 
		($data["requestType"]=="myResults")) {
	
	$sql = "SELECT r.id, r.username, e.name examName, r.takenOn, r.autoGrade ".
	" FROM results r INNER JOIN exams e on r.exam_id=e.id ";
	if ($data["requestType"]=="myResults") {
		$sql = $sql . "WHERE r.released = 1";
	}
	$stmt = mysqli_stmt_init($conn);
	
	$sql2 = "SELECT * FROM answers WHERE result_id=?";
	$stmt2 = mysqli_stmt_init($conn);
	
	if(!mysqli_stmt_prepare($stmt, $sql) || !mysqli_stmt_prepare($stmt2, $sql2)){
		echo '{"result":"error","error":"failed to prep statement"}';
		mysqli_close($conn);
		exit();
	}
	else{
		 
		mysqli_stmt_execute($stmt);
		$rows = array();
		mysqli_stmt_store_result($stmt);	
		while($row = fetchStatement($stmt)){
			
			
			mysqli_stmt_bind_param($stmt2, "i", $row['id']); 
			mysqli_stmt_execute($stmt2);
			$rows2 = array();
			mysqli_stmt_store_result($stmt2);	
			while($row2 = fetchStatement($stmt2)){
				$rows2[] = $row2;
			} 
			
			$row['answers'] = $rows2;
			$rows[] = $row;
		} 
	}
	$response = array(
		"results"=>$rows,
		"result"=>"success",
		"debug"=>$json
	);
	echo json_encode($response);
  
}
elseif ($data["requestType"]=="releaseResult") {
	$sql = "UPDATE results SET released = 1, autoGrade=? WHERE id=?";
	$stmt = mysqli_stmt_init($conn);
	$sql2 = "UPDATE answers SET autograderComment=? WHERE id=?";
	$stmt2 = mysqli_stmt_init($conn);
	if(!mysqli_stmt_prepare($stmt, $sql) || !mysqli_stmt_prepare($stmt2, $sql2)){
		echo '{"result":"error","error":"failed to prep statement"}';
		mysqli_close($conn);
		exit();
	}
	else{
		$formData = $data["formData"];
		mysqli_stmt_bind_param(
      $stmt, "ii", 
			$formData["grade"],
			$formData["result_id"]
		);
		mysqli_stmt_execute($stmt);
		$comments = $formData["comments"];
		foreach ($comments as $comment) {
			mysqli_stmt_bind_param(
        $stmt2, "si", 
				$comment["text"],
				$comment["answer_id"]
			);
			mysqli_stmt_execute($stmt2);
		}
	}
	$response = array(
		"result"=>"success",
		"debug"=>$json
	);
	echo json_encode($response);
} 
elseif ($data["requestType"]=="deleteResult") {
	$sql = "DELETE FROM answers WHERE result_id=?";
	$stmt = mysqli_stmt_init($conn);
	$sql2 = "DELETE FROM results WHERE id=?";
	$stmt2 = mysqli_stmt_init($conn);
	if(!mysqli_stmt_prepare($stmt, $sql) || !mysqli_stmt_prepare($stmt2, $sql2)){
		echo '{"result":"error","error":"failed to prep statement"}';
		mysqli_close($conn);
		exit();
	}
	else{
		$formData = $data["formData"];
		mysqli_stmt_bind_param(
      $stmt, "i", 
			$formData["result_id"]
      );
		mysqli_stmt_execute($stmt);
		mysqli_stmt_bind_param(
      $stmt2, "i", 
			$formData["result_id"]
      );
		mysqli_stmt_execute($stmt2);
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