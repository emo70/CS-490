CREATE TABLE IF NOT EXISTS `answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `result_id` int(11) NOT NULL,
  `answer` varchar(1000) NOT NULL,
  `autograderComment` varchar(10000) NOT NULL,
  `maxPoints` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_result` (`result_id`),
  KEY `fk_question` (`question_id`)
);

INSERT INTO `answers` (`id`, `question_id`, `result_id`, `answer`, `autograderComment`, `maxPoints`) VALUES
(16, 7, 15, 'getSum', '[{"item":"Test case using inputs 2,2","outcome":"Compile or run error","score":0},{"item":"Test case using inputs 4,4","outcome":"Compile or run error","score":5},{"item":"Test case using inputs 8,8","outcome":"Compile or run error","score":0},{"item":"Function name should be ''getSum''","outcome":"Function name - a word that preceds ''('', was not found","score":3},{"item":"Following constraint: Must use ''print'' statement","outcome":"Not followed","score":0},{"item":"Colon at the end of the first line","outcome":"Not found! The first line of the function definition must end with colon","score":0}]', 25),
(17, 7, 16, 'def getSum(a,b):\n return a+b', '[{"item":"Test case using inputs 2,2","outcome":"Passed","score":4.2},{"item":"Test case using inputs 4,4","outcome":"Passed","score":4.2},{"item":"Test case using inputs 8,8","outcome":"Passed","score":4.2},{"item":"Function name should be ''getSum''","outcome":"Correct","score":4.2},{"item":"Following constraint: Must use ''print'' statement","outcome":"Not followed","score":0},{"item":"Colon at the end of the first line","outcome":"Found","score":4}]', 25),
(18, 2, 17, 'def recur_factorial(n):  \n   if n == 1:  \n       return n  \n   else:  \n       return n*recur_factorial(n-1)  ', '[{"item":"Test case using inputs 5","outcome":"Passed","score":6.6},{"item":"Test case using inputs 10","outcome":"Passed","score":6.6},{"item":"Function name should be ''factorial''","outcome":"Function name ''recur_factorial'' is incorrect","score":0},{"item":"Following constraint: Must use ''if'' statement","outcome":"Followed","score":6.6},{"item":"Colon at the end of the first line","outcome":"Found","score":6.6}]', 33),
(19, 7, 17, 'def getSum(a,b)\n return a+b', '[{"item":"Test case using inputs 2,2","outcome":"Passed","score":4.2},{"item":"Test case using inputs 4,4","outcome":"Passed","score":4.2},{"item":"Test case using inputs 8,8","outcome":"Passed","score":4.2},{"item":"Function name should be ''getSum''","outcome":"Correct","score":4.2},{"item":"Following constraint: Must use ''print'' statement","outcome":"Not followed","score":4},{"item":"Colon at the end of the first line","outcome":"Not found! The first line of the function definition must end with colon","score":4}]', 25),
(20, 9, 17, 'def getProduct(a,c):\n print a*c', '[{"item":"Test case using inputs 3,7","outcome":"Passed","score":3},{"item":"Function name should be ''getProduct''","outcome":"Correct","score":3},{"item":"Colon at the end of the first line","outcome":"Found","score":3}]', 9),
(32, 7, 27, 'def helloWorld():\nprint(''helloWorld'')', '[{"item":"Test case using inputs 2,2","outcome":"Compile or run error","score":1},{"item":"Test case using inputs 4,4","outcome":"Compile or run error","score":0},{"item":"Test case using inputs 8,8","outcome":"Compile or run error","score":0},{"item":"Function name should be ''getSum''","outcome":"Function name ''helloWorld'' is incorrect","score":0},{"item":"Following constraint: Must use ''print'' statement","outcome":"Followed","score":4.2},{"item":"Colon at the end of the first line","outcome":"Found","score":4}]', 25),
(33, 40, 28, 'def operation(op, a, b):\n			if op == ''+'':\n				return a + b\n			elif op == ''-'':\n				return a - b\n			elif op == ''*'':\n				return a * b\n			elif op == ''/'':\n				return a / b\n			else:\n				return -1', '[{"item":"Test case using inputs \\"+\\",2,3","outcome":"Passed","score":3.8},{"item":"Test case using inputs \\"-\\",10,3","outcome":"Passed","score":3.8},{"item":"Test case using inputs \\"*\\",8,7","outcome":"Passed","score":3.8},{"item":"Test case using inputs \\"/\\",24,8","outcome":"Passed","score":3.8},{"item":"Test case using inputs \\"%\\",3,8","outcome":"Passed","score":3.8},{"item":"Function name should be ''operation''","outcome":"Correct","score":3.8},{"item":"Following constraint: Must use ''if'' statement","outcome":"Followed","score":3.8},{"item":"Colon at the end of the first line","outcome":"Found","score":3.4}]', 30),
(34, 2, 28, 'def recur_factorial(n):\n   if n == 1:\n       return n\n   else:\n       return n*recur_factorial(n-1)\n', '[{"item":"Test case using inputs 5","outcome":"Passed","score":5},{"item":"Test case using inputs 10","outcome":"Passed","score":5},{"item":"Function name should be ''factorial''","outcome":"Function name ''recur_factorial'' is incorrect","score":0},{"item":"Following constraint: Must use ''if'' statement","outcome":"Followed","score":5},{"item":"Colon at the end of the first line","outcome":"Found","score":5}]', 25),
(35, 31, 28, 'def getSum(a,b):\n return a+b', '[{"item":"Test case using inputs 2,2","outcome":"Passed","score":5},{"item":"Test case using inputs 4,4","outcome":"Passed","score":5},{"item":"Test case using inputs 10,5","outcome":"Passed","score":5},{"item":"Function name should be ''getSum''","outcome":"Correct","score":5},{"item":"Colon at the end of the first line","outcome":"Found","score":5}]', 25);


