require 'rails_helper'

RSpec.describe Transformer do
  let(:dummy_supplier) { {} }
  let(:transformer) { described_class.new(dummy_supplier) }

  describe '#amenities_general' do
    it 'returns general amenities' do
      dummy_supplier['Facilities'] = ['pool', 'gym']
      result = transformer.send(:amenities_general)
      expect(result).to eq(['pool', 'gym'])
    end

    it 'returns general amenities from hash' do
      dummy_supplier['amenities'] = { 'general' => ['wifi', 'sauna'] }
      result = transformer.send(:amenities_general)
      expect(result).to eq(['wifi', 'sauna'])
    end
  end

  describe '#amenities_room' do
    it 'returns room amenities' do
      dummy_supplier['amenities'] = { 'room' => ['tv', 'coffee_maker'] }
      result = transformer.send(:amenities_room)
      expect(result).to eq(['tv', 'coffee_maker'])
    end

    it 'returns room amenities from array' do
      dummy_supplier['amenities'] = ['tv', 'coffee_maker']
      result = transformer.send(:amenities_room)
      expect(result).to eq(['tv', 'coffee_maker'])
    end
  end

  describe '#map_to_hotel_image' do
    it 'maps image data' do
      dummy_supplier['images'] = { 'rooms' => [{ 'url' => 'room101.jpg', 'caption' => 'Room 101' }] }
      result = transformer.send(:map_to_hotel_image, dummy_supplier['images']['rooms'])
      expect(result).to eq([{ link: 'room101.jpg', description: 'Room 101' }])
    end
  end
end
