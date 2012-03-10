-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Fri Mar  9 22:36:03 2012
-- 

BEGIN TRANSACTION;

--
-- Table: event
--
DROP TABLE event;

CREATE TABLE event (
  id INTEGER PRIMARY KEY NOT NULL,
  title varchar(255) NOT NULL,
  description text,
  created datetime NOT NULL,
  updated datetime NOT NULL,
  start datetime,
  end datetime,
  creator_id int NOT NULL
);

CREATE INDEX creation_idx ON event (created);

CREATE INDEX updated_idx ON event (updated);

CREATE INDEX dateframe_idx ON event (start, end);

--
-- Table: role
--
DROP TABLE role;

CREATE TABLE role (
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(20) NOT NULL DEFAULT ''
);

CREATE UNIQUE INDEX name ON role (name);

--
-- Table: user
--
DROP TABLE user;

CREATE TABLE user (
  id INTEGER PRIMARY KEY NOT NULL,
  email VARCHAR(255) NOT NULL DEFAULT '',
  password VARCHAR(50) NOT NULL DEFAULT '',
  name VARCHAR(64) DEFAULT ''
);

CREATE UNIQUE INDEX email ON user (email);

--
-- Table: event_user
--
DROP TABLE event_user;

CREATE TABLE event_user (
  event_id INT NOT NULL DEFAULT 0,
  user_id INT NOT NULL DEFAULT 0,
  created datetime NOT NULL,
  PRIMARY KEY (event_id, user_id),
  FOREIGN KEY(event_id) REFERENCES event(id),
  FOREIGN KEY(user_id) REFERENCES user(id)
);

CREATE INDEX event_user_idx_event_id ON event_user (event_id);

CREATE INDEX event_user_idx_user_id ON event_user (user_id);

--
-- Table: user_role
--
DROP TABLE user_role;

CREATE TABLE user_role (
  user_id INT NOT NULL DEFAULT 0,
  role_id INT NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY(role_id) REFERENCES role(id),
  FOREIGN KEY(role_id) REFERENCES user(id)
);

CREATE INDEX user_role_idx_role_id ON user_role (role_id);

COMMIT;
