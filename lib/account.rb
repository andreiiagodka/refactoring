# frozen_string_literal: true

class Account
  attr_reader :login, :name, :password, :card, :file_path

  ACCOUNTS_FILE_NAME = 'accounts'
  YML_FORMAT = '.yml'

  def initialize
    @errors = []
    @file_path = ACCOUNTS_FILE_NAME + YML_FORMAT
  end

  def create
    loop do
      name_input
      age_input
      login_input
      password_input
      break if @errors.length.zero?
      @errors.each { |e| puts e }
      @errors = []
    end

    @card = []
    new_accounts = accounts << self
    @current_account = self
    File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml }
    Console.new.main_menu(@current_account)
  end

  def load
    loop do
      return create_the_first_account if accounts.empty?

      puts 'Enter your login'
      login = gets.chomp
      puts 'Enter your password'
      password = gets.chomp

      if accounts.map { |a| { login: a.login, password: a.password } }.include?({ login: login, password: password })
        a = accounts.select { |a| login == a.login }.first
        @current_account = a
        break
      else
        puts 'There is no account with given credentials'
        next
      end
    end
    Console.new.main_menu(@current_account)
  end

  def destroy_account(current_account)
    puts 'Are you sure you want to destroy account?[y/n]'
    a = gets.chomp
    if a == 'y'
      new_accounts = []
      accounts.each do |ac|
        if ac.login == current_account.login
        else
          new_accounts.push(ac)
        end
      end
      File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } #Storing
    end
  end

  def accounts
    File.exists?(@file_path) ? YAML.load_file(@file_path) : []
  end

  private

  def name_input
    puts 'Enter your name'
    @name = gets.chomp
    if @name == '' || @name[0].upcase != @name[0]
      @errors.push('Your name must not be empty and starts with first upcase letter')
    end
  end

  def age_input
    puts 'Enter your age'
    @age = gets.chomp
    if @age.to_i.is_a?(Integer) && @age.to_i >= 23 && @age.to_i <= 90
      @age = @age.to_i
    else
      @errors.push('Your Age must be greeter then 23 and lower then 90')
    end
  end

  def login_input
    puts 'Enter your login'
    @login = gets.chomp
    if @login == ''
      @errors.push('Login must present')
    end

    if @login.length < 4
      @errors.push('Login must be longer then 4 symbols')
    end

    if @login.length > 20
      @errors.push('Login must be shorter then 20 symbols')
    end

    if accounts.map { |a| a.login }.include? @login
      @errors.push('Such account is already exists')
    end
  end

  def password_input
    puts 'Enter your password'
    @password = gets.chomp
    if @password == ''
      @errors.push('Password must present')
    end

    if @password.length < 6
      @errors.push('Password must be longer then 6 symbols')
    end

    if @password.length > 30
      @errors.push('Password must be shorter then 30 symbols')
    end
  end

  def create_the_first_account
    puts 'There is no active accounts, do you want to be the first?[y/n]'
    return gets.chomp == 'y' ? create : Console.new.console
  end
end
