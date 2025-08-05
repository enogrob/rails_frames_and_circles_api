require 'rails_helper'

describe CircleCreationService do
  let!(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10) }

  it 'creates a valid circle' do
    result = described_class.call(frame, center_x: 1, center_y: 1, diameter: 2)
    expect(result).to be_a(Circle)
    expect(result).to be_persisted
    expect(result.center_x).to eq(1)
  end


  it 'returns errors for invalid circle (overlap)' do
    Circle.create!(center_x: 1, center_y: 1, diameter: 2, frame: frame)
    result = described_class.call(frame, center_x: 1, center_y: 1, diameter: 2)
    expect(result).to be_a(ActiveModel::Errors)
    expect(result[:base]).to include("Circle cannot touch another circle within the same frame")
  end

  it 'returns errors for circle outside frame' do
    result = described_class.call(frame, center_x: 100, center_y: 100, diameter: 2)
    expect(result).to be_a(ActiveModel::Errors)
    expect(result[:center_x].join).to match(/beyond/)
  end
end
