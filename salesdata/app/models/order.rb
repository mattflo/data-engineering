class Order < ActiveRecord::Base
  belongs_to :purchaser
  belongs_to :item
  belongs_to :import

  def total
  	quantity * item.price
  end
end
