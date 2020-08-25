<?php

// runs python program and returns output if ran successfully;
// otherwise returns "#error"
function runProgram($fullProgram) {
	$output = array();
	$tmpHandle = tmpfile();
	fwrite($tmpHandle, $fullProgram);
	$metaDatas = stream_get_meta_data($tmpHandle);
	$tmpFilename = $metaDatas['uri'];
	
	exec("timeout 1s python $tmpFilename", $output, $exitcode);
	fclose($tmpHandle);
	if ($exitcode==0) { // exit code 0 means there was no compilation error.
		return $output[0];
	} elseif ($exitcode==124 || $exitcode==137) { // these 2 exit codes returned by "timeout" unix command mean there was timeout
		return "#error";
	} else {
		return "#error";
	}
}

// runs single test case and returns: "#pass", "#error" or the actual incorrect output
function runTestCase($functionName, $functionBody, $testCaseValues, $expectedOutput) {
	if (isset($testCaseValues)) {
		$testCaseString = implode(",", $testCaseValues); 
	} else {
		$testCaseString = '';
	}
	
	$functionCall = "$functionName($testCaseString)";
	$fullProgram = "$functionBody\n$functionCall";
	$output = runProgram($fullProgram);
	if ($output=="#error") {
		return "#error";
	} elseif ($output==$expectedOutput) {
		return "#pass";
	} else {
		$functionCall = "print($functionName($testCaseString))";
		$fullProgram = "$functionBody\n$functionCall";
		$output = runProgram($fullProgram);
		if ($output==$expectedOutput) {
			return "#pass";
		} else {
			return $output;
		}
	}
}

// generates feedback json for 1 test case
function getTestCaseFeedback($result, $partialPoints, $testCaseValues, $testCaseResult) {
	$testCaseString = implode(",", $testCaseValues);
	$item = "Test case using inputs $testCaseString";
	if ($result == "#error") {
		$feedback = array(
			"item" => $item,
			"outcome" => "Compile or run error",
			"score" => 0
		);
	} elseif ($result == "#pass") {
		$feedback = array(
			"item" => $item,
			"outcome" => "Passed",
			"score" => $partialPoints
		);
	} else {
		$feedback = array(
			"item" => $item,
			"outcome" => "Did not pass. Expected output $testCaseResult, actual output $result",
			"score" => 0
		);
	}
	return $feedback;
}

//generates feedback for the function name
function getNameFeedback($actualName, $correctName, $partialPoints) {
	$item = "Function name should be '$correctName'";
	if ($actualName == $correctName) {
		$feedback = array(
			"item" => $item,
			"outcome" => "Correct",
			"score" => $partialPoints
		);
	} elseif ($actualName == 'NotFound') {
		$feedback = array(
			"item" => $item,
			"outcome" => "Function name - a word that preceds '(', was not found",
			"score" => 0
		);
	} else {
		$feedback = array(
			"item" => $item,
			"outcome" => "Function name '$actualName' is incorrect",
			"score" => 0
		);
	}
	return $feedback;
}

function getColonFeedback($colonFound, $partialPoints) {
	$item = "Colon at the end of the first line";
	if ($colonFound) {
		$feedback = array(
			"item" => $item,
			"outcome" => "Found",
			"score" => $partialPoints
		);
	} else {
		$feedback = array(
			"item" => $item,
			"outcome" => "Not found! The first line of the function definition must end with colon",
			"score" => 0
		);
	}
	return $feedback;
}

function getConstraintFeedback($constraintDesc, $functionBody, $partialPoints) {
	// extract constraint word like 'print' or 'if' from constraint description that we have in UI.
	// Uses reg exp to find a word within single quotes
	$constraint = preg_replace("/.*'(\w+)'.*/", "$1", $constraintDesc); 
	$item = "Following constraint: $constraintDesc";
	// multiline search of $constraint within functionBody
	if (preg_match("#\W+$constraint\W+#", $functionBody)) {
		$feedback = array(
			"item" => $item,
			"outcome" => "Followed",
			"score" => $partialPoints
		);
	} else {
		$feedback = array(
			"item" => $item,
			"outcome" => "Not followed",
			"score" => 0
		);
	}
	return $feedback;
}

