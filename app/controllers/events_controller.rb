class EventsController < ApplicationController
  def index
    @events = Event.all.order(starts_at: :desc)
  end

  def show
    # TODO: We should provide an option on the events#show page to view
    # all past or future events, which will allow users to navigate to
    # events which are not the current one
    @event = Event.find_by(slug: params[:slug])
    redirect_to events_path if @event.nil?
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

  def redirect_to_most_relevant
    e = Event.most_relevant
    unless e.nil?
      redirect_to event_camps_path(event_slug: e.slug)
    else
        redirect_to events_path
    end
  end
end
