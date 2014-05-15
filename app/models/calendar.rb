class Calendar
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :events
  belongs_to :user

  field :name, type: String

  validates_presence_of :name

  def published_events
    events.where published: '1'
  end

end
