require 'ostruct'
require 'yaml'

config = YAML.load_file(File.join(Rails.root, 'config', 'app_config.yml')) || {}
app_config = OpenStruct.new(config[Rails.env] || {})