class StatCollector
  @queue = :stats_queue
  def self.perform(class_id, course_id, user_id, status)
      Statistic.create(
        class_id: class_id,
        course_id: course_id,
        user_id: user_id,
        status: status.to_str
      )
  end
end

