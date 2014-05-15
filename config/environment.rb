# Load the rails application
require File.expand_path('../application', __FILE__)
require 'carrierwave/orm/activerecord'
#↓テンプレートのコンパイル関連,危険
#require 'danger_patch'
require 'app_core_extensions'
require 'csv'
#require 'cgiext'
# Initialize the rails application
Icms::Application.initialize!
#↑の後に↓をロードしないと適用されない
require 'danger_patch'