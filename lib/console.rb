# frozen_string_literal: true

require 'yaml'

class Console
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

  def initialize
    @errors = []
    @file_path = Account::ACCOUNTS_FILE_NAME + Account::YML_FORMAT
  end

  def console
    puts 'Hello, we are RubyG bank!'
    puts '- If you want to create account - press `create`'
    puts '- If you want to load account - press `load`'
    puts '- If you want to exit - press `exit`'

    case gets.chomp
    when CONSOLE_COMMANDS[:create] then Account.new.create
    when CONSOLE_COMMANDS[:load] then Account.new.load
    else exit
    end
  end

  def main_menu(current_account)
    loop do
      puts "\nWelcome, #{current_account.name}"
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
        Card.new.show_cards(current_account)
      when MAIN_MENU_COMMANDS[:cc]
        Card.new.create_card(current_account)
      when MAIN_MENU_COMMANDS[:dc]
        Card.new.destroy_card(current_account)
      when MAIN_MENU_COMMANDS[:pm]
        Money.new.put_money(current_account)
      when MAIN_MENU_COMMANDS[:wm]
        Money.new.withdraw_money(current_account)
      when MAIN_MENU_COMMANDS[:sm]
        Money.new.send_money(current_account)
      when MAIN_MENU_COMMANDS[:da]
        Account.new.destroy_account(current_account)
        exit
      when CONSOLE_COMMANDS[:exit]
        exit
        break
      else puts "Wrong command. Try again!\n"
      end
    end
  end
end
