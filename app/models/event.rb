class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include IceCube

  field :name, type: String
  field :all_day, type: Boolean, default: false
  field :published, type: String, default: '0'
  field :description, type: String
  field :location, type: String
  field :link, type: String
  field :address, type: String
  field :city, type: String
  field :state, type: String
  field :phone, type: String

  field :recurring_type,type: String

  field :start_at,type: Date
  field :start_at_hours,type: String, default: '00'
  field :start_at_minutes,type: String, default: '00'
  field :start_am_pm, type: String

  field :end_at,type: Date
  field :end_at_hours,type: String, default: '00'
  field :end_at_minutes,type: String, default: '00'
  field :end_am_pm, type: String

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :calendars
  has_and_belongs_to_many :areas

  field :parent_id, type: String

  validates_inclusion_of :start_am_pm, { in: [ 'am', 'pm', '' ] }
  validates_inclusion_of :end_am_pm, { in: [ 'am', 'pm', '' ] }

  validates_presence_of :start_at_hours, unless: :all_day?
  validates_presence_of :start_at_minutes, unless: :all_day?
  validates_presence_of :start_am_pm, unless: :all_day?
  validates_presence_of :end_at_hours, unless: :all_day?
  validates_presence_of :end_at_minutes, unless: :all_day?
  validates_presence_of :end_am_pm, unless: :all_day?


  def correct_calendars_count?
    calendars.count > 0
  end

  def location_defined?
    not (state.empty? or city.empty? or address.empty? or location.empty?)
  end

  def full_location
    "#{state} #{city} #{address} #{location}"
  end

  def all_day?
    return true if all_day.to_i==1 or all_day==true
    false
  end

  def published?
    return true if published.to_i==1 or published.to_s==true.to_s
    false
  end

  def date_is_ok?
    unless end_at >= start_at
      errors.add :date_time, 'end date must be after then start date'
      return false
    end
    true
  end

  validates_presence_of :recurring_type
  validates_presence_of :start_at
  validates_presence_of :end_at
  validates :name, presence: true
  validates_numericality_of :end_at_minutes, :start_at_minutes, less_than_or_equal_to: 60, more_than_or_equal_to: 0
  validates_numericality_of :end_at_hours, :start_at_hours, less_than_or_equal_to: 12, more_than_or_equal_to: 0
  validate :correct_calendars_count?
  validate :date_is_ok?, if: [:start_at, :end_at]

  belongs_to :user

  def start
    begin
      DateTime.parse("#{start_at} #{start_at_hours}:#{start_at_minutes} #{start_am_pm.downcase}")
    rescue
      DateTime.now
    end
  end

  def end
    begin
      DateTime.parse("#{end_at} #{end_at_hours}:#{end_at_minutes} #{start_am_pm.downcase}")
    rescue
      DateTime.now
    end
  end

  def recurring
    JSON.parse(recurring_type)
  end

  def schedule
    schedule = IceCube::Schedule.new
    schedule.add_recurrence_rule(recurring_rule)
    schedule
  end

  def recurring_rule
    return IceCube::SingleOccurrenceRule if recurring_type.match /^null$/i
    RecurringSelect.dirty_hash_to_rule recurring_type
  end

  def url
    unless link.match /https?:\/\/[\S]+/
      "http://#{link}"
    else
      link
    end
  end

end
