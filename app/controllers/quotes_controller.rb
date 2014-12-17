class QuotesController < ApplicationController
  include ActiveMerchant::Shipping

  def search
    if params['package_info'] == nil
      render json: {error: "bad request"}, status: :bad_request
    else
      set_delivery_info(params['package_info'])
      usps_rates = get_usps_rates
      # package = Package.new(params['package_info']['weight'].to_i, [20, 20, 20])
      # destination = Location.new(
      #                        country: "US",
      #                       #  state: params['package_info']['dest_state'],
      #                       #  city: params['package_info']['dest_city'],
      #                        zip: params['package_info']['dest_zip']
      #                            )
      # origin = Location.new(country: "US",
      #                       state: "WA",
      #                       city: "Seattle",
      #                       zip: "98103"
      #                       )
      # usps = USPS.new(login: ENV['USPS_LOGIN'])
      # ups_response = usps.find_rates(origin, destination, package)
      # ups_rates = ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

      # response = {'usps' => "blah", 'ups' => "blah", 'fedex' => 'blah'}
      render json: {ups: usps_rates, fedex: "blah", usps: "blah"}
    end
  end

  def get_usps_rates
    usps = USPS.new(login: ENV['USPS_LOGIN'])
    ups_response = usps.find_rates(@origin, @destination, @package)
    ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  end

  def set_delivery_info(package_info)
    @package = Package.new(package_info['weight'].to_i, [20, 20, 20])
    @origin = Location.new(country: "US", zip: "98103")
    @destination = Location.new(country: "US", zip: package_info['dest_zip'])
  end

end
