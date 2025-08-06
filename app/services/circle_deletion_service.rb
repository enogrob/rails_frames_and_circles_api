class CircleDeletionService
  def self.call(circle)
    circle.destroy
    circle
  end
end
