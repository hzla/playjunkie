class User < ApplicationRecord
  include Clearance::User
  has_many :authorizations, dependent: :destroy
  has_many :quizzes

  def self.create_from_facebook auth_hash
		profile = auth_hash['info']
		fb_token = auth_hash.credentials.token
		user = User.new name: profile['name'], profile_pic_url: profile['image'], email: profile['email']
    user.authorizations.build :unique_id => auth_hash["uid"]
    user if user.save(validate: false)
	end	

  def self.generate_code
    random = (48..122).map {|x| x.chr}
    characters = (random - random[43..48] - random[10..16])
    code = characters.map {|c| characters.sample}
    code.join[0..15]
  end

  def password_optional?
    true
  end

  def profile_pic
    profile_pic_url or '/assets/facebook.svg'
  end

  def is_facebook_user?
    !Authorization.where(user_id: id).empty?
  end
end
