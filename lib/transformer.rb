class Transformer
  include Utils

  def initialize(supplier)
    @supplier = supplier
  end

  def hotel
    {
      id: select_data(@supplier, %w[Id id hotel_id]),
      destination_id: select_data(@supplier, %w[DestinationId destination_id destination]),
      name: select_data(@supplier, %w[Name name hotel_name])&.strip,
      location: location,
      description: select_data(@supplier, %w[Description details])&.strip,
      amenities: amenities,
      images: images,
      booking_conditions: [select_data(@supplier, %w[booking_conditions])].flatten.compact.map(&:strip)
    }
  end

  private

  def amenities
    @_amenities ||= {
      general: amenities_general,
      room: amenities_room,
    }
  end

  def images
    @_images ||= {
      room: map_to_hotel_image(@supplier.dig('images', 'rooms')),
      site: map_to_hotel_image(@supplier.dig('images', 'site')),
      amenities: map_to_hotel_image(@supplier.dig('images', 'amenities')),
    }.compact
  end

  def location
    @_location ||= {
      address: address,
      city: @supplier["City"],
      country: select_data(@supplier, %w[Country]),
      lat: select_data(@supplier, %w[Latitude lat]),
      lng: select_data(@supplier, %w[Longitude lng]),
    }
  end

  def address
    @_address = begin
      if select_data(@supplier, %w[Address]).present?
        return ("#{select_data(@supplier, %w[Address])}, #{select_data(@supplier, %w[PostalCode])}").squish
      end

      (@supplier.dig('location', 'address') || select_data(@supplier, %w[address]))&.squish
    end
  end

  def country
    @_country = (@supplier.dig('location', 'country') || select_data(@supplier, %w[Country]))
  end

  def amenities_general
    @_amenities_general = @supplier['Facilities'] if @supplier['Facilities'].present?
    @_amenities_general = Array(@supplier.dig('amenities', 'general')) if @supplier['amenities'].is_a?(Hash)

    @_amenities_general&.map(&:strip)
  end

  def amenities_room
    @_amenities_room = @supplier.dig('amenities', 'room') if @supplier['amenities'].is_a?(Hash)
    @_amenities_room = select_data(@supplier, %w[amenities]) if @supplier['amenities'].is_a?(Array)

    @_amenities_room&.map(&:strip)
  end

  def map_to_hotel_image(data)
    data&.map do |image|
      {  link: select_data(image, %w[link url]), description: select_data(image, %w[caption description]) }
    end
  end
end
