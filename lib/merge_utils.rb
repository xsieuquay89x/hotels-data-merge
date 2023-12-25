module MergeUtils
  include Utils

  def merge(hotel, merge_hotel, key)
    data = hotel[key.to_sym]
    merge_data = merge_hotel[key.to_sym]

    case key
    when 'name'
      merge_name(data, merge_data)
    when 'amenities'
      merge_amenities(data, merge_data)
    when 'booking_conditions'
      merge_booking_conditions(data, merge_data)
    when 'images'
      merge_images(data, merge_data)
    when 'description'
      merge_description(data, merge_data)
    when 'location'
      merge_location(data, merge_data)
    else
      nil
    end
  end

  private

  def merge_amenities(data, merge_data)
    general = clean_dirty_data(data[:general], merge_data[:general])
    room = clean_dirty_data(data[:room], merge_data[:room])


     # Only keep those amenities in "room" which can not be found in "general"
    room = room.reject { |r| general.map(&:downcase).include?(r.downcase) }

    {
      general: general,
      room: room
    }
  end

  def merge_booking_conditions(data, merge_data)
    (data + merge_data)&.flatten.compact.uniq
  end

  def merge_description(data, merge_data)
    select_longer_existing_string(data, merge_data)
  end

  def merge_images(data, merge_data)
    # Iterate over all the image keys from both sources
    images = {}

    merge_data.keys.each do |key|
      value_merge_data = merge_data[key]
      value_data = data[key]
      # Select all URLs that have not been added yet.
      # After selected, add them both to the current set and the images array as well.
      images[key] = (value_data.to_a + value_merge_data.to_a).uniq { |value| value[:link] }
    end

    images
  end

  def merge_location(data, merge_data)
    {
      lat: data[:lat].presence || merge_data[:lat],
      lng:data[:lng].presence || merge_data[:lng],
      address: data[:address] || merge_data[:address],
      city: data[:city] || merge_data[:city],
      country: if data[:country].present? && merge_data[:country].present?
                 select_with_preferred_length(data[:country], merge_data[:country], 2)
               else
                 data[:country] || merge_data[:country]
               end
    }
  end

  def merge_name(data, merge_data)
    if data.present? && merge_data.present?
      return data.length > merge_data.length ? data : merge_data
    end

    data || merge_data
  end
end
