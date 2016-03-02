# == Schema Information
#
# Table name: voters
#
#  id                                     :integer          not null, primary key
#  vote_builder_id                        :integer
#  last_name                              :string(32)
#  first_name                             :string(32)
#  middle_name                            :string(32)
#  suffix                                 :string(30)
#  salutation                             :string(32)
#  phone                                  :string(10)
#  home_phone                             :string(10)
#  work_phone                             :string(10)
#  work_phone_ext                         :string(10)
#  cell_phone                             :string(10)
#  email                                  :string(100)
#  party                                  :string(5)
#  sex                                    :string(1)
#  age                                    :integer
#  dob                                    :date
#  dor                                    :date
#  state_file_id                          :integer          not null
#  search_index                           :string(13)
#  created_at                             :datetime
#  updated_at                             :datetime
#  address_id                             :integer
#  search_index2                          :string(12)
#  yor                                    :integer
#  presidential_primary_voting_frequency  :integer          default(0)
#  presidential_general_voting_frequency  :integer          default(0)
#  gubernatorial_primary_voting_frequency :integer          default(0)
#  gubernatorial_general_voting_frequency :integer          default(0)
#  municipal_primary_voting_frequency     :integer          default(0)
#  municipal_general_voting_frequency     :integer          default(0)
#

