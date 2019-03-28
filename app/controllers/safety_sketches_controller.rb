class SafetySketchesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_image!, only: :create
  before_action :load_camp!

  def index
  end

  def create
    if SafetySketch.create(image_params)
      redirect_to camp_safety_sketches_path(@camp.id)
    else
      render action: :index
    end
  end

  def destroy
    @camp.safety_sketches.find(params[:id]).destroy!
    redirect_to camp_safety_sketches_path(@camp.id)
  end

  private

  def load_camp!
    @camp = Camp.find(params[:camp_id])
    assert(current_user == @camp.creator || current_user.admin, :security_cant_change_images_you_dont_own)
  end

  def ensure_image!
    assert(params[:attachment], :error_no_image_selected)
  end

  def failure_path
    camp_safety_sketches_path(@camp.id)
  end

  def image_params
    params.permit(:attachment, :camp_id).merge(user_id: current_user.id)
  end
end
