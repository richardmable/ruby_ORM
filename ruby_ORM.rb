# Ruby ORM by Richard Mable

#see if I can create a man page for this app.
#create db and create tables in directions, they'll need to start postgresql as well
#remember this runs in irb

def direcitons
	puts "Directions"
end

directions

def man
end

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
		userById = `psql -d ORM -c "SELECT #{id} FROM users";`
		puts userById
	end

	# where - takes a Hash argument of user attributes and finds users with those attributes, returns an array of matching User objects
	def self.where(user_hash{})
		if #etc
		end

	end

	# all - returns all users in the database as objects inside of an array
	#I think this needs to be a loop
	#this COUNT function is inherently slow, according to postgresql documentation
	#.each do loops are preferred in Ruby
	def self.all
		arrayUsers = []
		tableSize = `psql -d ORM -c "SELECT COUNT(*) FROM users;"`
		(0..tableSize).each do |i|
			arrayUsers

			#change column type each time through, put into array each time.
			select each user, place in array. need to know size of column
		# select each column, put each result into array?
		puts array_users
	end

	# last - returns an object containing the last user in the database
	def self.last
		#sort the order of the table by descending number, then limit to the first result, print to page.
		userLast = `psql -d ORM -c "SELECT ORDER BY DESC LIMIT 1"`
		puts userLast
	end


	# begin EC
	# first - returns an object containing the first user in the database
	def self.first
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

