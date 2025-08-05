require 'rails_helper'

describe CircleDeletionService do
  let!(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10) }
  let!(:circle) { Circle.create!(center_x: 1, center_y: 1, diameter: 2, frame: frame) }

  it 'deletes a circle' do
    expect { described_class.call(circle) }.to change { Circle.count }.by(-1)
  end

  it 'does nothing if circle is already deleted' do
    circle.destroy
    expect { described_class.call(circle) }.not_to raise_error
  end
end
