#Ruby ORM

* Idea of this program is to replicate some common Activerecord commands

##Directions:

* Meant to be run in IRB, then load ruby_ORM.rb 
* If you have not created a database, run the dbCreate function
* This will create a psql db called ORM
* If you need to create a user table, run the tableCreate function
* DB name is ORM
* table is users
* table columns are: id(auto), fname, lname, email, age
* class is User
* .find will find a user by id 
* .where takes in a hash of user attributes, searches through the database for users
* with those attributes, and returns the results if there are any.
* .all will return all users as objects in an array,
* .last and .first will find the last and first entries to the DB.
* .destroy_all will delete every record in the DB.
* .destroy will ask you for a user's first name, and then delete that user.
* .create will create a new user with your in.
* .save will save an instance of User in the DB. So pass in fname, lname, email age
* to the User.save(fname, lname, email, age(integer) method and it will save to the database.
