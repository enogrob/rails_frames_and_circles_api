require 'rails_helper'

RSpec.describe Circle, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      frame = Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10)
      circle = Circle.new(center_x: 1.0, center_y: 2.0, diameter: 3.0, frame: frame)
      expect(circle).to be_valid
    end

    it 'is invalid without center_x' do
      circle = Circle.new(center_y: 2.0, diameter: 3.0)
      expect(circle).not_to be_valid
      expect(circle.errors[:center_x]).to include("can't be blank")
    end

    it 'is invalid without center_y' do
      circle = Circle.new(center_x: 1.0, diameter: 3.0)
      expect(circle).not_to be_valid
      expect(circle.errors[:center_y]).to include("can't be blank")
    end

    it 'is invalid without diameter' do
      circle = Circle.new(center_x: 1.0, center_y: 2.0)
      expect(circle).not_to be_valid
      expect(circle.errors[:diameter]).to include("can't be blank")
    end

    it 'is invalid with non-numeric center_x' do
      circle = Circle.new(center_x: 'foo', center_y: 2.0, diameter: 3.0)
      expect(circle).not_to be_valid
    end

    it 'is invalid with non-numeric center_y' do
      circle = Circle.new(center_x: 1.0, center_y: 'foo', diameter: 3.0)
      expect(circle).not_to be_valid
    end

    it 'is invalid with non-numeric diameter' do
      circle = Circle.new(center_x: 1.0, center_y: 2.0, diameter: 'foo')
      expect(circle).not_to be_valid
    end

    it 'is invalid with diameter <= 0' do
      circle = Circle.new(center_x: 1.0, center_y: 2.0, diameter: 0)
      expect(circle).not_to be_valid
    end
  end

  describe '#as_json' do
    it 'returns numeric values for geometry fields' do
      circle = Circle.new(center_x: 1, center_y: 2, diameter: 3)
      json = circle.as_json
      expect(json['center_x']).to eq(1.0)
      expect(json['center_y']).to eq(2.0)
      expect(json['diameter']).to eq(3.0)
    end
  end

  describe 'associations' do
    it 'is invalid without a frame' do
      circle = Circle.new(center_x: 1, center_y: 1, diameter: 1)
      expect(circle).not_to be_valid
      expect(circle.errors[:frame]).to include("must exist").or include("can't be blank")
    end

    it 'is valid with a frame' do
      frame = Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10)
      circle = Circle.new(center_x: 1, center_y: 1, diameter: 1, frame: frame)
      expect(circle).to be_valid
    end
  end
  describe 'geometry methods' do
    it '#radius returns half the diameter' do
      circle = Circle.new(diameter: 8)
      expect(circle.radius).to eq(4)
    end

    it '#area returns correct value' do
      circle = Circle.new(diameter: 2)
      expect(circle.area).to be_within(0.01).of(Math::PI)
    end

    it '#circumference returns correct value' do
      circle = Circle.new(diameter: 2)
      expect(circle.circumference).to be_within(0.01).of(2 * Math::PI)
    end

    it '#within_radius? returns true if circle is within search radius' do
      circle = Circle.new(center_x: 0, center_y: 0, diameter: 2)
      expect(circle.within_radius?(0, 0, 2)).to be true
    end

    it '#within_radius? returns false if circle is outside search radius' do
      circle = Circle.new(center_x: 5, center_y: 0, diameter: 2)
      expect(circle.within_radius?(0, 0, 2)).to be false
    end
  end

  describe 'custom validations' do
    let(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10) }

    it 'is invalid if circle does not fit in frame' do
      circle = Circle.new(center_x: -10, center_y: 0, diameter: 3, frame: frame)
      expect(circle).not_to be_valid
      expect(circle.errors[:center_x]).to include(/extends beyond/)
    end

    it 'is invalid if circle touches another circle in the same frame' do
      Circle.create!(center_x: 0, center_y: 0, diameter: 2, frame: frame)
      circle2 = Circle.new(center_x: 1, center_y: 0, diameter: 2, frame: frame)
      expect(circle2).not_to be_valid
      expect(circle2.errors[:base]).to include(/cannot touch/)
    end

    it 'is valid if circle does not touch another circle in the same frame' do
      Circle.create!(center_x: 0, center_y: 0, diameter: 2, frame: frame)
      circle2 = Circle.new(center_x: 4, center_y: 0, diameter: 2, frame: frame)
      expect(circle2).to be_valid
    end
  end
end
