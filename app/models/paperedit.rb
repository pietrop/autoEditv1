class Paperedit < ActiveRecord::Base
	 has_many :papercuts
	has_many :lines , through: :papercuts
	# accepts_nested_attributes_for :line #
	# def lines
	# 	p = Papercut.find(self.id)
		
	# end 
end
