class Import < ActiveRecord::Base
	has_many :orders

	def gross_revenue
		orders.map{|o| o.total}.inject(:+)
	end
end