CREATE TABLE IF NOT EXISTS `exams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(512) NOT NULL,
  `questions` varchar(1000) NOT NULL,
  `created` varchar(1000) NOT NULL,
  `points` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_exam_name` (`name`)
);

INSERT INTO `exams` (`id`, `name`, `questions`, `created`, `points`) VALUES
(41, 'Points test', '[2,7,9]', '4/12/2020, 10:22:48 PM', '[33,25,9]'),
(42, 'Output test', '[7]', '4/14/2020, 6:04:46 PM', '[25]'),
(46, 'Demo exam', '[40,2,31]', '4/16/2020, 6:48:01 PM', '[30,25,25]');


CREATE TABLE IF NOT EXISTS `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(255) NOT NULL,
  `description` varchar(1000) NOT NULL,
  `difficulty` varchar(255) NOT NULL,
  `functionName` varchar(255) NOT NULL,
  `outputWay` varchar(255),
  `testCaseValues` varchar(255) NOT NULL,
  `testCaseResults` varchar(1000) NOT NULL,
  `constr` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
);


INSERT INTO `questions` (`id`, `category`, `description`, `difficulty`, `functionName`, `outputWay`, `testCaseValues`, `testCaseResults`, `constr`) VALUES
(2, 'Recursion', 'Write a recursive function called ''factorial'' that calculates and returns factorial of a given number', 'Medium', 'factorial', 'Return', '[["5"],["10"]]', '["120","3628800"]', 'Must use ''if'' statement'),
(3, 'Flow Control', 'Create a function that runs some very complicated loop', 'Hard', 'executeLoop', 'Return', '[["1","1"]]', '["2"]', 'Must use ''for'' loop'),
(7, 'Math Operations', 'Write function getSum that prints sum of two numbers', 'Easy', 'getSum', 'Print', '[["2","2"],["4","4"],["8","8"]]', '["4","8","16"]', 'Must use ''print'' statement'),
(8, 'Math Operations', 'write function called ''getDiff'' that will take parameters a and b and return a-b', 'Easy', 'getDiff', 'Return', '[["10","3"],["20","5"]]', '["7","15"]', NULL),
(9, 'Math Operations', 'Write function getProduct that takes two parameters and returns a product', 'Easy', 'getProduct', 'Return', '[["3","7"]]', '["21"]', NULL),
(16, 'Flow Control', 'Write function get100 that return 100', 'Easy', 'get100', 'Return', '[]', '["100"]', NULL),
(19, 'Flow Control', 'Write function GetLalala which returns ''lalala''', 'Easy', 'GetLalala', 'Return', '[]', '["lalala"]', NULL),
(23, 'Strings', 'Write a function helloWorld that takes two arguments and returns concatenation of the two strings', 'Easy', 'helloWorld', 'Return', '[["\\"hello\\"","\\"world\\""]]', '["helloworld"]', NULL),
(26, 'Flow Control', 'Write a Python function that checks whether a passed string is palindrome or not.\n\n', 'Easy', 'isPalindrome', 'Return', '[["''aza''"],["''wow''"],["''loop''"]]', '["True","True","False"]', 'Must use ''for'' loop'),
(29, 'Recursion', 'Write a function ''recur_factorial'' to find factorial of number using recursion', 'Hard', 'recur_factorial', 'Return', '[["1"],["5"],["7"]]', '["1","120","5040"]', 'Must use ''if'' statement'),
(31, 'Math Operations', 'Write function ''getSum'' that will add two numbers and return sum. ', 'Easy', 'getSum', 'Return', '[["2","2"],["4","4"],["10","5"]]', '["4","8","15"]', NULL),
(32, 'Strings', 'Write function ''helloWorld'' that prints ''helloWorld''', 'Medium', 'helloWorld', 'Print', '[]', '["helloWorld"]', 'Must use ''print'' statement'),
(34, 'Math Operations', 'Write a function named doubltIt that takes a single int argument, num, and returns twice the value.', 'Easy', 'doubleIt', 'Return', '[["2"],["4"]]', '["4","8"]', NULL),
(35, 'Math Operations', 'Write a function named doubleIt that takes a single int argument called num and returns twice the value.', 'Medium', 'doubleIt', 'Return', '[["2"],["4"]]', '["4","8"]', NULL),
(40, 'Math Operations', 'Write a function named "operation" that takes three arguments: "op" which is an arithmetic operator, "+","-","*" or "/", and "a" and "b" which are two int numbers.\nThe function must return the result.', 'Medium', 'operation', 'Return', '[["\\"+\\"","2","3"],["\\"-\\"","10","3"],["\\"*\\"","8","7"],["\\"/\\"","24","8"],["\\"%\\"","3","8"]]', '["5","7","56","3","-1"]', 'Must use ''if'' statement'),
(41, 'Flow Control', 'Write a function getSum that takes argument n and returns sum of all positive integers from 1 to n. For n < 1 it should return -1.', 'Medium', 'getSum', '', '[["3"],["-5"]]', '["6","-1"]', NULL),
(42, 'Strings', 'Write function helloWorld that prints "helloWorld"', 'Easy', 'helloWorld', '', '[[],[]]', '["helloWorld","helloWorld"]', NULL);


CREATE TABLE IF NOT EXISTS `results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `exam_id` int(11) NOT NULL,
  `takenOn` varchar(255) NOT NULL,
  `autoGrade` int(11),
  `released` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_exam` (`exam_id`),
  KEY `fk_username` (`username`)
);


INSERT INTO `results` (`id`, `username`, `exam_id`, `takenOn`, `autoGrade`, `released`) VALUES
(15, 'student', 42, '4/16/2020, 1:52:30 PM', 32, 1),
(16, 'student', 42, '4/16/2020, 1:57:31 PM', 83, 1),
(17, 'student', 41, '4/16/2020, 5:31:41 PM', 90, 1),
(27, 'student', 42, '4/16/2020, 7:55:18 PM', 37, 1),
(28, 'student', 46, '4/16/2020, 8:10:31 PM', 94, 1);


CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `md5` varchar(255) NOT NULL,
  `userType` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_username` (`username`)
);


INSERT INTO `users` (`id`, `username`, `md5`, `userType`) VALUES
(1, 'student', md5('student'), 'student'),
(2, 'instructor', md5('instructor'), 'instructor');


ALTER TABLE `answers`
  ADD CONSTRAINT `fk_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
  ADD CONSTRAINT `fk_result` FOREIGN KEY (`result_id`) REFERENCES `results` (`id`);

ALTER TABLE `results`
  ADD CONSTRAINT `fk_exam` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`),
  ADD CONSTRAINT `fk_username` FOREIGN KEY (`username`) REFERENCES `users` (`username`);

