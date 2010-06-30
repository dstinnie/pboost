# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100630174611) do

  create_table "account_types", :force => true do |t|
    t.column "name", :string, :limit => 100, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "account_types", ["name"], :name => "index_account_types_on_name", :unique => true

  create_table "addresses", :force => true do |t|
    t.column "street_no", :string, :limit => 5
    t.column "street_no_half", :string, :limit => 3
    t.column "street_prefix", :string, :limit => 2
    t.column "street_name", :string, :limit => 32
    t.column "street_type", :string, :limit => 4
    t.column "street_suffix", :string, :limit => 2
    t.column "apt_type", :string, :limit => 5
    t.column "apt_no", :string, :limit => 8
    t.column "city", :string, :limit => 32
    t.column "state", :string, :limit => 2
    t.column "zip5", :string, :limit => 5
    t.column "zip4", :string, :limit => 4
    t.column "county_name", :string, :limit => 32
    t.column "precinct_name", :string, :limit => 32
    t.column "precinct_code", :string, :limit => 32
    t.column "cd", :string, :limit => 3
    t.column "sd", :string, :limit => 3
    t.column "hd", :string, :limit => 3
    t.column "comm_dist_code", :string, :limit => 2
    t.column "lat", :decimal, :precision => 15, :scale => 10
    t.column "lng", :decimal, :precision => 15, :scale => 10
    t.column "geo_failed", :boolean
    t.column "address_hash", :string, :limit => 32
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "geom", :point, :srid => 4326
    t.column "mcomm_dist_code", :string, :limit => 2
    t.column "is_odd", :boolean
    t.column "street_no_int", :integer
  end

  add_index "addresses", ["address_hash"], :name => "index_addresses_on_address_hash", :unique => true
  add_index "addresses", ["cd"], :name => "index_addresses_on_cd"
  add_index "addresses", ["city"], :name => "index_addresses_on_city"
  add_index "addresses", ["comm_dist_code"], :name => "index_addresses_on_comm_dist_code"
  add_index "addresses", ["county_name"], :name => "index_addresses_on_county_name"
  add_index "addresses", ["geom"], :name => "index_addresses_on_geom", :spatial=> true 
  add_index "addresses", ["hd"], :name => "index_addresses_on_hd"
  add_index "addresses", ["id"], :name => "index_addresses_on_id"
  add_index "addresses", ["is_odd"], :name => "index_addresses_on_is_odd"
  add_index "addresses", ["lat", "lng"], :name => "index_addresses_on_lat_and_lng"
  add_index "addresses", ["precinct_code"], :name => "index_addresses_on_precinct_code"
  add_index "addresses", ["sd"], :name => "index_addresses_on_sd"
  add_index "addresses", ["state"], :name => "index_addresses_on_state"

  create_table "addresses_gis_regions", :id => false, :force => true do |t|
    t.column "address_id", :integer, :null => false
    t.column "gis_region_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "addresses_gis_regions", ["address_id"], :name => "index_addresses_gis_regions_on_address_id"
  add_index "addresses_gis_regions", ["address_id", "gis_region_id"], :name => "index_addresses_gis_regions_on_address_id_and_gis_region_id", :unique => true
  add_index "addresses_gis_regions", ["gis_region_id"], :name => "index_addresses_gis_regions_on_gis_region_id"

  create_table "cities", :force => true do |t|
    t.column "name", :string, :limit => 64, :null => false
    t.column "state_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "lat", :decimal, :precision => 15, :scale => 10
    t.column "lng", :decimal, :precision => 15, :scale => 10
  end

  add_index "cities", ["name"], :name => "index_cities_on_name"
  add_index "cities", ["name", "state_id"], :name => "index_cities_on_name_and_state_id", :unique => true
  add_index "cities", ["state_id"], :name => "index_cities_on_state_id"

  create_table "cities_counties", :id => false, :force => true do |t|
    t.column "city_id", :integer, :null => false
    t.column "county_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "cities_counties", ["city_id"], :name => "index_cities_counties_on_city_id"
  add_index "cities_counties", ["county_id"], :name => "index_cities_counties_on_county_id"

  create_table "cities_municipal_districts", :id => false, :force => true do |t|
    t.column "city_id", :integer, :null => false
    t.column "municipal_district_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "cities_municipal_districts", ["city_id"], :name => "index_cities_municipal_districts_on_city_id"
  add_index "cities_municipal_districts", ["municipal_district_id"], :name => "index_cities_municipal_districts_on_municipal_district_id"

  create_table "congressional_districts", :force => true do |t|
    t.column "cd", :string, :limit => 3, :null => false
    t.column "state_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "congressional_districts", ["cd", "state_id"], :name => "index_congressional_districts_on_state_id_and_cd", :unique => true

  create_table "constituent_addresses", :force => true do |t|
    t.column "political_campaign_id", :integer
    t.column "address_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "constituent_addresses", ["address_id"], :name => "index_constituent_addresses_on_address_id"
  add_index "constituent_addresses", ["political_campaign_id"], :name => "index_constituent_addresses_on_political_campaign_id"

  create_table "constituents", :force => true do |t|
    t.column "political_campaign_id", :integer, :null => false
    t.column "voter_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "constituents", ["political_campaign_id"], :name => "index_constituents_on_political_campaign_id"
  add_index "constituents", ["political_campaign_id", "voter_id"], :name => "index_constituents_on_political_campaign_id_and_voter_id", :unique => true
  add_index "constituents", ["voter_id"], :name => "index_constituents_on_voter_id"

  create_table "council_districts", :force => true do |t|
    t.column "code", :string, :limit => 3, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "council_districts", ["code"], :name => "index_council_districts_on_code", :unique => true

  create_table "council_districts_counties", :id => false, :force => true do |t|
    t.column "county_id", :integer, :null => false
    t.column "council_district_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "council_districts_counties", ["council_district_id"], :name => "index_council_districts_counties_on_council_district_id"
  add_index "council_districts_counties", ["county_id"], :name => "index_council_districts_counties_on_county_id"

  create_table "counties", :force => true do |t|
    t.column "name", :string, :limit => 64, :null => false
    t.column "state_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "lat", :decimal, :precision => 15, :scale => 10
    t.column "lng", :decimal, :precision => 15, :scale => 10
  end

  add_index "counties", ["name"], :name => "index_counties_on_name"
  add_index "counties", ["name", "state_id"], :name => "index_counties_on_state_id_and_name", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.column "priority", :integer, :default => 0
    t.column "attempts", :integer, :default => 0
    t.column "handler", :text
    t.column "last_error", :text
    t.column "run_at", :datetime
    t.column "locked_at", :datetime
    t.column "failed_at", :datetime
    t.column "locked_by", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "elections", :force => true do |t|
    t.column "description", :string, :limit => 32, :null => false
    t.column "year", :integer, :null => false
    t.column "election_type", :string, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "elections", ["description"], :name => "index_elections_on_description", :unique => true
  add_index "elections", ["year", "election_type"], :name => "index_elections_on_year_and_election_type", :unique => true

  create_table "filters", :force => true do |t|
    t.column "type", :string, :limit => 64, :null => false
    t.column "string_val", :string, :limit => 64
    t.column "int_val", :integer
    t.column "max_int_val", :integer
    t.column "walksheet_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "filters", ["id"], :name => "index_filters_on_id", :unique => true
  add_index "filters", ["type"], :name => "index_filters_on_type"

