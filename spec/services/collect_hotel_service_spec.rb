# spec/services/collect_hotel_service_spec.rb
require 'rails_helper'

RSpec.describe CollectHotelService do
  describe '#call' do
    let(:service) { described_class.new }
    let(:hotels_data) { [
      { 'id' => '1', 'Name' => 'Hotel One', 'DestinationId' => '123' },
      { 'id' => '2', 'Name' => 'Hotel Two', 'DestinationId' => '456' }
    ]}

    context 'when suppliers are available' do
      before do
        allow(service).to receive(:fetch_supplier_data)
                            .and_return(hotels_data)
        service.call
      end

      it 'merges and stores hotels in Redis' do
        hotel_one = JSON.parse($redis.get('1'), symbolize_names: true)
        hotel_two = JSON.parse($redis.get('2'), symbolize_names: true)

        expect(hotel_one[:id]).to eq('1')
        expect(hotel_two[:id]).to eq('2')
      end
    end

    context 'when suppliers are not available' do
      before do
        allow(service).to receive(:fetch_supplier_data).and_return([])
        service.call
      end

      it 'does not store anything in Redis' do
        data =  $redis.keys('*').count
        expect(data).to eq 0
      end
    end
  end
end
