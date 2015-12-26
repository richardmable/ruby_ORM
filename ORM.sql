CREATE TABLE users (
	id serial PRIMARY KEY,
	fname varchar(50),
	lname varchar(50),
	address varchar(50),
	email varchar (20),
	age integer,
	dateCreated timestamp
)
