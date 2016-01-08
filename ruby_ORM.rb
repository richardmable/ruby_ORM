# Ruby ORM by Richard Mable

# bulk of this is going to be parasing the data
# 

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
	#create a hash of values then pull from the hash to assign to vars @fname = hash_of_values[:fname]
	#turn string into array with i.split! where the ! saves the new array to i without making a new var
	#use t.gsub("<", "") to replace < or etc with white space, to use t.split! properly
	#
	#User.new initializes a new user object, and assigns each value to an instance var. Pass in the key: value pairs, save to a var if desired
	def initialize(userAttributes = {})
		@fname = userAttributes.fetch(:fname)
		@lname = userAttributes.fetch(:lname)
		@address = userAttributes.fetch(:address)
		@email = userAttributes.fetch(:email)
		@age = userAttributes.fetch(:age)
	end

	# find - takes an ID argument and finds the User with that ID, returns a user object w/ information on that user from the DB
	def self.find(id)
		# backticks ` escape the irb, psql -d ORM goes into psql, -c make the line in "" a command
		userById = `psql -d ORM -c "SELECT * FROM users WHERE id = #{id}";`
		puts userById
	end

	# where - takes a Hash argument of user attributes and finds users with those attributes, returns an array of matching User objects
	# this method will place a user in the array if they match *ANY* attribute provided

	# this will be the regexp that returns only the user's info: 
	# .gsub(/-|\+|\||\n|\(|\)|1 row|id|fname|lname|address|email|age|datecreated/, '')
	def self.where(userAttributes = {fname: "", lname: "", address: "", email: "", age: ""})
		#create an empty array to push matched users into
		arrayWhoMatches = Array.new
		#rotate through each key value pair and check if they match the key value pair in the DB
		userAttributes.each do |k, v|
			#if fname matches first thing returned etc
			# deal with blanks?
			queryReturn = `psql -d ORM -c "SELECT * FROM users WHERE #{k} = '#{v}'";`
			queryReturn.gsub!(/-|\+|\||\n|\(|\)|1 row|id|fname|lname|address|email|age|datecreated/, '')
			#then make array
			#then go through the array
			if v == `psql -d ORM -c "SELECT * FROM users WHERE #{k} = '#{v}'";`
				#if it is a match, put the user into the arrayWhoMatches
				@arrayWhoMatches.push(`psql -d ORM -c "SELECT * FROM users WHERE #{k} = '#{v}'";`)
			else
				puts ""
				puts "There were no matches to your query."
				puts ""
			end
		end
		# Now print the results to irb
		puts ""
		puts "Here are the results of your query:"
		puts ""
		puts arrayWhoMatches
	end


	# 	if userAttributes.fetch(:fname) == `psql -d ORM -c "SELECT * FROM users WHERE fname = #{userAttributes.fetch(:fname)}";`
	# 		@arrayWhoMatches.push(fname)

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

