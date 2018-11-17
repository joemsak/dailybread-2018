class V1::JWTAuth
  def self.for(user)
    JWT.encode(
      {
        iss: "leftoverdough.com",
        exp: 10.minutes.from_now.to_i,
        id: user.id,
        email: user.email,
      },
      Rails.application.credentials.secret_key_base,
      'HS256'
    )
  end

  def self.decode(token)
    JWT.decode(
      token,
      Rails.application.credentials.secret_key_base,
      true,
      { algorithm: 'HS256' }
    )
  end
end