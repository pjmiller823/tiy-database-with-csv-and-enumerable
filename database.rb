class People
  attr_reader "name", "phone_number", "address", "position", "salary", "slack_account", "github_account"

  def initialize(name, phone_number, address, position, salary, slack_account, github_account)
    @name = name
    @phone_number = phone_number
    @address = address
    @position = position
    @salary = salary
    @slack_account = slack_account
    @github_account = github_account
  end
end

class Database
  def initialize
    @personnel = []
  end

  def adding_people
    loop do
      puts "What is the person's name? If you're done entering people just press enter"
      name = gets.chomp

      if name.empty?
        break
      end

      puts "What is #{name}'s phone number?"
      phone_number = gets.chomp

      puts "What is #{name}'s address?"
      address = gets.chomp

      puts "What is #{name}'s position in the company?"
      position = gets.chomp

      puts "What is #{name}'s salary?"
      salary = gets.chomp

      puts "What is #{name}'s slack account?"
      slack_account = gets.chomp

      puts "What is #{name}'s github account?"
      github_account = gets.chomp

      puts "Thank you for the addition!"

      person = People.new(name, phone_number, address, position, salary, slack_account, github_account)

      @personnel << person

    end

  end

  def searching_people
    found = false
    puts "Who would you like to search for?"
    search = gets.chomp

    @personnel.each do |person|
      if person.name == search
        puts "You searched for #{person.name}, their phone number is #{person.phone_number}. Their address is #{person.address}. They are the/a #{person.position}. They make #{person.salary}. They can be found on the internet at #{@slack_account} and #{@github_account}. Now please try not to misuse that information"
        found = true
        break
      end
    end
    if found == false
      puts "That person does not exist. Would you like to add them?"
    end
  end

  def deleting_people
    found = false
    index = 0
    puts "Who would you like to delete?"
    delete = gets.chomp

    @personnel.each do |person|
      if person.name == delete
        found = true
        @personnel.slice!(index)
        puts "Thank you for deleting!"
      end
      index += 1
    end
    if found == false
      puts "That person doesn't exist. Would you like to add them?"
    end
  end
end

database = Database.new

loop do
  puts "Welcome to The Iron Yard employee database! Press 'A' to add a, 'S' to search for a person, and 'D' to delete someone. Have fun! (if you want to leave just press enter.)"
  user_input = gets.chomp.upcase

  if user_input.empty?
    break
  end

  if user_input == "A"
    database.adding_people
  end

  if user_input == "S"
    database.searching_people
  end

  if user_input == "D"
    database.deleting_people
  end
end
