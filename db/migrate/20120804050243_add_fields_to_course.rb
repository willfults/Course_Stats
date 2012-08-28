class AddFieldsToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :category, :string
    add_column :courses, :privacy, :string
    add_column :courses, :published, :boolean
  end
end
