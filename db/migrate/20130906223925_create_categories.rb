class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
    end

    create_table :events_categories do |t|
      t.belongs_to :event
      t.belongs_to :category
    end
  end
end
