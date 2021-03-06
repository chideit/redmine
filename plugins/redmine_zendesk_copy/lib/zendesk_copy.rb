ActiveResource::Base.logger = ActiveRecord::Base.logger

module Zendesk
  module Rest
    class Ticket < ActiveResource::Base
    end
  end
end


class ZendeskListener2 < Redmine::Hook::Listener
  # We need this helper for rendering the detail stuff, and the accessors to fake it out
  include IssuesHelper
  attr_accessor :controller, :request

  def model_issues_after_save(context)
    self.controller = context[:controller]
    self.request = context[:request]
    puts 'got here'
    custom_field = CustomField.find(Setting.plugin_redmine_zendesk_copy['field'])
    return unless custom_field
    puts '2'
    journal = context[:journal]
    return unless journal
    
    issue = context[:issue]
    puts issue
    puts issue.custom_value_for(custom_field)
    return unless issue && issue.custom_value_for(custom_field)
    puts '4'
    zendesk_id_value = issue.custom_value_for(custom_field)
    return unless zendesk_id_value
    puts '5'
    zendesk_ids = zendesk_id_value.to_s.split(/,\ ?/).map(&:strip)
    return if zendesk_ids.empty?
    
    Zendesk::Rest::Ticket.site = Setting.plugin_redmine_zendesk_copy['zendesk_url']
    Zendesk::Rest::Ticket.user = Setting.plugin_redmine_zendesk_copy['zendesk_username']
    Zendesk::Rest::Ticket.password = Setting.plugin_redmine_zendesk_copy['zendesk_password']
    
    zendesk_ids.each do |zendesk_id|
      issue_url = "#{Setting.plugin_redmine_zendesk_copy['redmine_url']}/issues/#{issue.id}"
      comment = "Redmine ticket #{issue_url} was updated by #{journal.user.name}:\n\n"
      
      for detail in journal.details
        comment << show_detail(detail, true) rescue ""
        comment << "\n"
      end
      
      if journal.notes && !journal.notes.empty?
        comment << journal.notes
      end
      
      ticket = Zendesk::Rest::Ticket.find(zendesk_id)
      if issue.closed?
        ticket.status = "open"
      end
      ticket.comment = { :public => false, :body => comment }
      ticket.exists?
      ticket.save rescue nil
      puts "ticket saved"
    end
  end
end
