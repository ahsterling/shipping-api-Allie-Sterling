class Request < ActiveRecord::Base
  validates :request_url, :ip_address, presence: true
end
