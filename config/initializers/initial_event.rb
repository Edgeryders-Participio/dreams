# TODO:
# Write an initializer which populates a default Event and Organization if one
# does not exist in the database. This will allow us to be backwards compatible
# with existing instances.

# Steps:
# Check to see if there are any events / organizations in the database

# If there are no events, create one based on the following ENV variables:
# - INITIAL_EVENT_NAME
# - INITIAL_EVENT_STARTS_AT (this should be an ISO-formatted date string)
# - INITIAL_EVENT_ENDS_AT (this should be an ISO-formatted date string)

# We'll want to pull the 'submission_deadline' and 'safety_deadline'
# from the existing 'lockdown.yml' file.

# Assign all existing camps and grants to the newly created event

# If there are no organizations, create one based on the following ENV variables:
# - INITIAL_ORGANIZATION_NAME

# Assign all existing events to the newly created organization
# Assign all admin users to the newly created organization, by creating memberships for them

# if defined?(Event) && defined?(Organization)
#     return unless Event.all.any? && Organization.all.any?
# 
#     lockdown_data = Rails.application.config_for(:lockdown)
#     name        = ENV['INITIAL_EVENT_NAME'] || ""
#     starts_at   = ENV['INITIAL_EVENT_STARTS_AT'] || ""
#     ends_at     = ENV['INITIAL_EVENT_ENDS_AT'] || ""
# 
#     raise "" if name.empty? or start_at.empty? or end
# end