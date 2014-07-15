# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  abbrev     :string(2)        not null
#  name       :string(100)      not null
#  active     :boolean          default(TRUE), not null
#  lat        :decimal(15, 10)
#  lng        :decimal(15, 10)
#  created_at :datetime
#  updated_at :datetime
#

class State < ActiveRecord::Base
end
