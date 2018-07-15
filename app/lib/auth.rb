class Auth
  # Given a user object, encodes a JWT and returns it.
  #
  # @param {User} user
  # @return {String}
  def self.encode(user)
    payload = { id: user.id }
    JWT.encode(payload, auth_secret, algorithm)
  end

  # Given a JWT, decodes it and returns the resulting Hash.
  #
  # @param {String} jwt
  # @return {Hash}
  def self.decode(jwt)
    jwt_decoded = JWT.decode(jwt, auth_secret, true, { algorithm: algorithm })
    jwt_decoded.first # Returning first since the result is an array.
  end

  private_class_method def self.algorithm
    'HS256'
  end

  private_class_method def self.auth_secret
    ENV['AUTH_SECRET']
  end
end
