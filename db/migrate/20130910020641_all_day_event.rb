class AllDayEvent < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.boolean :all_day, default: true
    end
  end
end
