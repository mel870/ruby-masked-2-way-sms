class Agent < ActiveRecord::Base

	has_many :messages
	has_many :customers

end
