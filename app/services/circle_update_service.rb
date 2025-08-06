class CircleUpdateService
  def self.call(circle, params)
    unless circle.update(params)
      # If update fails, errors will be present on the circle
      return circle
    end
    circle
  end
end
