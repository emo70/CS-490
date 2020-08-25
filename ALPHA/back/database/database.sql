DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users(
	`ID` INT AUTO_INCREMENT,
    `username` VARCHAR(255) NOT NULL unique,
    `password` VARCHAR(255) NOT NULL,
    `TIMESTAMP`DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ID)
);

INSERT INTO users (username, password) VALUES ('test', MD5('test'));
INSERT INTO users (username, password) VALUES ('test1', MD5('test1'));
INSERT INTO users (username, password) VALUES ('test2', MD5('test2'));
INSERT INTO users (username, password) VALUES ('test3', MD5('test3'));
INSERT INTO users (username, password) VALUES ('test4', MD5('test4'));
INSERT INTO users (username, password) VALUES ('test5', MD5('test5'));
INSERT INTO users (username, password) VALUES ('test6', MD5('test6'));