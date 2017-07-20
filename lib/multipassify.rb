require 'openssl'
require 'time'
require 'json'
require 'base64'

class Multipassify
  attr_accessor :encryptionKey, :signingKey

  def initialize(secret)
    block_size = 16

    # Use the Multipass secret to derive two cryptographic keys,
    # one for encryption, one for signing
    hash = OpenSSL::Digest::Digest.new("sha256").digest(secret)
    self.encryptionKey = hash[0,block_size]
    self.signingKey = hash[block_size, 32]
  end

  def encode(obj)
    return if !obj

    # Store the current time in ISO8601 format.
    # The token will only be valid for a small timeframe around this timestamp.
    obj["created_at"] = Time.now.iso8601

    # Serialize the customer data to JSON and encrypt it
    cipherText = self.encrypt(obj.to_json)

    # Create a signature (message authentication code) of the ciphertext
    # and encode everything using URL-safe Base64 (RFC 4648)
    Base64.urlsafe_encode64(cipherText + self.sign(cipherText))
  end

  def encrypt(plaintext)
    cipher = OpenSSL::Cipher::Cipher.new("aes-128-cbc")
    cipher.encrypt
    cipher.key = self.encryptionKey

    ### Use a random IV
    cipher.iv = iv = cipher.random_iv

    # Use IV as first block of ciphertext
    iv + cipher.update(plaintext) + cipher.final
  end

  def generate_url(obj, domain)
    return if !domain
    return "https://" + domain + "/account/login/multipass/" + self.encode(obj)
  end

  def sign(data)
    OpenSSL::HMAC.digest("sha256", self.signingKey, data)
  end
end
