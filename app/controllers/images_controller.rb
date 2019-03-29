class ImagesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_image!, only: :create
  before_action :load_camp!

  def index
  end

  def create
    if Image.create(image_params)
      redirect_to event_camp_images_path(@event, @camp)
    else
      render action: :index
    end
  end

  def destroy
    @camp.images.find(params[:id]).destroy!
    redirect_to event_camp_images_path(@event, @camp)
  end

  private

  def load_camp!
    @event = Event.find(params[:event_id])
    not_found if @event.nil? if @event.nil?
    
    @camp = Camp.includes(:event).find(params[:camp_id])
    redirect_to event_camps_path(@event) if @camp.nil? or @camp.event.id != @event.id

    assert(current_user == @camp.creator || current_user.admin, :security_cant_change_images_you_dont_own)
  end

  def ensure_image!
    assert(params[:attachment], :error_no_image_selected)
  end

  def failure_path
    event_camp_images_path(@event, @camp)
  end

  def image_params
    params.permit(:attachment, :camp_id).merge(user_id: current_user.id)
  end
end
