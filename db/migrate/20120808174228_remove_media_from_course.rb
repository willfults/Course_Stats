class RemoveMediaFromCourse < ActiveRecord::Migration
  def up
    remove_column :courses, :media
  end

  def down
    add_column :courses, :media, :string
  end
end
