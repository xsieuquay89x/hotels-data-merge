require 'rails_helper'

RSpec.describe HotelsController, type: :controller do
  let(:fake_hotel_data) { {
    "id": "iJhz",
    "destination_id": 5432,
    "name": "Beach Villas Singapore",
    "location": {
      "lat": 1.264751,
      "lng": 103.824006,
      "address": "8 Sentosa Gateway, Beach Villas, 098269",
      "city": "Singapore",
      "country": "Singapore"
    },
    "description": "description 1.",
    "amenities": {
      "general": ["outdoor pool", "indoor pool", "business center", "childcare", "wifi", "dry cleaning", "breakfast"],
      "room": ["aircon", "tv", "coffee machine", "kettle", "hair dryer", "iron", "bathtub"]
    },
    "images": {
      "rooms": [
        { "link": "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg", "description": "Double room" },
        { "link": "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/3.jpg", "description": "Double room" },
        { "link": "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/4.jpg", "description": "Bathroom" }
      ],
      "site": [
        { "link": "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg", "description": "Front" }
      ],
      "amenities": [
        { "link": "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/0.jpg", "description": "RWS" }
      ]
    },
    "booking_conditions": [
      "All children are welcome. One child under 12 years stays free of charge when using existing beds. One child under 2 years stays free of charge in a child's cot/crib. One child under 4 years stays free of charge when using existing beds. One older child or adult is charged SGD 82.39 per person per night in an extra bed. The maximum number of children's cots/cribs in a room is 1. There is no capacity for extra beds in the room.",
      "Pets are not allowed.",
      "WiFi is available in all areas and is free of charge.",
      "Free private parking is possible on site (reservation is not needed).",
      "Guests are required to show a photo identification and credit card upon check-in. Please note that all Special Requests are subject to availability and additional charges may apply. Payment before arrival via bank transfer is required. The property will contact you after you book to provide instructions. Please note that the full amount of the reservation is due before arrival. Resorts World Sentosa will send a confirmation with detailed payment information. After full payment is taken, the property's details, including the address and where to collect keys, will be emailed to you. Bag checks will be conducted prior to entry to Adventure Cove Waterpark. === Upon check-in, guests will be provided with complimentary Sentosa Pass (monorail) to enjoy unlimited transportation between Sentosa Island and Harbour Front (VivoCity). === Prepayment for non refundable bookings will be charged by RWS Call Centre. === All guests can enjoy complimentary parking during their stay, limited to one exit from the hotel per day. === Room reservation charges will be charged upon check-in. Credit card provided upon reservation is for guarantee purpose. === For reservations made with inclusive breakfast, please note that breakfast is applicable only for number of adults paid in the room rate. Any children or additional adults are charged separately for breakfast and are to paid directly to the hotel."
    ]
  } }
  describe 'GET #index' do
    context 'when hotels are present' do
      before do
        allow_any_instance_of(HotelService).to receive(:get_hotels).and_return([fake_hotel_data])
        get :index
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body, {:symbolize_names => true})
        expect(result).to eq([fake_hotel_data])
      end
    end

    context 'when hotels are not present' do
      before do
        allow_any_instance_of(HotelService).to receive(:get_hotels).and_return(nil)
        get :index
      end

      it 'returns an error response' do
        result = JSON.parse(response.body, {:symbolize_names => true})
        expect(result[:message]).to eq('Could not find Hotels')
      end
    end

    context 'when an exception occurs' do
      before do
        allow_any_instance_of(HotelService).to receive(:get_hotels).and_raise('Some error')
        get :index
      end

      it 'returns a not found response' do
        result = JSON.parse(response.body, {:symbolize_names => true})
        expect(result[:message]).to eq('Not Found: Some error')
      end
    end
  end

  describe 'GET #show' do
    let(:params) { { id: 'iJhz' } }

    context 'when hotels are present' do
      before do
        allow_any_instance_of(HotelService).to receive(:get_hotel).and_return(fake_hotel_data)
        get :show, params: params
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body, {:symbolize_names => true})
        expect(result).to eq([fake_hotel_data])
      end
    end

    context 'when hotels are not present' do
      before do
        allow_any_instance_of(HotelService).to receive(:get_hotel).and_return(nil)
        get :show, params: params
      end

      it 'returns an error response' do
        result = JSON.parse(response.body, {:symbolize_names => true})
        expect(result[:message]).to eq('Could not find Hotels with id = iJhz')
      end
    end

    context 'when an exception occurs' do
      before do
        allow_any_instance_of(HotelService).to receive(:get_hotel).and_raise('Some error')
        get :show, params: params
      end

      it 'returns a not found response' do
        result = JSON.parse(response.body, {:symbolize_names => true})
        expect(result[:message]).to eq('Not Found: Some error')
      end
    end
  end

  describe 'POST #create' do
    context 'when hotel collection is successful' do
      before do
        allow_any_instance_of(CollectHotelService).to receive(:call)
        post :create
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body, {:symbolize_names => true})
        expect(result[:message]).to eq('Collect Hotels Success')
      end
    end

    context 'when an exception occurs during hotel collection' do
      before do
        allow_any_instance_of(CollectHotelService).to receive(:call).and_raise('Collection error')
        post :create
      end

      it 'returns a server error response' do
        result = JSON.parse(response.body, {:symbolize_names => true})
        expect(result[:message]).to eq('Collection error')
      end
    end
  end
end
