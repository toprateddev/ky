class EventsController < ApplicationController
  require 'csv'
  before_action :authenticate_user!

  before_action :is_author?, only: [:destroy, :update]
  before_action :find_event, only: [:show, :update, :edit, :destroy]

  def index
    @events = current_user.events
  end

  def all_locations
    respond_to do |f|
      f.json { render json: Event.all.map { |x| x.location }.delete_if { |y| y.nil? or y=='' }.to_json }
    end
  end

  def all_addresses
    respond_to do |f|
      f.json { render json: Event.all.map { |x| x.address }.delete_if { |y| y.nil? or y=='' }.to_json }
    end
  end

  def all_cities
    respond_to do |f|
      f.json { render json: Event.all.map { |x| x.city }.delete_if { |y| y.nil? or y=='' }.to_json }
    end
  end

  def all_states
    respond_to do |f|
      f.json { render json: Event.all.map { |x| x.state }.delete_if { |y| y.nil? or y=='' }.to_json }
    end
  end

  def all_phones
    respond_to do |f|
      f.json { render json: Event.all.map { |x| x.phone }.delete_if { |y| y.nil? or y=='' }.to_json }
    end
  end

  def all_urls
    respond_to do |f|
      f.json { render json: Event.all.map { |x| x.link }.delete_if { |y| y.nil? or y=='' }.to_json }
    end
  end

  def to_boolean(str)
    return '1' if str.match /^true$/i
    '0'
  end

  def new_csv
    render :csv_to_events
  end

  def csv_to_events
    calendar = Calendar.find(params[:calendar_id])
    
    CSV.foreach(params[:file].path, :headers => true) do |row|
      start_time, end_time = DateTime.strptime(row[2],'%H:%M:%S'), DateTime.strptime(row[4],'%H:%M:%S')
      start_at, end_at = Date.strptime(row[1], '%m/%d/%Y'), Date.strptime(row[3], '%m/%d/%Y')
      event = calendar.events.new(
        user: current_user,
        name: row[0],
        start_at: start_at,
        start_at_hours: start_time.strftime('%I'),
        start_at_minutes: start_time.strftime('%M'),
        start_am_pm: start_time.strftime('%P'),
        end_at: end_at,
        end_at_hours: end_time.strftime('%I'),
        end_at_minutes: end_time.strftime('%M'),
        end_am_pm: end_time.strftime('%P'),
        all_day: to_boolean(row[5]),
        description: row[6],
        location: row[7],
        link: row[8],
        recurring_type: 'null',
        published: '1'
      )
      event.save!
    end
  end

  def schedule
    @events = []
    max_date = params[:end] ? Time.new(params[:end]) : Time.now + 3.years

    current_user.published_events.each do |event|
      if event.recurring_rule==IceCube::SingleOccurrenceRule
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
    render 'schedule', layout: false
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = current_user.events.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.events.new event_params
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @event.update_attributes event_params
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit!
  end

  def find_event
    events = current_user.events.where(id: params[:id])
    @event = events.any? ? events.first : nil
  end

  def is_author?
    current_user.events.map { |x| x.id }.include? params[:id]
  end
end
