class Article < ActiveRecord::Base
  has_many :orders
  has_many :users, :through=>:orders

  attr_accessible :name, :content
end
