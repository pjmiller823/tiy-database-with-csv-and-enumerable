require 'csv'
require 'erb'
class People
  attr_reader "name", "phone", "address", "position", "salary", "slack", "github"

  def initialize(name, phone, address, position, salary, slack, github)
    @name = name
    @phone = phone
    @address = address
    @position = position
    @salary = salary
    @slack = slack
    @github = github
  end
end

class Database
  def initialize
    @personnel = []
    CSV.foreach("employees.csv", headers: true) do |row|
      name = row["name"]
      phone = row["phone"]
      address = row["address"]
      position = row["position"]
      salary = row["salary"]
      slack = row["slack"]
      github = row["github"]

      person = People.new(name, phone, address, position, salary.to_i, slack, github)

      @personnel << person
    end
  end

  def adding_people
    loop do
      puts "What is the person's name? If you're done entering people just press enter"
      name = gets.chomp

      if name.empty?
        break
      end

      if @personnel.find {|person| person.name == name}
        puts "That person already exists!"
      else
        puts "What is #{name}'s phone number?"
        phone = gets.chomp

        puts "What is #{name}'s address?"
        address = gets.chomp

        puts "What is #{name}'s position in the company?"
        position = gets.chomp

        puts "What is #{name}'s salary?"
        salary = gets.chomp.to_i

        puts "What is #{name}'s slack account?"
        slack = gets.chomp

        puts "What is #{name}'s github account?"
        github = gets.chomp

        puts "Thank you for the addition!"

        person = People.new(name, phone, address, position, salary.to_i, slack, github)

        @personnel << person

        writing_to_csv
      end
    end
  end

  def searching_people
    puts "Who would you like to search for? You can search for their name, Slack name or Github account."
    search = gets.chomp

    found_person = @personnel.find {|person| person.name.include?(search) || person.slack == search || person.github == search}

    if found_person
      puts "You searched for #{found_person.name}."
      puts "their phone number is #{found_person.phone}."
      puts "Their address is #{found_person.address}."
      puts "They are the/a #{found_person.position}."
      puts "Their salary is #{found_person.salary}."
      puts "They can be found on the internet at (slack) #{found_person.slack} and github.com/#{found_person.github}."
      puts "Now please try not to misuse that information"
    else
      puts "That person does not exist. Would you like to add them?"
    end
  end

  def deleting_people
    puts "Who would you like to delete?"
    delete = gets.chomp
    delete_person = @personnel.find {|person| person.name == delete}

    if delete_person
      puts "Thank you for deleting!"
      writing_to_csv
    end
    if delete_person = false
      puts "That person doesn't exist. Would you like to add them?"
    end
  end

  def employee_reports
    employee_list_display
    employees_by_position = @personnel.group_by {|person| person.position}

    employees_by_position.each do |position, people|
      total_salary = people.map {|person| person.salary}.sum
      puts "the total salary of the #{position}s is #{total_salary}"
      puts "the number of #{position}s is #{people.count}"
    end
  end

  def employee_list_display
    sorted_employee_list = @personnel.sort_by{ |person| person.name}
    puts "Here is a list of everyone we have working here"
    sorted_employee_list.each do |person|
      puts "name: #{person.name.ljust(13)} phone number: #{person.phone.ljust(13)} address: #{person.address.ljust(25)} position: #{person.position.ljust(18)} salary: #{person.salary.to_s.ljust(13)} slack account: #{person.slack.ljust(20)} github account: #{person.github.ljust(20)}"
    end
  end

  def writing_to_csv
    CSV.open("employees.csv", "w") do |csv|
      csv << ["name", "phone", "address", "position", "salary", "slack", "github"]
      @personnel.each do |person|
        csv << [person.name, person.phone, person.address, person.position, person.salary, person.slack, person.github]
      end
    end
  end
end
database = Database.new

loop do
  puts "Welcome to The Iron Yard employee database! Press 'A' to add a person, 'S' to search for a person, and 'D' to delete someone. To see the employee report press 'E' Have fun! (if you want to leave just press enter.)"
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

  if user_input == "E"
    database.employee_reports
  end
end
