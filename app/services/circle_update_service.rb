class CircleUpdateService
  def self.call(circle, params)
    # TODO: Add geometric and business validations here
    if circle.update(params)
      circle
    else
      circle.errors
    end
  end
end