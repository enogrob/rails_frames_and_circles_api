require 'rails_helper'

describe Circle, 'edge cases' do
  let!(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10) }

  it 'allows a circle exactly at the left edge' do
    circle = Circle.new(center_x: -5 + 1, center_y: 0, diameter: 2, frame: frame)
    expect(circle).to be_valid
  end

  it 'prevents a circle just outside the left edge' do
    circle = Circle.new(center_x: -5, center_y: 0, diameter: 2, frame: frame)
    expect(circle).not_to be_valid
    expect(circle.errors[:center_x]).to include(/left edge/)
  end

  it 'allows a circle exactly at the top edge' do
    circle = Circle.new(center_x: 0, center_y: 5 - 1, diameter: 2, frame: frame)
    expect(circle).to be_valid
  end

  it 'prevents a circle just outside the top edge' do
    circle = Circle.new(center_x: 0, center_y: 5, diameter: 2, frame: frame)
    expect(circle).not_to be_valid
    expect(circle.errors[:center_y]).to include(/top edge/)
  end

  it 'prevents a circle with zero diameter' do
    circle = Circle.new(center_x: 0, center_y: 0, diameter: 0, frame: frame)
    expect(circle).not_to be_valid
    expect(circle.errors[:diameter]).to include(/greater than 0/)
  end

  it 'prevents a circle with negative diameter' do
    circle = Circle.new(center_x: 0, center_y: 0, diameter: -1, frame: frame)
    expect(circle).not_to be_valid
    expect(circle.errors[:diameter]).to include(/greater than 0/)
  end
end
