class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :request_url
      t.text :params
      t.text :response_body
      t.string :ip_address

      t.timestamps
    end
  end
end
