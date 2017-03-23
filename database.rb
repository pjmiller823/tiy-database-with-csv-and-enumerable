require 'csv'
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
    CSV.foreach("employees.csv", headers: true) do |row|
      name = row[name]
      phone_number = row[phone_number]
      address = row[address]
      position = row[position]
      salary = row[salary]
      slack_account = row[slack_account]
      github_account = row[github_account]

      person = People.new(name, phone_number, address, position, salary, slack_account, github_account)
      @personnel << person
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
    puts "Who would you like to search for?"
    search = gets.chomp
    found_person = @personnel.find {|person| person.name == search}

    if found_person
      puts "You searched for #{found_person.name}."
      puts "their phone number is #{found_person.phone_number}."
      puts "Their address is #{found_person.address}."
      puts "They are the/a #{found_person.position}."
      puts "They make #{found_person.salary}."
      puts "They can be found on the internet at #{found_person.slack_account} and #{found_person.github_account}."
      puts "Now please try not to misuse that information"
    else
      puts "That person does not exist. Would you like to add them?"
    end
  end

  def deleting_people
    puts "Who would you like to delete?"
    delete = gets.chomp
    delete_person = @personnel.delete_if {|person| person.name == delete}

    if delete_person
      puts "Thank you for deleting!"
    else
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

# Steps for completing the homework:
# - ***Change my loops into enumerables.***
# - ***Creat a CSV file***
# - Put collected information into the CSV
# - Add a rule that doesn't let people recreate a person
# - Change the search to allow a partial match against the person's name, an exact match of the Slack Account, an exact match of the Github Account
# - Reformat display of Search results
# - Rewrite the CSV when an employee is added or deleted
# - Create a reports menu.
# - include total count and salary for three individuals.
