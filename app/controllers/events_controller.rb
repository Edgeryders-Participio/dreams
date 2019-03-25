class EventsController < ApplicationController
  before_action :set_current_id, only: :current
  before_action :set_past_events, only: :past
  before_action :set_future_events, only: :future

  def show
    # TODO: We should provide an option on the events#show page to view
    # all past or future events, which will allow users to navigate to
    # events which are not the current one
    @event = Event.find(params[:id])
  end

  def current
    @event = Event.current
    render :show
  end

  def future
    @events = Event.future
    render :index
  end

  def past
    @events = Event.past
    render :index
  end

  private

  def set_current_id
    raise "No events created!" unless Event.current
    params[:id] = Event.current.id
  end

  def is_current?
    @event.id == Event.current.id
  end

  def set_past_events
    @events = Event.past
  end

  def set_future_events
    @events = Event.future
  end
end
