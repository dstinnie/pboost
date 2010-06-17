class HouseDistrict < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'house_districts.hd'

	#====== ASSOCIATIONS ======
	belongs_to :state
	has_many :precincts
	
	#===== CLASS METHODS ======
	def self.to_json(hds)
		s = "{\"\" : \"Please choose\",\n"
		hds.each do |hd|
			s += "\"#{hd.id}\" : \"#{hd.hd}\",\n"
		end
		s = s[0,s.length-2]
		s += "}"
	end

end
