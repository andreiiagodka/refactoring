# frozen_string_literal: true

class Account
  include Database

  attr_reader :login, :name, :password, :card

  COMMANDS = {
    create: 'create',
    load: 'load',
    exit: 'exit'
  }.freeze

  VALID_RANGES = {
    age: (23..90)
  }.freeze

  def initialize
    @errors = []
  end

  def create
    loop do
      @name = name_input
      @age = age_input
      @login = login_input
      @password = password_input
      break if @errors.length.zero?
      @errors.each { |e| puts e }
      @errors = []
    end

    save_to_db(self)
    Console.new.main_menu(self)
  end

  def load
    loop do
      return create_the_first_account if load_from_db.empty?

      puts 'Enter your login'
      login = gets.chomp
      puts 'Enter your password'
      password = gets.chomp

      if load_from_db.map { |a| { login: a.login, password: a.password } }.include?({ login: login, password: password })
        a = load_from_db.select { |a| login == a.login }.first
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
      load_from_db.each do |ac|
        if ac.login == current_account.login
        else
          new_accounts.push(ac)
        end
      end
      File.open(STORAGE_YML, 'w') { |f| f.write new_accounts.to_yaml } #Storing
      exit
    end
  end

  def accounts
    load_from_db
  end

  private

  def name_input
    output.enter_name
    validate_name(user_input)
  end

  def validate_name(name)
    @errors << failing.invalid_name if name.empty? || !first_in_uppercase?(name)
    name
  end

  def first_in_uppercase?(name)
    name.chars.first.upcase == name.chars.first
  end

  def age_input
    output.enter_age
    validate_age(user_input)
  end

  def validate_age(age)
    @errors << failing.invalid_age unless integer?(age) || age_in_range?(age)
    age.to_i
  end

  def integer?(age)
    age.to_i.to_s == age.to_i
  end

  def age_in_range?(age)
    VALID_RANGES[:age].include?(age.to_i)
  end

  def login_input
    output.enter_login
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

    if load_from_db.map { |a| a.login }.include? @login
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

  def user_input
    gets.chomp
  end

  def output
    @output ||= Output.new
  end

  def failing
    @failing ||= Failing.new
  end
end
