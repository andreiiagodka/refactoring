# frozen_string_literal: true

module Database
  ACCOUNTS_FILE_NAME = 'accounts'
  YML_FORMAT = '.yml'
  STORAGE_YML = ACCOUNTS_FILE_NAME + YML_FORMAT

  def save_to_db(entity)
    File.open(STORAGE_YML, 'a') { |file| file.write self.to_yaml }
  end

  def load_from_db
    File.exists?(STORAGE_YML) ? YAML.load_stream(File.read(STORAGE_YML)) : []
  end
end
