# Redmine sample plugin
require 'redmine'
require File.dirname(__FILE__) + '/lib/duplicates'

::Rails.logger.info 'Duplicate Status Updater'

Redmine::Plugin.register :redmine_duplicates do
  name 'Duplicates plugin'
  author 'Amin Mirzaee'
  description 'Updates associated Redmine tickets with their duplicates when updated'
  version '0.1'
  settings :default => {
      'field' => nil,
    },
    :partial => 'settings/duplicates_plugin_settings'
end
