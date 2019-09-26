class User < ApplicationRecord
  rolify
  has_secure_password
  PASS_REGEX = /\A(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password,  presence: true, format: { with: PASS_REGEX }
  has_many :bank_accounts, class_name: "BankAccount", foreign_key: "user_id"
  before_save :generate_key

  def can_create_users?
    return self.has_any_role? :admin
  end

  def can_update_users?
    return self.has_any_role? :admin
  end

  def can_make_deposit?
    return self.has_any_role? :admin
  end

  def can_make_withdraw?
    return self.has_any_role? :holder
  end

  def can_make_transfer?
    return self.has_any_role? :holder
  end

  def can_look_balance?
    return self.has_any_role? :holder
  end

  def is_holder?
    return self.has_any_role? :holder
  end

  def is_admin?
    return self.has_any_role? :admin
  end

  private
  def generate_key
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.base64(len)
    self.key =  salt  if self.key.nil?
  end



end
