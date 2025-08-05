class Frame < ApplicationRecord
  has_many :circles, dependent: :destroy

  validates :center_x, presence: true, numericality: true
  validates :center_y, presence: true, numericality: true
  validates :width, presence: true, numericality: { greater_than: 0 }
  validates :height, presence: true, numericality: { greater_than: 0 }

  validate :frame_cannot_touch_other_frames

  # Ensure numeric output in JSON
  def as_json(options = {})
    super(options).merge(
      'center_x' => center_x.to_f,
      'center_y' => center_y.to_f,
      'width' => width.to_f,
      'height' => height.to_f
    )
  end

  # Keep model methods simple and related to data
  def area
    width * height
  end
  
  def left_edge
    center_x - (width / 2)
  end
  
  def right_edge
    center_x + (width / 2)
  end
  
  def top_edge
    center_y + (height / 2)
  end
  
  def bottom_edge
    center_y - (height / 2)
  end
  
  # Frame statistics methods
  def total_circles
    circles.count
  end
  
  def highest_circle_position
    return nil if circles.empty?
    
    highest = circles.max_by(&:center_y)
    { x: highest.center_x, y: highest.center_y }
  end
  
  def lowest_circle_position
    return nil if circles.empty?
    
    lowest = circles.min_by(&:center_y)
    { x: lowest.center_x, y: lowest.center_y }
  end
  
  def leftmost_circle_position
    return nil if circles.empty?
    
    leftmost = circles.min_by(&:center_x)
    { x: leftmost.center_x, y: leftmost.center_y }
  end
  
  def rightmost_circle_position
    return nil if circles.empty?
    
    rightmost = circles.max_by(&:center_x)
    { x: rightmost.center_x, y: rightmost.center_y }
  end
  
  private
  
  def frame_cannot_touch_other_frames
    return unless persisted? || new_record?
    
    # Check if this frame intersects with any existing frames
    other_frames = Frame.where.not(id: id)
    
    other_frames.each do |other_frame|
      if frames_intersect?(other_frame)
        errors.add(:base, "Frame cannot touch or intersect with another frame")
        break
      end
    end
  end
  
  def frames_intersect?(other_frame)
    # Check if two rectangular frames intersect or touch
    !(right_edge < other_frame.left_edge ||
      left_edge > other_frame.right_edge ||
      top_edge < other_frame.bottom_edge ||
      bottom_edge > other_frame.top_edge)
  end
end
