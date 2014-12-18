require 'rails_helper'

describe QuotesController do
  describe 'GET "search"' do

    it 'creates a request instance and saves it to the database' do
      requests = Request.all.count
      get :search, package_info: {weight: 123, dest_zip: "98103"}
      expect(Request.all.count).to eq requests + 1
    end

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

      it 'usps key has value of array' do
        get :search, package_info: {weight: 123, dest_zip: "98103"}
        usps_array = JSON.parse(response.body)['usps']
        expect(usps_array.class).to eq Array
      end

      it 'has the key of "fedex"' do
        get :search, package_info: {weight: 123, dest_zip: "98103"}
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key "fedex"
      end

      it 'fedex key has value of array' do
        get :search, package_info: {weight: 123, dest_zip: "98103"}
        fedex_array = JSON.parse(response.body)['fedex']
        expect(fedex_array.class).to eq Array
      end
    end

    context 'unsuccessful search' do

      it 'returns a 400 without a query' do
        get :search
        expect(response.status).to eq 400
      end

      it 'returns an error message when there is no weight' do
        get :search, package_info: {dest_zip: "98103"}
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key "error"
      end

      it 'returns an error message when there is no dest_zip' do
        get :search, package_info: {weight: 47382}
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key "error"
      end
    end
  end
end
