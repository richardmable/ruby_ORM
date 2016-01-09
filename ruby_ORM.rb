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
	attr_accessor :fname, :lname, :email, :age
	attr_reader :id

	#might need a method to initialize database, pass in arguments, and create the table
	#create a hash of values then pull from the hash to assign to vars @fname = hash_of_values[:fname]
	#turn string into array with i.split! where the ! saves the new array to i without making a new var
	#use t.gsub("<", "") to replace < or etc with white space, to use t.split! properly
	#
	#User.new initializes a new user object, and assigns each value to an instance var. Pass in the key: value pairs, save to a var if desired
	def initialize(userAttributes = {})
		@fname = userAttributes.fetch(:fname) if userAttributes[:fname]
		@lname = userAttributes.fetch(:lname) if userAttributes[:lname]
		@email = userAttributes.fetch(:email) if userAttributes[:email]
		@age = userAttributes.fetch(:age) if userAttributes[:age]
		puts "User ID: #{userAttributes[:id]}"
		puts "First Name: #{userAttributes[:fname]}"
		puts "Last Name: #{userAttributes[:lname]}"
		puts "Email: #{userAttributes[:email]}"
		puts "Age: #{userAttributes[:age]}"

	end

	# find - takes an ID argument and finds the User with that ID, returns a user object w/ information on that user from the DB
	def self.find(id)
		# backticks ` escape the irb, psql -d ORM goes into psql, -c make the line in "" a command
		userById = `psql -d ORM -c "SELECT * FROM users WHERE id = #{id}";`
		puts userById
	end

	# where - takes a Hash argument of user attributes and finds users with those attributes, returns an array of matching User objects
	# this method will place a user in the array if they match *ANY* attribute provided
	def self.where(userAttributes = {})
		keys = ""
		values = ""
		#rotate through each key value pair and check if they match the key value pair in the DB
		userAttributes.each do |k, v|
			keys += "#{k.to_s}" + ', '
			values += "'#{v.to_s}'" + ', '
		end

		keys = keys.chop.chop
		values = values.chop.chop
		queryReturn = `psql -d ORM -c "SELECT * FROM users WHERE (#{keys}) = (#{values})";`
		#check to see if there are any results, by seeing if queryReturn contains the 'no results' string from irb
		if queryReturn == " id | fname | lname | email | age | datecreated \n----+-------+-------+-------+-----+-------------\n(0 rows)\n\n"
			puts "There were no results of your search."
		#else, call the parse info function to parse the results into a readable format and print to terminal
		else
			parse_info queryReturn
		end
		
	end

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

	def self.parse_info returned_value
		#initialize line number to 0 to iterate through the lines of results
		line_num = 0
		#count the number of lines, so that we know how many results were returned
		lineCount = (returned_value.lines.count - 3)
		#
		returned_value.each_line do |line|
			# removes the pipes and splits the remaining information into an array
			searchResultInfo = line.gsub("|", '').split
			(2..lineCount).each do |userInfoLine|
				if line_num == userInfoLine
					puts "Your search returned some results!"
					# sets information found by each user by accessing array searchResultInfo
					# prints out to irb by invoking the new user method
					User.new(id: searchResultInfo[0], fname: searchResultInfo[1], lname: searchResultInfo[2], email: searchResultInfo[3], age: searchResultInfo[4])
					puts "Next User:"
				end
			end
			#increment the line_num by one to move onto the next line
			line_num += 1
		end	
	end
end







