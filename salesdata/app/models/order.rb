class Order < ActiveRecord::Base
  belongs_to :purchaser
  belongs_to :item
end
