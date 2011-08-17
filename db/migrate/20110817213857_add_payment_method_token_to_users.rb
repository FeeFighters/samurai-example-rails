class AddPaymentMethodTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :payment_method_token, :string
  end

  def self.down
    remove_column :users, :payment_method_token
  end
end
