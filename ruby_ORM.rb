# Ruby ORM by Richard Mable

def directions
	puts ""
	puts "Directions:"
	puts ".find will find a user by id, .all will return all users as objects in an array,"
	puts ".last and .first will find the last and first entries to the DB."
	puts "DB name is ORM, table is users"
	puts "class is User"
	puts ""
	puts "This is a work in progress!"
	puts ""
end

directions

class User
	attr_accessor :fname, :lname, :address, :email, :age

	#might need a method to initialize database, pass in arguments, and create the table
	def initialize(fname="", lname="", address="", email="", age="")
		@fname = fname
		@lname = lname
		@address = address
		@email = email
		@age = age
	end

	# find - takes an ID argument and finds the User with that ID, returns a user object w/ information on that user from the DB
	def self.find(id)
		# backticks ` escape the irb, psql -d ORM goes into psql, -c make the line in "" a command
		userById = `psql -d ORM -c "SELECT * FROM users WHERE id = #{id}";`
		puts userById
	end

	# where - takes a Hash argument of user attributes and finds users with those attributes, returns an array of matching User objects
	# def self.where(user_hash{})
	# 	if fname = ""

	# 	end

	# end

	# all - returns all users in the database as objects inside of an array
	def self.all
	@arrayUsers = Array.new{Hash.new}	
		tableSize = `psql -d ORM -c "SELECT COUNT(id) FROM users;"`
		puts tableSize
		i = 1
		(1..5).each do |i|	
			userObject = `psql -d ORM -c "SELECT fname, lname, address, email, age FROM users WHERE ID = '#{i}'";`
			@arrayUsers.push(userObject)
			i += 1
		end
		puts @arrayUsers
	end

	# last - returns an object containing the last user in the database
	def self.last
		#sort the order of the table by descending number, then limit to the first result, print to page.
		userLast = `psql -d ORM -c "SELECT * FROM users ORDER BY id DESC LIMIT 1"`
		puts userLast
	end

	# begin EC

	# first - returns an object containing the first user in the database
	def self.first
		userFirst = `psql -d ORM -c "SELECT * FROM users ORDER BY id ASC LIMIT 1"`
		puts userFirst
	end

	# create - Takes a Hash of user attributes and creates a new user record in the database, returns that record with the correct ID
	def self.create
	end

	# destroy_all - Destroys every record in the users table.
	def self.destroy_all
	end

	# save - An instance method. Saves an instance of User inside the database.
	def self.save
	end

	# destroy - Destroys a particular record.
	def self.destroy
	end
end

