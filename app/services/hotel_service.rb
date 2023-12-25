class HotelService

  def initialize
    super
  end

  def get_hotel(hotel_id)
    if hotel_id.present?
      hotel = $redis.get hotel_id
      JSON.parse(hotel, {:symbolize_names => true})
    else
      nil
    end
  end

  def get_hotels
    keys = $redis.keys('*')
    hotels = $redis.mget(keys)
    hotels.map do |hotel|
      JSON.parse(hotel, {:symbolize_names => true})
    end
  end
end