# Could not dump table "geography_columns" because of following StandardError
#   Unknown type 'name' for column 'f_table_catalog' /home/mark/Work/pboost/vendor/gems/postgis_adapter-0.7.8/lib/postgis_adapter/common_spatial_adapter.rb:52:in `table'/home/mark/Work/pboost/vendor/gems/postgis_adapter-0.7.8/lib/postgis_adapter/common_spatial_adapter.rb:50:in `each'/home/mark/Work/pboost/vendor/gems/postgis_adapter-0.7.8/lib/postgis_adapter/common_spatial_adapter.rb:50:in `table'/usr/lib/ruby/gems/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:72:in `tables'/usr/lib/ruby/gems/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:63:in `each'/usr/lib/ruby/gems/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:63:in `tables'/usr/lib/ruby/gems/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:25:in `dump'/usr/lib/ruby/gems/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:19:in `dump'/usr/lib/ruby/gems/1.8/gems/rails-2.3.8/lib/tasks/databases.rake:256/usr/lib/ruby/gems/1.8/gems/rails-2.3.8/lib/tasks/databases.rake:255:in `open'/usr/lib/ruby/gems/1.8/gems/rails-2.3.8/lib/tasks/databases.rake:255/usr/lib/ruby/1.8/rake.rb:636:in `call'/usr/lib/ruby/1.8/rake.rb:636:in `execute'/usr/lib/ruby/1.8/rake.rb:631:in `each'/usr/lib/ruby/1.8/rake.rb:631:in `execute'/usr/lib/ruby/1.8/rake.rb:597:in `invoke_with_call_chain'/usr/lib/ruby/1.8/monitor.rb:242:in `synchronize'/usr/lib/ruby/1.8/rake.rb:590:in `invoke_with_call_chain'/usr/lib/ruby/1.8/rake.rb:583:in `invoke'/usr/lib/ruby/gems/1.8/gems/rails-2.3.8/lib/tasks/databases.rake:113/usr/lib/ruby/1.8/rake.rb:636:in `call'/usr/lib/ruby/1.8/rake.rb:636:in `execute'/usr/lib/ruby/1.8/rake.rb:631:in `each'/usr/lib/ruby/1.8/rake.rb:631:in `execute'/usr/lib/ruby/1.8/rake.rb:597:in `invoke_with_call_chain'/usr/lib/ruby/1.8/monitor.rb:242:in `synchronize'/usr/lib/ruby/1.8/rake.rb:590:in `invoke_with_call_chain'/usr/lib/ruby/1.8/rake.rb:583:in `invoke'/usr/lib/ruby/1.8/rake.rb:2051:in `invoke_task'/usr/lib/ruby/1.8/rake.rb:2029:in `top_level'/usr/lib/ruby/1.8/rake.rb:2029:in `each'/usr/lib/ruby/1.8/rake.rb:2029:in `top_level'/usr/lib/ruby/1.8/rake.rb:2068:in `standard_exception_handling'/usr/lib/ruby/1.8/rake.rb:2023:in `top_level'/usr/lib/ruby/1.8/rake.rb:2001:in `run'/usr/lib/ruby/1.8/rake.rb:2068:in `standard_exception_handling'/usr/lib/ruby/1.8/rake.rb:1998:in `run'/usr/bin/rake:28

  create_table "gis_regions", :force => true do |t|
    t.column "name", :string, :limit => 128, :null => false
    t.column "political_campaign_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "geom", :polygon, :srid => 4326, :null => false
    t.column "voter_count", :integer, :default => 0
    t.column "populated", :boolean, :default => false
  end

  add_index "gis_regions", ["geom"], :name => "index_gis_regions_on_geom", :spatial=> true 
  add_index "gis_regions", ["name", "political_campaign_id"], :name => "index_gis_regions_on_name_and_political_campaign_id", :unique => true
  add_index "gis_regions", ["political_campaign_id"], :name => "index_gis_regions_on_political_campaign_id"

  create_table "gis_regions_voters", :id => false, :force => true do |t|
    t.column "gis_region_id", :integer, :null => false
    t.column "voter_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "gis_regions_voters", ["gis_region_id"], :name => "index_gis_regions_voters_on_gis_region_id"
  add_index "gis_regions_voters", ["gis_region_id", "voter_id"], :name => "index_gis_regions_voters_on_gis_region_id_and_voter_id", :unique => true
  add_index "gis_regions_voters", ["voter_id"], :name => "index_gis_regions_voters_on_voter_id"

  create_table "house_districts", :force => true do |t|
    t.column "hd", :string, :limit => 3, :null => false
    t.column "state_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "house_districts", ["hd", "state_id"], :name => "index_house_districts_on_state_id_and_hd", :unique => true

  create_table "municipal_districts", :force => true do |t|
    t.column "code", :string, :limit => 3, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "municipal_districts", ["code"], :name => "index_municipal_districts_on_code", :unique => true

  create_table "organization_types", :force => true do |t|
    t.column "name", :string, :limit => 100, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "organization_types", ["name"], :name => "index_organization_types_on_name", :unique => true

  create_table "organizations", :force => true do |t|
    t.column "organization_type_id", :integer
    t.column "name", :string, :limit => 100, :null => false
    t.column "email", :string, :limit => 125
    t.column "phone", :string, :limit => 10
    t.column "fax", :string, :limit => 10
    t.column "website", :string, :limit => 150
    t.column "account_type_id", :integer
    t.column "enabled", :boolean, :default => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "organizations", ["email"], :name => "index_organizations_on_email", :unique => true

  create_table "parties", :force => true do |t|
    t.column "code", :string, :limit => 1, :null => false
    t.column "name", :string, :limit => 32, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "parties", ["code"], :name => "index_parties_on_code", :unique => true
  add_index "parties", ["name"], :name => "index_parties_on_name", :unique => true

  create_table "political_campaigns", :force => true do |t|
    t.column "candidate_name", :string, :limit => 64
    t.column "seat_sought", :string, :limit => 128
    t.column "state_id", :integer, :null => false
    t.column "type", :string, :limit => 20
    t.column "seat_type", :string, :limit => 20
    t.column "congressional_district_id", :integer
    t.column "senate_district_id", :integer
    t.column "house_district_id", :integer
    t.column "county_id", :integer
    t.column "countywide", :boolean, :null => false
    t.column "council_district_id", :integer
    t.column "city_id", :integer
    t.column "muniwide", :boolean, :null => false
    t.column "organization_id", :integer
    t.column "municipal_district_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "constituent_count", :integer, :default => 0
    t.column "populated", :boolean, :default => false
  end

  add_index "political_campaigns", ["city_id"], :name => "index_political_campaigns_on_city_id"
  add_index "political_campaigns", ["congressional_district_id"], :name => "index_political_campaigns_on_congressional_district_id"
  add_index "political_campaigns", ["council_district_id"], :name => "index_political_campaigns_on_council_district_id"
  add_index "political_campaigns", ["county_id"], :name => "index_political_campaigns_on_county_id"
  add_index "political_campaigns", ["house_district_id"], :name => "index_political_campaigns_on_house_district_id"
  add_index "political_campaigns", ["municipal_district_id"], :name => "index_political_campaigns_on_municipal_district_id"
  add_index "political_campaigns", ["organization_id"], :name => "index_political_campaigns_on_organization_id"
  add_index "political_campaigns", ["senate_district_id"], :name => "index_political_campaigns_on_senate_district_id"

  create_table "precincts", :force => true do |t|
    t.column "name", :string, :limit => 32, :null => false
    t.column "code", :string, :limit => 32, :null => false
    t.column "county_id", :integer
    t.column "congressional_district_id", :integer
    t.column "senate_district_id", :integer
    t.column "house_district_id", :integer
    t.column "council_district_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "state_id", :integer
  end

  add_index "precincts", ["code"], :name => "index_precincts_on_code"
  add_index "precincts", ["code", "congressional_district_id"], :name => "index_precincts_on_code_and_congressional_district_id", :unique => true
  add_index "precincts", ["council_district_id", "code"], :name => "index_precincts_on_code_and_council_district_id", :unique => true
  add_index "precincts", ["county_id", "code"], :name => "index_precincts_on_code_and_county_id", :unique => true
  add_index "precincts", ["house_district_id", "code"], :name => "index_precincts_on_code_and_house_district_id", :unique => true
  add_index "precincts", ["code", "senate_district_id"], :name => "index_precincts_on_code_and_senate_district_id", :unique => true
  add_index "precincts", ["congressional_district_id"], :name => "index_precincts_on_congressional_district_id"
  add_index "precincts", ["council_district_id"], :name => "index_precincts_on_council_district_id"
  add_index "precincts", ["county_id"], :name => "index_precincts_on_county_id"
  add_index "precincts", ["house_district_id"], :name => "index_precincts_on_house_district_id"
  add_index "precincts", ["name"], :name => "index_precincts_on_name"
  add_index "precincts", ["name", "code"], :name => "index_precincts_on_name_and_code", :unique => true
  add_index "precincts", ["senate_district_id"], :name => "index_precincts_on_senate_district_id"
  add_index "precincts", ["state_id"], :name => "index_precincts_on_state_id"

  create_table "roles", :force => true do |t|
    t.column "name", :string, :limit => 50
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.column "role_id", :integer, :null => false
    t.column "user_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "senate_districts", :force => true do |t|
    t.column "sd", :string, :limit => 3, :null => false
    t.column "state_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "senate_districts", ["sd", "state_id"], :name => "index_senate_districts_on_state_id_and_sd", :unique => true

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string, :null => false
    t.column "data", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.column "abbrev", :string, :limit => 2, :null => false
    t.column "name", :string, :limit => 100, :null => false
    t.column "active", :boolean, :default => true
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "lat", :decimal, :precision => 15, :scale => 10
    t.column "lng", :decimal, :precision => 15, :scale => 10
  end

  add_index "states", ["abbrev"], :name => "index_states_on_abbrev", :unique => true
  add_index "states", ["name"], :name => "index_states_on_name", :unique => true

  create_table "time_zones", :force => true do |t|
    t.column "zone", :string, :limit => 64, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "time_zones", ["zone"], :name => "index_time_zones_on_zone", :unique => true

  create_table "users", :force => true do |t|
    t.column "login", :string, :limit => 100, :null => false
    t.column "email", :string, :limit => 100, :null => false
    t.column "first_name", :string, :limit => 32, :null => false
    t.column "last_name", :string, :limit => 32, :null => false
    t.column "phone", :string, :limit => 10
    t.column "crypted_password", :string
    t.column "password_salt", :string
    t.column "persistence_token", :string, :null => false
    t.column "perishable_token", :string, :null => false
    t.column "active", :boolean, :default => false, :null => false
    t.column "login_count", :integer, :default => 0, :null => false
    t.column "failed_login_count", :integer, :default => 0, :null => false
    t.column "last_request_at", :datetime
    t.column "current_login_at", :datetime
    t.column "last_login_at", :datetime
    t.column "current_login_ip", :string
    t.column "last_login_ip", :string
    t.column "time_zone_id", :integer
    t.column "organization_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["organization_id"], :name => "index_users_on_organization_id"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token", :unique => true

  create_table "voters", :force => true do |t|
    t.column "vote_builder_id", :integer, :limit => 8
    t.column "last_name", :string, :limit => 32
    t.column "first_name", :string, :limit => 32
    t.column "middle_name", :string, :limit => 32
    t.column "suffix", :string, :limit => 4
    t.column "salutation", :string, :limit => 32
    t.column "phone", :string, :limit => 10
    t.column "home_phone", :string, :limit => 10
    t.column "work_phone", :string, :limit => 10
    t.column "work_phone_ext", :string, :limit => 10
    t.column "cell_phone", :string, :limit => 10
    t.column "email", :string, :limit => 50
    t.column "party", :string, :limit => 1
    t.column "sex", :string, :limit => 1
    t.column "age", :integer, :limit => 2
    t.column "dob", :date
    t.column "dor", :date
    t.column "state_file_id", :string, :limit => 10
    t.column "address_id", :integer
    t.column "search_index", :string, :limit => 13
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "voters", ["address_id"], :name => "index_voters_on_address_id"
  add_index "voters", ["age"], :name => "index_voters_on_age"
  add_index "voters", ["id"], :name => "index_voters_on_id"
  add_index "voters", ["party"], :name => "index_voters_on_party"
  add_index "voters", ["search_index"], :name => "index_voters_on_search_index"
  add_index "voters", ["sex"], :name => "index_voters_on_sex"
  add_index "voters", ["vote_builder_id"], :name => "index_voters_on_vote_builder_id", :unique => true

  create_table "voting_history_voters", :force => true do |t|
    t.column "election_year", :integer
    t.column "election_month", :integer
    t.column "election_type", :string, :limit => 2
    t.column "voter_type", :string, :limit => 1
    t.column "voter_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "voting_history_voters", ["voter_id"], :name => "index_voting_history_voters_on_voter_id"

  create_table "walksheet_addresses", :force => true do |t|
    t.column "walksheet_id", :integer
    t.column "address_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "walksheet_addresses", ["address_id"], :name => "index_walksheet_addresses_on_address_id"
  add_index "walksheet_addresses", ["walksheet_id"], :name => "index_walksheet_addresses_on_walksheet_id"
  add_index "walksheet_addresses", ["walksheet_id", "address_id"], :name => "index_walksheet_addresses_on_walksheet_id_and_address_id", :unique => true

  create_table "walksheet_voters", :force => true do |t|
    t.column "walksheet_id", :integer
    t.column "voter_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "walksheet_voters", ["voter_id"], :name => "index_walksheet_voters_on_voter_id"
  add_index "walksheet_voters", ["walksheet_id"], :name => "index_walksheet_voters_on_walksheet_id"
  add_index "walksheet_voters", ["walksheet_id", "voter_id"], :name => "index_walksheet_voters_on_walksheet_id_and_voter_id", :unique => true

  create_table "walksheets", :force => true do |t|
    t.column "name", :string, :limit => 100, :null => false
    t.column "constituent_count", :integer
    t.column "populated", :boolean, :default => false
    t.column "political_campaign_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "walksheets", ["name"], :name => "index_walksheets_on_name"
  add_index "walksheets", ["name", "political_campaign_id"], :name => "index_walksheets_on_political_campaign_id_and_name", :unique => true

end
