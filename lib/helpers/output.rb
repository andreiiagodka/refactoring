# frozen_string_literal: true

class Output < I18nHelper
  OUTPUT = 'output'

  def show(argument)
    puts argument
  end

  def greeting
    show_in_console(:greeting)
  end

  def account_options
    show_in_console(:account_options,
                    create: Account::COMMANDS[:create],
                    load: Account::COMMANDS[:load],
                    exit: Account::COMMANDS[:exit])
  end

  def main_menu_options(account)
    commands = upcase_hash_values(Console::COMMANDS)
    show_in_console(:main_menu_options,
                    name: account.name,
                    sc: commands[:sc],
                    cc: commands[:cc],
                    dc: commands[:dc],
                    pm: commands[:pm],
                    wm: commands[:wm],
                    sm: commands[:sm],
                    da: commands[:da],
                    exit: Account::COMMANDS[:exit])
  end

  private

  def show_in_console(argument, *parameters)
    show(
      get(OUTPUT, argument, *parameters)
    )
  end

  def upcase_hash_values(hash)
    hash.transform_values(&:upcase)
  end
end
