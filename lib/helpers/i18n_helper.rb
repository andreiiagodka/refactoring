# frozen_string_literal: true

class I18nHelper
  def get(section, argument, *parameters)
    string_argument = argument.to_s
    I18n.t("#{section}.#{string_argument}", *parameters)
  end
end
