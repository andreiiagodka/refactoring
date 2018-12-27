# frozen_string_literal: true

class Failing < LocaleHelper
  FAILING = 'failing'

  def wrong_command
    get_phrase(:wrong_command)
  end

  def invalid_name
    get_phrase(:invalid_name)
  end

  def invalid_age
    get_phrase(:invalid_age)
  end

  def empty_login
    get_phrase(:empty_login)
  end

  def login_length
    get_phrase(:login_length)
  end

  def account_exists
    get_phrase(:account_exists)
  end

  def empty_password
    get_phrase(:empty_password)
  end

  def password_length
    get_phrase(:password_length)
  end

  private

  def get_phrase(argument, *parameters)
    get(FAILING, argument, *parameters)
  end
end
