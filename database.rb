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
      name = row["name"]
      phone_number = row["phone"]
      address = row["address"]
      position = row["position"]
      salary = row["salary"]
      slack_account = row["slack"]
      github_account = row["github"]

      person = People.new(name, phone_number, address, position, salary.to_i, slack_account, github_account)

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
        phone_number = gets.chomp

        puts "What is #{name}'s address?"
        address = gets.chomp

        puts "What is #{name}'s position in the company?"
        position = gets.chomp

        puts "What is #{name}'s salary?"
        salary = gets.chomp.to_i

        puts "What is #{name}'s slack account?"
        slack_account = gets.chomp

        puts "What is #{name}'s github account?"
        github_account = gets.chomp

        puts "Thank you for the addition!"

        person = People.new(name, phone_number, address, position, salary.to_i, slack_account, github_account)

        @personnel << person

        writing_to_csv
      end
    end
  end

  def searching_people
    puts "Who would you like to search for? You can search for their name, Slack name or Github account."
    search = gets.chomp

    found_person = @personnel.find {|person| person.name.include?(search) || person.slack_account == search || person.github_account == search}

    if found_person
      puts "You searched for #{found_person.name}."
      puts "their phone number is #{found_person.phone_number}."
      puts "Their address is #{found_person.address}."
      puts "They are the/a #{found_person.position}."
      puts "Their salary is #{found_person.salary}."
      puts "They can be found on the internet at (slack) #{found_person.slack_account} and github.com/#{found_person.github_account}."
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
      writing_to_csv
    else
      puts "That person doesn't exist. Would you like to add them?"
    end
  end

  def employee_reports
    employee_list_display
    puts "the total salary of the instructors is #{total_salary_instructor}"
    puts "the total salary of the directors is #{total_salary_director}"
    puts "the number of instructors is #{total_number_instructor}"
    puts "the number of directors is #{total_number_director}"
    puts "the number of students is #{total_number_student}"
  end

  def employee_list_display
    sorted_employee_list = @personnel.sort_by{ |person| person.name }
    puts "Here is a list of everyone we have working here"
    sorted_employee_list.each do |person|
      puts "name: #{person.name}, phone number: #{person.phone_number}, address: #{person.address}, position: #{person.position}, salary: #{person.salary}, slack account: #{person.slack_account}, github account: #{person.github_account}"
    end
  end

  def total_salary_instructor
    @personnel.select { |person| person.position.include?("Instructor") }.map { |person| person.salary }.sum
  end

  def total_salary_director
    @personnel.select { |person| person.position.include?("Director") }.map { |person| person.salary}.sum
  end

  def total_number_instructor
    @personnel.select { |person| person.position.include?("Instructor") }.count
  end

  def total_number_director
    @personnel.select { |person| person.position.include?("Director") }.count
  end

  def total_number_student
    @personnel.select { |person| person.position.include?("Student") }.count
  end

  def writing_to_csv
    CSV.open("employees.csv", "w") do |csv|
      csv << ["name", "phone_number", "address", "position", "salary", "slack_account", "github_account"]
      @personnel.each do |person|
          csv << [person.name, person.phone_number, person.address, person.position, person.salary, person.slack_account, person.github_account]
      end
    end
  end

end
database = Database.new

loop do
  puts "Welcome to The Iron Yard employee database! Press 'A' to add a, 'S' to search for a person, and 'D' to delete someone. To see the employee report press 'E' Have fun! (if you want to leave just press enter.)"
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
