class FrameDeletionService
  def self.call(frame)
    if frame.circles.exists?
      frame.errors.add(:base, "Cannot delete frame with circles")
      return frame
    end

    frame.destroy
    frame
  end
end