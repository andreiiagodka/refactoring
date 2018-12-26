# frozen_string_literal: true

class Failing < I18nHelper
  FAILING = 'failing'

  def wrong_command
    get_phrase(:wrong_command)
  end

  private

  def get_phrase(argument, *parameters)
    get(FAILING, argument, *parameters)
  end
end
