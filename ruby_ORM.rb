# Ruby ORM by Richard Mable

#directions the are printed to irb
def directions
	puts ""
	puts "                     Directions:"
	puts ""
	puts "     If you have not created a database, run the dbCreate function"
	puts "     This will create a psql db called ORM"
	puts "     If you need to create a user table, run the tableCreate function"
	puts "     DB name is ORM"
	puts "     table is users"
	puts "     table columns are: id(auto), fname, lname, email, age"
	puts "     class is User"
	puts "     .find will find a user by id "
	puts "     .where takes in a hash of user attributes, searches through the database for users"
	puts "     with those attributes, and returns the results if there are any."
	puts "     .all will return all users as objects in an array,"
	puts "     .last and .first will find the last and first entries to the DB."
	puts "     .destroy_all will delete every record in the DB."
	puts "     .destroy will ask you for a user's first name, and then delete that user."
	puts "     .create will create a new user with your inputs."
	puts "     .save will save an instance of User in the DB. So pass in fname, lname, email age"
	puts "     to the User.save(fname, lname, email, age(integer) method and it will save to the database."
	puts ""
	puts "                      Have fun!"
	puts ""
end

#when ruby_ORM.rb is loaded, prints the directions for the user
directions

def dbCreate
	`createdb ORM`
	puts "psql database ORM created!"
end

#creates a table called users with the appropriate columns if the user has not created a table in the db
def tableCreate
	`psql -d ORM -c "CREATE TABLE users (
		id serial PRIMARY KEY,
		fname varchar(50),
		lname varchar(50),
		email varchar (20),
		age integer
		)";`
puts "Table users was created in db ORM!"
end	

