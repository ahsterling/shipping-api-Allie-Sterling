require 'rails_helper'

describe QuotesController do
  describe 'GET "search"' do

    context "successful search" do
      it 'is successful with a query' do
        get :search, package_info: {weight: "123", dest_zip: "98103"}
        expect(response.status).to eq 200
      end

      it 'has the key of "usps"' do
        get :search, package_info: {weight: 123, dest_zip: "98103"}
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key "usps"
      end

      it 'has the key of "ups"' do
        get :search, package_info: {weight: 123, dest_zip: "98103"}
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key "ups"
      end

      it 'has the key of "fedex"' do
        get :search, package_info: {weight: 123, dest_zip: "98103"}
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key "fedex"

      end
    end

    context 'unsuccessful search' do

      it 'returns a 400 without a query' do
        get :search
        expect(response.status).to eq 400
      end
    end
  end
end
