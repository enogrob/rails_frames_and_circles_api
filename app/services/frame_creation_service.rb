class FrameCreationService
  def self.call(params)
    frame = Frame.new(params)
    if frame.save
      frame
    else
      frame.errors
    end
  end
end
