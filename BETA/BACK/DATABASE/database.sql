
CREATE TABLE users (
	id INT AUTO_INCREMENT PRIMARY KEY,
	username VARCHAR(255) NOT NULL,
	md5 VARCHAR(255) NOT NULL,
	userType VARCHAR(255) NOT NULL,
	CONSTRAINT unique_username UNIQUE (username)
);

/* create data: users 
student/student
instructor/instructor
 */
INSERT INTO users (username, md5, userType) values 
('student', MD5('student'), 'student');
INSERT INTO users (username, md5, userType) values 
('instructor', MD5('instructor'), 'instructor');

/* create questions table */
CREATE TABLE questions (
	id INT AUTO_INCREMENT PRIMARY KEY,
	category VARCHAR(255) NOT NULL,
	description VARCHAR(255) NOT NULL,
	difficulty VARCHAR(255) NOT NULL,
	functionName VARCHAR(255) NOT NULL,
	outputWay VARCHAR(255) NOT NULL,
	testCaseValues VARCHAR(255) NOT NULL,
	testCaseResults VARCHAR(255) NOT NULL,
	constr VARCHAR(255)
);
	
/* create exams table */
CREATE TABLE exams (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(512) NOT NULL,
	questions VARCHAR(255) NOT NULL,
	points VARCHAR(1000) NOT NULL,
	created VARCHAR(255) NOT NULL,
	CONSTRAINT unique_exam_name UNIQUE (name)
);
	
/*create table results*/
CREATE TABLE results (
	id INT AUTO_INCREMENT PRIMARY KEY,
	username VARCHAR(255) NOT NULL,
	exam_id INT NOT NULL,
	takenOn VARCHAR(255) NOT NULL,
	autoGrade INT NOT NULL,
	released TINYINT NOT NULL,
	CONSTRAINT fk_exam FOREIGN KEY (exam_id) REFERENCES exams(id),
	CONSTRAINT fk_username FOREIGN KEY (username) REFERENCES users(username)
);

/*create answers */
CREATE TABLE answers (
	id INT AUTO_INCREMENT PRIMARY KEY,
	question_id INT NOT NULL,
	result_id INT NOT NULL,
	answer VARCHAR(255) NOT NULL,
	maxPoints INT,
	autograderComment VARCHAR(255) NOT NULL,
	CONSTRAINT fk_result FOREIGN KEY (result_id) REFERENCES results(id),
	CONSTRAINT fk_question FOREIGN KEY (question_id) REFERENCES questions(id)
);