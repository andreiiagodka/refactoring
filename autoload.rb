# frozen_string_literal: true

require 'pry'
require 'yaml'
require 'i18n'

require_relative 'i18n_config'

require_relative 'lib/helpers/locale_helper'
require_relative 'lib/helpers/output'
require_relative 'lib/helpers/failing'

require_relative 'lib/modules/database'

require_relative 'lib/entities/account'
require_relative 'lib/entities/card'
require_relative 'lib/entities/money'
require_relative 'lib/entities/console'