class User
	attr_accessor :fname, :lname, :email, :age
	attr_reader :id

	#User.new initializes a new user object, and assigns each value to an instance var. Pass in the key: value pairs, save to a var if desired
	def initialize(userAttributes = {})
		#sets instance variables equal to the user attributes, if they exist
		@id = userAttributes.fetch(:id) if userAttributes[:id]
		@fname = userAttributes.fetch(:fname) if userAttributes[:fname]
		@lname = userAttributes.fetch(:lname) if userAttributes[:lname]
		@email = userAttributes.fetch(:email) if userAttributes[:email]
		@age = userAttributes.fetch(:age) if userAttributes[:age]

	end

	# find - takes an ID argument and finds the User with that ID, returns a user object w/ information on that user from the DB
	def self.find(id)
		# backticks ` escape the irb, psql -d ORM goes into psql, -c make the line in "" a command
		userById = `psql -d ORM -c "SELECT * FROM users WHERE id = #{id}";`
		if userById == " id | fname | lname | email | age | datecreated \n----+-------+-------+-------+-----+-------------\n(0 rows)\n\n"
			puts "There were no results of your search."
		#else, call the parse_info function to parse the results into a readable format and print to terminal
		else
			puts "Your search returned some results!"
			#this returns an array. Use .first to pull it out of the array to be its own object
			(parse_info userById).first
		end
	end

	# where - takes a Hash argument of user attributes and finds users with those attributes, returns an array of matching User objects
	# this method will return results only if the user matches all attributes provided
	def self.where(userAttributes = {})
		#set the keys and values vars to empty inititally
		keys = ""
		values = ""
		#rotate through each key value pair and make them match as in a hash
		userAttributes.each do |k, v|
			keys += "#{k.to_s}" + ', '
			values += "'#{v.to_s}'" + ', '
		end
		#remove the extra spaces
		keys = keys.chop.chop
		values = values.chop.chop
		#now search the database for users that match the supplied key value pairs
		queryReturn = `psql -d ORM -c "SELECT * FROM users WHERE (#{keys}) = (#{values})";`
		#check to see if there are any results, by seeing if queryReturn contains the 'no results' string from irb
		if queryReturn == " id | fname | lname | email | age | datecreated \n----+-------+-------+-------+-----+-------------\n(0 rows)\n\n"
			puts "There were no results of your search."
		#else, call the parse_info function to parse the results into a readable format and print to terminal
		else
			puts "Your search returned some results!"
			parse_info queryReturn
		end
	end

	# all - returns all users in the database as objects inside of an array
	def self.all
	#check the size of the table users
	tableSize = `psql -d ORM -c "SELECT COUNT(id) FROM users;"`
	#parse the resulting string by removing formatting and set tableSize to that result
	tableSize.gsub!(/-|count|\(|\)|\n|1 row/, '')
	#turn the string into an int to be used for the range in .each do
	tableSize = tableSize.to_i
	#if the table size is 0, there are no results, so this will print a message to the user informing them
		if tableSize == 0
			puts "There were no results of your search. Maybe you have an empty database?"
		#if the tableSize is any other number than 0, there are results, and this will print those results for the user
		else
			allUsers = Array.new
			puts "Here are all users in the database:"
			#now for 1 through the size of the table, look for a user with that id
			(1..tableSize).each do |i|	
				#each time through, assign userObject to the result of the search for that user's attributes via their ID
				queryReturn = `psql -d ORM -c "SELECT id, fname, lname, email, age FROM users WHERE ID = '#{i}';"`
				#grab the return of the parse_info each time it loops through, set to userInfo
				userInfo = parse_info queryReturn
				#grab the userInfo out of the array, so that we do not have arrays within arrays
				userInfo = userInfo.first
				#push that object into the allUsers array
				allUsers.push(userInfo)
				#increment i by 1 to move onto the next result
				i += 1
			end
		end
		#class method returns all the users in the database in the array
		allUsers
	end

	# last - returns an object containing the last user in the database
	def self.last
		#sort the order of the table by descending number, then limit to the first result, print to page.
		userLast = `psql -d ORM -c "SELECT * FROM users ORDER BY id DESC LIMIT 1;"`
		if userLast == " id | fname | lname | email | age | datecreated \n----+-------+-------+-------+-----+-------------\n(0 rows)\n\n"
			puts "There were no results of your search."
		#else, call the parse_info function to parse the results into a readable format and print to terminal
		else
			puts "Your search returned some results!"
			#this returns an array. Use .first to pull it out of the array to be its own object
			(parse_info userLast).first
		end
	end

	# first - returns an object containing the first user in the database
	def self.first
		userFirst = `psql -d ORM -c "SELECT * FROM users ORDER BY id ASC LIMIT 1;"`
		if userFirst == " id | fname | lname | email | age | datecreated \n----+-------+-------+-------+-----+-------------\n(0 rows)\n\n"
			puts "There were no results of your search."
		#else, call the parse_info function to parse the results into a readable format and print to terminal
		else
			puts "Your search returned some results!"
			#this returns an array. Use .first to pull it out of the array to be its own object
			(parse_info userFirst).first
		end
	end

	# create - Takes a Hash of user attributes and creates a new user record in the database, returns that record with the correct ID
	def self.create
		#create a new hash
		userCreate = Hash.new
		puts "First Name:"
		#ask user for first name
		fname_input = gets
		#get rid of the return character
		fname_input = fname_input.chomp
		#store the inputted value into the newly created hash
		userCreate.store("fname", "#{fname_input}")
		puts "Last Name:"
		lname_input = gets
		lname_input = lname_input.chomp
		userCreate.store("lname", "#{lname_input}")
		puts "Email:"
		email_input = gets
		email_input = email_input.chomp
		userCreate.store("email", "#{email_input}")
		puts "Age:"
		age_input = gets
		age_input = age_input.chomp
		userCreate.store("age", age_input)
		puts userCreate
		#create the user by inserting the stored hash values into the database
		`psql -d ORM -c "INSERT INTO users (fname, lname, email, age) VALUES ('#{userCreate['fname']}', '#{userCreate['lname']}', '#{userCreate['email']}', '#{userCreate['age']}');"`
	end

	# destroy_all - Destroys every record in the users table.
	def self.destroy_all
		`psql -d ORM -c "DELETE FROM users;"`
		puts "All users were deleted."
	end

	# save - An instance method. Saves an instance of User inside the database.
	def self.save(fname, lname, email, age)
		x = User.new({fname: "#{fname}", lname: "#{lname}", email: "#{email}", age: age})
		return x
	end

	# destroy - Destroys a particular record.
	def self.destroy
		puts "Please type the first name of the user you would like to delete:"
		# grab the user's input for the person they want to delete from the DB
		user_delete_fname = gets
		#delete the return characters at the end of the user input
		user_delete_fname = user_delete_fname.chomp
		queryReturn = `psql -d ORM -c "SELECT * FROM users WHERE fname = '#{user_delete_fname}';";`
		#check to see if that user exists
		if queryReturn == " id | fname | lname | email | age | datecreated \n----+-------+-------+-------+-----+-------------\n(0 rows)\n\n"
			puts "This person doesn't exist. Must have already deleted them?"
		else
			# the delete command, taking in the user input
			`psql -d ORM -c "DELETE FROM users WHERE fname = '#{user_delete_fname}';"`
			puts "#{user_delete_fname} was deleted."
		end
	end

	# this method turns the psql search results into human readable, workable data
	def self.parse_info(returned_value)
		#initialize line number to 0 to iterate through the lines of results
		line_num = 0
		#create a new empty hash
		arrayUsers = Array.new
		#count the number of lines, so that we know how many results were returned, and subtract 3
		#this is to account for the fact that the last 3 lines of any result do not contain user info
		lineCount = (returned_value.lines.count - 3)
		#for each line, do the following actions:
		returned_value.each_line do |line|
			# removes the pipes and splits the remaining information into an array
			searchResultInfo = line.gsub("|", '').split
			#now for lines 2 through lineCount, where lineCount is the max line of user information, do these actions
			(2..lineCount).each do |userInfoLine|
				#check to see if the current line_num matches the userInfoLine
				if line_num == userInfoLine
					# sets information found by each user by accessing array searchResultInfo
					userObject = User.new(id: searchResultInfo[0], fname: searchResultInfo[1], lname: searchResultInfo[2], email: searchResultInfo[3], age: searchResultInfo[4])
					#add the current userObject into the array arrayUsers
					arrayUsers.push(userObject)
				end
			end
			#increment the line_num by one to move onto the next line
			line_num += 1
		end	
		#the last line is what is returned by the method
		#hence put arrayUsers after the puts, or else arrayUsers becomes nil
		arrayUsers
	end
end
