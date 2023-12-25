require 'swagger_helper'

describe 'Hotels API' do
  path '/hotels' do

    post 'Collect Hotel' do
      tags 'Hotels'
      consumes 'application/json'

      response '200', 'collected' do
        let(:message) { { message: 'Collect Hotels Success' } }
        run_test!
      end
    end
  end

  path '/hotels' do

    get 'Get all hotels' do
      tags 'Hotels'
      produces 'application/json'

      response '200', 'Hotels Founds' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :string, },
            destination_id: { type: :integer, },
            name: { type: :string },
            description: { type: :string },
            booking_conditions: { type: :array, items: {
              type: :string
            } },
            amenities: { type: :object, properties: {
              general: { type: :array },
              room: { type: :array }
            } },
            images: { type: :object, properties: {
              rooms: { type: :arry, items: {
                type: :object,
                properties: {
                  link: { type: :string },
                  description: { type: :string }
                }}
              },
              site: { type: :arry, items: {
                type: :object,
                properties: {
                  link: { type: :string },
                  description: { type: :string }
                }}
              },
              amenities: { type: :arry, items: {
                type: :object,
                properties: {
                  link: { type: :string },
                  description: { type: :string }
                }}
              }
            } },
            location: { type: :object, properties: {
              address: { type: :string },
              city: { type: :string },
              country: { type: :string },
              lat: { type: :float },
              lng: { type: :float }
            } }
          }},
               required: [ ]
        example 'application/json', :hotels, [
          {
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
            "description": "Surrounded by tropical gardens, these upscale villas in elegant Colonial-style buildings are part of the Resorts World Sentosa complex and a 2-minute walk from the Waterfront train station. Featuring sundecks and pool, garden or sea views, the plush 1- to 3-bedroom villas offer free Wi-Fi and flat-screens, as well as free-standing baths, minibars, and tea and coffeemaking facilities. Upgraded villas add private pools, fridges and microwaves; some have wine cellars. A 4-bedroom unit offers a kitchen and a living room. There's 24-hour room and butler service. Amenities include posh restaurant, plus an outdoor pool, a hot tub, and free parking.",
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
          }
        ]
        run_test!
      end
    end
  end

  path '/hotels?id={id}' do

    get 'Retrieves a hotel' do
      tags 'Hotels'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :array, items: {
        type: :string
      }

      response '200', 'Hotel Found' do
        schema type: :array, items: {
          type: :object,
          properties: {
             id: { type: :string, },
             destination_id: { type: :integer, },
             name: { type: :string },
             description: { type: :string },
             booking_conditions: { type: :array, items: {
               type: :string
             } },
             amenities: { type: :object, properties: {
               general: { type: :array },
               room: { type: :array }
             } },
             images: { type: :object, properties: {
               rooms: { type: :arry, items: {
                  type: :object,
                  properties: {
                    link: { type: :string },
                    description: { type: :string }
                  }}
               },
               site: { type: :arry, items: {
                 type: :object,
                 properties: {
                   link: { type: :string },
                   description: { type: :string }
                 }}
               },
               amenities: { type: :arry, items: {
                 type: :object,
                 properties: {
                   link: { type: :string },
                   description: { type: :string }
                 }}
               }
             } },
             location: { type: :object, properties: {
               address: { type: :string },
               city: { type: :string },
               country: { type: :string },
               lat: { type: :float },
               lng: { type: :float }
             } }
           }},
               required: [ ]
        example 'application/json', :hotels, [
          {
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
            "description": "Surrounded by tropical gardens, these upscale villas in elegant Colonial-style buildings are part of the Resorts World Sentosa complex and a 2-minute walk from the Waterfront train station. Featuring sundecks and pool, garden or sea views, the plush 1- to 3-bedroom villas offer free Wi-Fi and flat-screens, as well as free-standing baths, minibars, and tea and coffeemaking facilities. Upgraded villas add private pools, fridges and microwaves; some have wine cellars. A 4-bedroom unit offers a kitchen and a living room. There's 24-hour room and butler service. Amenities include posh restaurant, plus an outdoor pool, a hot tub, and free parking.",
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
          }
        ]
        let(:id) { 'iJhz' }
        run_test!
      end
    end
  end
end