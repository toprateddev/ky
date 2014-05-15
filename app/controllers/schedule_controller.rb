class ScheduleController < ApplicationController

  before_action :authenticate_user!

  def show
    @events = []
    max_date = params[:end] ? Time.new(params[:end]) : Time.now + 3.years
    puts events.count
    events.each do |event|
      if event.recurring_rule == IceCube::SingleOccurrenceRule
        @events << event
      else
        schedule = event.schedule
        schedule.each_occurrence do |date|
          break if date > max_date or date > event.end_at
          fake_event = event.dup
          fake_event.parent_id = event.id
          fake_event.start_at = date
          if event.all_day?
            fake_event.end_at = date
          else
            fake_event.end_at = event.start_at
            fake_event.end_at_minutes = event.end_at_minutes
            fake_event.end_am_pm =event.end_am_pm
          end
          @events << fake_event
        end
      end
    end
    render layout: false
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit!
  end

  def find_event
    begin
      current_user.events.find params[:id]
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end

  def events
    calendar_events areas_events(categories_events(current_user.published_events))
  end

  def categories_events(e)
    return e.where(:category_ids.in => categories_ids) if categories_ids
    e
  end

  def areas_events(e)
    return e.where(:area_ids.in => areas_ids) if areas_ids
    e
  end

  def calendar_events(e)
    return e.where(:calendar_ids.in => [calendar_id]) if calendar_id
    e
  end

  def calendar
    begin
      current_user.calendars.find calendar_id
    rescue Mongoid::Errors::InvalidFind
      nil
    end
  end

  def calendar_id
    params[:calendar_id]
  end

  def areas_ids
    params[:areas_ids]
  end

  def categories_ids
    result = params[:categories_ids]
    result
  end

  def categories
    return false unless (categories_ids and calendar_id)
    current_user.categories.find(categories_ids)
  end

end
