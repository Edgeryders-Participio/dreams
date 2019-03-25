class OrganizationsController < ApplicationController
  def show
    # TODO: More than likely you'll want to create a view of an organization,
    # which displays the name of the org and perhaps lists the events they've done
    # That goes here!

    # This will likely eventually look like an 'About the organization' page, which
    # is visible to the public and provides additional info about the org to anyone
    # who signs up

    @organization = Organization.find(params[:id])
  end
end
