# frozen_string_literal: true

require 'yaml'

class Account
  attr_accessor :login, :name, :card, :password, :file_path

  CONSOLE_COMMANDS = {
    create: 'create',
    load: 'load',
    exit: 'exit'
  }.freeze

  MAIN_MENU_COMMANDS = {
    sc: 'sc',
    cc: 'cc',
    dc: 'dc',
    pm: 'pm',
    wm: 'wm',
    sm: 'sm',
    da: 'da'
  }.freeze

  CARDS = {
    usual: {
      type: 'usual',
      number: 16.times.map{rand(10)}.join,
      balance: 50.00
    },
    capitalist: {
      type: 'capitalist',
      number: 16.times.map{rand(10)}.join,
      balance: 100.00
    },
    virtual: {
      type: 'virtual',
      number: 16.times.map{rand(10)}.join,
      balance: 150.00
    }
  }.freeze

  ACCOUNTS_FILE_NAME = 'accounts'
  YML_FORMAT = '.yml'

  def initialize
    @errors = []
    @file_path = ACCOUNTS_FILE_NAME + YML_FORMAT
  end

  def console
    puts 'Hello, we are RubyG bank!'
    puts '- If you want to create account - press `create`'
    puts '- If you want to load account - press `load`'
    puts '- If you want to exit - press `exit`'

    case gets.chomp
    when CONSOLE_COMMANDS[:create] then create
    when CONSOLE_COMMANDS[:load] then load
    else exit
    end
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
    main_menu
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
    main_menu
  end

  def create_the_first_account
    puts 'There is no active accounts, do you want to be the first?[y/n]'
    return gets.chomp == 'y' ? create : console
  end

  def main_menu
    loop do
      puts "\nWelcome, #{@current_account.name}"
      puts 'If you want to:'
      puts '- show all cards - press SC'
      puts '- create card - press CC'
      puts '- destroy card - press DC'
      puts '- put money on card - press PM'
      puts '- withdraw money on card - press WM'
      puts '- send money to another card  - press SM'
      puts '- destroy account - press `DA`'
      puts '- exit from account - press `exit`'

      case gets.chomp.downcase
      when MAIN_MENU_COMMANDS[:sc]
        show_cards
      when MAIN_MENU_COMMANDS[:cc]
        create_card
      when MAIN_MENU_COMMANDS[:dc]
        destroy_card
      when MAIN_MENU_COMMANDS[:pm]
        put_money
      when MAIN_MENU_COMMANDS[:wm]
        withdraw_money
      when MAIN_MENU_COMMANDS[:sm]
        send_money
      when MAIN_MENU_COMMANDS[:da]
        destroy_account
        exit
      when CONSOLE_COMMANDS[:exit]
        exit
        break
      else puts "Wrong command. Try again!\n"
      end
    end
  end

  def create_card
    loop do
      puts 'You could create one of 3 card types'
      puts '- Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card. 5% tax on WITHDRAWING money. For creation this card - press `usual`'
      puts '- Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card. 4$ tax on WITHDRAWING money. For creation this card - press `capitalist`'
      puts '- Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card. 12% tax on WITHDRAWING money. For creation this card - press `virtual`'
      puts '- For exit - press `exit`'

      card = case gets.chomp
      when CARDS[:usual][:type]
        CARDS[:usual]
      when CARDS[:capitalist][:type]
        CARDS[:capitalist]
      when CARDS[:virtual][:type]
        CARDS[:virtual]
      else puts "Wrong card type. Try again!\n"
      end

      if card
        cards = @current_account.card << card
        @current_account.card = cards #important!!!
        new_accounts = []
        accounts.each { |ac| ac.login == @current_account.login ? new_accounts.push(@current_account) : new_accounts.push(ac) }
        File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } #Storing
        break
      end
    end
  end

  def destroy_card
    loop do
      if @current_account.card.any?
        puts 'If you want to delete:'

        @current_account.card.each_with_index { |c, i| puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}" }
        puts "press `exit` to exit\n"
        answer = gets.chomp
        break if answer == 'exit'
        if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i > 0
          puts "Are you sure you want to delete #{@current_account.card[answer&.to_i.to_i - 1][:number]}?[y/n]"
          a2 = gets.chomp
          if a2 == 'y'
            @current_account.card.delete_at(answer&.to_i.to_i - 1)
            new_accounts = []
            accounts.each { |ac| ac.login == @current_account.login ? new_accounts.push(@current_account) : new_accounts.push(ac) }
            File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } #Storing
            break
          else
            return
          end
        else
          puts "You entered wrong number!\n"
        end
      else
        puts "There is no active cards!\n"
        break
      end
    end
  end

  def show_cards
    if @current_account.card.any?
      @current_account.card.each { |c| puts "- #{c[:number]}, #{c[:type]}" }
    else
      puts "There is no active cards!\n"
    end
  end

  def withdraw_money
    puts 'Choose the card for withdrawing:'
    answer, a2, a3 = nil #answers for gets.chomp
    if @current_account.card.any?
      @current_account.card.each_with_index do |c, i|
        puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}"
      end
      puts "press `exit` to exit\n"
      loop do
        answer = gets.chomp
        break if answer == 'exit'
        if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i > 0
          current_card = @current_account.card[answer&.to_i.to_i - 1]
          loop do
            puts 'Input the amount of money you want to withdraw'
            a2 = gets.chomp
            if a2&.to_i.to_i > 0
              money_left = current_card[:balance] - a2&.to_i.to_i - withdraw_tax(current_card[:type], current_card[:balance], current_card[:number], a2&.to_i.to_i)
              if money_left > 0
                current_card[:balance] = money_left
                @current_account.card[answer&.to_i.to_i - 1] = current_card
                new_accounts = []
                accounts.each { |ac| ac.login == @current_account.login ? new_accounts.push(@current_account) : new_accounts.push(ac) }
                File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } #Storing
                puts "Money #{a2&.to_i.to_i} withdrawed from #{current_card[:number]}$. Money left: #{current_card[:balance]}$. Tax: #{withdraw_tax(current_card[:type], current_card[:balance], current_card[:number], a2&.to_i.to_i)}$"
                return
              else
                puts "You don't have enough money on card for such operation"
                return
              end
            else
              puts 'You must input correct amount of $'
              return
            end
          end
        else
          puts "You entered wrong number!\n"
          return
        end
      end
    else
      puts "There is no active cards!\n"
    end
  end

  def put_money
    puts 'Choose the card for putting:'

    if @current_account.card.any?
      @current_account.card.each_with_index { |c, i| puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}" }
      puts "press `exit` to exit\n"
      loop do
        answer = gets.chomp
        break if answer == 'exit'
        if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i > 0
          current_card = @current_account.card[answer&.to_i.to_i - 1]
          loop do
            puts 'Input the amount of money you want to put on your card'
            a2 = gets.chomp
            if a2&.to_i.to_i > 0
              if put_tax(current_card[:type], current_card[:balance], current_card[:number], a2&.to_i.to_i) >= a2&.to_i.to_i
                puts 'Your tax is higher than input amount'
                return
              else
                new_money_amount = current_card[:balance] + a2&.to_i.to_i - put_tax(current_card[:type], current_card[:balance], current_card[:number], a2&.to_i.to_i)
                current_card[:balance] = new_money_amount
                @current_account.card[answer&.to_i.to_i - 1] = current_card
                new_accounts = []
                accounts.each { |ac| ac.login == @current_account.login ? new_accounts.push(@current_account) : new_accounts.push(ac) }
                File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } #Storing
                puts "Money #{a2&.to_i.to_i} was put on #{current_card[:number]}. Balance: #{current_card[:balance]}. Tax: #{put_tax(current_card[:type], current_card[:balance], current_card[:number], a2&.to_i.to_i)}"
                return
              end
            else
              puts 'You must input correct amount of money'
              return
            end
          end
        else
          puts "You entered wrong number!\n"
          return
        end
      end
    else
      puts "There is no active cards!\n"
    end
  end

  def send_money
    puts 'Choose the card for sending:'

    if @current_account.card.any?
      @current_account.card.each_with_index { |c, i| puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}" }
      puts "press `exit` to exit\n"
      answer = gets.chomp
      exit if answer == 'exit'
      if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i > 0
        sender_card = @current_account.card[answer&.to_i.to_i - 1]
      else
        puts 'Choose correct card'
        return
      end
    else
      puts "There is no active cards!\n"
      return
    end

    puts 'Enter the recipient card:'
    a2 = gets.chomp
    if a2.length > 15 && a2.length < 17
      all_cards = accounts.map(&:card).flatten
      if all_cards.select { |card| card[:number] == a2 }.any?
        recipient_card = all_cards.select { |card| card[:number] == a2 }.first
      else
        puts "There is no card with number #{a2}\n"
        return
      end
    else
      puts 'Please, input correct number of card'
      return
    end

    loop do
      puts 'Input the amount of money you want to withdraw'
      a3 = gets.chomp
      if a3&.to_i.to_i > 0
        sender_balance = sender_card[:balance] - a3&.to_i.to_i - sender_tax(sender_card[:type], sender_card[:balance], sender_card[:number], a3&.to_i.to_i)
        recipient_balance = recipient_card[:balance] + a3&.to_i.to_i - put_tax(recipient_card[:type], recipient_card[:balance], recipient_card[:number], a3&.to_i.to_i)

        if sender_balance < 0
          puts "You don't have enough money on card for such operation"
        elsif put_tax(recipient_card[:type], recipient_card[:balance], recipient_card[:number], a3&.to_i.to_i) >= a3&.to_i.to_i
          puts 'There is no enough money on sender card'
        else
          sender_card[:balance] = sender_balance
          @current_account.card[answer&.to_i.to_i - 1] = sender_card
          new_accounts = []
          accounts.each do |ac|
            if ac.login == @current_account.login
              new_accounts.push(@current_account)
            elsif ac.card.map { |card| card[:number] }.include? a2
              recipient = ac
              new_recipient_cards = []
              recipient.card.each do |card|
                if card[:number] == a2
                  card[:balance] = recipient_balance
                end
                new_recipient_cards.push(card)
              end
              recipient.card = new_recipient_cards
              new_accounts.push(recipient)
            end
          end
          File.open('accounts.yml', 'w') { |f| f.write new_accounts.to_yaml } #Storing
          puts "Money #{a3&.to_i.to_i}$ was put on #{sender_card[:number]}. Balance: #{recipient_balance}. Tax: #{put_tax(sender_card[:type], sender_card[:balance], sender_card[:number], a3&.to_i.to_i)}$\n"
          puts "Money #{a3&.to_i.to_i}$ was put on #{a2}. Balance: #{sender_balance}. Tax: #{sender_tax(sender_card[:type], sender_card[:balance], sender_card[:number], a3&.to_i.to_i)}$\n"
          break
        end
      else
        puts 'You entered wrong number!\n'
      end
    end
  end

  def destroy_account
    puts 'Are you sure you want to destroy account?[y/n]'
    a = gets.chomp
    if a == 'y'
      new_accounts = []
      accounts.each do |ac|
        if ac.login == @current_account.login
        else
          new_accounts.push(ac)
        end
      end
      File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } #Storing
    end
  end

  private

  def name_input
    puts 'Enter your name'
    @name = gets.chomp
    if @name == '' || @name[0].upcase != @name[0]
      @errors.push('Your name must not be empty and starts with first upcase letter')
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

  def age_input
    puts 'Enter your age'
    @age = gets.chomp
    if @age.to_i.is_a?(Integer) && @age.to_i >= 23 && @age.to_i <= 90
      @age = @age.to_i
    else
      @errors.push('Your Age must be greeter then 23 and lower then 90')
    end
  end

  def accounts
    File.exists?(@file_path) ? YAML.load_file(@file_path) : []
  end

  def withdraw_tax(type, balance, number, amount)
    case type
    when CARDS[:usual][:type] then amount * 0.05
    when CARDS[:capitalist][:type] then amount * 0.04
    when CARDS[:virtual][:type] then amount * 0.88
    else 0
    end
  end

  def put_tax(type, balance, number, amount)
    case type
    when CARDS[:usual][:type] then amount * 0.02
    when CARDS[:capitalist][:type] then 10
    when CARDS[:virtual][:type] then 1
    else 0
    end
  end

  def sender_tax(type, balance, number, amount)
    case type
    when CARDS[:usual][:type] then 20
    when CARDS[:capitalist][:type] then amount * 0.1
    when CARDS[:virtual][:type] then 1
    else 0
    end
  end
end
