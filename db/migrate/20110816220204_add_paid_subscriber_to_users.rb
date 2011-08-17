class AddPaidSubscriberToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :paid_subscriber, :boolean, :default=>false
  end

  def self.down
    remove_column :users, :paid_subscriber
  end
end
