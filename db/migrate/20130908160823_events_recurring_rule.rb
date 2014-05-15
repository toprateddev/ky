class EventsRecurringRule < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.text :recurring_rule
    end
  end
end
