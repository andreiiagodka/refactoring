# frozen_string_literal: true

class LocaleHelper
  def get(section, argument, *parameters)
    string_argument = argument.to_s
    I18n.t("#{section}.#{string_argument}", *parameters)
  end
end
