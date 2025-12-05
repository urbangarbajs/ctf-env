CREATE DATABASE IF NOT EXISTS emr_db;
USE emr_db;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NOT NULL
);

INSERT INTO users (username, password, password_hash)
VALUES
  ('doctor', 'securepass', SHA2('securepass', 256)),
  ('nurse', 'nurse2024', SHA2('nurse2024', 256)),
  ('backup', 'HealthyBackup2025!', '929a9ca8774d3d05f5882bb2619473b5c5026618832affcaeb6cf70fd196962b');

CREATE TABLE IF NOT EXISTS patients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  mrn VARCHAR(50),
  name VARCHAR(100),
  note TEXT
);

INSERT INTO patients (mrn, name, note)
VALUES
  ('MRN-2025-CTF-01', 'CTF Test Patient', 'CTF-Patient flag location'),
  ('MRN-2024-0002', 'John Doe', 'routine checkup'),
  ('MRN-2024-0003', 'Jane Smith', 'allergy follow-up');

CREATE TABLE IF NOT EXISTS staff (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50),
  email VARCHAR(100),
  password VARCHAR(255)
);

INSERT INTO staff (username, email, password)
VALUES
  ('nurse.ana', 'nurse.ana@healthyclinic.local', 'Nurse123!'),
  ('tech.tim', 'tech.tim@healthyclinic.local', 'Techie!2025');

CREATE TABLE IF NOT EXISTS mail_messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  recipient VARCHAR(100),
  sender VARCHAR(100),
  subject VARCHAR(200),
  body TEXT
);

INSERT INTO mail_messages (recipient, sender, subject, body)
VALUES
  ('nurse.ana@healthyclinic.local', 'it@healthyclinic.local', 'HC-CTF{EMAIL_LEAK}', 'Confidential message with the mail flag.'),
  ('nurse.ana@healthyclinic.local', 'it@healthyclinic.local', 'Welcome', 'Welcome to HealthyClinic.');

CREATE TABLE IF NOT EXISTS credentials (
  id INT AUTO_INCREMENT PRIMARY KEY,
  service VARCHAR(50),
  username VARCHAR(50),
  password VARCHAR(255)
);

INSERT INTO credentials (service, username, password)
VALUES ('domain_admin', 'HC-ADMIN', 'Adm1nHC!2025');
