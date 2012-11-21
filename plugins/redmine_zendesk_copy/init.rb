# Redmine sample plugin
require 'zendesk_copy'
::Rails.logger.info 'Zendesk integration2'

Redmine::Plugin.register :redmine_zendesk_copy do
  name 'Zendesk plugin (copy)'
  author 'Amin Mirzaee'
  description 'Updates associated Zendesk tickets when Redmine issues are updated (copy for second project)'
  version '0.1'
  settings :default => {
      'zendesk_url' => 'https://support.zendesk.com/api/v2/',
      'zendesk_username' => 'zendeskuser',
      'zendesk_password' => 'zendeskpassword',
      'field' => nil,
      'redmine_url' => 'https://your.redmine.url/'
    },
    :partial => 'settings/redmine_zendesk_copy_settings'
end
