class CreateFulltextSearchIndex < ActiveRecord::Migration
  def self.up
    execute 'ALTER TABLE courses ENGINE = MyISAM'
    execute 'CREATE FULLTEXT INDEX fulltext_courses ON courses (name, description)'
  end
  
  def self.down
    execute 'ALTER TABLE courses ENGINE = InnoDB'
    execute 'DROP INDEX fulltext_courses ON courses'
  end

end
