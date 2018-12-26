# frozen_string_literal: true

LOCALES_DIR = 'locales'
EN_FILE = 'en'
YML_FORMAT = '.yml'

I18n.load_path << Dir[File.expand_path(LOCALES_DIR) + '/' + EN_FILE + YML_FORMAT]
