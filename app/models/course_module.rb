class CourseModule < ActiveRecord::Base
  attr_accessible :file_cache, :file, :name, :summary, :class_type, :course_id, :position
  
  attr_accessible :completed_date, :completed, :quiz_attributes
  
  mount_uploader :file, MediaUploader
  
  belongs_to :course
  
  validates :name, presence: true
  validates :summary, presence: true
  validates :class_type, presence: true
  validates :file, presence: true, :if => :validate_file?
  def validate_file?
    class_type !="Quiz"
  end
  
  validates_format_of :file, :with => %r{\.(png|jpg|jpeg)$}i, :if => :validate_image?, :message =>"Invalid image was entered. You can use either png or jpg/jpeg."
  def validate_image?
    class_type =="Image"
  end
  
  validates_format_of :file, :with => %r{\.(mp3)$}i, :if => :validate_audio?, :message =>"Invalid audio file was entered. You can use an mp3 file."
  def validate_audio?
    class_type =="Audio"
  end
  
  validates_format_of :file, :with => %r{\.(mp4)$}i, :if => :validate_video?, :message =>"Invalid video file was entered. You can use an mp4 file."
  def validate_video?
    class_type =="Video"
  end
  
  has_one :quiz
  accepts_nested_attributes_for :quiz, :allow_destroy => true

  
end
