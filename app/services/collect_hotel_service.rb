class CollectHotelService
  include MergeUtils

  attr_reader :errors, :hotel_ids

  SUPPLIER_HOTELS = [
    'https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/acme',
    'https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/patagonia',
    'https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/paperflies'
  ].freeze

  def initialize
    @hotel_ids = []
    @errors = []
  end

  def call
    SUPPLIER_HOTELS.each do |url|
      suppliers = fetch_supplier_data(url)

      if suppliers.present?
        suppliers.each do |supplier|
          hotel = ::Transformer.new(supplier).hotel

          merge_and_store_hotel(hotel)
        end
      else
        next
      end
    end

    check_and_delete_hotels
  rescue StandardError => ex
    add_error(ex)
  end

  def success?
    errors.blank?
  end

  private

  def merge_and_store_hotel(hotel)
    hotel_id = hotel[:id]
    cached_hotel = $redis.get hotel_id
    new_hotel = merge_data(cached_hotel, hotel)

    $redis.set hotel_id, new_hotel.to_json

    @hotel_ids << hotel_id
  rescue StandardError => ex
    add_error(ex)
  end

  def fetch_supplier_data(path, params = {}, options = {})
    result = ::Rest::Request.new(:get, path, params, options).perform

    if result.success?
      result.response
    else
      []
    end
  end

  def merge_data(cached_hotel, hotel)
    if cached_hotel.blank? || cached_hotel == 'null'
      new_hotel = hotel
    else
      new_hotel = JSON.parse(cached_hotel, {:symbolize_names => true})
      new_hotel[:destination_id] = hotel[:destination_id]
      new_hotel[:name] = merge(new_hotel, hotel, 'name')
      new_hotel[:location] = merge(new_hotel, hotel, 'location')
      new_hotel[:description] = merge(new_hotel, hotel, 'description')
      new_hotel[:amenities] = merge(new_hotel, hotel, 'amenities')
      new_hotel[:images] = merge(new_hotel, hotel, 'images')
      new_hotel[:booking_conditions] = merge(new_hotel, hotel, 'booking_conditions')
    end

    new_hotel
  end

  def check_and_delete_hotels
    cached_hotel_ids = $redis.keys('*')
    hotel_ids_to_delete = cached_hotel_ids - @hotel_ids

    hotel_ids_to_delete.each do |key|
      $redis.del(key)
    end
  rescue StandardError => ex
    add_error(ex)
  end

  def add_error(error)
    @errors ||= []

    if error.is_a?(StandardError)
      @errors << error
    elsif error.is_a?(Array)
      error.each { |err| add_error(err) }
    else
      @errors << StandardError.new(error)
    end
  end
end
