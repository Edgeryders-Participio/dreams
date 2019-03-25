ActiveAdmin.register Membership do
  actions :index, :show, :new, :create, :edit, :update
  permit_params :user_id, :collective_id, :collective_type

  # TODO: currently this doesn't quite work to create memberships the way we'd like
  # A first pass solution might be to have a dropdown of users by email
  # and a dropdown of all Camps and Organizations combined, so that you can choose
  # who to put in what collective.

  # SUPER ROUGH mockup might be:
  # New Membership
  # --------------

  #   User
  #   ----
  #   Hugi (hugi@borderlands.se)
  #   Kristoffer (kris@borderlands.se)

  #   Collective
  #   ----------
  #   West World (organization)
  #   East World (organization)
  #   Sea Snugs (camp)
  #   Health + Safety wizards (camp)

  # You should be able to find a way to modify the display_name of a model in the ActiveAdmin docs

  # ALTERNATIVELY: you could create two dashboards here,
  # (maybe admin/camp_memberships.rb and admin/organization_memberships.rb)
  # one for adding people to organizations, and another for adding them to camps.

  # A THIRD OPTION: Skip being able to add Camp memberships here
  # (that works in the app anyway), and simply make this form
  # able to add memberships to organizations
end
