module Utils
  def select_data(object, keys)
    keys.each do |key|
      data = object[key]
      return data if data
    end; nil
  end

  def select_with_preferred_length(str1, str2, preferred_length)
    return str1.upcase if str1&.length == preferred_length
    return str2.upcase if str2&.length == preferred_length

    str1 || str2
  end

  def select_longer_existing_string(str1, str2)
    if str1.present? && str2.present?
      return str1 if str1.length > str2.length
      return str2 if str1.length < str2.length
    end

    str1 || str2
  end

  def clean_dirty_data(arr1, arr2)
    arr = create_unique_array(arr1, arr2)
    arr = unique_case_insensitive(arr)
    occurrences = Hash.new(0)

    normalized_all = arr.map { |a| a.gsub(/\s+/, '') }

    normalized_all.each { |a| occurrences[a] += 1 }
    normalized_selected = normalized_all.select { |a| occurrences[a] >= 2 }

    arr.reject{ |a| normalized_selected.include?(a)}
  end

  def create_unique_array(arr1, arr2)
    (arr1.to_a + arr2.to_a).uniq
  end

  def unique_case_insensitive(array)
    array.map(&:downcase)&.flatten.compact.uniq
  end
end