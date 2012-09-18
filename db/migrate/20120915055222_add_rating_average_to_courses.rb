class AddRatingAverageToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :rating_average, :decimal, :default => 0, :precision => 5, :scale => 2
  end

  def self.down
    remove_column :courses, :rating_average
  end
end
