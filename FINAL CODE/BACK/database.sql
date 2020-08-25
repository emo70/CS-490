-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Host: sql1.njit.edu
-- Generation Time: Apr 25, 2020 at 07:22 PM
-- Server version: 8.0.17
-- PHP Version: 5.6.40

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `emo26`
--

-- --------------------------------------------------------

--
-- Table structure for table `answers`
--

CREATE TABLE IF NOT EXISTS `answers` (
`id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `result_id` int(11) NOT NULL,
  `answer` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL,
  `autograderComment` varchar(10000) COLLATE utf8mb4_general_ci NOT NULL,
  `maxPoints` int(11) DEFAULT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci AUTO_INCREMENT=1 ;

--
-- Dumping data for table `answers`
--

INSERT INTO `answers` (`id`, `question_id`, `result_id`, `answer`, `autograderComment`, `maxPoints`) VALUES
(18, 8, 13, 'def get100():\n    return 100', '{"items":[{"item":"Test case using inputs ","outcome":"Passed","score":16.7},{"item":"Function name should be ''get100''","outcome":"Correct","score":16.7},{"item":"Colon at the end of the first line","outcome":"Found","score":16.6}],"comment":"fdsfdsafads"}', 50),
(19, 14, 13, 'def helloWorld():\n    print (''helloWorld'')', '{"items":[{"item":"Test case using inputs ","outcome":"Passed","score":12.5},{"item":"Function name should be ''helloWorld''","outcome":"Correct","score":12.5},{"item":"Following constraint: Must use ''print'' statement","outcome":"Followed","score":12.5},{"item":"Colon at the end of the first line","outcome":"Found","score":12.5}],"comment":"gasgasg"}', 50),
(20, 8, 14, 'def get10():\n    return 100', '{"items":[{"item":"Test case using inputs ","outcome":"Passed","score":16.7},{"item":"Function name should be ''get100''","outcome":"Function name ''get10'' is incorrect","score":0},{"item":"Colon at the end of the first line","outcome":"Found","score":16.6}],"comment":""}', 50),
(21, 14, 14, 'def hello():\n    return (''helloWorld'')', '{"items":[{"item":"Test case using inputs ","outcome":"Passed","score":12.5},{"item":"Function name should be ''helloWorld''","outcome":"Function name ''hello'' is incorrect","score":0},{"item":"Following constraint: Must use ''print'' statement","outcome":"Not followed","score":0},{"item":"Colon at the end of the first line","outcome":"Found","score":12.5}],"comment":""}', 50),
(22, 8, 15, 'def get100()\n    print 100', '{"items":[{"item":"Test case using inputs ","outcome":"Passed","score":26},{"item":"Function name should be ''get100''","outcome":"Correct","score":20},{"item":"Colon at the end of the first line","outcome":"Not found! The first line of the function definition must end with colon","score":9}],"comment":""}', 50),
(23, 14, 15, 'def helloWorld()\n    print (''helloWorld'')', '{"items":[{"item":"Test case using inputs ","outcome":"Passed","score":12.5},{"item":"Function name should be ''helloWorld''","outcome":"Correct","score":12.5},{"item":"Following constraint: Must use ''print'' statement","outcome":"Followed","score":12.5},{"item":"Colon at the end of the first line","outcome":"Not found! The first line of the function definition must end with colon","score":0}],"comment":"fasfsa"}', 50),
(24, 14, 16, 'def helloWorld():\n print (''helloWorld'')', '{"items":[{"item":"Test case using inputs ","outcome":"Passed","score":25},{"item":"Function name should be ''helloWorld''","outcome":"Correct","score":25},{"item":"Following constraint: Must use ''print'' statement","outcome":"Followed","score":25},{"item":"Colon at the end of the first line","outcome":"Found","score":25}],"comment":""}', 100);

-- --------------------------------------------------------

--
-- Table structure for table `exams`
--

CREATE TABLE IF NOT EXISTS `exams` (
`id` int(11) NOT NULL,
  `name` varchar(512) COLLATE utf8mb4_general_ci NOT NULL,
  `questions` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL,
  `created` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL,
  `points` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `exams`
--

INSERT INTO `exams` (`id`, `name`, `questions`, `created`, `points`) VALUES
(3, 'test', '[8,14]', '4/24/2020, 6:25:43 PM', '[50,50]'),
(4, 'e3', '[14]', '4/25/2020, 3:19:00 PM', '[100]');

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE IF NOT EXISTS `questions` (
`id` int(11) NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL,
  `difficulty` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `functionName` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `testCaseValues` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `testCaseResults` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL,
  `constr` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`id`, `category`, `description`, `difficulty`, `functionName`, `testCaseValues`, `testCaseResults`, `constr`) VALUES
(3, 'Recursion', 'Write a recursive function called ''factorial'' that calculates and returns factorial of a given number', 'Medium', 'factorial', '[["5"],["10"]]', '["120","3628800"]', 'Must use ''if'' statement'),
(4, 'Flow Control', 'Create a function that runs some very complicated loop', 'Hard', 'executeLoop', '[["1","1"]]', '["2"]', 'Must use ''for'' loop'),
(5, 'Math Operations', 'Write function getSum that prints sum of two numbers', 'Easy', 'getSum', '[["2","2"],["4","4"],["8","8"]]', '["4","8","16"]', 'Must use ''print'' statement'),
(6, 'Math Operations', 'write function called ''getDiff'' that will take parameters a and b and return a-b', 'Easy', 'getDiff', '[["10","3"],["20","5"]]', '["7","15"]', NULL),
(7, 'Math Operations', 'Write function getProduct that takes two parameters and returns a product', 'Easy', 'getProduct', '[["3","7"]]', '["21"]', NULL),
(8, 'Flow Control', 'Write function get100 that return 100', 'Easy', 'get100', '[]', '["100"]', NULL),
(9, 'Flow Control', 'Write function GetLalala which returns ''lalala''', 'Easy', 'GetLalala', '[]', '["lalala"]', NULL),
(10, 'Strings', 'Write a function helloWorld that takes two arguments and returns concatenation of the two strings', 'Easy', 'helloWorld', '[["\\"hello\\"","\\"world\\""]]', '["helloworld"]', NULL),
(11, 'Flow Control', 'Write a Python function that checks whether a passed string is palindrome or not.\n\n', 'Easy', 'isPalindrome', '[["''aza''"],["''wow''"],["''loop''"]]', '["True","True","False"]', 'Must use ''for'' loop'),
(12, 'Recursion', 'Write a function ''recur_factorial'' to find factorial of number using recursion', 'Hard', 'recur_factorial', '[["1"],["5"],["7"]]', '["1","120","5040"]', 'Must use ''if'' statement'),
(13, 'Math Operations', 'Write function ''getSum'' that will add two numbers and return sum. ', 'Easy', 'getSum', '[["2","2"],["4","4"],["10","5"]]', '["4","8","15"]', NULL),
(14, 'Strings', 'Write function ''helloWorld'' that prints ''helloWorld''', 'Medium', 'helloWorld', '[]', '["helloWorld"]', 'Must use ''print'' statement'),
(15, 'Math Operations', 'Write a function named doubltIt that takes a single int argument, num, and returns twice the value.', 'Easy', 'doubleIt', '[["2"],["4"]]', '["4","8"]', NULL),
(16, 'Math Operations', 'Write a function named doubleIt that takes a single int argument called num and returns twice the value.', 'Medium', 'doubleIt', '[["2"],["4"]]', '["4","8"]', NULL),
(17, 'Math Operations', 'Write a function named "operation" that takes three arguments: "op" which is an arithmetic operator, "+","-","*" or "/", and "a" and "b" which are two int numbers.\nThe function must return the result.', 'Medium', 'operation', '[["\\"+\\"","2","3"],["\\"-\\"","10","3"],["\\"*\\"","8","7"],["\\"/\\"","24","8"],["\\"%\\"","3","8"]]', '["5","7","56","3","-1"]', 'Must use ''if'' statement'),
(18, 'Flow Control', 'Write a function getSum that takes argument n and returns sum of all positive integers from 1 to n. For n < 1 it should return -1.', 'Medium', 'getSum', '[["3"],["-5"]]', '["6","-1"]', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `results`
--

CREATE TABLE IF NOT EXISTS `results` (
`id` int(11) NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `exam_id` int(11) NOT NULL,
  `takenOn` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `released` tinyint(4) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci AUTO_INCREMENT=1 ;

--
-- Dumping data for table `results`
--

INSERT INTO `results` (`id`, `username`, `exam_id`, `takenOn`, `released`) VALUES
(13, 'student', 3, '4/24/2020, 6:26:28 PM', 1),
(14, 'student', 3, '4/24/2020, 6:27:27 PM', 1),
(15, 'student', 3, '4/24/2020, 6:28:01 PM', 1),
(16, 'student', 4, '4/25/2020, 3:19:28 PM', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
`id` int(11) NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `md5` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `userType` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci AUTO_INCREMENT=3 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `md5`, `userType`) VALUES
(1, 'student', 'cd73502828457d15655bbd7a63fb0bc8', 'student'),
(2, 'instructor', '175cca0310b93021a7d3cfb3e4877ab6', 'instructor');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `answers`
--
ALTER TABLE `answers`
 ADD PRIMARY KEY (`id`), ADD KEY `fk_result` (`result_id`), ADD KEY `fk_question` (`question_id`);

--
-- Indexes for table `exams`
--
ALTER TABLE `exams`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `unique_exam_name` (`name`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `results`
--
ALTER TABLE `results`
 ADD PRIMARY KEY (`id`), ADD KEY `fk_exam` (`exam_id`), ADD KEY `fk_username` (`username`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `unique_username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `answers`
--
ALTER TABLE `answers`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=25;
--
-- AUTO_INCREMENT for table `exams`
--
ALTER TABLE `exams`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT for table `results`
--
ALTER TABLE `results`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `answers`
--
ALTER TABLE `answers`
ADD CONSTRAINT `fk_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
ADD CONSTRAINT `fk_result` FOREIGN KEY (`result_id`) REFERENCES `results` (`id`);

--
-- Constraints for table `results`
--
ALTER TABLE `results`
ADD CONSTRAINT `fk_exam` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`),
ADD CONSTRAINT `fk_username` FOREIGN KEY (`username`) REFERENCES `users` (`username`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
