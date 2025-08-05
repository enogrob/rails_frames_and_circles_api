require 'rails_helper'

describe Frame, 'edge cases' do
  it 'prevents a frame with zero width' do
    frame = Frame.new(center_x: 0, center_y: 0, width: 0, height: 10)
    expect(frame).not_to be_valid
    expect(frame.errors[:width]).to include(/greater than 0/)
  end

  it 'prevents a frame with negative height' do
    frame = Frame.new(center_x: 0, center_y: 0, width: 10, height: -1)
    expect(frame).not_to be_valid
    expect(frame.errors[:height]).to include(/greater than 0/)
  end

  it 'allows a frame with minimum positive width and height' do
    frame = Frame.new(center_x: 0, center_y: 0, width: 0.0001, height: 0.0001)
    expect(frame).to be_valid
  end
end
