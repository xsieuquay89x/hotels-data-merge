require 'rails_helper'

RSpec.describe MergeUtils do
  let(:subject) { Class.new { extend MergeUtils } }

  let(:data) { {
    name: 'Luxury Resort',
    amenities: { general: ['pool', 'wifi'], room: ['tv', 'coffee maker', 'gym'] },
    booking_conditions: ['free cancellation', 'breakfast included'],
    description: 'Beautiful hotel with a view',
    images: { rooms: [{ description: 'Room 101', link: 'room101.jpg' },
                      { description: 'Room 103', link: 'room103.jpg' }], amenities: [] },
    location: { lat: 40.7128, lng: -74.0060, address: '456', city: 'Singapore', country: 'SG' }
  }}
  let(:merge_data) { {
    name: 'Five-Star Hotel and Spa',
    amenities: { general: ['wifi', 'gym'], room: ['coffee maker', 'mini bar'] },
    booking_conditions: ['wifi', 'free cancellation'],
    description: 'Luxurious accommodation with top-notch services',
    images: { rooms: [{ description: 'Room 102', link: 'room102.jpg' },
                      { description: 'Room 103', link: 'room101.jpg' }], site: [] },
    location: { lat: 40.7128, lng: -74.0060, address: '456', city: 'Singapore', country: 'Singapore' }
  }}
  describe '#merge_amenities' do
    it 'merges amenities data' do
      result = subject.merge(data, merge_data, 'amenities')

      expect(result).to eq({
                             general: ['pool', 'wifi', 'gym'],
                             room: ['tv', 'coffee maker', 'mini bar']
                           })
    end
  end

  describe '#merge_booking_conditions' do
    it 'merges booking conditions data' do
      result = subject.merge(data, merge_data, 'booking_conditions')

      expect(result).to eq(['free cancellation', 'breakfast included', 'wifi'])
    end
  end

  describe '#merge_description' do
    it 'merges description data' do
      result = subject.merge(data, merge_data, 'description')

      expect(result).to eq('Luxurious accommodation with top-notch services')
    end
  end

  describe '#merge_images' do
    it 'merges images data' do
      result = subject.merge(data, merge_data, 'images')

      expect(result).to eq({
                             rooms: [
                               { description: 'Room 101', link: 'room101.jpg' },
                               { description: 'Room 103', link: 'room103.jpg' },
                               { description: 'Room 102', link: 'room102.jpg' }
                             ],
                             site: []
                           })
    end
  end

  describe '#merge_location' do
    it 'merges location data' do
      result = subject.merge(data, merge_data, 'location')

      expect(result).to eq({
                             lat: 40.7128,
                             lng: -74.0060,
                             address: '456',
                             city: 'Singapore',
                             country: 'SG'
                           })
    end
  end

  describe '#merge_name' do
    it 'merges name data' do
      result = subject.merge(data, merge_data, 'name')

      expect(result).to eq('Five-Star Hotel and Spa')
    end
  end

  describe '#merge' do
    it 'merges nil' do
      result = subject.merge(data, merge_data, 'abc')

      expect(result).to eq(nil)
    end
  end
end
