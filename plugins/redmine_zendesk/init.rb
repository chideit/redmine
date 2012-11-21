# Redmine sample plugin
require 'zendesk'
::Rails.logger.info 'Zendesk integration'

Redmine::Plugin.register :redmine_zendesk do
  name 'Zendesk plugin'
  author 'Amin Mirzaee'
  description 'Updates associated Zendesk tickets when Redmine issues are updated'
  version '0.1'
  settings :default => {
      'zendesk_url' => 'https://support.zendesk.com/api/v2/',
      'zendesk_username' => 'zendeskuser',
      'zendesk_password' => 'zendeskpassword',
      'field' => nil,
      'redmine_url' => 'https://your.redmine.url/'
    },
    :partial => 'settings/redmine_zendesk_settings'
end
