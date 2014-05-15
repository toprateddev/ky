class EventForm
  include Mongoid::Document
  include Mongoid::Timestamps

  #include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  #include ActiveModel::ForbiddenAttributesProtection
  attr_reader :event

  validates :name, presence: true
  validates_numericality_of :end_at_minutes, :start_at_minutes, less_than_or_equal_to: 60, more_than_or_equal_to: 0
  validates_numericality_of :end_at_hours, :start_at_hours, less_than_or_equal_to: 12, more_than_or_equal_to: 0

  belongs_to :event

  def self.from_event(event)

  end

  def persisted?
    id || false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  #def start_at_hours
  #  if start_at and start_at.class == DateTime
  #    start_at.strftime('%I')
  #  else
  #    '00'
  #  end
  #end
  #
  #def start_at_minutes
  #  if start_at and start_at.class == DateTime
  #    start_at.strftime('%M')
  #  else
  #    '00'
  #  end
  #end
  #
  #def end_at_hours
  #  if end_at and end_at.class == DateTime
  #    end_at.strftime('%I')
  #  else
  #    '00'
  #  end
  #end
  #
  #def end_at_minutes
  #  if end_at and end_at.class == DateTime
  #    end_at.strftime('%M')
  #  else
  #    '00'
  #  end
  #end

  def _to_partial_path
    123
  end

  private

  def persist!
    recurring_rule = IceCube::Rule.from_hash rule_type: "IceCube::#{recurring_type}Rule"
    params = {
        name: name,
        start_at: DateTime.parse("#{start_at} #{start_at_hours}:#{start_at_minutes} #{start_am_pm.downcase}"),
        end_at: DateTime.parse("#{end_at} #{end_at_hours}:#{end_at_minutes} #{start_am_pm.downcase}"),
        all_day: all_day,
        recurring_rule: recurring_rule.to_json,
        calendar_ids: calendars_ids
    }
    begin
      @event = Event.find(id)
    rescue Mongoid::Errors::DocumentNotFound
      @event = Event.new
    end
    @event.update_attributes params
  end


end
