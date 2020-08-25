<?php
// Takes raw data from the request
$json = file_get_contents('php://input');

// Converts it into a PHP object
$data = json_decode($json, true);


$maxPoints = 0;
$earnedPoints = 0;

if ($data["requestType"]=="autograder") {
  $answers2 = array();
  $answers = $data["formData"]["answers"];
  foreach ($answers as $answer) {
	
    $question = $answer["question"];
	$points = $question["points"];
	$maxPoints += $points;
    $functionName = $question["functionName"];
    $outputWay = $question["outputWay"]; // "Print" or "Return"
    $functionCall = "";
    $testCaseValues = json_decode($question["testCaseValues"]);
	$testCaseResults = json_decode($question["testCaseResults"]);
	
	// add function call for each test case. There could be no inputs, just outputs, so iterating using number of results, not inputs
	for ($i = 0; $i < count($testCaseResults); $i++) {
		if (isset($testCaseValues[$i])) {
			$testCaseString = implode(",", $testCaseValues[$i]); 
		} else {
			$testCaseString = '';
		}
		if ($outputWay=="Print") { 
			$functionCall = $functionCall . "\n$functionName($testCaseString)";
		} else {
			// if function expected to just return a value, wrap call into print statement, otherwise there won't be any output to compare
			$functionCall = $functionCall . "\nprint($functionName($testCaseString))"; 
		}
	}
	
    $functionBody = $answer["answer"]; 
	$fullProgram = "$functionBody\n$functionCall";
	$output = array();
	
	if (trim($functionBody) !=='') {	
		$tmpHandle = tmpfile();
		fwrite($tmpHandle, $fullProgram);
		$metaDatas = stream_get_meta_data($tmpHandle);
		$tmpFilename = $metaDatas['uri'];
		
		exec("timeout 1s python $tmpFilename", $output, $exitcode);
		fclose($tmpHandle);
		
		if ($exitcode==0) { // exit code 0 means there was no compilation error. Proceed with comparing outputs for each test case
		  $testCaseNum = 0;
		  $numPassed = 0;
		  foreach ($testCaseResults as $testCaseResult) {
			$testCaseOutput = $output[$testCaseNum++];
			if ($testCaseResult == $testCaseOutput) {
			  $numPassed++;
			}
		  }
		  $totalCases = count($testCaseResults);
		  if ($numPassed == $totalCases) {
			$passed = true;
			$comment = 'All tests passed';
			$earnedPoints += $points;
		  } else {
			$passed = false;
			$comment = "$numPassed out of $totalCases tests passed." .
				"\nCalled as follows:" .
				$functionCall .
				"\nOutput is:\n" . implode("\n", $output) .
				"\nExpected:\n" . implode("\n", $testCaseResults);
		  }
		  
		} elseif ($exitcode==124 || $exitcode==137) { // these 2 exit codes returned by "timeout" unix command mean there was timeout
		  $passed = false;
		  $comment = "Infinite loop detected"; 
		} else {
		  $passed = false;
		  $comment = "Compilation or run time error";
		}
	} else {
		$passed = false;
		$comment = "No answer";		
	}		
	// add this to backend request for debug purpose. Backend will return entire request as a debug property of the json response
	$debuginfo = array(
      "output" => $output,
      "exitcode" => $exitcode,
      "program" => $fullProgram		
	);
	$answer2 = array(
		"question_id" => $answer["question"]["id"],
		"answer" => $answer["answer"],
		"passed" => $passed,
		"autograderComment" => $comment,
		"debug" => $debuginfo
	);
	$answers2[] = $answer2;
  }
  
  $grade = round($earnedPoints * 100 / $maxPoints);
  
  $formData2 = array(
	"exam_id" => $data["formData"]["exam_id"],
	"takenOn" => $data["formData"]["takenOn"],
	"autoGrade" => $grade,
	"answers" => $answers2
  );
  
  $data_tosave = array(
      "username" => $data["username"],
      "md5" => $data["md5"],
      "requestType" => $data["requestType"],
	  "formData" => $formData2
    );
  
  $url = "http://localhost/BACK/back_results.php";
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