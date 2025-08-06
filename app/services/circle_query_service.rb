class CircleQueryService
  def self.call(params)
    # Example: Find circles by frame and/or within a radius
    scope = Circle.all
    scope = scope.where(frame_id: params[:frame_id]) if params[:frame_id]
    # TODO: Add radius-based filtering if needed
    scope
  end
end
