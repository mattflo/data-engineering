class Order < ActiveRecord::Base
  belongs_to :purchaser
  belongs_to :item

  def total
  	quantity * item.price
  end
end
