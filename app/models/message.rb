class Message < ActiveRecord::Base

	belongs_to :customer 
	belongs_to :agent

end
