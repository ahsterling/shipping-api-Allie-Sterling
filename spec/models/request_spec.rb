require 'rails_helper'

describe Request do
  describe '.validations' do
    it 'is invalid without request url' do
      expect(Request.new(ip_address: "192.00.00.00")).to_not be_valid
    end

    it 'is invalid without an ip address' do
      expect(Request.new(request_url: "http://ship_it.herokuapp.com/search")).to_not be_valid
    end

    it 'is valid with a request_url and an ip address' do
      expect(Request.new(request_url: "http://ship_it.herokuapp.com/search", ip_address: "192.00.00.00" )).to be_valid
    end
  end
end
