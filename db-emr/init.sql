CREATE DATABASE IF NOT EXISTS emr_db;
USE emr_db;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(255) NOT NULL
);

-- normal user
INSERT INTO users (username, password)
VALUES ('doctor', 'securepass');

-- nurse user with weak password (matches MD5 example, if you use it later)
INSERT INTO users (username, password)
VALUES ('nurse', 'nurse2024');

-- table for possible future flags / creds
CREATE TABLE IF NOT EXISTS credentials (
  id INT AUTO_INCREMENT PRIMARY KEY,
  service VARCHAR(50),
  username VARCHAR(50),
  password VARCHAR(255)
);

INSERT INTO credentials (service, username, password)
VALUES ('domain_admin', 'Administrator', 'D0mainAdm1n2024');
