CREATE TABLE USERS
(
	ID INT IDENTITY(1,1),
	EMAIL VARCHAR(50),
	PASSWORD VARCHAR(40),
	REGISTER_DATE DATE NOT NULL DEFAULT GETDATE()
);

CREATE TABLE FRIENDS
(
	RELATION VARCHAR(30)
);

CREATE TABLE WALLS
(
	ID_USER INT,
	ID_PUBLISHER INT,
	CONTENT VARCHAR(512),
	PUBDATE DATE
);

CREATE TABLE GROUPS
(
	GR_ID INT IDENTITY(1,1),
	GR_NAME VARCHAR(30),
	DESCRIPTION VARCHAR(256) NOT NULL DEFAULT ''
);

CREATE TABLE GROUPMEMBERS
(
	RELATION VARCHAR(30)
);
