class HotelsController < ApplicationController
  def index
    json_response(hotels) if hotels.present?
    json_response(message: 'Could not find Hotels', status: :not_found) if hotels.blank?
  rescue StandardError => ex
    json_response(message: 'Not Found: ' + ex.message, status: :not_found)
  end

  def show
    json_response(hotels) if hotels.present?
    json_response(message: 'Could not find Hotels with id = ' + params[:id], status: :not_found) if hotels.blank?
  rescue StandardError => ex
    json_response(message: 'Not Found: ' + ex.message, status: :not_found)
  end

  def create
    service = CollectHotelService.new
    service.call

    if service.success?
      json_response(message: 'Collect Hotels Success', status: :created)
    else
      json_response(message: service.errors.first&.message, status: :error)
    end
  rescue StandardError => ex
    json_response(message: ex.message, status: :error)
  end

  private

  def hotels
    return @hotels if defined? @hotels

    @hotels = []
    service = HotelService.new

    if params[:id].present?
      params[:id].split(/,/).each do |id|
        hotel = service.get_hotel(id)
        @hotels << hotel if hotel.present?
      end
    else
      @hotels = service.get_hotels
    end

    @hotels
  end
end
