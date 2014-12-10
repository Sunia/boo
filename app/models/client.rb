class Client < ActiveRecord::Base
  has_many :friends
  has_many :requests
  
end
