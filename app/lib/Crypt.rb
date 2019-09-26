
class Crypt

  def self.decode (data, salt)
    len   = ActiveSupport::MessageEncryptor.key_len
    key = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    crypt.encrypt_and_sign(data)
  end

  def self.encode (data, salt)
    len   = ActiveSupport::MessageEncryptor.key_len
    key = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    crypt.decrypt_and_verify(data)
  end

end