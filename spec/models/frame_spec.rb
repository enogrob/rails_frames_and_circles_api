require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      frame = Frame.new(center_x: 1.0, center_y: 2.0, width: 3.0, height: 4.0)
      expect(frame).to be_valid
    end

    it 'is invalid without center_x' do
      frame = Frame.new(center_y: 2.0, width: 3.0, height: 4.0)
      expect(frame).not_to be_valid
      expect(frame.errors[:center_x]).to include("can't be blank")
    end

    it 'is invalid without center_y' do
      frame = Frame.new(center_x: 1.0, width: 3.0, height: 4.0)
      expect(frame).not_to be_valid
      expect(frame.errors[:center_y]).to include("can't be blank")
    end

    it 'is invalid without width' do
      frame = Frame.new(center_x: 1.0, center_y: 2.0, height: 4.0)
      expect(frame).not_to be_valid
      expect(frame.errors[:width]).to include("can't be blank")
    end

    it 'is invalid without height' do
      frame = Frame.new(center_x: 1.0, center_y: 2.0, width: 3.0)
      expect(frame).not_to be_valid
      expect(frame.errors[:height]).to include("can't be blank")
    end

    it 'is invalid with non-numeric center_x' do
      frame = Frame.new(center_x: 'foo', center_y: 2.0, width: 3.0, height: 4.0)
      expect(frame).not_to be_valid
    end

    it 'is invalid with non-numeric center_y' do
      frame = Frame.new(center_x: 1.0, center_y: 'foo', width: 3.0, height: 4.0)
      expect(frame).not_to be_valid
    end

    it 'is invalid with non-numeric width' do
      frame = Frame.new(center_x: 1.0, center_y: 2.0, width: 'foo', height: 4.0)
      expect(frame).not_to be_valid
    end

    it 'is invalid with non-numeric height' do
      frame = Frame.new(center_x: 1.0, center_y: 2.0, width: 3.0, height: 'foo')
      expect(frame).not_to be_valid
    end

    it 'is invalid with width <= 0' do
      frame = Frame.new(center_x: 1.0, center_y: 2.0, width: 0, height: 4.0)
      expect(frame).not_to be_valid
    end

    it 'is invalid with height <= 0' do
      frame = Frame.new(center_x: 1.0, center_y: 2.0, width: 3.0, height: 0)
      expect(frame).not_to be_valid
    end
  end

  describe '#as_json' do
    it 'returns numeric values for geometry fields' do
      frame = Frame.new(center_x: 1, center_y: 2, width: 3, height: 4)
      json = frame.as_json
      expect(json['center_x']).to eq(1.0)
      expect(json['center_y']).to eq(2.0)
      expect(json['width']).to eq(3.0)
      expect(json['height']).to eq(4.0)
    end
  end

  describe 'associations' do
    it 'destroys circles when frame is destroyed' do
      frame = Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10)
      frame.circles.create!(center_x: 1, center_y: 1, diameter: 1)
      expect { frame.destroy }.to change { Circle.count }.by(-1)
    end
  end

  describe 'geometry methods' do
    let(:frame) { Frame.new(center_x: 10, center_y: 20, width: 8, height: 6) }

    it '#area returns width * height' do
      expect(frame.area).to eq(48)
    end

    it '#left_edge returns correct value' do
      expect(frame.left_edge).to eq(6)
    end

    it '#right_edge returns correct value' do
      expect(frame.right_edge).to eq(14)
    end

    it '#top_edge returns correct value' do
      expect(frame.top_edge).to eq(23)
    end

    it '#bottom_edge returns correct value' do
      expect(frame.bottom_edge).to eq(17)
    end
  end

  describe 'circle statistics methods' do
    let(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10) }

    it '#total_circles returns 0 if no circles' do
      expect(frame.total_circles).to eq(0)
    end

    it '#total_circles returns count of circles' do
      frame.circles.create!(center_x: 1, center_y: 2, diameter: 1)
      frame.circles.create!(center_x: 3, center_y: 4, diameter: 1)
      expect(frame.total_circles).to eq(2)
    end

    it '#highest_circle_position returns nil if no circles' do
      expect(frame.highest_circle_position).to be_nil
    end

    it '#highest_circle_position returns highest y' do
      frame.circles.create!(center_x: 1, center_y: 2, diameter: 1)
      c2 = frame.circles.create!(center_x: 3, center_y: 4, diameter: 1)
      expect(frame.highest_circle_position).to eq({ x: c2.center_x, y: c2.center_y })
    end

    it '#lowest_circle_position returns lowest y' do
      c1 = frame.circles.create!(center_x: 1, center_y: 2, diameter: 1)
      frame.circles.create!(center_x: 3, center_y: 4, diameter: 1)
      expect(frame.lowest_circle_position).to eq({ x: c1.center_x, y: c1.center_y })
    end

    it '#leftmost_circle_position returns leftmost x' do
      c1 = frame.circles.create!(center_x: 1, center_y: 2, diameter: 1)
      frame.circles.create!(center_x: 3, center_y: 4, diameter: 1)
      expect(frame.leftmost_circle_position).to eq({ x: c1.center_x, y: c1.center_y })
    end

    it '#rightmost_circle_position returns rightmost x' do
      frame.circles.create!(center_x: 1, center_y: 2, diameter: 1)
      c2 = frame.circles.create!(center_x: 3, center_y: 4, diameter: 1)
      expect(frame.rightmost_circle_position).to eq({ x: c2.center_x, y: c2.center_y })
    end
  end

  describe 'frame_cannot_touch_other_frames' do
    it 'adds error if frame touches another frame' do
      Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10)
      frame2 = Frame.new(center_x: 5, center_y: 0, width: 10, height: 10)
      expect(frame2).not_to be_valid
      expect(frame2.errors[:base]).to include("Frame cannot touch or intersect with another frame")
    end

    it 'does not add error if frame does not touch another frame' do
      Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10)
      frame2 = Frame.new(center_x: 20, center_y: 0, width: 10, height: 10)
      expect(frame2).to be_valid
    end

    it 'does not add error if no other frames exist' do
      frame = Frame.new(center_x: 0, center_y: 0, width: 10, height: 10)
      expect(frame).to be_valid
    end
  end
end
