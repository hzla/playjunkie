class User < ApplicationRecord
  include Clearance::User
  has_many :authorizations



  def self.create_from_facebook auth_hash
		profile = auth_hash['info']
		fb_token = auth_hash.credentials.token
		user = User.new name: profile['name'], profile_pic_url: profile['image'], email: profile['email']
    user.authorizations.build :unique_id => auth_hash["uid"]
    binding.pry
    user if user.save(validate: false)
	end	
end
