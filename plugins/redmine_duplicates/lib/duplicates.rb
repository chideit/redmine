require 'redmine'

class DuplicatesListener < Redmine::Hook::Listener
  # We need this helper for rendering the detail stuff, and the accessors to fake it out
  include IssuesHelper
  attr_accessor :controller, :request

  def controller_issues_edit_after_save(context)
    self.controller = context[:controller]
    self.request = context[:request]
    
    custom_field = CustomField.find(Setting.plugin_redmine_duplicates['field'])
    return unless custom_field
    
    journal = context[:journal]
    return unless journal
    
    issue = context[:issue]
    return unless issue && issue.custom_value_for(custom_field)
    
    duplicate_id_value = issue.custom_value_for(custom_field)
    return unless duplicate_id_value
    
    duplicate_ids = duplicate_id_value.to_s.split(/,\ ?/).map(&:strip)
    return if duplicate_ids.empty?
    
    duplicate_ids.each do |duplicate_id|
      comment = "Redmine ticket ##{issue.id} was marked as a duplicate of this ticket by #{journal.user.name}:\n\n"
      
      for detail in journal.details
        comment << show_detail(detail, true) rescue ""
        comment << "\n"
      end
      
      if journal.notes && !journal.notes.empty?
        comment << journal.notes
      end

      duplicate = Issue.find_by_id(duplicate_id)

      unless duplicate.nil?
        # the issue may have been updated by another module
        duplicate.reload

        j = duplicate.init_journal(journal.user, comment)
        unless duplicate.save
        end
      end
    end
  end
end
