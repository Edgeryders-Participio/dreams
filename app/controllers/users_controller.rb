class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_lang_detector, only: [:show, :index, :me]

  def me
    # TODO: There's a possible regression here where this list may now display
    # Organization memberships as well.
    # I've written a relation which may be able to replace it cleanly in user.rb#18,
    # so you could start off with seeing if something like the following works:

    @memberships = current_user.collaborators.distinct.pluck(:email) - Array(current_user.email)
  end

  def show
    @user = User.find(params[:id])
  end

  def load_lang_detector
    @detector = StringDirection::Detector.new(:dominant)
  end
end
