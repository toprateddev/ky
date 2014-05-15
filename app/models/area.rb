class Area
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type:String


  has_and_belongs_to_many :events
  belongs_to :user

end
