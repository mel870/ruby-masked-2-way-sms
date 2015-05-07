class Customer < ActiveRecord::Base

	has_many :messages
	belongs_to :agent

end
