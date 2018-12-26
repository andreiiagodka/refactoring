# frozen_string_literal: true

class Console
  COMMANDS = {
    sc: 'sc',
    cc: 'cc',
    dc: 'dc',
    pm: 'pm',
    wm: 'wm',
    sm: 'sm',
    da: 'da'
  }.freeze

  def greeting
    output.greeting
    account_options
  end

  def main_menu(current_account)
    loop do
      output.main_menu_options(current_account)
      case user_input
      when COMMANDS[:sc] then card.show_cards(current_account)
      when COMMANDS[:cc] then card.create_card(current_account)
      when COMMANDS[:dc] then card.destroy_card(current_account)
      when COMMANDS[:pm] then money.put_money(current_account)
      when COMMANDS[:wm] then money.withdraw_money(current_account)
      when COMMANDS[:sm] then money.send_money(current_account)
      when COMMANDS[:da] then account.destroy_account(current_account)
      else output.show(failing.wrong_command)
      end
    end
  end

  private

  def account_options
    loop do
      output.account_options
      case user_input
      when Account::COMMANDS[:create] then account.create
      when Account::COMMANDS[:load] then account.load
      else output.show(failing.wrong_command)
      end
    end
  end

  def user_input
    input_value = gets.chomp.downcase
    exit?(input_value) ? exit : input_value
  end

  def exit?(input_value)
    input_value == Account::COMMANDS[:exit]
  end

  def account
    @account ||= Account.new
  end

  def card
    @card ||= Card.new
  end

  def money
    @money ||= Money.new
  end

  def output
    @output ||= Output.new
  end

  def failing
    @failing ||= Failing.new
  end
end
