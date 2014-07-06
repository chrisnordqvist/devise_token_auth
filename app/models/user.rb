class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable,
        :confirmable

  serialize :tokens, JSON

  def valid_token?(client_id, token)
    return false unless self.tokens[client_id]['expiry'] > 2.weeks.ago
    return false unless BCrypt::Password.new(self.tokens[client_id]['token']) == token

    return true
  end

  def serializable_hash(options={})
    options ||= {}
    options[:except] ||= [:tokens]
    super(options)
  end
end