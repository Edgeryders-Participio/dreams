class GuideviewController < ApplicationController
  include CanApplyFilters
  before_action :apply_filters, only: :index
  before_action :load_lang_detector, only: [:show, :index]

  def index
    @camps = Camp.all.page().per(1000)
  end

  private

  def load_lang_detector
    @detector = StringDirection::Detector.new(:dominant)
  end
end
