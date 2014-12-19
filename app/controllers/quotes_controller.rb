class QuotesController < ApplicationController
  include ActiveMerchant::Shipping
  rescue_from ActiveMerchant::Shipping::ResponseError, with: :no_response
  rescue_from Timeout::Error, with: :no_response

  def index

  end

  def search
    if params['package_info'] == nil || params['package_info']['dest_zip'] == nil || params['package_info']['weight'] == nil
      render json: {error: "not enough information in query"}, status: :bad_request
    else
      set_delivery_info(params['package_info'])
      usps_rates = get_usps_rates
      fedex_rates = get_fedex_rates
      render json: {usps: usps_rates, fedex: fedex_rates}, status: :ok
    end
    Request.create(request_url: request.original_url, ip_address: request.ip, params: params.to_s, response_body: response.body.to_s)
  end

  def track
    if params['carrier_name'] == "usps"
      usps = USPS.new(login: ENV['USPS_LOGIN'])
      tracking_info = usps.find_tracking_info(params['tracking_no'])
      track_array = []
      tracking_info.shipment_events.each do |event|
        track_array << [event.name, event.location.city, event.location.state, event.time]
        # puts "#{event.name} at #{event.location.city}, #{event.location.state} on #{event.time}. #{event.message}"
      end
    elsif params['carrier_name'] == "fedex"
      fedex = FedEx.new(test: true, login: ENV['FEDEX_METER'], password: ENV['FEDEX_PASSWORD'], key: ENV['FEDEX_KEY'], account: ENV['FEDEX_ACCOUNT'])
      tracking_info = fedex.find_tracking_info(params['tracking_no'])
      track_array = []
      tracking_info.shipment_events.each do |event|
        track_array << [event.name, event.location.city, event.location.state, event.time]
        # puts "#{event.name} at #{event.location.city}, #{event.location.state} on #{event.time}. #{event.message}"
      end

    end
    render json: track_array, status: :ok
  end

  def no_response
    render json: {error: "Sorry, there was an error processing your request"}, status: :request_timeout
    Request.create(request_url: request.original_url, ip_address: request.ip, params: params.to_s, response_body: response.body.to_s)

  end

  def get_usps_rates
    usps = USPS.new(login: ENV['USPS_LOGIN'])
    ups_response = usps.find_rates(@origin, @destination, @package)
    ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  end

  def set_delivery_info(package_info)
    @package = Package.new((package_info['weight'].to_i), [20, 20, 20], units: :imperial)
    @origin = Location.new(country: "US", zip: "98103")
    @destination = Location.new(country: "US", zip: package_info['dest_zip'])
  end

  def get_fedex_rates
    fedex = FedEx.new(test: true, login: ENV['FEDEX_METER'], password: ENV['FEDEX_PASSWORD'], key: ENV['FEDEX_KEY'], account: ENV['FEDEX_ACCOUNT'])
    fedex_response = fedex.find_rates(@origin, @destination, @package)
    fedex_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  end

end
