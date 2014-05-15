class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :parent_id, type: String

  has_many :subcategories, :class_name => 'Category', :foreign_key => 'parent_id', :dependent => :destroy
  belongs_to :parent_category, :class_name => 'Category'

  validates :name, presence: true
  has_and_belongs_to_many :events

  belongs_to :user
end
