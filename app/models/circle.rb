class Circle < ApplicationRecord
  def as_json(options = {})
    super(options).merge(
      "center_x" => center_x.to_f,
      "center_y" => center_y.to_f,
      "diameter" => diameter.to_f
    )
  end
  belongs_to :frame

  validates :center_x, :center_y, :diameter, presence: true
  validates :center_x, numericality: true
  validates :center_y, numericality: true
  validates :diameter, numericality: { greater_than: 0 }
  validates :frame_id, presence: true

  validate :circle_fits_in_frame
  validate :circle_cannot_touch_other_circles

  # Keep model methods simple and related to data
  def radius
    diameter / 2.0
  end

  def area
    Math::PI * (radius ** 2)
  end

  def circumference
    Math::PI * diameter
  end

  # Check if this circle is completely within a given radius from a point
  def within_radius?(point_x, point_y, search_radius)
    distance_to_point = Math.sqrt((center_x - point_x)**2 + (center_y - point_y)**2)
    distance_to_point + radius <= search_radius
  end

  private

  def circle_fits_in_frame
    return unless frame && diameter && center_x && center_y

    # Check if circle fits completely within frame boundaries
    if center_x - radius < frame.left_edge
      errors.add(:center_x, "Circle extends beyond left edge of frame")
    end

    if center_x + radius > frame.right_edge
      errors.add(:center_x, "Circle extends beyond right edge of frame")
    end

    if center_y - radius < frame.bottom_edge
      errors.add(:center_y, "Circle extends beyond bottom edge of frame")
    end

    if center_y + radius > frame.top_edge
      errors.add(:center_y, "Circle extends beyond top edge of frame")
    end
  end

  def circle_cannot_touch_other_circles
    return unless frame_id && center_x && center_y && diameter

    # Get all other circles in the same frame
    other_circles = Circle.where(frame_id: frame_id).where.not(id: id)

    other_circles.each do |other_circle|
      distance = Math.sqrt((center_x - other_circle.center_x)**2 + (center_y - other_circle.center_y)**2)
      min_distance = radius + other_circle.radius

      if distance <= min_distance
        errors.add(:base, "Circle cannot touch another circle within the same frame")
        break
      end
    end
  end
end