// find actual function name within the first line of function body
// uses reg exp to find a word before the opening bracket
function getActualName($firstLine) {
	if (preg_match("/\w+\s+(\w+)\s*[(]/", $firstLine, $matches)) {
		$actualName = $matches[1];
	} else {
		$actualName = "NotFound";
	}
	return $actualName;
}
// ---------- main script --------------

// Takes raw data from the request
$json = file_get_contents('php://input');
// Converts it into a PHP object
$data = json_decode($json, true);

if ($data["requestType"]=="autograder") {
  $answers2 = array();
  $answers = $data["formData"]["answers"];

  foreach ($answers as $answer) {
	$functionBody = $answer["answer"]; 
	$points = $answer["points"];

	if (trim($functionBody) !=='') {
		$question = $answer["question"];
		$functionName = $question["functionName"];    
		$testCaseValues = json_decode($question["testCaseValues"]);
		$testCaseResults = json_decode($question["testCaseResults"]);
		$functionLines = explode("\n", $functionBody);
		$firstLine = rtrim($functionLines[0]);
		$actualName = getActualName($firstLine);
		// if colon is not found at the end of the first line, note and fix the problem so that
		// we can still compile it and run test cases
		if (substr($firstLine, -1)==":") {
			$colonFound = true;
		} else {
			$colonFound = false;
			$functionLines[0] = "$firstLine:";
			$functionBody = implode("\n", $functionLines);
		}
	
		$numItems = count($testCaseResults) + 2; // number of items for itemized feedback on this answer
		if ($question["constr"]) {
			$numItems++;
		}
	
		// we ll give equal number of points for each test case
		// as well as 2-3 other things: correct function name, presence of colon and following constraint, if defined
		$partialPoints = round($points / $numItems, 1);
		// use this for last feebdack item because partial points need to add up to $points, despite rounding
		$partialPointsLast = $points - $partialPoints * ($numItems-1); 

		$answerFeedback = array();

		for ($i = 0; $i < count($testCaseResults); $i++) {
			$result = runTestCase($actualName, $functionBody, 
				$testCaseValues[$i], $testCaseResults[$i]);
			$answerFeedback[] = getTestCaseFeedback($result, $partialPoints, 
				$testCaseValues[$i], $testCaseResults[$i]);
		}
		
		$answerFeedback[] = getNameFeedback($actualName, $functionName, $partialPoints);
		if ($question["constr"]) {
			$answerFeedback[] = getConstraintFeedback($question["constr"], $functionBody, $partialPoints);
		}
		$answerFeedback[] = getColonFeedback($colonFound, $partialPointsLast);
		$feedbackWrapper = array(
			"items" => $answerFeedback,
			"comment" => ""
		);
		$comment = json_encode($feedbackWrapper);
	} else {
		$comment = "No answer";		
	}		
	
	$answer2 = array(
		"question_id" => $answer["question"]["id"],
		"answer" => $answer["answer"],
		"maxPoints" => $points,
		"autograderComment" => $comment
	);
	$answers2[] = $answer2;
  }
  
  $grade = round($earnedPoints * 100 / $maxPoints);
  
  $formData2 = array(
	"exam_id" => $data["formData"]["exam_id"],
	"takenOn" => $data["formData"]["takenOn"],
	"answers" => $answers2
  );
  
  $data_tosave = array(
      "username" => $data["username"],
      "md5" => $data["md5"],
      "requestType" => $data["requestType"],
	  "formData" => $formData2
    );
  
  $url = "https://web.njit.edu/~emo26/back_results.php"; 
  $handle = curl_init();
  curl_setopt($handle, CURLOPT_URL, $url);
  curl_setopt($handle, CURLOPT_POST, true);
  curl_setopt($handle, CURLOPT_POSTFIELDS , json_encode($data_tosave));
  curl_setopt($handle, CURLOPT_RETURNTRANSFER, true);
  $return_json = curl_exec($handle);
  curl_close($handle);
  echo $return_json;
  
} 
else {
  echo '{"result":"error","error":"unknown Request type"}';
}

?>