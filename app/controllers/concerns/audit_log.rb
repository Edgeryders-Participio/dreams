module AuditLog
  include ActiveSupport::Concern

  def audit_log(entry_type, description=nil, object=nil, user=current_user)
    LogEntry.create!(entry_type: entry_type,
                    description: description,
                    user: user,
                    object: object)
  end
end
