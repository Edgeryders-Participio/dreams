class CampsController < ApplicationController
  include CanApplyFilters
  before_action :apply_filters, only: :index
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_camp!, except: [:index, :new, :create]
  before_action :ensure_admin_delete!, only: [:destroy, :archive]
  before_action :ensure_admin_tag!, only: [:tag]
  before_action :ensure_admin_update!, only: [:update]
  before_action :ensure_grants!, only: [:update_grants]
  before_action :load_lang_detector, only: [:show, :index]
  before_action :load_event

  def index
  end

  def new
    @camp = Camp.new
    @camp.event = @event
  end

  def edit
    @just_view = params[:just_view]
  end

  def create
    @camp = Camp.new(camp_params.merge(creator: current_user))

    if create_camp
      flash[:notice] = t('created_new_dream')
      redirect_to edit_event_camp_path(@event, @camp)
    else
      flash.now[:notice] = "#{t:errors_str}: #{@camp.errors.full_messages.uniq.join(', ')}"
      render :new
    end
  end

  # Toggle granting

  def toggle_granting
    @camp.toggle!(:grantingtoggle)
    redirect_to event_camp_path(@event, @camp)
  end

  def update_grants
    @camp.grants.build(user: current_user, amount: granted)
    @camp.assign_attributes(
      minfunded:   (@camp.grants_received + granted) >= @camp.minbudget,
      fullyfunded: (@camp.grants_received + granted) >= @camp.maxbudget
    )

    if @camp.save
      current_user.update(grants: current_user.grants - granted)
      flash[:notice] = t(:thanks_for_sending, grants: granted)
    else
      flash[:error] = t(:errors_str, message: @camp.errors.full_messages.uniq.join(', '))
    end

    redirect_to event_camp_path(@event, @camp)
  end

  def update
    if @camp.update_attributes camp_params
      if params[:done] == '1'
        redirect_to event_camp_path(@event, @camp)
      elsif params[:safetysave] == '1'
        puts(event_camp_safety_sketches_path(@event, @camp))
        redirect_to event_camp_safety_sketches_path(@event, @camp)
      else
        respond_to do |format|
          format.html { redirect_to edit_event_camp_path(@event, @camp) }
          format.json { respond_with_bip(@camp) }
        end
      end
    else
      flash.now[:alert] = t(:errors_str, message: @camp.errors.full_messages.uniq.join(', '))
      respond_to do |format|
        format.html { render action: :edit }
        format.json { respond_with_bip(@camp) }
      end
    end
  end

  def tag
    @camp.update_attributes(tag_list: params.require(:camp).require(:tag_list))

    flash[:notice] = t(:tags_saved)
    redirect_to event_camp_path(@event, @camp)
  end

  def destroy
    @camp.destroy!
    redirect_to event_camps_path(@event)
  end

  # Display a camp and its users
  def show
    @main_image = @camp.images.first&.attachment&.url(:large)
  end

  # Allow a user to join a particular camp.
  def join
    if !current_user
      flash[:notice] = t(:join_dream)
    elsif @camp.users.include?(current_user)
      flash[:notice] = t(:join_already_sent)
    else
      flash[:notice] = t(:join_dream)
      @camp.users << @user
    end
    redirect_to @camp
  end

  def toggle_favorite
    if !current_user
      flash[:notice] = "please log in :)"
    elsif @camp.favorite_users.include?(current_user)
      @camp.favorite_users.delete(current_user)
      render json: {res: :ok}, status: 200
    else
      @camp.favorite_users << current_user
      render json: {res: :ok}, status: 200
    end
  end

  def archive
    @camp.update!(active: false)
    redirect_to event_camps_path(@event)
  end

  private

  def load_event
    @event = Event.find_by(slug: params[:event_slug])
    if @event.nil?
      redirect_to Event.most_relevant
    end
  end

  # TODO: We can't permit! attributes like this, because it means that anyone
  # can update anything about a camp in any way (including the id, etc); recipe for disaster!
  # we'll have to go through and determine which attributes can actually be updated via
  # this endpoint and pass them to permit normally.
  def camp_params
    params.require(:camp).permit!
  end

  def load_camp!
    return if @camp = Camp.find_by(params.permit(:id))
    flash[:alert] = t(:dream_not_found)
    redirect_to event_camps_path(@event)
  end

  def ensure_admin_delete!
    assert(current_user == @camp.creator || current_user.admin, :security_cant_delete_dreams_you_dont_own)
  end

  def ensure_admin_tag!
    assert(current_user.admin || current_user.guide, :security_cant_tag_dreams_you_dont_own)
  end

  def ensure_admin_update!
    assert(@camp.creator == current_user || current_user.admin || current_user.guide, :security_cant_edit_dreams_you_dont_own)
  end

  def ensure_grants!
    assert(@camp.maxbudget, :dream_need_to_have_max_budget) ||
    assert(current_user.grants >= granted, :security_more_grants, granted: granted, current_user_grants: current_user.grants) ||
    assert(granted > 0, :cant_send_less_then_one) ||
    assert(
      current_user.admin || (@camp.grants.where(user: current_user).sum(:amount) + granted <= app_setting('max_grants_per_user_per_dream')),
      :exceeds_max_grants_per_user_for_this_dream,
      max_grants_per_user_per_dream: app_setting('max_grants_per_user_per_dream')
    )
  end

  def granted
    @granted ||= [params[:grants].to_i, @camp.maxbudget - @camp.grants_received].min
  end

  def failure_path
    event_camp_path(@event, @camp)
  end

  def create_camp
    Camp.transaction do
      @camp.save!
      if app_setting('google_drive_integration') and ENV['GOOGLE_APPS_SCRIPT'].present?
        response = NewDreamAppsScript::createNewDreamFolder(@camp.creator.email, @camp.id, @camp.name)
        @camp.google_drive_folder_path = response['id']
        @camp.google_drive_budget_file_path = response['budget']
        @camp.save!
      end
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def load_lang_detector
    @detector = StringDirection::Detector.new(:dominant)
  end
end
