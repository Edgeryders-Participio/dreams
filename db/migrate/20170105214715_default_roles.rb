class DefaultRoles < ActiveRecord::Migration
  def change
    # Skip this migration as roles yml no longer in repo
    #Rails.application.config_for(:roles)['available_roles'].each do |r|
    #  Role.create!(identifier: r)
    #end
  end
end