class Voter < ActiveRecord::Base

  PARTY_TYPES = [
    ['ALL OTHER PARTIES',	'OTH'],
    ['DEMOCRAT', 'DEM'],
    ['NO DATA', 'NDA'],
    ['OTHERS - ALLIANCE', 'OAL'],
    ['OTHERS - AMERICAN', 'OAM'],
    ['OTHERS - AMERICAN INDEPENDENT', 'OAI'],
    ['OTHERS - AMERICAN SOCIALIST', 'OAS'],
    ['OTHERS - ANARCHIST', 'OAN'],
    ['OTHERS - BULL MOOSE', 'OBM'],
    ['OTHERS - CHRISTIAN', 'OCH'],
    ['OTHERS - COMMUNIST', 'OCO'],
    ['OTHERS - CONSERVATIVE', 'OCN'],
    ['OTHERS - CONSTITUTION', 'OCS'],
    ['OTHERS - CONSTITUTIONAL', 'OCON'],
    ['OTHERS - FREE CHOICE', 'OFCH'],
    ['OTHERS - FREEDOM', 'OFR'],
    ['OTHERS - GRASS ROOTS', 'OGRT'],
    ['OTHERS - GREEN LIBERTARIAN', 'OGL'],
    ['OTHERS - INDEPENDENT', 'OID'],
    ['OTHERS - INDIVIDUALIST', 'OIN'],
    ['OTHERS - LEAGUE OF THE SOUTH', 'OLS'],
    ['OTHERS - LIBERALS', 'OLIB'],
    ['OTHERS - LIBERTARIAN', 'OLIR'],
    ['OTHERS - NATIONAL SOCIALIST', 'ONAS'],
    ['OTHERS - NATURAL LAW', 'ONL'],
    ['OTHERS - NATURAL PARTY', 'ONP'],
    ['OTHERS - PATRIOT', 'OPAT'],
    ['OTHERS - PEOPLES', 'OPE'],
    ['OTHERS - POPULIST', 'OPOP'],
    ['OTHERS - REFORM', 'ORE'],
    ['OTHERS - RIGHT-TO-LIFE', 'ORL'],
    ['OTHERS - SOCIAL DEMOCRAT', 'OSD'],
    ['OTHERS - SOCIALIST', 'OSC'],
    ['OTHERS - TAX', 'OTX'],
    ['OTHERS - TAXPAYERS', 'OTP'],
    ['OTHERS - WHIG', 'OWH'],
    ['OTHERS - WORKERS', 'OWO'],
    ['REPUBLICAN', 'REP'],
    ['UNAFFILIATED', 'UNA']
  ].freeze

  DATE_SEARCH_FIELDS =  %w{dob dor}

  #exclude some fields from ransack search  
  UNRANSACKABLE_ATTRIBUTES = ['id','vote_builder_id','address_id',
    'suffix','salutation', 'phone' 'home_phone', 'work_phone', 'work_phone_ext','dor',
    'municipal_primary_voting_frequency', 'municipal_general_voting_frequency',
    'email', 'cell_phone', 'search_index','search_index2','created_at','updated_at']

  def self.ransackable_attributes auth_object = nil
    (column_names - UNRANSACKABLE_ATTRIBUTES) + _ransackers.keys
  end

  def self.client_column_names
      ['state_file_id','first_name','middle_name','last_name','sufix','age','phone','party']
  end

  # begin associations
  belongs_to :address
  has_many :votes, class_name: 'VotingHistory', foreign_key: :state_file_id, primary_key: :state_file_id
  has_one :registered_voters_data, foreign_key: :vtrid, primary_key: :state_file_id
  # end associations

  # begin public instance methods  
	def full_name
		"#{first_name} #{middle_name} #{last_name} #{suffix}".upcase.squeeze(' ')
	end

	def printable_name
		"#{last_name}, #{first_name} #{middle_name}".upcase
	end

	def build_search
		first_four = self.first_name.to_s.strip.upcase.gsub(/[^A-Z]/,'')[0,4].ljust(4,'X') rescue ''
		second_four = self.last_name.to_s.strip.upcase.gsub(/[^A-Z]/,'')[0,4].ljust(4,'X') rescue ''
		all = self.address.street_no.to_s.strip.upcase rescue ''
		first_four+second_four+all
	end

	def build_search2
		first_four = self.first_name.to_s.strip.upcase.gsub(/[^A-Z]/,'')[0,4].ljust(4,'X') rescue ''
		second_four = self.last_name.to_s.strip.upcase.gsub(/[^A-Z]/,'')[0,4].ljust(4,'X') rescue ''
		last_four = "#{self.dob.month.to_s.rjust(2,'0')}#{self.dob.day.to_s.rjust(2,'0')}" rescue "0000"
		first_four+second_four+last_four
	end
  
  # end public instance methods
  
  # begin public class methods
  def self.to_csv(options = {}, to_file = false, version = :admin)
    if to_file == true
      tempfile = Tempfile.new(["voters-export-#{Time.now.to_i}",".xls"])
      CSV.open(tempfile.path, "wb") do |csv|
        csv << (column_names + Address.column_names) if version == :admin
        csv << (client_column_names + Address.client_column_names) if version == :client
        all.includes(:address).find_each do |voter|
          csv << (voter.attributes.values_at(*column_names) + voter.address.attributes.values_at(*Address.column_names)) if version == :admin
          csv << (voter.attributes.values_at(*client_column_names) + voter.address.attributes.values_at(*Address.client_column_names)) if version == :client
        end
      end
      return File.new(tempfile.path, "r")
    else
      CSV.generate(options) do |csv|
        csv << (column_names + Address.column_names)
        all.includes(:address).find_each do |voter|
          csv << (voter.attributes.values_at(*column_names) + voter.address.attributes.values_at(*Address.column_names))
        end
      end
    end
  end
  # end public class methods

  def self.build_search_index(first_name, last_name, street_no)
		first_four = first_name.to_s.strip.upcase.gsub(/[^A-Z]/,'')[0,4].ljust(4,'X') rescue ''
		second_four = last_name.to_s.strip.upcase.gsub(/[^A-Z]/,'')[0,4].ljust(4,'X') rescue ''
		all = street_no.to_s.strip.upcase rescue ''
		first_four+second_four+all
  end

  def self.build_search_index2(first_name, last_name, dob)
		first_four = first_name.to_s.strip.upcase.gsub(/[^A-Z]/,'')[0,4].ljust(4,'X') rescue ''
		second_four = last_name.to_s.strip.upcase.gsub(/[^A-Z]/,'')[0,4].ljust(4,'X') rescue ''
		last_four = "#{dob.month.to_s.rjust(2,'0')}#{dob.day.to_s.rjust(2,'0')}" rescue "0000"
		first_four+second_four+last_four
  end

  def self.build_search_indexes2_by_batch(voter_ids)
    Voter.where(id: voter_ids).each do |voter|
      voter.update_attribute(:search_index2, voter.build_search2)    
    end
  end

  def self.build_search_indexes_by_batch(voter_ids)
    Voter.where(id: voter_ids).each do |voter|
      voter.update_attribute(:search_index, voter.build_search)    
    end
  end

  def self.build_search_indexes
    Voter.select(:id).where(search_index: nil).find_in_batches(:batch_size => 1000) do |batch|
      Voter.delay.build_search_indexes_by_batch(batch.map(&:id))
    end
  end

  def self.build_search_indexes2
    Voter.select(:id).where(search_index2: nil).find_in_batches(:batch_size => 1000) do |batch|
      Voter.delay.build_search_indexes2_by_batch(batch.map(&:id))
    end
  end
 
  def self.update_age
    ActiveRecord::Base.connection.execute("UPDATE voters SET age = date_part('year', age(voters.dob))", :skip_logging)
  end

  def self.link_addresses_from_registered_voters_data
    query = %{
      UPDATE voters 
        SET address_id = result.address_id
      FROM
        (SELECT addresses.id as address_id, voters.id as voter_id FROM registered_voters_data 
          INNER JOIN voters on voters.state_file_id = registered_voters_data.vtrid::int 
          INNER JOIN addresses ON addresses.address_hash = registered_voters_data.address_hash
          WHERE registered_voters_data.address_hash IS NOT NULL) AS result
      WHERE voters.id = result.voter_id}
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end
  
  def self.correct_address_links
    query = %{
      UPDATE voters SET address_id = result.a1_id
      FROM
      (SELECT a1.id as a1_id, a1.zip4, a2.id as a2_id FROM addresses a1
      INNER JOIN addresses a2 ON a2.id != a1.id 
      AND COALESCE(a2.street_no,'') = COALESCE(a1.street_no,'')
      AND COALESCE(a2.street_no_half,'') = COALESCE(a1.street_no_half, '')
      AND COALESCE(a2.street_prefix,'') = COALESCE(a1.street_prefix,'')
      AND COALESCE(a2.street_name,'') = COALESCE(a1.street_name,'')
      AND COALESCE(a2.street_type,'') = COALESCE(a1.street_type,'')
      AND COALESCE(a2.street_suffix,'') = COALESCE(a1.street_suffix,'')
      AND COALESCE(a2.apt_type,'') = COALESCE(a1.apt_type,'')
      AND COALESCE(a2.apt_no,'') = COALESCE(a1.apt_no,'')
      AND COALESCE(a2.city,'') = COALESCE(a1.city,'')
      AND COALESCE(a2.state,'') = COALESCE(a1.state,'')
      AND COALESCE(a2.zip5,'') = COALESCE(a1.zip5,'')
      AND COALESCE(a2.zip4,'') != COALESCE(a1.zip4,'')
      WHERE 
      COALESCE(a1.zip4,'') != '') as result
      WHERE voters.address_id = result.a2_id
    }
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end

  def self.delete_unused_addresses
    query = %{
      DELETE FROM addresses a
      WHERE
      NOT EXISTS (SELECT voters.id from voters WHERE voters.address_id = a.id)
    }
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end

  def self.link_addresses_from_van_data
    query = %{
      UPDATE voters 
        SET address_id = result.address_id
      FROM
        (SELECT addresses.id as address_id, voters.id as voter_id FROM van_data 
          INNER JOIN voters on voters.state_file_id = van_data.state_file_id 
          INNER JOIN addresses ON addresses.address_hash = van_data.address_hash
          WHERE voters.address_id IS NULL AND van_data.address_hash IS NOT NULL) AS result
      WHERE voters.id = result.voter_id}
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end
  # end public class methods
end
