class AddAmountToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :amount, :float
  end

  def self.down
    remove_column :articles, :amount
  end
end
