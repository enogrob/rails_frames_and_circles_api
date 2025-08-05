class CircleCreationService
  def self.call(frame, params)
    circle = frame.circles.new(params)
    # TODO: Add geometric and business validations here
    if circle.save
      circle
    else
      circle.errors
    end
  end
end