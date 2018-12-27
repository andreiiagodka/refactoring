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

  private

  def get_phrase(argument, *parameters)
    get(FAILING, argument, *parameters)
  end
end
