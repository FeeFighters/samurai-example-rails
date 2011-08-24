class User < ActiveRecord::Base
  has_many :orders
  has_many :articles, :through => :orders  
end
